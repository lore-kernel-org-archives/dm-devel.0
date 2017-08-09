From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 0/7] Device mapper and dm-mpath fixes
Date: Wed, 9 Aug 2017 11:32:09 -0700
Message-ID: <20170809183216.526-1-bart.vanassche@wdc.com>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: Bart Van Assche <bart.vanassche@wdc.com>, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

Hello Mike,

The patches in this series are what I came up with while analyzing the
soft and hard lockups reported by Laurence Oberman. Please consider
these patches for kernel v4.14.

Thank you,

Bart.

Bart Van Assche (7):
  dm: Fix the second dec_pending() argument in __split_and_process_bio()
  dm: Fix printk() rate limiting code
  dm-mpath: Do not lock up a CPU with requeuing activity
  dm-mpath: Avoid that building with W=1 causes gcc 7 to complain about
    fall-through
  dm-mpath: Complain about unsupported __multipath_map_bio() return
    values
  dm-mpath: Retry BLK_STS_RESOURCE errors
  dm-mpath: Make the dm-sq requeuing behavior consistent with the dm-mq
    behavior

 drivers/md/dm-mpath.c         |  8 ++++++--
 drivers/md/dm-rq.c            |  9 +++++----
 drivers/md/dm.c               | 12 +-----------
 include/linux/device-mapper.h | 41 ++++++++++++-----------------------------
 4 files changed, 24 insertions(+), 46 deletions(-)

-- 
2.13.3
