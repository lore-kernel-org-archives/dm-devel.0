From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 0/2] dm: restrict conflicting table loads and
	improve queue initialization
Date: Tue, 25 May 2010 10:43:11 -0400
Message-ID: <1274798593-19418-1-git-send-email-snitzer@redhat.com>
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
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

A mapped_device now has a specific immutable type (md->type) that is
set during the initial table_load (see: patch 1/2).

The DM device's request_queue will only have an elevator allocated and
exposed via sysfs if it is request-based (see: patch 2/2).

Please see the individual patch headers for more details.
(Kiyoshi, if you approve please reply with your "Acked-by" :)

This patchset is based on agk's DM "editing" tree:
http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/
(apply all patches listed in the series file up to NEXT_PATCHES_END)

This patchset also depends on the following linux-2.6-block.git
'for-linus' branch commits:
01effb0 block: allow initialization of previously allocated request_queue
e36f724 block: Adjust elv_iosched_show to return "none" for bio-based DM

I've made a full quilt series available here (builds on 2.6.34):
http://people.redhat.com/msnitzer/patches/dm-queue-init/latest/

A monolithic patch is also available here:
http://people.redhat.com/msnitzer/patches/dm-queue-init/latest/monolithic.patch

I welcome all comments/review.

v3 changes:
- reduce table_load's md->type_lock protected critical section
- only call dm_setup_md_queue on first table load
  - simplified dm_setup_md_queue as a result
- use existing DM_TYPE_* definitions instead of duplicating them
- eliminate overly verbose comments as the code speaks for itself much
  more clearly

v2 changes:
- remove do_resume and table_clear interlock
- rebase to agk's latest "editing" tree
- drop the dm_get_verified_mdptr and find_device_noinit patches that
  were at the end of v1; can revisit that code duplication cleanup later

Mike Snitzer (2):
  dm: prevent table type changes after initial table load
  dm: only initialize full request_queue for request-based device

 drivers/md/dm-ioctl.c |   24 +++++++++
 drivers/md/dm.c       |  131 +++++++++++++++++++++++++++++++++++++------------
 drivers/md/dm.h       |    7 +++
 3 files changed, 130 insertions(+), 32 deletions(-)
