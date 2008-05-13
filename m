From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [dm-devel] Desynchronizing dm-raid1
Date: Tue, 13 May 2008 11:38:22 +0800
Message-ID: <20080513033822.GA9604@gondor.apana.org.au>
References: <E1JtKQL-0004Nm-00@gondolin.me.apana.org.au> <Pine.LNX.4.64.0805061849020.7260@engineering.redhat.com> <Pine.LNX.4.64.0805122325050.373@engineering.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805122325050.373@engineering.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-crypto@vger.kernel.org, dm-devel@redhat.com, malahal@us.ibm.com
List-Id: dm-devel.ids

On Mon, May 12, 2008 at 11:28:44PM -0400, Mikulas Patocka wrote:
> 
> Or do you thint it would be useless (all major disk-encryption algorithms 
> read input buffer more times?) or it would create too much code 
> complexity?

I'm open to this approach.  As long as you do the work and come up
with the patch that is :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
