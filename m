From: Alasdair G Kergon <agk@redhat.com>
Subject: [git pull] device-mapper regression fixes for 2.6.27
Date: Wed, 1 Oct 2008 17:24:18 +0100
Message-ID: <20081001162417.GE5098@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Please pull from:

  master.kernel.org:/pub/scm/linux/kernel/git/agk/linux-2.6-dm.git

to get the following device-mapper fixes for 2.6.27:

Chandra Seetharaman (1):
      dm mpath: add missing path switching locking

Mikulas Patocka (2):
      dm: always allow one page in dm_merge_bvec
      dm: cope with access beyond end of device in dm_merge_bvec

 drivers/md/dm-mpath.c |   16 +++++++++++++++-
 drivers/md/dm.c       |   12 ++++++++----
 2 files changed, 23 insertions(+), 5 deletions(-)

Alasdair
-- 
agk@redhat.com
