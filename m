From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 0/7] multipath: miscellaneous bug fixes
Date: Wed,  7 Feb 2018 16:49:40 -0600
Message-ID: <1518043787-7066-1-git-send-email-bmarzins@redhat.com>
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

This is just a set of fixes for bugs I've run into.

Benjamin Marzinski (7):
  multipath: fix tur checker locking
  multipath: fix DEF_TIMEOUT use
  multipathd: remove coalesce_paths from ev_add_map
  multipathd: remove unused configure parameter
  Fix set_no_path_retry() regression
  multipathd: change spurious uevent msg priority
  multipath: print sysfs state in fast list mode

 libmultipath/checkers/tur.c | 66 ++++++++++++++++++++++++++++++++-------------
 libmultipath/discovery.c    |  2 +-
 libmultipath/structs_vec.c  |  5 ++--
 multipath/main.c            |  9 ++++---
 multipathd/main.c           | 55 +++++++++++--------------------------
 5 files changed, 73 insertions(+), 64 deletions(-)

-- 
2.7.4
