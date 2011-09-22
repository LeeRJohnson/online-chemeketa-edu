/*  -----------------------------------------------------------

COL UI - Version 0.3 (Development)

Update: 20090328

Authors: Lee R Johnson - ljohns10@chemeketa.edu

Created specifically for http://online.chemeketa.edu to 
add parsing, importing, etc. utilites.

Requires jQuery 1.3

-----------------------------------------------------------  */

var colUtil = {

    /**
    * Parses the the CCC fiscal year Term Id from 
    * @param {int} tid  The Learning Server Term Id or CCC Term Id.
    * @returns A string representing the full Term Id 
    */
    toTermCode: function(tid) {
        return colUtil.toTermYear(tid) + parseInt(tid % 4.25 + 1) * 10;
    },
    /**
    * Parses the the Term label from...
    * @param {int} tid  The Learning Server Term Id or CCC Term Id.
    * @returns A string representing the term label 
    */
    toTermLabel: function(tid) {
        switch (parseInt(tid % 4.25 + 1)) {
            case 1: return 'summer'; break; ;
            case 2: return 'fall'; break;
            case 3: return 'winter'; break;
            case 4: return 'spring'; break;
        }
    },
    /**
    * Parses the the CCC fiscal year from
    * @param {int} tid  The Learning Server Term Id or CCC Term Id.
    * @returns A string representing a year YYYY.
    */
    toTermYear: function(tid) {
    return (tid < 1990)
            ? parseInt(tid / 4 + 1989.75).toString()//1989.75 = 198940 
            : tid.substr(0, 3);//Just the YEAR
    },
    /**
    * Find the next or prev index number:
    * @param {int} from The starting index
    * @param {int} by   A positive for next or negative for prev
    * @param {int} of   a number of items
    * @returns a int indicating the next index
    */
    loopToIndex: function(from, by, of) {
        var i = from + by;
        i = (i > from)
		                ? (i % of)//make zero next after last
		                : ((i < 0) ? i + of : i); //takes negitive out of end
        return i;
    }

}

	
    
    $.shuffleArr = function(arr) {
        for (
            var j, x, i = arr.length; i;
            j = parseInt(Math.random() * i),
            x = arr[--i], arr[i] = arr[j], arr[j] = x
        );
        return arr;
    }
    
    $.fn.stripHtml = function() {
        var regexp = /<("[^"]*"|'[^']*'|[^'">])*>/gi;
        this.each(function() {
            $(this).html(
                $(this).html().replace(regexp,"")
            );
        });
        return $(this);
    }