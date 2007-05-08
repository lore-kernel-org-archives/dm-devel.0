From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.22 PATCH 03/26] dm crypt: disable barriers
Date: Tue, 8 May 2007 20:43:52 +0100
Message-ID: <20070508194352.GJ24114@agk.fab.redhat.com>
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
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Milan Broz <mbroz@redhat.com>

Disable barriers in dm-crypt because of current workqueue processing
can reorder requests.

This must be addresed later but for now disabling barriers is needed
to prevent data corruption.

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---

 drivers/md/dm-crypt.c |    3 +++
 1 files changed, 3 insertions(+)

Index: linux-2.6.21/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.21.orig/drivers/md/dm-crypt.c	2007-05-01 17:38:32.000000000 +0100
+++ linux-2.6.21/drivers/md/dm-crypt.c	2007-05-01 17:40:47.000000000 +0100
@@ -954,6 +954,9 @@ static int crypt_map(struct dm_target *t
 	struct crypt_config *cc = ti->private;
 	struct crypt_io *io;
 
+	if (bio_barrier(bio))
+		return -EOPNOTSUPP;
+
 	io = mempool_alloc(cc->io_pool, GFP_NOIO);
 	io->target = ti;
 	io->base_bio = bio;
