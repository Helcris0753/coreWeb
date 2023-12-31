USE [Web]
GO
/****** Object:  Table [dbo].[paginas]    Script Date: 09/07/2023 07:43:15 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[paginas](
	[webId] [int] IDENTITY(1,1) NOT NULL,
	[url] [nvarchar](200) NOT NULL,
	[titulo] [nvarchar](100) NULL,
	[descripcion] [nvarchar](255) NULL,
	[prioridad] [int] NOT NULL,
 CONSTRAINT [PK_paginas] PRIMARY KEY CLUSTERED 
(
	[webId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[consultasWeb]    Script Date: 09/07/2023 07:43:15 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[consultasWeb]
	@consulta nvarchar(200),
	@numPagina int
AS
BEGIN
	select
	(select url, titulo, descripcion from paginas
	where url like CONCAT('%', @consulta, '%') or soundex(url) like SOUNDEX(@consulta)
	or titulo like CONCAT('%', @consulta, '%') or soundex(titulo) like SOUNDEX(@consulta)
	or descripcion like CONCAT('%', @consulta, '%')
	order by prioridad, url, titulo
	OFFSET (@numPagina-1)*10 rows 
	fetch next 10 rows only
	for json auto
	),
	(
	select count(webId) from paginas
	where url like CONCAT('%', @consulta, '%') or soundex(url) like SOUNDEX(@consulta)
	or titulo like CONCAT('%', @consulta, '%') or soundex(titulo) like SOUNDEX(@consulta)
	or descripcion like CONCAT('%', @consulta, '%')
	)
END
GO
