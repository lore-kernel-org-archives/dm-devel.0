From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH] Add a tracepoint for block request remapping
Date: Sat, 19 Sep 2009 02:05:50 +0900
Message-ID: <4AB3BDEE.8090800@ce.jp.nec.com>
References: <4AB2E57B.2090101@ce.jp.nec.com> <20090918104539.GX23126@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090918104539.GX23126@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <jens.axboe@oracle.com>, Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hi Jens, Alasdair,

Jens Axboe wrote:
> On Fri, Sep 18 2009, Jun'ichi Nomura wrote:
>> Since 2.6.31 now has request-based device-mapper, it's useful to have
>> a tracepoint for request-remapping as well as bio-remapping.
>>
>> This patch adds a tracepoint for request-remapping, trace_block_rq_remap().
>> Existing trace_block_remap() is left unchanged but it might be better to
>> rename it to trace_block_bio_remap().
> 
> This looks good, we should definitely have a remap trace at that level
> too. Apart from that, nothing further to add than acking the observation
> that you need to make the ->device_to part of the trace endian clean.
> 
> If you resend with that and just send the core bit (the dm part should
> go through the dm branch), then I'll include it for 2.6.32.

I resent a revised patchset but I'm afraid they might be confusing
as the other patchset for max_sectors/queue_limits were also sent
in parallel and I didn't make them look like a thread.
For your reference, these are the revised patchset for tracing 
request-remap:

[PATCH 1/3] block: Add a tracepoint for block request remapping
https://www.redhat.com/archives/dm-devel/2009-September/msg00201.html

[PATCH 2/3] block: Rename trace_block_remap to trace_block_bio_remap
https://www.redhat.com/archives/dm-devel/2009-September/msg00202.html

[PATCH 3/3] dm: Add a remapping trace to request-based dm
https://www.redhat.com/archives/dm-devel/2009-September/msg00204.html

The 3rd patch for dm depends on the 1st.

-- 
Jun'ichi Nomura, NEC Corporation
