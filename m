From: Jimmy Stewpot <squid@oranged.to>
Subject: device mapper configurations
Date: Wed, 02 Jan 2008 14:21:29 +0000
Message-ID: <477B9DE9.3090108@oranged.to>
Reply-To: squid@oranged.to,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello,

I am currently working on writing a document on how to deploy the
standard multipath tools in Linux for our systems. We are currently
using all the storage vendor supplied tools and drivers, which leads to
problems in maintaining the servers patch level etc. Currently my
multipath configuration looks like this

defaults {
         udev_dir                /dev
         polling_interval        10
         selector                "round-robin 0"
         path_grouping_policy    multibus
         getuid_callout          "/lib/udev/scsi_id -g -u -s /block/%n"
         prio_callout            /bin/true
         path_checker            tur
         rr_min_io               100
         rr_weight               priorities
         failback                immediate
         no_path_retry           fail
         user_friendly_names     yes
}

devnode_blacklist {
         devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
         devnode "^hd[a-z][[0-9]*]"
         devnode "^cciss!c[0-9]d[0-9]*[p[0-9]*]"
}

multipaths {
         multipath {
                 wwid                    3600a0b800036fddd00000286477549b6
                 alias                   eux0000411-eul0001138-R1-1
                 path_grouping_policy    failover
                 path_checker            tur
                 path_selector           "round-robin 0"
                 failback                manual
                 rr_weight               priorities
                 no_path_retry           5
                 rr_min_io               100
         }
         multipath {
                 wwid                    3600a0b800036fddd0000027c47754568
                 alias                   eux0000411-eul0001138-R10-1
                 path_grouping_policy    failover
                 path_checker            tur
                 path_selector           "round-robin 0"
                 failback                manual
                 rr_weight               priorities
                 no_path_retry           5
                 rr_min_io               100
         }
         multipath {
                 wwid                    3600a0b800036fd910000025847754621
                 alias                   eux0000411-eul0001138-R10-2
                 path_grouping_policy    failover
                 path_checker            tur
                 path_selector           "round-robin 0"
                 failback                manual
                 rr_weight               priorities
                 no_path_retry           5
                 rr_min_io               100
         }
}
devices {
         device {
                 vendor                  "IBM"
                 product                 "1726-4xx  FAStT"
                 path_grouping_policy    failover
                 getuid_callout          "/lib/udev/scsi_id -g -u -s
/block/%n"
                 path_checker            tur
                 path_selector           "round-robin 0"
                 hardware_handler        "0"
                 failback                15
                 rr_weight               priorities
                 no_path_retry           queue
                 rr_min_io               100
}
}

When the system boots I get loads of errors that look like this

[  217.140126] end_request: I/O error, dev sdb, sector 0
[  217.140179] end_request: I/O error, dev sda, sector 0
[  217.607381] end_request: I/O error, dev sdf, sector 0
[  217.672613] end_request: I/O error, dev sdb, sector 0
[  217.672666] end_request: I/O error, dev sda, sector 0
[  218.139914] end_request: I/O error, dev sdf, sector 0
[  218.205140] end_request: I/O error, dev sdb, sector 0
[  218.205194] end_request: I/O error, dev sda, sector 0
[  218.672405] end_request: I/O error, dev sdf, sector 0
[  218.737635] end_request: I/O error, dev sda, sector 0
[  218.737693] end_request: I/O error, dev sdb, sector 0
[  219.171944] end_request: I/O error, dev sdf, sector 0
[  219.270187] end_request: I/O error, dev sda, sector 0
[  219.270242] end_request: I/O error, dev sdb, sector 0
[  219.704164] end_request: I/O error, dev sdf, sector 0
[  219.802719] end_request: I/O error, dev sda, sector 0
[  219.802770] end_request: I/O error, dev sdb, sector 0
[  220.236673] end_request: I/O error, dev sdf, sector 0
[  220.335191] end_request: I/O error, dev sda, sector 0
[  220.335247] end_request: I/O error, dev sdb, sector 0
[  220.769173] end_request: I/O error, dev sdf, sector 0
[  220.867724] end_request: I/O error, dev sda, sector 0
[  220.867778] end_request: I/O error, dev sdb, sector 0
[  221.285060] end_request: I/O error, dev sdf, sector 0
[  221.383578] end_request: I/O error, dev sdb, sector 0
[  221.383645] end_request: I/O error, dev sda, sector 0
[  221.799848] end_request: I/O error, dev sdf, sector 0
[  221.799851] printk: 26 messages suppressed.
[  221.799854] Buffer I/O error on device sdf, logical block 0
[  221.899449] end_request: I/O error, dev sdb, sector 0
[  221.899503] end_request: I/O error, dev sda, sector 0
[  222.300151] end_request: I/O error, dev sdf, sector 0
[  222.431946] end_request: I/O error, dev sdb, sector 0
[  222.432005] end_request: I/O error, dev sda, sector 0
[  222.799573] end_request: I/O error, dev sdf, sector 0
[  222.947834] end_request: I/O error, dev sdb, sector 0
[  222.947881] end_request: I/O error, dev sda, sector 0

When the servers boot up. The items being reported are the underlying
scsi devices which we have setup above. Is it normal to get these
messages or do I need to explicitly place the underlying devices into
the blacklist?

I am also after any advice regarding my configuration if you can see any
glaring mistakes or ways I could improve.

Regards,

Jimmy.
