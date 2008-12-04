From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Announce: unlimited number of shared snapshots
Date: Wed, 3 Dec 2008 22:27:35 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0812032136220.14109@hs20-bc2-1.build.redhat.com>
References: <492FAF1C.8080401@gluesys.com>
	<Pine.LNX.4.64.0811281449520.6900@hs20-bc2-1.build.redhat.com>
	<4933684F.9060606@gluesys.com>
	<Pine.LNX.4.64.0812020140540.28552@hs20-bc2-1.build.redhat.com>
	<4936187D.1000302@gluesys.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4936187D.1000302@gluesys.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: hgichon <kpkim@gluesys.com>
Cc: dm-devel@redhat.com, Klaus Kim <kgh@gluesys.com>, nst@gluesys.com
List-Id: dm-devel.ids

On Wed, 3 Dec 2008, hgichon wrote:

> ok, i found norecovery option for mouting XFS.
> 
> I make a some script for testing shared snapshots. It's simple.
> - create multisnap target
> - mkfs.xfs target / mount
> - loop ( cp /etc /target/$cnt... ; create multisnap-snap target ID $cnt; $cnt
> increased )
> 
> I want to see
> - snapshot creation time?
> - preserved snapshot image exactly?
> 
> I created more than 90 snapshot target, however there is no snapshot creation
> delay. WOW
> In checking the preserved snapshot images, but there is some problem.
> 
> 1. When snapshot number is more than 97,  Input/Output errors occurred in
> original volume.
> - In that time, snapshot overflow occurred maybe.
> 
> I attached my simple script and result.

This is definitely caused by snapshot overflow. See this:

ms: 0 4194304 multisnapshot 28 103 524288 524281 46399
                                   ^^^^^^^^^^^^^

It's the total and allocated number of chunks. Currently, it behaves in 
such a way that it prevents writing to the origin, I may add more error 
handling modes in the future.

> 2. With below df dump,  copy data was updated abnormally.

What exactly do you mean? Technically, you can get filesystem 
inconsistency in the snapshot if you take snapshot of a mounted 
filesystem. You should suspend the origin device with "dmsetup suspend" 
and resume with "dmsetup resume" it after taking the snapshot. Be aware to 
suspend only for brief period of time on unloaded system, as there is a 
deadlock possibility when running with suspended filesystem. xfs and ext3 
will clean-up themselves when suspending. For ext2, there's no way to get 
a clean snapshot, it's ext2 design limitation, even on old snapshots you 
get inconsistent snapshots when snapshotting mounted ext2 filesystem.

Mikulas

> best regards.
> 
> # df
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/sdb1             5.0G  646M  4.1G  14% /
> /dev/sdb2             5.0G  244M  4.5G   6% /var
> none                  292M  120K  292M   1% /dev/shm
> /dev/mapper/ms        2.0G  1.5G  595M  71% /mnt/ms
> /dev/mapper/ms0       2.0G  4.2M  2.0G   1% /mnt/ms0
> /dev/mapper/ms1       2.0G  4.2M  2.0G   1% /mnt/ms1
> /dev/mapper/ms2       2.0G   20M  2.0G   1% /mnt/ms2
> /dev/mapper/ms3       2.0G   20M  2.0G   1% /mnt/ms3
> /dev/mapper/ms4       2.0G   20M  2.0G   1% /mnt/ms4
> /dev/mapper/ms5       2.0G   20M  2.0G   1% /mnt/ms5
> /dev/mapper/ms6       2.0G   82M  2.0G   5% /mnt/ms6
> /dev/mapper/ms7       2.0G  4.2M  2.0G   1% /mnt/ms7
> /dev/mapper/ms8       2.0G  4.2M  2.0G   1% /mnt/ms8
> /dev/mapper/ms9       2.0G  4.2M  2.0G   1% /mnt/ms9
> /dev/mapper/ms10      2.0G   38M  2.0G   2% /mnt/ms10
> /dev/mapper/ms11      2.0G   38M  2.0G   2% /mnt/ms11
> /dev/mapper/ms12      2.0G   38M  2.0G   2% /mnt/ms12
> /dev/mapper/ms13      2.0G   89M  2.0G   5% /mnt/ms13
> /dev/mapper/ms14      2.0G   89M  2.0G   5% /mnt/ms14
> /dev/mapper/ms15      2.0G   89M  2.0G   5% /mnt/ms15
> /dev/mapper/ms16      2.0G   89M  2.0G   5% /mnt/ms16
> /dev/mapper/ms17      2.0G  138M  1.9G   7% /mnt/ms17
> /dev/mapper/ms18      2.0G  138M  1.9G   7% /mnt/ms18
> /dev/mapper/ms19      2.0G  138M  1.9G   7% /mnt/ms19
> /dev/mapper/ms20      2.0G  138M  1.9G   7% /mnt/ms20
> /dev/mapper/ms21      2.0G  211M  1.8G  11% /mnt/ms21
> /dev/mapper/ms22      2.0G  211M  1.8G  11% /mnt/ms22
> /dev/mapper/ms23      2.0G  211M  1.8G  11% /mnt/ms23
> /dev/mapper/ms24      2.0G  211M  1.8G  11% /mnt/ms24
> /dev/mapper/ms25      2.0G  211M  1.8G  11% /mnt/ms25
> /dev/mapper/ms26      2.0G  270M  1.8G  14% /mnt/ms26
> /dev/mapper/ms27      2.0G  270M  1.8G  14% /mnt/ms27
> /dev/mapper/ms28      2.0G  270M  1.8G  14% /mnt/ms28
> /dev/mapper/ms29      2.0G  270M  1.8G  14% /mnt/ms29
> /dev/mapper/ms30      2.0G  334M  1.7G  17% /mnt/ms30
> /dev/mapper/ms31      2.0G  334M  1.7G  17% /mnt/ms31
> /dev/mapper/ms32      2.0G  334M  1.7G  17% /mnt/ms32
> /dev/mapper/ms33      2.0G  389M  1.7G  20% /mnt/ms33
> /dev/mapper/ms34      2.0G  389M  1.7G  20% /mnt/ms34
> /dev/mapper/ms35      2.0G  389M  1.7G  20% /mnt/ms35
> /dev/mapper/ms36      2.0G  389M  1.7G  20% /mnt/ms36
> /dev/mapper/ms37      2.0G  437M  1.6G  22% /mnt/ms37
> /dev/mapper/ms38      2.0G  437M  1.6G  22% /mnt/ms38
> /dev/mapper/ms39      2.0G  437M  1.6G  22% /mnt/ms39
> /dev/mapper/ms40      2.0G  437M  1.6G  22% /mnt/ms40
> /dev/mapper/ms41      2.0G  494M  1.6G  25% /mnt/ms41
> /dev/mapper/ms42      2.0G  494M  1.6G  25% /mnt/ms42
> /dev/mapper/ms43      2.0G  494M  1.6G  25% /mnt/ms43
> /dev/mapper/ms44      2.0G  547M  1.5G  27% /mnt/ms44
> /dev/mapper/ms45      2.0G  547M  1.5G  27% /mnt/ms45
> /dev/mapper/ms46      2.0G  547M  1.5G  27% /mnt/ms46
> /dev/mapper/ms47      2.0G  596M  1.5G  30% /mnt/ms47
> /dev/mapper/ms48      2.0G  596M  1.5G  30% /mnt/ms48
> /dev/mapper/ms49      2.0G  596M  1.5G  30% /mnt/ms49
> /dev/mapper/ms50      2.0G  596M  1.5G  30% /mnt/ms50
> /dev/mapper/ms51      2.0G  644M  1.4G  32% /mnt/ms51
> /dev/mapper/ms52      2.0G  644M  1.4G  32% /mnt/ms52
> /dev/mapper/ms53      2.0G  644M  1.4G  32% /mnt/ms53
> /dev/mapper/ms54      2.0G  644M  1.4G  32% /mnt/ms54
> /dev/mapper/ms55      2.0G  698M  1.4G  35% /mnt/ms55
> /dev/mapper/ms56      2.0G  698M  1.4G  35% /mnt/ms56
> /dev/mapper/ms57      2.0G  698M  1.4G  35% /mnt/ms57
> /dev/mapper/ms58      2.0G  753M  1.3G  37% /mnt/ms58
> /dev/mapper/ms59      2.0G  753M  1.3G  37% /mnt/ms59
> /dev/mapper/ms60      2.0G  753M  1.3G  37% /mnt/ms60
> /dev/mapper/ms61      2.0G  804M  1.3G  40% /mnt/ms61
> /dev/mapper/ms62      2.0G  804M  1.3G  40% /mnt/ms62
> /dev/mapper/ms63      2.0G  804M  1.3G  40% /mnt/ms63
> /dev/mapper/ms64      2.0G  850M  1.2G  42% /mnt/ms64
> /dev/mapper/ms65      2.0G  850M  1.2G  42% /mnt/ms65
> /dev/mapper/ms66      2.0G  850M  1.2G  42% /mnt/ms66
> /dev/mapper/ms67      2.0G  887M  1.2G  44% /mnt/ms67
> /dev/mapper/ms68      2.0G  887M  1.2G  44% /mnt/ms68
> /dev/mapper/ms69      2.0G  887M  1.2G  44% /mnt/ms69
> /dev/mapper/ms70      2.0G  939M  1.1G  47% /mnt/ms70
> /dev/mapper/ms71      2.0G  939M  1.1G  47% /mnt/ms71
> /dev/mapper/ms72      2.0G  939M  1.1G  47% /mnt/ms72
> /dev/mapper/ms73      2.0G  983M  1.1G  49% /mnt/ms73
> /dev/mapper/ms74      2.0G  983M  1.1G  49% /mnt/ms74
> /dev/mapper/ms75      2.0G  983M  1.1G  49% /mnt/ms75
> /dev/mapper/ms76      2.0G  1.0G 1015M  51% /mnt/ms76
> /dev/mapper/ms77      2.0G  1.0G 1015M  51% /mnt/ms77
> /dev/mapper/ms78      2.0G  1.0G 1015M  51% /mnt/ms78
> /dev/mapper/ms79      2.0G  1.1G  970M  53% /mnt/ms79
> /dev/mapper/ms80      2.0G  1.1G  970M  53% /mnt/ms80
> /dev/mapper/ms81      2.0G  1.1G  970M  53% /mnt/ms81
> /dev/mapper/ms82      2.0G  1.1G  933M  55% /mnt/ms82
> /dev/mapper/ms83      2.0G  1.1G  933M  55% /mnt/ms83
> /dev/mapper/ms84      2.0G  1.1G  933M  55% /mnt/ms84
> /dev/mapper/ms85      2.0G  1.2G  890M  57% /mnt/ms85
> /dev/mapper/ms86      2.0G  1.2G  890M  57% /mnt/ms86
> /dev/mapper/ms87      2.0G  1.2G  890M  57% /mnt/ms87
> /dev/mapper/ms88      2.0G  1.2G  846M  59% /mnt/ms88
> /dev/mapper/ms89      2.0G  1.2G  846M  59% /mnt/ms89
> /dev/mapper/ms90      2.0G  1.2G  846M  59% /mnt/ms90
> /dev/mapper/ms91      2.0G  1.3G  809M  61% /mnt/ms91
> /dev/mapper/ms92      2.0G  1.3G  809M  61% /mnt/ms92
> /dev/mapper/ms93      2.0G  1.3G  763M  63% /mnt/ms93
> /dev/mapper/ms94      2.0G  1.3G  763M  63% /mnt/ms94
> /dev/mapper/ms95      2.0G  1.3G  763M  63% /mnt/ms95
> /dev/mapper/ms96      2.0G  1.3G  730M  65% /mnt/ms96
> 
> #dmsetup status
> ms28: 0 4194304 multisnap-snap
> ms13: 0 4194304 multisnap-snap
> ms45: 0 4194304 multisnap-snap
> ms30: 0 4194304 multisnap-snap
> ms77: 0 4194304 multisnap-snap
> ms62: 0 4194304 multisnap-snap
> ms94: 0 4194304 multisnap-snap
> ms3: 0 4194304 multisnap-snap
> ms27: 0 4194304 multisnap-snap
> ms12: 0 4194304 multisnap-snap
> ms59: 0 4194304 multisnap-snap
> ms44: 0 4194304 multisnap-snap
> ms76: 0 4194304 multisnap-snap
> ms61: 0 4194304 multisnap-snap
> ms93: 0 4194304 multisnap-snap
> ms2: 0 4194304 multisnap-snap
> ms26: 0 4194304 multisnap-snap
> ms11: 0 4194304 multisnap-snap
> ms58: 0 4194304 multisnap-snap
> ms43: 0 4194304 multisnap-snap
> ms75: 0 4194304 multisnap-snap
> ms60: 0 4194304 multisnap-snap
> ms92: 0 4194304 multisnap-snap
> ms1: 0 4194304 multisnap-snap
> LD-snap: 0 4194304 linear
> ms25: 0 4194304 multisnap-snap
> ms10: 0 4194304 multisnap-snap
> ms57: 0 4194304 multisnap-snap
> ms42: 0 4194304 multisnap-snap
> ms89: 0 4194304 multisnap-snap
> ms74: 0 4194304 multisnap-snap
> ms91: 0 4194304 multisnap-snap
> ms0: 0 4194304 multisnap-snap
> ms39: 0 4194304 multisnap-snap abnormally.
> ms24: 0 4194304 multisnap-snap
> ms56: 0 4194304 multisnap-snap
> ms41: 0 4194304 multisnap-snap
> ms88: 0 4194304 multisnap-snap
> ms73: 0 4194304 multisnap-snap
> ms90: 0 4194304 multisnap-snap
> LD-ori: 0 4194304 linear
> ms38: 0 4194304 multisnap-snap
> ms23: 0 4194304 multisnap-snap
> ms55: 0 4194304 multisnap-snap
> ms40: 0 4194304 multisnap-snap
> ms87: 0 4194304 multisnap-snap
> ms72: 0 4194304 multisnap-snap
> ms37: 0 4194304 multisnap-snap
> ms22: 0 4194304 multisnap-snap
> ms69: 0 4194304 multisnap-snap
> ms54: 0 4194304 multisnap-snap
> ms86: 0 4194304 multisnap-snap
> ms71: 0 4194304 multisnap-snap
> ms19: 0 4194304 multisnap-snap
> ms36: 0 4194304 multisnap-snap
> ms21: 0 4194304 multisnap-snap
> ms68: 0 4194304 multisnap-snap
> ms53: 0 4194304 multisnap-snap
> ms85: 0 4194304 multisnap-snap
> ms70: 0 4194304 multisnap-snap
> ms9: 0 4194304 multisnap-snap
> ms: 0 4194304 multisnapshot 28 103 524288 524281 46399 104 0 1 2 3 4 5 6 7 8 9
> 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
> 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61
> 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87
> 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103
> ms18: 0 4194304 multisnap-snap
> ms35: 0 4194304 multisnap-snap
> ms20: 0 4194304 multisnap-snap
> ms67: 0 4194304 multisnap-snap
> ms52: 0 4194304 multisnap-snap
> ms99: 0 4194304 multisnap-snap
> ms84: 0 4194304 multisnap-snap
> ms8: 0 4194304 multisnap-snap
> ms17: 0 4194304 multisnap-snap
> ms49: 0 4194304 multisnap-snap
> ms34: 0 4194304 multisnap-snap
> ms66: 0 4194304 multisnap-snap
> ms51: 0 4194304 multisnap-snap
> ms98: 0 4194304 multisnap-snap
> ms83: 0 4194304 multisnap-snap
> ms7: 0 4194304 multisnap-snap
> ms16: 0 4194304 multisnap-snap
> ms48: 0 4194304 multisnap-snap
> ms33: 0 4194304 multisnap-snap
> ms65: 0 4194304 multisnap-snap
> ms50: 0 4194304 multisnap-snap
> ms97: 0 4194304 multisnap-snap
> ms82: 0 4194304 multisnap-snap
> ms6: 0 4194304 multisnap-snap
> ms15: 0 4194304 multisnap-snap
> ms47: 0 4194304 multisnap-snap
> ms32: 0 4194304 multisnap-snap
> ms79: 0 4194304 multisnap-snap
> ms64: 0 4194304 multisnap-snap
> ms96: 0 4194304 multisnap-snap
> ms81: 0 4194304 multisnap-snap
> ms5: 0 4194304 multisnap-snap
> ms29: 0 4194304 multisnap-snap
> ms14: 0 4194304 multisnap-snap
> ms46: 0 4194304 multisnap-snap
> ms31: 0 4194304 multisnap-snap
> ms78: 0 4194304 multisnap-snap
> ms63: 0 4194304 multisnap-snap
> ms95: 0 4194304 multisnap-snap
> ms80: 0 4194304 multisnap-snap
> ms4: 0 4194304 multisnap-snap
> 
> #cat multisnap.sh
> #!/bin/sh
> help ()
> {
>    echo "$0 CMD OPT"
>    echo "CMD = INIT | SNAP"
>    echo "OPT = ORI_PATH, SNAP_PATH, CHUNK_SIZE, NAME | ORI_PATH, NAME,
> SNAP_NUM"
> }
> 
> [ $# -lt 2 ] && help && exit
> 
> CMD=$1
> 
> if [ $CMD = INIT ]; then
>    ORI=$2
>    SNAP=$3
>    CHUNK=$4
>    NAME=$5
> 
>    dd if=/dev/zero of=$SNAP bs=$CHUNK count=1
>    sync
>    echo 0 `blockdev --getsize $ORI` multisnapshot $ORI $SNAP $CHUNK|dmsetup
> create $NAME
>    mkfs.xfs -f /dev/mapper/$NAME
>    mkdir -p /mnt/$NAME
>    mount /dev/mapper/$NAME /mnt/$NAME
> 
> elif [ $CMD = SNAP ]; then
>    ORI=$2
>    NAME=$3
>    CNT=$4
>    SNAME=$NAME$CNT
> 
>    dmsetup message /dev/mapper/$NAME $CNT create
>    echo 0 `blockdev --getsize $ORI` multisnap-snap $ORI $CNT |dmsetup create
> $SNAME
>    mkdir -p /mnt/$SNAME
>    mount -o nouuid,ro,norecovery /dev/mapper/$SNAME /mnt/$SNAME
> else
>    help
> fi
> 
> #cat snap_c.sh
> #!/bin/sh
> CNT=0
> 
> while [ $CNT != 100 ]
> do
>    cp -a /etc /mnt/ms/etc$CNT
>    ./multisnap.sh SNAP /dev/mapper/LD-ori ms $CNT
>    CNT=$[ $CNT + 1 ]
>    echo "`date` $CNT created"
> done
> 
> #sh snap_c.sh
> Wed Nov 26 21:57:38 KST 2008 1 created
> Wed Nov 26 21:57:38 KST 2008 2 created
> Wed Nov 26 21:57:40 KST 2008 3 created
> Wed Nov 26 21:57:43 KST 2008 4 created
> Wed Nov 26 21:57:44 KST 2008 5 created
> Wed Nov 26 21:57:45 KST 2008 6 created
> Wed Nov 26 21:57:47 KST 2008 7 created
> Wed Nov 26 21:57:48 KST 2008 8 created
> Wed Nov 26 21:57:50 KST 2008 9 created
> Wed Nov 26 21:57:51 KST 2008 10 created
> Wed Nov 26 21:57:52 KST 2008 11 created
> Wed Nov 26 21:57:54 KST 2008 12 created
> Wed Nov 26 21:57:55 KST 2008 13 created
> Wed Nov 26 21:57:55 KST 2008 14 created
> Wed Nov 26 21:57:57 KST 2008 15 created
> Wed Nov 26 21:57:58 KST 2008 16 created
> Wed Nov 26 21:58:00 KST 2008 17 created
> Wed Nov 26 21:58:01 KST 2008 18 created
> Wed Nov 26 21:58:01 KST 2008 19 created
> Wed Nov 26 21:58:03 KST 2008 20 created
> Wed Nov 26 21:58:04 KST 2008 21 created
> Wed Nov 26 21:58:05 KST 2008 22 created
> Wed Nov 26 21:58:06 KST 2008 23 created
> Wed Nov 26 21:58:08 KST 2008 24 created
> Wed Nov 26 21:58:10 KST 2008 25 created
> Wed Nov 26 21:58:10 KST 2008 26 created
> Wed Nov 26 21:58:13 KST 2008 27 created
> Wed Nov 26 21:58:13 KST 2008 28 created
> Wed Nov 26 21:58:15 KST 2008 29 created
> Wed Nov 26 21:58:17 KST 2008 30 created
> Wed Nov 26 21:58:18 KST 2008 31 created
> Wed Nov 26 21:58:19 KST 2008 32 created
> Wed Nov 26 21:58:21 KST 2008 33 created
> Wed Nov 26 21:58:22 KST 2008 34 created
> Wed Nov 26 21:58:23 KST 2008 35 created
> Wed Nov 26 21:58:25 KST 2008 36 created
> Wed Nov 26 21:58:26 KST 2008 37 created
> Wed Nov 26 21:58:28 KST 2008 38 created
> Wed Nov 26 21:58:30 KST 2008 39 created
> Wed Nov 26 21:58:31 KST 2008 40 created
> Wed Nov 26 21:58:33 KST 2008 41 created
> Wed Nov 26 21:58:34 KST 2008 42 created
> Wed Nov 26 21:58:36 KST 2008 43 created
> Wed Nov 26 21:58:37 KST 2008 44 created
> Wed Nov 26 21:58:38 KST 2008 45 created
> Wed Nov 26 21:58:40 KST 2008 46 created
> Wed Nov 26 21:58:42 KST 2008 47 created
> Wed Nov 26 21:58:42 KST 2008 48 created
> Wed Nov 26 21:58:44 KST 2008 49 created
> Wed Nov 26 21:58:45 KST 2008 50 created
> Wed Nov 26 21:58:47 KST 2008 51 created
> Wed Nov 26 21:58:48 KST 2008 52 created
> Wed Nov 26 21:58:50 KST 2008 53 created
> Wed Nov 26 21:58:51 KST 2008 54 created
> Wed Nov 26 21:58:54 KST 2008 55 created
> Wed Nov 26 21:58:54 KST 2008 56 created
> Wed Nov 26 21:58:57 KST 2008 57 created
> Wed Nov 26 21:58:58 KST 2008 58 created
> Wed Nov 26 21:58:59 KST 2008 59 created
> Wed Nov 26 21:59:02 KST 2008 60 created
> Wed Nov 26 21:59:04 KST 2008 61 created
> Wed Nov 26 21:59:05 KST 2008 62 created
> Wed Nov 26 21:59:07 KST 2008 63 created
> Wed Nov 26 21:59:09 KST 2008 64 created
> Wed Nov 26 21:59:10 KST 2008 65 created
> Wed Nov 26 21:59:12 KST 2008 66 created
> Wed Nov 26 21:59:14 KST 2008 67 created
> Wed Nov 26 21:59:15 KST 2008 68 created
> Wed Nov 26 21:59:17 KST 2008 69 created
> Wed Nov 26 21:59:19 KST 2008 70 created
> Wed Nov 26 21:59:22 KST 2008 71 created
> Wed Nov 26 21:59:23 KST 2008 72 created
> Wed Nov 26 21:59:25 KST 2008 73 created
> Wed Nov 26 21:59:26 KST 2008 74 created
> Wed Nov 26 21:59:28 KST 2008 75 created
> Wed Nov 26 21:59:30 KST 2008 76 created
> Wed Nov 26 21:59:32 KST 2008 77 created
> Wed Nov 26 21:59:34 KST 2008 78 created
> Wed Nov 26 21:59:36 KST 2008 79 created
> Wed Nov 26 21:59:37 KST 2008 80 created
> Wed Nov 26 21:59:40 KST 2008 81 created
> Wed Nov 26 21:59:42 KST 2008 82 created
> Wed Nov 26 21:59:43 KST 2008 83 created
> Wed Nov 26 21:59:46 KST 2008 84 created
> Wed Nov 26 21:59:48 KST 2008 85 created
> Wed Nov 26 21:59:49 KST 2008 86 created
> Wed Nov 26 21:59:51 KST 2008 87 created
> Wed Nov 26 21:59:52 KST 2008 88 created
> Wed Nov 26 21:59:55 KST 2008 89 created
> Wed Nov 26 21:59:57 KST 2008 90 created
> Wed Nov 26 21:59:58 KST 2008 91 created
> Wed Nov 26 22:00:01 KST 2008 92 created
> Wed Nov 26 22:00:04 KST 2008 93 created
> Wed Nov 26 22:00:04 KST 2008 94 created
> Wed Nov 26 22:00:07 KST 2008 95 created
> Wed Nov 26 22:00:09 KST 2008 96 created
> Wed Nov 26 22:00:10 KST 2008 97 created
> cp: cannot create directory `/mnt/ms/etc97/doc': Input/output error
> cp: cannot create directory `/mnt/ms/etc97/cron.weekly': Input/output error
> cp: cannot create directory `/mnt/ms/etc97/snmp': Input/output error
> cp: cannot create directory `/mnt/ms/etc97/logrotate.d': Input/output error
> cp: cannot create regular file `/mnt/ms/etc97/pwdb.conf': Input/output error
> cp: cannot create regular file `/mnt/ms/etc97/rsyncd.conf': Input/output error
> <...snip...>
> cp: cannot create regular file `/mnt/ms/etc97/passwd': Input/output error
> cp: cannot create symbolic link `/mnt/ms/etc97/my.cnf': Input/output error
> cp: cannot create directory `/mnt/ms/etc97/ssl': Input/output error
> cp: cannot create regular file `/mnt/ms/etc97/ftpusers': Input/output error
> cp: cannot create regular file `/mnt/ms/etc97/mtab': Input/output error
> cp: cannot create directory `/mnt/ms/etc97/security': Input/output error
> cp: cannot create regular file `/mnt/ms/etc97/slp.reg': Input/output error
> cp: cannot create regular file `/mnt/ms/etc97/group-': Input/output error
> cp: cannot create regular file `/mnt/ms/etc97/blkid.tab': Input/output error
> cp: cannot create regular file `/mnt/ms/etc97/.pwd.lock': Input/output error
> cp: cannot create regular file `/mnt/ms/etc97/blkid.tab.old': Input/output
> error
> cp: cannot create regular file `/mnt/ms/etc97/passwd.bak': Input/output error
> cp: preserving times for `/mnt/ms/etc97': Input/output error
> device-mapper: message ioctl failed: No space left on device
> Command failed
> mount: you must specify the filesystem type
> Wed Nov 26 22:00:11 KST 2008 98 created
> cp: accessing `/mnt/ms/etc98': Input/output error
> device-mapper: message ioctl failed: No space left on device
> Command failed
> mount: you must specify the filesystem type
> Wed Nov 26 22:00:11 KST 2008 99 created
> cp: accessing `/mnt/ms/etc99': Input/output error
> device-mapper: message ioctl failed: No space left on device
> Command failed
> mount: you must specify the filesystem type
> Wed Nov 26 22:00:11 KST 2008 100 created
> 
> 
> Mikulas Patocka wrote:
> > Hi
> > 
> > I fixed the ext2 bug (it was unsupported handling of buffer readahead) ---
> > download the new version of patches from the same location.
> > 
> > I couldn't reproduce the XFS bug. Please retry. Are you sure that you didn't
> > try to mount the _snapshot_ as XFS? Snapshots are currently not writeable
> > (they will be writeable in the final version), so attempting to mount the
> > snapshot read/write would return i/o error to the filesystem and produce an
> > error message similar to the one displayed.
> > 
> > Thanks for testing it.
> > 
> > Mikulas
> >   
