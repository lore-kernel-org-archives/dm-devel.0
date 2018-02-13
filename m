From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v3 0/7] multipath: miscellaneous bug fixes
Date: Mon, 12 Feb 2018 21:42:07 -0600
Message-ID: <1518493334-18170-1-git-send-email-bmarzins@redhat.com>
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

This is just a set of fixes for bugs I've run into.

V3:
	-rework tur locking fix to deal with an error pointed out
	 by Martin, and to remove tur_running(), as suggested by Bart

V2:
        -rework tur locking fix to use atomic variables as Martin
         suggested. If this version doesn't make people happy, I'll
         just move the condlog() and be done with it.

        -add comments and fix messages for ev_add_map

        -fix bugs in cli_restore_queueing() and
         cli_restore_all_queueing()

        -check if paths exist in sysfs in fast listing mode

Benjamin Marzinski (7):
  libmultipath: fix tur checker locking
  multipath: fix DEF_TIMEOUT use
  multipathd: remove coalesce_paths from ev_add_map
  multipathd: remove unused configure parameter
  Fix set_no_path_retry() regression
  multipathd: change spurious uevent msg priority
  multipath: print sysfs state in fast list mode

 libmultipath/checkers/tur.c | 107 ++++++++++++++++++--------------------------
 libmultipath/discovery.c    |   2 +-
 libmultipath/structs_vec.c  |   5 ++-
 multipath/main.c            |  10 +++--
 multipathd/cli_handlers.c   |  20 +++++----
 multipathd/main.c           |  60 +++++++++----------------
 6 files changed, 86 insertions(+), 118 deletions(-)

-- 
2.7.4
