From: Eric Ren <zren@suse.com>
Subject: Re: dm mirror: fix crash caused by NULL-pointer
 dereference
Date: Mon, 26 Jun 2017 23:27:56 +0800
Message-ID: <a2dcb2e0-cba2-6776-f041-605a66486ec5@suse.com>
References: <20170626090848.21585-1-zren@suse.com>
	<7ba503ae-ab87-493a-264c-3b42f8418c34@redhat.com>
	<3291473d-1eec-89a7-c3a1-d49c82df500c@suse.com>
	<a2d51150-c820-57b8-f1d1-c39c7576929b@suse.com>
	<20170626143723.GA31713@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170626143723.GA31713@redhat.com>
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
Cc: jtang@suse.com, dm-devel@redhat.com, neilb@suse.com, agk@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

Hi Mike,


On 06/26/2017 10:37 PM, Mike Snitzer wrote:
> On Mon, Jun 26 2017 at  9:47am -0400,
> Eric Ren <zren@suse.com> wrote:
> [...snip...]
>>> """
>>> Revert "dm mirror: use all available legs on multiple failures"
>>> dm io: fix duplicate bio completion due to missing ref count
>> I have a confusion about this "dm io..." fix. The fix itself is good.
>>
>> Without it, a mkfs.ext4 on a mirrored dev whose primary mirror dev
>> has failed, will crash the kernel with the discard operation from mkfs.ext4.
>> However, mkfs.ext4 can succeed on a healthy mirrored device. This
>> is the thing I don't understand, because no matter the mirrored device is
>> good or not, there's always a duplicate bio completion before having this
>> this fix, thus write_callback() will be called twice, crashing will
>> occur on the
>> second write_callback():
> No, there is only a duplicate bio completion if the error path is taken
> (e.g. underlying device doesn't support discard).
Hmm, when "op == REQ_OP_DISCARD", please see comments in do_region():

"""
static void do_region(int op, int op_flags, unsigned region,
                       struct dm_io_region *where, struct dpages *dp,
                       struct io *io)
{
...
  if (op == REQ_OP_DISCARD)
                 special_cmd_max_sectors = q->limits.max_discard_sectors;
...
         if ((op == REQ_OP_DISCARD || op == REQ_OP_WRITE_ZEROES ||
              op == REQ_OP_WRITE_SAME) && special_cmd_max_sectors == 0) {
                 atomic_inc(&io->count);        ===>   [1]
                 dec_count(io, region, -EOPNOTSUPP);     ===>  [2]
                 return;
         }
"""

[1] ref count fixed by patch "dm io: ...";
[2] we won't come here if "special_cmd_max_sectors != 0", which is true 
when both sides
of the mirror is good.

So only when a mirror device fails, "max_discard_sectors" on its queue 
is 0, thus this error path
will be taken, right?

>
>> """
>> static void write_callback(unsigned long error, void *context)
>> {
>>          unsigned i;
>>          struct bio *bio = (struct bio *) context;
>>          struct mirror_set *ms;
>>          int should_wake = 0;
>>          unsigned long flags;
>>
>>          ms = bio_get_m(bio)->ms;        ====> NULL pointer at the
>> duplicate completion
>>          bio_set_m(bio, NULL);
>> """
>>
>> If no this fix, I expected the DISCARD IO would always crash the
>> kernel, but it's not true when
>> the mirrored device is good. Hope someone happen to know the reason
>> can give some hints ;-P
> If the mirror is healthy then only one completion is returned to
> dm-mirror (via write_callback).  The problem was the error patch wasn't
> managing the reference count as needed.  Whereas dm-io's normal discard
> IO path does.

Yes, I can understand this.

Thanks a lot,
Eric

>
> Mike
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
