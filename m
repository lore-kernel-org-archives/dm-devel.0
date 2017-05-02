From: NeilBrown <neilb@suse.com>
Subject: Re: [dm-devel] [mdadm PATCH 4/4] Create: tell udev device is not ready when first created.
Date: Wed, 03 May 2017 07:42:39 +1000
Message-ID: <87bmrbq6k0.fsf@notabene.neil.brown.name>
References: <149265560315.31004.3851231165281498425.stgit@noble> <149265600601.31004.323865505557190368.stgit@noble> <dedd27cd-9c2e-f244-d8aa-7a074679d3c6@gmail.com> <87mvbasqx6.fsf@notabene.neil.brown.name> <40a5fbff-9eef-07b3-fe1b-fb9a888cfb8b@redhat.com> <87k265rxsm.fsf@notabene.neil.brown.name> <f9977410-5a8e-1a78-1406-fc9875f83d13@redhat.com> <8737cpry7u.fsf@notabene.neil.brown.name> <65882238-57f0-dcef-645b-0ab1ab9cdc91@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <65882238-57f0-dcef-645b-0ab1ab9cdc91@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rajnoha <prajnoha@redhat.com>, Jes Sorensen <jes.sorensen@gmail.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


I'm sorry, but I didn't read all your words.

You seemed to be telling me about extra complexity in udev, and extra
complexity that you think belongs in mdadm, which together might achieve
your vision for how things should work.

But to me, complexity is the enemy.  Give me "simple" any day.

NeilBrown


On Tue, May 02 2017, Peter Rajnoha wrote:

> On 05/01/2017 06:35 AM, NeilBrown wrote:
>> On Fri, Apr 28 2017, Peter Rajnoha wrote:
>>=20
>>> On 04/28/2017 05:55 AM, NeilBrown wrote:
>>>> On Wed, Apr 26 2017, Peter Rajnoha wrote:
>>>>
>>>>> On 04/20/2017 11:35 PM, NeilBrown wrote:
>>>>>> If we wanted an more permanent udev rule, we would need to record the
>>>>>> devices that should be ignored in the filesystem somewhere else.
>>>>>> Maybe in /run/mdadm.
>>>>>> e.g.
>>>>>>
>>>>>>  KERNEL=3D=3D"md*", TEST=3D"/run/mdadm/creating-$kernel", ENV{SYSTEM=
D_READY}=3D"0"
>>>>>>
>>>>>> Then we could have something like the following (untested) in mdadm.
>>>>>> Does that seem more suitable?
>>>>>>
>>>>>
>>>>> Yes, please, if possible, go for a permanent udev rule surely - this
>>>>> will make it much easier for other foreign tools to hook in properly =
if
>>>>> needed and it would also be much easier to debug.
>>>>
>>>> I'm leaning towards the files-in-/run/mdadm approach too.  I'll make a
>>>> proper patch.
>>>>
>>>>>
>>>>> But, wouldn't it be better if we could just pass this information ("n=
ot
>>>>> initialized yet") as RUN_ARRAY md ioctl parameter? In that case the md
>>>>> driver in kernel could add the variable to the uevent it generates wh=
ich
>>>>> userspace udev rules could check for easily. This way, we don't need =
to
>>>>> hassle with creating files in filesystem and the information would be
>>>>> directly a part of the uevent the md kernel driver generates (so
>>>>> directly accessible in udev rules too). Also, possibly adding more
>>>>> variables for other future scenarios if needed.
>>>>
>>>> When would we clear the "not initialised yet" flag in the kernel, and
>>>> how?  And would that be enough.
>>>
>>> The flag wouldn't be stored in kernel, md kernel driver would just pass
>>> the flag with the uevent as it received in with ioctl/sysfs request to
>>> create a new dev. The udev in userspace would handle the state
>>> transition then from "flagged as not-initialized" state to "initilized"
>>> by checking the sequence of events as they come.
>>>
>>> We should have this sequence I assume:
>>>
>>>   1) "add" (creating dev, not usable yet)
>>>   2) "change" (activated dev, but not initialized yet)
>>>   3) "synthetic change" (after wiping the dev and closing it, the WATCH
>>> rule fires)
>>>
>>=20
>> "Should" is arguable, but there are no guarantees of this sequence.
>>=20
>> A particular cause of irregular sequencing is when an array is assembled
>> by the initrd, then after the real root is mounted, something runs
>>   udevadm trigger --action=3Dadd
>> (e.g. systemd-udev-triggger.service).
>>=20
>> In that case, 'add' is the first and only message that the
>> full-root-available udev sees, so it is not safe to ignore the array as
>> "not usable yet".
>>=20
>>=20
>
> As for initrd case, there's OPTIONS+=3D"db_persist" rule which is already
> used by dracut to keep udev db records when switching from initrd to
> root fs and replacing the udev daemon instance (other devices which do
> not have this option set will have udev db records cleared when switched
> to root fs). Not sure why it's not documented in udev yet (I already
> asked for that years ago), but the support is definitely there. So
> there's already a way to keep these records and to not lose track of the
> current state when switching from initrd. This makes it still possible
> to detect whether the synthetic "add" (or "change") event is sent before
> or after proper device initialization and to make it possible to react
> on the trigger (with synthetic uevents generated) still while ignoring
> the "add" event if that comes from the kernel before the device is
> initialized. And even if we're switching from initrd to root fs and
> restarting udev daemon.
>
>>>>
>>>> When mdadm creates an md array, at least 3 uevents get generated.
>>>> The first is generated when the md device object is created, either by
>>>> opening the /dev/mdXX file, or by writing magic to somewhere in sysfs.
>>>> The second is generated when the array is started and the content is
>>>> visible.
>>>> The third is generated when mdadm closes the file descriptor.  It opens
>>>> /dev/mdXX for O_RDWR and performs ioctls on this, and then closes it.
>>>> Because udev uses inotify to watch for a 'close for a writable file
>>>> descriptor', this generates another event.
>>>>
>>>> We need to ensure that none of these cause udev to run anything that
>>>> inspects the contents of the array.
>>>> Of the three, only the second one is directly under the control of the
>>>> md module, so only that one can add an environment variable.
>>>>
>>>> It might be possible to avoid the last one (by not opening for write),
>>>> but I cannot see a way to avoid the first one.
>>>
>>> So the first event is the "add" event ("md device object created") - in
>>> this case, the device is not yet usable anyway I suppose, so we can skip
>>> udev scans for this event right away (unless it's the synthetic "add"
>>> event which is generated by writing "add" to /sys/block/.../uevent file
>>> or alternatively using udevadm trigger - but we should be able to
>>> recognize this event "synthetic add event" because it always comes after
>>> the activating "change" event, otherwise we can skip scans).
>>=20
>> "not yet usable anyway" is not reliable.  It is very easy for mdadm to
>> finish making the array usable before udev gets around to processing the
>> initial "add" event.
>
> But in that case, there's certainly going to be a "change" event right
> after. We shouldn't skip the "add" completely and pretend it's the
> "change" now - there are rules for "add" events and rules for "change"
> events. The fact that things can change underneath while the event is
> being processed is something we need to count with in udev environment.
> The rules for "add" and "change" can be different. Also, various udev
> listeners/event subscribers can rely on this - otherwise we can't come
> up with proper state machine to check the sequence of events.
>
>>=20
>> You seem to be suggesting that udev rules should try to reverse-engineer
>> the sequence of events and deduce what is meant from that sequence.  I
>> doubt that would be very robust.
>>=20
>>=20
>
> I wouldn't say reverse-engineering. The rules expect certain sequence
> during device setup and initialization. And if the events are coming out
> of order, we can at least detect something is wrong. If we have "add"
> for device addition and then "change" to complete the device setup
> (which is happening for dm and md devices), this rule is static and
> stable. As for the out-of-band synthetic uevents (the udevadm trigger or
> echo add/change > /sys/.../uevent, the WATCH rule...), this is different
> - the event has its source in userspace which is causing it, not the
> kernel driver directly. Synthetic uevents are separate - we can
> recognize them, but that kernel patch I mentioned will help us here even
> more to make the rules easier to detect this.
>
>>>
>>> The second event, which is the "change" event, would be marked with the
>>> new "not initialized" flag. And so we skip the scans in udev too.
>>=20
>> (one obvious problem with this approach is that it cannot work with old
>> kernels, while my approach only requires an update to mdadm)
>>=20
>
> The fact we need to update the kernel is true, but does it really
> matter? Such kernel patch is going to be small and easy to backport if
> needed for distributions with older kernels.
>
> This is all about providing the straightforward way of detecting the
> uevents - if we have only ADD and CHANGE while certain subsystem needs
> more to differentiate uevents further (like md and dm which can't simply
> map its events to those 2 events only), adding a variable to the event
> to make this difference clear is the most straightforward and clean way
> to do that I think. We don't need to rely on anything outside udev
> environment itself - it's directly a part of it as a variable in uevent
> which is already happening with certain events - e.g. change with with
> DISK_RO=3D1 set and there are lots of other existing examples...
>
> (Another way would be to introduce completely new uevents besides
> add/change/remove. That's also possible, but harder-to-deploy solution.)
>
>>>
>>> Then mdadm opens the devive, clears any old content/signatures the data
>>> area may contain, then closes it - this generates the third event -
>>> which is the "synthetic change" event (as a result of the inotify WATCH
>>> rule). And this one would drop the "not initialized" flag in udev db and
>>> the scans in udev are now enabled.
>>=20
>> Nope, it would be incorrect for mdadm to clear any old content.
>> Sometimes people want to ignore old content.  Sometimes they very
>> definitely want to use it.  It would be wrong for any code to try to
>> guess what is wanted.
>>=20
>>=20
>
> The mdadm is not going to guess - it can have an option to
> enable/disable the wiping on demand directly on command line (which is
> also what is actually done in LVM).
>
> Otherwise, if mdadm is not going to wipe/initialize the device itself,
> then it needs to wait for the external tool to do it (based on external
> configuration or on some manual wipefs-like call). So the sequence would =
be:
>
>  1) mdadm creating the device
>  2) mdadm setting up the device, marking it as "not initialized yet"
>  4a) mdadm waiting for the external decision to be made about wiping part
>  4b) external tool doing the wiping (or not) based on configuration or
> user's will
>  5) mdadm continuing and finishing when the wiping part is complete
>
> I expect mdadm to return only if the device is properly initialized
> otherwise it's harder for other tools called after mdadm to start
> working with the device - they need to poll for the state laboriously
> and check for readiness.
>
>>>
>>> So we should be able to handle all three kinds of events I think.
>>>
>>> Now, as for even better synthetic event recognition, I've proposed a
>>> patch recently where udev as well as any other tool generating these
>>> synthetic events can add variables for more detailed event
>>> identification, so this one should help us in the future even more in
>>> these situations: https://lkml.org/lkml/2017/3/15/461. With this, we can
>>> even disable the WATCH rule till the device is properly initialized and
>>> the tool can generate the event itself by writing the
>>> /sys/block/.../uevent file with a variable that the tool can then wait
>>> for even (so the tool doesn't exit till the device is not properly
>>> initialized). Once this initialization is all done, the WATCH rule can
>>> be enabled for the dev. Also, with this, we don't need to be afraid that
>>> some other tool fired the WATCH rule by chance if it opened the dev for
>>> RW and closed it by mistake before we had a chance to initialize it
>>> (which would fire the synthetic change event before the
>>> wiping/initialization).
>>=20
>> It sounds to me like you are adding a lot of complexity to an
>> already-fragile system.  I'm not filled with confidence - sorry.
>>=20
>
> It would be great if we agree on some standard here. A variable directly
> in the uevent is one of such standards (of course, then we need to agree
> on variable naming and their meaning - but that's what I'm heading to).
>
> Once the kernel patch is in, I'll propose a patch for the udev daemon to
> add variable to detect the events coming from WATCH rule, the events
> coming from the trigger etc. So we can make a proper difference and
> rules can react to the events the most suitable way. But important here
> is that it's going to be marked in standard way. This, I believe,
> removes the fragility of the system where each subsystem is doing it's
> own magic to handle these events in non-standard ways... or saying it's
> impossible to detect and make a difference among events at all and hence
> giving up.
>
> I'm not saying that using out-of-band information channels like custom
> file somewhere in filesystem doesn't do its job, but it's surely
> creating an exception. Creating rules with such exceptions can cause
> situations which are harder to debug and harder to follow correctly if
> we're tracking whole stacks with different types of devices.
>
> In addition to that, with the possibility to add extra variables in
> synthesized uevents we're also able to wait for the event (via udev
> monitor) and that way, we can wait for the udev rules to be applied
> before continuing further with the tool that caused the synthesized
> uevent. Then, we can avoid code where we wait for some random time, for
> example (from the suggested patch):
>
> +	/* Give udev a moment to process the Change event caused
> +	 * by the close.
> +	 */
> +	usleep(100*1000);
> +	udev_unblock();
>
> In this case, for example, we can generate an event by writing to the
> /sys/.../uevent file instead of relying on the WATCH rule and then wait
> for that properly since we can set a variable which we recognize when it
> gets back to us via uevent monitor.
>
> So it's not adding that much complexity. Compare that to the time we
> spent on debugging these things when the timing doesn't happen to be idea=
l.
>
> --=20
> Peter
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlkI/U8ACgkQOeye3VZi
gbkIBw/+KbtG2dF60AQkJq/aI4R2IWIozgc6jj+wu9wheBtY2NM6HvdpuBaWuG4+
/j9SZ2MxQ+YY4kHFxz6Sid4NukVQtPQTop+4zg0n8Dr5xv3Fx58Q28i8nCU1C2I+
OrpRNooH7BqtNdQmsSTR46fHKPT0UvJjbhrPeJePms9ZCEy/FxKEHrcQ5pwH8tgN
hqccWLObQywcq9v+Iyra4wgjVVZSdXCnZF1wBZ9W+QjRFTMkGifsFE3CtGU9DIvY
33v8rsLPb34K7Uyc1b2LzPyQqfloco5tXaDvX0b173hokyo/SwJhDa4cTy1RlEGu
EEHpWiibfNXM8c87+kPfJ4tueHyngp4lR2tPcXbwO7tN6IWn2i/2vk9O/sFIPKB2
i5hRVyQ9y5ZRPzog8byVbNgf111K0P2qg2iA6W2R8VOODRmUeGPFBCT7Jvt10hJN
OS8SxF8d3LE7AllU4fZ6+xFfubPCsNgwtOLXLyXYFlDitwcouzqxNPlBN7bQDuj0
y+SDmgbPdJuF1HOPF0Nf/PSJOYISX2bQobeqPGKT0vZ33OSRpMDsqW9jp6hdA5S7
lINzRfD2b7vXwa9P933uis6XviFMxGioGjzTxNU8o+2xkraZ/9QY6jXCz9e0HYp1
USeUnTQW30Y/AdaN2a90ANYo1+iyWzLbJeF9i05RQQIm0swoaq4=
=/9lZ
-----END PGP SIGNATURE-----
--=-=-=--
