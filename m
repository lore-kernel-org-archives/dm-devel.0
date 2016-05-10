From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCHv2 0/7] multipathd 'cookie' handling rework
Date: Tue, 10 May 2016 08:15:51 +0200
Message-ID: <CABr-GnfFcFzzjbv5MvaO_0U-N0L=6G4KiMNQ=2GpBD+fSReSMQ@mail.gmail.com>
References: <1462791185-2903-1-git-send-email-hare@suse.de>
	<20160509180254.GB26117@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3135115601105844993=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160509180254.GB26117@octiron.msp.redhat.com>
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

--===============3135115601105844993==
Content-Type: multipart/alternative; boundary=001a11c243306546dd053276db22

--001a11c243306546dd053276db22
Content-Type: text/plain; charset=UTF-8

Merged.

multipath.conf.* are dropped.
the version code is bumped to 0.6.1

Thanks,
Christophe Varoqui
www.opensvc.com


On Mon, May 9, 2016 at 8:02 PM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> On Mon, May 09, 2016 at 12:52:58PM +0200, Hannes Reinecke wrote:
> > Hi all,
> >
> > here's now the second attempt to fixup the 'cookie' handling
> > in multipath-tools.
> > I've removed the patch to pass in a cookie as an argument
> > for dm_addmap_reload() and dm_simplecmd().
> > And I've removed all instances where we had been calling
> > dm_udev_complete() after failing to set the cookie to a task.
> >
> > As usual, reviews and comments are welcome.
>
> ACK for the whole set.
>
> Thanks for working through all this.
> -Ben
>
> >
> > Hannes Reinecke (7):
> >   devmapper: do not flush I/O for DM_DEVICE_CREATE
> >   devmapper: do not call dm_udev_complete if dm_task_set_cookie() failed
> >   configure: Rename ACT_RENAME2 to ACT_FORCERENAME
> >   devmapper: wait for udev in dm_simplecmd_noflush()
> >   multipathd: wait for udev in cli_resume()
> >   devmapper: remove 'udev_sync' argument from dm_simplecmd_noflush()
> >   libmultipath: Fixup 'DM_DEVICE_RELOAD' handling
> >
> >  libmultipath/configure.c  | 20 ++++---------
> >  libmultipath/configure.h  |  2 +-
> >  libmultipath/devmapper.c  | 75
> +++++++++++++++++++++++++++++++----------------
> >  libmultipath/devmapper.h  |  4 +--
> >  multipathd/cli_handlers.c |  4 +--
> >  5 files changed, 60 insertions(+), 45 deletions(-)
> >
> > --
> > 2.6.6
>

--001a11c243306546dd053276db22
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.<div><br></div><div>multipath.conf.* are dropped.</=
div><div>the version code is bumped to 0.6.1</div><div><br></div><div>Thank=
s,</div><div>Christophe Varoqui</div><div><a href=3D"http://www.opensvc.com=
">www.opensvc.com</a></div><div><br></div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Mon, May 9, 2016 at 8:02 PM, Benjamin Mar=
zinski <span dir=3D"ltr">&lt;<a href=3D"mailto:bmarzins@redhat.com" target=
=3D"_blank">bmarzins@redhat.com</a>&gt;</span> wrote:<br><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex"><span class=3D"">On Mon, May 09, 2016 at 12:52:58PM +0200, Ha=
nnes Reinecke wrote:<br>
&gt; Hi all,<br>
&gt;<br>
&gt; here&#39;s now the second attempt to fixup the &#39;cookie&#39; handli=
ng<br>
&gt; in multipath-tools.<br>
&gt; I&#39;ve removed the patch to pass in a cookie as an argument<br>
&gt; for dm_addmap_reload() and dm_simplecmd().<br>
&gt; And I&#39;ve removed all instances where we had been calling<br>
&gt; dm_udev_complete() after failing to set the cookie to a task.<br>
&gt;<br>
&gt; As usual, reviews and comments are welcome.<br>
<br>
</span>ACK for the whole set.<br>
<br>
Thanks for working through all this.<br>
-Ben<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
&gt;<br>
&gt; Hannes Reinecke (7):<br>
&gt;=C2=A0 =C2=A0devmapper: do not flush I/O for DM_DEVICE_CREATE<br>
&gt;=C2=A0 =C2=A0devmapper: do not call dm_udev_complete if dm_task_set_coo=
kie() failed<br>
&gt;=C2=A0 =C2=A0configure: Rename ACT_RENAME2 to ACT_FORCERENAME<br>
&gt;=C2=A0 =C2=A0devmapper: wait for udev in dm_simplecmd_noflush()<br>
&gt;=C2=A0 =C2=A0multipathd: wait for udev in cli_resume()<br>
&gt;=C2=A0 =C2=A0devmapper: remove &#39;udev_sync&#39; argument from dm_sim=
plecmd_noflush()<br>
&gt;=C2=A0 =C2=A0libmultipath: Fixup &#39;DM_DEVICE_RELOAD&#39; handling<br=
>
&gt;<br>
&gt;=C2=A0 libmultipath/configure.c=C2=A0 | 20 ++++---------<br>
&gt;=C2=A0 libmultipath/configure.h=C2=A0 |=C2=A0 2 +-<br>
&gt;=C2=A0 libmultipath/devmapper.c=C2=A0 | 75 ++++++++++++++++++++++++++++=
+++----------------<br>
&gt;=C2=A0 libmultipath/devmapper.h=C2=A0 |=C2=A0 4 +--<br>
&gt;=C2=A0 multipathd/cli_handlers.c |=C2=A0 4 +--<br>
&gt;=C2=A0 5 files changed, 60 insertions(+), 45 deletions(-)<br>
&gt;<br>
&gt; --<br>
&gt; 2.6.6<br>
</div></div></blockquote></div><br></div>

--001a11c243306546dd053276db22--


--===============3135115601105844993==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3135115601105844993==--
