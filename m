From: Alasdair G Kergon <agk@redhat.com>
Subject: [git pull] device-mapper fixes for 2.6.31
Date: Fri, 4 Sep 2009 20:52:01 +0100
Message-ID: <20090904195201.GP31998@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Very late in the release cycle I know (due to holidays), sorry, but please
would you pull the following device-mapper fixes from

  master.kernel.org:/pub/scm/linux/kernel/git/agk/linux-2.6-dm.git master

into 2.6.31 if you get this in time?

Jonathan Brassow (4):
      dm log: fix userspace status output
      dm log: remove incorrect field from userspace table output
      dm raid1: do not allow log_failure variable to unset after being set
      dm log: userspace add luid to distinguish between concurrent log instances

Kiyoshi Ueda (1):
      dm multipath: fix oops when request based io fails when no paths

Mike Snitzer (3):
      dm snapshot: implement iterate devices
      dm table: add more context to terse warning messages
      dm stripe: expose correct io hints

Mikulas Patocka (5):
      dm table: fix queue_limit checking device iterator
      dm snapshot: refactor zero_disk_area to use chunk_io
      dm snapshot: fix header corruption race on invalidation
      dm exception store: split set_chunk_size
      dm snapshot: fix on disk chunk size validation

 drivers/md/dm-exception-store.c        |   13 +++++
 drivers/md/dm-exception-store.h        |    4 ++
 drivers/md/dm-log-userspace-base.c     |   39 +++++++++-----
 drivers/md/dm-log-userspace-transfer.c |    6 ++-
 drivers/md/dm-log-userspace-transfer.h |    2 +-
 drivers/md/dm-raid1.c                  |    8 +++-
 drivers/md/dm-snap-persistent.c        |   88 +++++++++++++++++++-------------
 drivers/md/dm-snap.c                   |   23 ++++++++-
 drivers/md/dm-stripe.c                 |   13 ++++-
 drivers/md/dm-table.c                  |   51 ++++++++++++-------
 drivers/md/dm.c                        |   15 ++++--
 include/linux/device-mapper.h          |    4 ++
 include/linux/dm-log-userspace.h       |   13 ++++-
 13 files changed, 198 insertions(+), 81 deletions(-)

Thanks,
Alasdair
-- 
agk@redhat.com
