From: Gianluca Cecchi <gianluca.cecchi@gmail.com>
Subject: netapp and removed lun sometimes breaks multipath
Date: Thu, 7 Mar 2013 08:42:32 +0100
Message-ID: <CAG2kNCw6p8sagkTBW4jgd5Wh_P6Ft1PGe71nAk+vwqr6WYDJCw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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
sometimes I get this kind of problem when using snapdrive from netapp
to disconnect and delete luns that are on multipath.
Sometimes means that the process runs every night and it happens once
every 20 days
From a snapdrive point of view the snapshot luns were disconnected and
then deleted and the command apparently completes, but from an
operating system view the multipath layer is corrupted and I have to
poweroff the system to solve

$ sudo /sbin/multipath -l
360a9800037543544465d424130543773 dm-10 ,
[size=30G][features=3 queue_if_no_path pg_init_retries 50][hwhandler=1 alua][rw]
\_ round-robin 0 [prio=0][enabled]
 \_ #:#:#:# -   #:#   [failed][undef]

Every command using LVM results now blocked

I can see that the problematic commands run by snapdrive are these ones:

# ps -ef|grep 16140
root     16140     1  0 01:26 ?        00:00:00 /bin/bash -c
/sbin/mpath_wait /dev/mapper/360a9800037543544465d424130543773;
/sbin/kpartx -a -p p /dev/mapper/360a9800037543544465d424130543773
root     16148 16140  0 01:26 ?        00:00:00 /sbin/kpartx -a -p p
/dev/mapper/360a9800037543544465d424130543773

I have these two commands about 40 times every 3 minutes because
probably this is a sort of logic of snapdrive to retry.
Even if I don't know why from a command point of view it considers the
command completed

In mesages
Mar  7 01:26:59 noracs3 multipathd: 66:0: mark as failed
Mar  7 01:26:59 noracs3 kernel: ata2: EH complete
Mar  7 01:26:59 noracs3 kernel: device-mapper: multipath: Could not
failover the device: Handler scsi_dh_alua Error 15.
Mar  7 01:26:59 noracs3 kernel: device-mapper: multipath: Failing path 66:0.
Mar  7 01:30:22 noracs3 kernel: INFO: task kpartx:16148 blocked for
more than 120 seconds.
Mar  7 01:30:22 noracs3 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar  7 01:30:22 noracs3 kernel: kpartx        D ffffffff80157cde     0
16148  16140                     (NOTLB)
Mar  7 01:30:22 noracs3 kernel:  ffff8102d2b73bc8 0000000000000082
0000000000000001 ffffffff800e6b26
Mar  7 01:30:22 noracs3 kernel:  ffff81012755ad30 0000000000000002
ffff81016d0ef080 ffff81033fead7a0
Mar  7 01:30:22 noracs3 kernel:  0006d3269771a874 000000000000223b
ffff81016d0ef268 0000000f00000003
Mar  7 01:30:22 noracs3 kernel: Call Trace:
Mar  7 01:30:22 noracs3 kernel:  [<ffffffff800e6b26>]
block_read_full_page+0x252/0x26f
Mar  7 01:30:22 noracs3 kernel:  [<ffffffff8006ed48>] do_gettimeofday+0x40/0x90
Mar  7 01:30:22 noracs3 kernel:  [<ffffffff80029173>] sync_page+0x0/0x43
Mar  7 01:30:22 noracs3 kernel:  [<ffffffff800637de>] io_schedule+0x3f/0x67
Mar  7 01:30:22 noracs3 kernel:  [<ffffffff800291b1>] sync_page+0x3e/0x43
Mar  7 01:30:22 noracs3 kernel:  [<ffffffff80063922>]
__wait_on_bit_lock+0x36/0x66
Mar  7 01:30:22 noracs3 kernel:  [<ffffffff8003ff85>] __lock_page+0x5e/0x64


my multipath.conf is like this:

defaults {
        user_friendly_names no
        polling_interval 30
        rr_min_io 100
        no_path_retry queue
        queue_without_daemon    no
        flush_on_last_del       yes
        max_fds                 max
        pg_prio_calc            avg
}

devices {
        device {
                vendor                  "NETAPP"
                product                 "LUN"
                getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
                prio_callout            "/sbin/mpath_prio_alua /dev/%n"
                features                "3 queue_if_no_path pg_init_retries 50"
                hardware_handler        "1 alua"
                path_grouping_policy    group_by_prio
                failback                immediate
                rr_weight               uniform
                rr_min_io               128
                path_checker            tur
        }
}

tried both in 5.8 an in (not yet supported) 5.9
kernel-2.6.18-348.1.1.el5
device-mapper-multipath-0.4.7-54.el5

right now the system is blocked with

# uptime
 08:29:50 up 22 days, 13:39,  2 users,  load average: 38.09, 38.03, 38.01

You can see that 22 days above is the time I had to reboot the system
the previous occurrence...

I can run any suggested command to check
is there any dm command I can run to debug and try to solve without
poweroff / poweron?


let me know if you need more information
Thanks,
Gianluca

other netapp related info
- parameter different from default shipped
< default-transport="fcp" #Transport type to use for storage
provisioning, when a decision is needed
66d64
< multipathing-type="NativeMPIO" #Multipathing software to use when
more than one multipathing solution is available. Possible values are
'NativeMPIO' or 'none'
78d75
< san-clone-method="optimal" #Clone methods for snap connect


- the commands run in sequence are for each one of the 4 volumes the
system has mounted to make a backup

snapdrive snap disconnect -fs $MM
sleep 3
snapdrive snap delete -snapname
NA01-1:/vol/${VOLBASE}_${DBID}_${VV}_vol:${DBID}_SNAP_1

- problem raising both with
netapp_linux_host_utilities-6-0
netapp.snapdrive-5.0-1

and with the version installed now
netapp_linux_host_utilities-6-1
netapp.snapdrive-5.1-1
