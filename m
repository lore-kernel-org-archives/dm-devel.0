From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 0/6] dm: restrict conflicting table loads and
	improve queue initialization
Date: Sun, 23 May 2010 17:44:55 -0400
Message-ID: <1274651101-9784-1-git-send-email-snitzer@redhat.com>
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

This work has expanded in scope somewhat (based on Mikulas' suggestion
that I pursue more constrained table/device type switching to avoid
Kiyoshi's locking concerns).  A mapped_device now has a specific type
(md->type) that is managed in table_{load,clear} (see patch 3/6).

It should be noted that patch 4/6 is labeled "v8".  I still believe
v7's locking strategy is _not_ prone to problematic deadlock, as I
detailed/questioned here: http://lkml.org/lkml/2010/5/21/175
v7 is still available for viewing here:
https://patchwork.kernel.org/patch/101270/

But this new series eliminates v7's locking between table_load() and
do_resume() -- fixed md->type made this possible.  So these changes
may be more desirable overall (adds some clearer exclusion and state
transitions that I feel help DM without being too restrictive).

Please see the individual patch headers for more details.

A monolithic patch is also available here:
http://people.redhat.com/msnitzer/patches/dm-queue-init/monolithic.patch

I welcome all comments/review.  Hopefully others will find that what
I've done is worthwhile.

Mike Snitzer (6):
  block: Adjust elv_iosched_show to return "none" for bio-based DM
  dm ioctl: interlock resume and table clear
  dm: prevent table type changes after initial table load
  dm: only initialize full request_queue for request-based device
  dm ioctl: introduce dm_get_verified_mdptr
  dm ioctl: introduce find_device_noinit

 block/elevator.c      |    2 +-
 drivers/md/dm-ioctl.c |  148 +++++++++++++++++++++++++++------
 drivers/md/dm.c       |  216 +++++++++++++++++++++++++++++++++++++++++-------
 drivers/md/dm.h       |   12 +++
 4 files changed, 318 insertions(+), 60 deletions(-)
