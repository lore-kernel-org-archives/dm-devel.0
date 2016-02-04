From: Hannes Reinecke <hare@suse.de>
Subject: Re: dm-multipath low performance with blk-mq
Date: Thu, 4 Feb 2016 07:54:52 +0100
Message-ID: <56B2F5BC.1010700@suse.de>
References: <20160125233717.GQ24960@octiron.msp.redhat.com>
	<20160126132939.GA23967@redhat.com>
	<56A8A6A8.9090003@dev.mellanox.co.il>
	<20160127174828.GA31802@redhat.com> <56A904B6.50407@dev.mellanox.co.il>
	<20160129233504.GA13661@redhat.com> <56AC79D0.5060104@suse.de>
	<20160130191238.GA18686@redhat.com> <56AEFF63.7050606@suse.de>
	<20160203180406.GA11591@redhat.com> <20160203182423.GA12913@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160203182423.GA12913@redhat.com>
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
Cc: axboe@kernel.dk, Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "keith.busch@intel.com" <keith.busch@intel.com>, device-mapper development <dm-devel@redhat.com>, linux-block@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids

On 02/03/2016 07:24 PM, Mike Snitzer wrote:
> On Wed, Feb 03 2016 at  1:04pm -0500,
> Mike Snitzer <snitzer@redhat.com> wrote:
>  =

>> I'm still not clear on where the considerable performance loss is coming
>> from (on null_blk device I see ~1900K read IOPs but I'm still only
>> seeing ~1000K read IOPs when blk-mq DM-multipath is layered ontop).
>> What is very much apparent is: layering dm-mq multipath ontop of null_blk
>> results in a HUGE amount of additional context switches.  I can only
>> infer that the request completion for this stacked device (blk-mq queue
>> ontop of blk-mq queue, with 2 completions: 1 for clone completing on
>> underlying device and 1 for original request completing) is the reason
>> for all the extra context switches.
> =

> Starts to explain, certainly not the "reason"; that is still very much
> TBD...
> =

>> Here are pictures of 'perf report' for perf datat collected using
>> 'perf record -ag -e cs'.
>>
>> Against null_blk:
>> http://people.redhat.com/msnitzer/perf-report-cs-null_blk.png
> =

> if dm-mq nr_hw_queues=3D1 and null_blk nr_hw_queues=3D1
>   cpu          : usr=3D25.53%, sys=3D74.40%, ctx=3D1970, majf=3D0, minf=
=3D474
> if dm-mq nr_hw_queues=3D1 and null_blk nr_hw_queues=3D4
>   cpu          : usr=3D26.79%, sys=3D73.15%, ctx=3D2067, majf=3D0, minf=
=3D479
> =

>> Against dm-mpath ontop of the same null_blk:
>> http://people.redhat.com/msnitzer/perf-report-cs-dm_mq.png
> =

> if dm-mq nr_hw_queues=3D1 and null_blk nr_hw_queues=3D1
>   cpu          : usr=3D11.07%, sys=3D33.90%, ctx=3D667784, majf=3D0, minf=
=3D466
> if dm-mq nr_hw_queues=3D1 and null_blk nr_hw_queues=3D4
>   cpu          : usr=3D15.22%, sys=3D48.44%, ctx=3D2314901, majf=3D0, min=
f=3D466
> =

> So yeah, the percentages reflected in these respective images didn't do
> the huge increase in context switches justice... we _must_ figure out
> why we're seeing so many context switches with dm-mq.
> =

Well, the most obvious one being that you're using 1 dm-mq queue vs
4 null_blk queues.
So you will have have to do an additional context switch for 75% of
the total I/Os submitted.

Have you tested with 4 dm-mq hw queues?

To avoid context switches we would have to align the dm-mq queues to
the underlying blk-mq layout for the paths.

And we need to look at making the main submission path lockless;
I was wondering if we really need to take the lock if we don't
switch priority groups; maybe we can establish a similar algorithm
blk-mq does; if we were to have a queue per valid path in any given
priority group we should be able to run lockless and only take the
lock if we need to switch priority groups.

But anyway, I'll be looking at your patches.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
