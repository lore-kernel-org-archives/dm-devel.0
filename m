From: "Caushik, Ramesh" <ramesh.caushik@intel.com>
Subject: RE: open-iscsi + dm-multipath
Date: Tue, 15 Mar 2005 16:40:01 -0800
Message-ID: <EA4DC661A6353747A2E5C0DE8792DDDE0812849B@orsmsx404.amr.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
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
Cc: open-iscsi@googlegroups.com
List-Id: dm-devel.ids

BTW I have seen in the case of atleast 2 different iSCSI target
implementations (unh-iscsi and iscsi-enterprise target), the target does
not return the physical disk id for the scsi_id callout, but returns
manufactured values (like LINUX ISCSI for vendor, etc). Given that, how
can multipath-tools create multipaths for different iscsi disks ? I am
thinking of the case 2 iscsi servers running iscsi target software and
talking to the same FC disk at the back-end. By running multipath-tools
I would expect the 2 different iSCSI logical devices to be part of the
same multipath group. But if the target software on both the servers
returns made-up values then this scheme would break, right ? Any
comments on this one ?

Ramesh.     =20

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of christophe varoqui
Sent: Tuesday, March 15, 2005 2:49 PM
To: device-mapper development
Cc: open-iscsi@googlegroups.com
Subject: Re: [dm-devel] open-iscsi + dm-multipath

On sam, 2005-03-12 at 12:03 -0800, Dmitry Yusupov wrote:
> Hi Guys!
>=20
> had anyone tried to setup open-iscsi with dm-multipath yet?
> I think it should work out of the box, but would be cool if someone
will
> double check on that.
>=20
> PS: www.open-iscsi.org is a new cool project which features some
> noticeable performance improvements for soft-based iSCSI Initiator
plus
> other number of exciting abilities such as independent transport and
> better user-space vs. kernel split. Read more on project's web page.
>=20
I tried on Monday, but I'm stuck before dm-multipath kicks into play.
Build runs ok, modules load into the kernel, daemon starts up, but the
admin tool remain desparetely silent to all commands I stuffed at it.

What is even more weird is that the daemon (in debug mode) remains
silent too.

The target side works well : IET verified with Cisco initiator.

Regards,
--=20
christophe varoqui <christophe.varoqui@free.fr>


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
