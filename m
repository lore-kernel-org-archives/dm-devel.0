From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fix for 5.2-rc2
Date: Tue, 21 May 2019 19:38:45 -0400
Message-ID: <20190521233844.GA31426@redhat.com>
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, Michael Lass <bevan@bi-co.net>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit 8454fca4f53bbe5e0a71613192674c8ce5c52318:

  dm: fix a couple brace coding style issues (2019-05-16 10:09:21 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.2/dm-fix-1

for you to fetch changes up to 51b86f9a8d1c4bb4e3862ee4b4c5f46072f7520d:

  dm: make sure to obey max_io_len_target_boundary (2019-05-21 19:15:20 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Fix a particularly glaring oversight in a DM core commit from 5.1 that
  doesn't properly trim special IOs (e.g. discards) relative to
  corresponding target's max_io_len_target_boundary().

----------------------------------------------------------------
Michael Lass (1):
      dm: make sure to obey max_io_len_target_boundary

 drivers/md/dm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)
