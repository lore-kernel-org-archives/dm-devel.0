From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] dm: fix multipath regression due to initializing wrong
 request
Date: Mon, 09 Feb 2015 10:47:19 -0700
Message-ID: <54D8F2A7.6050501@kernel.dk>
References: <20150209163856.GA12781@posteo.de> <20150209164855.GB1599@redhat.com> <alpine.LNX.2.00.1502091651310.15481@localhost.lm.intel.com> <20150209171311.GC1599@redhat.com> <20150209173514.GA14199@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150209173514.GA14199@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, Keith Busch <keith.busch@intel.com>
Cc: Dongsu Park <dongsu.park@profitbricks.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On 02/09/2015 10:35 AM, Mike Snitzer wrote:
> On Mon, Feb 09 2015 at 12:13P -0500,
> Mike Snitzer <snitzer@redhat.com> wrote:
>
>> On Mon, Feb 09 2015 at 12:07pm -0500,
>> Keith Busch <keith.busch@intel.com> wrote:
>>
>>> Oh, we're not going rebase the series with the correction? I'm concerned
>>> someone biscecting a completely unrelated problem might step on this
>>> commit. Up to you guys. It's my fault, so I'll deal with the consequences.
>>
>> Rebasing this late (3.20 merge already opened) is generally not done.
>> Unfortunately we'll just have to suck it up and deal with the fallout
>> during bisect -- would wager very few are bisecting with multipath as
>> the focus of their test.
>
> Jens and I discussed this further and given that linux-block breaks
> dm-multipath it is best to fix linux-block and let Linus resolve the
> merge when I send him the linux-dm pull.
>
> Here is the patch to fix the regression:

Added, thanks. I don't think this is worth rebasing for, so just added 
to the top of for-3.20/core (since that's where the buggy commit was added).

-- 
Jens Axboe
