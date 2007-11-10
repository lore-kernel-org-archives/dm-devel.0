From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: Multipath blacklist exceptions issues
Date: Sat, 10 Nov 2007 02:17:45 +0100
Message-ID: <1194657466.6724.49.camel@localhost.localdomain>
References: <20071109002347.GG28113@ether.msp.redhat.com>
	<5201e28f0711090620i7f6360dfr3c0ffa6307ab91e0@mail.gmail.com>
	<20071109202044.GH28113@ether.msp.redhat.com>
	<5201e28f0711091520o3da59658kc41a39bc7e7b855b@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-tqL2/kwkSJ7avmoRG7GY"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5201e28f0711091520o3da59658kc41a39bc7e7b855b@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Stefan Bader <Stefan.Bader@de.ibm.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


--=-tqL2/kwkSJ7avmoRG7GY
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Indeed the current situation is fishy. Ben pointed a true braino in the
code I introduced when restructuring the blacklist lib :

in _filter_path(), I test each _filter_*() for r!=3D0 , where I intented
to check for r>0.

r=3D=3D0 implements  : "exit on first blacklist or exception match".
 r>0 implements  : "exit on first blacklist match".

With this later behaviour I can set things like that for max safety and
efficiency :

blacklist {
        devnode .*
        device {
                vendor .*
                product .*
        }
        wwid .*
}
blacklist_exceptions {
        devnode sd.*
        device {
                vendor IET.*
                product .*
        }
        wwid "1646561646265.*"
}

or pragmatically :

blacklist {
        devnode .*
        wwid .*
}
blacklist_exceptions {
        devnode sd.*
        wwid "1646561646265.*"
}



Working that out, I also realized there may be another small
misbehaviour :

First, a little background on path discovery operations :

1) /sys/block parsing shows devnode names
2) devnode names examination shows device identification strings
3) these strings help us choose a getuid helper, which finally shows
wwids

Meaning we want the devnode blacklisting to prevail over device and
wwid, in case we know we don't have device strings available (loop, dm-,
raw, ...)

Similarily, we want the device blacklist to prevail over wwid, in case
we know we don't have getuid callout available. I have no example for
this case though, so it shouldn't be as important as the previous one.

Problem is we challenge _filter_device() after _filter_wwid().
This can be easily shufled around.


So, I submit this (attached) patch to your review.

regards,
cvaroqui

=09
Le samedi 10 novembre 2007 =C3=A0 00:20 +0100, Stefan Bader a =C3=A9crit =
:
>=20
>        =20
>         Any thoughts on this? Good Idea? Worth doing?
>=20
> To be honest, I do not see the real simplification in that many
> changes. Spreading black- and/or white-lists over so many places seems
> rather confusion to me. I agree that using devnode names is not ideal
> for the reasons you mentioned. That was done mainly to have an
> internal blacklist of known devices that are known not to work.
> Potentially this could be a device type (=3D driver name?). But would
> this not also be possible as a new element of the blacklist? E.g.:
>=20
> blacklist {
>     driver fd
>     driver device-mapper
>     ...
> }
>=20
> The problem with the current implementation, in my thinking, is that
> we have a dependency between two sections (blacklist and
> blacklist_exceptions) and the keywords within. Without reading any
> further=20
> documentation it seems awkward that it is not possible to blacklist
> device nodes and punch holes by certain wwid numbers. When I think
> about it, I guess (any other opinions welcome) that a exception is
> what is really intended to be used. So that should always have more
> priority than a blacklist. So if the filter finds a matching entry in
> the blacklist_exceptions section, the device should be used.=20
>=20
> So my proposal would be:
>=20
> 1. process the blacklist_exceptions (any match enables the device)
> 2. process the blacklist
> 3. any device dropping through is also used.
>=20
> Additionally I like the idea of a match-by-driver extension.=20
>=20
> Stefan

--=-tqL2/kwkSJ7avmoRG7GY
Content-Disposition: attachment; filename=blacklist-misbehave.patch
Content-Type: text/x-patch; name=blacklist-misbehave.patch; charset=utf-8
Content-Transfer-Encoding: 7bit

diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
index 9a058f7..6297516 100644
--- a/libmultipath/blacklist.c
+++ b/libmultipath/blacklist.c
@@ -297,16 +297,14 @@ _filter_path (struct config * conf, struct path * pp)
 	int r;
 
 	r = _filter_devnode(conf->blist_devnode, conf->elist_devnode,pp->dev);
-	if (r)
-		return r;
-	r = _filter_wwid(conf->blist_wwid, conf->elist_wwid, pp->wwid);
-	if (r)
+	if (r > 0)
 		return r;
 	r = _filter_device(conf->blist_device, conf->elist_device,
 		 	   pp->vendor_id, pp->product_id);
-	if (r)
+	if (r > 0)
 		return r;
-	return 0;
+	r = _filter_wwid(conf->blist_wwid, conf->elist_wwid, pp->wwid);
+	return r;
 }
 
 int

--=-tqL2/kwkSJ7avmoRG7GY
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=-tqL2/kwkSJ7avmoRG7GY--
