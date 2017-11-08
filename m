From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 0/6] Misc patches
Date: Tue,  7 Nov 2017 18:15:10 -0600
Message-ID: <1510100116-6206-1-git-send-email-bmarzins@redhat.com>
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
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

The first two patches are simply reposts. Patch 3 and 5 are simple typo
fixes. Patch 4 is an updated built-in config I recieved from Hauwei
storage. The only large patch is 6. It adds a new paramter,
"ghost_delay" that users can set if their active/passive arrays keep
getting discovered in the wrong order, causing multipath to fail over
and then back again.

Benjamin Marzinski (6):
  mpathpersist: Fix invalid condition check
  multipath: add man page info for my prkey changes
  multipath: there is no "none" path state
  mutipath: updated Huawei storage config
  multipath: fix doc typo
  multipath: add "ghost_delay" parameter

 libmpathpersist/mpath_persist.c |  5 +++--
 libmultipath/checkers.c         |  1 -
 libmultipath/config.c           |  3 +++
 libmultipath/config.h           |  3 +++
 libmultipath/configure.c        | 11 +++++++++++
 libmultipath/defaults.h         |  1 +
 libmultipath/devmapper.c        |  2 +-
 libmultipath/dict.c             | 14 ++++++++++++++
 libmultipath/hwtable.c          |  4 +++-
 libmultipath/propsel.c          | 15 +++++++++++++++
 libmultipath/propsel.h          |  1 +
 libmultipath/structs.h          |  7 +++++++
 multipath/multipath.conf.5      | 38 +++++++++++++++++++++++++++++++++++++-
 multipathd/main.c               | 28 +++++++++++++++++++++++++++-
 multipathd/multipathd.8         | 16 ++++++++++++++++
 15 files changed, 142 insertions(+), 7 deletions(-)

-- 
2.7.4
