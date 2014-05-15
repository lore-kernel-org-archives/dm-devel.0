From: Brian Bunker <brian@purestorage.com>
Subject: an interesting note on LUN coalescing
Date: Thu, 15 May 2014 09:35:53 -0700
Message-ID: <9E356404-6E9E-4271-A8DC-8A95DD66AC81@purestorage.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

I have added a line to multipathd/main.c to see if I could get some more in=
formation when the dm device gets the wrong LUN=92s underneath. So I have a=
 dm device:

3624a9370c90d0d631ef8783e00010004 dm-2 PURE,FlashArray
size=3D500G features=3D'0' hwhandler=3D'0' wp=3Drw
`-+- policy=3D'round-robin 0' prio=3D0 status=3Dactive
  |- 3:0:0:3 sdav 66:240 active undef running
  |- 0:0:0:3 sdbc 67:96  active undef running
  |- 6:0:0:3 sdbt 68:112 active undef running
  |- 5:0:0:3 sdbu 68:128 active undef running
  |- 7:0:0:1 sdal 66:80  active undef running
  |- 2:0:0:1 sdb  8:16   active undef running
  `- 4:0:0:1 sdk  8:160  active undef running

I can see that when sdk is added to the dm, it is added to a dm ending in 0=
04, but the serial number of sdk clearly ends in 002:

May 15 05:09:55 rb9init4 multipathd: sdk: add path (uevent)
May 15 05:09:55 rb9init4 multipathd: 3624a9370c90d0d631ef8783e00010004: loa=
d table [0 1048576000 multipath 0 0 1 1 round-robin 0 7 1 66:240 1 67:96 1 =
68:112 1 68:128 1 66:80 1 8:16 1 8:160 1]
May 15 05:09:55 rb9init4 multipathd: sdk path added to devmap 3624a9370c90d=
0d631ef8783e00010004
May 15 05:09:55 rb9init4 multipathd: sdk [8:160]: path has a serial C90D0D6=
31EF8783E00010002

I am printing out pp->serial to get the serial number of sdk. =


Any idea why the lookup of wwid for a path gets clearly the wrong one? At s=
ome level the data structure has the right serial number. Is there a check =
missing that belongs there? Is there a bug in the lookup itself? I will kee=
p adding more debug lines to get to the bottom of the problem if there are =
no ideas. This definitely leads to a corruption when it happens.

Thanks,
Brian

Brian Bunker
brian@purestorage.com
