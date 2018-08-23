From: John Pittman <jpittman@redhat.com>
Subject: [PATCH 0/3] dm: replace atomic_t reference counters with
	refcount_t
Date: Thu, 23 Aug 2018 13:35:54 -0400
Message-ID: <20180823173557.19665-1-jpittman@redhat.com>
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
To: snitzer@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


This series of patches further integrates the refcount_t API into
the device-mapper layer.  The refcount_t API works to prevent counter
overflows and use-after-free bugs, so should make the
mechanism more robust, and make troubleshooting easier. Adding here
to dm-thin and dm-zoned.

Refcounters changed listed below:
 struct thin_c -> refcount
 struct dmz_bioctx -> ref
 struct dm_chunk_work -> refcount
 struct dmz_mblock -> ref
 struct dm_zone -> refcount

John Pittman (3):
 dm thin: use refcount_t for thin_c reference counting
 dm zoned: metadata: use refcount_t for dm zoned reference
 dm zoned: target: use refcount_t for dm zoned reference

 drivers/md/dm-thin.c | 8 ++++----
 drivers/md/dm-zoned-metadata.c | 25 +++++++++++++------------
 drivers/md/dm-zoned.h          |  2 +-
 drivers/md/dm-zoned-target.c | 20 ++++++++++----------

Best Regards,

John Pittman
Customer Engagement and Experience
Red Hat Inc.
