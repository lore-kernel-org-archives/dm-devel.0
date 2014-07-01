From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 06/12] Make multipath add wwids from kernel
 cmdline mpath.wwids with -A
Date: Tue, 1 Jul 2014 21:22:21 +0200
Message-ID: <CABr-GnedX62W_U988FjXs4eV+GisRjt_AhPe4J6XhBPzF+_uCw@mail.gmail.com>
References: <1404105243-5071-1-git-send-email-bmarzins@redhat.com>
	<1404105243-5071-7-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2861940863249771517=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1404105243-5071-7-git-send-email-bmarzins@redhat.com>
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

--===============2861940863249771517==
Content-Type: multipart/alternative; boundary=047d7b3a81a0d9a29704fd26b17c

--047d7b3a81a0d9a29704fd26b17c
Content-Type: text/plain; charset=UTF-8

Hannes,

would you Ack this one, or do you have some other idea for this in your
tree ?

Best regards,
Christophe Varoqui
www.opensvc.com


On Mon, Jun 30, 2014 at 7:13 AM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> This patch adds another option to multipath, "-A", which reads
> /proc/cmdline for mpath.wwid=<WWID> options, and adds any wwids it finds to
> /etc/multipath/wwids.  While this isn't usually important during normal
> operation, since these wwids should already be added, it can be helpful
> during installation, to make sure that multipath can claim devices as its
> own, before LVM or something else makes use of them.  The patch also execs
> "/sbin/multipath -A" before running multipathd in multipathd.service
>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/wwids.c          | 44
> +++++++++++++++++++++++++++++++++++++++++++
>  libmultipath/wwids.h          |  1 +
>  multipath/main.c              | 10 ++++++++--
>  multipath/multipath.8         |  5 ++++-
>  multipathd/multipathd.service |  1 +
>  5 files changed, 58 insertions(+), 3 deletions(-)
>
> diff --git a/libmultipath/wwids.c b/libmultipath/wwids.c
> index eca1799..1dc00bb 100644
> --- a/libmultipath/wwids.c
> +++ b/libmultipath/wwids.c
> @@ -274,3 +274,47 @@ remember_wwid(char *wwid)
>                 condlog(4, "wwid %s already in wwids file", wwid);
>         return 0;
>  }
> +
> +int remember_cmdline_wwid(void)
> +{
> +       FILE *f = NULL;
> +       char buf[LINE_MAX], *next, *ptr;
> +       int ret = 0;
> +
> +       f = fopen("/proc/cmdline", "re");
> +       if (!f) {
> +               condlog(0, "can't open /proc/cmdline : %s",
> strerror(errno));
> +               return -1;
> +       }
> +
> +       if (!fgets(buf, sizeof(buf), f)) {
> +               if (ferror(f))
> +                       condlog(0, "read of /proc/cmdline failed : %s",
> +                               strerror(errno));
> +               else
> +                       condlog(0, "couldn't read /proc/cmdline");
> +               fclose(f);
> +               return -1;
> +       }
> +       fclose(f);
> +       next = buf;
> +       while((ptr = strstr(next, "mpath.wwid="))) {
> +               ptr += 11;
> +               next = strpbrk(ptr, " \t\n");
> +               if (next) {
> +                       *next = '\0';
> +                       next++;
> +               }
> +               if (strlen(ptr)) {
> +                       if (remember_wwid(ptr) != 0)
> +                               ret = -1;
> +               }
> +               else {
> +                       condlog(0, "empty mpath.wwid kernel command line
> option");
> +                       ret = -1;
> +               }
> +               if (!next)
> +                       break;
> +       }
> +       return ret;
> +}
> diff --git a/libmultipath/wwids.h b/libmultipath/wwids.h
> index f3b21fa..2fbd419 100644
> --- a/libmultipath/wwids.h
> +++ b/libmultipath/wwids.h
> @@ -16,5 +16,6 @@ int remember_wwid(char *wwid);
>  int check_wwids_file(char *wwid, int write_wwid);
>  int remove_wwid(char *wwid);
>  int replace_wwids(vector mp);
> +int remember_cmdline_wwid(void);
>
>  #endif /* _WWIDS_H */
> diff --git a/multipath/main.c b/multipath/main.c
> index 157475e..ed93f66 100644
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -84,7 +84,7 @@ usage (char * progname)
>  {
>         fprintf (stderr, VERSION_STRING);
>         fprintf (stderr, "Usage:\n");
> -       fprintf (stderr, "  %s [-a|-c|-w|-W] [-d] [-r] [-v lvl] [-p pol]
> [-b fil] [-q] [dev]\n", progname);
> +       fprintf (stderr, "  %s [-a|-A|-c|-w|-W] [-d] [-r] [-v lvl] [-p
> pol] [-b fil] [-q] [dev]\n", progname);
>         fprintf (stderr, "  %s -l|-ll|-f [-v lvl] [-b fil] [dev]\n",
> progname);
>         fprintf (stderr, "  %s -F [-v lvl]\n", progname);
>         fprintf (stderr, "  %s -t\n", progname);
> @@ -98,6 +98,8 @@ usage (char * progname)
>                 "  -f      flush a multipath device map\n" \
>                 "  -F      flush all multipath device maps\n" \
>                 "  -a      add a device wwid to the wwids file\n" \
> +               "  -A      add devices from kernel command line
> mpath.wwids\n"
> +               "          parameters to wwids file\n" \
>                 "  -c      check if a device should be a path in a
> multipath device\n" \
>                 "  -q      allow queue_if_no_path when multipathd is not
> running\n"\
>                 "  -d      dry run, do not create or update devmaps\n" \
> @@ -445,7 +447,7 @@ main (int argc, char *argv[])
>         if (load_config(DEFAULT_CONFIGFILE, udev))
>                 exit(1);
>
> -       while ((arg = getopt(argc, argv, ":adchl::FfM:v:p:b:BrtqwW")) !=
> EOF ) {
> +       while ((arg = getopt(argc, argv, ":aAdchl::FfM:v:p:b:BrtqwW")) !=
> EOF ) {
>                 switch(arg) {
>                 case 1: printf("optarg : %s\n",optarg);
>                         break;
> @@ -518,6 +520,10 @@ main (int argc, char *argv[])
>                 case 'a':
>                         conf->cmd = CMD_ADD_WWID;
>                         break;
> +               case 'A':
> +                       if (remember_cmdline_wwid() != 0)
> +                               exit(1);
> +                       exit(0);
>                 case ':':
>                         fprintf(stderr, "Missing option argument\n");
>                         usage(argv[0]);
> diff --git a/multipath/multipath.8 b/multipath/multipath.8
> index b6479b1..f6b30c7 100644
> --- a/multipath/multipath.8
> +++ b/multipath/multipath.8
> @@ -8,7 +8,7 @@ multipath \- Device mapper target autoconfig
>  .RB [\| \-b\ \c
>  .IR bindings_file \|]
>  .RB [\| \-d \|]
> -.RB [\| \-h | \-l | \-ll | \-f | \-t | \-F | \-B | \-c | \-q | \|-r | \-a
> | \-w | \-W \|]
> +.RB [\| \-h | \-l | \-ll | \-f | \-t | \-F | \-B | \-c | \-q | \|-r | \-a
> | \-A | \-w | \-W \|]
>  .RB [\| \-p\ \c
>  .BR failover | multibus | group_by_serial | group_by_prio |
> group_by_node_name \|]
>  .RB [\| device \|]
> @@ -71,6 +71,9 @@ allow device tables with queue_if_no_path when
> multipathd is not running
>  .B \-a
>  add the wwid for the specified device to the wwids file
>  .TP
> +.B \-A
> +add wwids from any kernel command line mpath.wwid parameters to the wwids
> file
> +.TP
>  .B \-w
>  remove the wwid for the specified device from the wwids file
>  .TP
> diff --git a/multipathd/multipathd.service b/multipathd/multipathd.service
> index be3ba3f..8bb48b5 100644
> --- a/multipathd/multipathd.service
> +++ b/multipathd/multipathd.service
> @@ -10,6 +10,7 @@ Type=notify
>  NotifyAccess=main
>  LimitCORE=infinity
>  ExecStartPre=/sbin/modprobe dm-multipath
> +ExecStartPre=-/sbin/multipath -A
>  ExecStart=/sbin/multipathd -d -s
>  ExecReload=/sbin/multipathd reconfigure
>
> --
> 1.8.3.1
>
>

--047d7b3a81a0d9a29704fd26b17c
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div><div>Hannes,<br></div><br>would you Ack thi=
s one, or do you have some other idea for this in your tree ?<br><br></div>=
Best regards,<br></div>Christophe Varoqui<br></div><a href=3D"http://www.op=
ensvc.com">www.opensvc.com</a><br>
</div><div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">On Mon,=
 Jun 30, 2014 at 7:13 AM, Benjamin Marzinski <span dir=3D"ltr">&lt;<a href=
=3D"mailto:bmarzins@redhat.com" target=3D"_blank">bmarzins@redhat.com</a>&g=
t;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">This patch adds another option to multipath,=
 &quot;-A&quot;, which reads<br>
/proc/cmdline for mpath.wwid=3D&lt;WWID&gt; options, and adds any wwids it =
finds to<br>
/etc/multipath/wwids. =C2=A0While this isn&#39;t usually important during n=
ormal<br>
operation, since these wwids should already be added, it can be helpful<br>
during installation, to make sure that multipath can claim devices as its<b=
r>
own, before LVM or something else makes use of them. =C2=A0The patch also e=
xecs<br>
&quot;/sbin/multipath -A&quot; before running multipathd in multipathd.serv=
ice<br>
<br>
Signed-off-by: Benjamin Marzinski &lt;<a href=3D"mailto:bmarzins@redhat.com=
">bmarzins@redhat.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/wwids.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 44 +++++++++=
++++++++++++++++++++++++++++++++++<br>
=C2=A0libmultipath/wwids.h =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A01 +<br=
>
=C2=A0multipath/main.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 10=
 ++++++++--<br>
=C2=A0multipath/multipath.8 =C2=A0 =C2=A0 =C2=A0 =C2=A0 | =C2=A05 ++++-<br>
=C2=A0multipathd/multipathd.service | =C2=A01 +<br>
=C2=A05 files changed, 58 insertions(+), 3 deletions(-)<br>
<br>
diff --git a/libmultipath/wwids.c b/libmultipath/wwids.c<br>
index eca1799..1dc00bb 100644<br>
--- a/libmultipath/wwids.c<br>
+++ b/libmultipath/wwids.c<br>
@@ -274,3 +274,47 @@ remember_wwid(char *wwid)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 condlog(4, &quot;ww=
id %s already in wwids file&quot;, wwid);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
=C2=A0}<br>
+<br>
+int remember_cmdline_wwid(void)<br>
+{<br>
+ =C2=A0 =C2=A0 =C2=A0 FILE *f =3D NULL;<br>
+ =C2=A0 =C2=A0 =C2=A0 char buf[LINE_MAX], *next, *ptr;<br>
+ =C2=A0 =C2=A0 =C2=A0 int ret =3D 0;<br>
+<br>
+ =C2=A0 =C2=A0 =C2=A0 f =3D fopen(&quot;/proc/cmdline&quot;, &quot;re&quot=
;);<br>
+ =C2=A0 =C2=A0 =C2=A0 if (!f) {<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 condlog(0, &quot;can&#39=
;t open /proc/cmdline : %s&quot;, strerror(errno));<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -1;<br>
+ =C2=A0 =C2=A0 =C2=A0 }<br>
+<br>
+ =C2=A0 =C2=A0 =C2=A0 if (!fgets(buf, sizeof(buf), f)) {<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ferror(f))<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 condlog(0, &quot;read of /proc/cmdline failed : %s&quot;,<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 strerror(errno));<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 condlog(0, &quot;couldn&#39;t read /proc/cmdline&quot;);<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fclose(f);<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -1;<br>
+ =C2=A0 =C2=A0 =C2=A0 }<br>
+ =C2=A0 =C2=A0 =C2=A0 fclose(f);<br>
+ =C2=A0 =C2=A0 =C2=A0 next =3D buf;<br>
+ =C2=A0 =C2=A0 =C2=A0 while((ptr =3D strstr(next, &quot;mpath.wwid=3D&quot=
;))) {<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ptr +=3D 11;<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 next =3D strpbrk(ptr, &q=
uot; \t\n&quot;);<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (next) {<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 *next =3D &#39;\0&#39;;<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 next++;<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (strlen(ptr)) {<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (remember_wwid(ptr) !=3D 0)<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D -1;<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else {<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 condlog(0, &quot;empty mpath.wwid kernel command line option&quot;);<br=
>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 ret =3D -1;<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!next)<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 break;<br>
+ =C2=A0 =C2=A0 =C2=A0 }<br>
+ =C2=A0 =C2=A0 =C2=A0 return ret;<br>
+}<br>
diff --git a/libmultipath/wwids.h b/libmultipath/wwids.h<br>
index f3b21fa..2fbd419 100644<br>
--- a/libmultipath/wwids.h<br>
+++ b/libmultipath/wwids.h<br>
@@ -16,5 +16,6 @@ int remember_wwid(char *wwid);<br>
=C2=A0int check_wwids_file(char *wwid, int write_wwid);<br>
=C2=A0int remove_wwid(char *wwid);<br>
=C2=A0int replace_wwids(vector mp);<br>
+int remember_cmdline_wwid(void);<br>
<br>
=C2=A0#endif /* _WWIDS_H */<br>
diff --git a/multipath/main.c b/multipath/main.c<br>
index 157475e..ed93f66 100644<br>
--- a/multipath/main.c<br>
+++ b/multipath/main.c<br>
@@ -84,7 +84,7 @@ usage (char * progname)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 fprintf (stderr, VERSION_STRING);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 fprintf (stderr, &quot;Usage:\n&quot;);<br>
- =C2=A0 =C2=A0 =C2=A0 fprintf (stderr, &quot; =C2=A0%s [-a|-c|-w|-W] [-d] =
[-r] [-v lvl] [-p pol] [-b fil] [-q] [dev]\n&quot;, progname);<br>
+ =C2=A0 =C2=A0 =C2=A0 fprintf (stderr, &quot; =C2=A0%s [-a|-A|-c|-w|-W] [-=
d] [-r] [-v lvl] [-p pol] [-b fil] [-q] [dev]\n&quot;, progname);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 fprintf (stderr, &quot; =C2=A0%s -l|-ll|-f [-v =
lvl] [-b fil] [dev]\n&quot;, progname);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 fprintf (stderr, &quot; =C2=A0%s -F [-v lvl]\n&=
quot;, progname);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 fprintf (stderr, &quot; =C2=A0%s -t\n&quot;, pr=
ogname);<br>
@@ -98,6 +98,8 @@ usage (char * progname)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot; =C2=A0-f =C2=
=A0 =C2=A0 =C2=A0flush a multipath device map\n&quot; \<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot; =C2=A0-F =C2=
=A0 =C2=A0 =C2=A0flush all multipath device maps\n&quot; \<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot; =C2=A0-a =C2=
=A0 =C2=A0 =C2=A0add a device wwid to the wwids file\n&quot; \<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot; =C2=A0-A =C2=A0 =
=C2=A0 =C2=A0add devices from kernel command line mpath.wwids\n&quot;<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot; =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0parameters to wwids file\n&quot; \<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot; =C2=A0-c =C2=
=A0 =C2=A0 =C2=A0check if a device should be a path in a multipath device\n=
&quot; \<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot; =C2=A0-q =C2=
=A0 =C2=A0 =C2=A0allow queue_if_no_path when multipathd is not running\n&qu=
ot;\<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot; =C2=A0-d =C2=
=A0 =C2=A0 =C2=A0dry run, do not create or update devmaps\n&quot; \<br>
@@ -445,7 +447,7 @@ main (int argc, char *argv[])<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (load_config(DEFAULT_CONFIGFILE, udev))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 exit(1);<br>
<br>
- =C2=A0 =C2=A0 =C2=A0 while ((arg =3D getopt(argc, argv, &quot;:adchl::FfM=
:v:p:b:BrtqwW&quot;)) !=3D EOF ) {<br>
+ =C2=A0 =C2=A0 =C2=A0 while ((arg =3D getopt(argc, argv, &quot;:aAdchl::Ff=
M:v:p:b:BrtqwW&quot;)) !=3D EOF ) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 switch(arg) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 case 1: printf(&quo=
t;optarg : %s\n&quot;,optarg);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 break;<br>
@@ -518,6 +520,10 @@ main (int argc, char *argv[])<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 case &#39;a&#39;:<b=
r>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 conf-&gt;cmd =3D CMD_ADD_WWID;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 break;<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 case &#39;A&#39;:<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (remember_cmdline_wwid() !=3D 0)<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 exit(1);<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 exit(0);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 case &#39;:&#39;:<b=
r>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 fprintf(stderr, &quot;Missing option argument\n&quot;);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 usage(argv[0]);<br>
diff --git a/multipath/multipath.8 b/multipath/multipath.8<br>
index b6479b1..f6b30c7 100644<br>
--- a/multipath/multipath.8<br>
+++ b/multipath/multipath.8<br>
@@ -8,7 +8,7 @@ multipath \- Device mapper target autoconfig<br>
=C2=A0.RB [\| \-b\ \c<br>
=C2=A0.IR bindings_file \|]<br>
=C2=A0.RB [\| \-d \|]<br>
-.RB [\| \-h | \-l | \-ll | \-f | \-t | \-F | \-B | \-c | \-q | \|-r | \-a =
| \-w | \-W \|]<br>
+.RB [\| \-h | \-l | \-ll | \-f | \-t | \-F | \-B | \-c | \-q | \|-r | \-a =
| \-A | \-w | \-W \|]<br>
=C2=A0.RB [\| \-p\ \c<br>
=C2=A0.BR failover | multibus | group_by_serial | group_by_prio | group_by_=
node_name \|]<br>
=C2=A0.RB [\| device \|]<br>
@@ -71,6 +71,9 @@ allow device tables with queue_if_no_path when multipathd=
 is not running<br>
=C2=A0.B \-a<br>
=C2=A0add the wwid for the specified device to the wwids file<br>
=C2=A0.TP<br>
+.B \-A<br>
+add wwids from any kernel command line mpath.wwid parameters to the wwids =
file<br>
+.TP<br>
=C2=A0.B \-w<br>
=C2=A0remove the wwid for the specified device from the wwids file<br>
=C2=A0.TP<br>
diff --git a/multipathd/multipathd.service b/multipathd/multipathd.service<=
br>
index be3ba3f..8bb48b5 100644<br>
--- a/multipathd/multipathd.service<br>
+++ b/multipathd/multipathd.service<br>
@@ -10,6 +10,7 @@ Type=3Dnotify<br>
=C2=A0NotifyAccess=3Dmain<br>
=C2=A0LimitCORE=3Dinfinity<br>
=C2=A0ExecStartPre=3D/sbin/modprobe dm-multipath<br>
+ExecStartPre=3D-/sbin/multipath -A<br>
=C2=A0ExecStart=3D/sbin/multipathd -d -s<br>
=C2=A0ExecReload=3D/sbin/multipathd reconfigure<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
1.8.3.1<br>
<br>
</font></span></blockquote></div><br></div>

--047d7b3a81a0d9a29704fd26b17c--


--===============2861940863249771517==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2861940863249771517==--
