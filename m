From: Lucas Brasilino <lucas.brasilino@gmail.com>
Subject: rdac priority checker changing priorities
Date: Wed, 29 Apr 2009 19:34:54 -0300
Message-ID: <9ad205140904291534j4cc1a71aq3b4a0e308f1687bd@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
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

Hi

I don't know if I'm misundertanding something. I've got an DS4700 and I'm
switching from RDAC[1] to multipath, since it's natively supported in
the distribution I use
here (SLES 10 SP2).

Since RDAC[1] works perfect, I'm trying to use 'rdac' priority in multipath.

My /etc/multiconf.conf is quite tiny, since I'm building it step-by-step :-) :

blacklist {
	devnode "^sda[0-9]*"
}

defaults {
	user_friendly_names	yes
	prio			rdac
	path_checker		tur
}

multipaths {
	multipath {
		wwid	3600a0b8000327b900000107549f85224
		alias	mpath0
	}
}

I think that using 'prio rdac' makes multipath to use 'mpath_prio_rdac' tool.

 # multipath -v2 -ll
mpath0 (3600a0b8000327b900000107549f85224) dm-0 IBM,1814      FAStT
[size=140G][features=1 queue_if_no_path][hwhandler=1 rdac]
\_ round-robin 0 [prio=6][active]
 \_ 9:0:0:0  sdb 8:16  [active][ready]
\_ round-robin 0 [prio=1][enabled]
 \_ 10:0:0:0 sdc 8:32  [active][ghost]

So the first path has priority 6, as I can confirm:

# mpath_prio_rdac /dev/sdb
6
# mpath_prio_rdac /dev/sdc
1

After the first path (prio=6) failure I get:

# multipath -v2 -ll
sdb: rdac prio: inquiry command indicates error
mpath0 (3600a0b8000327b900000107549f85224) dm-0 IBM,1814      FAStT
[size=140G][features=1 queue_if_no_path][hwhandler=1 rdac]
\_ round-robin 0 [prio=0][enabled]
 \_ 9:0:0:0  sdb 8:16  [failed][faulty]
\_ round-robin 0 [prio=1][enabled]
 \_ 10:0:0:0 sdc 8:32  [active][ghost]

Ok.. working great, activating the second path. But after the faulty
path is restored:

# multipath -v2 -ll
mpath0 (3600a0b8000327b900000107549f85224) dm-0 IBM,1814      FAStT
[size=140G][features=1 queue_if_no_path][hwhandler=1 rdac]
\_ round-robin 0 [prio=2][enabled]
 \_ 9:0:0:0  sdb 8:16  [active][ghost]
\_ round-robin 0 [prio=5][active]
 \_ 10:0:0:0 sdc 8:32  [active][ready]

Second path is now priority!!! And of course does not fails back! By
the way, my LUN is configured in
DS4700 in sort a way that the first path *is* the path to preferred controller.

I think path priorities should not change. If so first path goes back
to 'active' status.
Am I misunderstanding something ? Or messing things up?

By the way, here comes the default 'multipath.conf':

#defaults {
#       udev_dir                /dev
#       polling_interval        10
#       selector                "round-robin 0"
#       path_grouping_policy    multibus
#       getuid_callout          "/lib/udev/scsi_id -g -u -s /block/%n"
#       prio                    const
#       path_checker            directio
#       rr_min_io               100
#       max_fds                 8192
#       rr_weight               priorities
#       failback                immediate
#       no_path_retry           fail
#       user_friendly_names     no
#}
#blacklist {
#       wwid 26353900f02796769
#       devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
#       devnode "^hd[a-z][[0-9]*]"
#       devnode "^cciss!c[0-9]d[0-9]*[p[0-9]*]"
#       device {
#               vendor DEC.*
#               product MSA[15]00
#       }
#}
[...]
#devices {
#       device {
#               vendor                  "COMPAQ  "
#               product                 "HSV110 (C)COMPAQ"
#               path_grouping_policy    multibus
#               getuid_callout          "/lib/udev/scsi_id -g -u -s /block/%n"
#               path_checker            directio
#               path_selector           "round-robin 0"
#               hardware_handler        "0"
#               failback                15
#               rr_weight               priorities
#               no_path_retry           queue
#               rr_min_io               100
#               product_blacklist       LUN_Z
#       }
#       device {
#               vendor                  "COMPAQ  "
#               product                 "MSA1000         "
#               path_grouping_policy    multibus
#       }
#}

Thanks a lot in advance
Lucas Brasilino

[1] http://www.lsi.com/rdac/ds4000.html
