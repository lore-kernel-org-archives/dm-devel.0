From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 0/3] Three multipath-tools source code
	cleanup patches
Date: Sat, 13 Jan 2018 09:46:25 +0100
Message-ID: <CABr-GneAVykXwmisxkgGn48kGzh2tQb-r8NiCyCZThXgNMMqJA@mail.gmail.com>
References: <20171212004503.12823-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0885666684701451021=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20171212004503.12823-1-bart.vanassche@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============0885666684701451021==
Content-Type: multipart/alternative; boundary="001a114ab7d695ba230562a46a1b"

--001a114ab7d695ba230562a46a1b
Content-Type: text/plain; charset="UTF-8"

Applied,
Thanks.

On Tue, Dec 12, 2017 at 1:45 AM, Bart Van Assche <bart.vanassche@wdc.com>
wrote:

> Hello Christophe,
>
> The three patches in this series make it easier to compile the
> multipath-tools
> source code with sparse and address two issues discovered by sparse. Please
> consider these patches for inclusion in the upstream multipath-tools
> repository.
>
> Thanks,
>
> Bart.
>
> Bart Van Assche (3):
>   Makefile.inc: Allow additional CFLAGS to be specified on the command
>     line
>   Allow the compiler to verify the consistency of the uxsock_timeout
>     definition and declaration
>   multipathd/cli.h: Add a header file guard
>
>  Makefile.inc      | 3 ++-
>  multipathd/cli.h  | 5 +++++
>  multipathd/main.c | 3 +--
>  3 files changed, 8 insertions(+), 3 deletions(-)
>
> --
> 2.15.1
>
>

--001a114ab7d695ba230562a46a1b
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied,<div>Thanks.</div></div><div class=3D"gmail_extra"=
><br><div class=3D"gmail_quote">On Tue, Dec 12, 2017 at 1:45 AM, Bart Van A=
ssche <span dir=3D"ltr">&lt;<a href=3D"mailto:bart.vanassche@wdc.com" targe=
t=3D"_blank">bart.vanassche@wdc.com</a>&gt;</span> wrote:<br><blockquote cl=
ass=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;p=
adding-left:1ex">Hello Christophe,<br>
<br>
The three patches in this series make it easier to compile the multipath-to=
ols<br>
source code with sparse and address two issues discovered by sparse. Please=
<br>
consider these patches for inclusion in the upstream multipath-tools reposi=
tory.<br>
<br>
Thanks,<br>
<br>
Bart.<br>
<br>
Bart Van Assche (3):<br>
=C2=A0 Makefile.inc: Allow additional CFLAGS to be specified on the command=
<br>
=C2=A0 =C2=A0 line<br>
=C2=A0 Allow the compiler to verify the consistency of the uxsock_timeout<b=
r>
=C2=A0 =C2=A0 definition and declaration<br>
=C2=A0 multipathd/cli.h: Add a header file guard<br>
<br>
=C2=A0Makefile.inc=C2=A0 =C2=A0 =C2=A0 | 3 ++-<br>
=C2=A0multipathd/cli.h=C2=A0 | 5 +++++<br>
=C2=A0multipathd/main.c | 3 +--<br>
=C2=A03 files changed, 8 insertions(+), 3 deletions(-)<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
2.15.1<br>
<br>
</font></span></blockquote></div><br></div>

--001a114ab7d695ba230562a46a1b--


--===============0885666684701451021==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0885666684701451021==--
