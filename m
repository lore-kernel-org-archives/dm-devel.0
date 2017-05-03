From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [dm-devel] [mdadm PATCH 4/4] Create: tell udev device is not
 ready when first created.
Date: Wed, 3 May 2017 10:41:08 -0400
Message-ID: <79314857-0cb3-2599-adc3-a39594316809@gmail.com>
References: <149265560315.31004.3851231165281498425.stgit@noble>
 <149265600601.31004.323865505557190368.stgit@noble>
 <dedd27cd-9c2e-f244-d8aa-7a074679d3c6@gmail.com>
 <87mvbasqx6.fsf@notabene.neil.brown.name>
 <40a5fbff-9eef-07b3-fe1b-fb9a888cfb8b@redhat.com>
 <87k265rxsm.fsf@notabene.neil.brown.name>
 <f9977410-5a8e-1a78-1406-fc9875f83d13@redhat.com>
 <8737cpry7u.fsf@notabene.neil.brown.name>
 <65882238-57f0-dcef-645b-0ab1ab9cdc91@redhat.com>
 <88ba4ec0-9c4d-aa07-b9b5-66cad893e130@gmail.com>
 <4b422ccc-b666-e9ae-4067-cb0c4e407c04@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4b422ccc-b666-e9ae-4067-cb0c4e407c04@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rajnoha <prajnoha@redhat.com>, NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On 05/03/2017 10:27 AM, Peter Rajnoha wrote:
> On 05/02/2017 03:40 PM, Jes Sorensen wrote:
>> On 05/02/2017 07:40 AM, Peter Rajnoha wrote:
>>> On 05/01/2017 06:35 AM, NeilBrown wrote:
>>>> On Fri, Apr 28 2017, Peter Rajnoha wrote:
>>>>> Then mdadm opens the devive, clears any old content/signatures the data
>>>>> area may contain, then closes it - this generates the third event -
>>>>> which is the "synthetic change" event (as a result of the inotify WATCH
>>>>> rule). And this one would drop the "not initialized" flag in udev db
>>>>> and
>>>>> the scans in udev are now enabled.
>>>>
>>>> Nope, it would be incorrect for mdadm to clear any old content.
>>>> Sometimes people want to ignore old content.  Sometimes they very
>>>> definitely want to use it.  It would be wrong for any code to try to
>>>> guess what is wanted.
>>>
>>> The mdadm is not going to guess - it can have an option to
>>> enable/disable the wiping on demand directly on command line (which is
>>> also what is actually done in LVM).
>>
>> I know the anaconda team keeps pushing for the nonsense of being able to
>> wipe drives on creation. It is wrong, it is broken, and it is not going
>> to happen.
>
> I'm not thinking about anaconda at the moment at all. It's just one of
> the many users of mdadm. I'm thinking about a fix in general for all the
> users which expect the device to be initialized properly when mdadm
> --create returns.

Well mdadm --create already initializes the array properly, so problem 
solved.

I saw this request repeatedly when I worked at Red Hat, and I got it 
again from my replacement who had been asked to do the same dirty work 
that I refused to do. Now we see the same request from you, so it is 
rather easy to assume it came from there again.

>>> Otherwise, if mdadm is not going to wipe/initialize the device itself,
>>> then it needs to wait for the external tool to do it (based on external
>>> configuration or on some manual wipefs-like call). So the sequence
>>> would be:
>>>
>>>  1) mdadm creating the device
>>>  2) mdadm setting up the device, marking it as "not initialized yet"
>>>  4a) mdadm waiting for the external decision to be made about wiping part
>>>  4b) external tool doing the wiping (or not) based on configuration or
>>> user's will
>>>  5) mdadm continuing and finishing when the wiping part is complete
>>>
>>> I expect mdadm to return only if the device is properly initialized
>>> otherwise it's harder for other tools called after mdadm to start
>>> working with the device - they need to poll for the state laboriously
>>> and check for readiness.
>>
>> What defines readiness? Some believe a raid1 array must be fully
>> assembled with all members, other setups are happy to have one running
>> drive in place.....
>
> With "ready" I mean the time when it's safe to do a scan without seeing
> old data (garbage) that may confuse udev hooks and udev event listeners.
> That scan is done at some time - at the time the activating "change"
> uevent comes and this rule does not pass
> ATTR{md/array_state}=="|clear|inactive" (if it passes, the device is not
> scanned yet).

I am not sure what you mean by old data here?

>> 4a/4b in your list here once again has no place in mdadm. Please kindly
>> tell the anaconda team to go back and handle this properly instead.
>
> The mdadm is creating the dev and so it should be responsible primarily
> for providing a device which is cleared and ready for use without
> causing any confusion on event-based system where various scans are
> executed based on incoming udev events.

This is exactly what it does. There is no difference to how mdadm does 
it compared to how it works if you plugin a new USB drive which may have 
data on it or if you assemble an iSCSI device that has metadata on it. 
Are you also going to suggest the iSCSI tools have a wipe metadata mode 
added to them?

> Alternatively, if mdadm is not going to be the place where the wiping
> happens, I'd expect at least the sequence above (which is more complex,
> yes, that's why I think having the wiping directly in mdadm is much
> easier solution).
>
> If you don't wipe the data and you don't give time for others to hook in
> to do that, you make it harder for others (they need to deactivate all
> the stack/garbage that is found in the data area after previous use).
>
> Also, we can't reliably call wiping on the underlying components first,
> because once they become MD components, the data are for the MD device
> has an offset and new data range is revealed from the underlying devices
> which may expose old signatures which were not visible on those
> underlying devices before the MD device got created.

Yes there is a risk that creating an array that exactly matches old 
metadata despite those signatures haven gotten wiped. This is a feature, 
people use it to recover their data, and it is not going to be removed.

If you don't want this, disable automatic processing of udev events that 
may do something on top of it. This is what anaconda should be doing.

Jes

