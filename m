From: Hannes Reinecke <hare@suse.de>
Subject: [RFC PATCH 0/7] dm-mpath: Do not clone requests
Date: Thu,  5 Jun 2014 15:11:00 +0200
Message-ID: <1401973867-121561-1-git-send-email-hare@suse.de>
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
To: Alasdair Kergon <agk@redhat.com>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Hi all,

this is a patchset I made some time ago to remove the
'insane request cloning' from dm-multipath.

Currently, multipath clones each request + attached bios before sending
them down to the underlying path. This not only increases the memory
requirements, but also leads to quite some interesting interactions
with the block layer.

This RFC pursues an alternative approach, leaving the request as-is
and just modify the rq_end_io handler to call the correct end_io function.
As the rq_end_io is called _before_ any bio_endio handler there is no
need to clone the bios nor the bio_endio handler.

In theory. This is just a test balloon to get some response.
I never got around to actually _test_ it. You have been warned.

Hannes Reinecke (7):
  dm: use dm_rq_target_io as argument for dm_done()
  dm: remove handling of DM_ENDIO_INCOMPLETE
  dm: move rq_completed() out of enclosing functions
  dm: open-code dm_kill_unmapped_request()
  dm: move free_rq_clone() out of dm_unprep_request()
  dm: open-code free_rq_clone()
  dm: do not clone requests

 drivers/md/dm.c               | 337 +++++++++---------------------------------
 include/linux/device-mapper.h |   1 -
 2 files changed, 73 insertions(+), 265 deletions(-)

-- 
1.7.12.4
