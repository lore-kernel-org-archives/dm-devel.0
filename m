From: Milan Broz <mbroz@redhat.com>
Subject: Re: Re: 2.6.24 Kernel Soft Lock Up with heavy I/O in
	dm-crypt
Date: Sat, 01 Mar 2008 20:30:59 +0100
Message-ID: <47C9AEF3.7040507@redhat.com>
References: <200802281924.03996.rrs@researchut.com>
	<20080228232048.51e28c1d.akpm@linux-foundation.org>
	<20080229184649.GJ1788@agk.fab.redhat.com>
	<200803010029.18320.rrs@researchut.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200803010029.18320.rrs@researchut.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ritesh Raj Sarraf <rrs@researchut.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, dm-crypt@saout.de, linux-kernel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, akpm@linux-foundation.org, Alasdair G Kergon <agk@redhat.com>, Christophe Saout <christophe@saout.de>
List-Id: dm-devel.ids

Ritesh Raj Sarraf wrote:

> 1) Initialize a device using dm-crypt and LUKS
> 2) Create a filesystem on top of it and mount it.
> 3) Write huge amount of data (as a normal user). Something like 150GB.
>
> As the load goes hight (to something like 12-14), the kernel lock-up is logged 
> into dmesg.
> At that moment, the OS is barely responsive.
>
>   
Please could you try to reproduce it with this patch applied?
(patch for 2.6.25-rc3, for 2.6.24 will follow - code changed here)

Milan
mbroz@redhat.com
--

Add cond_resched() to prevent stuck in big bio processing.

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 drivers/md/dm-crypt.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index b04f98d..2032228 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -432,6 +432,7 @@ static int crypt_convert(struct crypt_config *cc,
 			/* fall through*/
 		case 0:
 			ctx->sector++;
+			cond_resched();
 			continue;
 		}
 
