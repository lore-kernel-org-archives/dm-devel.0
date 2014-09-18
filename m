From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 0/2] dm: alternate solution to reloading with
	failed paths
Date: Thu, 18 Sep 2014 12:02:27 -0400
Message-ID: <1411056149-16418-1-git-send-email-snitzer@redhat.com>
References: <1407956023-32372-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1407956023-32372-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: hare@suse.de
Cc: Junichi Nomura <j-nomura@ce.jp.nec.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Hannes,

Here is v2 of Ben's approach to fixing the inability to reload a
multipath table that includes failed paths.  I've staged it in
linux-dm.git's 'for-next' branch.

But I wanted to send this v2 out to verify this approach works for
you.  This approach is focused on allowing failed paths to be pushed
down in a multipath table.

It does _not_ allow non-existent devices to be listed in an mpath
table like your patchset did.  So the aggressive dev_loss_tmo case
isn't covered... but Ben said that case is already handled by
multipathd getting a change event and pushing the table down without
the removed SCSI device(s).

Thoughts?
Mike

Benjamin Marzinski (2):
  dm mpath: stop queueing IO when no valid paths exist
  dm: allow active and inactive tables to share dm_devs

 drivers/md/dm-ioctl.c         |   2 +-
 drivers/md/dm-mpath.c         |   4 +-
 drivers/md/dm-table.c         | 102 ++++++++++++----------------------
 drivers/md/dm.c               | 126 ++++++++++++++++++++++++++++++++++++++++++
 drivers/md/dm.h               |   5 +-
 include/uapi/linux/dm-ioctl.h |   4 +-
 6 files changed, 170 insertions(+), 73 deletions(-)

-- 
1.9.3
