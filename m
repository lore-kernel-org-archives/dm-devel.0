From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v2 0/8] multipath cleanups
Date: Tue, 11 Aug 2020 16:58:35 -0500
Message-ID: <1597183123-15797-1-git-send-email-bmarzins@redhat.com>
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

Patches 0003 & 0004 fix an issue that I've seen with paths whose checker
takes too long when multipathd is starting up and creating devices.

The others are minor build fixes or small cleanups to my previous
patchset.

Changes in v2:
- patch 0003 no longer refactors count_active_paths(), as suggested
  by Martin Wilck
- Added patches 0007 & 0008, which are both unrelated minor changes.

Benjamin Marzinski (8):
  Makefile.inc: trim extra information from systemd version
  kpartx: fix -Wsign-compare error
  libmultipath: refactor path counting
  libmultipath: count pending paths as active on loads
  libmultipath: deal with flushing no maps
  multipath: deal with delegation failures correctly
  multipathd: unset mpp->hwe when removing map
  multipathd: log reason for calling domap()

 Makefile.inc                    |  2 +-
 kpartx/kpartx.c                 |  2 +-
 libmpathpersist/mpath_persist.c |  4 ++--
 libmultipath/devmapper.c        |  5 +++--
 libmultipath/structs.c          | 38 +++++++++++++++++++++------------
 libmultipath/structs.h          |  2 +-
 libmultipath/structs_vec.c      |  1 +
 multipath/main.c                |  9 +++++---
 multipathd/main.c               | 14 ++++++++----
 9 files changed, 49 insertions(+), 28 deletions(-)

-- 
2.17.2
