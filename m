From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5/4] dm-integrity: sleep and retry on allocation errors
Date: Tue, 2 Jun 2020 07:53:05 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2006020752170.25489@file01.intranet.prod.int.rdu2.redhat.com>
References: <20200601160421.912555280@debian-a64.vm>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <20200601160421.912555280@debian-a64.vm>
Sender: linux-crypto-owner@vger.kernel.org
To: Mike Snitzer <msnitzer@redhat.com>, Giovanni Cabiddu <giovanni.cabiddu@intel.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Milan Broz <mbroz@redhat.com>, djeffery@redhat.com
Cc: dm-devel@redhat.com, qat-linux@intel.com, linux-crypto@vger.kernel.org, guazhang@redhat.com, jpittman@redhat.com
List-Id: dm-devel.ids

dm-integrity: sleep and retry on allocation errors

Some hardware crypto drivers use GFP_ATOMIC allocations in the request
routine. These allocations can randomly fail - for example, they fail if
too many network packets are received.

If we propagated the failure up to the I/O stack, it would cause I/O
errors. So, we sleep and retry.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-integrity.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2020-04-05 21:11:02.000000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2020-06-02 13:49:36.000000000 +0200
@@ -859,6 +859,7 @@ static void complete_journal_encrypt(str
 static bool do_crypt(bool encrypt, struct skcipher_request *req, struct journal_completion *comp)
 {
 	int r;
+retry:
 	skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
 				      complete_journal_encrypt, comp);
 	if (likely(encrypt))
@@ -874,6 +875,10 @@ static bool do_crypt(bool encrypt, struc
 		reinit_completion(&comp->ic->crypto_backoff);
 		return true;
 	}
+	if (r == -ENOMEM) {
+		msleep(1);
+		goto retry;
+	}
 	dm_integrity_io_error(comp->ic, "encrypt", r);
 	return false;
 }
