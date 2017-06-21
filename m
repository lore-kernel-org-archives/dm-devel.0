From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 0/4] Four multipath-tools patches
Date: Wed, 21 Jun 2017 12:16:31 +0200
Message-ID: <CABr-GnduKJy-10AVYTh2seEz_CReFaqGbOFEE7nbMqzhwQd_mw@mail.gmail.com>
References: <20170613163339.23005-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3063519304535405241=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170613163339.23005-1-bart.vanassche@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============3063519304535405241==
Content-Type: multipart/alternative; boundary="001a11c0060e85da70055275a9d1"

--001a11c0060e85da70055275a9d1
Content-Type: text/plain; charset="UTF-8"

The set is merged.
Thanks.

The _GNU_SOURCE define is no issue.

On Tue, Jun 13, 2017 at 6:33 PM, Bart Van Assche <bart.vanassche@sandisk.com
> wrote:

> Hello Christophe,
>
> This patch series consists of four small patches: one patch that improves
> portability of the kpartx source code and three patches that address
> compiler
> warnings reported by gcc 7. Please consider these patches for merging.
>
> Thanks,
>
> Bart.
>
> Bart Van Assche (4):
>   kpartx: Improve portability of set_loop()
>   libmultipath: Simplify assemble_map()
>   libmultipath/datacore: Remove dead code
>   multipath: Fix a potential buffer overflow
>
>  kpartx/lopart.c                      | 10 ++----
>  libmultipath/dmparser.c              | 67 +++++++++++++++++-------------
> ------
>  libmultipath/prioritizers/datacore.c | 10 +-----
>  multipathd/cli_handlers.c            | 14 ++++----
>  4 files changed, 40 insertions(+), 61 deletions(-)
>
> --
> 2.12.2
>
>

--001a11c0060e85da70055275a9d1
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">The set is merged.<div>Thanks.</div><div><br></div><div>Th=
e _GNU_SOURCE define is no issue.</div></div><div class=3D"gmail_extra"><br=
><div class=3D"gmail_quote">On Tue, Jun 13, 2017 at 6:33 PM, Bart Van Assch=
e <span dir=3D"ltr">&lt;<a href=3D"mailto:bart.vanassche@sandisk.com" targe=
t=3D"_blank">bart.vanassche@sandisk.com</a>&gt;</span> wrote:<br><blockquot=
e class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc sol=
id;padding-left:1ex">Hello Christophe,<br>
<br>
This patch series consists of four small patches: one patch that improves<b=
r>
portability of the kpartx source code and three patches that address compil=
er<br>
warnings reported by gcc 7. Please consider these patches for merging.<br>
<br>
Thanks,<br>
<br>
Bart.<br>
<br>
Bart Van Assche (4):<br>
=C2=A0 kpartx: Improve portability of set_loop()<br>
=C2=A0 libmultipath: Simplify assemble_map()<br>
=C2=A0 libmultipath/datacore: Remove dead code<br>
=C2=A0 multipath: Fix a potential buffer overflow<br>
<br>
=C2=A0kpartx/lopart.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 | 10 ++----<br>
=C2=A0libmultipath/dmparser.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 | 67 +++++++++++++++++-------------<wbr>------<br>
=C2=A0libmultipath/prioritizers/<wbr>datacore.c | 10 +-----<br>
=C2=A0multipathd/cli_handlers.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 | =
14 ++++----<br>
=C2=A04 files changed, 40 insertions(+), 61 deletions(-)<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
2.12.2<br>
<br>
</font></span></blockquote></div><br></div>

--001a11c0060e85da70055275a9d1--


--===============3063519304535405241==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3063519304535405241==--
