( function _ArraySparse_test_s_( ) {

'use strict';

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

  var _ = _global_.wTools;

  _.include( 'wTesting' );

  require( '../layer4/ArraySparse.s' );

}

var _global = _global_;
var _ = _global_.wTools;
var Parent = _.Tester;

// --
// test
// --

function minimize( test )
{

  var src = [ 3,5, 5,7, 7,7, 11,11, 11,11, 11,11, 15,20 ];
  var expected = [ 3,7, 11,11, 15,20 ];
  var got = _.sparse.minimize( src );

  test.identical( got, expected );

}

// --
// define class
// --

var Self =
{

  name : 'Tools/base/layer4/ArraySparse',
  silencing : 1,

  tests :
  {

    minimize : minimize,

  },

};

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self.name );

})();
