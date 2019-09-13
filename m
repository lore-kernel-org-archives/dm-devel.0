From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v2 0/4] misc multipath patches
Date: Fri, 13 Sep 2019 17:04:00 -0500
Message-ID: <1568412244-23982-1-git-send-email-bmarzins@redhat.com>
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

These are a couple of disconnected multipath patches.

Changes in v2:

0003: As Martin suggested, fail immediately on wrong number of prin
      actions.

0004: mp_init now is an optional symbol for checker DSOs, and is ignored
      if it's missing, again at Martin's suggestion.

Benjamin Marzinski (4):
  mpathpersist: remove broken/unused code
  libmultipath: EMC PowerMax NVMe device config
  mpathpersist: fix leaks
  libmultipath: fix mpcontext initialization

 libmpathpersist/mpath_persist.c      | 16 ++++----------
 libmultipath/checkers.c              | 27 +++++++++++++++++++++--
 libmultipath/checkers.h              |  1 +
 libmultipath/checkers/emc_clariion.c |  7 ++++++
 libmultipath/discovery.c             |  2 ++
 libmultipath/hwtable.c               |  6 +++++
 mpathpersist/main.c                  | 33 ++++++++++++++++++----------
 7 files changed, 67 insertions(+), 25 deletions(-)

-- 
2.17.2
