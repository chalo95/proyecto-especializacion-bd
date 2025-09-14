select 
	ati.AUDIT_TRANS_INV as consumo_id,
	ti.CONSECUTIVO as detalle_id,
	ti.ARTICULO as articulo_id,
	eb.BODEGA as bodega_id,
	ISNULL(ti.LOTE, 'No especificado') as lote_id,
	ti.FECHA_HORA_TRANSAC as fecha_hora_transaccion,
	CASE
		WHEN ti.AJUSTE_CONFIG = '~CC~' THEN 'Consumo'
		ELSE 'NO APLICA'
	END as tipo_movimiento,
	ti.CANTIDAD,
	ti.COSTO_TOT_COMP_LOC as precio_unitario,
	(ti.CANTIDAD * ti.COSTO_TOT_COMP_LOC) as costo,
	eb.EXISTENCIA_MAXIMA,
	eb.EXISTENCIA_MINIMA,
	eb.CANT_DISPONIBLE,
	(eb.CANT_DISPONIBLE - ti.CANTIDAD) as cantidad_disponible_neta,
	((eb.CANT_DISPONIBLE - ti.CANTIDAD) * ti.COSTO_TOT_COMP_LOC) as valor_inventario_neto,
	((eb.EXISTENCIA_MAXIMA + eb.EXISTENCIA_MINIMA) / 2) as punto_medio_inv
from disprobe.transaccion_inv ti 
	join disprobe.ajuste_config ac ON ac.AJUSTE_CONFIG = ti.AJUSTE_CONFIG
	join disprobe.audit_trans_inv ati ON ati.AUDIT_TRANS_INV = ti.AUDIT_TRANS_INV
	join disprobe.existencia_bodega eb ON ti.BODEGA = eb.BODEGA
	join disprobe.articulo a ON ti.ARTICULO = a.ARTICULO
WHERE ti.AJUSTE_CONFIG = '~CC~';