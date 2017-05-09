From: Peter Rajnoha <prajnoha@redhat.com>
Subject: Re: [mdadm PATCH] Create: tell udev md device is not ready when first
 created.
Date: Tue, 9 May 2017 13:57:03 +0200
Message-ID: <469b0f73-f7ee-aaa0-f48d-76e569cd5eb7@redhat.com>
References: <149265560315.31004.3851231165281498425.stgit@noble>
 <149265600601.31004.323865505557190368.stgit@noble>
 <dedd27cd-9c2e-f244-d8aa-7a074679d3c6@gmail.com>
 <87mvbasqx6.fsf@notabene.neil.brown.name>
 <40a5fbff-9eef-07b3-fe1b-fb9a888cfb8b@redhat.com>
 <87h919ruj5.fsf@notabene.neil.brown.name>
 <6bd347e1-170c-48e9-1171-09ff143ace83@redhat.com>
 <c5fe5d16-5ca6-94b0-fd5b-0b6009d78bab@gmail.com>
 <2f431da6-0dce-b485-4109-6f8669814430@redhat.com>
 <590DF8FA.4090600@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <590DF8FA.4090600@youngman.org.uk>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Jes Sorensen <jes.sorensen@gmail.com>, NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On 05/06/2017 06:25 PM, Wols Lists wrote:
> On 03/05/17 15:13, Peter Rajnoha wrote:
>> There's a difference though - when you're *creating* a completely new
>> device that is an abstraction over existing devices, you (most of the
>> time) expect that new device to be initialized. For those corner cases
>> where people do need to keep the old data, there can be an option to do
>> that.
> 
> That's not a corner case. If there's old data that's the NORM. I get
> what you're after, I'm inclined to agree with you, but the default
> should be to DO NOTHING.
> 
Well, if keeping old data is norm or not (IOW, if wiping is going to be
default or not) - I'm not going to hassle about this. But at least we
should let users to decide on command line directly. If mdadm decides to
do this part somewhere outside by some other external tool, it should at
least coordinate with that tool then - that's an alternative.

I just think it's not that common to take raw disks with some old data
(presumably starting at the beginning of the disk or some offset) and
then using these disks to create a new MD device on top of them and then
for us to expect we see exactly same data content - maybe yes with a
luck, but usually, the MD signature reserves some space at the beginning
(and/or end) of the device to write its signatures (which overwrites
some of the old content anyway).

The use case where keeping the old data would probably make more sense
is when you had those disks already used by an MD device, then you wrote
some data/content to the MD device, then you removed the MD device and
then you recreate it again with exactly the same raid level and with
exactly the same MD signature lengths as before so you end up with the
same data area revealed by the fresh MD device. Now, the question is,
how many users do this? (yes, for recovery, but probably not for fresh
new array)

Anyway, I'm still OK to have the wiping disabled by default, but what I
want to see is that option to do enable the wiping on demand at least
for mdadm.

The patch as it was proposed and written automatically marks device as
not usable (SYSTEMD_READY=0) on new MD device creation directly in udev
database. So it leaves the decision on something external to mdadm.

OK then, let's wipe it ourselves by calling, for example, "wipefs -a" on
that MD device - the wiping is done and the SYSTEMD_READY=0 flag is
dropped due to the WATCH udev rule that fires (and synthesizes CHANGE
uevent that causes the rules and udev db values to be reevaluated). This
works.

And now the other use case - to not wipe anything - user is not going to
call any wipefs-like tool, but just keeps things as they are. In this
case, for the udev database content to be correct we either need to wait
for next CHANGE uevent to happen (whatever it's cause is) OR we need to
synthesize that CHANGE uevent directly on command line by writing "echo
change > /sys/block/md.../uevent". Now, how should we educate users to
do this (quite low-level) extra call? If the extra uevent is not there,
the udev db is out-of-date simply.

If that patch stays, I think the next logical step for distributions is
to take the upstream version of mdadm and then to create a wrapper over
upstream mdadm to provide this option in addition.

So wrapped mdadm would look something like:

  call mdadm --create
  if (user_passed_option_to_do_wiping)
    call wipefs -a /dev/md_name
  else
    write "change" to /sys/block/<md_name>/uevent

I'm afraid it's going to end this way, uselessly - it could have been
directly a part of mdadm with very little cost. That cost is dependency
on libbblkid (to get the signature offsets/lenghts we need to wipe for
event-based systems to not hook on them by mistake).

Now, what is the environment where libblkid is not present and mdadm is?
libblkid is quite basic library (part of util-linux) so present on
systems widely, even in initrds. Even that systemd uses it - just to
mention that the mdadm patch uses SYSTEMD_READY variable which is on
systemd-based systems only, but anyway... I'm not going to be that picky :)

> If you want mdadm to mess about with the content of the drives you
> should either (a) explicitly tell it to (yes I would like that option
> :-), or (b) do it yourself beforehand - dd if=/dev/zero etc etc.
> 
> It does seem weird to me that mdadm spends a lot of effort initialising
> an array and calculating parity blah-di-blah, and you can't tell it to
> just "set everything to zero". But there's no way it should mess about
> with what was there before, without explicitly being told to.
> 
>  When you're inserting existing drives, you're not creating them -
>> when those device come from factory (they're "created"), they never
>> contain garbage and old data when you buy them.
> 
> As Jes says, USB devices rarely come with nothing on them. MS eventually
> learnt their lesson, "doing something" BY DEFAULT with unknown/untrusted
> data was a really stupid idea - it was far too easy to get your system
> "pwned". Here it would be far too easy to trash an array you're trying
> to recover.

Recovery, yes, I agree.

But I suppose that SUCH recovery is less frequent than creating a new md
array. Anyway, let's keep the default to not wipe, if we like it more,
but I'm begging for the mdadm to have an option to have the possibility
to do the wiping on demand so I can choose that when I'm creating a new
fresh MD device and I know for sure I don't care about old stuff that
was written before. And if I choose to not do the wiping, I want mdadm
to generate the extra uevent that's needed to update the udev database
accordingly (e.g. see the wrapper I mentioned above).

-- 
Peter
