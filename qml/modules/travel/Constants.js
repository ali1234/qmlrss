var line_colours ={
    'bakerloo': ['#ffffff', '#996633'],
    'central': ['#ffffff', '#cc3333'],
    'circle': ['#000000', '#ffcc00'],
    'district': ['#ffffff', '#006633'],
    'hammersmith-city': ['#000000', '#cc9999'],
    'jubilee': ['#ffffff', '#868f98'],
    'metropolitan': ['#ffffff', '#660066'],
    'northern': ['#ffffff', '#000000'],
    'piccadilly': ['#ffffff', '#0019a8'],
    'victoria': ['#000000', '#0099cc'],
    'waterloo-city': ['#000000', '#66cccc'],
}

var mode_colours = {
    'bus': ['#ffffff', '#cc3333'],
    'dlr': ['#000000', '#009999'],
    'tram': ['#ffffff', '#66cc00'],
    'overground': ['#000000', '#e86a10'],
    'tflrail': ['#ffffff', '#0019a8'],
}

function get_colours(id, mode) {
    if (mode == "tube") {
        return line_colours[id];
    } else {
        return mode_colours[mode];
    }
}