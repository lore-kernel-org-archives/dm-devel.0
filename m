From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 0/6] multipath cleanups
Date: Mon, 27 Jul 2020 14:24:22 -0500
Message-ID: <1595877868-5595-1-git-send-email-bmarzins@redhat.com>
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

Benjamin Marzinski (6):
  Makefile.inc: trim extra information from systemd version
  kpartx: fix -Wsign-compare error
  libmultipath: remove code duplication in path counting
  libmultipath: count pending paths as active on loads
  libmultipath: deal with flushing no maps
  multipath: deal with delegation failures correctly

 Makefile.inc                    |  2 +-
 kpartx/kpartx.c                 |  2 +-
 libmpathpersist/mpath_persist.c |  4 +--
 libmultipath/devmapper.c        |  5 ++--
 libmultipath/structs.c          | 52 ++++++++++++++++-----------------
 libmultipath/structs.h          |  2 +-
 multipath/main.c                |  9 ++++--
 7 files changed, 39 insertions(+), 37 deletions(-)

-- 
2.17.2
