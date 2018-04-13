From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v4 18/20] multipath -u: quick check if path
	is multipathed
Date: Fri, 13 Apr 2018 11:12:43 -0500
Message-ID: <20180413161243.GF3103@octiron.msp.redhat.com>
References: <20180404161627.6244-1-mwilck@suse.com>
	<20180404161627.6244-19-mwilck@suse.com>
	<20180412184618.GT3103@octiron.msp.redhat.com>
	<1523571552.4346.108.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1523571552.4346.108.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com, Julian Andres Klode <julian.klode@canonical.com>
List-Id: dm-devel.ids

On Fri, Apr 13, 2018 at 12:19:12AM +0200, Martin Wilck wrote:
> On Thu, 2018-04-12 at 13:46 -0500, Benjamin Marzinski wrote:
> > On Wed, Apr 04, 2018 at 06:16:25PM +0200, Martin Wilck wrote:
> > > With "find_multipaths smart", we accept paths as valid if they are
> > > already part of a multipath map. This patch avoids doing a full
> > > path
> > > and device-mapper map scan for this case, speeding up "multipath
> > > -u"
> > > considerably.
> > =

> > I feel like this supports my idea from 17/20. I really think that in
> > smart mode, the only time we should be claiming a device as multipath
> > is
> > on an add event, if it has always been claimed (or pretend claimed)
> > as a
> > multipath path, or if it is currently a multipath path. Once we have
> > let
> > a uevent go by for a path without setting SYSTEMD_READY=3D0, anything
> > else
> > is free to use it, and we simply can't safely set SYSTEMD_READY=3D0,
> > unless we know that multipathd has already grabbed the device.
> =

> We have to remember that in the udev db then. That doesn't work for
> coldplug aside, but we agree that's not an issue. By checking a
> suitable udev variable, we can make sure that we never set
> SYSTEMD_READY=3D0 after having released the device to the system.

We can safely set SYSTEMD_READY=3D0 if we know that the device is now part
of an existing multipath device, but yeah.
 =

> >  I feel
> > like checking the wwids file should give you confidence that a device
> > either currently is a multipath path, or has always been claimed as
> > one.
> > However, this patch can fix any loop holes where a device isn't in
> > the
> > wwids file, but it multipathed (I don't know of any offhand).
> =

> multipath -u can't assume that multipathd is running. The map may have
> been set up in the initrd, and thus would not necessarily be in the
> WWIDs file in the root FS. =


That's a loophole. And because I accidentally forgot to add it before

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> Currently multipath -u scans all paths and maps in this case, just to
> figure out if the given path is maybe already part of a map. My patch
> was just meant as a shortcut for this case. If we could rely on the
> WWIDs file that would be even easier, but I don't think we can.
> =

> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
