From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [dm-crypt] INFO: task mount:11202 blocked for more
	than 120 seconds
Date: Tue, 18 Mar 2008 08:56:53 +0800
Message-ID: <20080318005653.GA14575@gondor.apana.org.au>
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de>
	<200803150108.04008.chunkeey@web.de>
	<200803151432.11125.chunkeey@web.de>
	<200803152234.53199.chunkeey@web.de>
	<alpine.DEB.1.00.0803161406040.6213@sheep.housecafe.de>
	<20080317173609.GD29322@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080317173609.GD29322@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christian Kujau <lists@nerdbynature.de>, Chr <chunkeey@web.de>, Milan Broz <mbroz@redhat.com>, David Chinner <dgc@sgi.com>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, dm-de
List-Id: dm-devel.ids

On Mon, Mar 17, 2008 at 05:36:09PM +0000, Alasdair G Kergon wrote:
> Latest version for everyone to try:
> 
> From: Milan Broz <mbroz@redhat.com>
> 
> Fix regression in dm-crypt introduced in commit
> 3a7f6c990ad04e6f576a159876c602d14d6f7fef
> (dm crypt: use async crypto).
> 
> If write requests need to be split into pieces, the code must not
> process them in parallel because the crypto context cannot be shared.
> So there can be parallel crypto operations on one part of the write,
> but only one write bio can be processed at a time.

Could you explain this part please? Crypto tfm objects are meant
to be reentrant, synchronous or not.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
