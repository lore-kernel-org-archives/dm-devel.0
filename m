From: Baolin Wang <baolin.wang@linaro.org>
Subject: Re: [PATCH v2 0/2] Introduce the bulk IV mode for improving the
 crypto engine efficiency
Date: Wed, 6 Jan 2016 14:49:05 +0800
Message-ID: <CAMz4kuJMcALYAcSUB1Dvz5+FvktvB_Trwt7YkJ=OwLS2Ti2ndw@mail.gmail.com>
References: <cover.1450233399.git.baolin.wang@linaro.org>
	<56711C0F.8030105@gmail.com>
	<CAMz4kuL2b5Qad5iD3odNVh9VO6ctu_M=QE=8fbdC_+ea+5wJ5w@mail.gmail.com>
	<56885330.9080801@gmail.com>
	<20160104201343.GQ16023@sirena.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160104201343.GQ16023@sirena.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Brown <broonie@kernel.org>
Cc: Milan Broz <gmazyland@gmail.com>, Jens Axboe <axboe@kernel.dk>, Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, neilb@suse.com, dan.j.williams@intel.com, martin.petersen@oracle.com, sagig@mellanox.com, Kent Overstreet <kent.overstreet@gmail.com>, keith.busch@intel.com, tj@kernel.org, Arnd Bergmann <arnd@arndb.de>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On 5 January 2016 at 04:13, Mark Brown <broonie@kernel.org> wrote:
> On Sat, Jan 02, 2016 at 11:46:08PM +0100, Milan Broz wrote:
>
>> Anyway, I think that you should optimize driver, not add strange hw-dependent
>> crypto modes to dmcrypt. This is not the first crypto accelerator that is just not
>> suited for this kind of use.
>
>> (If it can process batch of chunks of data each with own IV, then it can work
>> with dmcrypt, but I think such optimized code should be inside crypto API,
>> not in dmcrypt.)
>
> The flip side of this is there is an awful lot of hardware out there
> that has basically this pattern and if we can make the difference
> between people being able to encrypt or not encrypt their storage due to
> performance then that seems like a win.  Getting hardware changes isn't

Yeah, Now many vendors will supply AES hardware engine to improve the
encryption speed. Like Qualcom or Spreadtrum, they both support the
AES engine, which can handle the IV things in engine interior. So it
can handle bulk data with just one initial IV, which is implemented in
the out of tree req-dm-crypt code. That is why Milan's testing is
failed, cause there is no hardware engine to support this.

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



-- 
Baolin.wang
Best Regards
