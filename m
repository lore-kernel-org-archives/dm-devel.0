From: "Magni Fabrizio" <Fabrizio.Magni@rasnet.it>
Subject: RE: Unable to use multipath with LVM2
Date: Tue, 3 May 2005 14:49:03 +0200
Message-ID: <BFCF159FFD14F444B205968F32DBD5BB01700376@MAILEX01.rasgroup.ita.localnet>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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


Hi Lars,

> It'd be helpful if you actually reported which distribution you're
> talking about ;-)
>=20

luckily you know my situation.

> But looking at your version, I guess you might be running SLES9. In
> which case SP2 should help address your troubles:
> http://portal.suse.com/sdb/en/2005/04/sles_multipathing.html
>=20
> Please try and get access to the beta via your support contact.
>=20

I'm going to try soon.

> > If I insert aliases in multipath.conf and modify udev.rules=20
> I can see
> > symbolick links wichi can be used in failover or multibus=20
> (tested) but
> > they are not seen by the LVM2 (even modifying the filter in=20
> lvm.conf and
> > specifying "types").
>=20
> With those changes LVM2 is supposed to recognize them. Not sure why it
> doesn't for you.
>=20
> > What devices should the LVM scan to use multipathed PVs?
>=20
> Either the /dev/disk/by-*/ files, or /dev/dm-*; either will do. It's
> just important that it only uses those paths and doesn't use the raw
> disks (/dev/sdX).
>=20

/dev/disk/by-*/ can be scanned but they don't work properly on top of
multipath since they are linked directly to the "basic devices"
/dev/sd*.

I really don't understand why /dev/dm-* cannot be scanned properly by
the LVM2...

Fabrizio
