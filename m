From: Hannes Reinecke <hare@suse.de>
Subject: Re: [LSF/MM ATTEND][LSF/MM TOPIC] Multipath redesign
Date: Thu, 14 Jan 2016 08:25:52 +0100
Message-ID: <56974D80.2020803@suse.de>
References: <56961493.5010901@suse.de>
	<20160113175239.GE24960@octiron.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160113175239.GE24960@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On 01/13/2016 06:52 PM, Benjamin Marzinski wrote:
> On Wed, Jan 13, 2016 at 10:10:43AM +0100, Hannes Reinecke wrote:
>> Hi all,
>>
>> I'd like to attend LSF/MM and would like to present my ideas for a multi=
path
>> redesign.
>>
>> The overall idea is to break up the centralized multipath handling in
>> device-mapper (and multipath-tools) and delegate to the appropriate
>> sub-systems.
>>
>> Individually the plan is:
>> a) use the 'wwid' sysfs attribute to detect multipath devices;
>>     this removes the need of the current 'path_id' functionality
>>     in multipath-tools
>
> If all the devices that we support advertise their WWID through sysfs,
> I'm all for this. Not needing to worry about callouts or udev sounds
> great.
>
As of now, multipath-tools pretty much requires VPD page 0x83 to be =

implemented. So that's not a big issue. Plus I would leave the old =

infrastructure in place, as there are vendors which do provide their =

own path_id mechanism.

>> b) leverage topology information from scsi_dh_alua (which we will
>>     have once my ALUA handler update is in) to detect the multipath
>>     topology. This removes the need of a 'prio' infrastructure
>>     in multipath-tools
>
> What about devices that don't use alua? Or users who want to be able to
> pick a specific path to prefer? While I definitely prefer simple, we
> can't drop real funtionality to get there. Have you posted your
> scsi_dh_alua update somewhere?
>
Yep. Check the linux-scsi mailing list.

> I've recently had requests from users to
> 1. make a path with the TPGS pref bit set be in its own path group with
> the highest priority
Isn't that always the case?
Paths with TPGS pref bit set will have a different priority than =

those without the pref bit, and they should always have the highest =

priority.
I would rather consider this an error in the prioritizer ...

> 2. make the weighted prioritizer use persistent information to make its
> choice, so its actually useful. This is to deal with the need to prefer a
> specific path in a non-alua setup.
>
yeah, I had a similar request. And we should distinguish between the =

individual transports, as paths might be coming in via different =

protocols/transports.

> Some of the complexity with priorities is there out of necessity.
>
Agree.

>> c) implement block or scsi events whenever a remote port becomes
>>     unavailable. This removes the need of the 'path_checker'
>>     functionality in multipath-tools.
>
> I'm not convinced that we will be able to find out when paths come back
> online in all cases without some sort of actual polling. Again, I'd love
> this to be simpler, but asking all the types of storage we plan to
> support to notify us when they are up and down may not be realistic.
>
Currently we have three main transports: FC, iSCSI, and SAS.
FC has reliable path events via RSCN, as this is also what the =

drivers rely on internally (hello, zfcp :-)
If _that_ doesn't work we're in a deep hole anyway, cf the =

eh_deadline mechanism we had to implement.
iSCSI has the NOP mechanism, which in effect is polling on the iSCSI =

level. That would provide equivalent information; unfortunately not =

every target supports that.
But even without iSCSI has it's own error recovery logic, which will =

kick in whenever an error is detected. So we can as well hook into =

that and use it to send events.
And for SAS we have a far better control over the attached fabric, =

so it should be possible to get reliable events there, too.

That only leaves the non-transport drivers like virtio or the =

various RAID-like cards, which indeed might not be able to provide =

us with events.

So I would propose to make that optional; if events are supported =

(which could be figured out via sysfs) we should be using them and =

don't insist on polling, but fall back to the original methods if we =

don't have them.

>> d) leverage these events to handle path-up/path-down events
>>     in-kernel
>
> If polling is necessary, I'd rather it be done in userspace. Personally,
> I think the checker code is probably the least obectionable part of the
> multipath-tools (It's getting all the device information to set up the
> devices in the first place and coordinating with uevents that's really
> ugly, IMHO).
>
And this is where I do disagree.
The checker code is causing massive lock congestion on large-scale =

systems as there is precisely _one_ checker thread, having to check =

all devices serially. If paths go down on a large system we're =

having a flood of udev events, which we cannot handle in-time as the =

checkerloop holds the lock trying to check all those paths.

So being able to do away with the checkerloop is a major improvement =

there.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
