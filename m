From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 0/6] multipath cleanup patches
Date: Thu, 29 Mar 2018 22:36:57 -0500
Message-ID: <1522381023-15262-1-git-send-email-bmarzins@redhat.com>
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

The first four of these patches are minor fixes from Martin Wilck's
review of my recently merged patchset. The fifth patch is a license
clarification for libmpathcmd, and the sixth is is minor bugfix for
multipathd config value printing

Benjamin Marzinski (6):
  multipathd: remove incorrect pthread_testcancel
  multipath: add comments
  multipathd: minor dmevents polling code cleanups
  multipathd: remove unneeded function parameter
  mpathcmd: fix libmpathcmd license
  libmultipath: don't print undefined values

 libmpathcmd/mpath_cmd.c | 19 +++++++++++++
 libmpathcmd/mpath_cmd.h |  2 +-
 libmultipath/dict.c     |  8 ++++++
 multipathd/dmevents.c   | 10 ++++---
 multipathd/main.c       | 15 +++++------
 multipathd/waiter.c     |  1 -
 tests/dmevents.c        | 72 ++++++++++++++++++++++++++++++++++++++++++++++++-
 tests/util.c            |  2 ++
 8 files changed, 114 insertions(+), 15 deletions(-)

-- 
2.7.4
