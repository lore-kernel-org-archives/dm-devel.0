From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v6 0/7] dm-multipath: push back requests instead
	of queueing
Date: Mon,  3 Feb 2014 15:28:39 -0500
Message-ID: <1391459326-21569-1-git-send-email-snitzer@redhat.com>
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
To: Hannes Reinecke <hare@suse.de>
Cc: Junichi Nomura <j-nomura@ce.jp.nec.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Hannes,

I went over all of your patches and made a few tweaks, comments, and
improvements along the way.  Patch headers were modified very
slightly.

I wasn't seeing the need for (m->queue_io << 1) + m->queue_if_no_path
in v5's "[PATCH 3/6] dm-multipath: push back requests instead of
queueing" so I simplified that and documented the change in the
header.  If there is a reason for what you had please explain.

Patch 7 offers and incremental cleanup that builds on your v5
patchset.

I can rebase/modify any aspect of these patches so please just let me
know if there is something that needs changing.

Jun'ichi, I didn't add any tag for your contributions to this patchset
(either Acked-by or Reviewed-by) but I'd like you to reply to this
v6 patchset with those if you're OK with these changes.

Thanks,
Mike

Hannes Reinecke (5):
  dm mpath: do not call pg_init when it is already running
  dm mpath: push back requests instead of queueing
  dm mpath: remove process_queued_ios()
  dm mpath: reduce memory pressure when requeuing
  dm mpath: remove map_io()

Mike Snitzer (2):
  dm table: add dm_table_run_md_queue_async
  dm mpath: remove extra nesting in map function when path exists

 drivers/md/dm-mpath.c         | 208 ++++++++++++++----------------------------
 drivers/md/dm-table.c         |  19 ++++
 drivers/md/dm.c               |   5 +
 drivers/md/dm.h               |   1 +
 include/linux/device-mapper.h |   5 +
 5 files changed, 100 insertions(+), 138 deletions(-)

-- 
1.8.1.4
