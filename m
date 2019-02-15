From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 5.0 final
Date: Fri, 15 Feb 2019 09:38:32 -0500
Message-ID: <20190215143832.GA20900@redhat.com>
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Nikos Tsironis <ntsironis@arrikto.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit d13937116f1e82bf508a6325111b322c30c85eb9:

  Linux 5.0-rc6 (2019-02-10 14:42:20 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.0/dm-fixes-3

for you to fetch changes up to 4ae280b4ee3463fa57bbe6eede26b97daff8a0f1:

  dm thin: fix bug where bio that overwrites thin block ignores FUA (2019-02-14 19:02:29 -0500)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Fix bug in DM crypt's sizing of its block integrity tag space,
  resulting in less memory use when DM crypt layers on DM integrity.

- Fix a long-standing DM thinp crash consistency bug that was due to
  improper handling of FUA.  This issue is specific to writes that
  fill an entire thinp block which needs to be allocated.

----------------------------------------------------------------
Mikulas Patocka (1):
      dm crypt: don't overallocate the integrity tag space

Nikos Tsironis (1):
      dm thin: fix bug where bio that overwrites thin block ignores FUA

 drivers/md/dm-crypt.c |  2 +-
 drivers/md/dm-thin.c  | 55 ++++++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 51 insertions(+), 6 deletions(-)
