From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] mpathpersist: fix one more crash possiblity
Date: Thu, 18 May 2017 00:30:12 +0200
Message-ID: <CABr-GneCsYKQ1AyXzMY1e2H-YhzH=8nGM0sV10vNx1dzBCVbwQ@mail.gmail.com>
References: <1494654298-22658-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2654569317343762620=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1494654298-22658-1-git-send-email-bmarzins@redhat.com>
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

--===============2654569317343762620==
Content-Type: multipart/alternative; boundary="94eb2c09b39eee277e054fbfd4a1"

--94eb2c09b39eee277e054fbfd4a1
Content-Type: text/plain; charset="UTF-8"

Merged.
Thanks.

On Sat, May 13, 2017 at 7:44 AM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> when mpathpersist goes to rollback reservations, it doesn't do a
> rollback (and thus doesn't create a pthread) on paths that didn't
> successfully create a reservation in the first place. It also doesn't
> do any rollbacks at all if the last path in the multipath device was down,
> which is completely broken. However it still tries to join these
> non-existant pthreads, causing crashes.  To fix this, set the status to
> -1 (now MPATH_PR_SKIP) on threadinfos that don't get rollbacks, and
> remove the broken path state checking.
>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmpathpersist/mpath_persist.c | 13 +++++++------
>  libmpathpersist/mpath_persist.h |  1 +
>  2 files changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_
> persist.c
> index bf06efe..7fd4cb8 100644
> --- a/libmpathpersist/mpath_persist.c
> +++ b/libmpathpersist/mpath_persist.c
> @@ -481,7 +481,7 @@ int mpath_prout_reg(struct multipath *mpp,int
> rq_servact, int rq_scope,
>                 thread[i].param.rq_type = rq_type;
>                 thread[i].param.paramp = paramp;
>                 thread[i].param.noisy = noisy;
> -               thread[i].param.status = -1;
> +               thread[i].param.status = MPATH_PR_SKIP;
>
>                 condlog (3, "THRED ID [%d] INFO]", i);
>                 condlog (3, "rq_servact=%d ", thread[i].param.rq_servact);
> @@ -548,8 +548,7 @@ int mpath_prout_reg(struct multipath *mpp,int
> rq_servact, int rq_scope,
>         if (rollback && ((rq_servact == MPATH_PROUT_REG_SA) && sa_key != 0
> )){
>                 condlog (3, "%s: ERROR: initiating pr out rollback",
> mpp->wwid);
>                 for( i=0 ; i < active_pathcount ; i++){
> -                       if((thread[i].param.status == MPATH_PR_SUCCESS) &&
> -                                       ((pp->state == PATH_UP) ||
> (pp->state == PATH_GHOST))){
> +                       if(thread[i].param.status == MPATH_PR_SUCCESS) {
>                                 memcpy(&thread[i].param.paramp->key,
> &thread[i].param.paramp->sa_key, 8);
>                                 memset(&thread[i].param.paramp->sa_key,
> 0, 8);
>                                 thread[i].param.status = MPATH_PR_SUCCESS;
> @@ -559,10 +558,12 @@ int mpath_prout_reg(struct multipath *mpp,int
> rq_servact, int rq_scope,
>                                         condlog (0, "%s: failed to create
> thread for rollback. %d",  mpp->wwid, rc);
>                                         thread[i].param.status =
> MPATH_PR_THREAD_ERROR;
>                                 }
> -                       }
> +                       } else
> +                               thread[i].param.status = MPATH_PR_SKIP;
>                 }
>                 for(i=0; i < active_pathcount ; i++){
> -                       if (thread[i].param.status !=
> MPATH_PR_THREAD_ERROR) {
> +                       if (thread[i].param.status != MPATH_PR_SKIP &&
> +                           thread[i].param.status !=
> MPATH_PR_THREAD_ERROR) {
>                                 rc = pthread_join(thread[i].id, NULL);
>                                 if (rc){
>                                         condlog (3, "%s: failed to join
> thread while rolling back %d",
> @@ -676,7 +677,7 @@ int mpath_prout_rel(struct multipath *mpp,int
> rq_servact, int rq_scope,
>                 thread[i].param.rq_type = rq_type;
>                 thread[i].param.paramp = paramp;
>                 thread[i].param.noisy = noisy;
> -               thread[i].param.status = -1;
> +               thread[i].param.status = MPATH_PR_SKIP;
>
>                 condlog (3, " path count = %d", i);
>                 condlog (3, "rq_servact=%d ", thread[i].param.rq_servact);
> diff --git a/libmpathpersist/mpath_persist.h b/libmpathpersist/mpath_
> persist.h
> index 0f95943..1a34ce7 100644
> --- a/libmpathpersist/mpath_persist.h
> +++ b/libmpathpersist/mpath_persist.h
> @@ -43,6 +43,7 @@ extern "C" {
>
>
>  /* PR RETURN_STATUS */
> +#define MPATH_PR_SKIP                  -1  /* skipping this path */
>  #define MPATH_PR_SUCCESS               0
>  #define MPATH_PR_SYNTAX_ERROR          1   /*  syntax error or invalid
> parameter */
>                                             /* status for check condition
> */
> --
> 1.8.3.1
>
>

--94eb2c09b39eee277e054fbfd4a1
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.<div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Sat, May 13, 2017 at 7:44 AM, Benjamin Ma=
rzinski <span dir=3D"ltr">&lt;<a href=3D"mailto:bmarzins@redhat.com" target=
=3D"_blank">bmarzins@redhat.com</a>&gt;</span> wrote:<br><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex">when mpathpersist goes to rollback reservations, it doesn&#39=
;t do a<br>
rollback (and thus doesn&#39;t create a pthread) on paths that didn&#39;t<b=
r>
successfully create a reservation in the first place. It also doesn&#39;t<b=
r>
do any rollbacks at all if the last path in the multipath device was down,<=
br>
which is completely broken. However it still tries to join these<br>
non-existant pthreads, causing crashes.=C2=A0 To fix this, set the status t=
o<br>
-1 (now MPATH_PR_SKIP) on threadinfos that don&#39;t get rollbacks, and<br>
remove the broken path state checking.<br>
<br>
Signed-off-by: Benjamin Marzinski &lt;<a href=3D"mailto:bmarzins@redhat.com=
">bmarzins@redhat.com</a>&gt;<br>
---<br>
=C2=A0libmpathpersist/mpath_persist.<wbr>c | 13 +++++++------<br>
=C2=A0libmpathpersist/mpath_persist.<wbr>h |=C2=A0 1 +<br>
=C2=A02 files changed, 8 insertions(+), 6 deletions(-)<br>
<br>
diff --git a/libmpathpersist/mpath_<wbr>persist.c b/libmpathpersist/mpath_<=
wbr>persist.c<br>
index bf06efe..7fd4cb8 100644<br>
--- a/libmpathpersist/mpath_<wbr>persist.c<br>
+++ b/libmpathpersist/mpath_<wbr>persist.c<br>
@@ -481,7 +481,7 @@ int mpath_prout_reg(struct multipath *mpp,int rq_servac=
t, int rq_scope,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 thread[i].param.rq_=
type =3D rq_type;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 thread[i].param.par=
amp =3D paramp;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 thread[i].param.noi=
sy =3D noisy;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0thread[i].param.sta=
tus =3D -1;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0thread[i].param.sta=
tus =3D MPATH_PR_SKIP;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 condlog (3, &quot;T=
HRED ID [%d] INFO]&quot;, i);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 condlog (3, &quot;r=
q_servact=3D%d &quot;, thread[i].param.rq_servact);<br>
@@ -548,8 +548,7 @@ int mpath_prout_reg(struct multipath *mpp,int rq_servac=
t, int rq_scope,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rollback &amp;&amp; ((rq_servact =3D=3D MPA=
TH_PROUT_REG_SA) &amp;&amp; sa_key !=3D 0 )){<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 condlog (3, &quot;%=
s: ERROR: initiating pr out rollback&quot;, mpp-&gt;wwid);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 for( i=3D0 ; i &lt;=
 active_pathcount ; i++){<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0if((thread[i].param.status =3D=3D MPATH_PR_SUCCESS) &amp;&amp;<br=
>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0((pp-&gt;=
state =3D=3D PATH_UP) || (pp-&gt;state =3D=3D PATH_GHOST))){<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0if(thread[i].param.status =3D=3D MPATH_PR_SUCCESS) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 memcpy(&amp;thread[i].param.<wbr>par=
amp-&gt;key, &amp;thread[i].param.paramp-&gt;sa_<wbr>key, 8);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 memset(&amp;thread[i].param.<wbr>par=
amp-&gt;sa_key, 0, 8);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 thread[i].param.status =3D MPATH_PR_=
SUCCESS;<br>
@@ -559,10 +558,12 @@ int mpath_prout_reg(struct multipath *mpp,int rq_serv=
act, int rq_scope,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 condlog =
(0, &quot;%s: failed to create thread for rollback. %d&quot;,=C2=A0 mpp-&gt=
;wwid, rc);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 thread[i=
].param.status =3D MPATH_PR_THREAD_ERROR;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0} else<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0thread[i].param.status =3D MPATH_PR_S=
KIP;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 for(i=3D0; i &lt; a=
ctive_pathcount ; i++){<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0if (thread[i].param.status !=3D MPATH_PR_THREAD_ERROR) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0if (thread[i].param.status !=3D MPATH_PR_SKIP &amp;&amp;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0thread[i].param.status !=3D MPATH_PR_THREAD_ERROR) =
{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D pthread_join(thread[i].id, NU=
LL);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc){<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 condlog =
(3, &quot;%s: failed to join thread while rolling back %d&quot;,<br>
@@ -676,7 +677,7 @@ int mpath_prout_rel(struct multipath *mpp,int rq_servac=
t, int rq_scope,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 thread[i].param.rq_=
type =3D rq_type;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 thread[i].param.par=
amp =3D paramp;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 thread[i].param.noi=
sy =3D noisy;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0thread[i].param.sta=
tus =3D -1;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0thread[i].param.sta=
tus =3D MPATH_PR_SKIP;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 condlog (3, &quot; =
path count =3D %d&quot;, i);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 condlog (3, &quot;r=
q_servact=3D%d &quot;, thread[i].param.rq_servact);<br>
diff --git a/libmpathpersist/mpath_<wbr>persist.h b/libmpathpersist/mpath_<=
wbr>persist.h<br>
index 0f95943..1a34ce7 100644<br>
--- a/libmpathpersist/mpath_<wbr>persist.h<br>
+++ b/libmpathpersist/mpath_<wbr>persist.h<br>
@@ -43,6 +43,7 @@ extern &quot;C&quot; {<br>
<br>
<br>
=C2=A0/* PR RETURN_STATUS */<br>
+#define MPATH_PR_SKIP=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 -1=C2=A0 /* skipping this path */<br>
=C2=A0#define MPATH_PR_SUCCESS=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A00<br>
=C2=A0#define MPATH_PR_SYNTAX_ERROR=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1=C2=
=A0 =C2=A0/*=C2=A0 syntax error or invalid parameter */<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 /* status for check condition */<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
1.8.3.1<br>
<br>
</font></span></blockquote></div><br></div>

--94eb2c09b39eee277e054fbfd4a1--


--===============2654569317343762620==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2654569317343762620==--
