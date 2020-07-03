From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v2 0/4] misc patches
Date: Thu,  2 Jul 2020 19:38:23 -0500
Message-ID: <1593736707-14216-1-git-send-email-bmarzins@redhat.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

This is a small collection of individual bug fix patches that apply on
top of my previous patch set.

Changes from v1:

0001:	Going with Martin's strtoul() method instead

0002:	Now getpagesize() is only called once, and size_p is only set if
	posix_memalign is successful, as suggested by Martin.
	

Benjamin Marzinski (4):
  libmultipath: fix sysfs dev_loss_tmo parsing
  kpartx: read devices with direct IO
  kpartx: handle alternate bsd disklabel location
  libmultipath: fix checker detection for nvme devices

 kpartx/bsd.c             | 16 ++++++++++--
 kpartx/dasd.c            |  7 ++---
 kpartx/gpt.c             | 22 +++++++---------
 kpartx/kpartx.c          | 56 ++++++++++++++++++++++++++++++++--------
 kpartx/kpartx.h          |  2 ++
 libmultipath/discovery.c | 12 ++++++---
 libmultipath/propsel.c   |  4 ++-
 7 files changed, 87 insertions(+), 32 deletions(-)

-- 
2.17.2
