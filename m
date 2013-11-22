From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 13/13] multipathd: no_map_shutdown option
Date: Fri, 22 Nov 2013 10:12:36 +0100
Message-ID: <528F2004.2050101@suse.de>
References: <1384511384-27642-1-git-send-email-hare@suse.de>	<1384511384-27642-14-git-send-email-hare@suse.de>
	<20131121231710.GL1661@dhcp80-209.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20131121231710.GL1661@dhcp80-209.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On 11/22/2013 12:17 AM, Benjamin Marzinski wrote:
> I don't understand this option?  When I played around with it, it seems
> like it only causes problems.  For instance.  If I remove all the
> multipath devices with "multipath -F", then multipathd stops.
> Incidentally, this pisses off the watchdog timer.
> =

> This pops up in /var/log/messages
> =

> Nov 21 11:04:05 ask-08 systemd[1]: multipathd.service watchdog timeout!
> Nov 21 11:04:05 ask-08 systemd[1]: Unit multipathd.service entered
> failed state
> =

> and checking the status shows the service as failed.
> =

> # service multipathd status
> multipathd.service - Device-Mapper Multipath Device Controller
>    Loaded: loaded (/usr/lib/systemd/system/multipathd.service; enabled)
>    Active: failed (Result: watchdog) since Thu 2013-11-21 11:04:00 CST; 3=
min 25s ago
>   Process: 22687 ExecStart=3D/sbin/multipathd -d -s -n (code=3Dexited, st=
atus=3D0/SUCCESS)
>    Status: "shutdown"
> =

Yeah, because I forgot to set the exit status via sd_notify.
I'll be updating a patchset to include that.

> But the bigger issue is that multipathd is now stopped, and running
> "multipath" doesn't bring it back again.

Ah. Yes, you are absolutely right, of course.
I've forgot about this.

> You will create the multipath
> devices, but nothing will be monitoring them.  The same thing happens if
> the multipathd service is started before the any multipathable devices
> are discovered.  It starts up and then shuts back down (again tripping
> the watchdog timer). When those devices finally get discovered, there is
> nothing to listening for the uevents, so no multipath devices ever get
> created.
> =

> I must be missing something here.
> =

No, it's actually true what you've said.
Multipathd can only listen to events if it's started.
But that's precisely what systemd is for, right?
Starting a service when something is written onto a socket?
Guess it need some more work here.

But I could finally do my long-term project of merging
multipath and multipathd to share the same codebase, with
multipath just using the multipathd CLI and having no logic
on it's own.

But in the light of this, this patch is indeed not working
as designed, and should not be applied as of now.

Which doesn't affect the other parts in the series, which
_definitely_ should be applied.
Christophe, how to proceed?

Do you need a new patchset with the last patch removed,
or are you fine with the current one and just not applying
the last patch?

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
