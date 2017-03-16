From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: libdmmp: Fix incorrect use
	of __attribute__
Date: Thu, 16 Mar 2017 07:45:57 +0100
Message-ID: <CABr-Gnch2-Ejc=yLr4F2Yu=NWx9Qte6gHkCWZb+gugK7VCeNgg@mail.gmail.com>
References: <20170311141214.31039-1-fge@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1435339699806888784=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170311141214.31039-1-fge@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Gris Ge <fge@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============1435339699806888784==
Content-Type: multipart/alternative; boundary=94eb2c0afb62d2ec41054ad36972

--94eb2c0afb62d2ec41054ad36972
Content-Type: text/plain; charset=UTF-8

Applied
Thanks.

On Sat, Mar 11, 2017 at 3:12 PM, Gris Ge <fge@redhat.com> wrote:

> According to https://gcc.gnu.org/onlinedocs/gcc/Type-Attributes.html ,
> type attributes should be placed immediately after the struct, union or
> enum keyword.
>
> Signed-off-by: Gris Ge <fge@redhat.com>
> ---
>  libdmmp/libdmmp/libdmmp.h | 8 ++++----
>  libdmmp/libdmmp_private.h | 3 ++-
>  2 files changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/libdmmp/libdmmp/libdmmp.h b/libdmmp/libdmmp/libdmmp.h
> index 3fc8e6f..0679158 100644
> --- a/libdmmp/libdmmp/libdmmp.h
> +++ b/libdmmp/libdmmp/libdmmp.h
> @@ -73,18 +73,18 @@ extern "C" {
>   */
>  DMMP_DLL_EXPORT const char *dmmp_log_priority_str(int priority);
>
> -DMMP_DLL_EXPORT struct dmmp_context;
> +struct DMMP_DLL_EXPORT dmmp_context;
>
> -DMMP_DLL_EXPORT struct dmmp_mpath;
> +struct DMMP_DLL_EXPORT dmmp_mpath;
>
> -DMMP_DLL_EXPORT struct dmmp_path_group;
> +struct DMMP_DLL_EXPORT dmmp_path_group;
>
>  #define DMMP_PATH_GROUP_STATUS_UNKNOWN 0
>  #define DMMP_PATH_GROUP_STATUS_ENABLED 1
>  #define DMMP_PATH_GROUP_STATUS_DISABLED        2
>  #define DMMP_PATH_GROUP_STATUS_ACTIVE  3
>
> -DMMP_DLL_EXPORT struct dmmp_path;
> +struct DMMP_DLL_EXPORT dmmp_path;
>
>  #define DMMP_PATH_STATUS_UNKNOWN       0
>  //#define DMMP_PATH_STATUS_UNCHECKED   1
> diff --git a/libdmmp/libdmmp_private.h b/libdmmp/libdmmp_private.h
> index e23c995..3e813cb 100644
> --- a/libdmmp/libdmmp_private.h
> +++ b/libdmmp/libdmmp_private.h
> @@ -47,7 +47,8 @@ extern "C" {
>
>  #define _DMMP_PATH_GROUP_ID_UNKNOWN    0
>
> -DMMP_DLL_LOCAL struct _num_str_conv {
> +struct DMMP_DLL_LOCAL _num_str_conv;
> +struct _num_str_conv {
>         const uint32_t value;
>         const char *str;
>  };
> --
> 2.12.0
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--94eb2c0afb62d2ec41054ad36972
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied<div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Sat, Mar 11, 2017 at 3:12 PM, Gris Ge <sp=
an dir=3D"ltr">&lt;<a href=3D"mailto:fge@redhat.com" target=3D"_blank">fge@=
redhat.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">Accordin=
g to <a href=3D"https://gcc.gnu.org/onlinedocs/gcc/Type-Attributes.html" re=
l=3D"noreferrer" target=3D"_blank">https://gcc.gnu.org/<wbr>onlinedocs/gcc/=
Type-<wbr>Attributes.html</a> ,<br>
type attributes should be placed immediately after the struct, union or<br>
enum keyword.<br>
<br>
Signed-off-by: Gris Ge &lt;<a href=3D"mailto:fge@redhat.com">fge@redhat.com=
</a>&gt;<br>
---<br>
=C2=A0libdmmp/libdmmp/libdmmp.h | 8 ++++----<br>
=C2=A0libdmmp/libdmmp_private.h | 3 ++-<br>
=C2=A02 files changed, 6 insertions(+), 5 deletions(-)<br>
<br>
diff --git a/libdmmp/libdmmp/libdmmp.h b/libdmmp/libdmmp/libdmmp.h<br>
index 3fc8e6f..0679158 100644<br>
--- a/libdmmp/libdmmp/libdmmp.h<br>
+++ b/libdmmp/libdmmp/libdmmp.h<br>
@@ -73,18 +73,18 @@ extern &quot;C&quot; {<br>
=C2=A0 */<br>
=C2=A0DMMP_DLL_EXPORT const char *dmmp_log_priority_str(int priority);<br>
<br>
-DMMP_DLL_EXPORT struct dmmp_context;<br>
+struct DMMP_DLL_EXPORT dmmp_context;<br>
<br>
-DMMP_DLL_EXPORT struct dmmp_mpath;<br>
+struct DMMP_DLL_EXPORT dmmp_mpath;<br>
<br>
-DMMP_DLL_EXPORT struct dmmp_path_group;<br>
+struct DMMP_DLL_EXPORT dmmp_path_group;<br>
<br>
=C2=A0#define DMMP_PATH_GROUP_STATUS_UNKNOWN 0<br>
=C2=A0#define DMMP_PATH_GROUP_STATUS_ENABLED 1<br>
=C2=A0#define DMMP_PATH_GROUP_STATUS_<wbr>DISABLED=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 2<br>
=C2=A0#define DMMP_PATH_GROUP_STATUS_ACTIVE=C2=A0 3<br>
<br>
-DMMP_DLL_EXPORT struct dmmp_path;<br>
+struct DMMP_DLL_EXPORT dmmp_path;<br>
<br>
=C2=A0#define DMMP_PATH_STATUS_UNKNOWN=C2=A0 =C2=A0 =C2=A0 =C2=A00<br>
=C2=A0//#define DMMP_PATH_STATUS_UNCHECKED=C2=A0 =C2=A01<br>
diff --git a/libdmmp/libdmmp_private.h b/libdmmp/libdmmp_private.h<br>
index e23c995..3e813cb 100644<br>
--- a/libdmmp/libdmmp_private.h<br>
+++ b/libdmmp/libdmmp_private.h<br>
@@ -47,7 +47,8 @@ extern &quot;C&quot; {<br>
<br>
=C2=A0#define _DMMP_PATH_GROUP_ID_UNKNOWN=C2=A0 =C2=A0 0<br>
<br>
-DMMP_DLL_LOCAL struct _num_str_conv {<br>
+struct DMMP_DLL_LOCAL _num_str_conv;<br>
+struct _num_str_conv {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 const uint32_t value;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 const char *str;<br>
=C2=A0};<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.12.0<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/<wbr>mailman/listinfo/dm-deve=
l</a><br>
</font></span></blockquote></div><br></div>

--94eb2c0afb62d2ec41054ad36972--


--===============1435339699806888784==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1435339699806888784==--
