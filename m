From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 4.8-rc4
Date: Fri, 26 Aug 2016 13:09:33 -0400
Message-ID: <20160826170933.GA44443@redhat.com>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit fa8410b355251fd30341662a40ac6b22d3e38468:

  Linux 4.8-rc3 (2016-08-21 16:14:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm dm-4.8-fixes-3

for you to fetch changes up to 9c5a559d9495bba6e5b6c5ee4e8e2f2b71088684:

  dm log: fix unitialized bio operation flags (2016-08-24 21:55:05 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Another stable fix for DM flakey (that tweaks the previous fix that
  didn't factor in expected 'drop_writes' behavior for read IO).

- A dm-log bio operation flags fix for the broader block changes that
  were merged during the 4.8 merge window.

----------------------------------------------------------------
Heinz Mauelshagen (1):
      dm log: fix unitialized bio operation flags

Mike Snitzer (1):
      dm flakey: fix reads to be issued if drop_writes configured

 drivers/md/dm-flakey.c | 27 ++++++++++++++++-----------
 drivers/md/dm-log.c    | 11 ++++++-----
 2 files changed, 22 insertions(+), 16 deletions(-)
