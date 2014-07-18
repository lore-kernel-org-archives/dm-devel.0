From: Hannes Reinecke <hare@suse.de>
Subject: Re: dm-multipath: Accept failed paths for multipath maps
Date: Fri, 18 Jul 2014 08:12:16 +0200
Message-ID: <53C8BAC0.2030106@suse.de>
References: <1387353155-7271-1-git-send-email-hare@suse.de>
	<20131218140858.GC17730@redhat.com> <52B1B046.3040301@suse.de>
	<1387380498.7608.6.camel@ict-vth-stewarts01.ict.englab.netapp.com>
	<20140718000411.GB337@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140718000411.GB337@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, "Stewart, Sean" <Sean.Stewart@netapp.com>
Cc: device-mapper development <dm-devel@redhat.com>, Bryn Reeves <breeves@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 07/18/2014 02:04 AM, Mike Snitzer wrote:
> On Wed, Dec 18 2013 at 10:28am -0500,
> Stewart, Sean <Sean.Stewart@netapp.com> wrote:
>
>> On Wed, 2013-12-18 at 15:25 +0100, Hannes Reinecke wrote:
>>> On 12/18/2013 03:08 PM, Mike Snitzer wrote:
>>>> On Wed, Dec 18 2013 at  2:52am -0500,
>>>> Hannes Reinecke <hare@suse.de> wrote:
>>>>
>>>>> The multipath kernel module is rejecting any map with an invalid
>>>>> device. However, as the multipathd is processing the events serially
>>>>> it will try to push a map with invalid devices if more than one
>>>>> device failed at the same time.
>>>>> So we can as well accept those maps and make sure to mark the
>>>>> paths as down.
>>>>
>>>> Why is it so desirable to do this?  Reduced latency to restore at least
>>>> one valid path when a bunch of paths go down?
>>>>
>>> Without this patch multipathd cannot update the map as long is
>>> hasn't catched up with udev.
>>> During that time any scheduling decisions by the kernel part are
>>> necessarily wrong, as it has to rely on the old map.
>>>
>>>> Why can't we just rely on userspace eventually figuring out which paths
>>>> are failed and pushing a valid map down?
>>>>
>>> Oh, you can. This is what we're doing now :-)
>>>
>>> But it will lead to spurious error during failover when multipathd
>>> is trying to push down maps with invalid devices.
>>>
>>> You are also running into a race window between checking the path in
>>> multipathd and pushing down the map; if the device disappears during
>>> that time you won't be able to push down the map.
>>> If that happens during boot multipathd won't be able to create the
>>> map at all, so you might not be able to boot here.
>>> With that patch you at least have the device-mapper device, allowing
>>> booting to continue.
>>>
>>>> Are there favorable reports that this new behavior actually helps?
>>>> Please quantify how.
>>>>
>>> NetApp will have; they've been pushing me to forward this patch.
>>> Sean?
>>>
>> Agree.  Internally, we have run into numerous cases with Red Hat where
>> the "failed in domap" error will occur, due to user space being behind,
>> or device detaching taking too long.  The most severe case is with
>> InfiniBand, where the LLD may place a device offline, then every single
>> reload that is trying to add a good path in will fail.  I will qualify
>> this by saying that I realize it is a problem that the device gets
>> placed offline in the first place, but this patch would allow it a
>> chance to continue on. The user still has to take manual steps to fix
>> the problem in this case, but it seems less disruptive to applications.
>>
>> The device detaching case could be kind of disruptive to a user in the
>> scenario they are upgrading the firmware on a NetApp E-Series box, and
>> with this patch, at least a good path is able to be added in ASAP.
>>
>>> BTW, SUSE / SLES is running happily with this patch for years now.
>>> So it can't be at all bad ...
>>>
>>> Cheers,
>>>
>>> Hannes
>>
>> Also agreed.  We have seen this functionality in SLES for years, and
>> have not run into a problem with it.
>
> Revisiting this can of worms...
>
> As part of full due-diligence on the approach that SUSE and NetApp have
> seemingly enjoyed "for years" I reviewed Hannes' v3 patch, fixed one
> issue and did some cleanup.  I then converted over to using a slightly
> different approach where-in the DM core becomes a more willing
> co-conspirator in this hack by introducing the ability to have
> place-holder devices (dm_dev without an opened bdev) referenced in a DM
> table.  The work is here:
> http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=3Dth=
rowaway-dm-mpath-placeholder-devs
>
> Here is the diffstat of all 3 patches rolled up:
>
>   git diff d4bdac727f1e09412c762f177790a96432738264^..7681ae5ddb5d5678000=
23477be7ddc68f9812a95 | diffstat
>   dm-mpath.c |   51 +++++++++++++++++++++++++++++++++++----------------
>   dm-table.c |   53 ++++++++++++++++++++++++++++++++++++++++-------------
>   dm.c       |    5 ++---
>   dm.h       |   12 ++++++++++++
>   4 files changed, 89 insertions(+), 32 deletions(-)
>
> But it was only compile tested, because doing more validation of this
> work would mean it has a snowballs chance in hell of seeing the light of
> upstream.  Sadly it doesn't have a good chance; it would require some
> compelling proof:
> 1) that mpath is bullet-proof no matter how crazy a user got with fake
>     place-holder devices in their DM tables (coupled with reinstate_path
>     messages, etc)
At worst the user ends up with tables packed with non-existing =

devices. Which would be equivalent to a table with all paths failed.
So from that I don't see a problem.
We only might run into issues where userspace fails to do proper =

garbage collection on those tables. But then again, this can happen =

nowadays, too, when all paths from a large configuration drop =

suddenly and multipathd crashes.

> 2) that the storage configs that experienced problems with the current
>     DM mpath dm_get_device() failures weren't broken to start with (for
>     instance ib srp is apparently fixed now.. but those fixes are still
>     working their way into RHEL) -- or put differently: I need _details_
>     on the NetApp or other legit storage configs that are still
>     experiencing problems without a solution to this problem.
>
This has nothing to do with 'legit' storage configs, this is a =

direct result of the udev event handling and the internal multipathd =

path checker logic.

udev event are issue sequentially, so multipathd has to process them =

one at a time (it even has a udev receiving thread which basically =

ensures sequential processing).

multipathd then has to process the event, and update the device =

table _based on that event_. At that time it simply _cannot_ know if =

there are other events relating to the same table queued.
If there are, multipathd has no other choice than to push an invalid =

table down into the kernel.

> ... and even with that proof I'm pretty sure Alasdair will hate this
> place-holder approach and will push for some other solution.
>
> I'm going away on paternity leave until Sept 8... my _hope_ is that
> someone fixes multipath-tools to suck less or that a more clever
> solution to this problem is developed locally in DM mpath.
>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
