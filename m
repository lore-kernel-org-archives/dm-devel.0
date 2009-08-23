From: Jakov Sosic <jakov.sosic@srce.hr>
Subject: Sun StorageTek 2530 and dm?
Date: Sun, 23 Aug 2009 21:05:36 +0200
Message-ID: <20090823210536.4730636d@nb-jsosic>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
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

Hi!

I have StorageTek 2530 storage, which has two controllers. On host side
I have LSI LOGIC two SAS port cards. I've connected one cable from
LSI port1 to StorageTek ControllerA, and second SAS cable from LSI
port2 to StorageTek ControllerB.

On storage, I've set up initiators type to Linux.

But, I just can't get multipath working. For example:

# multipath -ll
sdc: checker msg is "readsector0 checker reports path is down"
sde: checker msg is "readsector0 checker reports path is down"
sdg: checker msg is "readsector0 checker reports path is down"
sas-mysql (3600a0b80003abc5c00000b654a916617) dm-1 SUN,LCSM100_S
[size=115G][features=0][hwhandler=0][rw]
\_ round-robin 0 [prio=0][active]
 \_ 1:0:0:1 sdc 8:32  [failed][faulty]
 \_ 1:0:1:1 sdf 8:80  [active][ready] 
sas-xen (3600a0b80002fcd18000014544a9166fb) dm-2 SUN,LCSM100_S
[size=21G][features=0][hwhandler=0][rw]
\_ round-robin 0 [prio=0][active]
 \_ 1:0:0:2 sdd 8:48  [active][ready] 
 \_ 1:0:1:2 sdg 8:96  [failed][faulty]
quorum (3600a0b80002fcd18000014514a9165b4) dm-0 SUN,LCSM100_S
[size=100M][features=0][hwhandler=0][rw]
\_ round-robin 0 [prio=0][active]
 \_ 1:0:0:0 sdb 8:16  [active][ready] 
 \_ 1:0:1:0 sde 8:64  [failed][faulty]

So, all paths on my second controller are failed/faulty....

Here is my multipath.conf:

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
		wwid
3600a0b80002fcd18000014544a9166fb
		alias			sas-xen
		path_grouping_policy	group_by_prio
		path_checker		tur
		prio_callout		"/sbin/mpath_prio_tpc.static /dev/%n"
	}
	multipath {
		wwid
3600a0b80003abc5c00000b654a916617
		alias			sas-mysql
		path_grouping_policy	group_by_prio
		path_checker		tur
		prio_callout		"/sbin/mpath_prio_tpc.static /dev/%n"
	}	
	multipath {
		wwid
3600a0b80002fcd18000014514a9165b4
		alias			quorum
		path_grouping_policy	group_by_prio
		path_checker		tur
		prio_callout		"/sbin/mpath_prio_tpc.static /dev/%n"
	}
}



I've also tried:
	multipath {
		wwid
		alias
		path_grouping_policy	failover
		path_checker		readsector0
		path_selector		"round-robin 0"
		failback		immediate
		no_path_retry		queue
	}

for those 3 wwid's...



I'm kinda lost... I've found this, but it is for FC storage, and mine
is SAS type...
http://osdir.com/ml/linux.kernel.device-mapper.devel/2007-02/msg00033.html

Thank you...







-- 
|    Jakov Sosic    |    ICQ: 28410271    |   PGP: 0x965CAE2D   |
=================================================================
| start fighting cancer -> http://www.worldcommunitygrid.org/   |
