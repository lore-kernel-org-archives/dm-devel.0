From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv5 0/6] dm-multipath: push back requests instead
	of queueing
Date: Mon,  3 Feb 2014 13:34:51 +0100
Message-ID: <1391430897-102094-1-git-send-email-hare@suse.de>
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
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Hi all,

dm-multipath still carries around it's own queueing framework for
implementing 'queue_if_no_path'.
However, there is no real reason for this; we could as well
push back the requests onto the request_queue.
In doing so we can also reduce the memory pressure during
fail_if_no_path scenarios, as we don't have to allocate a
context for each request when it need to be requeued.

Changes since v3:
- Include dm_md_get_queue(), as suggested from Mike Snitzer
- Call __pg_init_all_paths() in pg_init_done() to handle
  pg_init_required correctly, as suggested by Jun'ichi Nomura

Changes since v4:
- Fixup calls to __pg_init_all_paths() as found by
  Jun'ichi Nomura
- Update description for 'remove process_queue_ios' patch

Hannes Reinecke (5):
  dm-multipath: Do not call pg_init twice
  dm-multipath: push back requests instead of queueing
  dm-multipath: remove process_queued_ios()
  dm-multipath: reduce memory pressure during requeuing
  dm-multipath: remove map_io()

Mike Snitzer (1):
  dm: implement dm_md_get_queue()

 drivers/md/dm-mpath.c         | 208 ++++++++++++++----------------------------
 drivers/md/dm-table.c         |  14 +++
 drivers/md/dm.c               |   5 +
 drivers/md/dm.h               |   1 +
 include/linux/device-mapper.h |   5 +
 5 files changed, 93 insertions(+), 140 deletions(-)

-- 
1.7.12.4
