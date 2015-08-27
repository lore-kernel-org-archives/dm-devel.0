From: Juliano da Costa <juliano.dacosta@gmail.com>
Subject: Duplicate multipathd process
Date: Thu, 27 Aug 2015 12:53:00 -0300
Message-ID: <CAAKMKp4nFdd54uuFv8jZ9d9_5z-WcjW95htEA9va+2TD2oCA3w@mail.gmail.com>
References: <CAAKMKp6sA7T-g9zWHK4MOsCmLLssPyd5gijeE0DF_4t8QaYknQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5154827214692874808=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAAKMKp6sA7T-g9zWHK4MOsCmLLssPyd5gijeE0DF_4t8QaYknQ@mail.gmail.com>
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

--===============5154827214692874808==
Content-Type: multipart/alternative; boundary=f46d04428804341a9b051e4cf6e5

--f46d04428804341a9b051e4cf6e5
Content-Type: text/plain; charset=UTF-8

Hi ALL.

I'm having some problems and could not find solution with technical support.

My server is two multipathd running processes. I noticed that when there is
a failure to communicate with the SAN device looks like this:

volclu2 (36000144000000010700aa26e0e57b5b9) dm-36 EMC Invista
size = 1.0G features = '0' hwhandler = '0' wp = rw
`- + - Policy = 'queue-length 0' prio = 0 status = enabled
| - 0: 0: 0: 20 65:64 sdu failed running faulty
| - 0: 0: 1: 20 sdaq 66: 160 failed running faulty
| - 1: 0: 0: 20 sddf 70: 208 failed running faulty
`- 1: 0: 1: 20 sdeb 128: 48 failed running faulty

And then the communication is re-established looks like this:

volclu2 (36000144000000010700aa26e0e57b5b9) dm-36 EMC Invista
size = 1.0G features = '0' hwhandler = '0' wp = rw
`- + - Policy = 'queue-length 0' prio = 1 Status = enabled
| - 0: 0: 0: 20 65:64 sdu failed running ready
| - 0: 0: 1: 20 sdaq 66: 160 failed running ready
| - 1: 0: 0: 20 sddf 70: 208 failed running ready
`- 1: 0: 1: 20 sdeb 128: 48  failed running ready

The failback is not being automatic. The status of the device is "enable"
rather than "active".

The status only changes to "active" when I run "multipath -v3".

- What can cause the creation of two daemon multipathd?

Regards,
    Juliano.

--f46d04428804341a9b051e4cf6e5
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<p dir=3D"ltr">Hi ALL.<br></p>
<p dir=3D"ltr">I&#39;m having some problems and could not find solution wit=
h technical support.</p>
<p dir=3D"ltr">My server is two multipathd running processes. I noticed tha=
t when there is a failure to communicate with the SAN device looks like thi=
s:</p>
<p dir=3D"ltr">volclu2 (36000144000000010700aa26e0e57b5b9) dm-36 EMC Invist=
a<br>
size =3D 1.0G features =3D &#39;0&#39; hwhandler =3D &#39;0&#39; wp =3D rw<=
br>
`- + - Policy =3D &#39;queue-length 0&#39; prio =3D 0 status =3D enabled<br=
>
| - 0: 0: 0: 20 65:64 sdu failed running faulty<br>
| - 0: 0: 1: 20 sdaq 66: 160 failed running faulty<br>
| - 1: 0: 0: 20 sddf 70: 208 failed running faulty<br>
`- 1: 0: 1: 20 sdeb 128: 48 failed running faulty</p>
<p dir=3D"ltr">And then the communication is re-established looks like this=
:</p>
<p dir=3D"ltr">volclu2 (36000144000000010700aa26e0e57b5b9) dm-36 EMC Invist=
a<br>
size =3D 1.0G features =3D &#39;0&#39; hwhandler =3D &#39;0&#39; wp =3D rw<=
br>
`- + - Policy =3D &#39;queue-length 0&#39; prio =3D 1 Status =3D enabled<br=
>
| - 0: 0: 0: 20 65:64 sdu failed running ready<br>
| - 0: 0: 1: 20 sdaq 66: 160 failed running ready<br>
| - 1: 0: 0: 20 sddf 70: 208 failed running ready<br>
`- 1: 0: 1: 20 sdeb 128: 48=C2=A0 failed running ready</p>
<p dir=3D"ltr">The failback is not being automatic. The status of the devic=
e is &quot;enable&quot; rather than &quot;active&quot;.</p>
<p dir=3D"ltr">The status only changes to &quot;active&quot; when I run &qu=
ot;multipath -v3&quot;.</p>
<p dir=3D"ltr">- What can cause the creation of two daemon multipathd?</p>
<p dir=3D"ltr">Regards,<br>
=C2=A0=C2=A0=C2=A0 Juliano.</p>

--f46d04428804341a9b051e4cf6e5--


--===============5154827214692874808==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5154827214692874808==--
