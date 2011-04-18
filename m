From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [dm-devel] [PATCH 05/10] block: remove per-queue plugging
Date: Mon, 18 Apr 2011 11:47:39 +0200
Message-ID: <4DAC08BB.6060202@fusionio.com>
References: <20110411205928.13915719@notabene.brown>	<4DA2E03A.2080607@fusionio.com>	<20110411212635.7959de70@notabene.brown>	<4DA2E7F0.9010904@fusionio.com>	<20110411220505.1028816e@notabene.brown>	<4DA2F00E.6010907@fusionio.com>	<20110418081922.1651474a@notabene.brown>	<4DABDC60.2090009@fusionio.com>	<20110418172551.55629fc6@notabene.brown>	<4DABF1EA.3070301@fusionio.com> <20110418091959.GA32013@infradead.org> <4DAC070C.6010403@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DAC070C.6010403@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, "hch@infradead.org" <hch@infradead.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 2011-04-18 11:40, Hannes Reinecke wrote:
> On 04/18/2011 11:19 AM, hch@infradead.org wrote:
>> Btw, I really start to wonder if the request level is the right place
>> to do this on-stack plugging.  Wouldn't it be better to just plug
>> bios in the on-stack queue?  That way we could also stop doing the
>> special case merging when adding to the plug list, and leave all the
>> merging / I/O schedule logic in the __make_request path.  Probably
>> not .39 material, but worth a prototype?
>>
>> Also what this dicussion brought up is that the block layer data
>> structures are highly confusing.  Using a small subset of the
>> request_queue also for make_request based driver just doesn't make
>> sense.  It seems like we should try to migrate the required state
>> to struct gendisk, and submit I/O through a block_device_ops.submit
>> method, leaving the request_queue as an internal abstraction for
>> the request based drivers.
>>
> Good point.
> It would also help us we the device-mapper redesign agk and myself 
> discussed at LSF. Having a block_device_ops.submit function would
> allow us remap the actual request queue generically; and we would 
> even be able to address more than one request queue, which sounds 
> awfully similar to what Jens is trying to do ...

The multiqueue bits would still have one request_queue, but multiple
queueing structures (I called those blk_queue_ctx, iirc).

-- 
Jens Axboe

