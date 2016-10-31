From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 03/10] do not allow in-use path to change wwid
Date: Mon, 31 Oct 2016 09:30:03 -0500
Message-ID: <20161031143003.GW1972@octiron.msp.redhat.com>
References: <1477709726-5442-1-git-send-email-bmarzins@redhat.com>
	<1477709726-5442-4-git-send-email-bmarzins@redhat.com>
	<04fc0201-86a7-d83c-f2dd-5b24e6393a64@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <04fc0201-86a7-d83c-f2dd-5b24e6393a64@suse.de>
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

On Sun, Oct 30, 2016 at 02:45:01PM +0100, Hannes Reinecke wrote:
> On 10/29/2016 04:55 AM, Benjamin Marzinski wrote:
> >When a path is part of a multipath device, it must not change it's wwid.
> >If it can, when multipathd is reconfigured, you can end up with two
> >multipath devices owning the same path, eventually leading to a crash.
> >
> >Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> >---
> > libmultipath/dmparser.c | 8 ++++++++
> > 1 file changed, 8 insertions(+)
> >
> Hmm. While I do see that this is an issue, just continuing is probably as
> bad; the wwid change might be genuine, in which case this device has no
> business being part of that particular multipath device.
> Can't we just evict that offending path eg by orphaning it and let the ad=
min
> figure things out?

Possibly, but sometimes devices change wwids temporarily when they get
temporarily unmapped, which can happen when you resize them. When I
tried orphaning them, I could get multipath devices getting created for
that temporary wwid, which was pretty confusing.  My later patch also
disables access to these paths, so multipath can't keep writing to them,
but you don't get these annoying fake mutipath devices.

-Ben

> =

> Cheers,
> =

> Hannes
> -- =

> Dr. Hannes Reinecke		      zSeries & Storage
> hare@suse.de			      +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
