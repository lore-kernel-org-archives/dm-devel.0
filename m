From: Alasdair G Kergon <agk@redhat.com>
Subject: [git pull] device-mapper fixes for 2.6.29
Date: Mon, 16 Mar 2009 19:06:42 +0000
Message-ID: <20090316190642.GH5098@agk.fab.redhat.com>
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
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Huang Ying <ying.huang@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Please pull from:

  master.kernel.org:/pub/scm/linux/kernel/git/agk/linux-2.6-dm.git

to get the following device-mapper fixes for 2.6.29:

Huang Ying (1):
      dm crypt: fix kcryptd_async_done parameter

Mikulas Patocka (2):
      dm table: rework reference counting fix
      dm io: respect BIO_MAX_PAGES limit

Milan Broz (2):
      dm ioctl: validate name length when renaming
      dm crypt: wait for endio to complete before destruction

 drivers/md/dm-crypt.c |   43 +++++++++++++++++++++++++++++++------------
 drivers/md/dm-io.c    |    2 ++
 drivers/md/dm-ioctl.c |    7 ++++---
 drivers/md/dm.c       |   32 +++++++++++++++++++-------------
 4 files changed, 56 insertions(+), 28 deletions(-)

Thanks,
Alasdair
-- 
agk@redhat.com
