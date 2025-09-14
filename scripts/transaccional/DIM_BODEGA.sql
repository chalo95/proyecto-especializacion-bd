SELECT
    B.BODEGA AS bodega_id,
    B.NOMBRE AS bodega_nombre,
    B.TIPO AS bodega_tipo,
    B.TELEFONO AS bodega_telefono,
    B.DIRECCION AS bodega_direccion,
    B.CONSEC_TRASLADOS AS consec_traslados,
    B.U_ZONA AS zona,
    B.CreatedBy AS fecha_de_registro,
    B.CreateDate AS fecha_de_creacion,
    B.NoteExistsFlag AS producto_existencia,
    B.CreateDate AS fecha_inicio_vigencia,
    NULL AS fecha_fin_vigencia,
    'SI' AS registro_vigente,
    C.CLIENTE AS codigo_cliente_consigna,
    D.TIPO_DEVOLUCION AS tipo_de_cambio,
    Z.ZONA AS local,
    Z.NOMBRE AS localizacion
FROM
    ExactusERP6.disprobe.BODEGA AS B
LEFT JOIN
    ExactusERP6.disprobe.ZONA AS Z ON B.U_ZONA = Z.ZONA
LEFT JOIN
    ExactusERP6.disprobe.CLIENTE AS C ON Z.ZONA = C.ZONA
LEFT JOIN
    ExactusERP6.disprobe.DEVOLUCION AS D ON B.BODEGA = D.DEVOLUCION;





