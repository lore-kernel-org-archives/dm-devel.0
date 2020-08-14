From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [RESEND PATCH] nvme: explicitly use normal NVMe
 error handling when appropriate
Date: Fri, 14 Aug 2020 00:02:33 -0700
Message-ID: <9cced4a7-aafa-23c8-ad4b-d19e0b136585@grimberg.me>
References: <510f5aff-0437-b1ce-f7ab-c812edbea880@grimberg.me>
	<20200807045015.GA29737@redhat.com>
	<fec745aa-0091-ee1f-cb0f-da9e18cf0aa2@grimberg.me>
	<20200810143620.GA19127@redhat.com> <20200810172209.GA19535@redhat.com>
	<20200813144811.GA5452@redhat.com>
	<20200813153623.GA30905@infradead.org>
	<20200813174704.GA6137@redhat.com>
	<20200813184349.GA8191@infradead.org>
	<96aff2d0-5907-f5c9-9164-8fea0d030d95@grimberg.me>
	<20200814065559.GA29917@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200814065559.GA29917@infradead.org>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-nvme@lists.infradead.org, dm-devel@redhat.com, Chao Leng <lengchao@huawei.com>, Keith Busch <kbusch@kernel.org>, "Meneghini,
	John" <John.Meneghini@netapp.com>, Ewan Milne <emilne@redhat.com>
List-Id: dm-devel.ids


>>> +	switch (nvme_req_disposition(req)) {
>>> +	case COMPLETE:
>>> +		nvme_complete_req(req);
>>
>> nvme_complete_rq calling nvme_complete_req... Maybe call it
>> __nvme_complete_rq instead?
> 
> That's what I had first, but it felt so strangely out of place next
> to the other nvme_*_req calls..
> 
> Maybe nvme_complete_rq needs to be renamed - what about nvme_req_done?

I'd suggest to call nvme_complete_rq nvme_end_rq because it really calls
blk_mq_end_request. That would confuse with nvme_end_request which
calls blk_mq_complete_request... Maybe we need some naming improvements
throughout.

>> Maybe call nvme_req_disposition again locally here to not carry
>> the is_ana_status. But not a biggy..
> 
> That means it would have to become non-static in scope, limiting
> inlining possibilities, etc.

I see.
