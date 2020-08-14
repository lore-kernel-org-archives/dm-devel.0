From: "McIntyre, Vincent (CASS, Marsfield)" <Vincent.Mcintyre@csiro.au>
Subject: Re: Promise and ALUA
Date: Fri, 14 Aug 2020 02:18:35 +0000
Message-ID: <20200814021835.GD2644@mayhem.atnf.CSIRO.AU>
References: <20200810043316.GH21810@mayhem.atnf.CSIRO.AU>
	<8c910ecb-ddf8-0a91-4310-4daedb85cd89@gmail.com>
	<20200813235143.GB2644@mayhem.atnf.CSIRO.AU>
	<f9f8c62f-fa97-dbcb-52dd-503d392df95f@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <f9f8c62f-fa97-dbcb-52dd-503d392df95f@gmail.com>
Content-Language: en-US
Content-ID: <CD314DBDE1DFCD4084F70AA64B708D51@ausprd01.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Aug 14, 2020 at 02:24:08AM +0200, Xose Vazquez Perez wrote:
>
>If E830f is an Active-Active array without ALUA support,
>add to /etc/multipath.conf:
>
>devices {
>        device {
>                vendor "Promise"
>                product "VTrak"
>                product_blacklist "VTrak V-LUN"
>                path_grouping_policy "multibus"
>                detect_prio "no"
>                hardware_handler ""
>                prio "const"
>                failback "manual"
>                no_path_retry 30
>        }
>}
>
>run update-initramfs, and reboot.

I updated multipath.conf as above, ran update-initramfs.
# cat /etc/multipath.conf
devices {
        device {
                vendor "Promise"
                product "VTrak"
                product_blacklist "VTrak V-LUN"
                path_grouping_policy "multibus"
                detect_prio "no"
                hardware_handler ""
                prio "const"
                failback "manual"
                no_path_retry 30
        }
}

Also, I removed the wwid of the test LUN

# multipath -v 3 -w 2228a0001558b1855
Aug 14 11:52:54 | set open fds limit to 1048576/1048576
Aug 14 11:52:54 | loading //lib/multipath/libchecktur.so checker
Aug 14 11:52:54 | checker tur: message table size = 3
Aug 14 11:52:54 | loading //lib/multipath/libprioconst.so prioritizer
Aug 14 11:52:54 | foreign library "nvme" loaded successfully
Aug 14 11:52:54 | libdevmapper version 1.02.155 (2018-12-18)
Aug 14 11:52:54 | DM multipath kernel driver v1.13.0
Aug 14 11:52:54 | removing line '/2228a0001558b1855/
' from wwids file
Aug 14 11:52:54 | found '/2228a0001558b1855/
'
wwid '2228a0001558b1855' removed
Aug 14 11:52:54 | unloading const prioritizer
Aug 14 11:52:54 | unloading tur checker

# cat /etc/multipath/wwids
# Multipath wwids, Version : 1.0
# NOTE: This file is automatically maintained by multipath and multipathd.
# You should not need to edit this file in normal circumstances.
#
# Valid WWIDs:
/2221f000155c0792e/
/3600a098000b173f60000079e5da82d73/
/222e300015555469c/
#2228a0001558b1855/

# multipath -F
# multipath -l
(no output)
# multipath -r
# multpath -l |grep dm-
3600a098000b173f60000079e5da82d73 dm-10 DELL,MD38xxf

# reboot

# multipath -ll
3600a098000b173f60000079e5da82d73 dm-10 DELL,MD38xxf
size=40T features='5 queue_if_no_path pg_init_retries 50 queue_mode mq' hwhandler='1 rdac' wp=rw
|-+- policy='service-time 0' prio=14 status=active
| |- 1:0:10:0  sdaa 65:160 active ready running
| |- 1:0:12:0  sdac 65:192 active ready running
| |- 1:0:14:0  sdae 65:224 active ready running
| `- 1:0:8:0   sdy  65:128 active ready running
`-+- policy='service-time 0' prio=9 status=enabled
  |- 1:0:11:0  sdab 65:176 active ready running
  |- 1:0:13:0  sdad 65:208 active ready running
  |- 1:0:7:0   sdx  65:112 active ready running
  `- 1:0:9:0   sdz  65:144 active ready running

#  multipath -T
defaults {
        verbosity 2
        polling_interval 5
        max_polling_interval 20
        reassign_maps "no"
        multipath_dir "//lib/multipath"
        path_selector "service-time 0"
        path_grouping_policy "failover"
        uid_attribute "ID_SERIAL"
        prio "const"
        prio_args ""
        features "0"
        path_checker "tur"
        alias_prefix "mpath"
        failback "manual"
        rr_min_io 1000
        rr_min_io_rq 1
        max_fds "max"
        rr_weight "uniform"
        queue_without_daemon "no"
        flush_on_last_del "no"
        user_friendly_names "no"
        fast_io_fail_tmo 5
        bindings_file "/etc/multipath/bindings"
        wwids_file "/etc/multipath/wwids"
        prkeys_file "/etc/multipath/prkeys"
        log_checker_err always
        all_tg_pt "no"
        retain_attached_hw_handler "yes"
        detect_prio "yes"
        detect_checker "yes"
        force_sync "no"
        strict_timing "no"
        deferred_remove "no"
        config_dir "/etc/multipath/conf.d"
        delay_watch_checks "no"
        delay_wait_checks "no"
        marginal_path_err_sample_time "no"
        marginal_path_err_rate_threshold "no"
        marginal_path_err_recheck_gap_time "no"
        marginal_path_double_failed_time "no"
        find_multipaths "strict"
        uxsock_timeout 4000
        retrigger_tries 0
        retrigger_delay 10
        missing_uev_wait_timeout 30
        skip_kpartx "no"
        disable_changed_wwids "yes"
        remove_retries 0
        ghost_delay "no"
        find_multipaths_timeout -10
}
blacklist {
        devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st|dcssblk)[0-9]"
        devnode "^(td|hd|vd)[a-z]"
        devnode "^cciss!c[0-9]d[0-9]*"
        device {
                vendor "SGI"
                product "Universal Xport"
        }
        device {
                vendor "^DGC"
                product "LUNZ"
        }
        device {
                vendor "EMC"
                product "LUNZ"
        }
        device {
                vendor "DELL"
                product "Universal Xport"
        }
        device {
                vendor "IBM"
                product "Universal Xport"
        }
        device {
                vendor "IBM"
                product "S/390"
        }
        device {
                vendor "(NETAPP|LSI|ENGENIO)"
                product "Universal Xport"
        }
        device {
                vendor "STK"
                product "Universal Xport"
        }
        device {
                vendor "SUN"
                product "Universal Xport"
        }
        device {
                vendor "(Intel|INTEL)"
                product "VTrak V-LUN"
        }
        device {
                vendor "Promise"
                product "Vess V-LUN"
        }
        device {
                vendor "Promise"
                product "VTrak V-LUN"
        }
}
blacklist_exceptions {
        property "(SCSI_IDENT_|ID_WWN)"
}
devices {
        device {
                vendor "Promise"
                product "VTrak"
                product_blacklist "VTrak V-LUN"
                path_grouping_policy "multibus"
                hardware_handler ""
                prio "const"
                failback "manual"
                no_path_retry 30
                detect_prio "no"
        }
        device {
                vendor "DELL"
                product "^MD3"
                product_blacklist "Universal Xport"
                path_grouping_policy "group_by_prio"
                path_checker "rdac"
                features "2 pg_init_retries 50"
                hardware_handler "1 rdac"
                prio "rdac"
                failback "immediate"
                no_path_retry 30
        }
}
overrides {
}
multipaths {
        multipath {
                wwid "3600a098000b173f60000079e5da82d73"
        }
}


This is the device section I had before for the Promise
        device {
                vendor "Promise"
                product "VTrak"
                product_blacklist "VTrak V-LUN"
                path_grouping_policy "multibus"
                path_selector "service-time 0"
                path_checker "tur"
                prio "alua"
                failback "immediate"
                no_path_retry 30
        }
The only real differences are the prio and failback.

Vince
