From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 0/9] dm: changes staged in linux-next for 5.1
	so far
Date: Wed, 20 Feb 2019 16:44:27 -0500
Message-ID: <20190220214436.38476-1-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

This v2 eliminates the dm-mpath local cache for per-bio-data and
switches to allocating the target required per-bio-data as part of the
'struct dm_noclone' allocation -- special thanks to Mikulas for his
ideas and patch (#6) that went into this v2.

Test results show a slight improvement for bio-based dm-multipath (but
not the kind of win dm-linear gets from switching to noclone):

   linear: raw=6087MB/s clone=4241MB/s noclone=5148MB/s
   mpath:  raw=6087MB/s clone=3331MB/s noclone=3420MB/s

More work is needed to improve DM multipath performance (story of my
life)... but at least this shifts the focus away from DM core and back
to the dm-multipath target code.

Mike Snitzer (6):
  dm: update dm_process_bio() to split bio if in ->make_request_fn()
  dm: eliminate 'split_discard_bios' flag from DM target interface
  dm: improve noclone bio support
  dm: improve noclone_endio() to support multipath target
  dm mpath: enable noclone support for bio-based
  dm: remove unused _rq_tio_cache and _rq_cache

Mikulas Patocka (3):
  dm: refactor start_io_acct and end_io_acct
  dm: implement noclone optimization for bio-based
  dm: add per-bio-data support to noclone bio

 drivers/md/dm-cache-target.c  |   1 -
 drivers/md/dm-linear.c        |   3 +-
 drivers/md/dm-mpath.c         |  13 +-
 drivers/md/dm-raid.c          |  14 +-
 drivers/md/dm-rq.c            |  16 ++
 drivers/md/dm-rq.h            |  16 --
 drivers/md/dm-stripe.c        |   3 +-
 drivers/md/dm-table.c         |  11 ++
 drivers/md/dm-thin.c          |   1 -
 drivers/md/dm-zero.c          |   1 +
 drivers/md/dm-zoned-target.c  |   1 -
 drivers/md/dm.c               | 406 ++++++++++++++++++++++++++++--------------
 drivers/md/dm.h               |   1 +
 include/linux/device-mapper.h |   9 +-
 include/uapi/linux/dm-ioctl.h |   4 +-
 15 files changed, 330 insertions(+), 170 deletions(-)

-- 
2.15.0
