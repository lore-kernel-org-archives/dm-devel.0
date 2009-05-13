From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: no_path_retry configurable per device basis?
Date: Wed, 13 May 2009 19:08:30 +0100
Message-ID: <1242238110.13505.579.camel@breeves.fab.redhat.com>
References: <561c252c0905130851q221e9febq61cc37f9fe9cee3@mail.gmail.com>
	<1242231573.13505.571.camel@breeves.fab.redhat.com>
	<561c252c0905131035p19ddb6fdp32482feb0b66bf1e@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <561c252c0905131035p19ddb6fdp32482feb0b66bf1e@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, 2009-05-13 at 19:35 +0200, Gianluca Cecchi wrote:
> Thanks for answering.
> why will I still see queue if_if_no_path?

Because that's how retries are implemented; we enable queuing in the
device-mapper target and setup a counter. Every time the I/O fails we
decrement the counter by one. When it hits zero queuing is disabled in
the kernel and the queued I/Os are permitted to fail. This is different
to "no_path_retry queue" or "features '1 queue_if_no_path'" because with
those options queuing will never be disabled. We keep the I/O in memory
indefinitely until the paths return (or the host is rebooted).

> Ok for the kb... it was the same I referred to in my qyestion... ;-)

Sorry, didn't spot that ;)

> And what about having a multipath.conf like this?
> 
> blacklist {
>       devnode "^cciss!c[0-9]d[0-9]*"
> }
> 

I'd put "no_path_retry queue" in your defaults block since you want it
for all but one device on this storage:

> defaults {
>       user_friendly_names yes
>       polling_interval 30
>       rr_min_io 100
> }

The device section must be inside a devices { /*...*/ } block or it
won't get parsed/recognised:

>       device {
>               vendor                  "IBM"
>               product                 "1750500"
>               getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
>               prio_callout            "/sbin/mpath_prio_alua %d"
>               hardware_handler        "0"
>               path_grouping_policy    group_by_prio
>               failback                immediate
>               rr_weight               uniform
>               path_checker            tur

Since you only want this behavior for one LUN, why not set it at the
multipath level?

>               no_path_retry 3
>       }

> multipaths {
>       multipath {
>               wwid                    3600507630efe0b0c0000000000000600
>               alias                   mpath0

You can probably put this line in your defaults block and only override
it for the LUN on which you want a max of three retries:

>               no_path_retry      queue
>       }
>       multipath {
>               wwid                    3600507630efe0b0c0000000000000601
>               alias                   mpath1
>               no_path_retry      queue
>       }
>      [snip]
>       multipath {

I'd probably put the "no_path_retry 3" here:

>               wwid                    3600507630efe0b0c0000000000000610
>               alias                   mpath6
>       }
>     [snip]
> }
> 
> what would I see with multipath -l?
> 
> As in defaults for this device there is
> features 1 queue_if_no_path
> and there is no other option configurable per "features" key in device
> section....
> what would be the effect?
> Or in other words, can I disable the "features" key for a device....?
> For example setting fir it the no_path_retry that semms applicable to
> the device section itself...?

You'll need to remove that features option from the device block as you
have above, or specify an empty features property like:

features        "0"

Regards,
Bryn.
