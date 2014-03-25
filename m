From: Matias Bjorling <m@bjorling.me>
Subject: Re: [dm-devel] [PATCH RFC v1 01/01] dm-lightnvm: An open FTL for
 open firmware SSDs
Date: Mon, 24 Mar 2014 20:30:20 -0700
Message-ID: <5330F84C.8090803@bjorling.me>
References: <1395383538-18019-1-git-send-email-m@bjorling.me>	<1395383538-18019-2-git-send-email-m@bjorling.me> <20140321153749.GA17155@infradead.org> <532FCCFB.7010007@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <532FCCFB.7010007@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, device-mapper development <dm-devel@redhat.com>
Cc: snitzer@redhat.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, agk@redhat.com, Takashi HOSHINO <hoshino@labs.cybozu.co.jp>
List-Id: dm-devel.ids

On 03/23/2014 11:13 PM, Bart Van Assche wrote:
> On 03/21/14 16:37, Christoph Hellwig wrote:
>> Just curious:  why do you think implementing this as a block remapper
>> inside device mapper is a better idea than as a blk-mq driver?
>>
>> At the request layer you already get a lot of infrastructure for all the
>> queueing infrastructure for free, as well as all kinds of other helpers.
>> And the driver never remaps bios anyway but always submits new ones as
>> far as I can tell.
>>
>> Does it even make sense to expose the underlying devices as block
>> devices?  It surely would help to send this together with a driver
>> that you plan to use it on top of.
> 
> There might be some overlap between the functionality available in the
> lightnvm driver and the WalB driver announced last year. That last
> driver might have a wider user base and hence may have received more
> testing. See also http://thread.gmane.org/gmane.linux.file-systems/75124.
>

Hi Bart,

Thanks! There seems to be a little bit that can be reused. It does seem
from the github page that there haven't been any development since its
been posted. Maybe the development is moved elsewhere?

> Bart.
> 
