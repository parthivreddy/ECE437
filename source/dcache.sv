`include "cpu_types_pkg.vh"
`include "caches_if.vh"
`include "datapath_cache_if.vh"

module dcache(
    input logic CLK, nRST,
    datapath_cache_if.dcache dcif,
    caches_if.dcache cif
);

    import cpu_types_pkg::*;

    d_cache_frame [7:0] dcache_set_0;
    d_cache_frame [7:0] dcache_set_1;

    d_cache_frame [7:0] next_dcache_set_0;
    d_cache_frame [7:0] next_dcache_set_1;

    logic [7:0] least_recent_set;

    dcachef_t addr;

    

endmodule