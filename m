From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] readsector0: the length of the buffer wrong
Date: Fri, 8 Jul 2016 09:34:02 +0200
Message-ID: <CABr-Gndpfy3eGSOdFsh6ppH9qMs5FxhjevxZQ7ocOWosUJAf0Q@mail.gmail.com>
References: <OF3CB78F61.50E78D53-ON48257FE7.003E97A1-48257FE7.0040E0D4@zte.com.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7712147479297417286=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <OF3CB78F61.50E78D53-ON48257FE7.003E97A1-48257FE7.0040E0D4@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: zhang.kai16@zte.com.cn
Cc: device-mapper development <dm-devel@redhat.com>, tang.junhui@zte.com.cn, christophe varoqui <christophe.varoqui@free.fr>
List-Id: dm-devel.ids

--===============7712147479297417286==
Content-Type: multipart/alternative; boundary=001a114b1574a46acc05371ad306

--001a114b1574a46acc05371ad306
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Merged.
Thanks.

On Tue, Jul 5, 2016 at 1:48 PM, <zhang.kai16@zte.com.cn> wrote:

> hi,
>
> The length of the buffer is 4096, not 4069 in sg_read().
>
> ---
> libmultipath/checkers/readsector0.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/libmultipath/checkers/readsector0.c
> b/libmultipath/checkers/readsector0.c
> index 0550fb6..1c2a868 100644
> --- a/libmultipath/checkers/readsector0.c
> +++ b/libmultipath/checkers/readsector0.c
> @@ -29,7 +29,7 @@ int libcheck_check (struct checker * c)
>                  unsigned char sbuf[SENSE_BUFF_LEN];
>                  int ret;
>
> -                 ret =3D sg_read(c->fd, &buf[0], 4069, &sbuf[0],
> +                 ret =3D sg_read(c->fd, &buf[0], 4096, &sbuf[0],
>                                         SENSE_BUFF_LEN, c->timeout);
>
>                  switch (ret)
> --
> 1.9.1
>
>
>
> --------------------------------------------------------
> ZTE Information Security Notice: The information contained in this mail (=
and any attachment transmitted herewith) is privileged and confidential and=
 is intended for the exclusive use of the addressee(s).  If you are not an =
intended recipient, any disclosure, reproduction, distribution or other dis=
semination or use of the information contained is strictly prohibited.  If =
you have received this mail in error, please delete it and notify us immedi=
ately.
>
>
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--001a114b1574a46acc05371ad306
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.<div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Tue, Jul 5, 2016 at 1:48 PM,  <span dir=
=3D"ltr">&lt;<a href=3D"mailto:zhang.kai16@zte.com.cn" target=3D"_blank">zh=
ang.kai16@zte.com.cn</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_qu=
ote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex=
"><font size=3D"2" face=3D"sans-serif">hi,</font>
<br>
<br><font size=3D"2" face=3D"sans-serif">The length of the buffer is 4096, =
not
4069 in sg_read().</font>
<br><font size=3D"3">=C2=A0</font>
<br><tt><font size=3D"2">---<br>
 libmultipath/checkers/readsector0.c | 2 +-<br>
 1 file changed, 1 insertion(+), 1 deletion(-)<br>
<br>
diff --git a/libmultipath/checkers/readsector0.c b/libmultipath/checkers/re=
adsector0.c<br>
index 0550fb6..1c2a868 100644<br>
--- a/libmultipath/checkers/readsector0.c<br>
+++ b/libmultipath/checkers/readsector0.c<br>
@@ -29,7 +29,7 @@ int libcheck_check (struct checker * c)<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned
char sbuf[SENSE_BUFF_LEN];<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int
ret;<br>
 <br>
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
ret =3D sg_read(c-&gt;fd, &amp;buf[0], 4069, &amp;sbuf[0],<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
ret =3D sg_read(c-&gt;fd, &amp;buf[0], 4096, &amp;sbuf[0],<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
=C2=A0 =C2=A0 =C2=A0 SENSE_BUFF_LEN, c-&gt;timeout);<br>
 <br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0switch
(ret)<span class=3D"HOEnZb"><font color=3D"#888888"><br>
-- <br>
1.9.1</font></span></font></tt><span class=3D"HOEnZb"><font color=3D"#88888=
8"><tt><font size=3D"3"><br>
</font></tt>
<br>

<br><pre><font color=3D"blue">
--------------------------------------------------------
ZTE Information Security Notice: The information contained in this mail (an=
d any attachment transmitted herewith) is privileged and confidential and i=
s intended for the exclusive use of the addressee(s).  If you are not an in=
tended recipient, any disclosure, reproduction, distribution or other disse=
mination or use of the information contained is strictly prohibited.  If yo=
u have received this mail in error, please delete it and notify us immediat=
ely.

</font></pre><br>
</font></span><br>--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a>=
<br></blockquote></div><br></div>

--001a114b1574a46acc05371ad306--


--===============7712147479297417286==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7712147479297417286==--
