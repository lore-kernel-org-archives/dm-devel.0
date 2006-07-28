From: "Peter Koutoupis" <Peter_Koutoupis@us.xyratex.com>
Subject: aliases as raw devices......
Date: Fri, 28 Jul 2006 14:16:30 -0700
Message-ID: <1121230D3E3B6B4E9162069832D90A641BBF78@XYUS-EX22.xyus.xyratex.com>
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

All,

Using Redhat Advanced Server 4 Update 3 and the
device-mapper/multipath-tools native to it
(device-mapper-1.02.02-3.RHEL4 +
device-mapper-multipath-0.4.5-12.0.RHEL4), we have a failover
configuration of however many raw devices sorted by their WWID.  An
alias of both dm-x and the WWID number is given to that one LD of many
LUN mapping.  Let us say I have:
/dev/sda
/dev/sdb
/dev/sdc
/dev/sdd
All being different LUN mappings of the same LD and assigned the alias
of dm-0.  I can obviously write to the raw device of /dev/sda or
/dev/sdb and so on but I am unable to write to the raw device of
/dev/dm-0.  Actually to get into more detail..... dd writes to dm-0 just
fine but our own coded I/O read/write utility as an issue with ioctl
statting the geometry to the alias to the raw device.

Oictl_status =3D ioctl(fd, HDIO_GETGEO, &disk_geometry_info); //part of
source

The IO utility comes back saying:

HDIO_GETGEO error number 25

To stat a dm device what parameter would be most appropriate for ioctl
to pass?

Regards,

Peter Koutoupis
Systems Engineer
Xyratex International, Inc.
1804 Centre Point Circle
Suite 112
Naperville, IL 60563 USA
(630)364-7656
