From: Jens Axboe <axboe@kernel.dk>
Subject: Re: blk-mq request allocation stalls [was: Re: [PATCH v3
 0/8] dm: add request-based blk-mq support]
Date: Wed, 07 Jan 2015 08:32:14 -0700
Message-ID: <54AD517E.40002@kernel.dk>
References: <54999756.70303@acm.org>
	<1v2g6masssbu88ans1r6lres.1419354811001@email.android.com>
	<CAMM=eLd_A+fRBHDvcDqwF1a9co+G7XZvVhRyBd1AjxOdgjKhbA@mail.gmail.com>
	<549AB979.4050302@acm.org> <20141224182143.GA12922@redhat.com>
	<20141224185529.GA13246@redhat.com>
	<20141224192643.GA30461@redhat.com> <54A6DB1D.4030201@acm.org>
	<20150105213557.GA5030@redhat.com> <54ABAB80.70006@acm.org>
	<20150106160553.GB10224@redhat.com> <54AC0A39.90801@kernel.dk>
	<54AD0B63.3010505@acm.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <54AD0B63.3010505@acm.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bvanassche@acm.org>, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Keith Busch <keith.busch@intel.com>, device-mapper development <dm-devel@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
List-Id: dm-devel.ids

On 01/07/2015 03:33 AM, Bart Van Assche wrote:
> On 01/06/15 17:15, Jens Axboe wrote:
>> blk-mq request allocation is pretty much as optimized/fast as it can be.
>> The slowdown must be due to one of two reasons:
>>
>> - A bug related to running out of requests, perhaps a missing queue run
>> or something like that.
>> - A smaller number of available requests, due to the requested queue
>> depth.
>>
>> Looking at Barts results, it looks like it's usually fast, but sometimes
>> very slow. That would seem to indicate it's option #1 above that is the
>> issue. Bart, since this seems to wait for quite a bit, would it be
>> possible to cat the 'tags' file for that queue when it is stuck like
>> that?
>
> Hello Jens,
>
> Thanks for the assistance. Is this the output you were looking for ?
>
> # dmsetup table /dev/dm-1
> 0 256000 multipath 0 0 2 1 service-time 0 1 2 8:32 1 1 service-time 0 1
> 2 8:48 1 1
>
> # ls -ld /dev/sd[cd]
> brw-rw---- 1 root disk 8, 32 Jan  7 11:16 /dev/sdc
> brw-rw---- 1 root disk 8, 48 Jan  7 11:16 /dev/sdd
>
> # time mkfs.xfs -f /dev/dm-1 &
> [ ... ]
> real    4m12.101s
>
> # for d in sdc sdd; do echo ==== $d; (cd /sys/block/$d/mq &&
>    find|cut -c3-|grep tag|xargs grep -aH ''); done

You forgot dm-1, that's what mkfs is sleeping on. But given that sdc/sdd 
look idle, it still looks like a case of dm-1 not appropriately running 
the queues after insertion.

-- 
Jens Axboe
