def equilateral(sides):
    if len(sides) != 3:
        raise ValueError("A triangle must have three sides")
    if sides[0] <= 0 or sides[1] <= 0 or sides[2] <= 0:
        return False
    if sides[0] + sides[1] <= sides[2] or sides[0] + sides[2] <= sides[1] or sides[1] + sides[2] <= sides[0]:
        return False
    return sides[0] == sides[1] == sides[2]


def isosceles(sides):
    if len(sides) != 3:
        raise ValueError("A triangle must have three sides")
    if sides[0] <= 0 or sides[1] <= 0 or sides[2] <= 0:
        return False
    if sides[0] + sides[1] <= sides[2] or sides[0] + sides[2] <= sides[1] or sides[1] + sides[2] <= sides[0]:
        return False
    return sides[0] == sides[1] or sides[1] == sides[2] or sides[0] == sides[2]


def scalene(sides):
    if len(sides) != 3:
        raise ValueError("A triangle must have three sides")
    if sides[0] <= 0 or sides[1] <= 0 or sides[2] <= 0:
        return False
    if sides[0] + sides[1] <= sides[2] or sides[0] + sides[2] <= sides[1] or sides[1] + sides[2] <= sides[0]:
        return False
    return sides[0] != sides[1] and sides[1] != sides[2] and sides[0] != sides[2]
