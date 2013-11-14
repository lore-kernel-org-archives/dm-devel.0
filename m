From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] libmultipath/checkers/rdac.c: Use RTPG data
	in RDAC checker
Date: Thu, 14 Nov 2013 22:09:43 +0100
Message-ID: <CABr-Gnej_ZnfE8pxm_vrHPX2eqZiL5QU58wviOQcFjdgnyfRVQ@mail.gmail.com>
References: <1384387769-32710-1-git-send-email-sean.stewart@netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2444867267608928007=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1384387769-32710-1-git-send-email-sean.stewart@netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Sean Stewart <sean.stewart@netapp.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============2444867267608928007==
Content-Type: multipart/alternative; boundary=047d7b2e760435a3d804eb298089

--047d7b2e760435a3d804eb298089
Content-Type: text/plain; charset=ISO-8859-1

Applied.
Thanks.

Christophe Varoqui
www.opensvc.com


On Thu, Nov 14, 2013 at 1:09 AM, Sean Stewart <sean.stewart@netapp.com>wrote:

> Make the RDAC checker utilize the RTPG data given in the 0xC9 inquiry
> page to make intelligent decisions about path status, and print more
> descriptive path down messages.
>
> Signed-off-by: Sean Stewart <sean.stewart@netapp.com>
> ---
>  libmultipath/checkers/rdac.c | 92
> ++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 81 insertions(+), 11 deletions(-)
>
> diff --git a/libmultipath/checkers/rdac.c b/libmultipath/checkers/rdac.c
> index 2e64dd3..e0b2ea4 100644
> --- a/libmultipath/checkers/rdac.c
> +++ b/libmultipath/checkers/rdac.c
> @@ -34,6 +34,18 @@
>  #define MSG_RDAC_UP    "rdac checker reports path is up"
>  #define MSG_RDAC_DOWN  "rdac checker reports path is down"
>  #define MSG_RDAC_GHOST "rdac checker reports path is ghost"
> +#define MSG_RDAC_DOWN_TYPE(STR) MSG_RDAC_DOWN": "STR
> +
> +#define RTPG_UNAVAILABLE       0x3
> +#define RTPG_OFFLINE           0xE
> +#define RTPG_TRANSITIONING     0xF
> +
> +#define RTPG_UNAVAIL_NON_RESPONSIVE    0x2
> +#define RTPG_UNAVAIL_IN_RESET          0x3
> +#define RTPG_UNAVAIL_CFW_DL1           0x4
> +#define RTPG_UNAVAIL_CFW_DL2           0x5
> +#define RTPG_UNAVAIL_QUIESCED          0x6
> +#define RTPG_UNAVAIL_SERVICE_MODE      0x7
>
>  struct control_mode_page {
>         unsigned char header[8];
> @@ -199,22 +211,64 @@ struct volume_access_inq
>         char PQ_PDT;
>         char dontcare0[7];
>         char avtcvp;
> -       char dontcare1;
> -       char asym_access_state_cur;
> +       char vol_ppp;
> +       char aas_cur;
>         char vendor_specific_cur;
> -       char dontcare2[36];
> +       char aas_alt;
> +       char vendor_specific_alt;
> +       char dontcare1[34];
>  };
>
> +const char
> +*checker_msg_string(struct volume_access_inq *inq)
> +{
> +       /* lun not connected */
> +       if (((inq->PQ_PDT & 0xE0) == 0x20) || (inq->PQ_PDT & 0x7f))
> +               return MSG_RDAC_DOWN_TYPE("lun not connected");
> +
> +       /* if no tpg data is available, give the generic path down message
> */
> +       if (!(inq->avtcvp & 0x10))
> +               return MSG_RDAC_DOWN;
> +
> +       /* controller is booting up */
> +       if (((inq->aas_cur & 0x0F) == RTPG_TRANSITIONING) &&
> +               (inq->aas_alt & 0x0F) != RTPG_TRANSITIONING)
> +               return MSG_RDAC_DOWN_TYPE("ctlr is in startup sequence");
> +
> +       /* if not unavailable, give generic message */
> +       if ((inq->aas_cur & 0x0F) != RTPG_UNAVAILABLE)
> +               return MSG_RDAC_DOWN;
> +
> +       /* target port group unavailable */
> +       switch (inq->vendor_specific_cur) {
> +       case RTPG_UNAVAIL_NON_RESPONSIVE:
> +               return MSG_RDAC_DOWN_TYPE("non-responsive to queries");
> +       case RTPG_UNAVAIL_IN_RESET:
> +               return MSG_RDAC_DOWN_TYPE("ctlr held in reset");
> +       case RTPG_UNAVAIL_CFW_DL1:
> +       case RTPG_UNAVAIL_CFW_DL2:
> +               return MSG_RDAC_DOWN_TYPE("ctlr firmware downloading");
> +       case RTPG_UNAVAIL_QUIESCED:
> +               return MSG_RDAC_DOWN_TYPE("ctlr quiesced by admin
> request");
> +       case RTPG_UNAVAIL_SERVICE_MODE:
> +               return MSG_RDAC_DOWN_TYPE("ctlr is in service mode");
> +       default:
> +               return MSG_RDAC_DOWN_TYPE("ctlr is unavailable");
> +       }
> +}
> +
>  extern int
>  libcheck_check (struct checker * c)
>  {
>         struct volume_access_inq inq;
> -       int ret;
> +       int ret, inqfail;
>
> +       inqfail = 0;
>         memset(&inq, 0, sizeof(struct volume_access_inq));
>         if (0 != do_inq(c->fd, 0xC9, &inq, sizeof(struct
> volume_access_inq),
>                         c->timeout)) {
>                 ret = PATH_DOWN;
> +               inqfail = 1;
>                 goto done;
>         } else if (((inq.PQ_PDT & 0xE0) == 0x20) || (inq.PQ_PDT & 0x7f)) {
>                 /* LUN not connected*/
> @@ -222,12 +276,27 @@ libcheck_check (struct checker * c)
>                 goto done;
>         }
>
> -       /* check if controller is in service mode */
> -       if ((inq.avtcvp & 0x10) &&
> -           ((inq.asym_access_state_cur & 0x0F) == 0x3) &&
> -           (inq.vendor_specific_cur == 0x7)) {
> -               ret = PATH_DOWN;
> -               goto done;
> +       /* If TPGDE bit set, evaluate TPG information */
> +       if ((inq.avtcvp & 0x10)) {
> +               switch (inq.aas_cur & 0x0F) {
> +               /* Never use the path if it reports unavailable */
> +               case RTPG_UNAVAILABLE:
> +                       ret = PATH_DOWN;
> +                       goto done;
> +               /*
> +                * If both controllers report transitioning, it
> +                * means mode select or STPG is being processed.
> +                *
> +                * If this controller alone is transitioning, it's
> +                * booting and we shouldn't use it yet.
> +                */
> +               case RTPG_TRANSITIONING:
> +                       if ((inq.aas_alt & 0xF) != RTPG_TRANSITIONING) {
> +                               ret = PATH_DOWN;
> +                               goto done;
> +                       }
> +                       break;
> +               }
>         }
>
>         /* If owner set or ioship mode is enabled return PATH_UP always */
> @@ -239,7 +308,8 @@ libcheck_check (struct checker * c)
>  done:
>         switch (ret) {
>         case PATH_DOWN:
> -               MSG(c, MSG_RDAC_DOWN);
> +               MSG(c, (inqfail) ? MSG_RDAC_DOWN_TYPE("inquiry failed") :
> +                       checker_msg_string(&inq));
>                 break;
>         case PATH_UP:
>                 MSG(c, MSG_RDAC_UP);
> --
> 1.8.3.1
>
>

--047d7b2e760435a3d804eb298089
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied.<div>Thanks.</div><div><br></div><div>Christophe V=
aroqui</div><div><a href=3D"http://www.opensvc.com">www.opensvc.com</a></di=
v></div><div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">On Th=
u, Nov 14, 2013 at 1:09 AM, Sean Stewart <span dir=3D"ltr">&lt;<a href=3D"m=
ailto:sean.stewart@netapp.com" target=3D"_blank">sean.stewart@netapp.com</a=
>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">Make the RDAC checker utilize the RTPG data =
given in the 0xC9 inquiry<br>
page to make intelligent decisions about path status, and print more<br>
descriptive path down messages.<br>
<br>
Signed-off-by: Sean Stewart &lt;<a href=3D"mailto:sean.stewart@netapp.com">=
sean.stewart@netapp.com</a>&gt;<br>
---<br>
=A0libmultipath/checkers/rdac.c | 92 ++++++++++++++++++++++++++++++++++++++=
------<br>
=A01 file changed, 81 insertions(+), 11 deletions(-)<br>
<br>
diff --git a/libmultipath/checkers/rdac.c b/libmultipath/checkers/rdac.c<br=
>
index 2e64dd3..e0b2ea4 100644<br>
--- a/libmultipath/checkers/rdac.c<br>
+++ b/libmultipath/checkers/rdac.c<br>
@@ -34,6 +34,18 @@<br>
=A0#define MSG_RDAC_UP =A0 =A0&quot;rdac checker reports path is up&quot;<b=
r>
=A0#define MSG_RDAC_DOWN =A0&quot;rdac checker reports path is down&quot;<b=
r>
=A0#define MSG_RDAC_GHOST &quot;rdac checker reports path is ghost&quot;<br=
>
+#define MSG_RDAC_DOWN_TYPE(STR) MSG_RDAC_DOWN&quot;: &quot;STR<br>
+<br>
+#define RTPG_UNAVAILABLE =A0 =A0 =A0 0x3<br>
+#define RTPG_OFFLINE =A0 =A0 =A0 =A0 =A0 0xE<br>
+#define RTPG_TRANSITIONING =A0 =A0 0xF<br>
+<br>
+#define RTPG_UNAVAIL_NON_RESPONSIVE =A0 =A00x2<br>
+#define RTPG_UNAVAIL_IN_RESET =A0 =A0 =A0 =A0 =A00x3<br>
+#define RTPG_UNAVAIL_CFW_DL1 =A0 =A0 =A0 =A0 =A0 0x4<br>
+#define RTPG_UNAVAIL_CFW_DL2 =A0 =A0 =A0 =A0 =A0 0x5<br>
+#define RTPG_UNAVAIL_QUIESCED =A0 =A0 =A0 =A0 =A00x6<br>
+#define RTPG_UNAVAIL_SERVICE_MODE =A0 =A0 =A00x7<br>
<br>
=A0struct control_mode_page {<br>
=A0 =A0 =A0 =A0 unsigned char header[8];<br>
@@ -199,22 +211,64 @@ struct volume_access_inq<br>
=A0 =A0 =A0 =A0 char PQ_PDT;<br>
=A0 =A0 =A0 =A0 char dontcare0[7];<br>
=A0 =A0 =A0 =A0 char avtcvp;<br>
- =A0 =A0 =A0 char dontcare1;<br>
- =A0 =A0 =A0 char asym_access_state_cur;<br>
+ =A0 =A0 =A0 char vol_ppp;<br>
+ =A0 =A0 =A0 char aas_cur;<br>
=A0 =A0 =A0 =A0 char vendor_specific_cur;<br>
- =A0 =A0 =A0 char dontcare2[36];<br>
+ =A0 =A0 =A0 char aas_alt;<br>
+ =A0 =A0 =A0 char vendor_specific_alt;<br>
+ =A0 =A0 =A0 char dontcare1[34];<br>
=A0};<br>
<br>
+const char<br>
+*checker_msg_string(struct volume_access_inq *inq)<br>
+{<br>
+ =A0 =A0 =A0 /* lun not connected */<br>
+ =A0 =A0 =A0 if (((inq-&gt;PQ_PDT &amp; 0xE0) =3D=3D 0x20) || (inq-&gt;PQ_=
PDT &amp; 0x7f))<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 return MSG_RDAC_DOWN_TYPE(&quot;lun not conne=
cted&quot;);<br>
+<br>
+ =A0 =A0 =A0 /* if no tpg data is available, give the generic path down me=
ssage */<br>
+ =A0 =A0 =A0 if (!(inq-&gt;avtcvp &amp; 0x10))<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 return MSG_RDAC_DOWN;<br>
+<br>
+ =A0 =A0 =A0 /* controller is booting up */<br>
+ =A0 =A0 =A0 if (((inq-&gt;aas_cur &amp; 0x0F) =3D=3D RTPG_TRANSITIONING) =
&amp;&amp;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 (inq-&gt;aas_alt &amp; 0x0F) !=3D RTPG_TRANSI=
TIONING)<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 return MSG_RDAC_DOWN_TYPE(&quot;ctlr is in st=
artup sequence&quot;);<br>
+<br>
+ =A0 =A0 =A0 /* if not unavailable, give generic message */<br>
+ =A0 =A0 =A0 if ((inq-&gt;aas_cur &amp; 0x0F) !=3D RTPG_UNAVAILABLE)<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 return MSG_RDAC_DOWN;<br>
+<br>
+ =A0 =A0 =A0 /* target port group unavailable */<br>
+ =A0 =A0 =A0 switch (inq-&gt;vendor_specific_cur) {<br>
+ =A0 =A0 =A0 case RTPG_UNAVAIL_NON_RESPONSIVE:<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 return MSG_RDAC_DOWN_TYPE(&quot;non-responsiv=
e to queries&quot;);<br>
+ =A0 =A0 =A0 case RTPG_UNAVAIL_IN_RESET:<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 return MSG_RDAC_DOWN_TYPE(&quot;ctlr held in =
reset&quot;);<br>
+ =A0 =A0 =A0 case RTPG_UNAVAIL_CFW_DL1:<br>
+ =A0 =A0 =A0 case RTPG_UNAVAIL_CFW_DL2:<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 return MSG_RDAC_DOWN_TYPE(&quot;ctlr firmware=
 downloading&quot;);<br>
+ =A0 =A0 =A0 case RTPG_UNAVAIL_QUIESCED:<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 return MSG_RDAC_DOWN_TYPE(&quot;ctlr quiesced=
 by admin request&quot;);<br>
+ =A0 =A0 =A0 case RTPG_UNAVAIL_SERVICE_MODE:<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 return MSG_RDAC_DOWN_TYPE(&quot;ctlr is in se=
rvice mode&quot;);<br>
+ =A0 =A0 =A0 default:<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 return MSG_RDAC_DOWN_TYPE(&quot;ctlr is unava=
ilable&quot;);<br>
+ =A0 =A0 =A0 }<br>
+}<br>
+<br>
=A0extern int<br>
=A0libcheck_check (struct checker * c)<br>
=A0{<br>
=A0 =A0 =A0 =A0 struct volume_access_inq inq;<br>
- =A0 =A0 =A0 int ret;<br>
+ =A0 =A0 =A0 int ret, inqfail;<br>
<br>
+ =A0 =A0 =A0 inqfail =3D 0;<br>
=A0 =A0 =A0 =A0 memset(&amp;inq, 0, sizeof(struct volume_access_inq));<br>
=A0 =A0 =A0 =A0 if (0 !=3D do_inq(c-&gt;fd, 0xC9, &amp;inq, sizeof(struct v=
olume_access_inq),<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 c-&gt;timeout)) {<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D PATH_DOWN;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 inqfail =3D 1;<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto done;<br>
=A0 =A0 =A0 =A0 } else if (((inq.PQ_PDT &amp; 0xE0) =3D=3D 0x20) || (inq.PQ=
_PDT &amp; 0x7f)) {<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* LUN not connected*/<br>
@@ -222,12 +276,27 @@ libcheck_check (struct checker * c)<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto done;<br>
=A0 =A0 =A0 =A0 }<br>
<br>
- =A0 =A0 =A0 /* check if controller is in service mode */<br>
- =A0 =A0 =A0 if ((inq.avtcvp &amp; 0x10) &amp;&amp;<br>
- =A0 =A0 =A0 =A0 =A0 ((inq.asym_access_state_cur &amp; 0x0F) =3D=3D 0x3) &=
amp;&amp;<br>
- =A0 =A0 =A0 =A0 =A0 (inq.vendor_specific_cur =3D=3D 0x7)) {<br>
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D PATH_DOWN;<br>
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto done;<br>
+ =A0 =A0 =A0 /* If TPGDE bit set, evaluate TPG information */<br>
+ =A0 =A0 =A0 if ((inq.avtcvp &amp; 0x10)) {<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 switch (inq.aas_cur &amp; 0x0F) {<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Never use the path if it reports unavailab=
le */<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 case RTPG_UNAVAILABLE:<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D PATH_DOWN;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto done;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* If both controllers report transitioning=
, it<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* means mode select or STPG is being proce=
ssed.<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* If this controller alone is transitionin=
g, it&#39;s<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* booting and we shouldn&#39;t use it yet.=
<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 case RTPG_TRANSITIONING:<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((inq.aas_alt &amp; 0xF) !=
=3D RTPG_TRANSITIONING) {<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D PATH_=
DOWN;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto done;<br=
>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 }<br>
=A0 =A0 =A0 =A0 }<br>
<br>
=A0 =A0 =A0 =A0 /* If owner set or ioship mode is enabled return PATH_UP al=
ways */<br>
@@ -239,7 +308,8 @@ libcheck_check (struct checker * c)<br>
=A0done:<br>
=A0 =A0 =A0 =A0 switch (ret) {<br>
=A0 =A0 =A0 =A0 case PATH_DOWN:<br>
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 MSG(c, MSG_RDAC_DOWN);<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 MSG(c, (inqfail) ? MSG_RDAC_DOWN_TYPE(&quot;i=
nquiry failed&quot;) :<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 checker_msg_string(&amp;inq))=
;<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;<br>
=A0 =A0 =A0 =A0 case PATH_UP:<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 MSG(c, MSG_RDAC_UP);<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
1.8.3.1<br>
<br>
</font></span></blockquote></div><br></div>

--047d7b2e760435a3d804eb298089--


--===============2444867267608928007==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2444867267608928007==--
