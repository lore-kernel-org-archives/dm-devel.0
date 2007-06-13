From: "Vassar, Bob" <Robert.Vassar@am.sony.com>
Subject: RE: 4k block LUN problem
Date: Wed, 13 Jun 2007 15:17:25 -0400
Message-ID: <3DB43EBAF77555449D828440C12F8E7E034406D1@usbmaxms02.am.sony.com>
References: <20070613185651.GF18457@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20070613185651.GF18457@agk.fab.redhat.com>
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

Hello Alasdair,

I have used tur and this allows the system to boot. When I run "ll
/dev/mpath* I see the dm device created. All appears to be working OK.
Fdisk also reports the same number of devices as paths to the device. =20
When I try to make the file system (ext2 or 3) the make fails on writing
super blocks.=20

If I remove the multipath.conf file and make a file system on the 4k
block sd device the file system makes and I can read/write to the
device. As soon as try this again with the device-mapper the process
fails.=20

If I reformat the LUN as 512byte blocks the device-mapper works and I
can make the file system. =20

Thanks,

Bob


-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Alasdair G Kergon
Sent: Wednesday, June 13, 2007 1:57 PM
To: device-mapper development
Subject: Re: [dm-devel] 4k block LUN problem

Try using an alternative path checker like tur or directio.

readsector0 seems to have '512' hard-coded - this ought to get fixed.

Alasdair
--=20
agk@redhat.com

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
