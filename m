From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 4.12-rc1
Date: Fri, 5 May 2017 15:01:00 -0400
Message-ID: <20170505190059.GA88979@redhat.com>
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
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Joe Thornber <ejt@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Milan Broz <gmazyland@gmail.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit 7b66f13207e60e7c550af730986e77e38a0c69a3:

  Merge tag 'for-4.12/dm-post-merge-changes' of git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm (2017-05-03 10:34:03 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-4.12/dm-fixes

for you to fetch changes up to 10add84e276432d9dd8044679a1028dd4084117e:

  dm cache metadata: fail operations if fail_io mode has been established (2017-05-05 14:40:13 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- DM cache metadata fixes to short-circuit operations that require the
  metadata not be in 'fail_io' mode.  Otherwise crashes are possible.

- a DM cache fix to address the inability to adapt to continuous IO that
  happened to also reflect a changing working set (which required old
  blocks be demoted before the new working set could be promoted)

- a DM cache smq policy cleanup that fell out from reviewing the above

- fix the Kconfig help text for CONFIG_DM_INTEGRITY

----------------------------------------------------------------
Joe Thornber (1):
      dm cache policy smq: allow demotions to happen even during continuous IO

Mike Snitzer (3):
      dm cache policy smq: cleanup free_target_met() and clean_target_met()
      dm integrity: improve the Kconfig help text for DM_INTEGRITY
      dm cache metadata: fail operations if fail_io mode has been established

 drivers/md/Kconfig               | 15 +++++++++++++--
 drivers/md/dm-cache-metadata.c   | 12 ++++++++----
 drivers/md/dm-cache-policy-smq.c | 30 ++++++++++++++++++------------
 3 files changed, 39 insertions(+), 18 deletions(-)
