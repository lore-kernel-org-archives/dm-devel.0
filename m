From: Baolin Wang <baolin.wang@linaro.org>
Subject: Re: [PATCH 0/2] Introduce the request handling for dm-crypt
Date: Thu, 12 Nov 2015 10:15:32 +0800
Message-ID: <CAMz4ku+VF7-kLyE1fK45_MZ=-Tw3PqpySq3Cu86q+rZX4wRemw@mail.gmail.com>
References: <cover.1447233227.git.baolin.wang@linaro.org>
	<20151111094811.GA3641@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20151111094811.GA3641@infradead.org>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: axboe@kernel.dk, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, neilb@suse.com, jack@suse.cz, tj@kernel.org, jmoyer@redhat.com, keith.busch@intel.com, bart.vanassche@sandisk.com, linux-raid@vger.kernel.org, Mark Brown <broonie@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Garg, Dinesh" <dineshg@quicinc.com>, LKML <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On 11 November 2015 at 17:48, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Nov 11, 2015 at 05:31:43PM +0800, Baolin Wang wrote:
>> Now the dm-crypt code only implemented the 'based-bio' method to encrypt/
>> decrypt block data, which can only hanle one bio at one time. As we know,
>> one bio must use the sequential physical address and it also has a limitation
>> of length. Thus it may limit the big block encyrtion/decryption when some
>> hardware support the big block data encryption.
>>
>> This patch series introduc the 'based-request' method to handle the data
>> encryption/decryption. One request can contain multiple bios, so it can
>> handle big block data to improve the efficiency.
>
> NAK for more request based stacking or DM drivers.  They are a major
> pain to deal with, and adding more with different requirements then
> dm-multipath is not helping in actually making that one work properly.

But now many vendors supply the hardware engine to handle the
encyrtion/decryption. The hardware really need a big block to indicate
its performance with request based things. Another thing is now the
request based things is used by many vendors (Qualcomm, Spreadtrum and
so on) to improve their performance and there's a real performance
requirement here (I can show the performance result later).

I don't think you will worry if any one can work properly, we will
remove the bio based things in future if the request things are
accepted and proved effectively. Thanks for your comment.

-- 
Baolin.wang
Best Regards
