#!/data/inkling/venv/bin/python
# quality benchmark for XeInkling: GSM8K (few-shot, greedy), MMLU (5-shot, letter), small code suite (executed unit tests).
# usage: evalq.py <label> [suite ...]   (env of the engine configuration is inherited; results appended to /data/inkling/evalq/results.jsonl)
import sys, os, re, json, random, subprocess, tempfile
import pandas as pd
D = "/data/inkling/evalq"; BIN = "/data/inkling/target_exp22/release/xi-run"; RUN = "/data/inkling/runexp22.sh"; MODEL = "/data/inkling/model"
label = sys.argv[1]; suites = sys.argv[2:] or ["gsm8k", "mmlu", "code"]
def esc(s): return s.replace("\\", "\\\\").replace("\n", "\\n")
def run_batch(name, prompts, n):
    f = f"{D}/{name}.prompts"; open(f, "w").write("\n".join(esc(p) for p in prompts) + "\n")
    out = subprocess.run([RUN, BIN, MODEL, "x", str(n), "--batch", f], capture_output=True, text=True, timeout=7200).stdout
    res = {}
    for m in re.finditer(r"=====BEGIN (\d+)\n(.*?)\n=====END", out, re.S): res[int(m.group(1))] = m.group(2)
    return [res.get(i, "") for i in range(len(prompts))]
results = {}
rng = random.Random(1234)
if "gsm8k" in suites:
    g = pd.read_parquet("/data/inkling2mini/eval/data/gsm8k.parquet")
    idx = rng.sample(range(len(g)), 64); shots = idx[:4]; test = idx[4:]
    def clean(a): return re.sub(r"<<.*?>>", "", a)
    pre = "".join(f"Question: {g.question[i]}\nAnswer: {clean(g.answer[i])}\n\n" for i in shots)
    prompts = [pre + f"Question: {g.question[i]}\nAnswer:" for i in test]
    outs = run_batch("gsm8k", prompts, 170); ok = 0
    for i, o in zip(test, outs):
        gold = g.answer[i].split("####")[-1].strip().replace(",", "")
        m = re.search(r"####\s*\$?(-?[\d,\.]+)", o); pred = m.group(1).replace(",", "").rstrip(".") if m else ""
        try: ok += abs(float(pred) - float(gold)) < 1e-6
        except Exception: pass
    results["gsm8k"] = dict(acc=ok / len(test), n=len(test))
if "mmlu" in suites:
    m_ = pd.read_parquet("/data/inkling2mini/eval/data/mmlu.parquet")
    idx = rng.sample(range(len(m_)), 120); prompts = []; gold = []
    def fmt(r, ans=True): return r.question + "\n" + "\n".join(f"{'ABCD'[k]}. {c}" for k, c in enumerate(list(r.choices))) + "\nAnswer:" + (f" {'ABCD'[r.answer]}\n\n" if ans else "")
    for i in idx:
        r = m_.iloc[i]; same = m_[m_.subject == r.subject]; pool = [j for j in same.index if j != i]; sh = rng.sample(pool, 5)
        prompts.append("".join(fmt(m_.iloc[j]) for j in sh) + fmt(r, False)); gold.append("ABCD"[r.answer])
    outs = run_batch("mmlu", prompts, 3); ok = 0
    for o, gl in zip(outs, gold):
        mm = re.search(r"[ABCD]", o); ok += bool(mm) and mm.group(0) == gl
    results["mmlu"] = dict(acc=ok / len(gold), n=len(gold))
if "code" in suites:
    T = [
     ("def is_palindrome(s):\n    \"\"\"Return True if the string s reads the same forwards and backwards, ignoring case and non-alphanumeric characters.\"\"\"\n", "assert is_palindrome('A man, a plan, a canal: Panama') and not is_palindrome('hello') and is_palindrome('')"),
     ("def gcd(a, b):\n    \"\"\"Return the greatest common divisor of the positive integers a and b.\"\"\"\n", "assert gcd(12, 18) == 6 and gcd(17, 5) == 1 and gcd(100, 10) == 10"),
     ("def fizzbuzz(n):\n    \"\"\"Return a list of strings for 1..n: 'Fizz' for multiples of 3, 'Buzz' for multiples of 5, 'FizzBuzz' for both, otherwise the number as a string.\"\"\"\n", "assert fizzbuzz(15)[-1] == 'FizzBuzz' and fizzbuzz(5) == ['1','2','Fizz','4','Buzz']"),
     ("def flatten(lst):\n    \"\"\"Flatten an arbitrarily nested list of integers into a single flat list.\"\"\"\n", "assert flatten([1,[2,[3,4]],5]) == [1,2,3,4,5] and flatten([]) == []"),
     ("def count_vowels(s):\n    \"\"\"Return the number of vowels (a, e, i, o, u, case-insensitive) in s.\"\"\"\n", "assert count_vowels('Hello World') == 3 and count_vowels('xyz') == 0"),
     ("def primes_up_to(n):\n    \"\"\"Return the list of all prime numbers <= n in increasing order.\"\"\"\n", "assert primes_up_to(20) == [2,3,5,7,11,13,17,19] and primes_up_to(1) == []"),
     ("def fib(n):\n    \"\"\"Return the n-th Fibonacci number with fib(0) = 0 and fib(1) = 1.\"\"\"\n", "assert fib(10) == 55 and fib(0) == 0 and fib(1) == 1"),
     ("def merge_sorted(a, b):\n    \"\"\"Merge two sorted lists into one sorted list.\"\"\"\n", "assert merge_sorted([1,3,5],[2,4,6]) == [1,2,3,4,5,6] and merge_sorted([],[1]) == [1]"),
     ("def valid_parentheses(s):\n    \"\"\"Return True if the brackets ()[]{} in s are balanced and properly nested.\"\"\"\n", "assert valid_parentheses('([]{})') and not valid_parentheses('(]') and not valid_parentheses('(()')"),
     ("def two_sum(nums, target):\n    \"\"\"Return a pair of indices (i, j) with i < j such that nums[i] + nums[j] == target.\"\"\"\n", "r = two_sum([2,7,11,15], 9); assert tuple(sorted(r)) == (0,1)"),
     ("def roman_to_int(s):\n    \"\"\"Convert a Roman numeral string to an integer.\"\"\"\n", "assert roman_to_int('MCMXCIV') == 1994 and roman_to_int('IX') == 9"),
     ("def rle(s):\n    \"\"\"Run-length encode s, e.g. 'aaabcc' -> 'a3b1c2'.\"\"\"\n", "assert rle('aaabcc') == 'a3b1c2' and rle('') == ''"),
     ("def transpose(m):\n    \"\"\"Return the transpose of a rectangular matrix given as a list of rows.\"\"\"\n", "assert transpose([[1,2,3],[4,5,6]]) == [[1,4],[2,5],[3,6]]"),
     ("def is_anagram(a, b):\n    \"\"\"Return True if a and b are anagrams of each other, ignoring case and spaces.\"\"\"\n", "assert is_anagram('Listen','Silent') and not is_anagram('abc','abd')"),
     ("def max_subarray(nums):\n    \"\"\"Return the maximum sum of a non-empty contiguous subarray of nums.\"\"\"\n", "assert max_subarray([-2,1,-3,4,-1,2,1,-5,4]) == 6 and max_subarray([-3,-1]) == -1"),
     ("def binary_search(a, x):\n    \"\"\"Return the index of x in the sorted list a, or -1 if x is not present.\"\"\"\n", "assert binary_search([1,3,5,7,9], 7) == 3 and binary_search([1,3], 2) == -1"),
    ]
    prompts = ["# Python 3\n" + h for h, _ in T]
    outs = run_batch("code", prompts, 160); ok = 0
    for (h, t), o in zip(T, outs):
        body = o
        cut = re.search(r"\n(?=\S)", body)   # stop at the first line that is not indented (end of the function)
        if cut: body = body[:cut.start()]
        src = h + body + "\n\n" + t + "\n"
        with tempfile.NamedTemporaryFile("w", suffix=".py", delete=False) as f: f.write(src); fn = f.name
        try: ok += subprocess.run(["python3", fn], capture_output=True, timeout=10).returncode == 0
        except Exception: pass
        os.unlink(fn)
    results["code"] = dict(pass_rate=ok / len(T), n=len(T))
rec = dict(label=label, env={k: v for k, v in os.environ.items() if k.startswith("XIK_")}, **results)
open(f"{D}/results.jsonl", "a").write(json.dumps(rec) + "\n")
print(json.dumps(rec))
