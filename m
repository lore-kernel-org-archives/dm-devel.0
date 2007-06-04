From: "Vassar, Bob" <Robert.Vassar@am.sony.com>
Subject: 4k block LUN problem
Date: Mon, 4 Jun 2007 17:08:29 -0400
Message-ID: <3DB43EBAF77555449D828440C12F8E7E0332E31C@usbmaxms02.am.sony.com>
References: <1888A5CA2B0AD311AD520090274069940AA82789@usbmaxms02.am.sony.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <1888A5CA2B0AD311AD520090274069940AA82789@usbmaxms02.am.sony.com>
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

Hello,

I have a problem with a SAN array. I need LUNs over 2TB (15TB is my targe=
t) so my LUN block size is set to 4096. When I remove the black list entr=
y for this device Linux won't boot until the fiber channel lane times out=
. My SAN appliance is reporting under run errors with a read that is not =
a multiple of 4096 and debug shows a read of length:0. I think this is co=
ming from the path checker since when I change this to "tur" the system b=
oots and dm sees the equal UUID's and creates the dm-x device.=A0 When I =
try to create a file system on the dm device this fails writing the super=
 blocks.=A0=20

It appears that some dm function can not handle 4096 block size correctly=
 since if I remake my LUN's at 512byte the dm device is created and boots=
 with readsector0 as path checker and I can create an ext file system wit=
h no problem.=A0 Does any know if dm only works on 512 block devices or i=
s there a configuration parameter to handle block sizes other than 512 on=
 the physical device (not file system block). I have been back and forth =
with RH support for over a week and getting very frustrated.=A0=20

Thanks,
Bob
=A0
