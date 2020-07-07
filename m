From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 0/6] crypto: add CRYPTO_ALG_ALLOCATES_MEMORY
Date: Tue, 7 Jul 2020 10:58:00 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2007071049240.13237@file01.intranet.prod.int.rdu2.redhat.com>
References: <20200701045217.121126-1-ebiggers@kernel.org> <alpine.LRH.2.02.2007010358390.6597@file01.intranet.prod.int.rdu2.redhat.com> <20200706185403.GA736284@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <20200706185403.GA736284@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids



On Mon, 6 Jul 2020, Eric Biggers wrote:

> On Wed, Jul 01, 2020 at 03:59:10AM -0400, Mikulas Patocka wrote:
> > Thanks for cleaning this up.
> > 
> > Mikulas
> 
> Do you have any real comments on this?
> 
> Are the usage restrictions okay for dm-crypt?
> 
> - Eric

I think that your patch series is OK.

dm-crypt submits crypto requests with size aligned on 512 bytes. The start 
of the crypto request is usually aligned on 512 bytes, but not always - 
XFS with SLUB_DEBUG will send bios with misaligned bv_offset (but the bio 
vectors don't cross a page).

Mikulas
