From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: Multipath blacklist exceptions issues
Date: Tue, 13 Nov 2007 15:21:59 -0600
Message-ID: <20071113212158.GK28113@ether.msp.redhat.com>
References: <20071109002347.GG28113@ether.msp.redhat.com>
	<5201e28f0711090620i7f6360dfr3c0ffa6307ab91e0@mail.gmail.com>
	<20071109202044.GH28113@ether.msp.redhat.com>
	<5201e28f0711091520o3da59658kc41a39bc7e7b855b@mail.gmail.com>
	<1194657466.6724.49.camel@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1194657466.6724.49.camel@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@free.fr>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Sat, Nov 10, 2007 at 02:17:45AM +0100, Christophe Varoqui wrote:
> Indeed the current situation is fishy. Ben pointed a true braino in the
> code I introduced when restructuring the blacklist lib :
>=20
> in _filter_path(), I test each _filter_*() for r!=3D0 , where I intente=
d
> to check for r>0.
>=20
> r=3D=3D0 implements  : "exit on first blacklist or exception match".
>  r>0 implements  : "exit on first blacklist match".
>=20
> With this later behaviour I can set things like that for max safety and
> efficiency :
>=20
> blacklist {
>         devnode .*
>         device {
>                 vendor .*
>                 product .*
>         }
>         wwid .*
> }
> blacklist_exceptions {
>         devnode sd.*
>         device {
>                 vendor IET.*
>                 product .*
>         }
>         wwid "1646561646265.*"
> }
>=20
> or pragmatically :
>=20
> blacklist {
>         devnode .*
>         wwid .*
> }
> blacklist_exceptions {
>         devnode sd.*
>         wwid "1646561646265.*"
> }
>=20
>=20
>=20
> Working that out, I also realized there may be another small
> misbehaviour :
>=20
> First, a little background on path discovery operations :
>=20
> 1) /sys/block parsing shows devnode names
> 2) devnode names examination shows device identification strings
> 3) these strings help us choose a getuid helper, which finally shows
> wwids
>=20
> Meaning we want the devnode blacklisting to prevail over device and
> wwid, in case we know we don't have device strings available (loop, dm-=
,
> raw, ...)
>=20
> Similarily, we want the device blacklist to prevail over wwid, in case
> we know we don't have getuid callout available. I have no example for
> this case though, so it shouldn't be as important as the previous one.
>=20
> Problem is we challenge _filter_device() after _filter_wwid().
> This can be easily shufled around.
>=20
>=20
> So, I submit this (attached) patch to your review.

Looks fine to me.

-Ben
=20
> regards,
> cvaroqui
>=20
> =09
> Le samedi 10 novembre 2007 =E0 00:20 +0100, Stefan Bader a =E9crit :
> >=20
> >        =20
> >         Any thoughts on this? Good Idea? Worth doing?
> >=20
> > To be honest, I do not see the real simplification in that many
> > changes. Spreading black- and/or white-lists over so many places seem=
s
> > rather confusion to me. I agree that using devnode names is not ideal
> > for the reasons you mentioned. That was done mainly to have an
> > internal blacklist of known devices that are known not to work.
> > Potentially this could be a device type (=3D driver name?). But would
> > this not also be possible as a new element of the blacklist? E.g.:
> >=20
> > blacklist {
> >     driver fd
> >     driver device-mapper
> >     ...
> > }
> >=20
> > The problem with the current implementation, in my thinking, is that
> > we have a dependency between two sections (blacklist and
> > blacklist_exceptions) and the keywords within. Without reading any
> > further=20
> > documentation it seems awkward that it is not possible to blacklist
> > device nodes and punch holes by certain wwid numbers. When I think
> > about it, I guess (any other opinions welcome) that a exception is
> > what is really intended to be used. So that should always have more
> > priority than a blacklist. So if the filter finds a matching entry in
> > the blacklist_exceptions section, the device should be used.=20
> >=20
> > So my proposal would be:
> >=20
> > 1. process the blacklist_exceptions (any match enables the device)
> > 2. process the blacklist
> > 3. any device dropping through is also used.
> >=20
> > Additionally I like the idea of a match-by-driver extension.=20
> >=20
> > Stefan

> diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
> index 9a058f7..6297516 100644
> --- a/libmultipath/blacklist.c
> +++ b/libmultipath/blacklist.c
> @@ -297,16 +297,14 @@ _filter_path (struct config * conf, struct path *=
 pp)
>  	int r;
> =20
>  	r =3D _filter_devnode(conf->blist_devnode, conf->elist_devnode,pp->de=
v);
> -	if (r)
> -		return r;
> -	r =3D _filter_wwid(conf->blist_wwid, conf->elist_wwid, pp->wwid);
> -	if (r)
> +	if (r > 0)
>  		return r;
>  	r =3D _filter_device(conf->blist_device, conf->elist_device,
>  		 	   pp->vendor_id, pp->product_id);
> -	if (r)
> +	if (r > 0)
>  		return r;
> -	return 0;
> +	r =3D _filter_wwid(conf->blist_wwid, conf->elist_wwid, pp->wwid);
> +	return r;
>  }
> =20
>  int
