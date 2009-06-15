From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH block#for-2.6.31] block: add request clone
	interface (v2)
Date: Mon, 15 Jun 2009 12:30:57 +0300
Message-ID: <4A3614D1.20403@panasas.com>
References: <4A3075B2.9040208@ct.jp.nec.com>	<20090611110903.GO11363@kernel.dk>	<x49vdn3lynd.fsf@segfault.boston.devel.redhat.com>	<20090612133014.GK11363@kernel.dk>
	<x49ski5v7vs.fsf@segfault.boston.devel.redhat.com>
	<4A35C0A4.20707@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4A35C0A4.20707@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

On 06/15/2009 06:31 AM, Kiyoshi Ueda wrote:
> Hi Jeff,
> 
> On 06/12/2009 11:33 PM +0900, Jeff Moyer wrote:
>> Jens Axboe <jens.axboe@oracle.com> writes:
>>> On Thu, Jun 11 2009, Jeff Moyer wrote:
>>>> Jens Axboe <jens.axboe@oracle.com> writes:
>>>> Is blk_rq_unprep_clone really the best name?
>>>>           ^^^^^^
>>> Probably not, but I'm not very good at coming up with elegant names.
>>> Your email should have included a new suggestion :-)
>> Fair enough.  ;)
>>
>>>  - blk_rq_unprep_clone(struct request *clone)
>>>      * Frees cloned bios from the clone request.
>> Why not blk_rq_free_clone?
> 
> Because the 'clone' is not freed in this interface.
> This interface frees only bios in the 'clone'.
> Allocating/freeing the 'clone' are the caller's work, since
> only the caller knows how to allocate/free it.
> 
> 'prep' after 'alloc' and 'unprep' before 'free' is symmetric
> and I feel a good candidate for my request-stacking driver,
> so I chose it. 
> 
> Thanks,
> Kiyoshi Ueda

I'm not a native English speaker as well, so I'm fine
with blk_rq_{prep,unprep}_clone. But maybe the English
people don't like it?

Perhaps
blk_rq_{clone,declone} or blk_rq_{clone,declone}_bios

(Both unclone and declone are found on the net but are not
 found in the free dictionary)

Boaz
