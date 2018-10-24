From: =?UTF-8?B?w5Z6a2FuIEfDtmtzdQ==?= <ozkan.goksu@usishi.com>
Subject: Re: Multipathd failed when I remove faulted disk.
 "segfault at 648 error 4 in libmultipath.so.0"
Date: Wed, 24 Oct 2018 11:44:23 +0300
Message-ID: <CAPu=dv1XcUXNcuxMmWxQrR4-qpQmR7hHg-YLxXqPYe=Lx6jyRg@mail.gmail.com>
References: <CAPu=dv1ZUoapd2ACHKNSMUq5OUE304dobP6+EDeqGpJksmp4dA@mail.gmail.com>
	<ddf44a0e80bc76471e7a7c2a32ac2e2795013031.camel@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2587038421467933651=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <ddf44a0e80bc76471e7a7c2a32ac2e2795013031.camel@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: mwilck@suse.de
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============2587038421467933651==
Content-Type: multipart/alternative; boundary="000000000000e329e10578f57e1f"

--000000000000e329e10578f57e1f
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello Martin.

You can download the core dump here:
https://drive.google.com/file/d/10egy9RXch6-s4x6PX6UjoEfIk3g_gpb9/view?usp=
=3Dsharing

Martin Wilck <mwilck@suse.de>, 23 Eki 2018 Sal, 16:55 tarihinde =C5=9Funu y=
azd=C4=B1:

> On Tue, 2018-10-23 at 14:46 +0300, =C3=96zkan G=C3=B6ksu  wrote:
> > Hello.
> >
> > I was have a faulted disk in my 148 disk ZFS pool and I replaced the
> > disk with a new one but when I remove the disk from Jbod, Multipathd
> > service failed somehow.
> > The jbod attached via SAS LSI-3008
> >
> > What is the problem with the daemon?
> > How do I prevent this problem happen again?
>
> Do you have a core dump of multipathd?
>
> Martin
>
>
>

--000000000000e329e10578f57e1f
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr">Hello Martin.<div><br></div><div>You can =
download the core dump here:</div><div><a href=3D"https://drive.google.com/=
file/d/10egy9RXch6-s4x6PX6UjoEfIk3g_gpb9/view?usp=3Dsharing">https://drive.=
google.com/file/d/10egy9RXch6-s4x6PX6UjoEfIk3g_gpb9/view?usp=3Dsharing</a><=
br></div></div></div><br><div class=3D"gmail_quote"><div dir=3D"ltr">Martin=
 Wilck &lt;<a href=3D"mailto:mwilck@suse.de">mwilck@suse.de</a>&gt;, 23 Eki=
 2018 Sal, 16:55 tarihinde =C5=9Funu yazd=C4=B1:<br></div><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex">On Tue, 2018-10-23 at 14:46 +0300, =C3=96zkan G=C3=B6ksu=C2=
=A0 wrote:<br>
&gt; Hello.<br>
&gt; <br>
&gt; I was have a faulted disk in my 148 disk ZFS pool and I replaced the<b=
r>
&gt; disk with a new one but when I remove the disk from Jbod, Multipathd<b=
r>
&gt; service failed somehow.<br>
&gt; The jbod attached via SAS LSI-3008<br>
&gt; <br>
&gt; What is the problem with the daemon?<br>
&gt; How do I prevent this problem happen again?<br>
<br>
Do you have a core dump of multipathd?<br>
<br>
Martin<br>
<br>
<br>
</blockquote></div>

--000000000000e329e10578f57e1f--


--===============2587038421467933651==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2587038421467933651==--
