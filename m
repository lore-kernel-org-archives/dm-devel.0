From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: Problems with multipathing
Date: Thu, 13 Apr 2006 22:48:07 +0200
Message-ID: <443EB907.1070600@free.fr>
References: <443BF12E.50900@ludd.luth.se>
	<443BF87A.10804@free.fr>	<443C19E6.8000607@ludd.luth.se>
	<443E870E.1070902@ludd.luth.se>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <443E870E.1070902@ludd.luth.se>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Roger H=E5kansson a =E9crit :
> Roger H=E5kansson wrote:
>  =20
>> With upstream I guess you mean 0.4.7 or "CVS-HEAD".
>>
>> Haven't tried that, but just looking at the requirements tells me I'll
>> have a lot to do in order to even just to prepare to test it.
>>
>>    =20
>>>  Dependencies :
>>>  Linux kernel
>>>
>>>      * 2.6.10-rc*-udm2 or later
>>>      * 2.6.11-mm* or later
>>>      * 2.6.12-rc1 or later
>>>  udev 050+
>>>      =20
>> CentOS 4.3 have 2.6.9-34 and udev-039-10, and even though some stuff a=
re
>> backported I guess I have to update both and I can only imagine the
>> amount of work that will render me, but I'll try to do it if I can fin=
d
>> the time...
>>
>> =09
>>    =20
>
> 0.4.7 seems to work better without updating kernel or udev, but not
> entirely...
>
> Unless I've gotten this wrong, with pathgroupingpolicy set to failover =
I
> should get two pathgroups where only one is active an if the active
> fails, the other pathgroup will become active, correct?
> Multibus pathgrouping will place all paths in the same pathgroup so tha=
t
> all paths will share the I/O when they are active and if some path
> fails, the I/O is spread among the active paths, correct?
>
> Multibus works just like I expect it to, but failover doesn't fail the
> path entirely.
>
> This is what 'multipath -ll' gives me after I have disconnected one HBA
> from the fabric.
>
> mpath1 (3600d0230000000000b0191489a946602)
> [size=3D183 GB][features=3D0][hwhandler=3D0]
> \_ round-robin 0 [prio=3D0][enabled]
>  \_ 1:0:1:1 sdc 8:32  [active][faulty]
> \_ round-robin 0 [prio=3D0][enabled]
>  \_ 2:0:0:1 sdf 8:80  [active][ready]
> mpath2 (3600d0230000000000b0191489a946600)
> [size=3D97 GB][features=3D0][hwhandler=3D0]
> \_ round-robin 0 [prio=3D0][active]
>  \_ 1:0:1:0 sdb 8:16  [failed][faulty]
>  \_ 2:0:0:0 sde 8:64  [active][ready]
>
> Notice that sdc is faulty, but still active and both pathgroups are
> enabled but none is active...
>
> I've noticed this problem when I/O is active ( I was running a 'dd
> if=3D/dev/zero of=3D/mount_point count=3D10000000000' to each mpath) wh=
en one
> "path" fails, if there is no activity at all the failover works.
>
>  =20
I don't know your hardware (vendor =3D IFT, product =3D A16F-R2221) but i=
t=20
seems assymmetrical. Most hardware in this familly need a hardware=20
handler, and some need the "queue_if_no_path" feature set too.

You'll have to find how your array works and try to figure if some=20
existing hardware handler does the good thing.

As a last resort, post the maximum techical details about what  your=20
hardware needs to activate backup paths, and hope that some good soul is=20
willing to code the handler.

Regards,
cvaroqui
