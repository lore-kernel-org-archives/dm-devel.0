From: Andrew Elwell <andrewe@epcc.ed.ac.uk>
Subject: RHEL 4.3 to Sun 6320 storage
Date: Tue, 27 Jun 2006 11:04:16 +0100
Message-ID: <1151402657.4766.13.camel@x41ade>
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

Hi folks,

I'm trying to set up access to our SAN, 5 cabinets of 6320 storage, from
CentOS 4.3 using dm-multipath and two Emulex lpfc cards.


So far I can see the correct arrays through the zoning and have setup
multipath.conf as below:

defaults {
        user_friendly_names     yes
        polling_interval        1
        path_checker            tur
        path_grouping_policy    group_by_serial
}
devnode_blacklist {
        devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
        devnode "^hd[a-z]"
        devnode "^sd[a-b]"
	# sda and sdb are internal 3ware raid and sata system disk
        devnode "^cciss!c[0-9]d[0-9]*"
}
multipaths {
        multipath {
                wwid     360003baccb976000426f26d30004c45a
                alias    cab2a01t0
        }
        multipath {
                wwid    360003baccb976000426f27a00006ae93
                alias   cab2a01t1
	}
	... snip more multipath definitions....
}

multipath -ll shows..


cab2a01t2 (360003baccb976000426f289000049adb)
[size=1638 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [active]
 \_ 3:0:0:2 sde 8:64  [failed][faulty]
 \_ 4:0:0:2 sdj 8:144 [active][ready]

cab2a01t1 (360003baccb976000426f27a00006ae93)
[size=1638 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [active]
 \_ 3:0:0:1 sdd 8:48  [active][ready]
 \_ 4:0:0:1 sdi 8:128 [active][ready]

cab2a01t0 (360003baccb976000426f26d30004c45a)
[size=1638 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [active]
 \_ 3:0:0:0 sdc 8:32  [active][ready]
 \_ 4:0:0:0 sdh 8:112 [active][ready]



but the error log is filling up with 
 kernel: Device sde not ready.
 kernel: end_request: I/O error, dev sde, sector 2181037632
 multipathd: 8:64: mark as failed
 multipathd: cab2a01t2: remaining active paths: 1
 multipathd: 8:64: tur checker reports path is up
 multipathd: 8:64: reinstated
 multipathd: cab2a01t2: remaining active paths: 2
 kernel: Device sde not ready.
 kernel: end_request: I/O error, dev sde, sector 3187670215
 kernel: device-mapper: dm-multipath: Failing path 8:64.

etc. I guess I should be using something other than the default for
prio_callout, but what?

Please can someone give me hints on the correct incantation for
path_checker, path_grouping_policy, prio_callout

Many thanks

Andrew
