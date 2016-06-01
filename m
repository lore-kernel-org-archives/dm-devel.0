From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: multipath-tools: irrelevant files
Date: Wed, 1 Jun 2016 17:05:21 +0200
Message-ID: <CABr-GnfM-U2NRoiznhUDgmZJKrE5_gzQQaRk0trJOZxjs+eaRQ@mail.gmail.com>
References: <CAE+k_g+Eh3H1EAiJ0jm7P-efGbOOwpWRtYmvXyR9qhhHtefV7g@mail.gmail.com>
	<571DF852.6030604@redhat.com>
	<CAE+k_gKQcx+QR9bfEp1Wy8BawD14L2G5O0Yw-d0=CffBHqYbrA@mail.gmail.com>
	<571E0E7A.4050703@redhat.com>
	<CABr-GnfxOKz8gxDju20Hx3T9Tn74Zz9FhjF1dBk8weEBJMOmLg@mail.gmail.com>
	<1986ca6b-d281-4faf-2b50-11c3dc132463@gmail.com>
	<571F026C.5040102@suse.de>
	<20160427224601.GG26117@octiron.msp.redhat.com>
	<d0c31716-4350-4b97-90e3-caf238cc687b@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7993392951212017678=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <d0c31716-4350-4b97-90e3-caf238cc687b@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============7993392951212017678==
Content-Type: multipart/alternative; boundary=001a1142100a82da79053438d159

--001a1142100a82da79053438d159
Content-Type: text/plain; charset=UTF-8

Hi Xose,

this 4-patch patchset to janitor the project header files is now merged,
and more files deleted (specfile template and suse example sysv init
script).

Do you care if I don't publish tarballs anymore ? I'd rather deprecate this
http://christophe.varoqui.free.fr/  website usage. The gitweb at
git.opensvc.com offers the tarball extraction from version tags, for people
who don't want to clone the git project.

Best regards,
Christophe Varoqui
OpenSVC

On Thu, May 19, 2016 at 5:24 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> On 04/28/2016 12:46 AM, Benjamin Marzinski wrote:
>
> > On Tue, Apr 26, 2016 at 07:53:48AM +0200, Hannes Reinecke wrote:
> >> On 04/25/2016 10:14 PM, Xose Vazquez Perez wrote:
> >>> Btw, are these relevant ?
> >
> > For all that I didn't comment on, I feel the same way as Hannes.
> >
> >>> getuid/usb_id
> >> Huh? What is that doing there?
> >> It should really have been moved to the udev package ...
> >>
> >>> kpartx/kpartx_id
> >>> kpartx/kpartx.rules
> >> See above. Yes, they are relevant (at least for us)
> >
> > Like I said, Red Hat doesn't use them. I'll post our multipath.rules
> > shortly.
> >
> >>> multipath/01_udev
> >>> multipath/02_multipath
> >> Not used anymore with systemd/dracut
> >>
> >>> multipath/11-dm-mpath.rules
> >> Yep. Absolutely required.
> >>
> >>> multipath.conf.annotated
> >>> multipath.conf.defaults
> >>> multipath.conf.synthetic
> >> Actually, I never saw the need for those.
> >> Can we at least have them merged?
> >
> > I don't think they are being kept up to date anymore.  The 'defaults'
> > information can be gotten from a running system, and it includes the
> > changes from the config files, so it's much more useful. I have no idea
> > what people would use 'synthetic' for besides an example of what a
> > config would look like. And the 'annotated' information is all in the
> > multipath.conf manpage. Red Hat doesn't ship these files anymore. I'd be
> > happy to see them go.
> >
> >>> multipathd/multipathd.init.debian
> >>> multipathd/multipathd.init.redhat
> >>> multipathd/multipathd.init.suse
> >> Old init scripts; doubtful value.
> >>
> >>> multipathd/multipathd.service
> >>> multipathd/multipathd.socket
> >> systemd service definitions. Yes, required.
> >
> > Red Hat has a slightly different multipathd.service file, and we don't
> > ship the socket file.  Since multipathd should always be running, I
> > don't really see the need. Also, if you start multipathd manually
> > (instead of through udev) this causes problems with multipathd not
> > getting messages.
> >
> > For those interested, here's a diff of our multipath.service
> >
> > diff --git a/multipathd/multipathd.service
> > b/multipathd/multipathd.service
> > index d5f8606..1e5dfab 100644
> > --- a/multipathd/multipathd.service
> > +++ b/multipathd/multipathd.service
> > @@ -2,9 +2,10 @@
> >  Description=Device-Mapper Multipath Device Controller
> >  Before=iscsi.service iscsid.service lvm2-activation-early.service
> >  Before=local-fs-pre.target
> > -After=multipathd.socket
> > +ConditionPathExists=/etc/multipath.conf
> > +ConditionKernelCommandLine=!nompath
> >  DefaultDependencies=no
> > -Wants=local-fs-pre.target multipathd.socket blk-availability.service
> > +Wants=local-fs-pre.target blk-availability.service
> >  Conflicts=shutdown.target
> >
> >  [Service]
> > @@ -12,9 +13,9 @@ Type=notify
> >  NotifyAccess=main
> >  LimitCORE=infinity
> >  ExecStartPre=/sbin/modprobe dm-multipath
> > +ExecStartPre=-/sbin/multipath -A
> >  ExecStart=/sbin/multipathd -d -s
> >  ExecReload=/sbin/multipathd reconfigure
> >
> >  [Install]
> >  WantedBy=sysinit.target
> > -Also=multipathd.socket
> >
> >
> > Aside from dropping the socket, it checks that /etc/multipath.conf
> > exists, and that the kernel wasn't started with "nompath". Also it runs
> > "multipath -A" this reads the kernel commandline from /proc/cmdline, and
> > adds any wwids listed as part of any mpath.wwid=<wwid> parameters.
> > Hannes NACKed this patch, so the option isn't present upsteam.
> >
> >
> >>> multipath/multipath.init.suse
> >> Old init script; not used anymore.
> >>
> >>> multipath/multipath.rules
> >> Yep. used for udev.
> >>
> >>> multipath-tools.spec.in
> >>>
> >> Well; due to our buildservice we have to keep a separate spec file
> >> anyway. So ATM we don't use it.
>
> Hi Christophe, more files could be deleted as Benjamin and
> Hannes have suggested in this thread.
>
> I sent also four patches last month, and they're still pending:
> https://www.redhat.com/archives/dm-devel/2016-April/thread.html#00453
>
>
> BTW, there are not new tar files at http://christophe.varoqui.free.fr/ ,
> latest is 0.5.0
>
> -thanks-
>

--001a1142100a82da79053438d159
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Xose,<div><br></div><div>this 4-patch patchset to janit=
or the project header files is now merged, and more files deleted (specfile=
 template and suse example sysv init script).</div><div><br></div><div>Do y=
ou care if I don&#39;t publish tarballs anymore ? I&#39;d rather deprecate =
this=C2=A0<a href=3D"http://christophe.varoqui.free.fr/" rel=3D"noreferrer"=
 target=3D"_blank" style=3D"font-size:19.2px">http://christophe.varoqui.fre=
e.fr/</a><span style=3D"font-size:19.2px">=C2=A0</span>=C2=A0website usage.=
 The gitweb at <a href=3D"http://git.opensvc.com">git.opensvc.com</a> offer=
s the tarball extraction from version tags, for people who don&#39;t want t=
o clone the git project.</div><div><br></div><div>Best regards,</div><div>C=
hristophe Varoqui</div><div>OpenSVC</div></div><div class=3D"gmail_extra"><=
br><div class=3D"gmail_quote">On Thu, May 19, 2016 at 5:24 PM, Xose Vazquez=
 Perez <span dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" targ=
et=3D"_blank">xose.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote c=
lass=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;=
padding-left:1ex">On 04/28/2016 12:46 AM, Benjamin Marzinski wrote:<br>
<br>
&gt; On Tue, Apr 26, 2016 at 07:53:48AM +0200, Hannes Reinecke wrote:<br>
&gt;&gt; On 04/25/2016 10:14 PM, Xose Vazquez Perez wrote:<br>
&gt;&gt;&gt; Btw, are these relevant ?<br>
&gt;<br>
&gt; For all that I didn&#39;t comment on, I feel the same way as Hannes.<b=
r>
&gt;<br>
&gt;&gt;&gt; getuid/usb_id<br>
&gt;&gt; Huh? What is that doing there?<br>
&gt;&gt; It should really have been moved to the udev package ...<br>
&gt;&gt;<br>
&gt;&gt;&gt; kpartx/kpartx_id<br>
&gt;&gt;&gt; kpartx/kpartx.rules<br>
&gt;&gt; See above. Yes, they are relevant (at least for us)<br>
&gt;<br>
&gt; Like I said, Red Hat doesn&#39;t use them. I&#39;ll post our multipath=
.rules<br>
&gt; shortly.<br>
&gt;<br>
&gt;&gt;&gt; multipath/01_udev<br>
&gt;&gt;&gt; multipath/02_multipath<br>
&gt;&gt; Not used anymore with systemd/dracut<br>
&gt;&gt;<br>
&gt;&gt;&gt; multipath/11-dm-mpath.rules<br>
&gt;&gt; Yep. Absolutely required.<br>
&gt;&gt;<br>
&gt;&gt;&gt; multipath.conf.annotated<br>
&gt;&gt;&gt; multipath.conf.defaults<br>
&gt;&gt;&gt; multipath.conf.synthetic<br>
&gt;&gt; Actually, I never saw the need for those.<br>
&gt;&gt; Can we at least have them merged?<br>
&gt;<br>
&gt; I don&#39;t think they are being kept up to date anymore.=C2=A0 The &#=
39;defaults&#39;<br>
&gt; information can be gotten from a running system, and it includes the<b=
r>
&gt; changes from the config files, so it&#39;s much more useful. I have no=
 idea<br>
&gt; what people would use &#39;synthetic&#39; for besides an example of wh=
at a<br>
&gt; config would look like. And the &#39;annotated&#39; information is all=
 in the<br>
&gt; multipath.conf manpage. Red Hat doesn&#39;t ship these files anymore. =
I&#39;d be<br>
&gt; happy to see them go.<br>
&gt;<br>
&gt;&gt;&gt; multipathd/multipathd.init.debian<br>
&gt;&gt;&gt; multipathd/multipathd.init.redhat<br>
&gt;&gt;&gt; multipathd/multipathd.init.suse<br>
&gt;&gt; Old init scripts; doubtful value.<br>
&gt;&gt;<br>
&gt;&gt;&gt; multipathd/multipathd.service<br>
&gt;&gt;&gt; multipathd/multipathd.socket<br>
&gt;&gt; systemd service definitions. Yes, required.<br>
&gt;<br>
&gt; Red Hat has a slightly different multipathd.service file, and we don&#=
39;t<br>
&gt; ship the socket file.=C2=A0 Since multipathd should always be running,=
 I<br>
&gt; don&#39;t really see the need. Also, if you start multipathd manually<=
br>
&gt; (instead of through udev) this causes problems with multipathd not<br>
&gt; getting messages.<br>
&gt;<br>
&gt; For those interested, here&#39;s a diff of our multipath.service<br>
&gt;<br>
&gt; diff --git a/multipathd/multipathd.service<br>
&gt; b/multipathd/multipathd.service<br>
&gt; index d5f8606..1e5dfab 100644<br>
&gt; --- a/multipathd/multipathd.service<br>
&gt; +++ b/multipathd/multipathd.service<br>
&gt; @@ -2,9 +2,10 @@<br>
&gt;=C2=A0 Description=3DDevice-Mapper Multipath Device Controller<br>
&gt;=C2=A0 Before=3Discsi.service iscsid.service lvm2-activation-early.serv=
ice<br>
&gt;=C2=A0 Before=3Dlocal-fs-pre.target<br>
&gt; -After=3Dmultipathd.socket<br>
&gt; +ConditionPathExists=3D/etc/multipath.conf<br>
&gt; +ConditionKernelCommandLine=3D!nompath<br>
&gt;=C2=A0 DefaultDependencies=3Dno<br>
&gt; -Wants=3Dlocal-fs-pre.target multipathd.socket blk-availability.servic=
e<br>
&gt; +Wants=3Dlocal-fs-pre.target blk-availability.service<br>
&gt;=C2=A0 Conflicts=3Dshutdown.target<br>
&gt;<br>
&gt;=C2=A0 [Service]<br>
&gt; @@ -12,9 +13,9 @@ Type=3Dnotify<br>
&gt;=C2=A0 NotifyAccess=3Dmain<br>
&gt;=C2=A0 LimitCORE=3Dinfinity<br>
&gt;=C2=A0 ExecStartPre=3D/sbin/modprobe dm-multipath<br>
&gt; +ExecStartPre=3D-/sbin/multipath -A<br>
&gt;=C2=A0 ExecStart=3D/sbin/multipathd -d -s<br>
&gt;=C2=A0 ExecReload=3D/sbin/multipathd reconfigure<br>
&gt;<br>
&gt;=C2=A0 [Install]<br>
&gt;=C2=A0 WantedBy=3Dsysinit.target<br>
&gt; -Also=3Dmultipathd.socket<br>
&gt;<br>
&gt;<br>
&gt; Aside from dropping the socket, it checks that /etc/multipath.conf<br>
&gt; exists, and that the kernel wasn&#39;t started with &quot;nompath&quot=
;. Also it runs<br>
&gt; &quot;multipath -A&quot; this reads the kernel commandline from /proc/=
cmdline, and<br>
&gt; adds any wwids listed as part of any mpath.wwid=3D&lt;wwid&gt; paramet=
ers.<br>
&gt; Hannes NACKed this patch, so the option isn&#39;t present upsteam.<br>
&gt;<br>
&gt;<br>
&gt;&gt;&gt; multipath/multipath.init.suse<br>
&gt;&gt; Old init script; not used anymore.<br>
&gt;&gt;<br>
&gt;&gt;&gt; multipath/multipath.rules<br>
&gt;&gt; Yep. used for udev.<br>
&gt;&gt;<br>
&gt;&gt;&gt; <a href=3D"http://multipath-tools.spec.in" rel=3D"noreferrer" =
target=3D"_blank">multipath-tools.spec.in</a><br>
&gt;&gt;&gt;<br>
&gt;&gt; Well; due to our buildservice we have to keep a separate spec file=
<br>
&gt;&gt; anyway. So ATM we don&#39;t use it.<br>
<br>
Hi Christophe, more files could be deleted as Benjamin and<br>
Hannes have suggested in this thread.<br>
<br>
I sent also four patches last month, and they&#39;re still pending:<br>
<a href=3D"https://www.redhat.com/archives/dm-devel/2016-April/thread.html#=
00453" rel=3D"noreferrer" target=3D"_blank">https://www.redhat.com/archives=
/dm-devel/2016-April/thread.html#00453</a><br>
<br>
<br>
BTW, there are not new tar files at <a href=3D"http://christophe.varoqui.fr=
ee.fr/" rel=3D"noreferrer" target=3D"_blank">http://christophe.varoqui.free=
.fr/</a> ,<br>
latest is 0.5.0<br>
<br>
-thanks-<br>
</blockquote></div><br></div>

--001a1142100a82da79053438d159--


--===============7993392951212017678==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7993392951212017678==--
