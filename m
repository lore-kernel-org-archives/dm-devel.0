From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] libmpathpersist: use extern struct udev from
 main program
Date: Wed, 21 Jun 2017 12:24:03 +0200
Message-ID: <CABr-GncjgMzZKVqsUoAzOtGKOq1yx1ukOFme1zu-tJUrVvUxow@mail.gmail.com>
References: <20170326134947.24993-1-mwilck@suse.com>
	<20170620220355.GJ2940@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5342903007222259159=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170620220355.GJ2940@octiron.msp.redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

--===============5342903007222259159==
Content-Type: multipart/alternative; boundary="001a114157666e239a055275c4e8"

--001a114157666e239a055275c4e8
Content-Type: text/plain; charset="UTF-8"

Merged.
Thanks.

On Wed, Jun 21, 2017 at 12:03 AM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> On Sun, Mar 26, 2017 at 03:49:47PM +0200, Martin Wilck wrote:
> > Use the global variable "udev" - the internal one is not
> > initialized, causing current libudev calls to fail.
> > In the main program "mpathpersist", use a globally visible
> > variable "udev" rather than a local variable in main().
> > This imitates the way the global variable "udev" is used
> > in multipath and multipathd.
> >
> > Removed the "udev" parameter from mpath_lib_init() to
> > clarify that it isn't used.
> >
>
> ACK
>
> -Ben
>
> > Fixes: b87454988 "libmultipath: separate out 'udev' config entry"
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> >  libmpathpersist/mpath_persist.c | 4 ++--
> >  libmpathpersist/mpath_persist.h | 2 +-
> >  mpathpersist/main.c             | 5 +++--
> >  3 files changed, 6 insertions(+), 5 deletions(-)
> >
> > diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_
> persist.c
> > index 982c7954..9bca7764 100644
> > --- a/libmpathpersist/mpath_persist.c
> > +++ b/libmpathpersist/mpath_persist.c
> > @@ -34,10 +34,10 @@
> >
> >  #define __STDC_FORMAT_MACROS 1
> >
> > -struct udev *udev;
> > +extern struct udev *udev;
> >
> >  struct config *
> > -mpath_lib_init (struct udev *udev)
> > +mpath_lib_init (void)
> >  {
> >       struct config *conf;
> >
> > diff --git a/libmpathpersist/mpath_persist.h b/libmpathpersist/mpath_
> persist.h
> > index 79de5b5b..7422322d 100644
> > --- a/libmpathpersist/mpath_persist.h
> > +++ b/libmpathpersist/mpath_persist.h
> > @@ -174,7 +174,7 @@ struct prout_param_descriptor {           /* PROUT
> parameter descriptor */
> >   *
> >   * RETURNS: struct config ->Success, NULL->Failed.
> >   */
> > -extern struct config * mpath_lib_init (struct udev *udev);
> > +extern struct config * mpath_lib_init (void);
> >
> >
> >  /*
> > diff --git a/mpathpersist/main.c b/mpathpersist/main.c
> > index 2e0aba3c..e1aac8fa 100644
> > --- a/mpathpersist/main.c
> > +++ b/mpathpersist/main.c
> > @@ -57,6 +57,8 @@ void rcu_register_thread_memb(void) {}
> >
> >  void rcu_unregister_thread_memb(void) {}
> >
> > +struct udev *udev;
> > +
> >  int main (int argc, char * argv[])
> >  {
> >       int fd, c, res;
> > @@ -86,7 +88,6 @@ int main (int argc, char * argv[])
> >       int num_transport =0;
> >       void *resp = NULL;
> >       struct transportid * tmp;
> > -     struct udev *udev = NULL;
> >       struct config *conf;
> >
> >       if (optind == argc)
> > @@ -104,7 +105,7 @@ int main (int argc, char * argv[])
> >       }
> >
> >       udev = udev_new();
> > -     conf = mpath_lib_init(udev);
> > +     conf = mpath_lib_init();
> >       if(!conf) {
> >               udev_unref(udev);
> >               exit(1);
> > --
> > 2.12.0
> >
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--001a114157666e239a055275c4e8
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.<div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Wed, Jun 21, 2017 at 12:03 AM, Benjamin M=
arzinski <span dir=3D"ltr">&lt;<a href=3D"mailto:bmarzins@redhat.com" targe=
t=3D"_blank">bmarzins@redhat.com</a>&gt;</span> wrote:<br><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex"><span class=3D"">On Sun, Mar 26, 2017 at 03:49:47PM +0200, Ma=
rtin Wilck wrote:<br>
&gt; Use the global variable &quot;udev&quot; - the internal one is not<br>
&gt; initialized, causing current libudev calls to fail.<br>
&gt; In the main program &quot;mpathpersist&quot;, use a globally visible<b=
r>
&gt; variable &quot;udev&quot; rather than a local variable in main().<br>
&gt; This imitates the way the global variable &quot;udev&quot; is used<br>
&gt; in multipath and multipathd.<br>
&gt;<br>
&gt; Removed the &quot;udev&quot; parameter from mpath_lib_init() to<br>
&gt; clarify that it isn&#39;t used.<br>
&gt;<br>
<br>
</span>ACK<br>
<br>
-Ben<br>
<div><div class=3D"h5"><br>
&gt; Fixes: b87454988 &quot;libmultipath: separate out &#39;udev&#39; confi=
g entry&quot;<br>
&gt; Signed-off-by: Martin Wilck &lt;<a href=3D"mailto:mwilck@suse.com">mwi=
lck@suse.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 libmpathpersist/mpath_persist.<wbr>c | 4 ++--<br>
&gt;=C2=A0 libmpathpersist/mpath_persist.<wbr>h | 2 +-<br>
&gt;=C2=A0 mpathpersist/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0| 5 +++--<br>
&gt;=C2=A0 3 files changed, 6 insertions(+), 5 deletions(-)<br>
&gt;<br>
&gt; diff --git a/libmpathpersist/mpath_<wbr>persist.c b/libmpathpersist/mp=
ath_<wbr>persist.c<br>
&gt; index 982c7954..9bca7764 100644<br>
&gt; --- a/libmpathpersist/mpath_<wbr>persist.c<br>
&gt; +++ b/libmpathpersist/mpath_<wbr>persist.c<br>
&gt; @@ -34,10 +34,10 @@<br>
&gt;<br>
&gt;=C2=A0 #define __STDC_FORMAT_MACROS 1<br>
&gt;<br>
&gt; -struct udev *udev;<br>
&gt; +extern struct udev *udev;<br>
&gt;<br>
&gt;=C2=A0 struct config *<br>
&gt; -mpath_lib_init (struct udev *udev)<br>
&gt; +mpath_lib_init (void)<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct config *conf;<br>
&gt;<br>
&gt; diff --git a/libmpathpersist/mpath_<wbr>persist.h b/libmpathpersist/mp=
ath_<wbr>persist.h<br>
&gt; index 79de5b5b..7422322d 100644<br>
&gt; --- a/libmpathpersist/mpath_<wbr>persist.h<br>
&gt; +++ b/libmpathpersist/mpath_<wbr>persist.h<br>
&gt; @@ -174,7 +174,7 @@ struct prout_param_descriptor {=C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0/* PROUT parameter descriptor */<br>
&gt;=C2=A0 =C2=A0*<br>
&gt;=C2=A0 =C2=A0* RETURNS: struct config -&gt;Success, NULL-&gt;Failed.<br=
>
&gt;=C2=A0 =C2=A0*/<br>
&gt; -extern struct config * mpath_lib_init (struct udev *udev);<br>
&gt; +extern struct config * mpath_lib_init (void);<br>
&gt;<br>
&gt;<br>
&gt;=C2=A0 /*<br>
&gt; diff --git a/mpathpersist/main.c b/mpathpersist/main.c<br>
&gt; index 2e0aba3c..e1aac8fa 100644<br>
&gt; --- a/mpathpersist/main.c<br>
&gt; +++ b/mpathpersist/main.c<br>
&gt; @@ -57,6 +57,8 @@ void rcu_register_thread_memb(void) {}<br>
&gt;<br>
&gt;=C2=A0 void rcu_unregister_thread_memb(<wbr>void) {}<br>
&gt;<br>
&gt; +struct udev *udev;<br>
&gt; +<br>
&gt;=C2=A0 int main (int argc, char * argv[])<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int fd, c, res;<br>
&gt; @@ -86,7 +88,6 @@ int main (int argc, char * argv[])<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int num_transport =3D0;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0void *resp =3D NULL;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct transportid * tmp;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0struct udev *udev =3D NULL;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct config *conf;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (optind =3D=3D argc)<br>
&gt; @@ -104,7 +105,7 @@ int main (int argc, char * argv[])<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0udev =3D udev_new();<br>
&gt; -=C2=A0 =C2=A0 =C2=A0conf =3D mpath_lib_init(udev);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0conf =3D mpath_lib_init();<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if(!conf) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0udev_unref(udev)=
;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0exit(1);<br>
&gt; --<br>
&gt; 2.12.0<br>
&gt;<br>
</div></div>&gt; --<br>
&gt; dm-devel mailing list<br>
&gt; <a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
&gt; <a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"no=
referrer" target=3D"_blank">https://www.redhat.com/<wbr>mailman/listinfo/dm=
-devel</a><br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/<wbr>mailman/listinfo/dm-deve=
l</a><br>
</blockquote></div><br></div>

--001a114157666e239a055275c4e8--


--===============5342903007222259159==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5342903007222259159==--
