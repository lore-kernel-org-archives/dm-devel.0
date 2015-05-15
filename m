From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: snapshot-origin freezes system - what am I doing
	wrong?
Date: Fri, 15 May 2015 20:56:15 +0200
Message-ID: <5556414F.5030102@redhat.com>
References: <5555CE5D.3030404@web2web.at>	<5555E25A.2040106@redhat.com>	<55562315.4060707@web2web.at>	<555633DE.9060002@redhat.com>
	<55563F98.3070809@web2web.at>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <55563F98.3070809@web2web.at>
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

Dne 15.5.2015 v 20:48 Atom2 napsal(a):
> Am 15.05.15 um 19:58 schrieb Zdenek Kabelac:
>> Dne 15.5.2015 v 18:47 Atom2 napsal(a):
>>> Am 15.05.15 um 14:11 schrieb Zdenek Kabelac:
>>>> Dne 15.5.2015 v 12:45 Atom2 napsal(a):
>>>>> Hello list,
>>>>> I am trying to setup a cow snapshot for a LV that is used as a master image
>>>>> for a number of VMs. The idea basically is to be able to update the master
>>>>> image even when VMs are up and running; the VMs should then still see the
>>>>> old
>>>>> state of the image and only when they are restarted they should connect
>>>>> to the
>>>>> new image.
>>>>> Searching the net seemed to point towards a snapshot-origin/snapshot
>>>>> solution
>>>>> - however I am unable to get this to work. Information on the net seems
>>>>> to be
>>>>> sparse, so I though I'd ask the experts on the list. Here are my steps:
>>>>>
>>>>> 1.) I have a LV in volume group VG named master.ROOT
>>>>> (/dev/mapper/VG-master.ROOT), 8GB, formatted as ext4
>>>>> 2.) I create a sparese file: truncate -size=8G /tmp/snapshot
>>>>> 3.) losetup -f /tmp/snapshot --> gives /dev/loop0
>>>>> 4.) dmsetup create mytest.img --table "0 $(blockdev --getsz
>>>>> /dev/mapper/VG-master.ROOT) snapshot-origin /dev/mapper/VG-master.ROOT
>>>>> 5.) dmsetup create mytest.img.cow --table "0 $(blockdev --getsz /dev/loop0)
>>>>> snapshot /dev/mapper/VG-master.ROOT /dev/loop0 P 8"
>>>>>
>>>>> So far so good ... however, when I try to mount the origin device by
>>>>> 6.) mount /dev/mapper/mytest.img
>>>>> the mount call doesn't return and the system gets unresponsive/freezes up
>>>>> to a
>>>>> point when OOM-killer is being invoked. Login attempts on the console
>>>>> time out
>>>>> and in essence it is only possible to reboot the system using
>>>>> magic-sysreq key
>>>>> combinations.
>>>>>
>>>>> I'd be very much obliged if someone in the know could provide me with
>>>>> information what's wrong with this approach.
>>>>>
>>>>> Many thanks in advance Atom2
>>>>
>>>> Do you have any  scientific reason to not  use LVM2  here ?
>>> As far as I understand the snapshot-origin target with a cow snapshot is not
>>> (yet) directly supported by LVM2.
>>
>> Just curious - from where have you got this idea ??
> Well I simply haven't found anything within LVM2 that supports my use case.
> Everything I have found is about buffering writes to the original device such
> that the original device appears unchanged.
> I am, however, curious as well: What makes you think that my use case is
> covered by pure LVM2? Do you have a link with the steps required - that would
> be great!
>>
>>>
>>> Therefore I have so far worked from an assumption that I need to use dmsetup
>>> directly to solve my use case. If, however, you tell me otherwise and are able
>>> to show me how to use LVM2 instead, I am more than happy to go down that
>>> route. Let me once again outline my use case:
>>>
>>> I have a LV (that's the master image/template which was actually setup with
>>> LVM2) which is maintained from within a template VM and serves as the (r/o)
>>> root image for a number of other (dependent) virtual machines. All dependent
>>> virtual machines mount that template LV r/o and overlay it with an overlayfs
>>> as a r/w layer for write access.
>>> I now want to be able to update the master image from within the template VM
>>> and be able to update it at any time; running dependent VMs should however not
>>> see any changes to the image while they are up, hence the requirement to have
>>> a snapshot-origin target and a snapshot that would cow buffer any changes in
>>> the template (origin) target until such time the dependent VM is restarted. At
>>> that point in time the dependent VM would (if required setup and) connect to a
>>> new snapshot.
>>>
>>> I hope that clarifies my setup.
>>>
>>> Furthermore, IMHO and in any case mounting a dm-target should under no
>>> circumstances in essence bring down a machine - even if something is horribly
>>> wrong.
>>>
>>>> Management of snapshot target is not trivial - especially the order
>>>> of individual table loads and resumes.
>>>>
>>>> You could look at  'lvcreate -s -vvvv' if you are interested in ioctl
>>>> ordering of all operations here.
>>>>
>>> I am probably missing something here, but my steps listed above do not involve
>>> lvcreate ... so how could I use that -vvv?
>>>
>>
>> Well even kernel documentation for the snapshot target itself is rather
>> referencing usage of snapshot via lvm2 - and it's for a reason.
> I have seen that, but I got the impression, that's the other way round to what
> I require: It creates a snapshot that copies writes to the original device in
> order for the original volume to be in a consitent state e.g. for bacups;
> those writes will then later be merged back to the original volume. That's,
> however, unfortunately not what I require. What I require is that upon a write
> to the original device the _old_ block is copied to the snapshot cow device so
> that any process accessing the snapshot has a consistent (and unchanged) view
> of the original device. The original device itself will change!
>>
>> https://www.kernel.org/doc/Documentation/device-mapper/snapshot.txt
>>
>> So if you could use  lvm2 - stay with lvm2 and avoid your home-brew dmsetup
>> commands - it needs deep understanding how the old snapshot target works:
>>
>> http://people.redhat.com/agk/talks/LVM2-LinuxTag2006/
> It looks as if I am not smart enough and (at least) in the area of
> device-manager (which is expected) you are much smarter than me. So let me
> pick your brain: Would you be so kind to outline the steps required for me to
> be able to setup my use case with LVM2: Again, I need a snapshot device that
> only stores changed blocks from the snapshot-origin device (which is used
> somewhere else) and routes unchanged read requests back to the origin device.
> I am still not sure whether we are on the same page here.
>
> I am also very curious to understand why the exact same steps outlined further
> above _do_ work when both the snapshot-origin device and the snapshot device
> are based on losetup (spares-)file based block devices and fail when the
> snapshot-origin device is a block device created by LVM2 and only the snapshot
> device is a losetup (sparse-)file based block device.
>
> Many thanks again for your patience, but I'd very much appreciate if you could
> be more explicit in your (at least for me) rather vague answers. I am also
> happy to join a session on IRC - but that channel seems to be pretty orphand
> at all times.

I'm not saying  lvm2 solves your original problem - which I still don't seem 
to understand -  I'm just saying you need to look at how lvm2 is ordering 
ioctls with loads & resumes of targets when making snapshot.

IMHO old snapshot is quite complicated and maybe you should take a look at 
this provisioning support - especially if you think in terms of having lots of 
snapshot of single master volume - usage of old-snapshot target is pretty much 
dead road....

Regards

Zdenek
