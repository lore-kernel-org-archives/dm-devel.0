From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 7/7] dm-mpath: Fix a race condition in
	__multipath_map()
Date: Tue, 22 Nov 2016 19:48:03 -0500
Message-ID: <20161123004803.GA32186@redhat.com>
References: <e83f8718-9e73-5544-3bcc-4d9851b90ba1@sandisk.com>
	<81bc399e-df90-099d-1b25-bdb0fda3f27c@sandisk.com>
	<20161116003720.GA19059@redhat.com>
	<be828cfa-1121-8d99-0cd1-9021fab3adc8@sandisk.com>
	<20161121234316.GA25362@redhat.com>
	<d4a3879e-ec60-69f6-abb8-95aa7f305277@sandisk.com>
	<20161122003444.GB25362@redhat.com>
	<a8311b54-cd95-a1f9-7cd2-11adb10eec80@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <a8311b54-cd95-a1f9-7cd2-11adb10eec80@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Nov 22 2016 at  6:47pm -0500,
Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> On 11/21/2016 04:34 PM, Mike Snitzer wrote:
> >But you WARN_ON_ONCE(clone && q->mq_ops) will trigger with sq-on-mq.
> 
> Hello Mike,
> 
> This behavior is indeed triggered by the sq-on-mq test. After having
> added the following code in __bind():
> 
> 	if (old_map &&
> 	    dm_table_all_blk_mq_devices(old_map) !=
> 	    dm_table_all_blk_mq_devices(t))
> 		pr_debug("%s: old all_blk_mq %d <> new all_blk_mq %d\n",
> 			 dm_device_name(md),
> 			 dm_table_all_blk_mq_devices(old_map),
> 			 dm_table_all_blk_mq_devices(t));
> 
> I see the following output appear frequently in the kernel log:
> 
> dm_mod:__bind: 254:0: old all_blk_mq 1 <> new all_blk_mq 0
> 
> Could these all_blk_mq state changes explain that WARN_ON_ONCE(clone
> && q->mq_ops) is triggered in __multipath_map()? Does this mean that
> the comment in patch http://marc.info/?l=dm-devel&m=147925314306752
> is correct?

Yes, looks like you're on to something.  dm_old_prep_tio() has:

        /*
         * Must clone a request if this .request_fn DM device
         * is stacked on .request_fn device(s).
         */
        if (!dm_table_all_blk_mq_devices(table)) { ...

So if your table->all_blk_mq is false (likely due to a temporary no
paths in multipath table scenario) a clone will be passed to
__multipath_map().  But what isn't clear is how __multipath_map() would
then go on to have any underlying paths available to issue IO to (given
the table would have been empty -- or so I would think).

Would be great if you could verify that the table is in fact empty.

It should be noted that dm_table_determine_type() has:

        if (list_empty(devices) && __table_type_request_based(live_md_type)) {
                /* inherit live MD type */
                t->type = live_md_type;
                return 0;
        }

So this explains how/why an empty table will inherit the
DM_TYPE_MQ_REQUEST_BASED, and it also explains why the new (empty) table
would not have ->all_blk_mq set to true.  But again, no IO is able to be
issued when there are no underlying paths.

And looking closer, __multipath_map() _should_ return early with either
DM_MAPIO_DELAY_REQUEUE or DM_MAPIO_REQUEUE when no paths are available.

Not seeing how you could have this scenario where you prepared a clone
(as if the clone request were to be issued to a .request_fn, aka "sq",
device) and then by the time you get into __multipath_map() there is an
underlying path available with q->mq_ops.

But regardless, what certainly needs fixing is the inconsistency of
inheriting DM_TYPE_MQ_REQUEST_BASED but not setting all_blk_mq to true
(all_blk_mq == true is implied by DM_TYPE_MQ_REQUEST_BASED).

I'm now questioning why we even need the 'all_blk_mq' state within the
table.  I'll revisit the "why?" on all that in my previous commits.
I'll likely get back with you on this point tomorrow.  And will
hopefully have a fix for you.

FYI: given all this I do think something like your 7/7 patch (which you
referenced with the above url) would be a possible added safety net to
guard against future inconsistencies/bug/regressions.
