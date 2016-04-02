From: Willem Verbruggen <willem.verbruggen@anagky.be>
Subject: Multipath 0.5.0 sets all path priorities to 50 with SCST
 3.1.0 ALUA for group_by_prio
Date: Sat, 2 Apr 2016 13:19:58 +0200
Message-ID: <56FFAADE.3080405@anagky.be>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
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
To: christophe.varoqui@opensvc.com, dm-devel@redhat.com
List-Id: dm-devel.ids

Dear,

We were upgrading multipath-tools 0.4.9 to 0.5.0 on a dual node DRBD 
cluster with SCST 3.1.0 ISCSI exports and three XEN VM nodes.  All 5 
servers running:
root@cenbersto002:/usr/src# uname -a
Linux cenbersto002 4.1.18 #1 SMP Sun Mar 27 10:16:46 CEST 2016 x86_64 
GNU/Linux

For multipath 0.5.0 we cannot get the path priorities to work. Multipath 
gives all of them the priority 50 no matter what and puts all paths in 
one active group.
Is it a bug in 0.5.0 or did we still make a mistake in our upgraded 
configuration file (we checked all documentation we could find and did 
multiple tests)?
For 0.4.9 it still works fine on this upgraded platform. Then we get an 
active group with prio 130 and an enabled failover group with prio 50.

Config 0.5.0:
root@cenbernod001:~# cat multipath.conf
devices {
           device {
                   vendor                  "SCST_BIO"
#                  product                 "*"
#                  hardware_handler        "1 alua"
#                  features                "3 queue_if_no_path 
pg_init_retries 50"
#                  path_selector           "queue-length 0"
           }
}

defaults {
         polling_interval        10
         path_selector           "round-robin 0"
         path_grouping_policy    group_by_prio
         uid_attribute           "ID_SERIAL"
         getuid_callout          "/lib/udev/scsi_id --whitelisted 
--device=/dev/%n"
         prio                    alua
         path_checker            directio
         no_path_retry           queue
         rr_min_io               100
         rr_min_io_rq            100
         flush_on_last_del       no
         max_fds                 8192
         rr_weight               priorities
         failback                immediate
         queue_without_daemon    no
         user_friendly_names     no
         mode                    644
         uid                     0
         gid                     disk
#       hardware_handler        "1 alua"
}

blacklist {
         devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
         devnode "^hd[a-z]"
         devnode "^sda$"
         devnode "^sdb$"
#       wwid 350014ee1aed0e771
#       wwid 350014ee158048877
}

blacklist_exceptions {
#        device {
#                vendor SCST_BIO
#        }
         property "(ID_SCSI_VPD|ID_WWN|ID_SERIAL)"
         devnode "^sd[c-z]+"
         devnode "^sda[a-z]+"
         devnode "^sdb[a-z]+"
}

multipaths {
         multipath {
                 wwid                    26534376437633839
                 alias                   cenbererpprd007
         }
...

For multipath 0.4.9 we get the desired result:

cenbererbprd402 (26434373934373262) dm-44 SCST_BIO,cenbererbprd402
size=20G features='1 queue_if_no_path' hwhandler='0' wp=rw
|-+- policy='round-robin 0' prio=130 status=active
| |- 92:0:0:0  sdce 69:32   active ready running
| |- 93:0:0:0  sdcf 69:48   active ready running
| |- 150:0:0:0 sdek 128:192 active ready running
| `- 198:0:0:0 sdgg 131:192 active ready running
`-+- policy='round-robin 0' prio=50 status=enabled
   |- 106:0:0:0 sdcs 70:0    active ready running
   |- 107:0:0:0 sdct 70:16   active ready running
   |- 157:0:0:0 sder 129:48  active ready running
   `- 251:0:0:0 sdig 135:0   active ready running

Config 0.4.9:
root@cenbernod003:~# cat /etc/multipath.conf
devices {
        device {
                vendor "SCST_BIO"
#               product "VIRTUAL-DISK"
        }
}


##
## This is a template multipath-tools configuration file
## Uncomment the lines relevent to your environment
##
defaults {
         udev_dir                /dev
         polling_interval        10
         selector                "round-robin 0"
         path_grouping_policy    group_by_prio
         getuid_callout          "/lib/udev/scsi_id --whitelisted 
--device=/dev/%n"
         prio                    alua
         path_checker            directio
         rr_min_io               100
         flush_on_last_del       no
         max_fds                 8192
         rr_weight               priorities
         failback                immediate
         no_path_retry           queue
         queue_without_daemon    no
         user_friendly_names     no
         mode                    644
         uid                     0
         gid                     disk
}
blacklist {
         devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
         devnode "^hd[a-z]"
         devnode "^sda$"
         devnode "^sdb$"
}
multipaths {
         multipath {
                 wwid                    26534376437633839
                 alias                   cenbererpprd007
         }
...

In SCST we have ALUA groups with preference to one of the two DRBD nodes 
for each target:
DEVICE_GROUP cenbererbprd402 {
         DEVICE cenbererbprd402

         TARGET_GROUP cenbererbprd402 {
                 group_id 13
                 preferred 1
                 state active

                 TARGET cenbersto001:cenbererbprd402
         }
}

Thanks a lot in advance.

Kind Regards,

Willem

-- 
Willem Verbruggen                           ANAGKY BVBA
Zaakvoerder                                 Thaliastraat 71
+32 (0)497 54 96 36                         2600 Antwerpen
willem.verbruggen@anagky.be                 BE 0894.681.775
