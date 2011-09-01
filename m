From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH v2] multipath: add find_multipaths feature.
Date: Thu, 1 Sep 2011 13:54:58 -0500
Message-ID: <20110901185458.GL11793@ether.msp.redhat.com>
References: <20110725185758.GA1368@ether.msp.redhat.com>
	<20110901025518.GD11793@ether.msp.redhat.com>
	<1314861263.14056.89.camel@lapoo.opensvc.com>
	<20110901125720.GF11793@ether.msp.redhat.com>
	<4E5F9824.1020105@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4E5F9824.1020105@suse.de>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Sep 01, 2011 at 04:35:16PM +0200, Hannes Reinecke wrote:
> I already did a patch to allow for a different location for the bindings =

> file (methinks it's upstream, isn't it?)

It is.

> The issue here is an inversion in behaviour.
> Normally multipath would access / manage all devices except those
> blacklisted in /etc/multipath.conf
> With the patch multipath would access / manage _no_ devices except those =

> listed in /etc/multipath.conf

Or any devices that have two paths to them. Or devices that have, in the
past, had two paths to them. The idea behind this was to make multipath
"just work", without users needing to bother touching
/etc/multipath.conf at all, for common storage arrays.

multipathd will find all the devices with multiple paths (except the
blacklisted ones), and remember them so that in the future, as soon as
the first path becomes available, multipathd knows that it should be
multipathed.  Blacklisting works just as before. The only difference is
that you no longer need to use the blacklist to keep multipath from
grabbing devices that don't have multiple paths.  You only use it if you
have multiple paths, but for some reason you don't want to have
multipath manage them.

For devices with only one path, the user will need to specifically add
them.  But if the user want's to use multipath on single path devices,
then just don't turn on find_multipaths.

So I'm not sure I understand your objection.

> However, we definitely need to figure out how integrate with systemd.
> From my understanding we need to have some 'trigger', telling systemd to =

> ignore any disks multipath might hook onto.

With the wwids file, it's simple to be able to tell if a disk belongs to
multipath after multipath has already been setup on it once.  The only
issue is on the first time the disk is seen.  With find_multipaths this
is problem, since multipath won't know until it sees a second path to
the disk if it should be multipathed.  Without find_multipaths, we could
just assume that if the device is not blacklisted, it belongs to
multipath.

-Ben

> Sure, the find_multipaths feature would be a possible solution here, as =

> then systemd could evaluate the config file any everything would be dandy.
>
> However, I would prefer to modify 'multipath' (which is in the process on =

> becoming obsoleted currently). This could program could then be used to =

> provide systemd with the required information, ie if a device should be =

> ignored or not.
>
> Cheers,
>
> Hannes
> -- =

> Dr. Hannes Reinecke		      zSeries & Storage
> hare@suse.de			      +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
