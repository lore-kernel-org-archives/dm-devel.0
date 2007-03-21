From: Olaf Kirch <okir@lst.de>
Subject: [PATCH 2/3] Do not access the bio after
	generic_make_request
Date: Wed, 21 Mar 2007 08:06:44 +0100
Message-ID: <200703210806.45522.okir@lst.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
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
To: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: dm-devel.ids

Do not access the bio after generic_make_request

We should never access a bio after generic_make_request - there's
no guarantee it still exists.

Signed-off-by: olaf.kirch@oracle.com
---
 drivers/md/dm-crypt.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6.20/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.20.orig/drivers/md/dm-crypt.c
+++ linux-2.6.20/drivers/md/dm-crypt.c
@@ -655,9 +655,12 @@ static void process_write(struct crypt_i
 
 		generic_make_request(clone);
 
+		/* Do not reference clone after this - it
+		 * may be gone already. */
+
 		/* out of memory -> run queues */
 		if (remaining)
-			congestion_wait(bio_data_dir(clone), HZ/100);
+			congestion_wait(WRITE, HZ/100);
 	}
 }
 

-- 
Olaf Kirch  |  --- o --- Nous sommes du soleil we love when we play
okir@lst.de |    / | \   sol.dhoop.naytheet.ah kin.ir.samse.qurax
