From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 0/3] Clang fixes
Date: Tue, 9 Aug 2016 17:13:56 +0200
Message-ID: <CABr-GneVn8Hps0_+cLkj4SZ=-X-QEtpZ_8dh3FwrEkv8FzzOBQ@mail.gmail.com>
References: <1470727873-10502-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4836302664915683459=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1470727873-10502-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

--===============4836302664915683459==
Content-Type: multipart/alternative; boundary=94eb2c0636124cf7590539a4fb9f

--94eb2c0636124cf7590539a4fb9f
Content-Type: text/plain; charset=UTF-8

Merged.
Thanks.

On Tue, Aug 9, 2016 at 9:31 AM, Hannes Reinecke <hare@suse.de> wrote:

> Hi Christophe,
>
> Xose found some issues when building with clang.
>
> Hannes Reinecke (3):
>   libmultipath/discovery.c: use 'unsigned long' instead of 'unsigned int'
>   libmultipath/parser.c: correctly terminate buffer
>   multipath: fixup check for out-of-scope maps
>
>  libmultipath/discovery.c | 2 +-
>  libmultipath/parser.c    | 2 +-
>  multipath/main.c         | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
>
> --
> 2.6.6
>
>

--94eb2c0636124cf7590539a4fb9f
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.<div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Tue, Aug 9, 2016 at 9:31 AM, Hannes Reine=
cke <span dir=3D"ltr">&lt;<a href=3D"mailto:hare@suse.de" target=3D"_blank"=
>hare@suse.de</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" st=
yle=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">Hi Ch=
ristophe,<br>
<br>
Xose found some issues when building with clang.<br>
<br>
Hannes Reinecke (3):<br>
=C2=A0 libmultipath/discovery.c: use &#39;unsigned long&#39; instead of &#3=
9;unsigned int&#39;<br>
=C2=A0 libmultipath/parser.c: correctly terminate buffer<br>
=C2=A0 multipath: fixup check for out-of-scope maps<br>
<br>
=C2=A0libmultipath/discovery.c | 2 +-<br>
=C2=A0libmultipath/parser.c=C2=A0 =C2=A0 | 2 +-<br>
=C2=A0multipath/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 2 +-<br>
=C2=A03 files changed, 3 insertions(+), 3 deletions(-)<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
2.6.6<br>
<br>
</font></span></blockquote></div><br></div>

--94eb2c0636124cf7590539a4fb9f--


--===============4836302664915683459==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4836302664915683459==--
