"use strict";

// Find the difference in two arrays and return how much
function vars(a, b) {
    let diff = 0;
    for(let i = 0; i < a.length; i++) {
        if(Math.abs(a[i]-b[i]) != 0) {
            diff = Math.abs(a[i]-b[i]);
        }
    }
    return diff;
}

// Figure the slope out of a function at a point
function slope(f, start, end) {
    let top = f.apply(null, end) - f.apply(null, start);
    let bot = vars(start, end); return top/bot;
}

// Calculate the uncertainty in a function via propogation
function uncertainty(f, vars, unce) {
    let sums = 0;
    for(let i = 0; i < vars.length; i++) {
        let a = vars.slice(0);
        a[i] += 1e-10;
        let slop = slope(f, vars, a);
        let b = slop * unce[i];
        b *= b;
        sums += b;
    }
    return Math.sqrt(sums);
}

// Calculate the uncertainty of the user input data
function calc() {
  if(verifyPUF()){
    // Figure out how many decimal places should be shown in the result
    const SIG_FIG = document.getElementById("sf").value - 1;
    // Get the function from the input box
    let calculation_function = document.getElementById("func").value.split(",");
    calculation_function[calculation_function.length-1] = "return " + calculation_function[calculation_function.length-1] + ";"
    // Make the function
    let f = new Function(...calculation_function);
    // Get the parameters
    let params = document.getElementById("params").value.split(",");
    params = params.map(Number);
    // Get the uncertainties in the parameters
    let unce = document.getElementById("uncert").value.split(",");
    unce = unce.map(Number);
    // Apply the parameters to the function
    let F = f.apply(null, params);
    // Find the propogated uncertainty
    let uncertainty_in_f = uncertainty(f, params, unce);
    // Get the resulting string
    //let res = F.toFixed(SIG_FIG) + "+-" + uncertainty_in_f.toFixed(SIG_FIG);
    //document.getElementById("out").innerHTML = res;

    let t1 = F.toExponential().split("e").map(Number)
    let base = t1[0], exp = t1[1]
    let t2 = uncertainty_in_f.toExponential().split("e").map(Number)
    let base2 = t2[0], exp2 = t2[1]
    document.getElementById("out").innerHTML = "With Significant Figures: ";
    let strOut = "<b>(" + base.toFixed(SIG_FIG) + "&#177;";
    if((base2 * (10**(exp2-exp))).toFixed(SIG_FIG)=="0.00") {
      strOut += "0.01";
    }
    else {
      strOut += (base2 * (10**(exp2-exp))).toFixed(SIG_FIG);
    }
    strOut += ")&#8226;10<sup>" + exp + "</sup></b>";
    document.getElementById("out").innerHTML += strOut;
  }
}

// Returns the length of the function parameters
function getFuncParams() {
  let parts = document.getElementById("func").value.split(",");
  return parts.length - 1;
}


// Update Parameter text each time the text box is updated
function updateParams() {
  let parts = document.getElementById("params").value.split(",");
  document.getElementById("paramVals").innerHTML = parts.join(", ");
  if(parts.length != getFuncParams())
    document.getElementById("paramVals").innerHTML += " -- Too few/many values for given params";
}

// Update Uncertainty parameter text each time the text box is updated
function updateUncert() {
  let parts = document.getElementById("uncert").value.split(",");
  document.getElementById("uncertVals").innerHTML = parts.join(", ");
  if(parts.length != getFuncParams())
    document.getElementById("uncertVals").innerHTML += " -- Too few/many values for given params";
}

// Verify there are the correct number of parameters and uncertainties
//  for the function
function verifyPUF() {
  updateFunc();
  let P = document.getElementById("params").value.split(",").length;
  let U = document.getElementById("uncert").value.split(",").length;
  return getFuncParams() == P && P == U;
}

// Update the function text output every time the input is updated
function updateFunc() {
  let parts = document.getElementById("func").value.split(",");
  let ret = parts.pop();
  document.getElementById("funcVal").innerHTML = "f(" + parts + ") = " + ret;
  updateUncert();
  updateParams();
}
