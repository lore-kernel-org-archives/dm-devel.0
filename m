From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv7 0/7] dm-multipath: push back requests instead
	of queueing
Date: Tue,  4 Feb 2014 11:54:33 +0100
Message-ID: <1391511280-29325-1-git-send-email-hare@suse.de>
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

here's now an updated patchset, which includes the comments/modifications
from Jun'ichi.

I've also updated your last patch to remove the last layer of indentation;
it's now far clearer to read.

And I've attached the 'Reviewed-By' tags from Jun'ichi where applicable.

Hannes Reinecke (5):
  dm mpath: do not call pg_init when it is already running
  dm mpath: push back requests instead of queueing
  dm mpath: remove process_queued_ios()
  dm mpath: reduce memory pressure when requeuing
  dm mpath: remove map_io()

Mike Snitzer (2):
  dm table: add dm_table_run_md_queue_async
  dm mpath: remove extra nesting in map function

 drivers/md/dm-mpath.c         | 208 ++++++++++++++----------------------------
 drivers/md/dm-table.c         |  19 ++++
 drivers/md/dm.c               |   5 +
 drivers/md/dm.h               |   1 +
 include/linux/device-mapper.h |   5 +
 5 files changed, 101 insertions(+), 137 deletions(-)

-- 
1.7.12.4
