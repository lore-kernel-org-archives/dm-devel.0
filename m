From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 8/9] dm: Fix two race conditions related to
 stopping and starting queues
Date: Thu, 1 Sep 2016 13:52:36 -0700
Message-ID: <66e36ae7-19ff-058f-049a-3e91a62b19b3@sandisk.com>
References: <BLUPR02MB1683D3D8F604FEB429143A4381E20@BLUPR02MB1683.namprd02.prod.outlook.com>
	<20160901150503.GA11074@redhat.com>
	<ca45a2b1-99bc-1779-3b4f-a03343ccbd9a@sandisk.com>
	<20160901155051.GA11353@redhat.com> <20160901161253.GA11410@redhat.com>
	<e8cf7d03-82a6-cba3-60c4-c436ae3a24f7@sandisk.com>
	<20160901190505.GA12106@redhat.com>
	<235c0ca3-0c01-6dc8-208e-1a4c153dd69c@sandisk.com>
	<20160901203332.GB12407@redhat.com>
	<889bdb89-a16b-927a-adf0-fa04418a0c06@sandisk.com>
	<20160901204806.GA12742@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160901204806.GA12742@redhat.com>
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
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, device-mapper development <dm-devel@redhat.com>, "hch@lst.de" <hch@lst.de>
List-Id: dm-devel.ids

On 09/01/2016 01:48 PM, Mike Snitzer wrote:
> Yeah, I since fixed that.  Doesn't change the fact that your use of
> blk_mq_freeze_queue() causes the 100% cpu usage.

Hello Mike,

Sorry but that doesn't make sense to me. blk_mq_freeze_queue() either 
returns quickly or waits. It cannot cause 100% CPU usage. Something else 
must be going on. If you can make the code available that you used in 
your test I will have a look at it.

Bart.
