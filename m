From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [dm-devel] Desynchronizing dm-raid1
Date: Fri, 23 May 2008 09:53:45 +1000
Message-ID: <20080522235345.GA4019@gondor.apana.org.au>
References: <E1JtKQL-0004Nm-00@gondolin.me.apana.org.au> <Pine.LNX.4.64.0805061849020.7260@engineering.redhat.com> <Pine.LNX.4.64.0805122325050.373@engineering.redhat.com> <20080513033822.GA9604@gondor.apana.org.au> <Pine.LNX.4.64.0805131622120.486@engineering.redhat.com> <20080514011457.GB18728@gondor.apana.org.au> <Pine.LNX.4.64.0805212210330.17520@engineering.redhat.com> <20080522024225.GA28400@gondor.apana.org.au> <Pine.LNX.4.64.0805220828500.15805@engineering.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805220828500.15805@engineering.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>, linux-crypto@vger.kernel.org, dm-devel@redhat.com, malahal@us.ibm.com
List-Id: dm-devel.ids

On Thu, May 22, 2008 at 08:32:45AM -0400, Mikulas Patocka wrote:
>
> There may be external modules.

Sorry but we don't support external modules.  They should be merged
upstream rather than distributed in the wild.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
