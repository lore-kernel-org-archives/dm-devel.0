From: Christopher Chen <muffaleta@gmail.com>
Subject: Re: FS directly on top of dm devices?
Date: Thu, 16 Apr 2009 17:47:35 -0700
Message-ID: <7bc80d500904161747n588b5b27v54b6c346ecd824d7@mail.gmail.com>
References: <49E7C4A6.3080301@gps.caltech.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49E7C4A6.3080301@gps.caltech.edu>
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

I run md over mpath dm'd devices, without partitioning. Of course, I
use dm-multipath to reach individual disks in a JBOD with two FC-AL
loops.

Lots of people like to do this to preserve stripe alignment.

I also use LVM, with the metadatasize option on creation of the PV, to
preserve stripe alignment.

Do you have a specific application in mind, like a database?

On Thu, Apr 16, 2009 at 4:52 PM, Scott Dungan <scott@gps.caltech.edu> wro=
te:
> We recently had an engineer from a large storage vendor suggest that we=
 make
> our file systems directly onto the multipathed devices without first
> creating underlying partitions or using LVM. =A0Having not run with thi=
s
> method in production before, we would like to gather as much informatio=
n as
> possible first. Initial searches for documentation on this method has
> produced few results, short of a Suse/Novell document from 2005 under
> section 4:
>
> http://support.novell.com/techcenter/sdb/en/2005/04/sles_multipathing.h=
tml
>
> Does anyone have any experience with this or can point us to more
> documentation. thoughts or recommendations?
>
> Thanks,
>
> --
>
> Scott A Dungan
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>



--=20
Chris Chen <muffaleta@gmail.com>
"I want the kind of six pack you can't drink."
-- Micah
