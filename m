From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: increase the print length
 of the multipath fields
Date: Sun, 20 Nov 2016 10:21:01 +0100
Message-ID: <CABr-GndJj4MR-SGu4U-bxHO3o98QaofeqOPyMS+_pUEvn41W5A@mail.gmail.com>
References: <1478781121-10924-1-git-send-email-tang.wenji@zte.com.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0586702568372689345=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1478781121-10924-1-git-send-email-tang.wenji@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: tang.wenji@zte.com.cn
Cc: zhang.kai16@zte.com.cn, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============0586702568372689345==
Content-Type: multipart/alternative; boundary=94eb2c1a1b7edc16ae0541b80e3a

--94eb2c1a1b7edc16ae0541b80e3a
Content-Type: text/plain; charset=UTF-8

Applied,
thanks.

On Thu, Nov 10, 2016 at 1:32 PM, <tang.wenji@zte.com.cn> wrote:

> From: "tang.wenji" <tang.wenji@zte.com.cn>
>
> The maximum field length is set to 64, which may be truncated when
> displayed.
> E.g:the multipath's 'features' field sets as "6 queue_if_no_path
> pg_init_retries 3 pg_init_delay_msecs 30 retain_attached_hw_handler",  but
> it shows as "6 queue_if_no_path pg_init_retries 3 pg_init_delay_msecs 30
> ret" .
>
> Signed-off-by: tang.wenji <tang.wenji@zte.com.cn>
> ---
>  libmultipath/print.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/libmultipath/print.h b/libmultipath/print.h
> index 6839fc7..b8c3436 100644
> --- a/libmultipath/print.h
> +++ b/libmultipath/print.h
> @@ -66,7 +66,7 @@
>
>  #define MAX_LINE_LEN  80
>  #define MAX_LINES     64
> -#define MAX_FIELD_LEN 64
> +#define MAX_FIELD_LEN 128
>  #define PROGRESS_LEN  10
>
>  struct path_data {
> --
> 2.8.1.windows.1
>
>

--94eb2c1a1b7edc16ae0541b80e3a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied,<div>thanks.</div></div><div class=3D"gmail_extra"=
><br><div class=3D"gmail_quote">On Thu, Nov 10, 2016 at 1:32 PM,  <span dir=
=3D"ltr">&lt;<a href=3D"mailto:tang.wenji@zte.com.cn" target=3D"_blank">tan=
g.wenji@zte.com.cn</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quot=
e" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">=
From: &quot;tang.wenji&quot; &lt;<a href=3D"mailto:tang.wenji@zte.com.cn">t=
ang.wenji@zte.com.cn</a>&gt;<br>
<br>
The maximum field length is set to 64, which may be truncated when<br>
displayed.<br>
E.g:the multipath&#39;s &#39;features&#39; field sets as &quot;6 queue_if_n=
o_path<br>
pg_init_retries 3 pg_init_delay_msecs 30 retain_attached_hw_handler&quot;,=
=C2=A0 but<br>
it shows as &quot;6 queue_if_no_path pg_init_retries 3 pg_init_delay_msecs =
30 ret&quot; .<br>
<br>
Signed-off-by: tang.wenji &lt;<a href=3D"mailto:tang.wenji@zte.com.cn">tang=
.wenji@zte.com.cn</a>&gt;<br>
---<br>
=C2=A0libmultipath/print.h | 2 +-<br>
=C2=A01 file changed, 1 insertion(+), 1 deletion(-)<br>
<br>
diff --git a/libmultipath/print.h b/libmultipath/print.h<br>
index 6839fc7..b8c3436 100644<br>
--- a/libmultipath/print.h<br>
+++ b/libmultipath/print.h<br>
@@ -66,7 +66,7 @@<br>
<br>
=C2=A0#define MAX_LINE_LEN=C2=A0 80<br>
=C2=A0#define MAX_LINES=C2=A0 =C2=A0 =C2=A064<br>
-#define MAX_FIELD_LEN 64<br>
+#define MAX_FIELD_LEN 128<br>
=C2=A0#define PROGRESS_LEN=C2=A0 10<br>
<br>
=C2=A0struct path_data {<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.8.1.windows.1<br>
<br>
</font></span></blockquote></div><br></div>

--94eb2c1a1b7edc16ae0541b80e3a--


--===============0586702568372689345==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0586702568372689345==--
