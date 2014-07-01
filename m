From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 05/12] allow users to add wwids to
 /etc/multipath/wwids with -a
Date: Tue, 1 Jul 2014 20:58:13 +0200
Message-ID: <CABr-GneeMqZoXPNTRU109ny5DVS+ULnxMTYTb8b0t4-z7Y0Jcg@mail.gmail.com>
References: <1404105243-5071-1-git-send-email-bmarzins@redhat.com>
	<1404105243-5071-6-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6026584560557521503=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1404105243-5071-6-git-send-email-bmarzins@redhat.com>
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

--===============6026584560557521503==
Content-Type: multipart/alternative; boundary=001a11c2e55a93d32b04fd265bb6

--001a11c2e55a93d32b04fd265bb6
Content-Type: text/plain; charset=UTF-8

Applied.
Thanks.


On Mon, Jun 30, 2014 at 7:13 AM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> The patch adds a "-a" option to multipath, that allows it to add wwids
> to the /etc/multipath wwids file.
>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/config.h |  1 +
>  multipath/main.c      | 17 +++++++++++++++--
>  multipath/multipath.8 |  5 ++++-
>  3 files changed, 20 insertions(+), 3 deletions(-)
>
> diff --git a/libmultipath/config.h b/libmultipath/config.h
> index eb23820..ac7c58e 100644
> --- a/libmultipath/config.h
> +++ b/libmultipath/config.h
> @@ -30,6 +30,7 @@ enum mpath_cmds {
>         CMD_VALID_PATH,
>         CMD_REMOVE_WWID,
>         CMD_RESET_WWIDS,
> +       CMD_ADD_WWID,
>  };
>
>  struct hwentry {
> diff --git a/multipath/main.c b/multipath/main.c
> index 54b2a74..157475e 100644
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -84,7 +84,7 @@ usage (char * progname)
>  {
>         fprintf (stderr, VERSION_STRING);
>         fprintf (stderr, "Usage:\n");
> -       fprintf (stderr, "  %s [-c|-w|-W] [-d] [-r] [-v lvl] [-p pol] [-b
> fil] [-q] [dev]\n", progname);
> +       fprintf (stderr, "  %s [-a|-c|-w|-W] [-d] [-r] [-v lvl] [-p pol]
> [-b fil] [-q] [dev]\n", progname);
>         fprintf (stderr, "  %s -l|-ll|-f [-v lvl] [-b fil] [dev]\n",
> progname);
>         fprintf (stderr, "  %s -F [-v lvl]\n", progname);
>         fprintf (stderr, "  %s -t\n", progname);
> @@ -97,6 +97,7 @@ usage (char * progname)
>                 "  -ll     show multipath topology (maximum info)\n" \
>                 "  -f      flush a multipath device map\n" \
>                 "  -F      flush all multipath device maps\n" \
> +               "  -a      add a device wwid to the wwids file\n" \
>                 "  -c      check if a device should be a path in a
> multipath device\n" \
>                 "  -q      allow queue_if_no_path when multipathd is not
> running\n"\
>                 "  -d      dry run, do not create or update devmaps\n" \
> @@ -295,6 +296,15 @@ configure (void)
>                         }
>                         goto out;
>                 }
> +               if (conf->cmd == CMD_ADD_WWID) {
> +                       r = remember_wwid(refwwid);
> +                       if (r == 0)
> +                               printf("wwid '%s' added\n", refwwid);
> +                       else
> +                               printf("failed adding '%s' to wwids
> file\n",
> +                                      refwwid);
> +                       goto out;
> +               }
>                 condlog(3, "scope limited to %s", refwwid);
>                 if (conf->cmd == CMD_VALID_PATH) {
>                         if (check_wwids_file(refwwid, 0) == 0){
> @@ -435,7 +445,7 @@ main (int argc, char *argv[])
>         if (load_config(DEFAULT_CONFIGFILE, udev))
>                 exit(1);
>
> -       while ((arg = getopt(argc, argv, ":dchl::FfM:v:p:b:BrtqwW")) !=
> EOF ) {
> +       while ((arg = getopt(argc, argv, ":adchl::FfM:v:p:b:BrtqwW")) !=
> EOF ) {
>                 switch(arg) {
>                 case 1: printf("optarg : %s\n",optarg);
>                         break;
> @@ -505,6 +515,9 @@ main (int argc, char *argv[])
>                 case 'W':
>                         conf->cmd = CMD_RESET_WWIDS;
>                         break;
> +               case 'a':
> +                       conf->cmd = CMD_ADD_WWID;
> +                       break;
>                 case ':':
>                         fprintf(stderr, "Missing option argument\n");
>                         usage(argv[0]);
> diff --git a/multipath/multipath.8 b/multipath/multipath.8
> index a2262ac..b6479b1 100644
> --- a/multipath/multipath.8
> +++ b/multipath/multipath.8
> @@ -8,7 +8,7 @@ multipath \- Device mapper target autoconfig
>  .RB [\| \-b\ \c
>  .IR bindings_file \|]
>  .RB [\| \-d \|]
> -.RB [\| \-h | \-l | \-ll | \-f | \-t | \-F | \-B | \-c | \-q | \|-r | \-w
> | \-W \|]
> +.RB [\| \-h | \-l | \-ll | \-f | \-t | \-F | \-B | \-c | \-q | \|-r | \-a
> | \-w | \-W \|]
>  .RB [\| \-p\ \c
>  .BR failover | multibus | group_by_serial | group_by_prio |
> group_by_node_name \|]
>  .RB [\| device \|]
> @@ -68,6 +68,9 @@ check if a block device should be a path in a multipath
> device
>  .B \-q
>  allow device tables with queue_if_no_path when multipathd is not running
>  .TP
> +.B \-a
> +add the wwid for the specified device to the wwids file
> +.TP
>  .B \-w
>  remove the wwid for the specified device from the wwids file
>  .TP
> --
> 1.8.3.1
>
>

--001a11c2e55a93d32b04fd265bb6
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Applied.<br></div>Thanks.<br></div><div class=3D"gmai=
l_extra"><br><br><div class=3D"gmail_quote">On Mon, Jun 30, 2014 at 7:13 AM=
, Benjamin Marzinski <span dir=3D"ltr">&lt;<a href=3D"mailto:bmarzins@redha=
t.com" target=3D"_blank">bmarzins@redhat.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">The patch adds a &quot;-a&quot; option to mu=
ltipath, that allows it to add wwids<br>
to the /etc/multipath wwids file.<br>
<br>
Signed-off-by: Benjamin Marzinski &lt;<a href=3D"mailto:bmarzins@redhat.com=
">bmarzins@redhat.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/config.h | =C2=A01 +<br>
=C2=A0multipath/main.c =C2=A0 =C2=A0 =C2=A0| 17 +++++++++++++++--<br>
=C2=A0multipath/multipath.8 | =C2=A05 ++++-<br>
=C2=A03 files changed, 20 insertions(+), 3 deletions(-)<br>
<br>
diff --git a/libmultipath/config.h b/libmultipath/config.h<br>
index eb23820..ac7c58e 100644<br>
--- a/libmultipath/config.h<br>
+++ b/libmultipath/config.h<br>
@@ -30,6 +30,7 @@ enum mpath_cmds {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 CMD_VALID_PATH,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 CMD_REMOVE_WWID,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 CMD_RESET_WWIDS,<br>
+ =C2=A0 =C2=A0 =C2=A0 CMD_ADD_WWID,<br>
=C2=A0};<br>
<br>
=C2=A0struct hwentry {<br>
diff --git a/multipath/main.c b/multipath/main.c<br>
index 54b2a74..157475e 100644<br>
--- a/multipath/main.c<br>
+++ b/multipath/main.c<br>
@@ -84,7 +84,7 @@ usage (char * progname)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 fprintf (stderr, VERSION_STRING);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 fprintf (stderr, &quot;Usage:\n&quot;);<br>
- =C2=A0 =C2=A0 =C2=A0 fprintf (stderr, &quot; =C2=A0%s [-c|-w|-W] [-d] [-r=
] [-v lvl] [-p pol] [-b fil] [-q] [dev]\n&quot;, progname);<br>
+ =C2=A0 =C2=A0 =C2=A0 fprintf (stderr, &quot; =C2=A0%s [-a|-c|-w|-W] [-d] =
[-r] [-v lvl] [-p pol] [-b fil] [-q] [dev]\n&quot;, progname);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 fprintf (stderr, &quot; =C2=A0%s -l|-ll|-f [-v =
lvl] [-b fil] [dev]\n&quot;, progname);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 fprintf (stderr, &quot; =C2=A0%s -F [-v lvl]\n&=
quot;, progname);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 fprintf (stderr, &quot; =C2=A0%s -t\n&quot;, pr=
ogname);<br>
@@ -97,6 +97,7 @@ usage (char * progname)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot; =C2=A0-ll =
=C2=A0 =C2=A0 show multipath topology (maximum info)\n&quot; \<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot; =C2=A0-f =C2=
=A0 =C2=A0 =C2=A0flush a multipath device map\n&quot; \<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot; =C2=A0-F =C2=
=A0 =C2=A0 =C2=A0flush all multipath device maps\n&quot; \<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot; =C2=A0-a =C2=A0 =
=C2=A0 =C2=A0add a device wwid to the wwids file\n&quot; \<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot; =C2=A0-c =C2=
=A0 =C2=A0 =C2=A0check if a device should be a path in a multipath device\n=
&quot; \<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot; =C2=A0-q =C2=
=A0 =C2=A0 =C2=A0allow queue_if_no_path when multipathd is not running\n&qu=
ot;\<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot; =C2=A0-d =C2=
=A0 =C2=A0 =C2=A0dry run, do not create or update devmaps\n&quot; \<br>
@@ -295,6 +296,15 @@ configure (void)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 goto out;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (conf-&gt;cmd =3D=3D =
CMD_ADD_WWID) {<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 r =3D remember_wwid(refwwid);<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (r =3D=3D 0)<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printf(&quot;wwid &#39;%s&#39; added\n&quot=
;, refwwid);<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 else<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printf(&quot;failed adding &#39;%s&#39; to =
wwids file\n&quot;,<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0refwwid);<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 goto out;<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 condlog(3, &quot;sc=
ope limited to %s&quot;, refwwid);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (conf-&gt;cmd =
=3D=3D CMD_VALID_PATH) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (check_wwids_file(refwwid, 0) =3D=3D 0){<br>
@@ -435,7 +445,7 @@ main (int argc, char *argv[])<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (load_config(DEFAULT_CONFIGFILE, udev))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 exit(1);<br>
<br>
- =C2=A0 =C2=A0 =C2=A0 while ((arg =3D getopt(argc, argv, &quot;:dchl::FfM:=
v:p:b:BrtqwW&quot;)) !=3D EOF ) {<br>
+ =C2=A0 =C2=A0 =C2=A0 while ((arg =3D getopt(argc, argv, &quot;:adchl::FfM=
:v:p:b:BrtqwW&quot;)) !=3D EOF ) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 switch(arg) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 case 1: printf(&quo=
t;optarg : %s\n&quot;,optarg);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 break;<br>
@@ -505,6 +515,9 @@ main (int argc, char *argv[])<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 case &#39;W&#39;:<b=
r>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 conf-&gt;cmd =3D CMD_RESET_WWIDS;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 break;<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 case &#39;a&#39;:<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 conf-&gt;cmd =3D CMD_ADD_WWID;<br>
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 break;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 case &#39;:&#39;:<b=
r>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 fprintf(stderr, &quot;Missing option argument\n&quot;);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 usage(argv[0]);<br>
diff --git a/multipath/multipath.8 b/multipath/multipath.8<br>
index a2262ac..b6479b1 100644<br>
--- a/multipath/multipath.8<br>
+++ b/multipath/multipath.8<br>
@@ -8,7 +8,7 @@ multipath \- Device mapper target autoconfig<br>
=C2=A0.RB [\| \-b\ \c<br>
=C2=A0.IR bindings_file \|]<br>
=C2=A0.RB [\| \-d \|]<br>
-.RB [\| \-h | \-l | \-ll | \-f | \-t | \-F | \-B | \-c | \-q | \|-r | \-w =
| \-W \|]<br>
+.RB [\| \-h | \-l | \-ll | \-f | \-t | \-F | \-B | \-c | \-q | \|-r | \-a =
| \-w | \-W \|]<br>
=C2=A0.RB [\| \-p\ \c<br>
=C2=A0.BR failover | multibus | group_by_serial | group_by_prio | group_by_=
node_name \|]<br>
=C2=A0.RB [\| device \|]<br>
@@ -68,6 +68,9 @@ check if a block device should be a path in a multipath d=
evice<br>
=C2=A0.B \-q<br>
=C2=A0allow device tables with queue_if_no_path when multipathd is not runn=
ing<br>
=C2=A0.TP<br>
+.B \-a<br>
+add the wwid for the specified device to the wwids file<br>
+.TP<br>
=C2=A0.B \-w<br>
=C2=A0remove the wwid for the specified device from the wwids file<br>
=C2=A0.TP<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
1.8.3.1<br>
<br>
</font></span></blockquote></div><br></div>

--001a11c2e55a93d32b04fd265bb6--


--===============6026584560557521503==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6026584560557521503==--
