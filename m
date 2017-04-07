From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 4.11-rc6
Date: Fri, 7 Apr 2017 11:14:22 -0400
Message-ID: <20170407151422.GA22875@redhat.com>
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
Cc: dm-devel@redhat.com, Dmitry Bilunov <kmeaw@yandex-team.ru>, Sami Tolvanen <samitolvanen@google.com>, Joe Thornber <ejt@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit 4495c08e84729385774601b5146d51d9e5849f81:

  Linux 4.11-rc2 (2017-03-12 14:47:08 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/dm-4.11-fixes-2

for you to fetch changes up to 86e3e83b443669dd2bcc5c8a83b23e3aa0694c0d:

  dm verity fec: fix bufio leaks (2017-03-31 15:44:25 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Two stable@ fixes for the verity target's FEC support

- A stable@ fix for raid target's raid1 support (when no bitmap is used)

- A 4.11 cache metadata v2 format fix to properly test blocks are clean

----------------------------------------------------------------
Dmitry Bilunov (1):
      dm raid: fix NULL pointer dereference for raid1 without bitmap

Joe Thornber (1):
      dm cache metadata: fix metadata2 format's blocks_are_clean_separate_dirty

Sami Tolvanen (2):
      dm verity fec: limit error correction recursion
      dm verity fec: fix bufio leaks

 drivers/md/dm-cache-metadata.c |  8 +++++---
 drivers/md/dm-raid.c           |  2 +-
 drivers/md/dm-verity-fec.c     | 18 ++++++++++++++----
 drivers/md/dm-verity-fec.h     |  4 ++++
 4 files changed, 24 insertions(+), 8 deletions(-)
