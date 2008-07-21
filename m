From: Alasdair G Kergon <agk@redhat.com>
Subject: [git pull] device-mapper update for 2.6.27
Date: Mon, 21 Jul 2008 12:09:58 +0100
Message-ID: <20080721110958.GF24157@agk.fab.redhat.com>
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
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Julia Lawall <julia@diku.dk>, Richard Kennedy <richard@rsk.demon.co.uk>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Please pull from:

  master.kernel.org:/pub/scm/linux/kernel/git/agk/linux-2.6-dm.git

to get the following device-mapper update for 2.6.27:

Adrian Bunk (1):
      dm log: make dm_dirty_log init and exit static

Alasdair G Kergon (1):
      dm mpath: fix test for reinstate_path

Mikulas Patocka (5):
      dm mpath: free path selector on invalid args
      dm mpath: return parameter error
      dm snapshot: track snapshot reads
      dm snapshot: fix race during exception creation
      dm snapshot: use per device mempools

Milan Broz (4):
      dm: introduce merge_bvec_fn
      dm: linear add merge
      dm table: remove merge_bvec sector restriction
      dm crypt: add merge

Richard Kennedy (1):
      dm io: remove struct padding

 drivers/md/dm-crypt.c         |   18 ++++-
 drivers/md/dm-linear.c        |   38 ++++++++-
 drivers/md/dm-log.c           |    4 +-
 drivers/md/dm-mpath.c         |   10 ++-
 drivers/md/dm-snap.c          |  163 +++++++++++++++++++++++++++++++++++------
 drivers/md/dm-snap.h          |   11 +++
 drivers/md/dm-table.c         |   13 ++--
 drivers/md/dm.c               |   46 +++++++++++-
 drivers/md/dm.h               |    6 --
 include/linux/device-mapper.h |    6 ++
 include/linux/dm-ioctl.h      |    4 +-
 11 files changed, 270 insertions(+), 49 deletions(-)
  
Alasdair
-- 
agk@redhat.com
