From: christophe varoqui <christophe.varoqui@free.fr>
Subject: [mini-ANNOUNCE] multipath-tools-0.4.5-pre4
Date: Fri, 29 Jul 2005 11:28:48 +0200
Message-ID: <1122629328.3569.27.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello,

here is another 0.4.5 development snapshot.

0.4.5-pre3 to pre4 ShortLog :

    [multipath] handle alias changes in config file
    [multipathd] '-d' command line flag does not fork anymore
    [multipathd] add the reconfigure CLI command
    [libmultipath] socket filesystem location moved to /var/run
    [libmultipath] third cut at output column aligning
    [multipathd] fix 2 log issues
    [libchecker] readsector0 compilation warning fix
    [libmultipath] second cut at output column aligning
    [libmultipath] first cut at output column aligning
    [multipathd] fix daemon crash in enable_group() be pp->pgindex is
nul
    [multipath] revoke pp->mpp after loading a "struct path" from the
daemon
    [multipathd] move the shutdown message down in the shutdown sequence
    [checkers] remove trailing '\n' in checker messages
    [libmultipath] condlog() not to enqueue uneeded logs
    [multipathd] Two little issues with unix socket lsnr.
    [libmultipath] no need to msg when multipath can't connect to uxsock
    [multipath and multipathd] remove the path cache file logic
    [multipathd] dead includes yearly clean up in main.c
    [multipathd] remove copy.[ch]
    [libmultipath] add HSV110 to the hwtable
    [multipathd] uevent trigger to not react to "remove map"
    [build] 'find' warning fix
    [multipathd] SIGUSR1 to SIGHUP for alt thread cancelation
    [multipathd] race bugs
    [multipathd] detach threads
    [multipathd] interim support for reaping DM events waiter threads
    [multipathd] remove the private namespace and callout cache logic
    [libmultipath] get_word() to initialize *word to NULL early
    [libmultipath] revert "remove queue_if_no_path for DGC hardware"
    [multipathd] Ed's Friday assorted fixes
    [prioritizers] alua upgrade
    [libmultipath] more explicit dm-prereq() output
    [libmultipath] remove queue_if_no_path for DGC hardware.
    [libchecker] add pstate_snprintf()
    [multipathd] add header white line to the CLI generic help message
    [multipathd] in debug mode, log the pathchecker values for each
check
    [multipath] set an initial value to di_flag in main()
    [libmultipath] possible daemon crash with pp->wwid == 0x0
    [multipath] '-l' to never report checker state
    [multipathd] Debian specific compilation error, pthread related
    [multipathd] memory and threading audit
    [multipathd] don't free unallocated mem in cli.c
    [multipathd] -lreadline needs -lcurses
    [multipathd] merge a more versatile CLI parser
    [multipathd] uxsock patch
    [multipathd] assorted cleanups
    [multipathd] shut a warning down
    [multipath] map flushing to remove layered DM-partitioned too
    [multipath] express the failback delay in seconds
    [multipathd] add "sg $map $pgindex" CLI command
    [multipath] remove dead paths from maps
    [multipath] new '-f' command line flag
    [multipathd] re-enable disabled PG when at least one path is up
    [libmultipath] commit the unix socket lib
    [multipathd] don't check at all if path is orphaned
    [libmultipath] forgot blacklist.c in the previous commit
    [libmultipath] better default blacklist rules
    [multipathd] daemon survives a path add when its map is not
registered
    [multipathd] survive a map removal
    [multipathd] don't historize empty cli commands
    [multipathd] readline support for daemon control shell
    [multipathd] unix socket daemon control interface
    [checkers] new hp_sw checker for StorageWorks hw
    [multipath] get rid of the "best" pg info in output
    [multipath] fix -l and -ll flags with a specified limited scope
    [path_priority] rename prioritizers
    [multipathd] adjust chkconfig values in redhat init script

As usual, doc and download at :
http://christophe.varoqui.free.fr/

Archive mirror at ftp://sources.redhat.com/pub/dm/multipath-tools/
Regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>
