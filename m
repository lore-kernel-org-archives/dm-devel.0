From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv3 0/5] dm-multipath: push back requests instead
	of queueing
Date: Fri, 31 Jan 2014 10:10:39 +0100
Message-ID: <1391159444-17987-1-git-send-email-hare@suse.de>
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

This patchset is the third version, including
the review by Jun'ichi Nomura and suggestions from Mike Snitzer.

Hannes Reinecke (5):
  dm-multipath: Do not call pg_init twice
  dm-multipath: push back requests instead of queueing
  dm-multipath: remove process_queued_ios()
  dm-multipath: reduce memory pressure during requeuing
  dm-multipath: remove map_io()

 drivers/md/dm-mpath.c         | 214 +++++++++++++++---------------------------
 drivers/md/dm.c               |  13 +++
 include/linux/device-mapper.h |   1 +
 3 files changed, 88 insertions(+), 140 deletions(-)

-- 
1.7.12.4
