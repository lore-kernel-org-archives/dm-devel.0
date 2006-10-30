From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [BUG] dmsetup table output changed from 2.6.18 to
	2.6.19-rc3 and breaks yaird.
Date: Mon, 30 Oct 2006 19:15:54 +0000
Message-ID: <20061030191554.GN1319@agk.surrey.redhat.com>
References: <20061030151930.GQ27337@susi>
	<20061030184331.GY3928@agk.surrey.redhat.com>
	<Pine.LNX.4.64.0610301053010.25218@g5.osdl.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0610301053010.25218@g5.osdl.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Linus Torvalds <torvalds@osdl.org>
Cc: Andrew Morton <akpm@osdl.org>, Christophe Saout <christophe@saout.de>, dm-crypt@saout.de, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Stefan Schmidt <stefan@datenfreihafen.org>, herbert@gondor.apana.org.au
List-Id: dm-devel.ids

On Mon, Oct 30, 2006 at 11:00:29AM -0800, Linus Torvalds wrote:
> (maybe something like this trivial one? Totally untested, but it would 
> seem to be the sane approach)
 
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index a625576..645e3ce 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -925,8 +925,7 @@ static int crypt_status(struct dm_target
>  		break;
>  
>  	case STATUSTYPE_TABLE:
> -		cipher = crypto_blkcipher_name(cc->tfm);
> -
> +		cipher = cc->cipher;
>  		chainmode = cc->chainmode;
>  
>  		if (cc->iv_mode)
> 
> 

Looks correct.

The point of STATUSTYPE_TABLE is to return (readable) output to userspace in
a format that the crypt_ctr() function would accept back in.

So crypt_ctr() now stores a private copy of cipher and chainmode for
crypt_status() to regurgitate when requested.

Alasdair
-- 
agk@redhat.com
