From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv9 0/8] dm-multipath: push back requests instead
	of queueing
Date: Fri, 28 Feb 2014 15:33:41 +0100
Message-ID: <1393598029-67995-1-git-send-email-hare@suse.de>
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

Hi Mike,

here's version 9 of the patchset which might just be the
final one. I've included the remaining issue Jun'ichi pointed
out, and added the respective 'reviewed-by' tags where missing.

Hannes Reinecke (6):
  dm mpath: do not call pg_init when it is already running
  dm mpath: push back requests instead of queueing
  dm mpath: remove process_queued_ios()
  dm mpath: reduce memory pressure when requeuing
  dm mpath: remove map_io()
  dm-mpath: do not activate failed paths

Mike Snitzer (2):
  dm table: add dm_table_run_md_queue_async
  dm mpath: remove extra nesting in map function

 drivers/md/dm-mpath.c         | 213 +++++++++++++++---------------------------
 drivers/md/dm-table.c         |  19 ++++
 drivers/md/dm.c               |   5 +
 drivers/md/dm.h               |   1 +
 include/linux/device-mapper.h |   5 +
 5 files changed, 105 insertions(+), 138 deletions(-)

-- 
1.7.12.4
