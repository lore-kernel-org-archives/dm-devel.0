From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 0/8] dm: changes staged in linux-next for 5.1 so
	far
Date: Tue, 19 Feb 2019 17:17:13 -0500
Message-ID: <20190219221721.29830-1-snitzer@redhat.com>
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

I seized on Mikulas's noclone patches and took it upon myself to add
noclone support to bio-based dm-multipath.  Pretty happy with how
things turned out but also open to all review/feedback.

I've verified that all mptest tests pass (with tcmloop, mptest's
nvmefcloop based test setup panics with 5.0-rc6.. I should probably
report and/or fix that).

I've yet to do the before vs after multipath benchmarking to see if
there is a performance win but I'm betting there will be (otherwise I
wouldn't have done this work).  I'll backfill benchmarking results
later in the week.

Mike Snitzer (6):
  dm: update dm_process_bio() to split bio if in ->make_request_fn()
  dm: eliminate 'split_discard_bios' flag from DM target interface
  dm: improve noclone bio support
  dm: add the ability to attach per-bio-data to dm_noclone bio
  dm: improve noclone_endio() to support multipath target
  dm mpath: add support for dm_noclone and its per-bio-data

Mikulas Patocka (2):
  dm: refactor start_io_acct and end_io_acct
  dm: implement noclone optimization for bio-based

 drivers/md/dm-cache-target.c  |   1 -
 drivers/md/dm-core.h          |   1 +
 drivers/md/dm-linear.c        |   1 +
 drivers/md/dm-mpath.c         |  65 ++++++--
 drivers/md/dm-raid.c          |  14 +-
 drivers/md/dm-stripe.c        |   1 +
 drivers/md/dm-table.c         |  11 ++
 drivers/md/dm-thin.c          |   1 -
 drivers/md/dm-zero.c          |   1 +
 drivers/md/dm-zoned-target.c  |   1 -
 drivers/md/dm.c               | 357 +++++++++++++++++++++++++++++-------------
 drivers/md/dm.h               |   1 +
 include/linux/device-mapper.h |  22 ++-
 13 files changed, 346 insertions(+), 131 deletions(-)

-- 
2.15.0
