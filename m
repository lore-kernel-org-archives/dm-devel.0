From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 8/9] dm: Fix two race conditions related to
 stopping and starting queues
Date: Thu, 1 Sep 2016 13:15:17 -0700
Message-ID: <235c0ca3-0c01-6dc8-208e-1a4c153dd69c@sandisk.com>
References: <18db2396-cd4f-1d52-1ffa-21b9b512eaf4@sandisk.com>
	<82ff8574-8b73-8ba3-9098-741060f38fca@sandisk.com>
	<20160901031355.GB4741@redhat.com>
	<BLUPR02MB1683D3D8F604FEB429143A4381E20@BLUPR02MB1683.namprd02.prod.outlook.com>
	<20160901150503.GA11074@redhat.com>
	<ca45a2b1-99bc-1779-3b4f-a03343ccbd9a@sandisk.com>
	<20160901155051.GA11353@redhat.com> <20160901161253.GA11410@redhat.com>
	<e8cf7d03-82a6-cba3-60c4-c436ae3a24f7@sandisk.com>
	<20160901190505.GA12106@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160901190505.GA12106@redhat.com>
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

On 09/01/2016 12:05 PM, Mike Snitzer wrote:
> On Thu, Sep 01 2016 at  1:59pm -0400,
> Bart Van Assche <bart.vanassche@sandisk.com> wrote:
>> On 09/01/2016 09:12 AM, Mike Snitzer wrote:
>>> Please see/test the dm-4.8 and dm-4.9 branches (dm-4.9 being rebased
>>> ontop of dm-4.8):
>>> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-4.8
>>> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-4.9
>>
>> Hello Mike,
>>
>> The result of my tests of the dm-4.9 branch is as follows:
>> * With patch "dm mpath: check if path's request_queue is dying in
>> activate_path()" I still see every now and then that CPU usage of
>> one of the kworker threads jumps to 100%.
>
> So you're saying that the dying queue check is still needed in the path
> selector?  Would be useful to know why the 100% is occuring.  Can you
> get a stack trace during this time?

Hello Mike,

A few days ago I had already tried to obtain a stack trace with perf but 
the information reported by perf wasn't entirely accurate. What I know 
about that 100% CPU usage is as follows:
* "dmsetup table" showed three SRP SCSI device nodes but these SRP SCSI
   device nodes were not visible in /sys/block. This means that
   scsi_remove_host() had already removed these from sysfs.
* hctx->run_work kept being requeued over and over again on the kernel
   thread with name "kworker/3:1H". I assume this means that
   blk_mq_run_hw_queue() was called with the second argument (async) set
   to true. This probably means that the following dm-rq code was
   triggered:

	if (map_request(tio, rq, md) == DM_MAPIO_REQUEUE) {
		/* Undo dm_start_request() before requeuing */
		rq_end_stats(md, rq);
		rq_completed(md, rq_data_dir(rq), false);
		return BLK_MQ_RQ_QUEUE_BUSY;
	}

Bart.
