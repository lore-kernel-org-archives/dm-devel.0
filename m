From: Nuno Fernandes <npf-mlists@eurotux.com>
Subject: Can't seem to set features=1 queue_if_no_path
Date: Tue, 2 Nov 2010 16:24:04 +0000
Message-ID: <201011021624.04519.npf-mlists@eurotux.com>
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

Hi,

I have the following multipath.conf

[root@blade01 ~]# cat /etc/multipath.conf
defaults {
        user_friendly_names yes
}
blacklist {
        devnode "^sda$"
}
device {
        vendor                  "*"
        product                 "*"
        getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
        prio_callout            "/sbin/mpath_prio_rdac /dev/%n"
        hardware_handler        "1 rdac"
        features                "1 queue_if_no_path"
        path_grouping_policy    group_by_prio
        failback                immediate
        no_path_retry           queue
        rr_min_io               1000
        path_checker            rdac
}
multipaths {
        multipath {
                wwid                    360080e5000183dfe000003754ccffae5
                alias                   red
        }
        multipath {
                wwid                    360080e5000183c88000003734ccffa68
                alias                   blue
        }
}

I have both "no_path_retry           queue" and 'features                "1 
queue_if_no_path"'.

Nevertheless, it doens't get applied:

[root@blade01 ~]# multipath -ll
blue (360080e5000183c88000003734ccffa68) dm-1 IBM,1814      FAStT
[size=100G][features=0][hwhandler=1 rdac][rw]
\_ round-robin 0 [prio=200][active]
 \_ 2:0:1:2 sde 8:64  [active][ready]
 \_ 1:0:1:2 sdi 8:128 [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 2:0:0:2 sdc 8:32  [active][ghost]
 \_ 1:0:0:2 sdg 8:96  [active][ghost]
red (360080e5000183dfe000003754ccffae5) dm-0 IBM,1814      FAStT
[size=100G][features=0][hwhandler=1 rdac][rw]
\_ round-robin 0 [prio=200][active]
 \_ 2:0:0:1 sdb 8:16  [active][ready]
 \_ 1:0:0:1 sdf 8:80  [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 2:0:1:1 sdd 8:48  [active][ghost]
 \_ 1:0:1:1 sdh 8:112 [active][ghost]

Using kernel 2.6.18-194.17.4.el5xen 64 bits from centos.

Any ideas?
Thanks,
Nuno Fernandes
