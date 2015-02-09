From: Keith Busch <keith.busch@intel.com>
Subject: Re: blk-mq crash with dm-multipath in for-3.20/core
Date: Mon, 9 Feb 2015 17:07:34 +0000 (UTC)
Message-ID: <alpine.LNX.2.00.1502091651310.15481@localhost.lm.intel.com>
References: <20150209163856.GA12781@posteo.de> <20150209164855.GB1599@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150209164855.GB1599@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Dongsu Park <dongsu.park@profitbricks.com>, Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, 9 Feb 2015, Mike Snitzer wrote:
> On Mon, Feb 09 2015 at 11:38am -0500,
> Dongsu Park <dongsu.park@profitbricks.com> wrote:
>> So that commit 6d6285c45f5a should be either reverted, or moved to
>> linux-dm tree, doesn't it?
>>
>> Cheers,
>> Dongsu
>>
>> [1] https://www.redhat.com/archives/dm-devel/2015-January/msg00171.html
>> [2] https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-for-3.20&id=102e38b1030e883efc022dfdc7b7e7a3de70d1c5
>
> Right, we're aware of this typo in 6d6285c45f5a.  Sorry about that, but
> as you noted, once both the linux-block and linux-dm branches for 3.20
> are merged all is back to working.
>
> So we're planning to just leave the block commit as broken and let the
> dm commit you noted fix it up.  In the end 3.20-rc1 will have a working
> dm-multipath.

Oh, we're not going rebase the series with the correction? I'm concerned
someone biscecting a completely unrelated problem might step on this
commit. Up to you guys. It's my fault, so I'll deal with the consequences.
