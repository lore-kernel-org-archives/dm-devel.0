From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v2 00/20] Various multipath-tools fixes
Date: Thu, 18 Jan 2018 11:02:40 -0600
Message-ID: <20180118170240.GY5638@octiron.msp.redhat.com>
References: <20180113211938.31552-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180113211938.31552-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

On Sat, Jan 13, 2018 at 10:19:18PM +0100, Martin Wilck wrote:
> Hi Christophe,
> 
> here is v2 of my last series, rebased onto your latest merges.
> 
> Changes wrt v1:
> 
>   - dropped already merged CLOCK_MONOTONIC patch
>   - added a compiler warning fix
>   - improved placement of NetApp entry in hwtable (Xose Vazquez Perez, 09/20)
>   - added two SUSE patches that were missing in the previous series
>     (15/20, 16/20; Xose Vazquez Perez)
>   - added the re-submission of my path latency prio fixes from November (17-20/20)
>   - fixed wrong calculation of standard deviation (Guan Junxiong, 19/20)
> 
> I added 16/20 at Xose's request, knowing that it may be a bit more
> controversial than the rest. At SUSE we've currently added it only for
> SLE-12 SP2, because SLES12-SP2 GA had DefaultTaskMax=512, which is much
> too low for multipathd. Current systemd versions have increased this to
> 4915, which would be sufficient for most but not all multipath
> deployments (https://github.com/systemd/systemd/issues/3211).

These all look fine.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
 
> Regards,
> Martin
> 
> Martin Wilck (20):
>   libmultipath: don't try to set hwhandler if it is retained
>   multipath: delegate dangerous commands to multipathd
>   libmultipath: condlog: log to stderr
>   libmultipath: fix return code of sysfs_get_timeout
>   libmultipath: fix return code of sgio_get_vpd()
>   libmultipath: sgio_get_vpd: add page argument
>   libmultipath: get_vpd_sgio: support VPD 0xc9
>   libmultipath: select ALUA prioritizer for RDAC arrays only
>   libmultipath: hwtable: multibus for NetApp NVMe-FC
>   multipath -C: decrease log level
>   kpartx.rules: fix by-id/scsi-* for user_friendly_names
>   multipathd.socket: add WantedBy=sockets.target
>   multipathd.service: drop Before=lvm2-lvmetad.service
>   multipathd: fix compiler warning for uev_pathfail_check
>   test-kpartx: add test for mapping without UUID
>   multipathd.service: set TasksMax=infinity
>   libmultipath: path latency: fix default base num
>   libmultipath: path latency: log threshold with p2
>   libmultipath: path latency: simplify getprio()
>   libmultipath: path latency: remove warnings
> 
>  Makefile.inc                             |   2 +-
>  kpartx/dm-parts.rules                    |   4 +-
>  kpartx/kpartx_id                         |   8 ++-
>  kpartx/test-kpartx                       |  11 ++-
>  libmultipath/configure.c                 |   8 ++-
>  libmultipath/debug.c                     |   4 +-
>  libmultipath/discovery.c                 |  16 +++--
>  libmultipath/hwtable.c                   |  37 +++++++---
>  libmultipath/prioritizers/path_latency.c | 112 ++++++++++---------------------
>  libmultipath/propsel.c                   |  37 +++++++++-
>  multipath/11-dm-mpath.rules              |   3 +-
>  multipath/main.c                         |  66 +++++++++++++++++-
>  multipathd/main.c                        |   4 +-
>  multipathd/multipathd.service            |   3 +-
>  multipathd/multipathd.socket             |   3 +
>  15 files changed, 210 insertions(+), 108 deletions(-)
> 
> -- 
> 2.15.1
