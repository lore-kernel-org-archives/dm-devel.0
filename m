From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 4.3-rc3
Date: Tue, 22 Sep 2015 16:31:53 -0400
Message-ID: <20150922203153.GA40142@redhat.com>
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
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit 6ff33f3902c3b1c5d0db6b1e2c70b6d76fba357f:

  Linux 4.3-rc1 (2015-09-12 16:35:56 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm tags/dm-4.3-fixes

for you to fetch changes up to 586b286b110e94eb31840ac5afc0c24e0881fe34:

  dm crypt: constrain crypt device's max_segment_size to PAGE_SIZE (2015-09-14 12:04:24 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
Two stable@ fixes:

- DM thinp fix to properly advertise discard support as disabled for
  thin devices backed by a thin-pool with discard support disabled.

- DM crypt fix to prevent the creation of bios that violate the
  underlying block device's max_segments limits.  This fixes a
  relatively long-standing NCQ SSD corruption issue reported against
  dm-crypt ever since the dm-crypt cpu parallelization patches were
  merged back in 4.0.

----------------------------------------------------------------
Mike Snitzer (2):
      dm thin: disable discard support for thin devices if pool's is disabled
      dm crypt: constrain crypt device's max_segment_size to PAGE_SIZE

 drivers/md/dm-crypt.c | 17 +++++++++++++++--
 drivers/md/dm-thin.c  |  4 ++++
 2 files changed, 19 insertions(+), 2 deletions(-)
