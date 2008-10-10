From: Alasdair G Kergon <agk@redhat.com>
Subject: [git pull] device-mapper patches for 2.6.28
Date: Fri, 10 Oct 2008 13:51:59 +0100
Message-ID: <20081010125159.GK5098@agk.fab.redhat.com>
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
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Jens Axboe <jens.axboe@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Please pull from:

  master.kernel.org:/pub/scm/linux/kernel/git/agk/linux-2.6-dm.git

to get the following device-mapper patches for 2.6.28:
 
Alasdair G Kergon (2):
      dm crypt: remove inc_pending from write_io_submit
      dm: detect lost queue

Benjamin Marzinski (1):
      dm mpath: use more error codes

Jonathan Brassow (1):
      dm raid1: kcopyd should stop on error if errors handled

Kiyoshi Ueda (1):
      dm mpath: remove is_active from struct dm_path

Mikulas Patocka (6):
      dm exception store: introduce area_location function
      dm exception store: use chunk_t for_areas
      dm: export struct dm_dev
      dm: publish dm_get_mapinfo
      dm: publish dm_table_unplug_all
      dm: publish dm_vcalloc

Milan Broz (7):
      dm crypt: tidy inc pending
      dm crypt: tidy crypt alloc
      dm crypt: tidy write loop pending
      dm crypt: move dec_pending on error into write_io_submit
      dm crypt: fix async inc_pending
      dm crypt: tidy ctx pending
      dm crypt: avoid unnecessary wait when splitting bio

 drivers/md/dm-crypt.c           |  109 +++++++++++++++++++++++---------------
 drivers/md/dm-exception-store.c |   29 +++++++----
 drivers/md/dm-ioctl.c           |    4 +-
 drivers/md/dm-mpath.c           |   35 +++++++------
 drivers/md/dm-mpath.h           |    2 -
 drivers/md/dm-raid1.c           |    4 +-
 drivers/md/dm-table.c           |   97 ++++++++++++++++++++++------------
 drivers/md/dm.h                 |   10 +---
 include/linux/device-mapper.h   |   18 ++++++-
 9 files changed, 190 insertions(+), 118 deletions(-)

Alasdair
-- 
agk@redhat.com
