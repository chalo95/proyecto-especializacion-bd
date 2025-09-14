/*
	FactVenta
	FactFecha
	dimArticulo
*/

/*########################
	DimFecha 
##########################*/
--select 
--* 
--from [warehouse].[dimFecha]


/*########################
	DimArticulo
##########################*/

select 
ART.ARTICULO as articulo_id,
ART.DESCRIPCION as descripcion,
CASE TIPO 
   WHEN 'B' THEN 'Sub-producto'
   WHEN 'C' THEN 'Coproducto'
   WHEN 'D' THEN 'Desecho'
   WHEN 'E' THEN 'Semi-elaborado'
   WHEN 'F' THEN 'Fantasma'
   WHEN 'K' THEN 'Kit'
   WHEN 'L' THEN 'Laboral'
   WHEN 'M' THEN 'Materia Prima' 
   WHEN 'O' THEN 'Otro'
   WHEN 'P' THEN 'Proceso'
   WHEN 'Q' THEN 'Material de Empaque'
   WHEN 'R' THEN 'Refacción'
   WHEN 'S' THEN 'Reproceso'
   WHEN 'T' THEN 'Teminado'
   WHEN 'U' THEN 'Suministro'
   WHEN 'V' THEN 'Servicio'
   ELSE 'No Definido' END as tipo,
CASE ART.origen_corp    
	WHEN 'T' THEN 'Terceros'   
	WHEN 'C' THEN 'Corporativo'   
	ELSE 'No Definido' END origen,
Case ART.ACTIVO 
	when 'S' THEN 'SI'
	ELSE 'NO' END activo,
ISNULL(CLA1.DESCRIPCION,'No Asignado') as Clasificacion1,
ISNULL(CLA2.DESCRIPCION,'No Asignado') as Clasificacion2,
ISNULL(CLA3.DESCRIPCION,'No Asignado') as Clasificacion3,
ISNULL(CLA4.DESCRIPCION,'No Asignado') as Clasificacion4,
ISNULL(CLA5.DESCRIPCION,'No Asignado') as Clasificacion5,
ISNULL(CLA6.DESCRIPCION,'No Asignado') as Clasificacion6,
ISNULL(unidad.DESCRIPCION,'No Asignado') unidad_medida,
ART.peso_neto AS peso_neto,
ART.peso_bruto AS peso_bruto,
ART.volumen AS volumen,
'' as 'costo_local', -- pediente
'' as'tipo_costo_comparativo', --pediente
'' as 'costo_comparativo', --pendiente
ART.EXISTENCIA_MAXIMA,
ART.EXISTENCIA_MINIMA,
ART.PUNTO_DE_REORDEN,
ART.ULTIMA_SALIDA, -- dimfecha
ART.ULTIMO_INGRESO, -- dimfecha
ART.ULTIMO_INVENTARIO-- dimfecha
from 
disprobe.ARTICULO ART left join 
disprobe.CLASIFICACION CLA1 on CLA1.CLASIFICACION = ART.CLASIFICACION_1 left join 
disprobe.CLASIFICACION CLA2 on CLA2.CLASIFICACION = ART.CLASIFICACION_2 left join
disprobe.CLASIFICACION CLA3 on CLA3.CLASIFICACION = ART.CLASIFICACION_3 left join
disprobe.CLASIFICACION CLA4 on CLA4.CLASIFICACION = ART.CLASIFICACION_4 left join
disprobe.CLASIFICACION CLA5 on CLA5.CLASIFICACION = ART.CLASIFICACION_5 left join
disprobe.CLASIFICACION CLA6 on CLA6.CLASIFICACION = ART.CLASIFICACION_6 inner join 
disprobe.unidad_de_medida unidad on unidad.UNIDAD_MEDIDA = ART.UNIDAD_ALMACEN

/*
############################
	FactVenta
############################
*/
--Falta

select top 40
AUDI.AUDIT_TRANS_INV as venta_id,
AJUSTE.DESCRIPCION as tipo_movimiento,
TRANS.CANTIDAD as cantida,
TRANS.PRECIO_TOTAL_LOCAL as precio_local,
TRANS.COSTO_TOT_COMP_LOC as Costo,
EXBOD.EXISTENCIA_MAXIMA as existencia_maxima,
EXBOD.EXISTENCIA_MINIMA as existencia_minima,
EXBOD.CANT_DISPONIBLE as Disponibilidad_bruta
FROM   
 disprobe.transaccion_inv TRANS (NOLOCK)   
 inner join DISPROBE.audit_trans_inv AUDI (NOLOCK)    ON TRANS.audit_trans_inv = AUDI.audit_trans_inv  
 left join disprobe.EXISTENCIA_BODEGA EXBOD on EXBOD.ARTICULO = TRANS.ARTICULO and EXBOD.BODEGA = TRANS.BODEGA
 LEFT JOIN DISPROBE.ajuste_config AJUSTE on TRANS.ajuste_config = AJUSTE.ajuste_config  

 Where 
 AJUSTE.DESCRIPCION = 'Venta' 
 
 


