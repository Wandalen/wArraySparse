
let _ = require( 'wTools' );

let sparse = [ 3,5, 5,7, 7,7, 11,11, 11,11, 11,11, 15,20 ];
console.log( sparse );
let minimized = _.sparse.minimize( sparse );
console.log( minimized );

/*
expected output :



*/
