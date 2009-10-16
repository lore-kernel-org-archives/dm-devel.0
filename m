From: Alasdair G Kergon <agk@redhat.com>
Subject: [git pull] device-mapper fixes for 2.6.32-rc6
Date: Fri, 16 Oct 2009 23:22:24 +0100
Message-ID: <20091016222224.GF6208@agk-dp.fab.redhat.com>
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
Cc: Andrew Morton <akpm@osdl.org>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Please pull from:

  master.kernel.org:/pub/scm/linux/kernel/git/agk/linux-2.6-dm.git master

to get the following device-mapper fixes for inclusion in 2.6.32-rc6:

Andrew Morton (1):
      dm log: userspace fix incorrect luid cast in userspace_ctr

Jonathan Brassow (1):
      dm snapshot: free exception store on init failure

Kiyoshi Ueda (1):
      dm: dec_pending needs locking to save error value

Mikulas Patocka (6):
      dm snapshot: sort by chunk size to fix race
      dm snapshot: require non zero chunk size by end of ctr
      dm exception store: fix failed set_chunk_size error path
      dm snapshot: lock snapshot while supplying status
      dm snapshot: use unsigned integer chunk size
      dm snapshot: allow chunk size to be less than page size

Zdenek Kabelac (1):
      dm: add missing del_gendisk to alloc_dev error path

 drivers/md/dm-exception-store.c    |   38 +++++++++++------------------------
 drivers/md/dm-exception-store.h    |    8 +++---
 drivers/md/dm-log-userspace-base.c |    2 +-
 drivers/md/dm-snap-persistent.c    |   16 +++++++-------
 drivers/md/dm-snap.c               |   25 +++++++++++++++++++---
 drivers/md/dm.c                    |   11 ++++++++-
 6 files changed, 55 insertions(+), 45 deletions(-)

Alasdair
-- 
agk@redhat.com
