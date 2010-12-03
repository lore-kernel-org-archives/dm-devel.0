From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 0/4] dm log userspace: a fix and other
	improvements
Date: Fri,  3 Dec 2010 18:12:46 -0500
Message-ID: <1291417970-5626-1-git-send-email-snitzer@redhat.com>
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
To: agk@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Alasdair,

I've reviewed all of these patches from Jon:
- cleaned up all patch headers and subjects a bit
- patch 1 is a fix that should go to 2.6.37
- the others are fine to go to linux-next (and queue for 2.6.38)
- made some changes to patch 3 (uninit 'type' warning, move 'group'
  from end of 'log_c' structure to flush_by_group's stack). Jon may
  clean up the flush_by_group() list processing further but I've added
  a useful comment about the final list_splice_init.

Thanks,
Mike

Jonathan Brassow (4):
  dm log userspace: trap all errors from failed log construction
  dm log userspace: split flush queue
  dm log userspace: group clear and mark requests
  dm log userspace: add version number to communication structure

 drivers/md/dm-log-userspace-base.c     |  130 ++++++++++++++++++++++++++------
 drivers/md/dm-log-userspace-transfer.c |    1 +
 include/linux/dm-log-userspace.h       |   13 +++-
 3 files changed, 119 insertions(+), 25 deletions(-)

-- 
1.7.2.3
