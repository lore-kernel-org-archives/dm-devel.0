From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: HSG80, DM, multipath issues
Date: Mon, 10 Apr 2006 23:16:46 +0200
Message-ID: <443ACB3E.6060106@free.fr>
References: <20060410174210.GA3798@tditx.com> <443AA3DF.3080404@free.fr>
	<20060410204822.GA6573@tditx.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060410204822.GA6573@tditx.com>
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

D. North a =E9crit :
> Thus spake Christophe Varoqui (christophe.varoqui@free.fr):
>
>  =20
>> The one I used is "force a bounce per LUN just after driver loading",=20
>> which this snippet does :
>>
>>        sg_start -s 1 /dev/$i
>>    =20
>
>
> Thanks! ... This got me going enough to get a /dev/mapper/lun4p1...p3 u=
p & running!
> This was done manually from a 'rescue mode' boot of SuSE 10.
>
> After trying the required commands on a running system, it's clear now =
that the
> device mapper setup has to be done in the initrd if I expect to boot fr=
om this
> array. No problem there... that's just a comment.
>
> What is troubling me more at the moment is the difference between the d=
evice
> mapper table setup commands created by the multipath command and how th=
ey
> are different from what dm-mpath.c is actually expecting.
>
> I downloaded 0.4.7 multipath tools & verified that they produce the sam=
e
> table setup issues that I'm having trouble with from the 0.4.5 tool tha=
t
> is current with SuSE 10. For example, the SuSE version of multipath com=
mand
> produces this:
>        0 443027195 multipath 0 0 2 1 round-robin 1 1 8:0 1000 round-rob=
in 1 1 8:16 1000
> Which produces the previously mentioned misparse in dm-mpath.c (my debu=
gging mods)
>        Apr 10 15:30:35 orthus-san kernel: nr_params is 1001, nr_selecto=
r_args =3D 1000, pg->nr_pgpaths is 8
>
> Multipath tools 0.4.7 also causes the same diagnostic message (from my
> debugging modifications), and it is sending in the same number of argum=
ents
> (14) to dm-mpath.c.  I don't, however, get the diagnostic message any m=
ore from
> this version of multipath to determine what it is actually sending into
> libdevmapper, so I am not, at the moment, absolutely certain that the a=
rgument
> list is the same as 0.4.5.
>
> To bypass the misparse, I can still use a command like this:
>        # echo 0 443027195 multipath 0 0 2 1 round-robin 1 1 1 0 8:0 rou=
nd-robin 1 1 1 0 8:16 | dmsetup create lun4
>
> I have successfully set up a device mapper mapping that I can read & wr=
ite
> to from a rescue system, so the above command does actually work.
>
> Unfortunately, if I correctly understand what I'm seeing, this means th=
at the
> current multipath tools 0.4.7 is incompatible with the dm_multipath mod=
ule in
> my 2.6.13-15.8 kernel. Also, this would seem to mean that multipathd is=
 also
> incompatible with this kernel.
>
>  =20
Taken from "The Source", the multipath target syntax is :

/*-----------------------------------------------------------------
 * Constructor/argument parsing:
 * <#multipath feature args> [<arg>]*
 * <#hw_handler args> [hw_handler [<arg>]*]
 * <#priority groups>
 * <initial priority group>
 *     [<selector> <#selector args> [<arg>]*
 *      <#paths> <#per-path selector args>
 *         [<path> [<arg>]* ]+ ]+
 *---------------------------------------------------------------*/

1000 is the default number of IO routed to a path before the driver=20
switches to the next path in the same pathgroup. This is the simple way=20
to achieve the load-leveling through the "round-robin" selector.

Maybe confusingly, the rr_min_io is the "per-path selector args".
Thus, for a path group in your setup :

<selector> =3D round-robin
<#selector args> =3D 0
[<arg>]* =3D NULL
<#paths> =3D 1 (in your case)
<#per-path selector args> =3D 1 (for rr_min_io)
<path> =3D 8:0 (for one)
[<arg>]* =3D 1000 (default rr_min_io, proper)

What strikes me in this map "0 443027195 multipath 0 0 2 1 round-robin 1=20
1 8:0 1000 round-robin 1 1 8:16 1000" is the lack of <#selector args>.

... but I don't reproduce here : "0 71122560 multipath 1=20
queue_if_no_path 0 2 1 round-robin 0 1 1 8:32 100 round-robin 0 1 1 8:80=20
100"

> Is anyone aware of a workaround or even a better identification for thi=
s
> incompatibility?
>
> Thanks!
>  =20
