From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: multipath-0.5.0 still provides broken udev rules
Date: Thu, 28 Apr 2016 17:45:20 -0500
Message-ID: <20160428224520.GI26117@octiron.msp.redhat.com>
References: <CAE+k_g+Eh3H1EAiJ0jm7P-efGbOOwpWRtYmvXyR9qhhHtefV7g@mail.gmail.com>
	<571DF852.6030604@redhat.com>
	<CAE+k_gKQcx+QR9bfEp1Wy8BawD14L2G5O0Yw-d0=CffBHqYbrA@mail.gmail.com>
	<571E0E7A.4050703@redhat.com>
	<CABr-GnfxOKz8gxDju20Hx3T9Tn74Zz9FhjF1dBk8weEBJMOmLg@mail.gmail.com>
	<1986ca6b-d281-4faf-2b50-11c3dc132463@gmail.com>
	<571F026C.5040102@suse.de>
	<20160427224601.GG26117@octiron.msp.redhat.com>
	<5721AC70.3070606@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <5721AC70.3070606@suse.de>
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
Cc: Peter Volkov <peter.volkov@gmail.com>, device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Thu, Apr 28, 2016 at 08:23:44AM +0200, Hannes Reinecke wrote:
> On 04/28/2016 12:46 AM, Benjamin Marzinski wrote:
> > Aside from dropping the socket, it checks that /etc/multipath.conf
> > exists, and that the kernel wasn't started with "nompath". Also it runs
> > "multipath -A" this reads the kernel commandline from /proc/cmdline, and
> > adds any wwids listed as part of any mpath.wwid=3D<wwid> parameters.
> > Hannes NACKed this patch, so the option isn't present upsteam.
> > =

> >  =

> Hmm. Actually, I do like the 'nompath' checking; we do lack the
> capability of switching off multipath from the kernel commandline
> ATM. So yes, we should be including that bit.
> =

> As for /etc/multipath.conf ... The original setup has been shipping
> without any multipath.conf file. So I would be okay with this change
> if we can guarantee that /etc/multipath.conf will always be existing.
> Seeing that you're running 'multipath -A' to add any wwids, wouldn't
> that be sufficient?
> IE why do we need the check for /etc/multipath.conf here; couldn't
> we make 'multipath -A' return non-zero to avoid multipathd to be
> started?

The idea with checking for /etc/multipath.conf is exactly that it
doesn't ship with one.  This way, even if multipath is installed on the
system, it isn't automatically enabled.  Obviously, simply touching
/etc/multipath.conf is enough for a default config. This isn't super
necessary in the multipathd.service file, because you need to enable
the service for it to run, but I do this to match the checks in the
multipath.rules file.

All that's involved in this is the check in multipathd.service, the
check in multipath.rules, and a small bit of code that gets run when
multipath starts, and exits with a warning if you don't have a
configuration file. I belive I posted this years ago, and it got Nak'ed.
I'm fine if upstream doesn't want to do things this way.

multipath -A won't create a configuration file, it will just add any
WWIDs from the kernel commandline to the wwids file. I see them as two
entirely seperate things. Like I said above, the multipath.rules checks
for /etc/multipath.conf as well. You really need the conditions for when
multipath is enabled to match between these two files.

-Ben

> =

> Cheers,
> =

> Hannes
> -- =

> Dr. Hannes Reinecke		   Teamlead Storage & Networking
> hare@suse.de			               +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
> HRB 21284 (AG N=FCrnberg)
