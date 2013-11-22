From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 13/13] multipathd: no_map_shutdown option
Date: Fri, 22 Nov 2013 10:30:22 +0100
Message-ID: <CABr-GncbrpsL5VLvHh+V0e714KguJrJEuRGfihrcq+1Wbs568w@mail.gmail.com>
References: <1384511384-27642-1-git-send-email-hare@suse.de>
	<1384511384-27642-14-git-send-email-hare@suse.de>
	<20131121231710.GL1661@dhcp80-209.msp.redhat.com>
	<528F2004.2050101@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2828067908434334231=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <528F2004.2050101@suse.de>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============2828067908434334231==
Content-Type: multipart/alternative; boundary=047d7bd76fe0d3e2c904ebc0a907

--047d7bd76fe0d3e2c904ebc0a907
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

To my knowledge, systemd has not been integrated in all distributions.
It would be nice not to break the build of multipath-tools on those
environments.

The current patchset breaks the build on non-systemd systems as soon as
patch 06/13.
I can apply the patchset from 01/13 to 05/13 included, and let you refactor
the systemd integration proper in a new series.

Is that ok with you ?

Best regards,
Christophe Varoqui
www.opensvc.com



On Fri, Nov 22, 2013 at 10:12 AM, Hannes Reinecke <hare@suse.de> wrote:

> On 11/22/2013 12:17 AM, Benjamin Marzinski wrote:
> > I don't understand this option?  When I played around with it, it seems
> > like it only causes problems.  For instance.  If I remove all the
> > multipath devices with "multipath -F", then multipathd stops.
> > Incidentally, this pisses off the watchdog timer.
> >
> > This pops up in /var/log/messages
> >
> > Nov 21 11:04:05 ask-08 systemd[1]: multipathd.service watchdog timeout!
> > Nov 21 11:04:05 ask-08 systemd[1]: Unit multipathd.service entered
> > failed state
> >
> > and checking the status shows the service as failed.
> >
> > # service multipathd status
> > multipathd.service - Device-Mapper Multipath Device Controller
> >    Loaded: loaded (/usr/lib/systemd/system/multipathd.service; enabled)
> >    Active: failed (Result: watchdog) since Thu 2013-11-21 11:04:00 CST;
> 3min 25s ago
> >   Process: 22687 ExecStart=3D/sbin/multipathd -d -s -n (code=3Dexited,
> status=3D0/SUCCESS)
> >    Status: "shutdown"
> >
> Yeah, because I forgot to set the exit status via sd_notify.
> I'll be updating a patchset to include that.
>
> > But the bigger issue is that multipathd is now stopped, and running
> > "multipath" doesn't bring it back again.
>
> Ah. Yes, you are absolutely right, of course.
> I've forgot about this.
>
> > You will create the multipath
> > devices, but nothing will be monitoring them.  The same thing happens i=
f
> > the multipathd service is started before the any multipathable devices
> > are discovered.  It starts up and then shuts back down (again tripping
> > the watchdog timer). When those devices finally get discovered, there i=
s
> > nothing to listening for the uevents, so no multipath devices ever get
> > created.
> >
> > I must be missing something here.
> >
> No, it's actually true what you've said.
> Multipathd can only listen to events if it's started.
> But that's precisely what systemd is for, right?
> Starting a service when something is written onto a socket?
> Guess it need some more work here.
>
> But I could finally do my long-term project of merging
> multipath and multipathd to share the same codebase, with
> multipath just using the multipathd CLI and having no logic
> on it's own.
>
> But in the light of this, this patch is indeed not working
> as designed, and should not be applied as of now.
>
> Which doesn't affect the other parts in the series, which
> _definitely_ should be applied.
> Christophe, how to proceed?
>
> Do you need a new patchset with the last patch removed,
> or are you fine with the current one and just not applying
> the last patch?
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                   zSeries & Storage
> hare@suse.de                          +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
>

--047d7bd76fe0d3e2c904ebc0a907
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<div><br></div><div>To my knowledge, systemd has not be=
en integrated in all distributions.</div><div>It would be nice not to break=
 the build of multipath-tools on those environments.</div><div><br></div><d=
iv>
The current patchset breaks the build on non-systemd systems as soon as pat=
ch 06/13.</div><div>I can apply the patchset from 01/13 to 05/13 included, =
and let you refactor the systemd integration proper in a new series.</div>
<div><br></div><div>Is that ok with you ?</div><div><br></div><div>Best reg=
ards,<br></div><div>Christophe Varoqui</div><div><a href=3D"http://www.open=
svc.com">www.opensvc.com</a></div><div><br></div></div><div class=3D"gmail_=
extra">
<br><br><div class=3D"gmail_quote">On Fri, Nov 22, 2013 at 10:12 AM, Hannes=
 Reinecke <span dir=3D"ltr">&lt;<a href=3D"mailto:hare@suse.de" target=3D"_=
blank">hare@suse.de</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quo=
te" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"=
>
<div class=3D"im">On 11/22/2013 12:17 AM, Benjamin Marzinski wrote:<br>
&gt; I don&#39;t understand this option? =A0When I played around with it, i=
t seems<br>
&gt; like it only causes problems. =A0For instance. =A0If I remove all the<=
br>
&gt; multipath devices with &quot;multipath -F&quot;, then multipathd stops=
.<br>
&gt; Incidentally, this pisses off the watchdog timer.<br>
&gt;<br>
&gt; This pops up in /var/log/messages<br>
&gt;<br>
&gt; Nov 21 11:04:05 ask-08 systemd[1]: multipathd.service watchdog timeout=
!<br>
&gt; Nov 21 11:04:05 ask-08 systemd[1]: Unit multipathd.service entered<br>
&gt; failed state<br>
&gt;<br>
&gt; and checking the status shows the service as failed.<br>
&gt;<br>
&gt; # service multipathd status<br>
&gt; multipathd.service - Device-Mapper Multipath Device Controller<br>
&gt; =A0 =A0Loaded: loaded (/usr/lib/systemd/system/multipathd.service; ena=
bled)<br>
&gt; =A0 =A0Active: failed (Result: watchdog) since Thu 2013-11-21 11:04:00=
 CST; 3min 25s ago<br>
&gt; =A0 Process: 22687 ExecStart=3D/sbin/multipathd -d -s -n (code=3Dexite=
d, status=3D0/SUCCESS)<br>
&gt; =A0 =A0Status: &quot;shutdown&quot;<br>
&gt;<br>
</div>Yeah, because I forgot to set the exit status via sd_notify.<br>
I&#39;ll be updating a patchset to include that.<br>
<div class=3D"im"><br>
&gt; But the bigger issue is that multipathd is now stopped, and running<br=
>
&gt; &quot;multipath&quot; doesn&#39;t bring it back again.<br>
<br>
</div>Ah. Yes, you are absolutely right, of course.<br>
I&#39;ve forgot about this.<br>
<div class=3D"im"><br>
&gt; You will create the multipath<br>
&gt; devices, but nothing will be monitoring them. =A0The same thing happen=
s if<br>
&gt; the multipathd service is started before the any multipathable devices=
<br>
&gt; are discovered. =A0It starts up and then shuts back down (again trippi=
ng<br>
&gt; the watchdog timer). When those devices finally get discovered, there =
is<br>
&gt; nothing to listening for the uevents, so no multipath devices ever get=
<br>
&gt; created.<br>
&gt;<br>
&gt; I must be missing something here.<br>
&gt;<br>
</div>No, it&#39;s actually true what you&#39;ve said.<br>
Multipathd can only listen to events if it&#39;s started.<br>
But that&#39;s precisely what systemd is for, right?<br>
Starting a service when something is written onto a socket?<br>
Guess it need some more work here.<br>
<br>
But I could finally do my long-term project of merging<br>
multipath and multipathd to share the same codebase, with<br>
multipath just using the multipathd CLI and having no logic<br>
on it&#39;s own.<br>
<br>
But in the light of this, this patch is indeed not working<br>
as designed, and should not be applied as of now.<br>
<br>
Which doesn&#39;t affect the other parts in the series, which<br>
_definitely_ should be applied.<br>
Christophe, how to proceed?<br>
<br>
Do you need a new patchset with the last patch removed,<br>
or are you fine with the current one and just not applying<br>
the last patch?<br>
<br>
Cheers,<br>
<br>
Hannes<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
Dr. Hannes Reinecke =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 zSeries &amp; Stora=
ge<br>
<a href=3D"mailto:hare@suse.de">hare@suse.de</a> =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0<a href=3D"tel:%2B49%20911%2074053%20688" value=
=3D"+4991174053688">+49 911 74053 688</a><br>
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg<br>
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)<br>
</font></span></blockquote></div><br></div>

--047d7bd76fe0d3e2c904ebc0a907--


--===============2828067908434334231==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2828067908434334231==--
