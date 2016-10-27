From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 4.9-rc3
Date: Thu, 27 Oct 2016 19:51:55 -0400
Message-ID: <20161027235155.GA11074@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tahsin Erdogan <tahsin@google.com>, "tang.junhui" <tang.junhui@zte.com.cn>, Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com, Andy Whitcroft <apw@canonical.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit 24532f768121b07b16178ffb40442ece43365cbd:

  Merge branch 'for-4.9/block-smp' of git://git.kernel.dk/linux-block (2016-10-09 17:32:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm tags/dm-4.9-fixes

for you to fetch changes up to dafa724bf582181d9a7d54f5cb4ca0bf8ef29269:

  dm table: fix missing dm_put_target_type() in dm_table_add_target() (2016-10-24 11:17:46 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- A couple DM raid and DM mirror fixes

- A couple .request_fn request-based DM NULL pointer fixes

- A fix for a DM target reference count leak, on target load error, that
  prevented associated DM target kernel module(s) from being removed

----------------------------------------------------------------
Andy Whitcroft (1):
      dm raid: fix compat_features validation

Heinz Mauelshagen (3):
      dm mirror: fix read error on recovery after default leg failure
      dm mirror: use all available legs on multiple failures
      dm raid: fix activation of existing raid4/10 devices

Mike Snitzer (1):
      dm rq: clear kworker_task if kthread_run() returned an error

Tahsin Erdogan (1):
      dm: free io_barrier after blk_cleanup_queue call

tang.junhui (1):
      dm table: fix missing dm_put_target_type() in dm_table_add_target()

 Documentation/device-mapper/dm-raid.txt |  1 +
 drivers/md/dm-raid.c                    | 15 +++++++++------
 drivers/md/dm-raid1.c                   | 22 +++-------------------
 drivers/md/dm-rq.c                      |  7 +++++--
 drivers/md/dm-table.c                   | 24 +++++++++---------------
 drivers/md/dm.c                         |  4 ++--
 6 files changed, 29 insertions(+), 44 deletions(-)
