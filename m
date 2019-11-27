From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 RESEND 0/5]  Drop nr_active,
	and some more fixes
Date: Wed, 27 Nov 2019 15:05:46 +0000
Message-ID: <20191127150604.31417-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: Chongyun Wu <wu.chongyun@h3c.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

(Resending this, as it didn't make it to the ML last time).

This series applies on top of my late "multipath-tools: cleanup and 
warning enablement" series.

Patch 3/5 is a rework of my RFC patch with the same subject
submitted on Nov. 13th, trying to accomodate Ben's suggestions.
Patch 1 and 2 are trivial refactorings to prepare for it.
Patch 4 and 5 are fixes for bugs that I encountered when
testing patch 3.

As usual, reviews and comments are welcome.

Changes v1 -> v2:

 * Added Reviewed-by's from Ben where appropriate
 * 03/05: don't check current state when calling set_no_path_retry()
   from cli_handler code (Ben)

Martin Wilck (5):
  multipathd: move set_no_path_retry() back to libmultipath
  libmultipath: dict.c: rename duplicate set_no_path_retry()
  libmultipath: drop mpp->nr_active field
  libmultipath: fix (max_)polling_interval setting logic
  libmultipath: fix ALUA autodetection when paths are down

 libmultipath/config.c      | 40 +++++++++++++++--
 libmultipath/config.h      |  1 +
 libmultipath/configure.c   |  5 +--
 libmultipath/defaults.h    |  3 +-
 libmultipath/devmapper.c   |  2 +-
 libmultipath/dict.c        | 10 ++---
 libmultipath/discovery.c   | 22 +++++++++-
 libmultipath/io_err_stat.c |  4 +-
 libmultipath/print.c       |  5 ++-
 libmultipath/propsel.c     | 20 +++++++--
 libmultipath/structs.c     | 19 ++++++++
 libmultipath/structs.h     |  4 +-
 libmultipath/structs_vec.c | 89 +++++++++++++++++++++++++++++++-------
 libmultipath/structs_vec.h |  3 +-
 multipathd/cli_handlers.c  | 41 ++++++++----------
 multipathd/main.c          | 75 +++++---------------------------
 16 files changed, 217 insertions(+), 126 deletions(-)

-- 
2.24.0
