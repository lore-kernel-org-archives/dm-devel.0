From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fix for 4.18-rc6
Date: Fri, 20 Jul 2018 15:14:07 -0400
Message-ID: <20180720191407.GA11868@redhat.com>
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
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following change since commit 021c91791a5e7e85c567452f1be3e4c2c6cb6063:

  Linux 4.18-rc3 (2018-07-01 16:04:53 -0700)

is available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-4.18/dm-fixes-2

for you to fetch up to d284f8248c72d0cb36a930920e60592eb455cd0d:

  dm writecache: support optional offset for start of device (2018-07-02 16:14:02 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Fix DM writecache target to allow an optional offset to the start of
  the data and metadata area.  This allows userspace tools (e.g. LVM2)
  to place a header and metadata at the front of the writecache device
  for its use.

----------------------------------------------------------------
Mikulas Patocka (1):
      dm writecache: support optional offset for start of device

 Documentation/device-mapper/writecache.txt |  2 ++
 drivers/md/dm-writecache.c                 | 43 ++++++++++++++++++++----------
 2 files changed, 31 insertions(+), 14 deletions(-)
