From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 0/2] More miscellaneous patches
Date: Tue,  5 Jun 2018 17:40:19 -0500
Message-ID: <1528238421-26087-1-git-send-email-bmarzins@redhat.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

These patches are based on top of the last two I sent.

Benjamin Marzinski (2):
  mpathpersist: fix aptpl support
  multipath: don't check timestamps without a path

 libmpathpersist/mpath_persist.c  |  3 ++-
 libmpathpersist/mpath_updatepr.c | 11 +++++++----
 libmpathpersist/mpathpr.h        |  3 ++-
 libmultipath/Makefile            |  2 +-
 libmultipath/config.h            |  2 ++
 libmultipath/dict.c              | 23 +++++++++++++++++++----
 libmultipath/dict.h              |  3 ++-
 libmultipath/prkey.c             | 27 ++++++++++++++++++++++++---
 libmultipath/prkey.h             |  6 ++++--
 libmultipath/propsel.c           |  6 ++++--
 libmultipath/structs.h           |  1 +
 libmultipath/util.c              | 16 ++++++++++++++++
 libmultipath/util.h              |  1 +
 multipath/main.c                 |  4 +---
 multipath/multipath.conf.5       |  7 +++++--
 multipathd/cli_handlers.c        | 15 ++++++++++-----
 multipathd/main.c                |  1 +
 17 files changed, 102 insertions(+), 29 deletions(-)

-- 
2.7.4
