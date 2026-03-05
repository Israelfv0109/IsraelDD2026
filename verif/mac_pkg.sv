package mac_pkg;
    // Clase Base: Generador Random
    class random_gen;
        rand bit signed [`MAC_DATA_WIDTH-1:0] a, b;
        constraint data_range { 
            a inside {[`MAC_MAX_NEG : `MAC_MAX_POS]}; 
            b inside {[`MAC_MAX_NEG : `MAC_MAX_POS]}; 
        }
    endclass

    // Clase para Corners (Test 4, 5) Distribución Ponderada
    class random_gen_corners extends random_gen;
        constraint c_zeros { 
           a dist {0:=10, `MAC_MAX_POS:=10, `MAC_MAX_NEG:=10,  [1:`MAC_SMALL_POS_LIMIT]:/30, [`MAC_SMALL_NEG_LIMIT:-1]:/30,[`MAC_SMALL_POS_LIMIT+1:`MAC_MAX_POS-1]:/5, [`MAC_MAX_NEG+1:`MAC_SMALL_NEG_LIMIT-1]:/5};
           b dist {0:=10, `MAC_MAX_POS:=10, `MAC_MAX_NEG:=10,  [1:`MAC_SMALL_POS_LIMIT]:/30, [`MAC_SMALL_NEG_LIMIT:-1]:/30,[`MAC_SMALL_POS_LIMIT+1:`MAC_MAX_POS-1]:/5, [`MAC_MAX_NEG+1:`MAC_SMALL_NEG_LIMIT-1]:/5};
	    //el diagonal distribuye en partes iguales
        }
    endclass
endpackage
