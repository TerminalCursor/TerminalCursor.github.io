let EXTRA_REPULSE_FORCE = 7.5;
let currentNode = undefined;
let moveTarg = false;
var canvas = document.getElementById('webGLCanvas');
canvas.width  = window.innerWidth - 16;
canvas.height = window.innerHeight - (canvas.offsetTop + 16 + 20);
var ctx = canvas.getContext('2d');
ctx.clearRect(0, 0, canvas.width, canvas.height);
//ctx.font = '30px Arial';
//ctx.fillText("Test", 0, 30);

let adjacency_matrix = [
    [0,1,0,0,0,0,0,1],
    [1,0,1,0,0,0,1,0],
    [0,1,0,1,0,0,0,0],
    [0,0,1,0,1,0,0,0],
    [0,0,0,1,0,1,0,0],
    [0,0,0,0,1,0,1,0],
    [0,1,0,0,0,1,0,1],
    [1,0,0,0,0,0,1,0]
];

let pos_matrix = [
    [1,1,1],
    [2,1,1],
    [3,1,1],
    [4,1,1],
    [4,2,1],
    [3,2,1],
    [2,2,1],
    [1,2,1]
];
/*
let pos_matrix = [
    [1,1,1],
    [2,1,1],
    [3,1,1],
    [4,1,1],
    [5,1,1],
    [6,1,1],
    [7,1,1],
    [8,1,1]
];
*/

let vel_matrix = [
    [0,0,0],
    [0,0,0],
    [0,0,0],
    [0,0,0],
    [0,0,0],
    [0,0,0],
    [0,0,0],
    [0,0,0]
];

let getLine = function(edge) {
    let line = [];
    line.push([edge.nodes[0].pos[0], edge.nodes[0].pos[1]]);
    line.push([edge.nodes[1].pos[0], edge.nodes[1].pos[1]]);
    return line;
}

class Node {
    constructor(pos, vel, id) {
        this.pos = pos;
        this.vel = vel;
        this.color = 'blue';
        this.id = -1;
        if(id != undefined) {
            this.id = id;
        }
    }
}

class Edge {
    constructor() {
        this.nodes = arguments;
        this.relaxed = 50;
        this.k = 10;
    }

    setParams(relaxed, k) {
        if(relaxed != undefined) {
            this.relaxed = relaxed;
        }
        if(k != undefined) {
            this.k = k;
        }
    }

    length() {
        let line = getLine(this);
        let length = Math.sqrt(Math.pow(line[1][0] - line[0][0], 2) + Math.pow(line[1][1] - line[0][1], 2));
        return length;
    }

    r() {
        let r = [];
        for(let i = 0; i < this.nodes[0].pos.length;i++) {
            r.push(this.nodes[1].pos[i] - this.nodes[0].pos[i]);
        }
        return r;
    }

    rHat() {
        let rhat = this.r();
        for(let i = 0; i < rhat.length; i++) {
            rhat[i] /= this.length();
        }
        return rhat;
    }

    forceArrowN1() {
        let rhat = this.rHat();
        let forceMag = this.k * (this.length() - this.relaxed);
        let forceArrow = [];
        for(let i = 0; i < rhat.length; i++) {
            forceArrow.push(rhat[i] * forceMag);
        }
        return forceArrow;
    }
    forceArrowN2() {
        let rhat = this.rHat();
        let forceMag = this.k * (this.length() - this.relaxed);
        let forceArrow = [];
        for(let i = 0; i < rhat.length; i++) {
            forceArrow.push(-rhat[i] * forceMag);
        }
        return forceArrow;
    }
}

class GEdge {
    constructor() {
        this.nodes = arguments;
        this.relaxed = 30;
        this.k = 2;
    }

    setParams(relaxed, k) {
        if(relaxed != undefined) {
            this.relaxed = relaxed;
        }
        if(k != undefined) {
            this.k = k;
        }
    }

    length() {
        let line = getLine(this);
        let length = Math.sqrt(Math.pow(line[1][0] - line[0][0], 2) + Math.pow(line[1][1] - line[0][1], 2));
        return length;
    }

    r() {
        let r = [];
        for(let i = 0; i < this.nodes[0].pos.length;i++) {
            r.push(this.nodes[1].pos[i] - this.nodes[0].pos[i]);
        }
        return r;
    }

    rHat() {
        let rhat = this.r();
        for(let i = 0; i < rhat.length; i++) {
            rhat[i] /= this.length();
        }
        return rhat;
    }

    doForce() {
        return (this.length() - this.relaxed) < 0;
    }

    forceArrowN1() {
        if(this.doForce()) {
            let rhat = this.rHat();
            let forceMag = this.k * (this.length() - this.relaxed - EXTRA_REPULSE_FORCE);
            let forceArrow = [];
            for(let i = 0; i < rhat.length; i++) {
                forceArrow.push(rhat[i] * forceMag);
            }
            return forceArrow;
        } else {
            return [0, 0, 0];
        }
        return [0, 0, 0];
    }
    forceArrowN2() {
        if(this.doForce()) {
            let rhat = this.rHat();
            let forceMag = this.k * (this.length() - this.relaxed - EXTRA_REPULSE_FORCE);
            let forceArrow = [];
            for(let i = 0; i < rhat.length; i++) {
                forceArrow.push(-rhat[i] * forceMag);
            }
            return forceArrow;
        } else {
            return [0, 0, 0];
        }
        return [0, 0, 0];
    }
}

let drawDot = function(ctx, pos, color) {
    ctx.beginPath();
    ctx.arc(pos[0], pos[1], 10, 0, 2 * Math.PI, false);
    ctx.fillStyle = color;
    ctx.fill();
    ctx.linewidth = 3;
    ctx.strokeStyle = color;
    ctx.stroke();

}

let drawLine = function(ctx, ends) {
    ctx.beginPath();
    ctx.strokeStyle = '#030';
    ctx.moveTo(ends[0][0], ends[0][1]);
    ctx.lineTo(ends[1][0], ends[1][1]);
    ctx.stroke();
}

let nodes = [];
let edges = [];
let gedges = [];
let importNEG = function() {
    nodes = [];
    edges = [];
    gedges = [];
    /* Nodes */
    for(let subn = 0; subn < pos_matrix.length; subn++) {
        let pos = pos_matrix[subn];
        let vel = vel_matrix[subn];
        nodes.push(new Node([pos[0] * 100, pos[1] * 100, pos[2] * 100], vel, subn));
    }
    /* Edges */
    for(let i = 0; i < adjacency_matrix.length; i++) {
        for(let j = 0; j < adjacency_matrix[0].length; j++) {
            if(adjacency_matrix[i][j] == 1 && i > j) {
                edges.push(new Edge(nodes[i], nodes[j]));
            }
        }
    }
    /* Invisible Repulsive Springs 'GEdges' */
    for(let i = 0; i < adjacency_matrix.length; i++) {
        for(let j = 0; j < adjacency_matrix[0].length; j++) {
            if(i != j) {
                gedges.push(new GEdge(nodes[i], nodes[j]));
            }
        }
    }
}
importNEG();

let TIMESTEP = 10;
let MAX = 300;
let DT = 0.05;
let FRICTION = 0.8;
let MOVE = true;
let t = 0;
let moveTimer = setInterval(() => {
    t += DT;
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    for(let noden = 0; noden < nodes.length; noden++) {
        let node = nodes[noden];
        drawDot(ctx, node.pos, node.color);
    }
    for(let edgen = 0; edgen < edges.length; edgen++) {
        let edge = edges[edgen];
        drawLine(ctx, getLine(edge));
    }
    if(MOVE) {
        for(let gedgen = 0; gedgen < gedges.length; gedgen++) {
            let gedge = gedges[gedgen];
            if(gedge.doForce()) {
                gedge.nodes[0].color = 'orange';
                gedge.nodes[1].color = 'orange';
                for(let i = 0; i < gedge.forceArrowN1().length; i++) {
                    gedge.nodes[0].vel[i] += gedge.forceArrowN1()[i] * DT;
                    gedge.nodes[1].vel[i] += gedge.forceArrowN2()[i] * DT;
                    gedge.nodes[0].pos[i] += gedge.nodes[0].vel[i] * DT;
                    gedge.nodes[1].pos[i] += gedge.nodes[1].vel[i] * DT;
                }
            }
            else if(gedge.nodes[0].color == 'orange' && gedge.nodes[1].color == 'orange') {
                gedge.nodes[0].color = 'blue';
                gedge.nodes[1].color = 'blue';
            }
        }
        for(let edgen = 0; edgen < edges.length; edgen++) {
            let edge = edges[edgen];
            for(let i = 0; i < edge.forceArrowN1().length; i++) {
                edge.nodes[0].vel[i] += edge.forceArrowN1()[i] * DT;
                edge.nodes[0].vel[i] *= FRICTION;
                edge.nodes[1].vel[i] += edge.forceArrowN2()[i] * DT;
                edge.nodes[1].vel[i] *= FRICTION;
                edge.nodes[0].pos[i] += edge.nodes[0].vel[i] * DT + (Math.random() / 1000 / t); /* Random factor breaks the particles off a straight line */
                edge.nodes[1].pos[i] += edge.nodes[1].vel[i] * DT + (Math.random() / 1000 / t);
            }
        }
    }
    if(currentNode != undefined && lastMouseX != undefined && lastMouseY != undefined) {
        currentNode.pos[0] = lastMouseX;
        currentNode.pos[1] = lastMouseY;
    }
    ctx.fillStyle = 'black';
    ctx.strokeStyle = 'black';
    ctx.font = '30px Arial';
    ctx.fillText("Demo Version", 0, 30);
}, TIMESTEP);
/*
setTimeout(() => {
    clearInterval(moveTimer);
    console.log("Finished");
}, MAX*TIMESTEP);
*/

let lastMouseX = null;
let lastMouseY = null;

canvas.onmousedown = function(event) {
    console.log(event);
    for(let noden = 0; noden < nodes.length; noden++) {
        let node = nodes[noden];
        let dist = 0;
        let evtX = event.clientX - canvas.offsetLeft;
        let evtY = event.clientY - canvas.offsetTop;
        lastMouseX = evtX;
        lastMouseY = evtY;
        dist += (evtX - node.pos[0]) * (evtX - node.pos[0]);
        dist += (evtY - node.pos[1]) * (evtY - node.pos[1]);
        if(Math.sqrt(dist) <= 13) {
            currentNode = node;
        }
    }
    let evtX = event.clientX - canvas.offsetLeft;
    canvas.onmousemove = function(event) {
        console.log(event);
        let evtX = event.clientX - canvas.offsetLeft;
        let evtY = event.clientY - canvas.offsetTop;
        lastMouseX = evtX;
        lastMouseY = evtY;
        if(currentNode != undefined) {
            currentNode.pos[0] = evtX;
            currentNode.pos[1] = evtY;
        }
    }
}


canvas.onmouseup = function(event) {
    console.log(event);
    currentNode = undefined;
    canvas.onmousemove = null;
    lastMouseX = null;
    lastMouseY = null;
}

document.onkeydown = function(event) {
    console.log(event);
    if(event.key == "p") {
        MOVE = !MOVE;
    }
    else if(event.key == "r") {
        importNEG();
    }
}
