From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 01/11] Remove trailing spaces from sysfs
	attributes
Date: Fri, 13 Dec 2013 23:24:16 +0100
Message-ID: <CABr-GnfWgvX-oxS1F4N6ktOkRR91j-zKbaSt7JSRe5WwO-eXbg@mail.gmail.com>
References: <1386936854-8399-1-git-send-email-hare@suse.de>
	<1386936854-8399-2-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5305218371354715876=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1386936854-8399-2-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============5305218371354715876==
Content-Type: multipart/alternative; boundary=20cf303dd358361c9d04ed71ec9a

--20cf303dd358361c9d04ed71ec9a
Content-Type: text/plain; charset=ISO-8859-1

Hannes,

FYI, related to this patch,

commit 3e7763345a31e81318b70d7af68902984312f624
Author: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date:   Fri Dec 13 23:10:27 2013 +0100

    [libmultipath] Fix a compilation warning

    Now that we chop the sysfs attribute strings, the size returned
    by strlcpy is not used anymore. Remove the variable to tame
    the compiler warning.

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index ccd3b62..b7470f8 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -143,7 +143,6 @@ path_discovery (vector pathvec, struct config * conf,
int flag)
 extern ssize_t                                                         \
 sysfs_get_##fname (struct udev_device * udev, char * buff, size_t len) \
 {                                                                      \
-       ssize_t ret;                                                    \
        const char * attr;                                              \
        const char * devname;                                           \
                                                                        \
@@ -163,7 +162,7 @@ sysfs_get_##fname (struct udev_device * udev, char *
buff, size_t len)      \
                        devname, #fname);                               \
                return -EINVAL;                                         \
        }                                                               \
-       ret = strlcpy(buff, attr, len);                                 \
+       strlcpy(buff, attr, len);                                       \
        return strchop(buff);                                           \
 }

Best regards,
Christophe Varoqui


On Fri, Dec 13, 2013 at 1:14 PM, Hannes Reinecke <hare@suse.de> wrote:

> Some sysfs attributes may contain trailing spaces, which only
> serve to confuse matters. So strip them before continuing.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  libmultipath/discovery.c | 2 +-
>  libmultipath/util.c      | 3 ++-
>  libmultipath/util.h      | 2 +-
>  3 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index d5557d9..d519c02 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -164,7 +164,7 @@ sysfs_get_##fname (struct udev_device * udev, char *
> buff, size_t len)      \
>                 return -EINVAL;                                         \
>         }                                                               \
>         ret = strlcpy(buff, attr, len);                                 \
> -       return ret;                                                     \
> +       return strchop(buff);                                           \
>  }
>
>  declare_sysfs_get_str(devtype);
> diff --git a/libmultipath/util.c b/libmultipath/util.c
> index a9f5939..e6fd11d 100644
> --- a/libmultipath/util.c
> +++ b/libmultipath/util.c
> @@ -10,13 +10,14 @@
>  #include "vector.h"
>  #include "structs.h"
>
> -void
> +size_t
>  strchop(char *str)
>  {
>         int i;
>
>         for (i=strlen(str)-1; i >=0 && isspace(str[i]); --i) ;
>         str[++i] = '\0';
> +       return strlen(str);
>  }
>
>  int
> diff --git a/libmultipath/util.h b/libmultipath/util.h
> index 44184a1..7b67dff 100644
> --- a/libmultipath/util.h
> +++ b/libmultipath/util.h
> @@ -1,7 +1,7 @@
>  #ifndef _UTIL_H
>  #define _UTIL_H
>
> -void strchop(char *);
> +size_t strchop(char *);
>  int basenamecpy (const char * src, char * dst, int);
>  int filepresent (char * run);
>  int get_word (char * sentence, char ** word);
> --
> 1.8.1.4
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--20cf303dd358361c9d04ed71ec9a
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hannes,<div><br></div><div>FYI, related to this patch,</di=
v><div><br></div><div><div>commit 3e7763345a31e81318b70d7af68902984312f624<=
/div><div>Author: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoq=
ui@opensvc.com">christophe.varoqui@opensvc.com</a>&gt;</div>
<div>Date: =A0 Fri Dec 13 23:10:27 2013 +0100</div><div><br></div><div>=A0 =
=A0 [libmultipath] Fix a compilation warning</div><div>=A0 =A0=A0</div><div=
>=A0 =A0 Now that we chop the sysfs attribute strings, the size returned</d=
iv><div>=A0 =A0 by strlcpy is not used anymore. Remove the variable to tame=
</div>
<div>=A0 =A0 the compiler warning.</div><div><br></div><div>diff --git a/li=
bmultipath/discovery.c b/libmultipath/discovery.c</div><div>index ccd3b62..=
b7470f8 100644</div><div>--- a/libmultipath/discovery.c</div><div>+++ b/lib=
multipath/discovery.c</div>
<div>@@ -143,7 +143,6 @@ path_discovery (vector pathvec, struct config * co=
nf, int flag)</div><div>=A0extern ssize_t =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 \</div><div>=A0sysfs_get_##fname (struct udev_device * udev, char * bu=
ff, size_t len) \</div>
<div>=A0{ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
\</div><div>- =A0 =A0 =A0 ssize_t ret; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\</div><=
div>=A0 =A0 =A0 =A0 const char * attr; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\</div>
<div>=A0 =A0 =A0 =A0 const char * devname; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \</div><div>=A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \</div><div>@@ =
-163,7 +162,7 @@ sysfs_get_##fname (struct udev_device * udev, char * buff,=
 size_t len) =A0 =A0 =A0\</div>
<div>=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 devname, #fname); =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \</div><div>=A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \</div><div>=A0 =A0 =A0 =A0=
 } =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \</div>
<div>- =A0 =A0 =A0 ret =3D strlcpy(buff, attr, len); =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \</div><div>+ =A0 =A0 =A0 strlc=
py(buff, attr, len); =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 \</div><div>=A0 =A0 =A0 =A0 return strchop(buff); =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 \</div>
<div>=A0}</div></div><div><br></div><div>Best regards,</div><div>Christophe=
 Varoqui</div></div><div class=3D"gmail_extra"><br><br><div class=3D"gmail_=
quote">On Fri, Dec 13, 2013 at 1:14 PM, Hannes Reinecke <span dir=3D"ltr">&=
lt;<a href=3D"mailto:hare@suse.de" target=3D"_blank">hare@suse.de</a>&gt;</=
span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"HOEnZb"><div class=3D"h5">Some=
 sysfs attributes may contain trailing spaces, which only<br>
serve to confuse matters. So strip them before continuing.<br>
<br>
Signed-off-by: Hannes Reinecke &lt;<a href=3D"mailto:hare@suse.de">hare@sus=
e.de</a>&gt;<br>
---<br>
=A0libmultipath/discovery.c | 2 +-<br>
=A0libmultipath/util.c =A0 =A0 =A0| 3 ++-<br>
=A0libmultipath/util.h =A0 =A0 =A0| 2 +-<br>
=A03 files changed, 4 insertions(+), 3 deletions(-)<br>
<br>
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c<br>
index d5557d9..d519c02 100644<br>
--- a/libmultipath/discovery.c<br>
+++ b/libmultipath/discovery.c<br>
@@ -164,7 +164,7 @@ sysfs_get_##fname (struct udev_device * udev, char * bu=
ff, size_t len) =A0 =A0 =A0\<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL; =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \<br>
=A0 =A0 =A0 =A0 } =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \<br>
=A0 =A0 =A0 =A0 ret =3D strlcpy(buff, attr, len); =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \<br>
- =A0 =A0 =A0 return ret; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \<br>
+ =A0 =A0 =A0 return strchop(buff); =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \<br>
=A0}<br>
<br>
=A0declare_sysfs_get_str(devtype);<br>
diff --git a/libmultipath/util.c b/libmultipath/util.c<br>
index a9f5939..e6fd11d 100644<br>
--- a/libmultipath/util.c<br>
+++ b/libmultipath/util.c<br>
@@ -10,13 +10,14 @@<br>
=A0#include &quot;vector.h&quot;<br>
=A0#include &quot;structs.h&quot;<br>
<br>
-void<br>
+size_t<br>
=A0strchop(char *str)<br>
=A0{<br>
=A0 =A0 =A0 =A0 int i;<br>
<br>
=A0 =A0 =A0 =A0 for (i=3Dstrlen(str)-1; i &gt;=3D0 &amp;&amp; isspace(str[i=
]); --i) ;<br>
=A0 =A0 =A0 =A0 str[++i] =3D &#39;\0&#39;;<br>
+ =A0 =A0 =A0 return strlen(str);<br>
=A0}<br>
<br>
=A0int<br>
diff --git a/libmultipath/util.h b/libmultipath/util.h<br>
index 44184a1..7b67dff 100644<br>
--- a/libmultipath/util.h<br>
+++ b/libmultipath/util.h<br>
@@ -1,7 +1,7 @@<br>
=A0#ifndef _UTIL_H<br>
=A0#define _UTIL_H<br>
<br>
-void strchop(char *);<br>
+size_t strchop(char *);<br>
=A0int basenamecpy (const char * src, char * dst, int);<br>
=A0int filepresent (char * run);<br>
=A0int get_word (char * sentence, char ** word);<br>
--<br>
1.8.1.4<br>
<br>
</div></div>--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D"_bla=
nk">https://www.redhat.com/mailman/listinfo/dm-devel</a><br>
</blockquote></div><br></div>

--20cf303dd358361c9d04ed71ec9a--


--===============5305218371354715876==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5305218371354715876==--
