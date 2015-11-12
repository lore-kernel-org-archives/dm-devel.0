From: Baolin Wang <baolin.wang@linaro.org>
Subject: Re: [PATCH 0/2] Introduce the request handling for dm-crypt
Date: Thu, 12 Nov 2015 17:40:59 +0800
Message-ID: <CAMz4kuKBhWcednSauyVhGsSQoNPoLnr4-1RkvJkQvvUR3UpQKg@mail.gmail.com>
References: <cover.1447233227.git.baolin.wang@linaro.org>
	<20151111094811.GA3641@infradead.org>
	<CAMz4ku+VF7-kLyE1fK45_MZ=-Tw3PqpySq3Cu86q+rZX4wRemw@mail.gmail.com>
	<20151112091732.GA23780@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151112091732.GA23780@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk, Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, neilb@suse.com, tj@kernel.org, jmoyer@redhat.com, keith.busch@intel.com, bart.vanassche@sandisk.com, linux-raid@vger.kernel.org, Mark Brown <broonie@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Garg, Dinesh" <dineshg@quicinc.com>, LKML <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On 12 November 2015 at 17:17, Jan Kara <jack@suse.cz> wrote:
> On Thu 12-11-15 10:15:32, Baolin Wang wrote:
>> On 11 November 2015 at 17:48, Christoph Hellwig <hch@infradead.org> wrote:
>> > On Wed, Nov 11, 2015 at 05:31:43PM +0800, Baolin Wang wrote:
>> >> Now the dm-crypt code only implemented the 'based-bio' method to encrypt/
>> >> decrypt block data, which can only hanle one bio at one time. As we know,
>> >> one bio must use the sequential physical address and it also has a limitation
>> >> of length. Thus it may limit the big block encyrtion/decryption when some
>> >> hardware support the big block data encryption.
>> >>
>> >> This patch series introduc the 'based-request' method to handle the data
>> >> encryption/decryption. One request can contain multiple bios, so it can
>> >> handle big block data to improve the efficiency.
>> >
>> > NAK for more request based stacking or DM drivers.  They are a major
>> > pain to deal with, and adding more with different requirements then
>> > dm-multipath is not helping in actually making that one work properly.
>>
>> But now many vendors supply the hardware engine to handle the
>> encyrtion/decryption. The hardware really need a big block to indicate
>> its performance with request based things. Another thing is now the
>> request based things is used by many vendors (Qualcomm, Spreadtrum and
>> so on) to improve their performance and there's a real performance
>> requirement here (I can show the performance result later).
>
> So you've mentioned several times that hardware needs big blocks. How big
> those blocks need to be? Ideally, can you give some numbers on how the
> throughput of the encryption hw grows with the block size?

It depends on the hardware design. My beaglebone black board's AES
engine can handle 1M at one time which is not big. As I know some
other AES engine can handle 16M data at one time or more.

>
> Because as Mike had said there are downsides to having request based
> dm-crypt as well. E.g. if you want to have encrypted raid5 volume then
> you'd rather want to put encryption on top of raid5 (easier management,
> larger sequential blocks to encrypt, ...) but you cannot do that when
> dm-crypt would be request based. So modifying bio-based dm-crypt to form
> larger chunks for encryption HW would be superior in this regard.
>

Make sense.

> You mentioned that you use requests because of size limitations on bios - I
> had a look and current struct bio can easily describe 1MB requests (that's
> assuming 64-bit architecture, 4KB pages) when we have 1 page worth of
> struct bio_vec. Is that not enough?

Usually one bio does not always use the full 1M, maybe some 1k/2k/8k
or some other small chunks. But request can combine some sequential
small bios to be a big block and it is better than bio at least.

>
>                                                                 Honza
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR



-- 
Baolin.wang
Best Regards
