From: Keith Busch <keith.busch@intel.com>
Subject: [PATCHv2 0/4] blk-mq support for dm multipath
Date: Fri, 17 Oct 2014 17:46:34 -0600
Message-ID: <1413589598-17631-1-git-send-email-keith.busch@intel.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Keith Busch <keith.busch@intel.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

This series makes device mapper's multipath work with both blk-mq and
the older request_queue based block devices.

As before, I tested with a slightly modified version of Matias' blk-mq
nvme driver with dual ported nvme controller. I'll post the nvme changes
to that list once the blk-mq mpath is good to go.

I've tried to split this into logically separate patches to prep and
support this request_queue type.

Patch [2/4] is a bit of a departure from what was done before, but I
hope something like this is alright.

v1 -> v2:

Micro-optimization setting the cloned rq->bio to null from dm-mpath
instead of blk_mq_rq_ctx_init.

There's no way around getting a request without calling
blk_get_request. Making this API safe in an interrupt disabled context is
troublesome, so submitting the dm request to the target in a different
thread so it is NOT inline with dm's request_fn. We can use GFP_KERNEL
now since the allocation occurs in this new context. I believe this is
okay in both request queue types since neither allocate from general
purpose memory.

In v1, the target would allocate the request and dm would release it. This
duality is somewhat changed: the target's map_rq is still responsible
to allocate since only it knows what request queue to allocate from,
and I've added a new target type function (unmap_rq) to handle releasing.

I fixed the error handling; it was completely untested before and quite
broken. To test, I synthesized 4 different errors: no requests available,
no memory available to the clone bio, invalid target, and completing
requests in low-level driver with an error. All worked as expected on
blk-mq devices.

Keith Busch (4):
  dm: prep initialized requests
  dm: Submit stacked requests in irq enabled context
  dm: Move request allocation to dm_target type
  block: blk-mq support for cloned requests

 block/blk-core.c              |    7 +-
 drivers/md/dm-mpath.c         |   22 ++++--
 drivers/md/dm-target.c        |    9 ++-
 drivers/md/dm.c               |  155 +++++++++++++++++++++--------------------
 include/linux/device-mapper.h |    7 +-
 5 files changed, 112 insertions(+), 88 deletions(-)

-- 
1.7.10.4
