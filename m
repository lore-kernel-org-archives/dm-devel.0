From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 00/14] Various multipath-tools fixes
Date: Fri, 12 Jan 2018 23:07:29 +0100
Message-ID: <20180112220743.11513-1-mwilck@suse.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Hi Christophe,

here is a series of small fixes that has accumulated at SUSE during
the last months. The first three were already posted here, but you
didn't merge them yet, so I took the freedom to re-post them.
The others should be mostly non-controversial, I hope.
Reviews are of course welcome.

Regards,
Martin

Gris Ge (1):
  multipathd daemon: Fix incorrect use of CLOCK_MONOTONIC in pthread

Martin Wilck (13):
  libmultipath: don't try to set hwhandler if it is retained
  multipath: delegate dangerous commands to multipathd
  libmultipath: condlog: log to stderr
  libmultipath: fix return code of sysfs_get_timeout
  libmultipath: fix return code of sgio_get_vpd()
  libmultipath: sgio_get_vpd: add page argument
  libmultipath: get_vpd_sgio: support VPD 0xc9
  libmultipath: select ALUA prioritizer for RDAC arrays only
  libmultipath: hwtable: multibus for NetApp NVMe-FC
  multipath -C: decrease log level
  kpartx.rules: fix by-id/scsi-* for user_friendly_names
  multipathd.socket: add WantedBy=sockets.target
  multipathd.service: drop Before=lvm2-lvmetad.service

 Makefile.inc                  |  2 +-
 kpartx/dm-parts.rules         |  4 +--
 kpartx/kpartx_id              |  8 +++++-
 libmultipath/configure.c      |  8 +++++-
 libmultipath/debug.c          |  4 +--
 libmultipath/discovery.c      | 16 +++++++----
 libmultipath/hwtable.c        | 13 +++++++++
 libmultipath/propsel.c        | 37 +++++++++++++++++++++++-
 multipath/11-dm-mpath.rules   |  3 +-
 multipath/main.c              | 66 ++++++++++++++++++++++++++++++++++++++++++-
 multipathd/cli.c              |  2 +-
 multipathd/multipathd.service |  2 +-
 multipathd/multipathd.socket  |  3 ++
 13 files changed, 150 insertions(+), 18 deletions(-)

-- 
2.15.1
