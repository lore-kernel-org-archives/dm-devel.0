From: Jens Axboe <axboe@kernel.dk>
Subject: Re: dm-multipath low performance with blk-mq
Date: Wed, 27 Jan 2016 12:50:43 -0700
Message-ID: <56A91F93.9090002@kernel.dk>
References: <569E11EA.8000305@dev.mellanox.co.il>
	<20160119224512.GA10515@redhat.com> <20160125214016.GA10060@redhat.com>
	<20160125233717.GQ24960@octiron.msp.redhat.com>
	<20160126132939.GA23967@redhat.com>
	<56A8A6A8.9090003@dev.mellanox.co.il>
	<20160127174828.GA31802@redhat.com> <56A90388.1030105@kernel.dk>
	<20160127181655.GB31802@redhat.com> <56A90BBF.3050407@kernel.dk>
	<20160127191443.GD31802@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160127191443.GD31802@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: "keith.busch@intel.com" <keith.busch@intel.com>, Sagi Grimberg <sagig@dev.mellanox.co.il>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids

On 01/27/2016 12:14 PM, Mike Snitzer wrote:
> Yeah, I was using some crap ioping test to get those 500K/85K results.
> I've now switched to the fio test Sagi shared [...]

Tsk tsk

-- 
Jens Axboe
