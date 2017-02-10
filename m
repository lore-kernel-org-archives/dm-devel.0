From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] Tolerate modprobe failures in
	multipathd.service
Date: Fri, 10 Feb 2017 15:40:32 +0100
Message-ID: <CABr-Gnc-hGEJQw0=W2uQFhj2GFmqVq_ZhV8r3O2skTwj2jfe-Q@mail.gmail.com>
References: <CACqULmOaE9MwhLmczZWCcFBPAHim5kYnBMCbgXNnYBUCQvjneQ@mail.gmail.com>
	<20170105153010.GN2732@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1458939682064971169=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170105153010.GN2732@octiron.msp.redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Anthony Ryan <anthonyryan1@gmail.com>
List-Id: dm-devel.ids

--===============1458939682064971169==
Content-Type: multipart/alternative; boundary=94eb2c1924d2814e2905482e1474

--94eb2c1924d2814e2905482e1474
Content-Type: text/plain; charset=UTF-8

Applied.
Thanks.

On Thu, Jan 5, 2017 at 4:30 PM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> On Thu, Jan 05, 2017 at 08:33:10AM -0500, Anthony Ryan wrote:
> > When these modules are built statically into the kernel, modprobe
> > will fail and prevent the service from being started. By making this
> > line non-fatal, on such systems the service is still able to be
> > started.
>
> ACK
>
> -Ben
>
> > ---
> >  multipathd/multipathd.service | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/multipathd/multipathd.service b/multipathd/multipathd.
> service
> > index e3d6f91..d26577f 100644
> > --- a/multipathd/multipathd.service
> > +++ b/multipathd/multipathd.service
> > @@ -11,7 +11,7 @@ Conflicts=shutdown.target
> >  Type=notify
> >  NotifyAccess=main
> >  LimitCORE=infinity
> > -ExecStartPre=/sbin/modprobe -a scsi_dh_alua scsi_dh_emc scsi_dh_rdac
> > dm-multipath
> > +ExecStartPre=-/sbin/modprobe -a scsi_dh_alua scsi_dh_emc scsi_dh_rdac
> > dm-multipath
> >  ExecStart=/sbin/multipathd -d -s
> >  ExecReload=/sbin/multipathd reconfigure
> >
> > --
> > 2.11.0
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

--94eb2c1924d2814e2905482e1474
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied.<div>Thanks.</div></div><div class=3D"gmail_extra"=
><br><div class=3D"gmail_quote">On Thu, Jan 5, 2017 at 4:30 PM, Benjamin Ma=
rzinski <span dir=3D"ltr">&lt;<a href=3D"mailto:bmarzins@redhat.com" target=
=3D"_blank">bmarzins@redhat.com</a>&gt;</span> wrote:<br><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex"><span class=3D"">On Thu, Jan 05, 2017 at 08:33:10AM -0500, An=
thony Ryan wrote:<br>
&gt; When these modules are built statically into the kernel, modprobe<br>
&gt; will fail and prevent the service from being started. By making this<b=
r>
&gt; line non-fatal, on such systems the service is still able to be<br>
&gt; started.<br>
<br>
</span>ACK<br>
<br>
-Ben<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
&gt; ---<br>
&gt;=C2=A0 multipathd/multipathd.service | 2 +-<br>
&gt;=C2=A0 1 file changed, 1 insertion(+), 1 deletion(-)<br>
&gt;<br>
&gt; diff --git a/multipathd/multipathd.<wbr>service b/multipathd/multipath=
d.<wbr>service<br>
&gt; index e3d6f91..d26577f 100644<br>
&gt; --- a/multipathd/multipathd.<wbr>service<br>
&gt; +++ b/multipathd/multipathd.<wbr>service<br>
&gt; @@ -11,7 +11,7 @@ Conflicts=3Dshutdown.target<br>
&gt;=C2=A0 Type=3Dnotify<br>
&gt;=C2=A0 NotifyAccess=3Dmain<br>
&gt;=C2=A0 LimitCORE=3Dinfinity<br>
&gt; -ExecStartPre=3D/sbin/modprobe -a scsi_dh_alua scsi_dh_emc scsi_dh_rda=
c<br>
&gt; dm-multipath<br>
&gt; +ExecStartPre=3D-/sbin/modprobe -a scsi_dh_alua scsi_dh_emc scsi_dh_rd=
ac<br>
&gt; dm-multipath<br>
&gt;=C2=A0 ExecStart=3D/sbin/multipathd -d -s<br>
&gt;=C2=A0 ExecReload=3D/sbin/multipathd reconfigure<br>
&gt;<br>
&gt; --<br>
&gt; 2.11.0<br>
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

--94eb2c1924d2814e2905482e1474--


--===============1458939682064971169==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1458939682064971169==--
