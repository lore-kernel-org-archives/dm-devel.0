From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 0/2] Introduce the bulk IV mode for improving
 the crypto engine efficiency
Date: Tue, 12 Jan 2016 18:31:19 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1601121744400.18228@file01.intranet.prod.int.rdu2.redhat.com>
References: <cover.1450233399.git.baolin.wang@linaro.org> <56711C0F.8030105@gmail.com> <CAMz4kuL2b5Qad5iD3odNVh9VO6ctu_M=QE=8fbdC_+ea+5wJ5w@mail.gmail.com> <56885330.9080801@gmail.com> <20160104201343.GQ16023@sirena.org.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160104201343.GQ16023@sirena.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, Mark Brown <broonie@kernel.org>
Cc: Milan Broz <gmazyland@gmail.com>, Jens Axboe <axboe@kernel.dk>, keith.busch@intel.com, linux-raid@vger.kernel.org, martin.petersen@oracle.com, Mike Snitzer <snitzer@redhat.com>, Baolin Wang <baolin.wang@linaro.org>, linux-block@vger.kernel.org, neilb@suse.com, LKML <linux-kernel@vger.kernel.org>, sagig@mellanox.com, Arnd Bergmann <arnd@arndb.de>, tj@kernel.org, dan.j.williams@intel.com, Kent Overstreet <kent.overstreet@gmail.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids



On Mon, 4 Jan 2016, Mark Brown wrote:

> On Sat, Jan 02, 2016 at 11:46:08PM +0100, Milan Broz wrote:
> 
> > Anyway, I think that you should optimize driver, not add strange hw-dependent
> > crypto modes to dmcrypt. This is not the first crypto accelerator that is just not
> > suited for this kind of use.
> 
> > (If it can process batch of chunks of data each with own IV, then it can work
> > with dmcrypt, but I think such optimized code should be inside crypto API,
> > not in dmcrypt.)
> 
> The flip side of this is there is an awful lot of hardware out there
> that has basically this pattern and if we can make the difference
> between people being able to encrypt or not encrypt their storage due to
> performance then that seems like a win.  Getting hardware changes isn't
> going to be a fast process.  From a brief look at the crypto layer it
> does look there may be things we can do there, if only in terms of
> factoring out the common patterns for driving the queue of operations
> into the hardware so it's easy for drivers to do the best thing.  
> 
> One thing that occurs to me for the IV programming that has been
> proposed for SPI by Martin Sparl (and seen good results on Raspberry PI)
> is to insert transfers programming the crypto engine into the stream of
> DMA operations so we can keep the hardware busy.  It won't work with
> every SoC out there but it will work with a lot of them, it's what
> hardware that explicitly supports this will be doing internally.  It's
> the sort of thing that would benefit from factoring out, it's a lot of
> hassle to implement per driver.
> 
> The main thing the out of tree req-dm-crypt code is doing was using a
> larger block size which does seem like a reasonable thing to allow
> people to tune for performance tradeofffs but I undertand that's a lot
> harder to achieve in a good way than one might hope.

But as Milan pointed out, that larger block size doesn't work if you 
process requests with different sizes - the data encrypted with one 
request size won't match if you decrypt them with a different request 
size.


XTS with larger block could work if it were possible to use arbitrary 
initial tweak - the function crypt() in crypto/xts.c calculates the 
initial sector tweak by encrypting the iv:

tw(crypto_cipher_tfm(ctx->tweak), w->iv, w->iv);

and then calculates each cipher block's tweak by multiplying the tweak by 
a constant polynomial (alpha):

gf128mul_x_ble(s.t, s.t);	(s.t is the same as w->iv)


If we could supply the tweak directly, we could use larger sectors in 
dm-crypt.

For example, we could use 64k XTS sectors and if the user is accessing 1k 
offset in the sector, we could calculate initial sector tweak
	tw(crypto_cipher_tfm(ctx->tweak), w->iv, w->iv);
and then multiply it by alpha^(1024/16) (because we are 1024 bytes into 
the sector and xts block size is 16). That would make it possible to use 
larger encryption requests and the data would match regardless of request 
size.

But the Linux crypto API doesn't allow this - the code that would multiply 
the tweak after initial encryption isn't there (maybe we could get this 
behavior by modifying ctx->tweak to point to a null cipher, but it is 
dirty hack to poke into private crypto structures).

Does the hardware encryption you are optimizing for allow setting 
arbitrary tweaks in XTS mode? What is the specific driver you are 
optimizing for?


Another possibility is to use dm-crypt block size 4k and use a filesystem 
with 4k blocksize on it (it will never send requests not aligned on 4k 
boundary, so we could reject such requests with an error).

Mikulas
