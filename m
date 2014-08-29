From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fix for 3.17
Date: Fri, 29 Aug 2014 08:41:28 -0400
Message-ID: <20140829124128.GA28291@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit 52addcf9d6669fa439387610bc65c92fa0980cef:

  Linux 3.17-rc2 (2014-08-25 15:36:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/dm-3.17-fix

for you to fetch changes up to d49ec52ff6ddcda178fc2476a109cf1bd1fa19ed:

  dm crypt: fix access beyond the end of allocated space (2014-08-28 14:24:09 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
Fix 3.17-rc1 regression introduced by switching the DM crypt target to
using per-bio data.

----------------------------------------------------------------
Mikulas Patocka (1):
      dm crypt: fix access beyond the end of allocated space

 drivers/md/dm-crypt.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)
