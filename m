From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/5] dm: implement REQ_FLUSH/FUA support for bio-based
 dm
Date: Wed, 01 Sep 2010 15:56:09 +0200
Message-ID: <4C7E5B79.3080709@kernel.org>
References: <1283162296-13650-1-git-send-email-tj@kernel.org> <1283162296-13650-3-git-send-email-tj@kernel.org> <20100901134343.GA25260@redhat.com> <4C7E5A38.9050001@kernel.org> <20100901135433.GB25251@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100901135433.GB25251@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: jaxboe@fusionio.com, k-ueda@ct.jp.nec.com, j-nomura@ce.jp.nec.com, jamie@shareable.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de, dm-devel@redhat.com
List-Id: dm-devel.ids

On 09/01/2010 03:54 PM, Mike Snitzer wrote:
>> It just doesn't happen anymore.  If the underlying device doesn't
>> support FLUSH/FUA, the block layer simply make those parts noop.  IOW,
>> it no longer distinguishes between writeback cache which doesn't
>> support cache flush at all and writethrough cache.  Devices which have
>> WB cache w/o flush very difficult to come by these days and there's
>> nothing much we can do anyway, so it doesn't make sense to require
>> everyone to implement -EOPNOTSUPP.
>>
>> One scheduled feature is to implement falling back to REQ_FLUSH when
>> the device advertises REQ_FUA but fails to process it, but one way or
>> the other, the goal is encapsulating REQ_FLUSH/FUA support in block
>> layer proper.  If FLUSH/FUA can be retried using a different strategy,
>> it should be done inside request_queue proper instead of pushing retry
>> logic to all its users.
> 
> OK, so maybe add this info to the patch header one of the primary
> FLUSH+FUA conversion patches?

Sure.

Thanks.

-- 
tejun
