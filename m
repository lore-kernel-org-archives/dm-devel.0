From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 4.12 final
Date: Thu, 29 Jun 2017 16:13:19 -0400
Message-ID: <20170629201319.GA19968@redhat.com>
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
Cc: Vallish Vaidyeshwara <vallish@amazon.com>, Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit feb7695fe9fb83084aa29de0094774f4c9d4c9fc:

  dm io: fix duplicate bio completion due to missing ref count (2017-06-21 12:04:50 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-4.12/dm-fixes-5

for you to fetch changes up to 00a0ea33b495ee6149bf5a77ac5807ce87323abb:

  dm thin: do not queue freed thin mapping for next stage processing (2017-06-27 15:14:34 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- A dm thinp fix for crash that will occur when metadata device failure
  races with discard passdown to the underlying data device.

- A dm raid fix to not access the superblock's >= 1.9.0 'sectors' member
  unconditionally.

----------------------------------------------------------------
Heinz Mauelshagen (1):
      dm raid: fix oops on upgrading to extended superblock format

Vallish Vaidyeshwara (1):
      dm thin: do not queue freed thin mapping for next stage processing

 drivers/md/dm-raid.c | 17 ++++++++++++++---
 drivers/md/dm-thin.c | 26 +++++++++++++-------------
 2 files changed, 27 insertions(+), 16 deletions(-)
