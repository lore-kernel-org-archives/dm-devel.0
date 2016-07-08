From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 0/5] multipath-tools: Makefiles housekeeping
Date: Fri, 8 Jul 2016 09:03:07 +0200
Message-ID: <CABr-Gne9t80fXUAdfyo=MzWWYYmsg7qejR+bOYaHoaBtdfd16Q@mail.gmail.com>
References: <1467294253-19376-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6555623960261415769=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1467294253-19376-1-git-send-email-xose.vazquez@gmail.com>
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

--===============6555623960261415769==
Content-Type: multipart/alternative; boundary=001a114108401ac8ef05371a658b

--001a114108401ac8ef05371a658b
Content-Type: text/plain; charset=UTF-8

This patchset is merged.
Thanks.

On Thu, Jun 30, 2016 at 3:44 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
>
>
> Xose Vazquez Perez (5):
>   multipath-tools: delete spec/rpm traces from Makefile
>   multipath-tools: merge RPM_OPT_FLAGS into OPTFLAGS
>   multipath-tools: don't create /usr/share/doc/mpathpersist/ from make
> install
>   multipath-tools: don't create /etc/init.d from make install
>   multipath-tools: make uninstall leaves traces behind
>
>  Makefile                 | 9 ---------
>  Makefile.inc             | 7 ++-----
>  libmpathpersist/Makefile | 3 ++-
>  multipathd/Makefile      | 2 --
>  4 files changed, 4 insertions(+), 17 deletions(-)
>
> --
> 2.7.4
>
>

--001a114108401ac8ef05371a658b
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">This patchset is merged.<div>Thanks.</div></div><div class=
=3D"gmail_extra"><br><div class=3D"gmail_quote">On Thu, Jun 30, 2016 at 3:4=
4 PM, Xose Vazquez Perez <span dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazqu=
ez@gmail.com" target=3D"_blank">xose.vazquez@gmail.com</a>&gt;</span> wrote=
:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-le=
ft:1px #ccc solid;padding-left:1ex">Cc: Christophe Varoqui &lt;<a href=3D"m=
ailto:christophe.varoqui@opensvc.com">christophe.varoqui@opensvc.com</a>&gt=
;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
<br>
<br>
Xose Vazquez Perez (5):<br>
=C2=A0 multipath-tools: delete spec/rpm traces from Makefile<br>
=C2=A0 multipath-tools: merge RPM_OPT_FLAGS into OPTFLAGS<br>
=C2=A0 multipath-tools: don&#39;t create /usr/share/doc/mpathpersist/ from =
make install<br>
=C2=A0 multipath-tools: don&#39;t create /etc/init.d from make install<br>
=C2=A0 multipath-tools: make uninstall leaves traces behind<br>
<br>
=C2=A0Makefile=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0| 9 ---------<br>
=C2=A0Makefile.inc=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 7 ++---=
--<br>
=C2=A0libmpathpersist/Makefile | 3 ++-<br>
=C2=A0multipathd/Makefile=C2=A0 =C2=A0 =C2=A0 | 2 --<br>
=C2=A04 files changed, 4 insertions(+), 17 deletions(-)<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
2.7.4<br>
<br>
</font></span></blockquote></div><br></div>

--001a114108401ac8ef05371a658b--


--===============6555623960261415769==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6555623960261415769==--
