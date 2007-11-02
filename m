From: lemons_terry@emc.com
Subject: RE: Does dm handle tape devices?
Date: Fri, 2 Nov 2007 16:01:53 -0400
Message-ID: <B6FF36386FC9AC4BB098A4528811409F4B7882@CORPUSMX40A.corp.emc.com>
References: <B6FF36386FC9AC4BB098A4528811409F4B7802@CORPUSMX40A.corp.emc.com>
	<20071102195126.GA3712@linux.vnet.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20071102195126.GA3712@linux.vnet.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

Thanks for the reply.  I have a customer who runs three tape-aware
applications in one Linux system.  Two of those applications use device
files (ex., dev/nst0) to access the tape devices, so the persistent
udev-created symbolic links in /dev/tape/by-id and /dev/generic/by-id
will work fine for those applications.

A third application, alas, uses SCSI IDs to refer to the tape devices.
I've been instructed to seek a persistent naming solution for this
application, too, one that (hopefully) won't require modification of the
application.  I started out looking at the QLogic FC HBA's persistence
capability, and saw that it functions at the target level within a
single HBA.  But I found that some vendors don't support this method of
persistence, opting instead to use device mapper.

Hope this is clear.

tl

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Mike Anderson
Sent: Friday, November 02, 2007 3:51 PM
To: device-mapper development
Subject: Re: [dm-devel] Does dm handle tape devices?

lemons_terry@emc.com <lemons_terry@emc.com> wrote:
> Hi
>=20
> I need to provide persistent binding / persistent device naming for
tape devices in Linux environments.  Does device mapper provide some
facility for this, or is DM only for disk devices?
>=20

Device mapper is only for block devices.

I saw your similar question on the udev list. Is there some reason that
udev will not provide a id that you can use. If not you can alter the
udev rules (or add your own) to provide a persistent id for your
environment.

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
