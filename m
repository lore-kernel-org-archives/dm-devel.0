From: "Peter Koutoupis" <Peter_Koutoupis@us.xyratex.com>
Subject: RE: geometry of dm devices......
Date: Tue, 8 Aug 2006 13:32:49 -0700
Message-ID: <1121230D3E3B6B4E9162069832D90A641BC0D2@XYUS-EX22.xyus.xyratex.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
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

I thank you for your response.  I actually thought of this as a work
around for the dm multipath device and pretty much as a last resort.
But my concern was raised with a multipath device and I was hoping to
get a answer for any dm device but I guess it is not possible.  Once
again thank you for your response.

Peter

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Benjamin Marzinski
Sent: Tuesday, August 08, 2006 3:06 PM
To: device-mapper development
Subject: Re: [dm-devel] geometry of dm devices......

On Wed, Aug 02, 2006 at 09:26:31AM -0700, Peter Koutoupis wrote:
> Unfortunately I got no reponses in my last post so I will try this=20
> again...but now is a slightly different direction.
>=20
> I understand the HDIO_GETGEO is an unsupported feature to dm=20
> devices....but under normal practices how would a normal end-user be=20
> able to obtain such geometry from a raw dm device?  I have read of=20
> individuals looking into the MBR or grub (which sometimes resulted in=20
> incorrect results) and a few other things.  But if a dba type app such

> as oracle needs to work with a dm created raw device...how would it=20
> normally stat for the device geometry?  Any ideas?  Directions?

I suppose it depends on what the dm device is.  If it is a mirror or
stripped device with multiple devices under it, I'm not sure what a good
answer is.

However if it is a multipath device, with only one physical device under
it, couldn't you just send the ioctl to one of the underlying paths?

Say you have a multipath device (dm-0), that is composed of 4 paths
(sda, sdb, sdc, sdd).  Sending the ioctl to any one of those sd* paths
would return the same device geometry. Since you are using multipath,
you are obviously concerned that one of those paths might be down. So
you could try sending the ioctl down each path in succession, until you
got one that successfully returned.

-Ben
=20
> Thanks,
>=20
> Petros
>=20
> -----Original Message-----
> From: Peter Koutoupis
> Sent: Friday, July 28, 2006 4:17 PM
> To: 'device-mapper development'
> Subject: [dm-devel] aliases as raw devices......
>=20
> All,
>=20
> Using Redhat Advanced Server 4 Update 3 and the=20
> device-mapper/multipath-tools native to it
> (device-mapper-1.02.02-3.RHEL4 +
> device-mapper-multipath-0.4.5-12.0.RHEL4), we have a failover=20
> configuration of however many raw devices sorted by their WWID.  An=20
> alias of both dm-x and the WWID number is given to that one LD of many

> LUN mapping.  Let us say I have:
> /dev/sda
> /dev/sdb
> /dev/sdc
> /dev/sdd
> All being different LUN mappings of the same LD and assigned the alias

> of dm-0.  I can obviously write to the raw device of /dev/sda or=20
> /dev/sdb and so on but I am unable to write to the raw device of=20
> /dev/dm-0.  Actually to get into more detail..... dd writes to dm-0=20
> just fine but our own coded I/O read/write utility as an issue with=20
> ioctl statting the geometry to the alias to the raw device.
>=20
> Oictl_status =3D ioctl(fd, HDIO_GETGEO, &disk_geometry_info); //part of=
=20
> source
>=20
> The IO utility comes back saying:
>=20
> HDIO_GETGEO error number 25
>=20
> To stat a dm device what parameter would be most appropriate for ioctl

> to pass?
>=20
> Regards,
>=20
> Peter Koutoupis
> Systems Engineer
> Xyratex International, Inc.
> 1804 Centre Point Circle
> Suite 112
> Naperville, IL 60563 USA
> (630)364-7656
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
