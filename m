From: Jens Axboe <axboe@kernel.dk>
Subject: Re: a fix and two cleanups around blk_stack_limits
Date: Mon, 20 Jul 2020 15:35:44 -0600
Message-ID: <ab942c19-68c3-2a76-b3b2-136a2bf3ca54@kernel.dk>
References: <20200720061251.652457-1-hch@lst.de>
 <dfe56cf2-db3d-3461-9834-be314f4080ef@kernel.dk>
 <20200720173530.GA21442@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200720173530.GA21442@lst.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Damien.LeMoal@wdc.com, linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On 7/20/20 11:35 AM, Christoph Hellwig wrote:
> On Mon, Jul 20, 2020 at 10:56:23AM -0600, Jens Axboe wrote:
>> On 7/20/20 12:12 AM, Christoph Hellwig wrote:
>>> Hi Jens,
>>>
>>> this series ensures that the zoned device limitations are properly
>>> inherited in blk_stack_limits, and then cleanups up two rather
>>> pointless wrappers around it.
>>
>> We should probably make this against for-5.9/drivers instead, to avoid
>> an unnecessary conflict when merging.
> 
> Then we'd also need a merge as my next series depends on this, and it
> clearly is core material.  Not sure which one is more important.

Hmm, might make more sense to kick off a branch topic for this and just
merge it after the other ones.

-- 
Jens Axboe
