From: Alasdair G Kergon <agk@redhat.com>
Subject: [git pull] Additional device-mapper patches for 2.6.28
Date: Tue, 21 Oct 2008 17:59:01 +0100
Message-ID: <20081021165901.GO5098@agk.fab.redhat.com>
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
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Heinz Mauelshagen <mauelshagen@redhat.com>, stable@kernel.org, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Please pull from:

  master.kernel.org:/pub/scm/linux/kernel/git/agk/linux-2.6-dm.git
 
to get the following additional device-mapper patches for 2.6.28:
  
Alasdair G Kergon (1):
      dm exception store: refactor zero_area

Heinz Mauelshagen (1):
      dm raid1: separate region_hash interface part1

Kazuo Ito (1):
      dm kcopyd: avoid queue shuffle

Kiyoshi Ueda (2):
      dm: remove unused flush_all
      dm: tidy local_init

Martin K. Petersen (1):
      dm: mark split bio as cloned

Mikulas Patocka (5):
      dm snapshot: fix primary_pe race
      dm snapshot: drop unused last_percent
      dm exception store: fix misordered writes
      dm: publish array_too_big
      dm: remove dm header from targets

Milan Broz (3):
      dm crypt: tidy sector
      dm crypt: fix async split
      dm crypt: remove waitqueue

 drivers/md/Makefile             |    2 +-
 drivers/md/dm-crypt.c           |   56 +++-
 drivers/md/dm-delay.c           |    3 +-
 drivers/md/dm-exception-store.c |  108 ++++--
 drivers/md/dm-io.c              |    2 +-
 drivers/md/dm-kcopyd.c          |   14 +-
 drivers/md/dm-linear.c          |    2 +-
 drivers/md/dm-log.c             |    2 +-
 drivers/md/dm-mpath.c           |    3 +-
 drivers/md/dm-path-selector.c   |    3 +-
 drivers/md/dm-raid1.c           |  791 +++++----------------------------------
 drivers/md/dm-region-hash.c     |  704 ++++++++++++++++++++++++++++++++++
 drivers/md/dm-round-robin.c     |    3 +-
 drivers/md/dm-snap.c            |   11 +-
 drivers/md/dm-snap.h            |    5 +-
 drivers/md/dm-stripe.c          |    6 +-
 drivers/md/dm-zero.c            |    2 +-
 drivers/md/dm.c                 |   49 +--
 drivers/md/dm.h                 |    9 -
 include/linux/device-mapper.h   |    3 +
 include/linux/dm-region-hash.h  |  104 +++++
 21 files changed, 1084 insertions(+), 798 deletions(-)
 create mode 100644 drivers/md/dm-region-hash.c
 create mode 100644 include/linux/dm-region-hash.h

Thanks,
Alasdair
-- 
agk@redhat.com
