From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 0/2] multipath-tools: Housekeeping
Date: Sat, 4 Jun 2016 09:13:53 +0200
Message-ID: <CABr-Gnfzix=vXZKQ0_ESwDyLi=H=w+HXZns5nq3D04s9XAgjgg@mail.gmail.com>
References: <1464997974-19881-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4905357884718304190=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1464997974-19881-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============4905357884718304190==
Content-Type: multipart/alternative; boundary=001a1142100affaa5a05346e94e4

--001a1142100affaa5a05346e94e4
Content-Type: text/plain; charset=UTF-8

Merged.
Thanks.

On Sat, Jun 4, 2016 at 1:52 AM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> I don't know if you want to keep these ones:
> [Hannes says, and Benjamin agrees:]
>
> getuid/usb_id
> > Huh? What is that doing there?
> > It should really have been moved to the udev package ...
>
> multipath/01_udev
> multipath/02_multipath
> > Not used anymore with systemd/dracut
>
> Xose Vazquez Perez (2):
>   multipath-tools: tarballs from gitweb
>   multipath-tools: remove useless init scripts
>
>  README                            |   4 +
>  multipathd/multipathd.init.debian |  29 ------
>  multipathd/multipathd.init.redhat | 152 -----------------------------
>  multipathd/multipathd.init.suse   | 200
> --------------------------------------
>  4 files changed, 4 insertions(+), 381 deletions(-)
>  delete mode 100644 multipathd/multipathd.init.debian
>  delete mode 100644 multipathd/multipathd.init.redhat
>  delete mode 100644 multipathd/multipathd.init.suse
>
> --
> 2.5.5
>
>

--001a1142100affaa5a05346e94e4
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.<div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Sat, Jun 4, 2016 at 1:52 AM, Xose Vazquez=
 Perez <span dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" targ=
et=3D"_blank">xose.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote c=
lass=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;=
padding-left:1ex">I don&#39;t know if you want to keep these ones:<br>
[Hannes says, and Benjamin agrees:]<br>
<br>
getuid/usb_id<br>
&gt; Huh? What is that doing there?<br>
&gt; It should really have been moved to the udev package ...<br>
<br>
multipath/01_udev<br>
multipath/02_multipath<br>
&gt; Not used anymore with systemd/dracut<br>
<br>
Xose Vazquez Perez (2):<br>
=C2=A0 multipath-tools: tarballs from gitweb<br>
=C2=A0 multipath-tools: remove useless init scripts<br>
<br>
=C2=A0README=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A04 +<br>
=C2=A0multipathd/multipathd.init.debian |=C2=A0 29 ------<br>
=C2=A0multipathd/multipathd.init.redhat | 152 -----------------------------=
<br>
=C2=A0multipathd/multipathd.init.suse=C2=A0 =C2=A0| 200 -------------------=
-------------------<br>
=C2=A04 files changed, 4 insertions(+), 381 deletions(-)<br>
=C2=A0delete mode 100644 multipathd/multipathd.init.debian<br>
=C2=A0delete mode 100644 multipathd/multipathd.init.redhat<br>
=C2=A0delete mode 100644 multipathd/multipathd.init.suse<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
2.5.5<br>
<br>
</font></span></blockquote></div><br></div>

--001a1142100affaa5a05346e94e4--


--===============4905357884718304190==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4905357884718304190==--
