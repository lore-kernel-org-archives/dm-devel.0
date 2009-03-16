From: "John A. Sullivan III" <jsullivan@opensourcedevel.com>
Subject: Poor iSCSI performance
Date: Mon, 16 Mar 2009 05:57:44 -0400
Message-ID: <1237197464.6525.58.camel@jaspav.missionsit.net.missionsit.net>
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

Hello, all.  We've been struggling to tweak performance between on Linux
iSCSI initiators (open-iscsi) and our opensolar iSCSI targets (Nexenta).
On top of our generally poor performance (max 7000 IOPS per GbE NIC), we
are seeing abysmal performance when we try to compensate by using either
dm-multipath or dmadm to use multiple iSCSI LUNs.

We have been testing using an eight processor Linux server with 6 GbE
network interfaces speaking to a Nexenta based Z200 storage system from
Pogo Linux with 10 GbE ports.  I will attach a text file with some
results using disktest.

In summary, if we ran four completely independent tests against four
separate targets on four separate NICs, we achieved an aggregate 24940
IOPS with 512 byte blocks and 6713 IOPS with 64KB blocks.

However, we would prefer to treat the storage as a single disk and so
attempted to use software RAID, i.e., we created four LUNs, presented
them as four separate disks and then used software RAID0 to stripe
across all four targets.  We expected slightly less than the performance
cited above.  Instead, we received 4450 IOPS for 512 and for 64KB.

We then took a different approach and created one big LUN with eight
paths to the target using dm-multipath multibus with round-robin
scheduling and rr_min_io=100.  Our numbers were 4350 IOPS for 512 and
1450 IOPS with 64KB.

We then suspected it might an issue of the number of threads rather than
just the number of disks, i.e., the four independent disk test was using
four separate processes.  So we ran four separate, concurrent tests
against the RAID0 array and the multipath setup.

RAID0 increased to 11720 IOPS for 512 and 3188 IOPS for 64 KB - still a
far cry from 24900 and and 6713.  dm-multipath numbers were 10140 IOPS
for 512 and 2563 IOPS for 64KB.  Moreover, the CPU utilization was
brutal.

/etc/multipath.conf:
blacklist {
#        devnode "*"
        # sdb
        wwid SATA_ST3250310NS_9SF0L234
        #sda
        wwid SATA_ST3250310NS_9SF0LVSR
        # The above does not seem to be working thus we will do
        devnode "^sd[ab]$"
        # This is usually a bad idea as the device names can change
        # However, since we add our iSCSI devices long after boot, I
think we are safe
}
defaults {
        udev_dir                /dev
        polling_interval        5
        selector                "round-robin 0"
        path_grouping_policy    multibus
        getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
        prio_callout            /bin/true
        path_checker            readsector0
        rr_min_io               100
        max_fds                 8192
        rr_weight               priorities
        failback                immediate
        no_path_retry           fail
#       user_friendly_names     yes
}
multipaths {
        multipath {
                wwid
3600144f0e2824900000049b98e2b0001
                alias                   isda
        }
        multipath {
                wwid
3600144f0e2824900000049b062950002
                alias                   isdplain
        }
        multipath {
                wwid
3600144f0e2824900000049b9bb350001
                alias                   isdb
        }
        multipath {
                wwid
3600144f0e2824900000049b9bb350002
                alias                   isdc
        }
        multipath {
                wwid
3600144f0e2824900000049b9bb360003
                alias                   isdd
        }
        multipath {
                wwid
3600144f0e2824900000049b7878a0006
                alias                   isdtest
        }
}
devices {
       device {
               vendor                  "NEXENTA"
               product                 "COMSTAR"
#               vendor                  "SUN"
#               product                 "SOLARIS"
               getuid_callout          "/sbin/scsi_id -g -u -s /block/%
n"
               features                "0"
               hardware_handler        "0"
#               path_grouping_policy    failover
               rr_weight               uniform
#               rr_min_io               1000
               path_checker            readsector0
       }
}

What would account for such miserable performance? How can we improve
it? We do not want to proliferate disks just to increase aggregate
performance.  Thanks - John
-- 
John A. Sullivan III
Open Source Development Corporation
+1 207-985-7880
jsullivan@opensourcedevel.com

http://www.spiritualoutreach.com
Making Christianity intelligible to secular society
