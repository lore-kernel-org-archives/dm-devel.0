From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Device-mapper misc cleanup
Date: Mon, 19 Mar 2012 16:53:45 +0100
Message-ID: <1332172428-35948-1-git-send-email-hare@suse.de>
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
Cc: Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

This is small patchset for some cleanups I've found during
debugging other issues:

- Zero out bi_end_io: I always find it more convenient to
  explictly zero out things we've set previously. No harm
  done, but possibly easier debugging.
- Simplify call to free_devices(): free_devices() already
  does a list_for_each(), so we don't have to check for
  list_empty...
- Delayed cleanup for dm_table_destroy(): We have krefs
  in the kernel, which does exactly what we want. And I
  fail to see why we can't use them here. Plus we're
  saving an msleep ...

Hannes Reinecke (3):
  dm: zero out bi_end_io on remapping failure
  dm-table: simplify call to free_devices()
  dm-table: delayed cleanup for dm_table_destroy()

 drivers/md/dm-table.c |   29 ++++++++++++++---------------
 drivers/md/dm.c       |    1 +
 2 files changed, 15 insertions(+), 15 deletions(-)
