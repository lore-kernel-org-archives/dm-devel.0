From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: sync valgrind.h with 3.12
	upstream
Date: Mon, 27 Feb 2017 06:48:14 +0100
Message-ID: <CABr-GnfN6vV=LOViMUf2ka8z+O8AFEGsoa9q7NwzayO+pjKVqQ@mail.gmail.com>
References: <20170220133730.3535-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4937125708067829133=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170220133730.3535-1-xose.vazquez@gmail.com>
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
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============4937125708067829133==
Content-Type: multipart/alternative; boundary=001a113534421d3bd605497ca013

--001a113534421d3bd605497ca013
Content-Type: text/plain; charset=UTF-8

Applied.

On Mon, Feb 20, 2017 at 2:37 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> Cc: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  third-party/valgrind/valgrind.h | 40 ++++++++++++++++++++++++++++++
> +++++++---
>  1 file changed, 37 insertions(+), 3 deletions(-)
>
> diff --git a/third-party/valgrind/valgrind.h b/third-party/valgrind/
> valgrind.h
> index 4b8ef75..6892007 100644
> --- a/third-party/valgrind/valgrind.h
> +++ b/third-party/valgrind/valgrind.h
> @@ -89,7 +89,7 @@
>          || (__VALGRIND_MAJOR__ == 3 && __VALGRIND_MINOR__ >= 6))
>  */
>  #define __VALGRIND_MAJOR__    3
> -#define __VALGRIND_MINOR__    11
> +#define __VALGRIND_MINOR__    12
>
>
>  #include <stdarg.h>
> @@ -946,7 +946,7 @@ typedef
>                       "move %0, $11\n\t"     /*result*/            \
>                       : "=r" (_zzq_result)                         \
>                       : "r" (_zzq_default), "r" (&_zzq_args[0])    \
> -                     : "$11", "$12");                             \
> +                     : "$11", "$12", "memory");                   \
>      _zzq_result;                                                  \
>    })
>
> @@ -1017,7 +1017,7 @@ typedef
>                           "move %0, $11\n\t"     /*result*/          \
>                           : "=r" (_zzq_result)                       \
>                           : "r" (_zzq_default), "r" (&_zzq_args[0])  \
> -                         : "$11", "$12");                           \
> +                         : "$11", "$12", "memory");                 \
>      _zzq_result;                                                    \
>    })
>
> @@ -6759,6 +6759,7 @@ __inline
>  VALGRIND_PRINTF(const char *format, ...)
>  {
>  #if defined(NVALGRIND)
> +   if (format) *(volatile const char *)format;   /* avoid compiler
> warning */
>     return 0;
>  #else /* NVALGRIND */
>  #if defined(_MSC_VER) || defined(__MINGW64__)
> @@ -6797,6 +6798,7 @@ __inline
>  VALGRIND_PRINTF_BACKTRACE(const char *format, ...)
>  {
>  #if defined(NVALGRIND)
> +   if (format) *(volatile const char *)format;   /* avoid compiler
> warning */
>     return 0;
>  #else /* NVALGRIND */
>  #if defined(_MSC_VER) || defined(__MINGW64__)
> @@ -7007,6 +7009,38 @@ VALGRIND_PRINTF_BACKTRACE(const char *format, ...)
>      VALGRIND_DO_CLIENT_REQUEST_STMT(VG_USERREQ__CREATE_MEMPOOL,   \
>                                      pool, rzB, is_zeroed, 0, 0)
>
> +/* Create a memory pool with some flags specifying extended behaviour.
> +   When flags is zero, the behaviour is identical to
> VALGRIND_CREATE_MEMPOOL.
> +
> +   The flag VALGRIND_MEMPOOL_METAPOOL specifies that the pieces of memory
> +   associated with the pool using VALGRIND_MEMPOOL_ALLOC  will be used
> +   by the application as superblocks to dole out MALLOC_LIKE blocks using
> +   VALGRIND_MALLOCLIKE_BLOCK. In other words, a meta pool is a "2 levels"
> +   pool : first level is the blocks described by VALGRIND_MEMPOOL_ALLOC.
> +   The second level blocks are described using VALGRIND_MALLOCLIKE_BLOCK.
> +   Note that the association between the pool and the second level blocks
> +   is implicit : second level blocks will be located inside first level
> +   blocks. It is necessary to use the VALGRIND_MEMPOOL_METAPOOL flag
> +   for such 2 levels pools, as otherwise valgrind will detect overlapping
> +   memory blocks, and will abort execution (e.g. during leak search).
> +
> +   Such a meta pool can also be marked as an 'auto free' pool using the
> flag
> +   VALGRIND_MEMPOOL_AUTO_FREE, which must be OR-ed together with the
> +   VALGRIND_MEMPOOL_METAPOOL. For an 'auto free' pool,
> VALGRIND_MEMPOOL_FREE
> +   will automatically free the second level blocks that are contained
> +   inside the first level block freed with VALGRIND_MEMPOOL_FREE.
> +   In other words, calling VALGRIND_MEMPOOL_FREE will cause implicit calls
> +   to VALGRIND_FREELIKE_BLOCK for all the second level blocks included
> +   in the first level block.
> +   Note: it is an error to use the VALGRIND_MEMPOOL_AUTO_FREE flag
> +   without the VALGRIND_MEMPOOL_METAPOOL flag.
> +*/
> +#define VALGRIND_MEMPOOL_AUTO_FREE  1
> +#define VALGRIND_MEMPOOL_METAPOOL   2
> +#define VALGRIND_CREATE_MEMPOOL_EXT(pool, rzB, is_zeroed, flags)        \
> +   VALGRIND_DO_CLIENT_REQUEST_STMT(VG_USERREQ__CREATE_MEMPOOL,          \
> +                                   pool, rzB, is_zeroed, flags, 0)
> +
>  /* Destroy a memory pool. */
>  #define VALGRIND_DESTROY_MEMPOOL(pool)                            \
>      VALGRIND_DO_CLIENT_REQUEST_STMT(VG_USERREQ__DESTROY_MEMPOOL,  \
> --
> 2.11.1
>
>

--001a113534421d3bd605497ca013
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied.</div><div class=3D"gmail_extra"><br><div class=3D=
"gmail_quote">On Mon, Feb 20, 2017 at 2:37 PM, Xose Vazquez Perez <span dir=
=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" target=3D"_blank">xo=
se.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_qu=
ote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex=
">Cc: Bart Van Assche &lt;<a href=3D"mailto:bart.vanassche@sandisk.com">bar=
t.vanassche@sandisk.com</a>&gt;<br>
Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com=
">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0third-party/valgrind/valgrind.<wbr>h | 40 +++++++++++++++++++++++++++=
+++<wbr>+++++++---<br>
=C2=A01 file changed, 37 insertions(+), 3 deletions(-)<br>
<br>
diff --git a/third-party/valgrind/<wbr>valgrind.h b/third-party/valgrind/<w=
br>valgrind.h<br>
index 4b8ef75..6892007 100644<br>
--- a/third-party/valgrind/<wbr>valgrind.h<br>
+++ b/third-party/valgrind/<wbr>valgrind.h<br>
@@ -89,7 +89,7 @@<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|| (__VALGRIND_MAJOR__ =3D=3D 3 &amp;&amp=
; __VALGRIND_MINOR__ &gt;=3D 6))<br>
=C2=A0*/<br>
=C2=A0#define __VALGRIND_MAJOR__=C2=A0 =C2=A0 3<br>
-#define __VALGRIND_MINOR__=C2=A0 =C2=A0 11<br>
+#define __VALGRIND_MINOR__=C2=A0 =C2=A0 12<br>
<br>
<br>
=C2=A0#include &lt;stdarg.h&gt;<br>
@@ -946,7 +946,7 @@ typedef<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 &quot;move %0, $11\n\t&quot;=C2=A0 =C2=A0 =C2=A0/*result*/=C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 : &quot;=3Dr&quot; (_zzq_result)=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0\<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 : &quot;r&quot; (_zzq_default), &quot;r&quot; (&amp;_zzq_args[0])=C2=A0=
 =C2=A0 \<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0: &quot;$11&quot;, &quot;$12&quot;);=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0\<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0: &quot;$11&quot;, &quot;$12&quot;, &quot;memory&quot;);=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0\<br>
=C2=A0 =C2=A0 =C2=A0_zzq_result;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \<br>
=C2=A0 =C2=A0})<br>
<br>
@@ -1017,7 +1017,7 @@ typedef<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 &quot;move %0, $11\n\t&quot;=C2=A0 =C2=A0 =C2=A0/*result*=
/=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 : &quot;=3Dr&quot; (_zzq_result)=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0\<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 : &quot;r&quot; (_zzq_default), &quot;r&quot; (&amp;_zzq_=
args[0])=C2=A0 \<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0: &quot;$11&quot;, &quot;$12&quot;);=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0\<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0: &quot;$11&quot;, &quot;$12&quot;, &quot;memory&quot;);=
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0\<br>
=C2=A0 =C2=A0 =C2=A0_zzq_result;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \<br>
=C2=A0 =C2=A0})<br>
<br>
@@ -6759,6 +6759,7 @@ __inline<br>
=C2=A0VALGRIND_PRINTF(const char *format, ...)<br>
=C2=A0{<br>
=C2=A0#if defined(NVALGRIND)<br>
+=C2=A0 =C2=A0if (format) *(volatile const char *)format;=C2=A0 =C2=A0/* av=
oid compiler warning */<br>
=C2=A0 =C2=A0 return 0;<br>
=C2=A0#else /* NVALGRIND */<br>
=C2=A0#if defined(_MSC_VER) || defined(__MINGW64__)<br>
@@ -6797,6 +6798,7 @@ __inline<br>
=C2=A0VALGRIND_PRINTF_BACKTRACE(<wbr>const char *format, ...)<br>
=C2=A0{<br>
=C2=A0#if defined(NVALGRIND)<br>
+=C2=A0 =C2=A0if (format) *(volatile const char *)format;=C2=A0 =C2=A0/* av=
oid compiler warning */<br>
=C2=A0 =C2=A0 return 0;<br>
=C2=A0#else /* NVALGRIND */<br>
=C2=A0#if defined(_MSC_VER) || defined(__MINGW64__)<br>
@@ -7007,6 +7009,38 @@ VALGRIND_PRINTF_BACKTRACE(<wbr>const char *format, .=
..)<br>
=C2=A0 =C2=A0 =C2=A0VALGRIND_DO_CLIENT_REQUEST_<wbr>STMT(VG_USERREQ__CREATE=
_<wbr>MEMPOOL,=C2=A0 =C2=A0\<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pool, rzB, is_ze=
roed, 0, 0)<br>
<br>
+/* Create a memory pool with some flags specifying extended behaviour.<br>
+=C2=A0 =C2=A0When flags is zero, the behaviour is identical to VALGRIND_CR=
EATE_MEMPOOL.<br>
+<br>
+=C2=A0 =C2=A0The flag VALGRIND_MEMPOOL_METAPOOL specifies that the pieces =
of memory<br>
+=C2=A0 =C2=A0associated with the pool using VALGRIND_MEMPOOL_ALLOC=C2=A0 w=
ill be used<br>
+=C2=A0 =C2=A0by the application as superblocks to dole out MALLOC_LIKE blo=
cks using<br>
+=C2=A0 =C2=A0VALGRIND_MALLOCLIKE_BLOCK. In other words, a meta pool is a &=
quot;2 levels&quot;<br>
+=C2=A0 =C2=A0pool : first level is the blocks described by VALGRIND_MEMPOO=
L_ALLOC.<br>
+=C2=A0 =C2=A0The second level blocks are described using VALGRIND_MALLOCLI=
KE_BLOCK.<br>
+=C2=A0 =C2=A0Note that the association between the pool and the second lev=
el blocks<br>
+=C2=A0 =C2=A0is implicit : second level blocks will be located inside firs=
t level<br>
+=C2=A0 =C2=A0blocks. It is necessary to use the VALGRIND_MEMPOOL_METAPOOL =
flag<br>
+=C2=A0 =C2=A0for such 2 levels pools, as otherwise valgrind will detect ov=
erlapping<br>
+=C2=A0 =C2=A0memory blocks, and will abort execution (e.g. during leak sea=
rch).<br>
+<br>
+=C2=A0 =C2=A0Such a meta pool can also be marked as an &#39;auto free&#39;=
 pool using the flag<br>
+=C2=A0 =C2=A0VALGRIND_MEMPOOL_AUTO_FREE, which must be OR-ed together with=
 the<br>
+=C2=A0 =C2=A0VALGRIND_MEMPOOL_METAPOOL. For an &#39;auto free&#39; pool, V=
ALGRIND_MEMPOOL_FREE<br>
+=C2=A0 =C2=A0will automatically free the second level blocks that are cont=
ained<br>
+=C2=A0 =C2=A0inside the first level block freed with VALGRIND_MEMPOOL_FREE=
.<br>
+=C2=A0 =C2=A0In other words, calling VALGRIND_MEMPOOL_FREE will cause impl=
icit calls<br>
+=C2=A0 =C2=A0to VALGRIND_FREELIKE_BLOCK for all the second level blocks in=
cluded<br>
+=C2=A0 =C2=A0in the first level block.<br>
+=C2=A0 =C2=A0Note: it is an error to use the VALGRIND_MEMPOOL_AUTO_FREE fl=
ag<br>
+=C2=A0 =C2=A0without the VALGRIND_MEMPOOL_METAPOOL flag.<br>
+*/<br>
+#define VALGRIND_MEMPOOL_AUTO_FREE=C2=A0 1<br>
+#define VALGRIND_MEMPOOL_METAPOOL=C2=A0 =C2=A02<br>
+#define VALGRIND_CREATE_MEMPOOL_EXT(<wbr>pool, rzB, is_zeroed, flags)=C2=
=A0 =C2=A0 =C2=A0 =C2=A0 \<br>
+=C2=A0 =C2=A0VALGRIND_DO_CLIENT_REQUEST_<wbr>STMT(VG_USERREQ__CREATE_<wbr>=
MEMPOOL,=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pool, rzB, is_zeroed, f=
lags, 0)<br>
+<br>
=C2=A0/* Destroy a memory pool. */<br>
=C2=A0#define VALGRIND_DESTROY_MEMPOOL(pool)=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \<br>
=C2=A0 =C2=A0 =C2=A0VALGRIND_DO_CLIENT_REQUEST_<wbr>STMT(VG_USERREQ__DESTRO=
Y_<wbr>MEMPOOL,=C2=A0 \<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.11.1<br>
<br>
</font></span></blockquote></div><br></div>

--001a113534421d3bd605497ca013--


--===============4937125708067829133==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4937125708067829133==--
