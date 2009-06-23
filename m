From: Charlie Brady <charlieb-dm-devel@budge.apana.org.au>
Subject: multipathd configuration for Sun StorageTek 2510
Date: Tue, 23 Jun 2009 15:15:43 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0906231512040.18393@e-smith.charlieb.ott.istop.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
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


I've added this to my multipath.conf:

devices {
     device {
         vendor                  "SUN"
         product                 "LCSM100_I"
         getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
         prio_callout            "/sbin/mpath_prio_rdac /dev/%n"
         features                "0"
         hardware_handler        "1 rdac"
         path_grouping_policy    group_by_prio
         failback                immediate
         rr_weight               uniform
         no_path_retry           queue
         rr_min_io               1000
         path_checker            rdac
     }
}

If anyone sees any errors, please let me know. If not, could this 
information be added to multipath.conf.defaults and 
the equivalent to libmultipath/hwtable.c?
