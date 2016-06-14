From: Brian Bunker <brian@purestorage.com>
Subject: Re: [PATCH] multipath-tools: add Pure Storage device to
 hardware table
Date: Tue, 14 Jun 2016 06:55:12 -0700
Message-ID: <CAHZQxyKaGYKgvaJc_7YEiDaA3PJmMiAL+JN7VfRF0mtC0bwTLQ@mail.gmail.com>
References: <1465835437-18350-1-git-send-email-xose.vazquez@gmail.com>
	<dc5c07f3-361b-9d32-c926-a394c1543c9a@gmail.com>
	<1465907821099.6145@Dell.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4922843172147147367=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1465907821099.6145@Dell.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Menny_Hamburger@dell.com
Cc: device-mapper development <dm-devel@redhat.com>, xose.vazquez@gmail.com
List-Id: dm-devel.ids

--===============4922843172147147367==
Content-Type: multipart/alternative; boundary=001a114fef8a96f30305353d5ae6

--001a114fef8a96f30305353d5ae6
Content-Type: text/plain; charset=UTF-8

Hello all,

Definitely we want the one we included with the queue length vs. round
robin and 60 second devloss timeout. Not sure where the other one came from.

Thanks
Brian

Brian Bunker
PURE Storage, Inc.
On Jun 14, 2016 5:40 AM, <Menny_Hamburger@dell.com> wrote:

> If driver names are different between tophat and magichat you can stick
> with different names instead of an alias in modprobe.conf and do "install x
> modprobe install y" in modprobe.conf
> ________________________________________
> From: dm-devel-bounces@redhat.com <dm-devel-bounces@redhat.com> on behalf
> of Xose Vazquez Perez <xose.vazquez@gmail.com>
> Sent: Tuesday, June 14, 2016 3:32 PM
> To: Christophe Varoqui; device-mapper development; Brian Bunker
> Subject: Re: [dm-devel] [PATCH] multipath-tools: add Pure Storage device
> to hardware table
>
> On 06/13/2016 06:30 PM, Xose Vazquez Perez wrote:
>
> > based on documentation provided by the manufacturer:
> >
> https://support.purestorage.com/@api/deki/files/1733/=Pure_Storage_Oracle_DB_Best_Practices.pdf?revision=2
> >
> > vendor                  "PURE"
> > product                 "FlashArray"  (extracted from outputs)
>
> Please DROP this one. It was already included by Brian Bunker <
> brian@purestorage.com>
>
> > +     {
> > +             .vendor        = "PURE",
> > +             .product       = "FlashArray",
> > +             .selector      = "round-robin 0",
> > +             .pgpolicy      = MULTIBUS,
> > +             .minio         = 1,
> > +             .checker_name  = TUR,
> > +             .fast_io_fail  = 10,
> > +             .dev_loss      = 30,
> > +     },
>
> Though it's a bit different. Why ?
>
> +               .vendor        = "PURE",
> +               .product       = "FlashArray",
> +               .features      = DEFAULT_FEATURES,
> +               .hwhandler     = DEFAULT_HWHANDLER,
> +               .selector      = "queue-length 0",
> +               .pgpolicy      = MULTIBUS,
> +               .pgfailback    = -FAILBACK_IMMEDIATE,
> +               .checker_name  = TUR,
> +               .fast_io_fail  = 10,
> +               .user_friendly_names = USER_FRIENDLY_NAMES_OFF,
> +               .prio_name     = DEFAULT_PRIO,
> +               .no_path_retry = 0,
> +               .dev_loss      = 60,
> +               .prio_args     = NULL,
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--001a114fef8a96f30305353d5ae6
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<p dir=3D"ltr">Hello all,</p>
<p dir=3D"ltr">Definitely we want the one we included with the queue length=
 vs. round robin and 60 second devloss timeout. Not sure where the other on=
e came from.</p>
<p dir=3D"ltr">Thanks<br>
Brian</p>
<p dir=3D"ltr">Brian Bunker<br>
PURE Storage, Inc.</p>
<div class=3D"gmail_quote">On Jun 14, 2016 5:40 AM,  &lt;<a href=3D"mailto:=
Menny_Hamburger@dell.com">Menny_Hamburger@dell.com</a>&gt; wrote:<br type=
=3D"attribution"><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8=
ex;border-left:1px #ccc solid;padding-left:1ex">If driver names are differe=
nt between tophat and magichat you can stick with different names instead o=
f an alias in modprobe.conf and do &quot;install x modprobe install y&quot;=
 in modprobe.conf<br>
________________________________________<br>
From: <a href=3D"mailto:dm-devel-bounces@redhat.com">dm-devel-bounces@redha=
t.com</a> &lt;<a href=3D"mailto:dm-devel-bounces@redhat.com">dm-devel-bounc=
es@redhat.com</a>&gt; on behalf of Xose Vazquez Perez &lt;<a href=3D"mailto=
:xose.vazquez@gmail.com">xose.vazquez@gmail.com</a>&gt;<br>
Sent: Tuesday, June 14, 2016 3:32 PM<br>
To: Christophe Varoqui; device-mapper development; Brian Bunker<br>
Subject: Re: [dm-devel] [PATCH] multipath-tools: add Pure Storage device to=
 hardware table<br>
<br>
On 06/13/2016 06:30 PM, Xose Vazquez Perez wrote:<br>
<br>
&gt; based on documentation provided by the manufacturer:<br>
&gt; <a href=3D"https://support.purestorage.com/@api/deki/files/1733/=3DPur=
e_Storage_Oracle_DB_Best_Practices.pdf?revision=3D2" rel=3D"noreferrer" tar=
get=3D"_blank">https://support.purestorage.com/@api/deki/files/1733/=3DPure=
_Storage_Oracle_DB_Best_Practices.pdf?revision=3D2</a><br>
&gt;<br>
&gt; vendor=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &=
quot;PURE&quot;<br>
&gt; product=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&=
quot;FlashArray&quot;=C2=A0 (extracted from outputs)<br>
<br>
Please DROP this one. It was already included by Brian Bunker &lt;<a href=
=3D"mailto:brian@purestorage.com">brian@purestorage.com</a>&gt;<br>
<br>
&gt; +=C2=A0 =C2=A0 =C2=A0{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.vendor=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =3D &quot;PURE&quot;,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.product=C2=A0 =C2=A0=
 =C2=A0 =C2=A0=3D &quot;FlashArray&quot;,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.selector=C2=A0 =C2=
=A0 =C2=A0 =3D &quot;round-robin 0&quot;,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.pgpolicy=C2=A0 =C2=
=A0 =C2=A0 =3D MULTIBUS,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.minio=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0=3D 1,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.checker_name=C2=A0 =
=3D TUR,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.fast_io_fail=C2=A0 =
=3D 10,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.dev_loss=C2=A0 =C2=
=A0 =C2=A0 =3D 30,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0},<br>
<br>
Though it&#39;s a bit different. Why ?<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.vendor=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =3D &quot;PURE&quot;,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.product=C2=A0 =C2=
=A0 =C2=A0 =C2=A0=3D &quot;FlashArray&quot;,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.features=C2=A0 =C2=
=A0 =C2=A0 =3D DEFAULT_FEATURES,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.hwhandler=C2=A0 =
=C2=A0 =C2=A0=3D DEFAULT_HWHANDLER,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.selector=C2=A0 =C2=
=A0 =C2=A0 =3D &quot;queue-length 0&quot;,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.pgpolicy=C2=A0 =C2=
=A0 =C2=A0 =3D MULTIBUS,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.pgfailback=C2=A0 =
=C2=A0 =3D -FAILBACK_IMMEDIATE,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.checker_name=C2=A0=
 =3D TUR,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.fast_io_fail=C2=A0=
 =3D 10,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.user_friendly_name=
s =3D USER_FRIENDLY_NAMES_OFF,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.prio_name=C2=A0 =
=C2=A0 =C2=A0=3D DEFAULT_PRIO,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.no_path_retry =3D =
0,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.dev_loss=C2=A0 =C2=
=A0 =C2=A0 =3D 60,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.prio_args=C2=A0 =
=C2=A0 =C2=A0=3D NULL,<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a>=
<br>
</blockquote></div>

--001a114fef8a96f30305353d5ae6--


--===============4922843172147147367==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4922843172147147367==--
