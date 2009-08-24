From: Jakov Sosic <jakov.sosic@srce.hr>
Subject: Re: Sun StorageTek 2530 and dm?
Date: Mon, 24 Aug 2009 23:53:47 +0200
Message-ID: <20090824235347.4b8cbd8a@pc-jsosic.srce.hr>
References: <20090823210536.4730636d@nb-jsosic>
	<20090823213448.154d6cff@nb-jsosic>
	<Pine.LNX.4.64.0908241128370.27199@e-smith.charlieb.ott.istop.com>
	<20090824202915.27815959@pc-jsosic.srce.hr>
	<1251139716.24406.4.camel@chandra-ubuntu>
	<20090824205933.4b4c8456@pc-jsosic.srce.hr>
	<1251145497.24406.18.camel@chandra-ubuntu>
	<20090824223627.6e1a918c@pc-jsosic.srce.hr>
	<1251147451.24406.28.camel@chandra-ubuntu>
	<20090824231416.598ecc11@pc-jsosic.srce.hr>
	<1251150116.24406.37.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1251150116.24406.37.camel@chandra-ubuntu>
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

On Mon, 24 Aug 2009 14:41:56 -0700
Chandra Seetharaman <sekharan@us.ibm.com> wrote:

> These messages are seen because there is no support for this device
> in-built in the scsi_dh_rdac module.
> 
> These will disappear when youadded the device support to scsi_dh_rdac
> module and include the module in your initrd image.

Now if I understand correctly - because my device is not
supported by scsi_dh_rdac - RDAC is not functional at all? Because
later in the dmesg, it shows 

sd 1:0:1:0: rdac: LUN 0 (owned)
sd 1:0:0:0: rdac: LUN 0 (unowned)

which suggests that RDAC is working after all? 






Here is my current multipath.conf (Sbeaf_11 and Sbeaf_21 are iSCSI
targets that work flawlessly):

defaults {
	user_friendly_names yes
}
defaults {
	udev_dir		/dev
	polling_interval 	10
	selector		"round-robin 0"
	path_grouping_policy	multibus
	getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
	prio_callout		/bin/true
	path_checker		readsector0
	rr_min_io		100
	max_fds			8192
	rr_weight		priorities
	failback		immediate
	no_path_retry		fail
	user_friendly_names	yes
}
blacklist {
	devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
	devnode "^hd[a-z]"
}
multipaths {
	multipath {
		wwid			S_beaf11
		alias			controller0
		path_grouping_policy	failover
		path_checker		readsector0
		path_selector		"round-robin 0"
		failback		immediate
		no_path_retry		queue
	}
	multipath {
		wwid			S_beaf21
		alias			controller1
		path_grouping_policy	failover
		path_checker		readsector0
		path_selector		"round-robin 0"
		failback		immediate
		no_path_retry		queue
	}
	multipath {
		wwid
3600a0b80002fcd18000014544a9166fb
		alias			sas-xen
	}
	multipath {
		wwid
3600a0b80003abc5c00000b654a916617
		alias			sas-mysql
	}
	multipath {
		wwid
3600a0b80002fcd18000014514a9165b4
		alias			qd
	}
}


devices {
	device {
		vendor			"SUN"
		product			"LCSM100_S"
		getuid_callout		"/sbin/scsi_id -g -u
-s /block/%n"
		prio_callout            "/sbin/mpath_prio_tpc /dev/%n"
		hardware_handler	"1 rdac"
		path_grouping_policy	group_by_prio
		path_checker		rdac
		failback		immediate
		rr_weight		uniform
		no_path_retry		queue
		rr_min_io		1000
	}
}




And here is the multipath -ll:

# multipath -ll
qd (3600a0b80002fcd18000014514a9165b4) dm-0 SUN,LCSM100_S
[size=100M][features=1 queue_if_no_path][hwhandler=1 rdac][rw]
\_ round-robin 0 [prio=3][active]
 \_ 1:0:1:0  sde 8:64  [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 1:0:0:0  sdb 8:16  [active][ghost]
controller1 (S_beaf21) dm-4 IET,VIRTUAL-DISK
[size=3.4T][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=0][active]
 \_ 8:0:0:1  sdk 8:160 [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 9:0:0:1  sdj 8:144 [active][ready]
controller0 (S_beaf11) dm-3 IET,VIRTUAL-DISK
[size=3.4T][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=0][active]
 \_ 10:0:0:1 sdh 8:112 [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 11:0:0:1 sdi 8:128 [active][ready]
sas-mysql (3600a0b80003abc5c00000b654a916617) dm-1 SUN,LCSM100_S
[size=115G][features=1 queue_if_no_path][hwhandler=1 rdac][rw]
\_ round-robin 0 [prio=3][active]
 \_ 1:0:1:1  sdf 8:80  [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 1:0:0:1  sdc 8:32  [active][ghost]
sas-xen (3600a0b80002fcd18000014544a9166fb) dm-2 SUN,LCSM100_S
[size=21G][features=1 queue_if_no_path][hwhandler=1 rdac][rw]
\_ round-robin 0 [prio=3][active]
 \_ 1:0:0:2  sdd 8:48  [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 1:0:1:2  sdg 8:96  [active][ghost]







-- 
|    Jakov Sosic    |    ICQ: 28410271    |   PGP: 0x965CAE2D   |
=================================================================
| start fighting cancer -> http://www.worldcommunitygrid.org/   |
