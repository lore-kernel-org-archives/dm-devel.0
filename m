From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 0/9] Misc Multipath patches
Date: Fri, 22 Feb 2019 10:58:03 -0600
Message-ID: <1550854692-19873-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

The series is a mix of resends an new patches.

Patches 0001-0005 are simply resends of patches I've submitted earlier,
with no changes other that adding Reviewed-by's where appropriate.

Patches 0006-0009 are the result of running into some bugs during
firmare updates on an array. 

Benjamin Marzinski (9):
  libmultipath: disable user_friendly_names for NetApp
  libmultipath: handle existing paths in marginal_path enqueue
  multipathd: cleanup marginal paths checking timers
  libmultipath: fix marginal paths queueing errors
  libmultipath: fix marginal_paths nr_active check
  multipathd: Fix miscounting active paths
  multipathd: ignore failed wwid recheck
  libmutipath: continue to use old state on PATH_PENDING
  multipathd: use update_path_groups instead of reload_map

 libmultipath/discovery.c   | 18 ++++++----
 libmultipath/hwtable.c     |  1 +
 libmultipath/io_err_stat.c | 71 +++++++++++++++-----------------------
 libmultipath/io_err_stat.h |  2 +-
 multipath/main.c           |  2 +-
 multipathd/cli_handlers.c  |  2 +-
 multipathd/main.c          | 27 +++++++++------
 multipathd/main.h          |  2 ++
 8 files changed, 62 insertions(+), 63 deletions(-)

-- 
2.17.2
