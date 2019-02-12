From: "John Stoffel" <john@stoffel.org>
Subject: Re: Possible bug in mirror target
Date: Tue, 12 Feb 2019 17:36:43 -0500
Message-ID: <23651.19067.298943.820452@quad.stoffel.home>
References: <CAN-y+EKdQnRWck4B3Ms0ZGHqEL4+V+xPb-G3vhPy+Qe0DMO0oA@mail.gmail.com>
	<27e658d7-265f-b765-1b19-d61f52da8457@redhat.com>
	<23648.40558.660430.523285@quad.stoffel.home>
	<84219415-de11-5b28-ec2f-68ee7e74c4b0@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <84219415-de11-5b28-ec2f-68ee7e74c4b0@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: dm-devel@redhat.com, John Stoffel <john@stoffel.org>, Drew Hastings <dhastings@crucialwebhost.com>
List-Id: dm-devel.ids

>>>>> "Zdenek" =3D=3D Zdenek Kabelac <zkabelac@redhat.com> writes:

Zdenek> Dne 10. 02. 19 v 22:58 John Stoffel napsal(a):
>>>>>>> "Zdenek" =3D=3D Zdenek Kabelac <zkabelac@redhat.com> writes:
>> =

Zdenek> Dne 05. 02. 19 v 1:47 Drew Hastings napsal(a):
>>>> Hi,
>>>> =

>>>> I'm assuming all user space code is expected to use the handle_errors =
feature,
>>>> so this isn't that big of a deal. I'm also using 4.19.13, which I thin=
k is
>>>> more recent than the latest update to=A0dm-raid1.c
>>>> =

>>>> That said, there may be a bug that causes the entire mirror to crash i=
f there
>>>> is an error on the first leg of the mirror, but not on the 2nd leg.
>>>> =

>>>> Works fine if you do cause IO errors on the 2nd leg:
>>>> =

>>>> root@kernel-dev:~# dmsetup create zerodev --table "0 1073741824 zero"
>>>> root@kernel-dev:~# dmsetup create errordev --table "0 1073741824 error"
>>>> =

>>>> =

>>>> root@kernel-dev:~# dmsetup create mirror-table --table "0 1073741824 m=
irror
>>>> core 2 524288 nosync 2 /dev/mapper/zerodev 0 /dev/mapper/errordev 0 0"
>> =

Zdenek> There are 2 operational modes for old dm mirror target.
Zdenek> One requires to handle errors externally. Please check i.e. the fol=
lowing
Zdenek> guide for mirror target:
>> =

Zdenek> https://wiki.gentoo.org/wiki/Device-mapper
>> =

Zdenek> Lvm2 is using 'dmeventd' to service this error handling
Zdenek> (i.e. dropping the mirror leg or allocating replacement one).
>> =

>> Is it time to remove the dm-mirror target then?  Or to deprecate it?
>> Or to just silently replace it with something that does the right
>> thing when errors happen?  I can't think of why *anyone* would want to
>> use the dm-mirror target as it now seems to work.


Zdenek> The old dm mirror works differently then new dm raid - so if
Zdenek> you have an old one present/running (i.e. LVM mirrored volume)
Zdenek> using this target - you need to have this target present to be
Zdenek> able to access such volume.

Ok, I see that.  I just wonder if A) anyone still uses this target and
B) if it should be deprecated since it doesn't provide the protections
that the dm_raid target provides.

Getting rid of legacy stuff isn't a bad thing... :-)

Zdenek> You can (in lvm2) convert such mirror to use newer dm raid
Zdenek> target - but this requires some extra space (even though very
Zdenek> small metadata volume) which is now required per each mirrored
Zdenek> leg.

Not a bad thing.

Zdenek> Both targets are still maintained and bugfixed.

Zdenek> There is also something about very high complexity of mdraid
Zdenek> code and relative simplicity of old mirror target.

I'm thinking about the complexity of maintaing both in parallel, when
the older one doesn't provide the protections of the newer one. =


Zdenek> As for comment about *anyone* - majority of users are
Zdenek> consuming DM targets via lvm2 - there you get this transition
Zdenek> automatically - when you ask to create mirrored LV - lvm2 will
Zdenek> use (if present in kernel) newer md raid variant.  If anyone
Zdenek> is using DM directly with 'dmsetup' command - it's assumed
Zdenek> these are skilled users familiar with kernel doc (dmsetup is
Zdenek> low-level admins tool).  Lvm2 should be seen as
Zdenek> 'friendly-face' of these DM targets - which otherwise do
Zdenek> require pretty complex setup. If you do not want to use lvm2,
Zdenek> the tool replacing lvm2 needs to reproduce this extra logic.

Right, so how many use the old version?  =
