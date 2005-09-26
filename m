From: Ray Stell <stellr@cns.vt.edu>
Subject: adding luns
Date: Mon, 26 Sep 2005 09:09:10 -0400
Message-ID: <20050926130910.GA19498@locust.cns.vt.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

What actions are required to get multipath to "see" a lun added
after reboot?  I tried using an alternate qlogic driver, qla2xxx-v8.00.02-1, 
but that did not work.  Thanks. 

environment:
 - rhas4 U2 Beta - Linux pecan 2.6.9-16.EL #1 Mon Aug 15 19:58:49 EDT 2005 i686 i686 i386 GNU/Linux
 - multipath-tools-0.4.5.49. compiled from ftp://sources.redhat.com/pub/dm/multipath-tools    
     one-off patch of mpath_faker.c
 - 2 QLogic PCI to Fibre Channel Host Adapters for QLA2340:
   Firmware version 3.03.15 IPX, Driver version 8.01.00b5-rh2
 - IBM ESS 2105F20 4 paths
 - /etc/mulipath.conf:
   defaults {
           multipath_tool  "/sbin/multipath -v0"
           udev_dir        /dev
           polling_interval 10
           default_selector        "round-robin 0"
           default_path_grouping_policy    multibus
           default_getuid_callout  "/sbin/scsi_id -g -u -s /block/%n"
           default_prio_callout    "/bin/true"
           default_features        "0"
           rr_wmin_io              100
           failback                immediate
   }
   devnode_blacklist {
           devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
           devnode "^hd[a-z][0-9]*"
           devnode "^cciss!c[0-9]d[0-9]*[p[0-9]*]"
   }
   devices {
           device {
                   vendor                  "IBM"
                   product                 "2105F20"
                   path_grouping_policy    multibus
                   path_checker            tur
           }
   }
============================================================
Ray Stell  stellr@vt.edu  (540) 231-4109  Tempus fugit  28^D
