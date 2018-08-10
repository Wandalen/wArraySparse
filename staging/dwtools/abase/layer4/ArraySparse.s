( function _ArraySparse_s_() {

'use strict';

/**
  @module Tools/base/ArraySparse - Collection of routines to operate effectively sparse array. A sparse array is an vector of intervals which split number space into two subsets, internal and external. ArraySparse leverage iterating, inverting, minimizing and other operations on a sparse array. Use the module to increase memory efficiency of your algorithms.
*/

/**
 * @file ArraySparse.s
 */

if( typeof module !== 'undefined' )
{

  if( typeof _global_ === 'undefined' || !_global_.wBase )
  {
    let toolsPath = '../../../dwtools/Base.s';
    let toolsExternal = 0;
    try
    {
      toolsPath = require.resolve( toolsPath );
    }
    catch( err )
    {
      toolsExternal = 1;
      require( 'wTools' );
    }
    if( !toolsExternal )
    require( toolsPath );
  }

}

//

let Self = _global_.wTools.sparse = _global_.wTools.sparse || Object.create( null );
let _global = _global_;
let _ = _global_.wTools;

let _ArraySlice = Array.prototype.slice;
let _FunctionBind = Function.prototype.bind;
let _ObjectToString = Object.prototype.toString;
let _ObjectHasOwnProperty = Object.hasOwnProperty;

let _arraySlice = _.longSlice;

// --
// sparse
// --

function is( sparse )
{
  _.assert( arguments.length === 1 );

  if( !_.longIs( sparse ) )
  return false;

  if( sparse.length % 2 !== 0 )
  return false;

  return true;
}

//

function eachElement( sparse,onEach )
{

  _.assert( arguments.length === 2 );
  _.assert( _.sparse.is( sparse ) );

  let index = 0;
  for( let s = 0, sl = sparse.length / 2 ; s < sl ; s++ )
  {
    let range = [ sparse[ s*2 + 0 ],sparse[ s*2 + 1 ] ];
    for( let key = range[ 0 ], kl = range[ 1 ] ; key < kl ; key++ )
    {
      onEach.call( this,key,index,range,1 );
      index += 1;
    }
  }

}

//

function eachElementEvenOutside( sparse,length,onEach )
{

  _.assert( arguments.length === 3 );
  _.assert( _.sparse.is( sparse ) );
  _.assert( _.numberIs( length ) );
  _.assert( _.routineIs( onEach ) );

  let index = 0;
  let was = 0;
  for( let s = 0, sl = sparse.length / 2 ; s < sl ; s++ )
  {
    let range = [ sparse[ s*2 + 0 ],sparse[ s*2 + 1 ] ];

    for( let key = was ; key < range[ 0 ] ; key++ )
    {
      onEach.call( this,key,index,range,0 );
      index += 1;
    }

    for( let key = range[ 0 ], kl = range[ 1 ] ; key < kl ; key++ )
    {
      onEach.call( this,key,index,range,1 );
      index += 1;
    }

    was = range[ 1 ];
  }

  for( let key = was ; key < length ; key++ )
  {
    onEach.call( this,key,index,range,0 );
    index += 1;
  }

}

//

function elementsTotal( sparse )
{
  let result = 0;

  _.assert( arguments.length === 1 );
  _.assert( _.sparse.is( sparse ) );

  for( let s = 0, sl = sparse.length / 2 ; s < sl ; s++ )
  {
    let range = [ sparse[ s*2 + 0 ],sparse[ s*2 + 1 ] ];
    result += range[ 1 ] - range[ 0 ];
  }

  return result;
}

//

function minimize( sparse )
{

  _.assert( arguments.length === 1 );
  _.assert( _.sparse.is( sparse ) )

  if( sparse.length === 0 )
  {
    debugger;
    return _.entityMakeOfLength( sparse, 0 );
  }

  let l = 1;
  let acc = 0;

  for( let i = 2 ; i < sparse.length ; i += 2 )
  {

    let e1 = sparse[ i-1 ];
    let b2 = sparse[ i+0 ];

    if( e1 !== b2 )
    {
      acc = 0;
      l += 2;
    }
    else
    {
      acc += 1;
    }

  }

  if( acc > 0 )
  l += 2;

  let result = _.entityMakeOfLength( sparse, l*2 );

  result[ 0 ] = sparse[ 0 ];
  result[ 1 ] = sparse[ 1 ];

  let b = sparse[ 0 ];
  let e = sparse[ 1 ];
  let c = 0;
  acc = 0;

  /* */

  for( let i = 2 ; i < sparse.length ; i += 2 )
  {

    let e1 = sparse[ i-1 ];
    let b2 = sparse[ i+0 ];

    if( e1 !== b2 )
    {
      result[ c+0 ] = b;
      result[ c+1 ] = e;
      b = sparse[ i+0 ];
      e = sparse[ i+1 ];
      c += 2;
      acc = 0;
    }
    else
    {
      e = sparse[ i+1 ];
      acc += 1;
    }

  }

  /* */

  if( acc > 0 )
  {
    result[ c+0 ] = b;
    result[ c+1 ] = e;
  }

  _.assert( c === l );

  return result;
}

// --
// define class
// --

let Proto =
{

  // sparse

  is : is,

  eachElement : eachElement,
  eachElementEvenOutside : eachElementEvenOutside,
  elementsTotal : elementsTotal,

  minimize : minimize,

}

_.mapExtend( Self, Proto );

// --
// export
// --

if( typeof module !== 'undefined' )
if( _global_.WTOOLS_PRIVATE )
delete require.cache[ module.id ];

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
