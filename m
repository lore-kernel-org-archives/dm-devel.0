From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath: add option '-i' to ignore wwids
	file
Date: Thu, 24 Jul 2014 10:37:17 +0200
Message-ID: <CABr-GncPvA-M8QK8W-xtb8-Ew49q2mKpCJN5RgRoMthHb1Czmw@mail.gmail.com>
References: <1404454811-21073-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3072377015313451128=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1404454811-21073-1-git-send-email-hare@suse.de>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============3072377015313451128==
Content-Type: multipart/alternative; boundary=089e01634d744d26bb04feec5d73

--089e01634d744d26bb04feec5d73
Content-Type: text/plain; charset=UTF-8

Applied.
Thanks.


On Fri, Jul 4, 2014 at 8:20 AM, Hannes Reinecke <hare@suse.de> wrote:

> When called from udev the multipath program is used to check
> if a device should be handled by multipath. Any new device,
> however, will not be present in /etc/multipath/wwids, and
> the check will always fail.
> This patch implements the option '-i' to multipath to skip
> checking the wwids file for these scenarios.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  libmultipath/config.h |  1 +
>  multipath/main.c      | 18 +++++++++++-------
>  multipath/multipath.8 |  5 ++++-
>  3 files changed, 16 insertions(+), 8 deletions(-)
>
> diff --git a/libmultipath/config.h b/libmultipath/config.h
> index ac7c58e..ca17f39 100644
> --- a/libmultipath/config.h
> +++ b/libmultipath/config.h
> @@ -106,6 +106,7 @@ struct config {
>         int max_fds;
>         int force_reload;
>         int queue_without_daemon;
> +       int ignore_wwids;
>         int checker_timeout;
>         int daemon;
>  #ifdef USE_SYSTEMD
> diff --git a/multipath/main.c b/multipath/main.c
> index 157475e..fd6262f 100644
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -84,7 +84,7 @@ usage (char * progname)
>  {
>         fprintf (stderr, VERSION_STRING);
>         fprintf (stderr, "Usage:\n");
> -       fprintf (stderr, "  %s [-a|-c|-w|-W] [-d] [-r] [-v lvl] [-p pol]
> [-b fil] [-q] [dev]\n", progname);
> +       fprintf (stderr, "  %s [-a|-c|-w|-W] [-d] [-r] [-i] [-v lvl] [-p
> pol] [-b fil] [-q] [dev]\n", progname);
>         fprintf (stderr, "  %s -l|-ll|-f [-v lvl] [-b fil] [dev]\n",
> progname);
>         fprintf (stderr, "  %s -F [-v lvl]\n", progname);
>         fprintf (stderr, "  %s -t\n", progname);
> @@ -103,6 +103,7 @@ usage (char * progname)
>                 "  -d      dry run, do not create or update devmaps\n" \
>                 "  -t      dump internal hardware table\n" \
>                 "  -r      force devmap reload\n" \
> +               "  -i      ignore wwids file\n" \
>                 "  -B      treat the bindings file as read only\n" \
>                 "  -p      policy
> failover|multibus|group_by_serial|group_by_prio\n" \
>                 "  -b fil  bindings file location\n" \
> @@ -307,12 +308,12 @@ configure (void)
>                 }
>                 condlog(3, "scope limited to %s", refwwid);
>                 if (conf->cmd == CMD_VALID_PATH) {
> -                       if (check_wwids_file(refwwid, 0) == 0){
> -                               printf("%s is a valid multipath device
> path\n", conf->dev);
> +                       if (conf->ignore_wwids ||
> +                           check_wwids_file(refwwid, 0) == 0)
>                                 r = 0;
> -                       }
> -                       else
> -                               printf("%s is not a valid multipath device
> path\n", conf->dev);
> +
> +                       printf("%s %s a valid multipath device path\n",
> +                              conf->dev, r == 0 ? "is" : "is not");
>                         goto out;
>                 }
>         }
> @@ -445,7 +446,7 @@ main (int argc, char *argv[])
>         if (load_config(DEFAULT_CONFIGFILE, udev))
>                 exit(1);
>
> -       while ((arg = getopt(argc, argv, ":adchl::FfM:v:p:b:BrtqwW")) !=
> EOF ) {
> +       while ((arg = getopt(argc, argv, ":adchl::FfM:v:p:b:BritqwW")) !=
> EOF ) {
>                 switch(arg) {
>                 case 1: printf("optarg : %s\n",optarg);
>                         break;
> @@ -503,6 +504,9 @@ main (int argc, char *argv[])
>                 case 'r':
>                         conf->force_reload = 1;
>                         break;
> +               case 'i':
> +                       conf->ignore_wwids = 1;
> +                       break;
>                 case 't':
>                         r = dump_config();
>                         goto out_free_config;
> diff --git a/multipath/multipath.8 b/multipath/multipath.8
> index b6479b1..13e2e89 100644
> --- a/multipath/multipath.8
> +++ b/multipath/multipath.8
> @@ -8,7 +8,7 @@ multipath \- Device mapper target autoconfig
>  .RB [\| \-b\ \c
>  .IR bindings_file \|]
>  .RB [\| \-d \|]
> -.RB [\| \-h | \-l | \-ll | \-f | \-t | \-F | \-B | \-c | \-q | \|-r | \-a
> | \-w | \-W \|]
> +.RB [\| \-h | \-l | \-ll | \-f | \-t | \-F | \-B | \-c | \-q | \|-r |
> \|-i | \-a | \-w | \-W \|]
>  .RB [\| \-p\ \c
>  .BR failover | multibus | group_by_serial | group_by_prio |
> group_by_node_name \|]
>  .RB [\| device \|]
> @@ -55,6 +55,9 @@ print internal hardware table to stdout
>  .B \-r
>  force devmap reload
>  .TP
> +.B \-i
> +ignore wwids file when processing devices
> +.TP
>  .B \-B
>  treat the bindings file as read only
>  .TP
> --
> 1.8.4.5
>
>

--089e01634d744d26bb04feec5d73
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied.<div>Thanks.</div></div><div class=3D"gmail_extra"=
><br><br><div class=3D"gmail_quote">On Fri, Jul 4, 2014 at 8:20 AM, Hannes =
Reinecke <span dir=3D"ltr">&lt;<a href=3D"mailto:hare@suse.de" target=3D"_b=
lank">hare@suse.de</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">When called from udev the multipath program =
is used to check<br>
if a device should be handled by multipath. Any new device,<br>
however, will not be present in /etc/multipath/wwids, and<br>
the check will always fail.<br>
This patch implements the option &#39;-i&#39; to multipath to skip<br>
checking the wwids file for these scenarios.<br>
<br>
Signed-off-by: Hannes Reinecke &lt;<a href=3D"mailto:hare@suse.de">hare@sus=
e.de</a>&gt;<br>
---<br>
=C2=A0libmultipath/config.h | =C2=A01 +<br>
=C2=A0multipath/main.c =C2=A0 =C2=A0 =C2=A0| 18 +++++++++++-------<br>
=C2=A0multipath/multipath.8 | =C2=A05 ++++-<br>
=C2=A03 files changed, 16 insertions(+), 8 deletions(-)<br>
<br>
diff --git a/libmultipath/config.h b/libmultipath/config.h<br>
index ac7c58e..ca17f39 100644<br>
--- a/libmultipath/config.h<br>
+++ b/libmultipath/config.h<br>
@@ -106,6 +106,7 @@ struct config {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int max_fds;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int force_reload;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int queue_without_daemon;<br>
+ =C2=A0 =C2=A0 =C2=A0 int ignore_wwids;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int checker_timeout;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int daemon;<br>
=C2=A0#ifdef USE_SYSTEMD<br>
diff --git a/multipath/main.c b/multipath/main.c<br>
index 157475e..fd6262f 100644<br>
--- a/multipath/main.c<br>
+++ b/multipath/main.c<br>
@@ -84,7 +84,7 @@ usage (char * progname)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 fprintf (stderr, VERSION_STRING);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 fprintf (stderr, &quot;Usage:\n&quot;);<br>
- =C2=A0 =C2=A0 =C2=A0 fprintf (stderr, &quot; =C2=A0%s [-a|-c|-w|-W] [-d] =
[-r] [-v lvl] [-p pol] [-b fil] [-q] [dev]\n&quot;, progname);<br>
+ =C2=A0 =C2=A0 =C2=A0 fprintf (stderr, &quot; =C2=A0%s [-a|-c|-w|-W] [-d] =
[-r] [-i] [-v lvl] [-p pol] [-b fil] [-q] [dev]\n&quot;, progname);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 fprintf (stderr, &quot; =C2=A0%s -l|-ll|-f [-v =
lvl] [-b fil] [dev]\n&quot;, progname);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 fprintf (stderr, &quot; =C2=A0%s -F [-v lvl]\n&=
quot;, progname);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 fprintf (stderr, &quot; =C2=A0%s -t\n&quot;, pr=
ogname);<br>
@@ -103,6 +103,7 @@ usage (char * progname)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot; =C2=A0-d =C2=
=A0 =C2=A0 =C2=A0dry run, do not create or update devmaps\n&quot; \<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot; =C2=A0-t =C2=
=A0 =C2=A0 =C2=A0dump internal hardware table\n&quot; \<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot; =C2=A0-r =C2=
=A0 =C2=A0 =C2=A0force devmap reload\n&quot; \<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot; =C2=A0-i =C2=A0 =
=C2=A0 =C2=A0ignore wwids file\n&quot; \<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot; =C2=A0-B =C2=
=A0 =C2=A0 =C2=A0treat the bindings file as read only\n&quot; \<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot; =C2=A0-p =C2=
=A0 =C2=A0 =C2=A0policy failover|multibus|group_by_serial|group_by_prio\n&q=
uot; \<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot; =C2=A0-b fil=
 =C2=A0bindings file location\n&quot; \<br>
@@ -307,12 +308,12 @@ configure (void)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 condlog(3, &quot;sc=
ope limited to %s&quot;, refwwid);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (conf-&gt;cmd =
=3D=3D CMD_VALID_PATH) {<br>
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (check_wwids_file(refwwid, 0) =3D=3D 0){<br>
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printf(&quot;%s is a valid multipath device=
 path\n&quot;, conf-&gt;dev);<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (conf-&gt;ignore_wwids ||<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 check_wwids_file(refwwid, 0) =3D=3D 0)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 r =3D 0;<br>
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 }<br>
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 else<br>
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printf(&quot;%s is not a valid multipath de=
vice path\n&quot;, conf-&gt;dev);<br>
+<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 printf(&quot;%s %s a valid multipath device path\n&quot;,<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0conf-&gt;dev, r =3D=3D 0 ? &quot;is&quot; : =
&quot;is not&quot;);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 goto out;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
@@ -445,7 +446,7 @@ main (int argc, char *argv[])<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (load_config(DEFAULT_CONFIGFILE, udev))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 exit(1);<br>
<br>
- =C2=A0 =C2=A0 =C2=A0 while ((arg =3D getopt(argc, argv, &quot;:adchl::FfM=
:v:p:b:BrtqwW&quot;)) !=3D EOF ) {<br>
+ =C2=A0 =C2=A0 =C2=A0 while ((arg =3D getopt(argc, argv, &quot;:adchl::FfM=
:v:p:b:BritqwW&quot;)) !=3D EOF ) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 switch(arg) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 case 1: printf(&quo=
t;optarg : %s\n&quot;,optarg);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 break;<br>
@@ -503,6 +504,9 @@ main (int argc, char *argv[])<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 case &#39;r&#39;:<b=
r>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 conf-&gt;force_reload =3D 1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 break;<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 case &#39;i&#39;:<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 conf-&gt;ignore_wwids =3D 1;<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 break;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 case &#39;t&#39;:<b=
r>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 r =3D dump_config();<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 goto out_free_config;<br>
diff --git a/multipath/multipath.8 b/multipath/multipath.8<br>
index b6479b1..13e2e89 100644<br>
--- a/multipath/multipath.8<br>
+++ b/multipath/multipath.8<br>
@@ -8,7 +8,7 @@ multipath \- Device mapper target autoconfig<br>
=C2=A0.RB [\| \-b\ \c<br>
=C2=A0.IR bindings_file \|]<br>
=C2=A0.RB [\| \-d \|]<br>
-.RB [\| \-h | \-l | \-ll | \-f | \-t | \-F | \-B | \-c | \-q | \|-r | \-a =
| \-w | \-W \|]<br>
+.RB [\| \-h | \-l | \-ll | \-f | \-t | \-F | \-B | \-c | \-q | \|-r | \|-i=
 | \-a | \-w | \-W \|]<br>
=C2=A0.RB [\| \-p\ \c<br>
=C2=A0.BR failover | multibus | group_by_serial | group_by_prio | group_by_=
node_name \|]<br>
=C2=A0.RB [\| device \|]<br>
@@ -55,6 +55,9 @@ print internal hardware table to stdout<br>
=C2=A0.B \-r<br>
=C2=A0force devmap reload<br>
=C2=A0.TP<br>
+.B \-i<br>
+ignore wwids file when processing devices<br>
+.TP<br>
=C2=A0.B \-B<br>
=C2=A0treat the bindings file as read only<br>
=C2=A0.TP<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
1.8.4.5<br>
<br>
</font></span></blockquote></div><br></div>

--089e01634d744d26bb04feec5d73--


--===============3072377015313451128==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3072377015313451128==--
