From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] Makefiles: Fix function availability checks
Date: Sun, 20 Nov 2016 14:40:05 +0100
Message-ID: <CABr-GnckhrCEK2P-WH90zmZ6nq8WihgwjqoajHp4x=0CzXwbPw@mail.gmail.com>
References: <1c628eb2-589d-d8b8-952c-d64c5e74d785@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1696238060293494145=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1c628eb2-589d-d8b8-952c-d64c5e74d785@sandisk.com>
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

--===============1696238060293494145==
Content-Type: multipart/alternative; boundary=001a114309a84ba4940541bbadba

--001a114309a84ba4940541bbadba
Content-Type: text/plain; charset=UTF-8

Very nice, thanks.
Merged.

On Fri, Nov 18, 2016 at 8:52 PM, Bart Van Assche <bart.vanassche@sandisk.com
> wrote:

> The current implementation of the code that checks for function
> presence is not correct because it checks for a prefix match only.
> Introduce a function that checks for the exact function name.
> Additionally, report whether or not the function has been found.
> An example of the output produced by this function if 'make' is
> run:
>
> Checking for dm_task_no_flush in /usr/include/libdevmapper.h ... yes
> Checking for dm_task_set_cookie in /usr/include/libdevmapper.h ... yes
> Checking for udev_monitor_set_receive_buffer_size in
> /usr/include/libudev.h ... yes
> Checking for dm_task_deferred_remove in /usr/include/libdevmapper.h ... yes
>
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> ---
>  Makefile.inc          | 14 ++++++++++++++
>  kpartx/Makefile       |  4 +---
>  libmultipath/Makefile | 16 ++++------------
>  3 files changed, 19 insertions(+), 15 deletions(-)
>
> diff --git a/Makefile.inc b/Makefile.inc
> index 1cc8f44..e7f4e05 100644
> --- a/Makefile.inc
> +++ b/Makefile.inc
> @@ -69,5 +69,19 @@ OPTFLAGS     = -O2 -g -pipe -Wall -Wextra -Wformat=2 \
>  CFLAGS         = $(OPTFLAGS) -fPIC -DLIB_STRING=\"${LIB}\"
> -DRUN_DIR=\"${RUN}\"
>  SHARED_FLAGS   = -shared
>
> +# Check whether a function with name $1 has been declared in header file
> $2.
> +check_func =
>     \
> +    $(shell
>      \
> +       if grep -Eq "^[^[:blank:]]+[[:blank:]]+$1[[:blank:]]*(.*)*" "$2";
> then \
> +          found=1;
>     \
> +          status="yes";
>      \
> +       else
>      \
> +          found=0;
>     \
> +          status="no";
>     \
> +       fi;
>     \
> +       echo 1>&2 "Checking for $1 in $2 ... $$status";
>     \
> +       echo "$$found"
>      \
> +    )
> +
>  %.o:   %.c
>         $(CC) $(CFLAGS) -c -o $@ $<
> diff --git a/kpartx/Makefile b/kpartx/Makefile
> index e8a59f2..9441a2b 100644
> --- a/kpartx/Makefile
> +++ b/kpartx/Makefile
> @@ -7,9 +7,7 @@ CFLAGS += -I. -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
>
>  LIBDEPS += -ldevmapper
>
> -LIBDM_API_COOKIE = $(shell grep -Ecs '^[a-z]*[[:space:]]+dm_task_set_cookie'
> /usr/include/libdevmapper.h)
> -
> -ifneq ($(strip $(LIBDM_API_COOKIE)),0)
> +ifneq ($(call check_func,dm_task_set_cookie,/usr/include/libdevmapper.h),
> 0)
>         CFLAGS += -DLIBDM_API_COOKIE
>  endif
>
> diff --git a/libmultipath/Makefile b/libmultipath/Makefile
> index 495cebe..a11e483 100644
> --- a/libmultipath/Makefile
> +++ b/libmultipath/Makefile
> @@ -20,27 +20,19 @@ ifdef SYSTEMD
>         endif
>  endif
>
> -LIBDM_API_FLUSH = $(shell grep -Ecs '^[a-z]*[[:space:]]+dm_task_no_flush'
> /usr/include/libdevmapper.h)
> -
> -ifneq ($(strip $(LIBDM_API_FLUSH)),0)
> +ifneq ($(call check_func,dm_task_no_flush,/usr/include/libdevmapper.h),0)
>         CFLAGS += -DLIBDM_API_FLUSH -D_GNU_SOURCE
>  endif
>
> -LIBDM_API_COOKIE = $(shell grep -Ecs '^[a-z]*[[:space:]]+dm_task_set_cookie'
> /usr/include/libdevmapper.h)
> -
> -ifneq ($(strip $(LIBDM_API_COOKIE)),0)
> +ifneq ($(call check_func,dm_task_set_cookie,/usr/include/libdevmapper.h),
> 0)
>         CFLAGS += -DLIBDM_API_COOKIE
>  endif
>
> -LIBUDEV_API_RECVBUF = $(shell grep -Ecs '^[a-z]*[[:space:]]+udev_
> monitor_set_receive_buffer_size' /usr/include/libudev.h)
> -
> -ifneq ($(strip $(LIBUDEV_API_RECVBUF)),0)
> +ifneq ($(call check_func,udev_monitor_set_receive_buffer_size,/usr/
> include/libudev.h),0)
>         CFLAGS += -DLIBUDEV_API_RECVBUF
>  endif
>
> -LIBDM_API_DEFERRED = $(shell grep -Ecs '^[a-z]*[[:space:]]+dm_task_deferred_remove'
> /usr/include/libdevmapper.h)
> -
> -ifneq ($(strip $(LIBDM_API_DEFERRED)),0)
> +ifneq ($(call check_func,dm_task_deferred_remove,/usr/include/
> libdevmapper.h),0)
>         CFLAGS += -DLIBDM_API_DEFERRED
>  endif
>
> --
> 2.10.1
>
>

--001a114309a84ba4940541bbadba
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Very nice, thanks.<div>Merged.</div></div><div class=3D"gm=
ail_extra"><br><div class=3D"gmail_quote">On Fri, Nov 18, 2016 at 8:52 PM, =
Bart Van Assche <span dir=3D"ltr">&lt;<a href=3D"mailto:bart.vanassche@sand=
isk.com" target=3D"_blank">bart.vanassche@sandisk.com</a>&gt;</span> wrote:=
<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-lef=
t:1px #ccc solid;padding-left:1ex">The current implementation of the code t=
hat checks for function<br>
presence is not correct because it checks for a prefix match only.<br>
Introduce a function that checks for the exact function name.<br>
Additionally, report whether or not the function has been found.<br>
An example of the output produced by this function if &#39;make&#39; is<br>
run:<br>
<br>
Checking for dm_task_no_flush in /usr/include/libdevmapper.h ... yes<br>
Checking for dm_task_set_cookie in /usr/include/libdevmapper.h ... yes<br>
Checking for udev_monitor_set_receive_<wbr>buffer_size in /usr/include/libu=
dev.h ... yes<br>
Checking for dm_task_deferred_remove in /usr/include/libdevmapper.h ... yes=
<br>
<br>
Signed-off-by: Bart Van Assche &lt;<a href=3D"mailto:bart.vanassche@sandisk=
.com">bart.vanassche@sandisk.com</a>&gt;<br>
---<br>
=C2=A0Makefile.inc=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 | 14 ++++++++++++++<br=
>
=C2=A0kpartx/Makefile=C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 4 +---<br>
=C2=A0libmultipath/Makefile | 16 ++++------------<br>
=C2=A03 files changed, 19 insertions(+), 15 deletions(-)<br>
<br>
diff --git a/Makefile.inc b/Makefile.inc<br>
index 1cc8f44..e7f4e05 100644<br>
--- a/Makefile.inc<br>
+++ b/Makefile.inc<br>
@@ -69,5 +69,19 @@ OPTFLAGS=C2=A0 =C2=A0 =C2=A0=3D -O2 -g -pipe -Wall -Wext=
ra -Wformat=3D2 \<br>
=C2=A0CFLAGS=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D $(OPTFLAGS) -fPIC -DLIB_S=
TRING=3D\&quot;${LIB}\&quot; -DRUN_DIR=3D\&quot;${RUN}\&quot;<br>
=C2=A0SHARED_FLAGS=C2=A0 =C2=A0=3D -shared<br>
<br>
+# Check whether a function with name $1 has been declared in header file $=
2.<br>
+check_func =3D=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 \<br>
+=C2=A0 =C2=A0 $(shell=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0\<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if grep -Eq &quot;^[^[:blank:]]+[[:blank:]]+$1[=
<wbr>[:blank:]]*(.*)*&quot; &quot;$2&quot;; then \<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 found=3D1;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 status=3D&quot;yes&quot;;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0\<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0else=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0\<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 found=3D0;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 status=3D&quot;no&quot;;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0fi;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0echo 1&gt;&amp;2 &quot;Checking for $1 in $2 ..=
. $$status&quot;;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 \<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0echo &quot;$$found&quot;=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0\<br>
+=C2=A0 =C2=A0 )<br>
+<br>
=C2=A0%.o:=C2=A0 =C2=A0%.c<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(CC) $(CFLAGS) -c -o $@ $&lt;<br>
diff --git a/kpartx/Makefile b/kpartx/Makefile<br>
index e8a59f2..9441a2b 100644<br>
--- a/kpartx/Makefile<br>
+++ b/kpartx/Makefile<br>
@@ -7,9 +7,7 @@ CFLAGS +=3D -I. -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=
=3D64<br>
<br>
=C2=A0LIBDEPS +=3D -ldevmapper<br>
<br>
-LIBDM_API_COOKIE =3D $(shell grep -Ecs &#39;^[a-z]*[[:space:]]+dm_task_<wb=
r>set_cookie&#39; /usr/include/libdevmapper.h)<br>
-<br>
-ifneq ($(strip $(LIBDM_API_COOKIE)),0)<br>
+ifneq ($(call check_func,dm_task_set_cookie,<wbr>/usr/include/libdevmapper=
.h),<wbr>0)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 CFLAGS +=3D -DLIBDM_API_COOKIE<br>
=C2=A0endif<br>
<br>
diff --git a/libmultipath/Makefile b/libmultipath/Makefile<br>
index 495cebe..a11e483 100644<br>
--- a/libmultipath/Makefile<br>
+++ b/libmultipath/Makefile<br>
@@ -20,27 +20,19 @@ ifdef SYSTEMD<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 endif<br>
=C2=A0endif<br>
<br>
-LIBDM_API_FLUSH =3D $(shell grep -Ecs &#39;^[a-z]*[[:space:]]+dm_task_<wbr=
>no_flush&#39; /usr/include/libdevmapper.h)<br>
-<br>
-ifneq ($(strip $(LIBDM_API_FLUSH)),0)<br>
+ifneq ($(call check_func,dm_task_no_flush,/<wbr>usr/include/libdevmapper.h=
),0)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 CFLAGS +=3D -DLIBDM_API_FLUSH -D_GNU_SOURCE<br>
=C2=A0endif<br>
<br>
-LIBDM_API_COOKIE =3D $(shell grep -Ecs &#39;^[a-z]*[[:space:]]+dm_task_<wb=
r>set_cookie&#39; /usr/include/libdevmapper.h)<br>
-<br>
-ifneq ($(strip $(LIBDM_API_COOKIE)),0)<br>
+ifneq ($(call check_func,dm_task_set_cookie,<wbr>/usr/include/libdevmapper=
.h),<wbr>0)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 CFLAGS +=3D -DLIBDM_API_COOKIE<br>
=C2=A0endif<br>
<br>
-LIBUDEV_API_RECVBUF =3D $(shell grep -Ecs &#39;^[a-z]*[[:space:]]+udev_<wb=
r>monitor_set_receive_buffer_<wbr>size&#39; /usr/include/libudev.h)<br>
-<br>
-ifneq ($(strip $(LIBUDEV_API_RECVBUF)),0)<br>
+ifneq ($(call check_func,udev_monitor_set_<wbr>receive_buffer_size,/usr/<w=
br>include/libudev.h),0)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 CFLAGS +=3D -DLIBUDEV_API_RECVBUF<br>
=C2=A0endif<br>
<br>
-LIBDM_API_DEFERRED =3D $(shell grep -Ecs &#39;^[a-z]*[[:space:]]+dm_task_<=
wbr>deferred_remove&#39; /usr/include/libdevmapper.h)<br>
-<br>
-ifneq ($(strip $(LIBDM_API_DEFERRED)),0)<br>
+ifneq ($(call check_func,dm_task_deferred_<wbr>remove,/usr/include/<wbr>li=
bdevmapper.h),0)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 CFLAGS +=3D -DLIBDM_API_DEFERRED<br>
=C2=A0endif<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
2.10.1<br>
<br>
</font></span></blockquote></div><br></div>

--001a114309a84ba4940541bbadba--


--===============1696238060293494145==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1696238060293494145==--
