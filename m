From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] libmultipath:fix loop traversed partly
Date: Fri, 22 Jul 2016 11:44:52 +0200
Message-ID: <CABr-Gneo3J3m1c1pWbFnn0b-OEf7e0o7c_ipaVchn7uk6fFwXg@mail.gmail.com>
References: <1468498173-8328-1-git-send-email-zhang.kai16@zte.com.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3089685155611004478=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1468498173-8328-1-git-send-email-zhang.kai16@zte.com.cn>
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

--===============3089685155611004478==
Content-Type: multipart/alternative; boundary=001a1142bc6c5230490538364912

--001a1142bc6c5230490538364912
Content-Type: text/plain; charset=UTF-8

Your fix is now merged.
Thanks.

On Thu, Jul 14, 2016 at 2:09 PM, <zhang.kai16@zte.com.cn> wrote:

> From: "zhang.kai" <zhang.kai16@zte.com.cn>
>
> Problem:
> With each iteration of the vector_foreach_slot() loop statement,
> some slots couldn't be traversed when a slot is deleted from vector.
>
> Reasons:
> Currently,loop's index 'i' is not decremented correspondingly when a slot
> is
> deleted from vector.Meanwhile, in the vector_foreach_slot() loop, mpp is
> assigned
> from vector newmp directly, so find_slot() could be omitted.
>
> Signed-off-by: zhang.kai <zhang.kai16@zte.com.cn>
> ---
>  libmultipath/configure.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index a9b9cf0..c06a3df 100644
> --- a/libmultipath/configure.c
> +++ b/libmultipath/configure.c
> @@ -924,16 +924,14 @@ coalesce_paths (struct vectors * vecs, vector newmp,
> char * refwwid, int force_r
>         if (newmp) {
>                 vector_foreach_slot (newmp, mpp, i) {
>                         char alias[WWID_SIZE];
> -                       int j;
>
>                         if (!deadmap(mpp))
>                                 continue;
>
>                         strncpy(alias, mpp->alias, WWID_SIZE - 1);
>
> -                       if ((j = find_slot(newmp, (void *)mpp)) != -1)
> -                               vector_del_slot(newmp, j);
> -
> +                       vector_del_slot(newmp, i);
> +                       i--;
>                         remove_map(mpp, vecs, 0);
>
>                         if (dm_flush_map(alias))
> --
> 2.8.1.windows.1
>
> --------------------------------------------------------
> ZTE Information Security Notice: The information contained in this mail
> (and any attachment transmitted herewith) is privileged and confidential
> and is intended for the exclusive use of the addressee(s).  If you are not
> an intended recipient, any disclosure, reproduction, distribution or other
> dissemination or use of the information contained is strictly prohibited.
> If you have received this mail in error, please delete it and notify us
> immediately.
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--001a1142bc6c5230490538364912
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Your fix is now merged.<div>Thanks.</div></div><div class=
=3D"gmail_extra"><br><div class=3D"gmail_quote">On Thu, Jul 14, 2016 at 2:0=
9 PM,  <span dir=3D"ltr">&lt;<a href=3D"mailto:zhang.kai16@zte.com.cn" targ=
et=3D"_blank">zhang.kai16@zte.com.cn</a>&gt;</span> wrote:<br><blockquote c=
lass=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;=
padding-left:1ex">From: &quot;zhang.kai&quot; &lt;<a href=3D"mailto:zhang.k=
ai16@zte.com.cn">zhang.kai16@zte.com.cn</a>&gt;<br>
<br>
Problem:<br>
With each iteration of the vector_foreach_slot() loop statement,<br>
some slots couldn&#39;t be traversed when a slot is deleted from vector.<br=
>
<br>
Reasons:<br>
Currently,loop&#39;s index &#39;i&#39; is not decremented correspondingly w=
hen a slot is<br>
deleted from vector.Meanwhile, in the vector_foreach_slot() loop, mpp is as=
signed<br>
from vector newmp directly, so find_slot() could be omitted.<br>
<br>
Signed-off-by: zhang.kai &lt;<a href=3D"mailto:zhang.kai16@zte.com.cn">zhan=
g.kai16@zte.com.cn</a>&gt;<br>
---<br>
=C2=A0libmultipath/configure.c | 6 ++----<br>
=C2=A01 file changed, 2 insertions(+), 4 deletions(-)<br>
<br>
diff --git a/libmultipath/configure.c b/libmultipath/configure.c<br>
index a9b9cf0..c06a3df 100644<br>
--- a/libmultipath/configure.c<br>
+++ b/libmultipath/configure.c<br>
@@ -924,16 +924,14 @@ coalesce_paths (struct vectors * vecs, vector newmp, =
char * refwwid, int force_r<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (newmp) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 vector_foreach_slot=
 (newmp, mpp, i) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 char alias[WWID_SIZE];<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0int j;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (!deadmap(mpp))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 continue;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 strncpy(alias, mpp-&gt;alias, WWID_SIZE - 1);<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0if ((j =3D find_slot(newmp, (void *)mpp)) !=3D -1)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0vector_del_slot(newmp, j);<br>
-<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0vector_del_slot(newmp, i);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0i--;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 remove_map(mpp, vecs, 0);<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (dm_flush_map(alias))<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.8.1.windows.1<br>
<br>
--------------------------------------------------------<br>
ZTE Information Security Notice: The information contained in this mail (an=
d any attachment transmitted herewith) is privileged and confidential and i=
s intended for the exclusive use of the addressee(s).=C2=A0 If you are not =
an intended recipient, any disclosure, reproduction, distribution or other =
dissemination or use of the information contained is strictly prohibited.=
=C2=A0 If you have received this mail in error, please delete it and notify=
 us immediately.<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a>=
<br>
</font></span></blockquote></div><br></div>

--001a1142bc6c5230490538364912--


--===============3089685155611004478==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3089685155611004478==--
