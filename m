From: Milan Broz <mbroz@redhat.com>
Subject: Re: Re: 2.6.24 Kernel Soft Lock Up with heavy I/O
	in	dm-crypt
Date: Sat, 01 Mar 2008 20:33:35 +0100
Message-ID: <47C9AF8F.2050502@redhat.com>
References: <200802281924.03996.rrs@researchut.com>	<20080228232048.51e28c1d.akpm@linux-foundation.org>	<20080229184649.GJ1788@agk.fab.redhat.com>	<200803010029.18320.rrs@researchut.com>
	<47C9AEF3.7040507@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <47C9AEF3.7040507@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Ritesh Raj Sarraf <rrs@researchut.com>, Herbert Xu <herbert@gondor.apana.org.au>, dm-crypt@saout.de, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, Alasdair G Kergon <agk@redhat.com>, Christophe Saout <christophe@saout.de>
List-Id: dm-devel.ids

(the same patch for 2.6.24)

Milan
--
Add cond_resched() to prevent stuck in big bio processing.

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 drivers/md/dm-crypt.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.24.3/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.24.3.orig/drivers/md/dm-crypt.c	2008-02-26 01:20:20.000000000 +0100
+++ linux-2.6.24.3/drivers/md/dm-crypt.c	2008-03-01 16:46:24.000000000 +0100
@@ -374,6 +374,7 @@ static int crypt_convert(struct crypt_co
 			break;
 
 		ctx->sector++;
+		cond_resched();
 	}
 
 	return r;
