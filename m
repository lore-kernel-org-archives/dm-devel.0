From: Alasdair G Kergon <agk@redhat.com>
Subject: [git pull 00/06] device-mapper fixes for 2.6.24-rc*
Date: Thu, 13 Dec 2007 14:40:04 +0000
Message-ID: <20071213144004.GS24157@agk.fab.redhat.com>
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
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Please pull from:

  master.kernel.org:/pub/scm/linux/kernel/git/agk/linux-2.6-dm.git

to get the following device-mapper fixes for 2.6.24:
 
Alasdair G Kergon (1):
      dm: trigger change uevent on rename

Jun'ichi Nomura (1):
      dm: table detect io beyond device

Milan Broz (2):
      dm crypt: fix write endio
      dm crypt: use bio_add_page

Neil Brown (1):
      dm: merge max_hw_sector

Paul Mundt (1):
      dm mpath: hp requires scsi

 drivers/md/Kconfig            |    2 +-
 drivers/md/dm-crypt.c         |   31 +++++++++++++++----------------
 drivers/md/dm-ioctl.c         |   12 +++++-------
 drivers/md/dm-table.c         |   16 +++++++++++++++-
 drivers/md/dm.c               |   31 ++++++++++++++++++++++++-------
 drivers/md/dm.h               |    7 +++++++
 include/linux/device-mapper.h |    1 +
 7 files changed, 68 insertions(+), 32 deletions(-)

Alasdair
-- 
agk@redhat.com
