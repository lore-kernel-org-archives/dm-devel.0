From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 0/2] Introduce the request handling for dm-crypt
Date: Thu, 12 Nov 2015 13:57:27 +0100
Message-ID: <4436790.rotQ3a7v5c@wuerfel>
References: <cover.1447233227.git.baolin.wang@linaro.org> <20151112122400.GB27454@quack.suse.cz> <CAMz4kuLmGfyae=PXb8keuCpkEFDdXZzvuBtUiJHRAz0P55mxXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMz4kuLmGfyae=PXb8keuCpkEFDdXZzvuBtUiJHRAz0P55mxXg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Baolin Wang <baolin.wang@linaro.org>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk, Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, neilb@suse.com, tj@kernel.org, jmoyer@redhat.com, keith.busch@intel.com, bart.vanassche@sandisk.com, linux-raid@vger.kernel.org, Mark Brown <broonie@kernel.org>, "Garg, Dinesh" <dineshg@quicinc.com>, LKML <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Thursday 12 November 2015 20:51:10 Baolin Wang wrote:
> On 12 November 2015 at 20:24, Jan Kara <jack@suse.cz> wrote:
> > On Thu 12-11-15 19:46:26, Baolin Wang wrote:
> >> On 12 November 2015 at 19:06, Jan Kara <jack@suse.cz> wrote:
> >> > Well, one question is "can handle" and other question is how big gain in
> >> > throughput it will bring compared to say 1M chunks. I suppose there's some
> >> > constant overhead to issue a request to the crypto hw and by the time it is
> >> > encrypting 1M it may be that this overhead is well amortized by the cost of
> >> > the encryption itself which is in principle linear in the size of the
> >> > block. That's why I'd like to get idea of the real numbers...
> >>
> >> Please correct me if I misunderstood your point. Let's suppose the AES
> >> engine can handle 16M at one time. If we give the size of data is less
> >> than 16M, the engine can handle it at one time. But if the data size
> >> is 20M (more than 16M), the engine driver will split the data with 16M
> >> and 4M to deal with. I can not say how many numbers, but I think the
> >> engine is like to big chunks than small chunks which is the hardware
> >> engine's advantage.
> >
> > No, I meant something different. I meant that if HW can encrypt 1M in say
> > 1.05 ms and it can encrypt 16M in 16.05 ms, then although using 16 M blocks
> > gives you some advantage it becomes diminishingly small.
> >
> 
> But if it encrypts 16M with 1M one by one, it will be much more than
> 16.05ms (should be consider the SW submits bio one by one).

The example that Jan gave was meant to illustrate the case where it's not
much more than 16.05ms, just slightly more.

The point is that we need real numbers to show at what size we stop
getting significant returns from increased block sizes.

> >> >> > You mentioned that you use requests because of size limitations on bios - I
> >> >> > had a look and current struct bio can easily describe 1MB requests (that's
> >> >> > assuming 64-bit architecture, 4KB pages) when we have 1 page worth of
> >> >> > struct bio_vec. Is that not enough?
> >> >>
> >> >> Usually one bio does not always use the full 1M, maybe some 1k/2k/8k
> >> >> or some other small chunks. But request can combine some sequential
> >> >> small bios to be a big block and it is better than bio at least.
> >> >
> >> > As Christoph mentions 4.3 should be better in submitting larger bios. Did
> >> > you check it?
> >>
> >> I'm sorry I didn't check it. What's the limitation of one bio on 4.3?
> >
> > On 4.3 it is 1 MB (which should be enough because requests are limited to
> > 512 KB by default anyway). Previously the maximum bio size depended on the
> > queue parameters such as max number of segments etc.
> 
> But it maybe not enough for HW engine which can handle maybe 10M/20M
> at one time.

Given that you have already done measurements, can you find out how much
you lose in overall performance with your existing patch if you artificially
limit the maximum size to sizes like 256kb, 1MB, 4MB, ...?

	Arnd
