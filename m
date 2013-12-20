From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH for-next 00/20] dm: current patches queued in
	linux-dm.git for-next
Date: Fri, 20 Dec 2013 18:37:13 -0500
Message-ID: <1387582653-13647-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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

I've pushed these changes to linux-dm.git's for-next branch.  The
first 2 will likely still go to Linus for 3.13.  But the others are
all for 3.14.  Any of these patches can be modified/rebased/etc so
please shout if you see something you don't like.  Also please shout
if there is a patch you don't see queued but feel it should be (Hannes
I haven't gotten to your dm-mpath invalid paths patch yet, sorry).

I put a lot of work into fixing the thinp target's handling of
-ENOSPC.  I'd appreciate it if reviewers interested in this area would
put particular focus on patch 18: "dm thin: fix pool_preresume resize
with heavy IO races".

Happy Holidays,
Mike

Joe Thornber (5):
  dm thin: fix discard support to a previously shared block
  dm thin: return error from alloc_data_block if pool is not in write mode
  dm thin: factor out check_low_water_mark and use bools
  dm thin: handle metadata failures more consistently
  dm cache policy mq: introduce three promotion threshold tunables

Mike Snitzer (12):
  dm thin: initialize dm_thin_new_mapping returned by get_next_mapping
  dm space map metadata: limit errors in sm_metadata_new_block
  dm persistent data: cleanup dm-thin specific references in text
  dm thin: use bool rather than unsigned for flags in structures
  dm thin: add mappings to end of prepared_* lists
  dm thin: log info when growing the data or metadata device
  dm thin: cleanup and improve no space handling
  dm thin: requeue bios to DM core if no_free_space and in read-only mode
  dm thin: add error_if_no_space feature
  dm thin: eliminate the no_free_space flag
  dm thin: fix set_pool_mode exposed pool operation races
  dm thin: fix pool_preresume resize with heavy IO races

Mikulas Patocka (2):
  dm table: remove unused buggy code that extends the targets array
  dm delay: use per-bio data instead of a mempool and slab cache

Wei Yongjun (1):
  dm cache policy mq: use list_del_init instead of list_del + INIT_LIST_HEAD

 Documentation/device-mapper/cache-policies.txt     |  16 +-
 Documentation/device-mapper/thin-provisioning.txt  |   7 +
 drivers/md/Kconfig                                 |   6 +-
 drivers/md/dm-cache-policy-mq.c                    |  67 ++--
 drivers/md/dm-delay.c                              |  35 +-
 drivers/md/dm-table.c                              |  22 +-
 drivers/md/dm-thin-metadata.c                      |  55 ++++
 drivers/md/dm-thin-metadata.h                      |   7 +-
 drivers/md/dm-thin.c                               | 358 ++++++++++++++-------
 drivers/md/persistent-data/dm-block-manager.c      |   2 +-
 drivers/md/persistent-data/dm-space-map-metadata.c |   4 +-
 11 files changed, 378 insertions(+), 201 deletions(-)

-- 
1.8.1.4
