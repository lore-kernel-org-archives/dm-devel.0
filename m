From: seth vidal <skvidal@linux.duke.edu>
Subject: failover speed
Date: Mon, 28 Aug 2006 14:53:09 -0400
Message-ID: <1156791189.26413.8.camel@cutter>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,
 I've gotten failover and failback working, however, I'm not sure if the
amount of wait time for the failover is reasonable. I'm using QLogic
2340 cards and an EVA8000. I'm curious if anyone else using something
similar is seeing in terms of failover times. 

When things are running as I'd expect I'm seeing just a few seconds
before the new path is up. When things seem wrong it's waiting and
queueing for as much as 1.5 minutes.

What should I be expecting?

My multipath.conf looks like this:

defaults {
        user_friendly_names             yes
        multipath_tool                  "/sbin/multipath -v0"
        udev_dir                        /dev
        polling_interval                10
        default_selector                "round-robin 0"
        default_path_grouping_policy    failover
        default_getuid_callout          "/sbin/scsi_id -g -u -s /block/%
n"
        default_prio_callout            "/bin/true"
        default_features                "0"
        rr_min_io                      100
        failback                        immediate
}

devnode_blacklist {
        devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
        devnode "^hd[a-z]"
        devnode "^cciss!c[0-9]d[0-9]*"
}



multipaths {

        multipath {
                wwid
3600508b40010764b0000b00003630000
                alias                   "lun1"
                path_grouping_policy    failover
                path_checker            readsector0
                path_selector           "round-robin 0"
                failback                20
                rr_weight               priorities
                no_path_retry           queue
        }

        multipath {
                wwid
3600508b40010764b0000b00003660000
                alias                   "lun2"
                path_grouping_policy    failover
                path_checker            readsector0
                path_selector           "round-robin 0"
                failback                20
                rr_weight               priorities
                no_path_retry           queue
        }
        multipath {
                wwid
3600508b40010764b0000b000036b0000
                alias                   "lun3"
                path_grouping_policy    failover
                path_checker            readsector0
                path_selector           "round-robin 0"
                failback                20
                rr_weight               priorities
                no_path_retry           queue
        }

        multipath {
                wwid
3600508b40010764b0000b000036e0000
                alias                   "lun4"
                path_grouping_policy    failover
                path_checker            readsector0
                path_selector           "round-robin 0"
                failback                20
                rr_weight               priorities
                no_path_retry           queue
        }
}
devices {
          device {
#             vendor                 "HP      "
#             product                "HSV210          "
              vendor                 "HP*"
              product                "HSV210*"
              path_grouping_policy   group_by_prio
              getuid_callout         "/sbin/scsi_id -g -u -s /block/%n"
              path_checker           tur
              path_selector          "round-robin 0"
              prio_callout           "/sbin/mpath_prio_alua %d"
              failback               immediate
              no_path_retry          60
          }
}


Thanks,
-sv
