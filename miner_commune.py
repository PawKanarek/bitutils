import commune as c


def print_all_min_stakes():
    for m in c.modules("subspace."): 
        try:
            module = c.module(m)
            print(module.min_stake())
        except Exception:
            print(f"cannot open {m}")
            pass
        
        
print_all_min_stakes()