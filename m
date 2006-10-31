From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [BUG] dmsetup table output changed from 2.6.18 to
	2.6.19-rc3 and breaks yaird.
Date: Tue, 31 Oct 2006 11:56:46 +1100
Message-ID: <20061031005646.GA26146@gondor.apana.org.au>
References: <20061030151930.GQ27337@susi>
	<20061030184331.GY3928@agk.surrey.redhat.com>
	<Pine.LNX.4.64.0610301053010.25218@g5.osdl.org>
	<1162237148.9415.7.camel@leto.intern.saout.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1162237148.9415.7.camel@leto.intern.saout.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Saout <christophe@saout.de>
Cc: Andrew Morton <akpm@osdl.org>, dm-crypt@saout.de, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>, Alasdair G Kergon <agk@redhat.com>, Stefan Schmidt <stefan@datenfreihafen.org>
List-Id: dm-devel.ids

On Mon, Oct 30, 2006 at 08:39:08PM +0100, Christophe Saout wrote:
>
> > Herbert, the breakage _seems_ to be due to the STATUSTYPE_TABLE case 
> > change:
> > 
> > -		cipher = crypto_tfm_alg_name(cc->tfm);
> > +		cipher = crypto_blkcipher_name(cc->tfm);
> > 
> > which effectively changes "aes" into "cbc(aes)", which is wrong, since we 
> > show the chainmode separately.

Yes that's wrong.

However, the bigger problem is that dmcrypt's algorithm specification
does not allow all algorithms to be specified.  In particular, algorithms
with dashes in their names cannot be represented in an unambiguous way.

The separation of chain modes and algorithm names is in fact unnecessary
and only complicates matters.

For now it's no big deal since the algorithms people actually use
can be represented.  But it would be nice to get this fixed.
 
> ----
> 
> Fix dm-crypt after the block cipher API changes to correctly return the
> backwards compatible cipher-chainmode[-ivmode] format for "dmsetup
> table".
> 
> Signed-off-by: Christophe Saout <christophe@saout.de>

Looks good to me.

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
