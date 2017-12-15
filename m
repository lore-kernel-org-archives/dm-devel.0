From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 4.15-rc4
Date: Fri, 15 Dec 2017 13:59:39 -0500
Message-ID: <20171215185938.GB18170@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, Suren Baghdasaryan <surenb@google.com>, monty_pavel@sina.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit ae64f9bd1d3621b5e60d7363bc20afb46aede215:

  Linux 4.15-rc2 (2017-12-03 11:01:47 -0500)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-4.15/dm-fixes

for you to fetch changes up to fbc7c07ec23c040179384a1f16b62b6030eb6bdd:

  dm bufio: fix shrinker scans when (nr_to_scan < retain_target) (2017-12-08 10:54:25 -0500)

Please pull, thanks!
Mike

----------------------------------------------------------------
- Fix a particularly nasty DM core bug in a 4.15 refcount_t conversion.

- Fix various targets to dm_register_target after module __init
  resources created; otherwise racing lvm2 commands could result in a
  NULL pointer during initialization of associated DM kernel module.

- Fix regression in bio-based DM multipath queue_if_no_path handling.

- Fix DM bufio's shrinker to reclaim more than one buffer per scan.

----------------------------------------------------------------
Mike Snitzer (2):
      dm table: fix regression from improper dm_dev_internal.count refcount_t conversion
      dm mpath: fix bio-based multipath queue_if_no_path handling

Suren Baghdasaryan (1):
      dm bufio: fix shrinker scans when (nr_to_scan < retain_target)

monty_pavel@sina.com (1):
      dm: fix various targets to dm_register_target after module __init resources created

 drivers/md/dm-bufio.c        |  8 ++++--
 drivers/md/dm-cache-target.c | 12 ++++----
 drivers/md/dm-mpath.c        | 67 +++++++++++++++++++++++++++++++++-----------
 drivers/md/dm-snap.c         | 48 +++++++++++++++----------------
 drivers/md/dm-table.c        |  5 ++--
 drivers/md/dm-thin.c         | 22 +++++++--------
 6 files changed, 100 insertions(+), 62 deletions(-)
