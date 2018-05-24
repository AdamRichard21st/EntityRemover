#include < amxmodx >
#include < amxmisc >
#include < fakemeta >

/* Arquivo para armazenar a lista de entidades.
* Nota : Deve estar dentro da pasta configs. */
#define SZ_ENTITY_LIST "cstrike_entity_remover.ini"

/* Máximo de caracteres por linha.
* troque se tiver problemas com a
* leitura das entidades da lista. */
#define MAX_DATA_LEN 48

new Trie:g_tEntities;
new g_iForwardSpawn;

public plugin_precache()
{
	if ( LoadSettings() )
	{
		g_iForwardSpawn = register_forward( FM_Spawn, "Forward_FM_Spawn" );
	}
}

public plugin_init()
{
	register_plugin( "Entity Remover", "0.0.2", "AdamRichard21st" );
	unregister_forward( FM_Spawn, g_iForwardSpawn );
	TrieDestroy( g_tEntities );
}

public Forward_FM_Spawn( iEnt )
{
	static szClassName[ 32 ];

	if ( pev_valid( iEnt ) )
	{
		pev( iEnt, pev_classname, szClassName, charsmax( szClassName ) );

		if ( TrieKeyExists( g_tEntities, szClassName ) )
		{
			engfunc( EngFunc_RemoveEntity, iEnt );
		}
	}
	return FMRES_IGNORED;
}

bool:LoadSettings()
{
	new szFile[ 92 ];
	new fFile;

	get_configsdir( szFile, charsmax( szFile ) );
	formatex( szFile, charsmax( szFile ), "%s/%s", szFile, SZ_ENTITY_LIST );

	if ( !( fFile = fopen( szFile, "r" ) ) )
	{
		set_fail_state( "[EntityRemover] A lista de entidades nao foi encontrada. Plugin interrompido." );
		return false;
	}
	new const SZ_ALLMAPS[] = "TodosMapas";
	new szData	[ MAX_DATA_LEN + 1 ];
	new szMap	[ 32 ];
	new iEnts;
	new bool:bLoad;

	g_tEntities = TrieCreate();
	get_mapname( szMap, charsmax( szMap ) );

	while ( fgets( fFile, szData, MAX_DATA_LEN ) )
	{
		switch ( szData[ 0 ] )
		{
			case '/', '\', '*', ';', '{': continue;
			case '}': bLoad = false;
			default:
			{
				trim( szData );

				if ( bLoad )
				{
					iEnts += TrieSetCell( g_tEntities, szData, 1, false );
				}
				else bLoad = equal( szData, SZ_ALLMAPS ) || equal( szData, szMap );
			}
		}
	}
	fclose( fFile );
	return iEnts > 0;
}