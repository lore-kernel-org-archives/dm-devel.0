From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 11/12] make prioritizers use checker_timeout,
	if set
Date: Thu, 24 Jul 2014 10:49:24 +0200
Message-ID: <CABr-GndHYRrapK8SUR+05C7RZzX+-nTfiOL9=mBwLzp4EFjp1w@mail.gmail.com>
References: <1404105243-5071-1-git-send-email-bmarzins@redhat.com>
	<1404105243-5071-12-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5041859603333503791=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1404105243-5071-12-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============5041859603333503791==
Content-Type: multipart/alternative; boundary=089e013cc0869f811204feec8837

--089e013cc0869f811204feec8837
Content-Type: text/plain; charset=UTF-8

Applied,
Thanks.


On Mon, Jun 30, 2014 at 7:14 AM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> The multipath prioritizers can get stuck issuing scsi commands that
> don't return quickly, just like the checkers. So if checker_timeout
> is set, the prioritizers should should it for their cmd timeouts as
> well.
>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/prio.c                   | 7 +++++++
>  libmultipath/prio.h                   | 1 +
>  libmultipath/prioritizers/alua_rtpg.c | 5 +++--
>  libmultipath/prioritizers/emc.c       | 2 +-
>  libmultipath/prioritizers/hds.c       | 2 +-
>  libmultipath/prioritizers/hp_sw.c     | 2 +-
>  libmultipath/prioritizers/ontap.c     | 4 ++--
>  libmultipath/prioritizers/rdac.c      | 2 +-
>  multipath.conf.annotated              | 5 +++--
>  multipath/multipath.conf.5            | 4 ++--
>  10 files changed, 22 insertions(+), 12 deletions(-)
>
> diff --git a/libmultipath/prio.c b/libmultipath/prio.c
> index 05a8cf1..6ee0b9c 100644
> --- a/libmultipath/prio.c
> +++ b/libmultipath/prio.c
> @@ -10,6 +10,13 @@
>
>  static LIST_HEAD(prioritizers);
>
> +unsigned int get_prio_timeout(unsigned int default_timeout)
> +{
> +       if (conf->checker_timeout)
> +               return conf->checker_timeout * 1000;
> +       return default_timeout;
> +}
> +
>  int init_prio (void)
>  {
>         if (!add_prio(DEFAULT_PRIO))
> diff --git a/libmultipath/prio.h b/libmultipath/prio.h
> index 4eeb216..495688f 100644
> --- a/libmultipath/prio.h
> +++ b/libmultipath/prio.h
> @@ -51,6 +51,7 @@ struct prio {
>         int (*getprio)(struct path *, char *);
>  };
>
> +unsigned int get_prio_timeout(unsigned int default_timeout);
>  int init_prio (void);
>  void cleanup_prio (void);
>  struct prio * add_prio (char *);
> diff --git a/libmultipath/prioritizers/alua_rtpg.c
> b/libmultipath/prioritizers/alua_rtpg.c
> index 981ba06..6d04fc1 100644
> --- a/libmultipath/prioritizers/alua_rtpg.c
> +++ b/libmultipath/prioritizers/alua_rtpg.c
> @@ -21,6 +21,7 @@
>  #define __user
>  #include <scsi/sg.h>
>
> +#include "../prio.h"
>  #include "alua_rtpg.h"
>
>  #define SENSE_BUFF_LEN  32
> @@ -134,7 +135,7 @@ do_inquiry(int fd, int evpd, unsigned int codepage,
> void *resp, int resplen)
>         hdr.dxfer_len           = resplen;
>         hdr.sbp                 = sense;
>         hdr.mx_sb_len           = sizeof(sense);
> -       hdr.timeout             = DEF_TIMEOUT;
> +       hdr.timeout             = get_prio_timeout(DEF_TIMEOUT);
>
>         if (ioctl(fd, SG_IO, &hdr) < 0) {
>                 PRINT_DEBUG("do_inquiry: IOCTL failed!\n");
> @@ -253,7 +254,7 @@ do_rtpg(int fd, void* resp, long resplen)
>         hdr.dxfer_len           = resplen;
>         hdr.mx_sb_len           = sizeof(sense);
>         hdr.sbp                 = sense;
> -       hdr.timeout             = DEF_TIMEOUT;
> +       hdr.timeout             = get_prio_timeout(DEF_TIMEOUT);
>
>         if (ioctl(fd, SG_IO, &hdr) < 0)
>                 return -RTPG_RTPG_FAILED;
> diff --git a/libmultipath/prioritizers/emc.c
> b/libmultipath/prioritizers/emc.c
> index 91b3d90..e49809c 100644
> --- a/libmultipath/prioritizers/emc.c
> +++ b/libmultipath/prioritizers/emc.c
> @@ -31,7 +31,7 @@ int emc_clariion_prio(const char *dev, int fd)
>         io_hdr.dxferp = sense_buffer;
>         io_hdr.cmdp = inqCmdBlk;
>         io_hdr.sbp = sb;
> -       io_hdr.timeout = 60000;
> +       io_hdr.timeout = get_prio_timeout(60000);
>         io_hdr.pack_id = 0;
>         if (ioctl(fd, SG_IO, &io_hdr) < 0) {
>                 pp_emc_log(0, "sending query command failed");
> diff --git a/libmultipath/prioritizers/hds.c
> b/libmultipath/prioritizers/hds.c
> index f748707..8043b5b 100644
> --- a/libmultipath/prioritizers/hds.c
> +++ b/libmultipath/prioritizers/hds.c
> @@ -114,7 +114,7 @@ int hds_modular_prio (const char *dev, int fd)
>         io_hdr.dxferp = inqBuff;
>         io_hdr.cmdp = inqCmdBlk;
>         io_hdr.sbp = sense_buffer;
> -       io_hdr.timeout = 2000;  /* TimeOut = 2 seconds */
> +       io_hdr.timeout = get_prio_timeout(2000); /* TimeOut = 2 seconds */
>
>         if (ioctl (fd, SG_IO, &io_hdr) < 0) {
>                 pp_hds_log(0, "SG_IO error");
> diff --git a/libmultipath/prioritizers/hp_sw.c
> b/libmultipath/prioritizers/hp_sw.c
> index c24baad..4950cf7 100644
> --- a/libmultipath/prioritizers/hp_sw.c
> +++ b/libmultipath/prioritizers/hp_sw.c
> @@ -46,7 +46,7 @@ int hp_sw_prio(const char *dev, int fd)
>         io_hdr.dxfer_direction = SG_DXFER_NONE;
>         io_hdr.cmdp = turCmdBlk;
>         io_hdr.sbp = sb;
> -       io_hdr.timeout = 60000;
> +       io_hdr.timeout = get_prio_timeout(60000);
>         io_hdr.pack_id = 0;
>   retry:
>         if (ioctl(fd, SG_IO, &io_hdr) < 0) {
> diff --git a/libmultipath/prioritizers/ontap.c
> b/libmultipath/prioritizers/ontap.c
> index 026d45d..5e82a17 100644
> --- a/libmultipath/prioritizers/ontap.c
> +++ b/libmultipath/prioritizers/ontap.c
> @@ -89,7 +89,7 @@ static int send_gva(const char *dev, int fd, unsigned
> char pg,
>         io_hdr.dxferp = results;
>         io_hdr.cmdp = cdb;
>         io_hdr.sbp = sb;
> -       io_hdr.timeout = SG_TIMEOUT;
> +       io_hdr.timeout = get_prio_timeout(SG_TIMEOUT);
>         io_hdr.pack_id = 0;
>         if (ioctl(fd, SG_IO, &io_hdr) < 0) {
>                 pp_ontap_log(0, "SG_IO ioctl failed, errno=%d", errno);
> @@ -141,7 +141,7 @@ static int get_proxy(const char *dev, int fd)
>         io_hdr.dxferp = results;
>         io_hdr.cmdp = cdb;
>         io_hdr.sbp = sb;
> -       io_hdr.timeout = SG_TIMEOUT;
> +       io_hdr.timeout = get_prio_timeout(SG_TIMEOUT);
>         io_hdr.pack_id = 0;
>         if (ioctl(fd, SG_IO, &io_hdr) < 0) {
>                 pp_ontap_log(0, "ioctl sending inquiry command failed, "
> diff --git a/libmultipath/prioritizers/rdac.c
> b/libmultipath/prioritizers/rdac.c
> index 2bf1443..a210055 100644
> --- a/libmultipath/prioritizers/rdac.c
> +++ b/libmultipath/prioritizers/rdac.c
> @@ -31,7 +31,7 @@ int rdac_prio(const char *dev, int fd)
>         io_hdr.dxferp = sense_buffer;
>         io_hdr.cmdp = inqCmdBlk;
>         io_hdr.sbp = sb;
> -       io_hdr.timeout = 60000;
> +       io_hdr.timeout = get_prio_timeout(60000);
>         io_hdr.pack_id = 0;
>         if (ioctl(fd, SG_IO, &io_hdr) < 0) {
>                 pp_rdac_log(0, "sending inquiry command failed");
> diff --git a/multipath.conf.annotated b/multipath.conf.annotated
> index 235e130..f158746 100644
> --- a/multipath.conf.annotated
> +++ b/multipath.conf.annotated
> @@ -243,8 +243,9 @@
>  #      #
>  #      # name    : checker_timeout
>  #      # scope   : multipath & multipathd
> -#      # desc    : The timeout to use for path checkers that issue scsi
> -#      #           commands with an explicit timeout, in seconds.
> +#      # desc    : The timeout to use for path checkers and prioritizers
> +#      #           that issue scsi commands with an explicit timeout, in
> +#      #           seconds.
>  #      # values  : n > 0
>  #      # default : taken from /sys/block/sd<x>/device/timeout
>  #      checker_timeout 60
> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> index 1a904e9..195e663 100644
> --- a/multipath/multipath.conf.5
> +++ b/multipath/multipath.conf.5
> @@ -330,8 +330,8 @@ maximum number of open fds is taken from the calling
> process. It is usually
>  if that number is greated than 1024.
>  .TP
>  .B checker_timeout
> -Specify the timeout to user for path checkers that issue scsi commands
> with an
> -explicit timeout, in seconds; default taken from
> +Specify the timeout to use for path checkers and prioritizers that issue
> scsi
> +commands with an explicit timeout, in seconds; default taken from
>  .I /sys/block/sd<x>/device/timeout
>  .TP
>  .B fast_io_fail_tmo
> --
> 1.8.3.1
>
>

--089e013cc0869f811204feec8837
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied,<div>Thanks.</div></div><div class=3D"gmail_extra"=
><br><br><div class=3D"gmail_quote">On Mon, Jun 30, 2014 at 7:14 AM, Benjam=
in Marzinski <span dir=3D"ltr">&lt;<a href=3D"mailto:bmarzins@redhat.com" t=
arget=3D"_blank">bmarzins@redhat.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">The multipath prioritizers can get stuck iss=
uing scsi commands that<br>
don&#39;t return quickly, just like the checkers. So if checker_timeout<br>
is set, the prioritizers should should it for their cmd timeouts as<br>
well.<br>
<br>
Signed-off-by: Benjamin Marzinski &lt;<a href=3D"mailto:bmarzins@redhat.com=
">bmarzins@redhat.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/prio.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 | 7 +++++++<br>
=C2=A0libmultipath/prio.h =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 | 1 +<br>
=C2=A0libmultipath/prioritizers/alua_rtpg.c | 5 +++--<br>
=C2=A0libmultipath/prioritizers/emc.c =C2=A0 =C2=A0 =C2=A0 | 2 +-<br>
=C2=A0libmultipath/prioritizers/hds.c =C2=A0 =C2=A0 =C2=A0 | 2 +-<br>
=C2=A0libmultipath/prioritizers/hp_sw.c =C2=A0 =C2=A0 | 2 +-<br>
=C2=A0libmultipath/prioritizers/ontap.c =C2=A0 =C2=A0 | 4 ++--<br>
=C2=A0libmultipath/prioritizers/rdac.c =C2=A0 =C2=A0 =C2=A0| 2 +-<br>
=C2=A0multipath.conf.annotated =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0| 5 +++--<br>
=C2=A0multipath/multipath.conf.5 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=
 4 ++--<br>
=C2=A010 files changed, 22 insertions(+), 12 deletions(-)<br>
<br>
diff --git a/libmultipath/prio.c b/libmultipath/prio.c<br>
index 05a8cf1..6ee0b9c 100644<br>
--- a/libmultipath/prio.c<br>
+++ b/libmultipath/prio.c<br>
@@ -10,6 +10,13 @@<br>
<br>
=C2=A0static LIST_HEAD(prioritizers);<br>
<br>
+unsigned int get_prio_timeout(unsigned int default_timeout)<br>
+{<br>
+ =C2=A0 =C2=A0 =C2=A0 if (conf-&gt;checker_timeout)<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return conf-&gt;checker_=
timeout * 1000;<br>
+ =C2=A0 =C2=A0 =C2=A0 return default_timeout;<br>
+}<br>
+<br>
=C2=A0int init_prio (void)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!add_prio(DEFAULT_PRIO))<br>
diff --git a/libmultipath/prio.h b/libmultipath/prio.h<br>
index 4eeb216..495688f 100644<br>
--- a/libmultipath/prio.h<br>
+++ b/libmultipath/prio.h<br>
@@ -51,6 +51,7 @@ struct prio {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int (*getprio)(struct path *, char *);<br>
=C2=A0};<br>
<br>
+unsigned int get_prio_timeout(unsigned int default_timeout);<br>
=C2=A0int init_prio (void);<br>
=C2=A0void cleanup_prio (void);<br>
=C2=A0struct prio * add_prio (char *);<br>
diff --git a/libmultipath/prioritizers/alua_rtpg.c b/libmultipath/prioritiz=
ers/alua_rtpg.c<br>
index 981ba06..6d04fc1 100644<br>
--- a/libmultipath/prioritizers/alua_rtpg.c<br>
+++ b/libmultipath/prioritizers/alua_rtpg.c<br>
@@ -21,6 +21,7 @@<br>
=C2=A0#define __user<br>
=C2=A0#include &lt;scsi/sg.h&gt;<br>
<br>
+#include &quot;../prio.h&quot;<br>
=C2=A0#include &quot;alua_rtpg.h&quot;<br>
<br>
=C2=A0#define SENSE_BUFF_LEN =C2=A032<br>
@@ -134,7 +135,7 @@ do_inquiry(int fd, int evpd, unsigned int codepage, voi=
d *resp, int resplen)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 hdr.dxfer_len =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =3D resplen;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 hdr.sbp =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =3D sense;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 hdr.mx_sb_len =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =3D sizeof(sense);<br>
- =C2=A0 =C2=A0 =C2=A0 hdr.timeout =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =3D DEF_TIMEOUT;<br>
+ =C2=A0 =C2=A0 =C2=A0 hdr.timeout =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =3D get_prio_timeout(DEF_TIMEOUT);<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ioctl(fd, SG_IO, &amp;hdr) &lt; 0) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 PRINT_DEBUG(&quot;d=
o_inquiry: IOCTL failed!\n&quot;);<br>
@@ -253,7 +254,7 @@ do_rtpg(int fd, void* resp, long resplen)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 hdr.dxfer_len =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =3D resplen;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 hdr.mx_sb_len =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =3D sizeof(sense);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 hdr.sbp =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =3D sense;<br>
- =C2=A0 =C2=A0 =C2=A0 hdr.timeout =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =3D DEF_TIMEOUT;<br>
+ =C2=A0 =C2=A0 =C2=A0 hdr.timeout =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =3D get_prio_timeout(DEF_TIMEOUT);<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ioctl(fd, SG_IO, &amp;hdr) &lt; 0)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -RTPG_RTPG_F=
AILED;<br>
diff --git a/libmultipath/prioritizers/emc.c b/libmultipath/prioritizers/em=
c.c<br>
index 91b3d90..e49809c 100644<br>
--- a/libmultipath/prioritizers/emc.c<br>
+++ b/libmultipath/prioritizers/emc.c<br>
@@ -31,7 +31,7 @@ int emc_clariion_prio(const char *dev, int fd)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 io_hdr.dxferp =3D sense_buffer;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 io_hdr.cmdp =3D inqCmdBlk;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 io_hdr.sbp =3D sb;<br>
- =C2=A0 =C2=A0 =C2=A0 io_hdr.timeout =3D 60000;<br>
+ =C2=A0 =C2=A0 =C2=A0 io_hdr.timeout =3D get_prio_timeout(60000);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 io_hdr.pack_id =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ioctl(fd, SG_IO, &amp;io_hdr) &lt; 0) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pp_emc_log(0, &quot=
;sending query command failed&quot;);<br>
diff --git a/libmultipath/prioritizers/hds.c b/libmultipath/prioritizers/hd=
s.c<br>
index f748707..8043b5b 100644<br>
--- a/libmultipath/prioritizers/hds.c<br>
+++ b/libmultipath/prioritizers/hds.c<br>
@@ -114,7 +114,7 @@ int hds_modular_prio (const char *dev, int fd)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 io_hdr.dxferp =3D inqBuff;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 io_hdr.cmdp =3D inqCmdBlk;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 io_hdr.sbp =3D sense_buffer;<br>
- =C2=A0 =C2=A0 =C2=A0 io_hdr.timeout =3D 2000; =C2=A0/* TimeOut =3D 2 seco=
nds */<br>
+ =C2=A0 =C2=A0 =C2=A0 io_hdr.timeout =3D get_prio_timeout(2000); /* TimeOu=
t =3D 2 seconds */<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ioctl (fd, SG_IO, &amp;io_hdr) &lt; 0) {<br=
>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pp_hds_log(0, &quot=
;SG_IO error&quot;);<br>
diff --git a/libmultipath/prioritizers/hp_sw.c b/libmultipath/prioritizers/=
hp_sw.c<br>
index c24baad..4950cf7 100644<br>
--- a/libmultipath/prioritizers/hp_sw.c<br>
+++ b/libmultipath/prioritizers/hp_sw.c<br>
@@ -46,7 +46,7 @@ int hp_sw_prio(const char *dev, int fd)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 io_hdr.dxfer_direction =3D SG_DXFER_NONE;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 io_hdr.cmdp =3D turCmdBlk;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 io_hdr.sbp =3D sb;<br>
- =C2=A0 =C2=A0 =C2=A0 io_hdr.timeout =3D 60000;<br>
+ =C2=A0 =C2=A0 =C2=A0 io_hdr.timeout =3D get_prio_timeout(60000);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 io_hdr.pack_id =3D 0;<br>
=C2=A0 retry:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ioctl(fd, SG_IO, &amp;io_hdr) &lt; 0) {<br>
diff --git a/libmultipath/prioritizers/ontap.c b/libmultipath/prioritizers/=
ontap.c<br>
index 026d45d..5e82a17 100644<br>
--- a/libmultipath/prioritizers/ontap.c<br>
+++ b/libmultipath/prioritizers/ontap.c<br>
@@ -89,7 +89,7 @@ static int send_gva(const char *dev, int fd, unsigned cha=
r pg,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 io_hdr.dxferp =3D results;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 io_hdr.cmdp =3D cdb;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 io_hdr.sbp =3D sb;<br>
- =C2=A0 =C2=A0 =C2=A0 io_hdr.timeout =3D SG_TIMEOUT;<br>
+ =C2=A0 =C2=A0 =C2=A0 io_hdr.timeout =3D get_prio_timeout(SG_TIMEOUT);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 io_hdr.pack_id =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ioctl(fd, SG_IO, &amp;io_hdr) &lt; 0) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pp_ontap_log(0, &qu=
ot;SG_IO ioctl failed, errno=3D%d&quot;, errno);<br>
@@ -141,7 +141,7 @@ static int get_proxy(const char *dev, int fd)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 io_hdr.dxferp =3D results;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 io_hdr.cmdp =3D cdb;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 io_hdr.sbp =3D sb;<br>
- =C2=A0 =C2=A0 =C2=A0 io_hdr.timeout =3D SG_TIMEOUT;<br>
+ =C2=A0 =C2=A0 =C2=A0 io_hdr.timeout =3D get_prio_timeout(SG_TIMEOUT);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 io_hdr.pack_id =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ioctl(fd, SG_IO, &amp;io_hdr) &lt; 0) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pp_ontap_log(0, &qu=
ot;ioctl sending inquiry command failed, &quot;<br>
diff --git a/libmultipath/prioritizers/rdac.c b/libmultipath/prioritizers/r=
dac.c<br>
index 2bf1443..a210055 100644<br>
--- a/libmultipath/prioritizers/rdac.c<br>
+++ b/libmultipath/prioritizers/rdac.c<br>
@@ -31,7 +31,7 @@ int rdac_prio(const char *dev, int fd)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 io_hdr.dxferp =3D sense_buffer;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 io_hdr.cmdp =3D inqCmdBlk;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 io_hdr.sbp =3D sb;<br>
- =C2=A0 =C2=A0 =C2=A0 io_hdr.timeout =3D 60000;<br>
+ =C2=A0 =C2=A0 =C2=A0 io_hdr.timeout =3D get_prio_timeout(60000);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 io_hdr.pack_id =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ioctl(fd, SG_IO, &amp;io_hdr) &lt; 0) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pp_rdac_log(0, &quo=
t;sending inquiry command failed&quot;);<br>
diff --git a/multipath.conf.annotated b/multipath.conf.annotated<br>
index 235e130..f158746 100644<br>
--- a/multipath.conf.annotated<br>
+++ b/multipath.conf.annotated<br>
@@ -243,8 +243,9 @@<br>
=C2=A0# =C2=A0 =C2=A0 =C2=A0#<br>
=C2=A0# =C2=A0 =C2=A0 =C2=A0# name =C2=A0 =C2=A0: checker_timeout<br>
=C2=A0# =C2=A0 =C2=A0 =C2=A0# scope =C2=A0 : multipath &amp; multipathd<br>
-# =C2=A0 =C2=A0 =C2=A0# desc =C2=A0 =C2=A0: The timeout to use for path ch=
eckers that issue scsi<br>
-# =C2=A0 =C2=A0 =C2=A0# =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 commands with a=
n explicit timeout, in seconds.<br>
+# =C2=A0 =C2=A0 =C2=A0# desc =C2=A0 =C2=A0: The timeout to use for path ch=
eckers and prioritizers<br>
+# =C2=A0 =C2=A0 =C2=A0# =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 that issue scsi=
 commands with an explicit timeout, in<br>
+# =C2=A0 =C2=A0 =C2=A0# =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 seconds.<br>
=C2=A0# =C2=A0 =C2=A0 =C2=A0# values =C2=A0: n &gt; 0<br>
=C2=A0# =C2=A0 =C2=A0 =C2=A0# default : taken from /sys/block/sd&lt;x&gt;/d=
evice/timeout<br>
=C2=A0# =C2=A0 =C2=A0 =C2=A0checker_timeout 60<br>
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5<br>
index 1a904e9..195e663 100644<br>
--- a/multipath/multipath.conf.5<br>
+++ b/multipath/multipath.conf.5<br>
@@ -330,8 +330,8 @@ maximum number of open fds is taken from the calling pr=
ocess. It is usually<br>
=C2=A0if that number is greated than 1024.<br>
=C2=A0.TP<br>
=C2=A0.B checker_timeout<br>
-Specify the timeout to user for path checkers that issue scsi commands wit=
h an<br>
-explicit timeout, in seconds; default taken from<br>
+Specify the timeout to use for path checkers and prioritizers that issue s=
csi<br>
+commands with an explicit timeout, in seconds; default taken from<br>
=C2=A0.I /sys/block/sd&lt;x&gt;/device/timeout<br>
=C2=A0.TP<br>
=C2=A0.B fast_io_fail_tmo<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
1.8.3.1<br>
<br>
</font></span></blockquote></div><br></div>

--089e013cc0869f811204feec8837--


--===============5041859603333503791==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5041859603333503791==--
