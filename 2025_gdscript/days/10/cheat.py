#!/usr/bin/python3
# Comes from https://github.com/jonathanpaulson/AdventOfCode/blob/master/2025/10.py
# I can't figure this out in GDScript since everybody and their hamsters are using Z3

import sys
import z3

D = sys.stdin.read()
p2 = 0

print("start")
remaining = 177
for line in D.splitlines():
    remaining -= 1
    words = line.split()
    buttons = words[1:-1]
    B = []
    NS = []
    for button in buttons:
        ns = [int(x) for x in button[1:-1].split(',')]
        button_n = sum(2**x for x in ns)
        B.append(button_n)
        NS.append(ns)

    # solve Ax = B
    # where A = effect of each button
    # x = how many times we press each button
    # B = goal state
    # minimize(sum(X))
    joltage = words[-1]
    joltage_ns = [int(x) for x in joltage[1:-1].split(',')]
    V = []
    for i in range(len(buttons)):
        V.append(z3.Int(f'B{i}'))
    EQ = []
    for i in range(len(joltage_ns)):
        terms = []
        for j in range(len(buttons)):
            if i in NS[j]:
                terms.append(V[j])
        eq = (sum(terms) == joltage_ns[i])
        EQ.append(eq)
    o = z3.Optimize()
    o.minimize(sum(V))
    for eq in EQ:
        o.add(eq)
    for v in V:
        o.add(v >= 0)
    assert o.check()
    M = o.model()
    total = 0
    for d in M.decls():
        p2 += M[d].as_long()
        total += M[d].as_long()

    print("remaining: ", remaining, "/177 - answer: ", total)

print(p2)
