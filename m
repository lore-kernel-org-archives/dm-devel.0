From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 4.6-rc4
Date: Thu, 14 Apr 2016 17:51:42 -0400
Message-ID: <20160414215142.GA21120@redhat.com>
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
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit bf16200689118d19de1b8d2a3c314fc21f5dc7bb:

  Linux 4.6-rc3 (2016-04-10 17:58:30 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm tags/dm-4.6-fixes

for you to fetch changes up to 9567366fefddeaea4ed1d713270535d93a3b3c76:

  dm cache metadata: fix READ_LOCK macros and cleanup WRITE_LOCK macros (2016-04-14 17:34:49 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- fix a 4.6-rc1 bio-based DM 'struct dm_target_io' leak in an error path

- stable@ fix for DM cache metadata's READ_LOCK macros that were
  incorrectly returning error if the block manager was in read-only
  mode; also cleanup multi-statement macros to use do {} while(0)

----------------------------------------------------------------
Mike Snitzer (1):
      dm cache metadata: fix READ_LOCK macros and cleanup WRITE_LOCK macros

Mikulas Patocka (1):
      dm: fix dm_target_io leak if clone_bio() returns an error

 drivers/md/dm-cache-metadata.c | 64 ++++++++++++++++++++++++++----------------
 drivers/md/dm.c                |  4 ++-
 2 files changed, 43 insertions(+), 25 deletions(-)
