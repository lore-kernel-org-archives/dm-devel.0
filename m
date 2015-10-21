From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 09/18] Make multipath deactivate devices
 before iscsi shutdown
Date: Wed, 21 Oct 2015 17:29:24 -0500
Message-ID: <20151021222924.GY2872@octiron.msp.redhat.com>
References: <1444333491-16265-1-git-send-email-bmarzins@redhat.com>
	<1444333491-16265-10-git-send-email-bmarzins@redhat.com>
	<561B5BA3.5030501@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <561B5BA3.5030501@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Oct 12, 2015 at 09:05:07AM +0200, Hannes Reinecke wrote:
> On 10/08/2015 09:44 PM, Benjamin Marzinski wrote:
> > The multipath devices need to be deactivated before iscsi is shutdown,
> > otherwise the multipath devices will generate a lot of error messages
> > when it loses its iscsi path devices.
> > =

> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  multipathd/multipathd.service | 1 +
> >  1 file changed, 1 insertion(+)
> > =

> > diff --git a/multipathd/multipathd.service b/multipathd/multipathd.serv=
ice
> > index b5b755b..fc2e009 100644
> > --- a/multipathd/multipathd.service
> > +++ b/multipathd/multipathd.service
> > @@ -1,5 +1,6 @@
> >  [Unit]
> >  Description=3DDevice-Mapper Multipath Device Controller
> > +Requires=3Dblk-availability.service
> >  Before=3Discsi.service iscsid.service lvm2-activation-early.service
> >  Before=3Dlocal-fs-pre.target
> >  After=3Dmultipathd.socket
> > =

> =

> This will limit multipath to run on root-on-iSCSI scenarios. You
> cannot run multipath on non-iSCSI and have a non-root share on iSCSI
> after this change.
> Is that intended?

Huh? This doesn't stop multipath from being set up on non-root iscsi
devices. It just means that before systemd shuts down iscsi in the
shutdown initramfs, it will attempt to disassemble the multipath device,
if possible.  I'm not sure what your objection here is. Am I missing
something?

-Ben

> =

> Cheers,
> =

> Hannes
> -- =

> Dr. Hannes Reinecke		               zSeries & Storage
> hare@suse.de			               +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
> HRB 21284 (AG N=FCrnberg)
> =

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
