From: Douglas McClendon <dmc.fedora@filteredperception.org>
Subject: Re: semop failed for cookie?
Date: Tue, 27 Apr 2010 22:52:36 -0500
Message-ID: <4BD7B104.8050402@filteredperception.org>
References: <4BD74F99.8020605@filteredperception.org>
	<20100427223323.GB29708@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100427223323.GB29708@agk-dp.fab.redhat.com>
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

On 04/27/2010 05:33 PM, Alasdair G Kergon wrote:
> On Tue, Apr 27, 2010 at 03:56:57PM -0500, Douglas McClendon wrote:
>> I have a user of an installation tool of mine that is hitting this
>> message, with a very recent pre-fedora-13 kernel.
>
> udev is now involved in this process.
> Check they have up-to-date lvm2 and udev packages and that they've not
> tried to customise their udev rules - if they have, you'll need to
> check their changes didn't break things.

Thanks for the reply and the advice.  I'm not so interested in the issue 
that I'll necessarily get to it very soon, but what you said will no 
doubt help.

One thing though, which may not have been obvious, and almost sounds 
dubious, is what I'm actually doing there.  I'll try to describe it in 
words here, to see if this shouts out as a situation that may no longer 
be expected to work (because honestly I was probably pretty pleased and 
half-surprised to discover that it did work 3 years ago)-

Basically the livecd mode you should be familiar with.  ext3 image on a 
loop device.  cow file in tmpfs on a loop device.  Combined with 
dm-snapshot, resulting in what is used as the rootfs device.  Simple enough.

So what I do (and this is dusty code I haven't payed attention to in a 
long time, so maybe I'm misunderstanding my own code, but probably not) 
is this-

1) with that dmsetup create that is now failing, I first create a 
duplicate device (different name, same table) as the one that the 
rootfs.  I.e. another snapshot device with the same components/table.

2) I use a reload --table on the device that is the rootfs, to replace 
it with a new table, that is a mirror of the device created in (1) and 
the target normal hard disk partition that the script is installing the 
OS to.

3) I do a resume on the rootfs device such that the new table with the 
mirror activates, and the migration starts to occur

4) when the mirror completes, I do another reload then resume with a new 
linear table pointing to the newly installed fs on normal disk 
partition.  Then I tear down all the unused original devices.

So, if something about this description screams out- the new udev 
semantics will prevent (1) from working, let me know.


>
> Big script.
>
> Debug it by adding lines to dump the state immediately before the problem
> command, then immediately after it.
>
> Dump state by running 'dmsetup info -c', 'dmsetup table', 'dmsetup status'
> and 'dmsetup udevcookies'.
>
> If that still doesn't help, break the 'dmsetup create' command down into
> its three constituent commands (dmsetup create --notable, dmsetup load,
> dmsetup resume) and dump the state between each of them and confirm
> which is failing.

Sounds good.  Again, what I'm doing with two devices with the same table 
smells like something that might have been inadvertently allowed before 
and now not.  Or maybe other people do it all the time for other reasons 
I'm not considering right now.

-dmc


>
> Alasdair
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
