From: "Vassar, Bob" <Robert.Vassar@am.sony.com>
Subject: RE: 4k block LUN problem
Date: Wed, 13 Jun 2007 15:47:15 -0400
Message-ID: <3DB43EBAF77555449D828440C12F8E7E034406FD@usbmaxms02.am.sony.com>
References: <20070613193433.GG18457@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20070613193433.GG18457@agk.fab.redhat.com>
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

I didn't partition the dm device. I used fdisk to create the sda[1]
partition on the lun. The dm device is then created on sda[1]. I then
simply mkfs on the dm partition. =20

I'll check again following your advice below with lvm and check with
blockdev. We are a bit new at this and information from reliable sources
is hard to come by (many opinions, less factual advice). Thanks for your
insight, I'll give it go. =20

Bob


-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Alasdair G Kergon
Sent: Wednesday, June 13, 2007 2:35 PM
To: device-mapper development
Subject: Re: [dm-devel] 4k block LUN problem

On Wed, Jun 13, 2007 at 03:17:25PM -0400, Vassar, Bob wrote:
> I have used tur and this allows the system to boot. When I run "ll
> /dev/mpath* I see the dm device created. All appears to be working OK.


So use tur then.  First problem solved.

> Fdisk also reports the same number of devices as paths to the device.


Fdisk?  Don't partition it: use logical volumes instead:
pvcreate/vgcreate/lvcreate.
- You'd need parted (gpt) rather than fdisk to partition large devices
and then kpartx.


Now run 'blockdev --getss' to check whether or not the sector size gets
propagated correctly from the underlying device to the multipath device.

Alasdair
--=20
agk@redhat.com

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
