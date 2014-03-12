From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Disable partitions scan for multipathed
	devices
Date: Wed, 12 Mar 2014 16:31:25 +0100
Message-ID: <53207DCD.2030303@suse.de>
References: <1394624936-118530-1-git-send-email-hare@suse.de>
	<20140312122310.GB14017@agk-dp.fab.redhat.com>
	<532052CB.2090605@suse.de> <53205712.8000200@redhat.com>
	<53205933.5060706@suse.de> <53205AD1.40804@redhat.com>
	<53205BDF.2090504@redhat.com> <53205DBB.3030100@suse.de>
	<53207296.4060309@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <53207296.4060309@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Peter Rajnoha <prajnoha@redhat.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

On 03/12/2014 03:43 PM, Peter Rajnoha wrote:
> On 03/12/2014 02:14 PM, Hannes Reinecke wrote:
>> _However_: The 'no_partition' feature has the advantage that you
>> don't need to modify the multipath code; it'll just take whatever is
>> in 'features' and pass it 1:1 into the device-mapper table.
>>
>
> But you still need some config file in userspace that will store
> the fact that some of the mpath devs need to be marked with this
> feature flag.
>
Yes. Multipath already has the 'multipath.conf' file, which is
used to specify and/or modify multipath devices.
Including the ability to set the 'features' string,
which is passed 1:1 into the device-mapper core.

>> When using cookies for that we'd need either a separate
>> mechanism/flag for multipathing or filter out the features list.
>> _And_ we need to modify libdevmapper _and_ multipath at the same
>> time to make that work.
>> But if you insist ...
>
> If this is a subsystem specific (in this case mpath) flag, we
> don't need to change libdevmapper, only mpath userspace code.
>
Ah. Ok, that simplifies matters.

>>
>> So can you make a patch for libdevmapper to add this cookie flag?
>> I'll be checking the multipath-tools code ...
>
> I'll try to think about this a bit more since it would be beneficial
> to have such a thing for all block devices actually - any of them
> can be be used in a VM and we need to prevent scanning all such
> devices, not just mpath ones. A simple solution would be for users
> to define a udev rule (providing them a template) where they can
> match against some properties (e.g. DM name, uuid or WWID or whatever
> else is present for the block dev to match against in the rule).
>
> This actually brings us to a general problem with making the device
> "private" in some way on the host system. AFAIK we still don't have
> a general rule for this! Everybody is patching this on his own.
> With all the support for various autoactivations and automounts,
> this can become quite dangerous then if not configured properly
> by each subsystem's mechanism to make the device private.
>
Hehe. I've got a patch which implements a 'no_partition_scan' kernel
parameter, disabling the in-kernel partition scanning code altogether.
Especially useful if you're running on a root-on-multipath system,
as then basically _all_ devices are handled by multipathing, so
the in-kernel partition scan is pointless at best.
At worst it'll trigger tons of I/O errors on the passive path,
slowing down the machine to an eventual halt as the serial console
overflows.

And, btw, a udev rule won't work as the in-kernel scanning code
would be called nevertheless. You'd need to inhibit that, only then can =

you intercept the scanning.

I can post it here if you're interested ...

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
