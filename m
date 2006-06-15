From: David Sung Min Joo <djoo@redhat.com>
Subject: DS4300 Turbo
Date: Fri, 16 Jun 2006 08:28:46 +0900
Message-ID: <4491ED2E.6070101@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=EUC-KR
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

Dear all,

I just had a case where, I setup dm-multipath with DS4300-turbo (Dual
controller) with failover.
However with CLVM, whenever I try to check VGs with vgscan it would take
more than 3 mins.

Then in the /var/log/messages, I would see paths being dropped resulting
not having any path to the storage, and after few retries within
themselves, the right VGs will be shown.
However, I am very worried with outputs;
Jun 16 06:52:20 aigwebmail kernel: device-mapper: dm-multipath: Failing
path 8:16.
Jun 16 06:52:20 aigwebmail multipathd: 8:16: tur checker reports path is
down
Jun 16 06:52:20 aigwebmail multipathd: checker failed path 8:16 in map
4300-0
Jun 16 06:52:20 aigwebmail multipathd: 4300-0: remaining active paths: 1
Jun 16 06:52:21 aigwebmail multipathd: 8:144: tur checker reports path
is down
Jun 16 06:52:21 aigwebmail multipathd: checker failed path 8:144 in map
4300-0
Jun 16 06:52:21 aigwebmail kernel: device-mapper: dm-multipath: Failing
path 8:144.
Jun 16 06:52:31 aigwebmail multipathd: 4300-0: remaining active paths: 0
Jun 16 06:52:31 aigwebmail multipathd: 8:16: tur checker reports path is up
Jun 16 06:52:31 aigwebmail multipathd: 8:16: reinstated
Jun 16 06:52:31 aigwebmail multipathd: 4300-0: remaining active paths: 1
Jun 16 06:52:31 aigwebmail multipathd: 8:144: tur checker reports path is up
Jun 16 06:52:31 aigwebmail multipathd: 8:144: reinstated
Jun 16 06:52:31 aigwebmail multipathd: 4300-0: remaining active paths: 2
Jun 16 06:52:42 aigwebmail multipathd: 8:160: tur checker reports path
is down
Jun 16 06:52:42 aigwebmail multipathd: checker failed path 8:160 in map
4300-1
Jun 16 06:52:42 aigwebmail kernel: device-mapper: dm-multipath: Failing
path 8:160.
Jun 16 06:52:52 aigwebmail multipathd: 4300-1: remaining active paths: 1
Jun 16 06:52:52 aigwebmail multipathd: 8:160: tur checker reports path is up
Jun 16 06:52:52 aigwebmail multipathd: 8:160: reinstated
Jun 16 06:52:52 aigwebmail multipathd: 4300-1: remaining active paths: 2

FYI,

multipath.conf

defaults {
	multipath_tool 		"/sbin/multipath -v0"
	udev_dir     		/dev
	polling_interval	10
	selector     		"round-robin 0"
	path_grouping_policy	failover
	getuid_callout 		"/sbin/scsi_id -g -u -s /block/%n"
	prio_callout		"/bin/true"
	path_checker		tur
	rr_wmin_io		100
	failback		immediate
	user_friendly_names	yes
}
....
devnode_blacklist {
       wwid 26353900f02796769
	devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
	devnode "^hd[a-z][0-9]*"
	devnode "^cciss!c[0-9]d[0-9]*"
	devnode "sda"

Regards,
David Joo
}
