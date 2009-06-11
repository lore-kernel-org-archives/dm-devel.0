From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH block#for-2.6.31] block: add request clone
	interface
Date: Thu, 11 Jun 2009 12:18:09 +0900
Message-ID: <4A307771.10303@ct.jp.nec.com>
References: <4A2E1490.7060902@ct.jp.nec.com> <20090609180344.GQ11363@kernel.dk>
	<4A2F1741.8090100@ct.jp.nec.com> <4A2F66ED.80206@panasas.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4A2F66ED.80206@panasas.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: k-ueda@ct.jp.nec.com, linux-kernel@vger.kernel.org, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, device-mapper development <dm-devel@redhat.com>, Jens Axboe <jens.axboe@oracle.com>, Tejun Heo <tj@kernel.org>
List-Id: dm-devel.ids

Hi Boaz,

On 06/10/2009 04:55 PM +0900, Boaz Harrosh wrote:
> On 06/10/2009 05:15 AM, Kiyoshi Ueda wrote:
>> On 06/10/2009 03:03 AM +0900, Jens Axboe wrote:
>>> On Tue, Jun 09 2009, Kiyoshi Ueda wrote:
>>>> Hi Jens,
>>>>
>>>> +/*
>>>> + * Copy request information of the original request to the clone request.
>>>> + */
>>>> +static void __blk_rq_prep_clone(struct request *dst, struct request *src)
>>>> +{
>>>> +	dst->cpu = src->cpu;
>>>> +	dst->cmd_flags = (rq_data_dir(src) | REQ_NOMERGE);
>>>> +	dst->cmd_type = src->cmd_type;
>>>> +	dst->__sector = blk_rq_pos(src);
>>>> +	dst->__data_len = blk_rq_bytes(src);
>>>> +	dst->nr_phys_segments = src->nr_phys_segments;
>>>> +	dst->ioprio = src->ioprio;
>>>> +	dst->buffer = src->buffer;
>>>> +	dst->cmd_len = src->cmd_len;
>>>> +	dst->cmd = src->cmd;
>>> Are you making sure that 'src' always exists while 'dst' is alive?
>> Yes.
>> Request-based dm is the owner of 'src' (original) and
>> it never frees 'src' until the 'dst' (clone) are completed.
>>
>> I avoided deep-copying __cmd/buffer/sense as it's costly
>> (additional allocation and memcpy).
> 
> For my needs for example dst->cmd will be different then
> src->cmd. Could be untouched. The caller will set what he
> needs.
> 
> dst->sense should be untouched, caller can set to src->sense
> if he wants to. Or like me he already have another buffer.
> 
> dst->buffer is always NULL in my path so I don't know
> what that is. Tejun?
> 
> It should only be about bios and lengths.
> 
> And a big fat comment about what it does and what it
> does not.

OK, I removed ->cmd, ->sense and ->buffer from __blk_rq_prep_clone()
and added some documents.
Please see the updated patch:
    http://marc.info/?l=dm-devel&m=124468991432260&w=2

Thanks,
Kiyoshi Ueda
