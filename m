From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: [BUG] dmsetup table output changed from 2.6.18 to
 2.6.19-rc3 and breaks yaird.
Date: Mon, 30 Oct 2006 11:00:29 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0610301053010.25218@g5.osdl.org>
References: <20061030151930.GQ27337@susi>
	<20061030184331.GY3928@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20061030184331.GY3928@agk.surrey.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: Andrew Morton <akpm@osdl.org>, Christophe Saout <christophe@saout.de>, dm-crypt@saout.de, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Stefan Schmidt <stefan@datenfreihafen.org>, herbert@gondor.apana.org.au
List-Id: dm-devel.ids


On Mon, 30 Oct 2006, Alasdair G Kergon wrote:
>  
> It cannot have been intentional as there was no mention of the change to the
> userspace interface in the git changelog (and the interface version number
> was not changed).
> 
> A new patch is needed to revert the part of the patch that changed the
> userspace interface.
> 
> Please don't forget to copy in the appropriate maintainers when you send
> messages like this one:
>   http://marc.theaimsgroup.com/?l=linux-netdev&m=115547174417490&w=2
> so they can provide acks:-)

Yeah.

Herbert, the breakage _seems_ to be due to the STATUSTYPE_TABLE case 
change:

-		cipher = crypto_tfm_alg_name(cc->tfm);
+		cipher = crypto_blkcipher_name(cc->tfm);

which effectively changes "aes" into "cbc(aes)", which is wrong, since we 
show the chainmode separately.

Please, somebody who knows this area, send me a fix,

		Linus

----
(maybe something like this trivial one? Totally untested, but it would 
seem to be the sane approach)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index a625576..645e3ce 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -925,8 +925,7 @@ static int crypt_status(struct dm_target
 		break;
 
 	case STATUSTYPE_TABLE:
-		cipher = crypto_blkcipher_name(cc->tfm);
-
+		cipher = cc->cipher;
 		chainmode = cc->chainmode;
 
 		if (cc->iv_mode)
