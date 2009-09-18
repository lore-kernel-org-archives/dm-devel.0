From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH] Add a tracepoint for block request remapping
Date: Fri, 18 Sep 2009 23:34:48 +0900
Message-ID: <4AB39A88.3040106@ce.jp.nec.com>
References: <4AB2E57B.2090101@ce.jp.nec.com> <4AB32148.3010004@cn.fujitsu.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4AB32148.3010004@cn.fujitsu.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

Li Zefan wrote:
> Jun'ichi Nomura wrote:
>> Since 2.6.31 now has request-based device-mapper, it's useful to have
>> a tracepoint for request-remapping as well as bio-remapping.
>>
>> This patch adds a tracepoint for request-remapping, trace_block_rq_remap().
> 
>> Existing trace_block_remap() is left unchanged but it might be better to
>> rename it to trace_block_bio_remap().
> 
> Why not. ;)

OK, I'll add a renaming patch.

>> +static void blk_add_trace_rq_remap(struct request_queue *q,
>> +				   struct request *rq, dev_t dev,
>> +				   sector_t from)
>> +{
>> +	struct blk_trace *bt = q->blk_trace;
>> +	struct blk_io_trace_remap r;
>> +
>> +	if (likely(!bt))
>> +		return;
>> +
>> +	r.device_from = cpu_to_be32(dev);
>> +	r.device_to   = disk_devt(rq->rq_disk);
> 
> cpu_to_be32(dis_devt(...))

Thank you! I'll fix that.

>> +	r.sector_from = cpu_to_be64(from);
>> +
>> +	__blk_add_trace(bt, blk_rq_pos(rq), blk_rq_bytes(rq),
>> +			rq_data_dir(rq), BLK_TA_REMAP, !!rq->errors,
>> +			sizeof(r), &r);
>> +}

-- 
Jun'ichi Nomura, NEC Corporation
