From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH 2/2] dm: only initialize full request_queue for
	request-based device
Date: Wed, 19 May 2010 08:01:30 -0400
Message-ID: <AANLkTinndXq8DkMBOUf5z8R_8lWRoRbDuOZ1LEmWeI21@mail.gmail.com>
References: <1273532139-23043-2-git-send-email-snitzer@redhat.com>
	 <4BEA659F.9050206@ct.jp.nec.com> <20100513035750.GA25523@redhat.com>
	 <4BED049C.5040409@ct.jp.nec.com> <20100514140852.GA10373@redhat.com>
	 <4BF10BF1.3040108@ct.jp.nec.com> <20100517172737.GA24591@redhat.com>
	 <4BF25091.3000507@ct.jp.nec.com> <20100518134639.GA27582@redhat.com>
	 <4BF37DD5.9050409@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4BF37DD5.9050409@ct.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Vivek Goyal <vgoyal@redhat.com>, Nikanth Karthikesan <knikanth@suse.de>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, May 19, 2010 at 1:57 AM, Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wr=
ote:
> Hi Mike,
>
> On 05/18/2010 10:46 PM +0900, Mike Snitzer wrote:
>> Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
>>> On 05/18/2010 02:27 AM +0900, Mike Snitzer wrote:
>>>> Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
>>>>> As far as I understand, the current model of device-mapper is:
>>>>> =A0 - a table (precisely, a target) has various attributes,
>>>>> =A0 =A0 bio-based/request-based is one of such attributes
>>>>> =A0 - a table and its attributes are bound to the block device on=
 resume
>>>>> If we want to fix a problem, I think we should either work based =
on
>>>>> this model or change the model.
>>>>>
>>>>> Your patch makes that loading table affects the block device, so =
you
>>>>> are changing the model.
>>>>>
>>>>> If you change the model, it should be done carefully.
>>>>> For example, the current model allows most of the table loading c=
ode
>>>>> to run without exclusive lock on the device because it doesn't af=
fect
>>>>> the device itself. =A0If you change this model, table loading nee=
ds to
>>>>> be serialized with appropriate locking.
>>>>
>>>> Nice catch, yes md->queue needs protection (see patch below).
>>>
>>> Not enough. (See drivers/md/dm-ioctl.c:table_load().)
>>> Table load sequence is:
>>> =A0 1. populate table
>>> =A0 2. set the table to ->new_map of the hash_cell for the mapped_d=
evice
>>> =A0 =A0 =A0in protection by _hash_lock.
>>>
>>> Since your fix only serializes the step 1, concurrent table loading
>>> could end up with inconsistent status; e.g. request-based table is
>>> bound to the mapped_device while the queue is initialized as bio-ba=
sed.
>>> With your new model, those 2 steps above must be atomic.
>>
>> Ah, yes.. I looked at the possibility of serializing the entirety of
>> table_load but determined that would be too excessive (would reduce
>> parallelism of table_load). =A0But I clearly missed the fact that th=
ere
>> could be a race to the _hash_lock protected critical section in
>> table_load() -- leading to queue inconsistency.
>>
>> I'll post v5 of the overall patch which will revert the mapped_devic=
e
>> 'queue_lock' serialization that I proposed in v4. =A0v5 will contain
>> the following patch to localize all table load related queue
>> manipulation to the _hash_lock protected critical section in
>> table_load(). =A0So it sets the queue up _after_ the table's type is
>> established with dm_table_set_type().
>
> dm_table_setup_md_queue() may allocate memory with blocking mode.
> Blocking allocation inside exclusive _hash_lock can cause deadlock;
> e.g. when it has to wait for other dm devices to resume to free some
> memory.

We make no guarantees that other DM devices will resume before a table
load -- so calling dm_table_setup_md_queue() within the exclusive
_hash_lock is no different than other DM devices being suspended while
a request-based DM device performs its first table_load().

My thinking was this should not be a problem as it is only valid to
call dm_table_setup_md_queue() before the newly created request-based
DM device has been resumed.

AFAIK we don't have any explicit constraints on memory allocations
during table load (e.g. table loads shouldn't depend on other devices'
writeback) -- but any GFP_KERNEL allocation could recurse
(elevator_alloc() currently uses GFP_KERNEL with kmalloc_node)...

I'll have to review the DM code further to see if all memory
allocations during table_load() are done via mempools.  I'll also
bring this up on this week's LVM call.

> Also, your patch changes the queue configuration even when a table is
> already active and used. =A0(e.g. Loading bio-based table to a mapped=
_device
> which is already active/used as request-based sets q->requst_fn in NU=
LL.)
> That could cause some critical problems.

Yes, that is possible and I can add additional checks to prevent this.
But this speaks to a more general problem with the existing DM code.

dm_swap_table() has the negative check to prevent such table loads, e.g=
=2E:
/* cannot change the device type, once a table is bound */

This check should come during table_load, as part of
dm_table_set_type(), rather than during table resume.

Thanks,
Mike
