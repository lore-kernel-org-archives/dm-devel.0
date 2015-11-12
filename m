From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/2] Introduce the request handling for dm-crypt
Date: Thu, 12 Nov 2015 13:24:00 +0100
Message-ID: <20151112122400.GB27454@quack.suse.cz>
References: <cover.1447233227.git.baolin.wang@linaro.org>
 <20151111094811.GA3641@infradead.org>
 <CAMz4ku+VF7-kLyE1fK45_MZ=-Tw3PqpySq3Cu86q+rZX4wRemw@mail.gmail.com>
 <20151112091732.GA23780@quack.suse.cz>
 <CAMz4kuKBhWcednSauyVhGsSQoNPoLnr4-1RkvJkQvvUR3UpQKg@mail.gmail.com>
 <20151112110617.GA26662@quack.suse.cz>
 <CAMz4kuKmU8E3O6pvE0VXGzJ53uobFzGkNYien0_OXXBssafo3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAMz4kuKmU8E3O6pvE0VXGzJ53uobFzGkNYien0_OXXBssafo3Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Baolin Wang <baolin.wang@linaro.org>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk, Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, neilb@suse.com, tj@kernel.org, jmoyer@redhat.com, keith.busch@intel.com, bart.vanassche@sandisk.com, linux-raid@vger.kernel.org, Mark Brown <broonie@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Garg, Dinesh" <dineshg@quicinc.com>, LKML <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Thu 12-11-15 19:46:26, Baolin Wang wrote:
> On 12 November 2015 at 19:06, Jan Kara <jack@suse.cz> wrote:
> > On Thu 12-11-15 17:40:59, Baolin Wang wrote:
> >> On 12 November 2015 at 17:17, Jan Kara <jack@suse.cz> wrote:
> >> > On Thu 12-11-15 10:15:32, Baolin Wang wrote:
> >> >> On 11 November 2015 at 17:48, Christoph Hellwig <hch@infradead.org> wrote:
> >> >> > On Wed, Nov 11, 2015 at 05:31:43PM +0800, Baolin Wang wrote:
> >> >> >> Now the dm-crypt code only implemented the 'based-bio' method to encrypt/
> >> >> >> decrypt block data, which can only hanle one bio at one time. As we know,
> >> >> >> one bio must use the sequential physical address and it also has a limitation
> >> >> >> of length. Thus it may limit the big block encyrtion/decryption when some
> >> >> >> hardware support the big block data encryption.
> >> >> >>
> >> >> >> This patch series introduc the 'based-request' method to handle the data
> >> >> >> encryption/decryption. One request can contain multiple bios, so it can
> >> >> >> handle big block data to improve the efficiency.
> >> >> >
> >> >> > NAK for more request based stacking or DM drivers.  They are a major
> >> >> > pain to deal with, and adding more with different requirements then
> >> >> > dm-multipath is not helping in actually making that one work properly.
> >> >>
> >> >> But now many vendors supply the hardware engine to handle the
> >> >> encyrtion/decryption. The hardware really need a big block to indicate
> >> >> its performance with request based things. Another thing is now the
> >> >> request based things is used by many vendors (Qualcomm, Spreadtrum and
> >> >> so on) to improve their performance and there's a real performance
> >> >> requirement here (I can show the performance result later).
> >> >
> >> > So you've mentioned several times that hardware needs big blocks. How big
> >> > those blocks need to be? Ideally, can you give some numbers on how the
> >> > throughput of the encryption hw grows with the block size?
> >>
> >> It depends on the hardware design. My beaglebone black board's AES
> >> engine can handle 1M at one time which is not big. As I know some
> >> other AES engine can handle 16M data at one time or more.
> >
> > Well, one question is "can handle" and other question is how big gain in
> > throughput it will bring compared to say 1M chunks. I suppose there's some
> > constant overhead to issue a request to the crypto hw and by the time it is
> > encrypting 1M it may be that this overhead is well amortized by the cost of
> > the encryption itself which is in principle linear in the size of the
> > block. That's why I'd like to get idea of the real numbers...
> 
> Please correct me if I misunderstood your point. Let's suppose the AES
> engine can handle 16M at one time. If we give the size of data is less
> than 16M, the engine can handle it at one time. But if the data size
> is 20M (more than 16M), the engine driver will split the data with 16M
> and 4M to deal with. I can not say how many numbers, but I think the
> engine is like to big chunks than small chunks which is the hardware
> engine's advantage.

No, I meant something different. I meant that if HW can encrypt 1M in say
1.05 ms and it can encrypt 16M in 16.05 ms, then although using 16 M blocks
gives you some advantage it becomes diminishingly small.

> >> > You mentioned that you use requests because of size limitations on bios - I
> >> > had a look and current struct bio can easily describe 1MB requests (that's
> >> > assuming 64-bit architecture, 4KB pages) when we have 1 page worth of
> >> > struct bio_vec. Is that not enough?
> >>
> >> Usually one bio does not always use the full 1M, maybe some 1k/2k/8k
> >> or some other small chunks. But request can combine some sequential
> >> small bios to be a big block and it is better than bio at least.
> >
> > As Christoph mentions 4.3 should be better in submitting larger bios. Did
> > you check it?
> 
> I'm sorry I didn't check it. What's the limitation of one bio on 4.3?

On 4.3 it is 1 MB (which should be enough because requests are limited to
512 KB by default anyway). Previously the maximum bio size depended on the
queue parameters such as max number of segments etc.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
