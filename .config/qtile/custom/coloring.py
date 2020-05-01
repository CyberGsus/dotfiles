import numpy as np

def apply_alpha(color_1, color_2, alpha):
    return np.array(alpha * color_2 + (1 - alpha) * color_1, dtype=color_1.dtype)


def qtile_to_np(color):
    col_int = int(color[1:], 16)
    return np.array([
        (col_int & 0xff0000) >> 16,
        (col_int & 0xff00) >> 8,
        (col_int & 0xff),
    ], dtype=np.uint8)

def np_to_qtile(color):
    col_int = int(color[0] << 16 | color[1] << 8 | color[2])
    return '#' + hex(col_int)[2:]


def apply_alpha_qtile(color_1, color_2, alpha):
    if type(color_1) == str:
        return apply_alpha_qtile([color_1], color_2, alpha)
    elif type(color_2) == str:
        return apply_alpha_qtile(color_1, [color_2], alpha)

    color1_np =  [*map(qtile_to_np, color_1)]
    color2_np =  [*map(qtile_to_np, color_2)]

    color_np_alpha = [*map(lambda x: apply_alpha(x[0], x[1], alpha), zip(
        color1_np, color2_np))]

    return [*map(np_to_qtile, color_np_alpha)]


if __name__ == '__main__':
    col1 = [ '#ffffff', '#ff00ff' ]
    col2 = [ '#000000', '#a0ff00' ]
    print(apply_alpha_qtile(col1, col2, 0.5))
