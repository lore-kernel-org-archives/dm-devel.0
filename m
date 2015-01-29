From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] last couple device mapper fixes for 3.19 final
Date: Thu, 29 Jan 2015 08:49:27 -0500
Message-ID: <20150129134927.GA663@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
Cc: dm-devel@redhat.com, Joe Thornber <ejt@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit 26bc420b59a38e4e6685a73345a0def461136dce:

  Linux 3.19-rc6 (2015-01-25 20:04:41 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/dm-3.19-fixes-3

for you to fetch changes up to 2a7eaea02b99b6e267b1e89c79acc6e9a51cee3b:

  dm thin: don't allow messages to be sent to a pool target in READ_ONLY or FAIL mode (2015-01-28 10:00:34 -0500)

Please pull, thanks.
Mike

----------------------------------------------------------------
1 stable fix for a dm-cache 3.19-rc6 regression and 1 stable fix for
dm-thin:

- fix DM cache metadata open/lookup error paths to properly use ERR_PTR
  and IS_ERR (fixes: 3.19-rc6 "stable" commit 9b1cc9f251)

- fix DM thin-provisioning to disallow userspace from sending messages
  to the thin-pool if the pool is in READ_ONLY or FAIL mode since no
  metadata changes are not allowed in these modes.

----------------------------------------------------------------
Joe Thornber (2):
      dm cache: fix missing ERR_PTR returns and handling
      dm thin: don't allow messages to be sent to a pool target in READ_ONLY or FAIL mode

 drivers/md/dm-cache-metadata.c | 9 +++++----
 drivers/md/dm-thin.c           | 6 ++++++
 2 files changed, 11 insertions(+), 4 deletions(-)
