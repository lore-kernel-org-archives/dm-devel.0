From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] mpathpersistent: segment faulty occured in
	mpath_persistent_reserve_in()
Date: Fri, 4 Nov 2016 17:35:54 +0100
Message-ID: <CABr-GncjKSERWv8yOJOXxhxFCWUabKb_zumWuWDuUYBnPLbnuA@mail.gmail.com>
References: <1477558528-9416-1-git-send-email-tang.wenji@zte.com.cn>
	<20161104162314.GG1972@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4872576043409621387=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161104162314.GG1972@octiron.msp.redhat.com>
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
Cc: zhang.kai16@zte.com.cn, device-mapper development <dm-devel@redhat.com>, christophe varoqui <christophe.varoqui@free.fr>, tang.junhui@zte.com.cn, tang.wenji@zte.com.cn
List-Id: dm-devel.ids

--===============4872576043409621387==
Content-Type: multipart/alternative; boundary=001a113d9724a7b51d05407c4411

--001a113d9724a7b51d05407c4411
Content-Type: text/plain; charset=UTF-8

Tang,

would you rebase this patch over upstream master please ?

Bart's commit 6e89fd1ec49da86555558acd63f05a4b4152a5c8 already moved the
conf pointer declaration.

Thanks,
Christophe.


On Fri, Nov 4, 2016 at 5:23 PM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> On Thu, Oct 27, 2016 at 04:55:28PM +0800, tang.wenji@zte.com.cn wrote:
>
> ACK
>
> -Ben
>
> > From: 10111224 <tang.wenji@zte.com.cn>
> >
> > Segment faulty occured when executing "mpathpersist -i -k
> > /dev/mapper/mpath1" command.The reason is that an uninitialized global
> variable conf is used in mpath_persistent_reserve_in(). The same problem
> also exists in
> > mpath_persistent_reserve_out().
> >
> > Signed-off-by: tang.wenji <tang.wenji@zte.com.cn>
> > ---
> >  libmpathpersist/mpath_persist.c | 21 +++++++++++++++++++--
> >  libmpathpersist/mpathpr.h       |  4 ----
> >  2 files changed, 19 insertions(+), 6 deletions(-)
> >
> > diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_
> persist.c
> > index 7501651..582d4ef 100644
> > --- a/libmpathpersist/mpath_persist.c
> > +++ b/libmpathpersist/mpath_persist.c
> > @@ -78,6 +78,7 @@ updatepaths (struct multipath * mpp)
> >       int i, j;
> >       struct pathgroup * pgp;
> >       struct path * pp;
> > +     struct config *conf;
> >
> >       if (!mpp->pg)
> >               return 0;
> > @@ -97,16 +98,24 @@ updatepaths (struct multipath * mpp)
> >                                       continue;
> >                               }
> >                               pp->mpp = mpp;
> > +                             conf = get_multipath_config();
> >                               pathinfo(pp, conf, DI_ALL);
> > +                             put_multipath_config(conf);
> >                               continue;
> >                       }
> >                       pp->mpp = mpp;
> >                       if (pp->state == PATH_UNCHECKED ||
> > -                                     pp->state == PATH_WILD)
> > +                                     pp->state == PATH_WILD){
> > +                             conf = get_multipath_config();
> >                               pathinfo(pp, conf, DI_CHECKER);
> > +                             put_multipath_config(conf);
> > +                     }
> >
> > -                     if (pp->priority == PRIO_UNDEF)
> > +                     if (pp->priority == PRIO_UNDEF){
> > +                             conf = get_multipath_config();
> >                               pathinfo(pp, conf, DI_PRIO);
> > +                             put_multipath_config(conf);
> > +                     }
> >               }
> >       }
> >       return 0;
> > @@ -159,8 +168,11 @@ int mpath_persistent_reserve_in (int fd, int
> rq_servact,
> >       int map_present;
> >       int major, minor;
> >       int ret;
> > +     struct config *conf;
> >
> > +     conf = get_multipath_config();
> >       conf->verbosity = verbose;
> > +     put_multipath_config( conf);
> >
> >       if (fstat( fd, &info) != 0){
> >               condlog(0, "stat error %d", fd);
> > @@ -252,8 +264,11 @@ int mpath_persistent_reserve_out ( int fd, int
> rq_servact, int rq_scope,
> >       int j;
> >       unsigned char *keyp;
> >       uint64_t prkey;
> > +     struct config *conf;
> >
> > +     conf = get_multipath_config();
> >       conf->verbosity = verbose;
> > +     put_multipath_config(conf);
> >
> >       if (fstat( fd, &info) != 0){
> >               condlog(0, "stat error fd=%d", fd);
> > @@ -320,7 +335,9 @@ int mpath_persistent_reserve_out ( int fd, int
> rq_servact, int rq_scope,
> >               goto out1;
> >       }
> >
> > +     conf = get_multipath_config();
> >       select_reservation_key(conf, mpp);
> > +     put_multipath_config(conf);
> >
> >       switch(rq_servact)
> >       {
> > diff --git a/libmpathpersist/mpathpr.h b/libmpathpersist/mpathpr.h
> > index cd58201..e6c2ded 100644
> > --- a/libmpathpersist/mpathpr.h
> > +++ b/libmpathpersist/mpathpr.h
> > @@ -25,10 +25,6 @@ struct threadinfo {
> >       struct prout_param param;
> >  };
> >
> > -
> > -struct config * conf;
> > -
> > -
> >  int prin_do_scsi_ioctl(char * dev, int rq_servact, struct prin_resp *
> resp, int noisy);
> >  int prout_do_scsi_ioctl( char * dev, int rq_servact, int rq_scope,
> >               unsigned int rq_type, struct prout_param_descriptor
> *paramp, int noisy);
> > --
> > 2.8.1.windows.1
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

--001a113d9724a7b51d05407c4411
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Tang,<div><br></div><div>would you rebase this patch over =
upstream master please ?</div><div><br></div><div>Bart&#39;s commit=C2=A06e=
89fd1ec49da86555558acd63f05a4b4152a5c8 already moved the conf pointer decla=
ration.</div><div><br></div><div>Thanks,</div><div>Christophe.</div><div><b=
r></div></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On =
Fri, Nov 4, 2016 at 5:23 PM, Benjamin Marzinski <span dir=3D"ltr">&lt;<a hr=
ef=3D"mailto:bmarzins@redhat.com" target=3D"_blank">bmarzins@redhat.com</a>=
&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0=
 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">On Thu, Oct 27, 2016 a=
t 04:55:28PM +0800, <a href=3D"mailto:tang.wenji@zte.com.cn">tang.wenji@zte=
.com.cn</a> wrote:<br>
<br>
ACK<br>
<br>
-Ben<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
&gt; From: 10111224 &lt;<a href=3D"mailto:tang.wenji@zte.com.cn">tang.wenji=
@zte.com.cn</a>&gt;<br>
&gt;<br>
&gt; Segment faulty occured when executing &quot;mpathpersist -i -k<br>
&gt; /dev/mapper/mpath1&quot; command.The reason is that an uninitialized g=
lobal variable conf is used in mpath_persistent_reserve_in(). The same prob=
lem also exists in<br>
&gt; mpath_persistent_reserve_out()<wbr>.<br>
&gt;<br>
&gt; Signed-off-by: tang.wenji &lt;<a href=3D"mailto:tang.wenji@zte.com.cn"=
>tang.wenji@zte.com.cn</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 libmpathpersist/mpath_persist.<wbr>c | 21 +++++++++++++++++++--<=
br>
&gt;=C2=A0 libmpathpersist/mpathpr.h=C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 4 --=
--<br>
&gt;=C2=A0 2 files changed, 19 insertions(+), 6 deletions(-)<br>
&gt;<br>
&gt; diff --git a/libmpathpersist/mpath_<wbr>persist.c b/libmpathpersist/mp=
ath_<wbr>persist.c<br>
&gt; index 7501651..582d4ef 100644<br>
&gt; --- a/libmpathpersist/mpath_<wbr>persist.c<br>
&gt; +++ b/libmpathpersist/mpath_<wbr>persist.c<br>
&gt; @@ -78,6 +78,7 @@ updatepaths (struct multipath * mpp)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int i, j;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct pathgroup * pgp;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct path * pp;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct config *conf;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!mpp-&gt;pg)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt; @@ -97,16 +98,24 @@ updatepaths (struct multipath * mpp)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0contin=
ue;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pp-&gt;mpp =3D mpp;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0conf =3D get_multipath_config();<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pathinfo(pp, conf, DI_ALL);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0put_multipath_config(conf);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0continue;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0pp-&gt;mpp =3D mpp;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0if (pp-&gt;state =3D=3D PATH_UNCHECKED ||<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pp-&gt;state=
 =3D=3D PATH_WILD)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pp-&gt;state=
 =3D=3D PATH_WILD){<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0conf =3D get_multipath_config();<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pathinfo(pp, conf, DI_CHECKER);<br=
>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0put_multipath_config(conf);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0}<br>
&gt;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0if (pp-&gt;priority =3D=3D PRIO_UNDEF)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0if (pp-&gt;priority =3D=3D PRIO_UNDEF){<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0conf =3D get_multipath_config();<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pathinfo(pp, conf, DI_PRIO);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0put_multipath_config(conf);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt; @@ -159,8 +168,11 @@ int mpath_persistent_reserve_in (int fd, int rq_s=
ervact,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int map_present;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int major, minor;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int ret;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct config *conf;<br>
&gt;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0conf =3D get_multipath_config();<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0conf-&gt;verbosity =3D verbose;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0put_multipath_config( conf);<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (fstat( fd, &amp;info) !=3D 0){<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(0, &quot=
;stat error %d&quot;, fd);<br>
&gt; @@ -252,8 +264,11 @@ int mpath_persistent_reserve_out ( int fd, int rq=
_servact, int rq_scope,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int j;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned char *keyp;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0uint64_t prkey;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct config *conf;<br>
&gt;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0conf =3D get_multipath_config();<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0conf-&gt;verbosity =3D verbose;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0put_multipath_config(conf);<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (fstat( fd, &amp;info) !=3D 0){<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(0, &quot=
;stat error fd=3D%d&quot;, fd);<br>
&gt; @@ -320,7 +335,9 @@ int mpath_persistent_reserve_out ( int fd, int rq_=
servact, int rq_scope,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out1;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0conf =3D get_multipath_config();<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0select_reservation_key(conf, mpp);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0put_multipath_config(conf);<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0switch(rq_servact)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0{<br>
&gt; diff --git a/libmpathpersist/mpathpr.h b/libmpathpersist/mpathpr.h<br>
&gt; index cd58201..e6c2ded 100644<br>
&gt; --- a/libmpathpersist/mpathpr.h<br>
&gt; +++ b/libmpathpersist/mpathpr.h<br>
&gt; @@ -25,10 +25,6 @@ struct threadinfo {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct prout_param param;<br>
&gt;=C2=A0 };<br>
&gt;<br>
&gt; -<br>
&gt; -struct config * conf;<br>
&gt; -<br>
&gt; -<br>
&gt;=C2=A0 int prin_do_scsi_ioctl(char * dev, int rq_servact, struct prin_r=
esp * resp, int noisy);<br>
&gt;=C2=A0 int prout_do_scsi_ioctl( char * dev, int rq_servact, int rq_scop=
e,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int rq_=
type, struct prout_param_descriptor *paramp, int noisy);<br>
&gt; --<br>
&gt; 2.8.1.windows.1<br>
&gt;<br>
&gt; --<br>
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
</div></div></blockquote></div><br></div>

--001a113d9724a7b51d05407c4411--


--===============4872576043409621387==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4872576043409621387==--
