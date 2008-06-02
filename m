From: Milan Broz <mbroz@redhat.com>
Subject: Re: 2.6.24 Kernel Soft Lock Up with heavy I/O in dm-crypt
Date: Mon, 02 Jun 2008 14:51:04 +0200
Message-ID: <4843ECB8.4010002@redhat.com>
References: <20080602030738.GA7761@yantp.cn.ibm.com>
	<48439890.6030904@redhat.com>
	<20080602123145.GA8258@yantp.cn.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080602123145.GA8258@yantp.cn.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Yan Li <elliot.li.tech@gmail.com>
Cc: Ritesh Raj Sarraf <rrs@researchut.com>, Herbert Xu <herbert@gondor.apana.org.au>, dm-crypt@saout.de, linux-kernel@vger.kernel.org, dm-devel@redhat.com, rjmaomao@gmail.com, Andrew Morton <akpm@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>, Christophe Saout <christophe@saout.de>
List-Id: dm-devel.ids

Yan Li wrote:

>> Please could you try if  patch here helps and doesn't cause performance degradation?
>> http://www2.kernel.org/pub/linux/kernel/people/agk/patches/2.6/2.6.25/dm-crypt-add-cond_resched.patch
>>     
>
> Will the result of testing a Debian 2.6.24-etchnhalf.1-amd64 kernel
> (very near a vanilla kernel) be of same value?  Since the data on some
> other drives on this server is important so I dare not try 2.6.25-rc
> on it.
>   
patch just adds cond_resched(), problem is the same in all recent kernel I think.
just for 2.6.24 kernel patch need to be slighly modified (see below)

> Following is my test plan, comments are welcomed:
>
> Test command:
> # dd if=/dev/zero of=/dev/mapper/open_device bs=500M count=10
> (this server has 2G memory)
>   
bonnie++ test or something like that is more appropriate, but

for this problem is dd test enough

> The command will be run	for 3 times, and average speed of last two
> runs will be taken as result score.
>
>   
flush caches between tests or simple luksClose & luksOpen + mount device between
test runs

> Dm-crypt LUKS Encryption scenarios:
> aes-cbc-essiv:sha256, keysize 128
> aes-xts-plain, keysize 256
> aes-xts-plain, keysize 512
>
> I will compare the speed of all above 3 encryption scenarios, with and
> without the patch.
>
>   
Patch for 2.6.24 kernel

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
