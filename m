From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/2] Introduce the request handling for dm-crypt
Date: Thu, 12 Nov 2015 10:17:32 +0100
Message-ID: <20151112091732.GA23780@quack.suse.cz>
References: <cover.1447233227.git.baolin.wang@linaro.org>
 <20151111094811.GA3641@infradead.org>
 <CAMz4ku+VF7-kLyE1fK45_MZ=-Tw3PqpySq3Cu86q+rZX4wRemw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAMz4ku+VF7-kLyE1fK45_MZ=-Tw3PqpySq3Cu86q+rZX4wRemw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Baolin Wang <baolin.wang@linaro.org>
Cc: Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, neilb@suse.com, jack@suse.cz, tj@kernel.org, jmoyer@redhat.com, keith.busch@intel.com, bart.vanassche@sandisk.com, linux-raid@vger.kernel.org, Mark Brown <broonie@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Garg, Dinesh" <dineshg@quicinc.com>, LKML <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Thu 12-11-15 10:15:32, Baolin Wang wrote:
> On 11 November 2015 at 17:48, Christoph Hellwig <hch@infradead.org> wrote:
> > On Wed, Nov 11, 2015 at 05:31:43PM +0800, Baolin Wang wrote:
> >> Now the dm-crypt code only implemented the 'based-bio' method to encrypt/
> >> decrypt block data, which can only hanle one bio at one time. As we know,
> >> one bio must use the sequential physical address and it also has a limitation
> >> of length. Thus it may limit the big block encyrtion/decryption when some
> >> hardware support the big block data encryption.
> >>
> >> This patch series introduc the 'based-request' method to handle the data
> >> encryption/decryption. One request can contain multiple bios, so it can
> >> handle big block data to improve the efficiency.
> >
> > NAK for more request based stacking or DM drivers.  They are a major
> > pain to deal with, and adding more with different requirements then
> > dm-multipath is not helping in actually making that one work properly.
> 
> But now many vendors supply the hardware engine to handle the
> encyrtion/decryption. The hardware really need a big block to indicate
> its performance with request based things. Another thing is now the
> request based things is used by many vendors (Qualcomm, Spreadtrum and
> so on) to improve their performance and there's a real performance
> requirement here (I can show the performance result later).

So you've mentioned several times that hardware needs big blocks. How big
those blocks need to be? Ideally, can you give some numbers on how the
throughput of the encryption hw grows with the block size?

Because as Mike had said there are downsides to having request based
dm-crypt as well. E.g. if you want to have encrypted raid5 volume then
you'd rather want to put encryption on top of raid5 (easier management,
larger sequential blocks to encrypt, ...) but you cannot do that when
dm-crypt would be request based. So modifying bio-based dm-crypt to form
larger chunks for encryption HW would be superior in this regard.

You mentioned that you use requests because of size limitations on bios - I
had a look and current struct bio can easily describe 1MB requests (that's
assuming 64-bit architecture, 4KB pages) when we have 1 page worth of
struct bio_vec. Is that not enough?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
