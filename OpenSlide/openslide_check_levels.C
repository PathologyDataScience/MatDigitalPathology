#include <openslide.h>
#include "mex.h"

/*Provides access to the objective and levels/magnification data of a whole-slide image.*/
/*validity of input file. Returns scalar indicating success.							*/
/*Interface "[Dims, Factors, Objective, MppX, MppY] = openslide_check_levels(File);"	*/

/*input:																				*/
/*File - (string) Filename and path of the file to test.								*/

/*output:																				*/
/*Dims - (K x 2 float) Dimensions of each level in image pyramid in slide. Height in	*/
/*		 first column, width in 2nd.													*/
/*Factors - (K x 1) Downsampling factor for each level.									*/
/*Objective - (string) Objective magnification at base layer.							*/
/*MppX - (string) Microns-per-pixel in horizontal dimension.							*/
/*MppY - (string) Microns-per-pixel in vertical dimension.								*/

/*notes:																				*/
/*compile - mex -L/opt/lib/ -lopenslide -I/opt/include/openslide/ openslide_check_levels.C	*/

/*Author: Lee Cooper, Emory University.													*/


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {

	/*variables*/
	char *buffer; /*array for input string*/
	int32_t levels; /*number of levels*/
	int64_t w, h; /*width, height of each level*/
	double *dims, *ds; /*pointers to outputs - for convenience*/
	const char *objective, *mppx, *mppy;
	openslide_t *slide; /*openslide struct*/
	int i; /*loop iterator*/
	
	/*check input arguments*/
	if(nrhs != 1) {
		mexErrMsgTxt("'openslide_check_levels.m' requires one input argument.");
	}
	if(nlhs > 5) {
		mexErrMsgTxt("'openslide_check_levels.m' produces two outputs.");
	}
	
	/*check input type*/
	if(!mxIsChar(prhs[0]) || (mxGetM(prhs[0]) != 1)) {
		mexErrMsgTxt("Input must be character array.");
	}
	
	/*copy*/
	buffer = mxArrayToString(prhs[0]);
	
	/*copy input*/
	if(openslide_can_open(buffer) == 1) {
			
		/*open*/	
		slide = openslide_open(buffer);

		/*check for error*/
		if(openslide_get_error(slide) != NULL) {
			mexErrMsgTxt("'openslide_check_levels.m' cannot open slide.");
		}
		else {
			
			/*get # of levels*/
			levels = openslide_get_layer_count(slide);
			
			/*allocate arrays*/
			plhs[0] = mxCreateDoubleMatrix((mwSize)levels, 2, mxREAL);
			plhs[1] = mxCreateDoubleMatrix((mwSize)levels, 1, mxREAL);
			
			/*get output addresses*/
			dims = mxGetPr(plhs[0]);
			ds = mxGetPr(plhs[1]);
			
			/*loop through levels, get dimensions/downsample factor of each*/
			for(i = 0; i < levels; i++) {
			
				/*get level info*/
				openslide_get_layer_dimensions(slide, (int32_t)i, &w, &h);
				*ds = openslide_get_layer_downsample(slide, (int32_t)i);
				ds = ds + 1;
				
				/*copy dimensions to outputs*/
				*dims = (double)h;
				*(dims+levels) = (double)w;
				dims = dims + 1;
				
			}

			/*get properties*/
			objective = openslide_get_property_value(slide, OPENSLIDE_PROPERTY_NAME_OBJECTIVE_POWER);
			mppx = openslide_get_property_value(slide, OPENSLIDE_PROPERTY_NAME_MPP_X);
			mppy = openslide_get_property_value(slide, OPENSLIDE_PROPERTY_NAME_MPP_Y);
			
			/*assign properties to outputs*/
			plhs[2] = mxCreateString(objective);
			plhs[3] = mxCreateString(mppx);
			plhs[4] = mxCreateString(mppy);
			
		}
	}
	else{ /*can't open slide*/
		mexErrMsgTxt("'openslide_check_levels.m' cannot open slide.");
	}
	
	/*free input buffer copy*/
	mxFree(buffer);
	
}
