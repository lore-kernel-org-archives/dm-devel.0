From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: [PATCH RFC 1/3] block: add flag 'nowait_requests' into queue
 limits
Date: Wed, 3 Jun 2020 11:24:53 +0300
Message-ID: <2a58bc7a-0aad-3f40-cb8e-db9cb88f9df4@yandex-team.ru>
References: <159101473169.180989.12175693728191972447.stgit@buzz>
 <159101502963.180989.6228080995222059011.stgit@buzz>
 <20200603045822.GA17137@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200603045822.GA17137@infradead.org>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-Id: dm-devel.ids

On 03/06/2020 07.58, Christoph Hellwig wrote:
> On Mon, Jun 01, 2020 at 03:37:09PM +0300, Konstantin Khlebnikov wrote:
>> Add flag for marking bio-based queues which support REQ_NOWAIT.
>> Set for all request based (mq) devices.
>>
>> Stacking device should set it after blk_set_stacking_limits() if method
>> make_request() itself doesn't delay requests or handles REQ_NOWAIT.
> 
> I don't think this belongs into the queue limits.  For example a
> stacking driver that always defers requests to a workqueue can support
> REQ_NOWAIT entirely independent of the underlying devices.  I think
> this just needs to be a simple queue flag.
> 

For O_DIRECT I/O REQ_NOWAIT not just about non-blocking submition.
It also provides instant feedback about contention. Like ECN from network.
This feedback is useful for rate-control and balancing load between replicas.

If upper layer simply remaps and forwards requests below then to forward
contention all layers of stacked device should support this feature.
That's why I've put it as flag into limits - to reuse limits stacking.

If any layer defers request, then it should somehow limit size of backlog
at the same time to provide sane behaviour for REQ_NOWAIT regardless of
behaviour lower devices. So, then it could simply set that flag in limits.

Also I want to add handing into blk-qos/throttler - never delay REQ_NOWAIT.
