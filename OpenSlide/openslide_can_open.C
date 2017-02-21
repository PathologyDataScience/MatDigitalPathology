#include <openslide.h>
#include "mex.h"

/*Provides access to the OpenSlide function 'openslide_can_open' to test 				*/
/*validity of input file. Returns scalar indicating success.							*/
/*Interface "Result = openslide_can_open();"											*/

/*input:																				*/
/*File - (string) Filename and path of the file to test.								*/

/*output:																				*/
/*Success - (scalar) Flag indicating whether file can be opened (1) or not (0)			*/
/*notes:																				*/
/*compile - mex -L/opt/lib/ -lopenslide -I/opt/include/openslide/ openslide_can_open.C	*/

/*Author: Lee Cooper, Emory University.													*/


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {

	/*variables*/
	char *buffer; /*array for input string*/
	bool result; /*output*/

	/*check input arguments*/
	if(nrhs != 1) {
		mexErrMsgTxt("'openslide_can_open.m' requires one input argument.");
	}
	if(nlhs > 1) {
		mexErrMsgTxt("'openslide_can_open.m' produces one output.");
	}
	
	/*check input type*/
	if(!mxIsChar(prhs[0]) || (mxGetM(prhs[0]) != 1)) {
		mexErrMsgTxt("Input must be character array.");
	}
	
	/*copy*/
	buffer = mxArrayToString(prhs[0]);
	
	/*copy input*/
	result = openslide_can_open(buffer);
	
	/*set output*/
	plhs[0] = mxCreateDoubleScalar((double)result);

	/*free input buffer copy*/
	mxFree(buffer);
}
