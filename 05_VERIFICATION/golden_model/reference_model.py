def model(x, lo, hi):
    if lo > hi:
        return lo, 1
    if x < lo:
        return lo, 0
    if x > hi:
        return hi, 0
    return x, 0


def run():
    directed = [
        (49,50,100,(50,0)),
        (50,50,100,(50,0)),
        (51,50,100,(51,0)),
        (75,50,100,(75,0)),
        (99,50,100,(99,0)),
        (100,50,100,(100,0)),
        (101,50,100,(100,0)),
        (75,100,50,(100,1)),
        (0,0,0,(0,0)),
        (255,255,255,(255,0)),
        (0,0,255,(0,0)),
        (255,0,255,(255,0)),
    ]

    for x,lo,hi,expected in directed:
        assert model(x,lo,hi) == expected

    # Representative complete sample sweeps for valid intervals.
    for lo in range(0,256,17):
        for hi in range(lo,256,19):
            for x in range(256):
                y,e = model(x,lo,hi)
                assert e == 0
                assert lo <= y <= hi

                if x < lo:
                    assert y == lo
                elif x > hi:
                    assert y == hi
                else:
                    assert y == x

    # Representative invalid configurations.
    for lo in range(1,256,13):
        for hi in range(0,lo,11):
            for x in range(0,256,7):
                y,e = model(x,lo,hi)
                assert e == 1
                assert y == lo

    print("C02 reference model PASS")


if __name__ == "__main__":
    run()