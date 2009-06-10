From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH block#for-2.6.31] block: add request clone
	interface
Date: Wed, 10 Jun 2009 11:15:29 +0900
Message-ID: <4A2F1741.8090100@ct.jp.nec.com>
References: <4A2E1490.7060902@ct.jp.nec.com> <20090609180344.GQ11363@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090609180344.GQ11363@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, k-ueda@ct.jp.nec.com, device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org, Boaz Harrosh <bharrosh@panasas.com>
List-Id: dm-devel.ids

Hi Jens,

On 06/10/2009 03:03 AM +0900, Jens Axboe wrote:
> On Tue, Jun 09 2009, Kiyoshi Ueda wrote:
>> Hi Jens,
>>
>> +/*
>> + * Copy request information of the original request to the clone request.
>> + */
>> +static void __blk_rq_prep_clone(struct request *dst, struct request *src)
>> +{
>> +	dst->cpu = src->cpu;
>> +	dst->cmd_flags = (rq_data_dir(src) | REQ_NOMERGE);
>> +	dst->cmd_type = src->cmd_type;
>> +	dst->__sector = blk_rq_pos(src);
>> +	dst->__data_len = blk_rq_bytes(src);
>> +	dst->nr_phys_segments = src->nr_phys_segments;
>> +	dst->ioprio = src->ioprio;
>> +	dst->buffer = src->buffer;
>> +	dst->cmd_len = src->cmd_len;
>> +	dst->cmd = src->cmd;
> 
> Are you making sure that 'src' always exists while 'dst' is alive?

Yes.
Request-based dm is the owner of 'src' (original) and
it never frees 'src' until the 'dst' (clone) are completed.

I avoided deep-copying __cmd/buffer/sense as it's costly
(additional allocation and memcpy).
And I don't think there are any needs for that.
But if anyone really wants that even with the copying cost,
please speak up.

Thanks,
Kiyoshi Ueda
