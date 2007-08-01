From: Eric Ritchie <eritchie@interactivebrokers.com>
Subject: RH 4 and HSG80
Date: Wed, 01 Aug 2007 10:53:55 -0400
Message-ID: <46B09E83.9010503@interactivebrokers.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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

I trying to setup multipathing with HSG80s on a Redhat 4 update 5 host. 
I have it mostly working, the problem I'm having is that the 2 disks 
I've created on the HSGs only go through one controller. I set the 
preferred path for each disk to use a different controller but dm always 
sets them to go through just one. I also can't find a way to move a disk 
to the other controller, I thought multipathd -k switch would work but 
it doesn't. Does anyone have RedHat4 and HSG80s working properly with 
multipathing? Here is my multipath.conf file and multipath -ll output:

defaults {
        user_friendly_names yes
}

defaults {
        udev_dir                /dev
        polling_interval        10
        selector                "round-robin 0"
        path_grouping_policy    multibus
        getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
        prio_callout            /bin/true
        path_checker            readsector0
        rr_min_io               100
        rr_weight               priorities
        failback                immediate
        no_path_retry           fail
        user_friendly_name      yes
        features                "1 queue_if_no_path"
}
devnode_blacklist {
        devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
        devnode "^hd[a-z]"
        devnode "^cciss!c[0-9]d[0-9]*"
}

multipaths {
        multipath {
                wwid                    360001fe1000d85f000039341397602d2
                alias                   disk1
                path_grouping_policy    multibus
                path_checker            readsector0
                path_selector           "round-robin 0"
                failback                manual
                rr_weight               priorities
                no_path_retry           5
        }
        multipath {
                wwid                    360001fe1000d85f0000393413976024b
                alias                   disk2
                path_grouping_policy    multibus
                path_checker            readsector0
                path_selector           "round-robin 0"
                failback                manual
                rr_weight               priorities
                no_path_retry           5
        }
}
devices {
        device {
                vendor                  DEC
                product                 HSG80
                path_grouping_policy    group_by_serial
                getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
                path_checker            hp_sw
                features                "1 queue_if_no_path"
        }
        device {
                vendor                  DEC
                product                 "HSG80    (C) DEC"
                path_grouping_policy    group_by_serial
                getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
                path_checker            hp_sw
                features                "1 queue_if_no_path"
        }
}

[root@lin380g5-ib etc]# multipath -ll
disk2 (360001fe1000d85f0000393413976024b)
[size=339 GB][features="1 queue_if_no_path"][hwhandler="0"]
\_ round-robin 0 [active]
 \_ 0:0:4:11 sdb 8:16  [active][ready]
 \_ 0:0:5:11 sdd 8:48  [active][ghost]
 \_ 1:0:4:11 sdf 8:80  [active][ready]
 \_ 1:0:5:11 sdh 8:112 [active][ghost]

disk1 (360001fe1000d85f000039341397602d2)
[size=67 GB][features="1 queue_if_no_path"][hwhandler="0"]
\_ round-robin 0 [active]
 \_ 0:0:4:20 sda 8:0   [active][ready]
 \_ 0:0:5:20 sdc 8:32  [active][ghost]
 \_ 1:0:4:20 sde 8:64  [active][ready]
 \_ 1:0:5:20 sdg 8:96  [active][ghost]


Thanks

-- 
Eric Ritchie
Interactive Brokers LLC
