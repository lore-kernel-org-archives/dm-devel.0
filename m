From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fix for 4.0-rc6
Date: Thu, 26 Mar 2015 17:26:57 -0400
Message-ID: <20150326212657.GA55395@redhat.com>
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

The following changes since commit e5db29806b99ce2b2640d2e4d4fcb983cea115c5:

  dm io: deal with wandering queue limits when handling REQ_DISCARD and REQ_WRITE_SAME (2015-02-27 14:53:32 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm tags/dm-4.0-fix-2

for you to fetch changes up to 63a4f065ece613b6d575b538234375b0e9c23bbc:

  dm: fix add_disk() NULL pointer due to race with free_dev() (2015-03-23 18:14:00 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
. Fix DM core device cleanup regression -- due to a latent race that was
  exposed by the bdi changes that were introduced during the 4.0 merge.

----------------------------------------------------------------
Mike Snitzer (1):
      dm: fix add_disk() NULL pointer due to race with free_dev()

 drivers/md/dm.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)
