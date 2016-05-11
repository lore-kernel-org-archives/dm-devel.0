From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: multipathd: move 'filter_devnode' under vector lock
Date: Wed, 11 May 2016 19:36:39 +0200
Message-ID: <CABr-Gne9Dz6ayWWreJPcCG5r0UhFM+NtUE__1SuF=4eVjgOw2A@mail.gmail.com>
References: <1462962941-9429-1-git-send-email-hare@suse.de>
	<20160511171839.GC26117@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6157541445626531926=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160511171839.GC26117@octiron.msp.redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Hannes Reinecke <hare@suse.com>
List-Id: dm-devel.ids

--===============6157541445626531926==
Content-Type: multipart/alternative; boundary=001a11411da0f366c50532947b4b

--001a11411da0f366c50532947b4b
Content-Type: text/plain; charset=UTF-8

Merged

On Wed, May 11, 2016 at 7:18 PM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> On Wed, May 11, 2016 at 12:35:41PM +0200, Hannes Reinecke wrote:
> > Ben Marzinski pointed out that filter_devnode() is used
> > without any lock or configuration settings in uev_trigger(),
> > and hence might be invalid when processing events during
> > reconfiguration.
> > So move it into the individual functions and handle it
> > with the vector lock held.
>
> ACK
>
> -Ben
>
> >
> > Signed-off-by: Hannes Reinecke <hare@suse.com>
> > ---
> >  multipathd/main.c | 45 +++++++++++++++++++++++++++------------------
> >  1 file changed, 27 insertions(+), 18 deletions(-)
> >
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index 58e8854..2c7486d 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -580,6 +580,11 @@ uev_add_path (struct uevent *uev, struct vectors *
> vecs)
> >       pthread_cleanup_push(cleanup_lock, &vecs->lock);
> >       lock(vecs->lock);
> >       pthread_testcancel();
> > +     if (filter_devnode(conf->blist_devnode, conf->elist_devnode,
> > +                        uev->kernel) > 0) {
> > +             ret = 0;
> > +             goto out_unlock;
> > +     }
> >       pp = find_path_by_dev(vecs->pathvec, uev->kernel);
> >       if (pp) {
> >               int r;
> > @@ -637,6 +642,7 @@ uev_add_path (struct uevent *uev, struct vectors *
> vecs)
> >               free_path(pp);
> >               ret = 1;
> >       }
> > +out_unlock:
> >       lock_cleanup_pop(vecs->lock);
> >       return ret;
> >  }
> > @@ -780,22 +786,23 @@ fail:
> >  static int
> >  uev_remove_path (struct uevent *uev, struct vectors * vecs)
> >  {
> > -     struct path *pp;
> > -     int ret;
> > +     struct path *pp = NULL;
> > +     int ret = 0;
> >
> >       condlog(2, "%s: remove path (uevent)", uev->kernel);
> >       pthread_cleanup_push(cleanup_lock, &vecs->lock);
> >       lock(vecs->lock);
> >       pthread_testcancel();
> > -     pp = find_path_by_dev(vecs->pathvec, uev->kernel);
> > -     if (pp)
> > -             ret = ev_remove_path(pp, vecs);
> > -     lock_cleanup_pop(vecs->lock);
> > -     if (!pp) {
> > -             /* Not an error; path might have been purged earlier */
> > -             condlog(0, "%s: path already removed", uev->kernel);
> > -             return 0;
> > +     if (filter_devnode(conf->blist_devnode, conf->elist_devnode,
> > +                        uev->kernel) == 0) {
> > +             pp = find_path_by_dev(vecs->pathvec, uev->kernel);
> > +             if (pp)
> > +                     ret = ev_remove_path(pp, vecs);
> > +             else
> > +                     /* Not an error; path might have been purged
> earlier */
> > +                     condlog(0, "%s: path already removed",
> uev->kernel);
> >       }
> > +     lock_cleanup_pop(vecs->lock);
> >       return ret;
> >  }
> >
> > @@ -905,7 +912,7 @@ uev_update_path (struct uevent *uev, struct vectors
> * vecs)
> >       ro = uevent_get_disk_ro(uev);
> >
> >       if (ro >= 0) {
> > -             struct path * pp;
> > +             struct path * pp = NULL;
> >               struct multipath *mpp = NULL;
> >
> >               condlog(2, "%s: update path write_protect to '%d'
> (uevent)",
> > @@ -918,6 +925,10 @@ uev_update_path (struct uevent *uev, struct vectors
> * vecs)
> >                * need to be at the same indentation level, hence
> >                * this slightly convoluted codepath.
> >                */
> > +             if (filter_devnode(conf->blist_devnode,
> conf->elist_devnode,
> > +                                uev->kernel) > 0) {
> > +                     goto out_unlock;
> > +             }
> >               pp = find_path_by_dev(vecs->pathvec, uev->kernel);
> >               if (pp) {
> >                       if (pp->initialized == INIT_REQUESTED_UDEV) {
> > @@ -937,11 +948,13 @@ uev_update_path (struct uevent *uev, struct
> vectors * vecs)
> >                                       uev->kernel, mpp->alias, retval);
> >                       }
> >               }
> > +     out_unlock:
> >               lock_cleanup_pop(vecs->lock);
> >               if (!pp) {
> > -                     condlog(0, "%s: spurious uevent, path not found",
> > -                             uev->kernel);
> > -                     return 1;
> > +                     if (retval)
> > +                             condlog(0, "%s: spurious uevent, path not
> found",
> > +                                     uev->kernel);
> > +                     return retval;
> >               }
> >               if (retval == 2)
> >                       return uev_add_path(uev, vecs);
> > @@ -1059,10 +1072,6 @@ uev_trigger (struct uevent * uev, void *
> trigger_data)
> >       /*
> >        * path add/remove event
> >        */
> > -     if (filter_devnode(conf->blist_devnode, conf->elist_devnode,
> > -                        uev->kernel) > 0)
> > -             goto out;
> > -
> >       if (!strncmp(uev->action, "add", 3)) {
> >               r = uev_add_path(uev, vecs);
> >               goto out;
> > --
> > 2.6.6
>

--001a11411da0f366c50532947b4b
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged</div><div class=3D"gmail_extra"><br><div class=3D"g=
mail_quote">On Wed, May 11, 2016 at 7:18 PM, Benjamin Marzinski <span dir=
=3D"ltr">&lt;<a href=3D"mailto:bmarzins@redhat.com" target=3D"_blank">bmarz=
ins@redhat.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" s=
tyle=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><spa=
n class=3D"">On Wed, May 11, 2016 at 12:35:41PM +0200, Hannes Reinecke wrot=
e:<br>
&gt; Ben Marzinski pointed out that filter_devnode() is used<br>
&gt; without any lock or configuration settings in uev_trigger(),<br>
&gt; and hence might be invalid when processing events during<br>
&gt; reconfiguration.<br>
&gt; So move it into the individual functions and handle it<br>
&gt; with the vector lock held.<br>
<br>
</span>ACK<br>
<br>
-Ben<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
&gt;<br>
&gt; Signed-off-by: Hannes Reinecke &lt;<a href=3D"mailto:hare@suse.com">ha=
re@suse.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 multipathd/main.c | 45 +++++++++++++++++++++++++++--------------=
----<br>
&gt;=C2=A0 1 file changed, 27 insertions(+), 18 deletions(-)<br>
&gt;<br>
&gt; diff --git a/multipathd/main.c b/multipathd/main.c<br>
&gt; index 58e8854..2c7486d 100644<br>
&gt; --- a/multipathd/main.c<br>
&gt; +++ b/multipathd/main.c<br>
&gt; @@ -580,6 +580,11 @@ uev_add_path (struct uevent *uev, struct vectors =
* vecs)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0pthread_cleanup_push(cleanup_lock, &amp;vecs=
-&gt;lock);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0lock(vecs-&gt;lock);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0pthread_testcancel();<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (filter_devnode(conf-&gt;blist_devnode, conf-&=
gt;elist_devnode,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 uev-&gt;kernel) &gt; 0) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D 0;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out_unlock;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0pp =3D find_path_by_dev(vecs-&gt;pathvec, ue=
v-&gt;kernel);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (pp) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int r;<br>
&gt; @@ -637,6 +642,7 @@ uev_add_path (struct uevent *uev, struct vectors *=
 vecs)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0free_path(pp);<b=
r>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D 1;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; +out_unlock:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0lock_cleanup_pop(vecs-&gt;lock);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0return ret;<br>
&gt;=C2=A0 }<br>
&gt; @@ -780,22 +786,23 @@ fail:<br>
&gt;=C2=A0 static int<br>
&gt;=C2=A0 uev_remove_path (struct uevent *uev, struct vectors * vecs)<br>
&gt;=C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0struct path *pp;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0int ret;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct path *pp =3D NULL;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0int ret =3D 0;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(2, &quot;%s: remove path (uevent)&qu=
ot;, uev-&gt;kernel);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0pthread_cleanup_push(cleanup_lock, &amp;vecs=
-&gt;lock);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0lock(vecs-&gt;lock);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0pthread_testcancel();<br>
&gt; -=C2=A0 =C2=A0 =C2=A0pp =3D find_path_by_dev(vecs-&gt;pathvec, uev-&gt=
;kernel);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0if (pp)<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D ev_remove_pat=
h(pp, vecs);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0lock_cleanup_pop(vecs-&gt;lock);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0if (!pp) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Not an error; path=
 might have been purged earlier */<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(0, &quot;%s: =
path already removed&quot;, uev-&gt;kernel);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (filter_devnode(conf-&gt;blist_devnode, conf-&=
gt;elist_devnode,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 uev-&gt;kernel) =3D=3D 0) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pp =3D find_path_by_d=
ev(vecs-&gt;pathvec, uev-&gt;kernel);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (pp)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0ret =3D ev_remove_path(pp, vecs);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0else<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0/* Not an error; path might have been purged earlier */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0condlog(0, &quot;%s: path already removed&quot;, uev-&gt;kernel);<br=
>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; +=C2=A0 =C2=A0 =C2=A0lock_cleanup_pop(vecs-&gt;lock);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0return ret;<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt; @@ -905,7 +912,7 @@ uev_update_path (struct uevent *uev, struct vector=
s * vecs)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0ro =3D uevent_get_disk_ro(uev);<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (ro &gt;=3D 0) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct path * pp;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct path * pp =3D =
NULL;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct multipath=
 *mpp =3D NULL;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(2, &quot=
;%s: update path write_protect to &#39;%d&#39; (uevent)&quot;,<br>
&gt; @@ -918,6 +925,10 @@ uev_update_path (struct uevent *uev, struct vecto=
rs * vecs)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * need to be at=
 the same indentation level, hence<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * this slightly=
 convoluted codepath.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (filter_devnode(co=
nf-&gt;blist_devnode, conf-&gt;elist_devnode,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 uev-&gt;kernel) &gt; 0) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0goto out_unlock;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pp =3D find_path=
_by_dev(vecs-&gt;pathvec, uev-&gt;kernel);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (pp) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0if (pp-&gt;initialized =3D=3D INIT_REQUESTED_UDEV) {<br>
&gt; @@ -937,11 +948,13 @@ uev_update_path (struct uevent *uev, struct vect=
ors * vecs)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0uev-&g=
t;kernel, mpp-&gt;alias, retval);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; +=C2=A0 =C2=A0 =C2=A0out_unlock:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0lock_cleanup_pop=
(vecs-&gt;lock);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!pp) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0condlog(0, &quot;%s: spurious uevent, path not found&quot;,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0uev-&gt;kernel);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0return 1;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0if (retval)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(0, &quot;%s: spurious uevent, pa=
th not found&quot;,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0uev-&gt;kern=
el);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0return retval;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (retval =3D=
=3D 2)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0return uev_add_path(uev, vecs);<br>
&gt; @@ -1059,10 +1072,6 @@ uev_trigger (struct uevent * uev, void * trigge=
r_data)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 * path add/remove event<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
&gt; -=C2=A0 =C2=A0 =C2=A0if (filter_devnode(conf-&gt;blist_devnode, conf-&=
gt;elist_devnode,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 uev-&gt;kernel) &gt; 0)<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;<br>
&gt; -<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!strncmp(uev-&gt;action, &quot;add&quot;=
, 3)) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0r =3D uev_add_pa=
th(uev, vecs);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;<br>
&gt; --<br>
&gt; 2.6.6<br>
</div></div></blockquote></div><br></div>

--001a11411da0f366c50532947b4b--


--===============6157541445626531926==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6157541445626531926==--
