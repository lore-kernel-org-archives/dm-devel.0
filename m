From: devzero@web.de
Subject: Re: Re: device mapper integrated loops - and one more
	year !
Date: Sat, 20 Jan 2007 15:57:23 +0100
Message-ID: <1572893983@web.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: breeves@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello Bryn,=20


>I'll see if we can get a revised version of the current patch for wider
>testing in the next couple of weeks - let me know if you would be
>interested in trying this out.

not sure if i sent a reply to this or have missed this -  but, yes - i`m =
still interested very much in using dm-loop !

is there anything new with this?
do i have to expect issues with files >2gb ? (i need to loopback mount dv=
d iso-images)

is there a download url for the latest dm-loop patch so i can do some tes=
ts and report feedback ?

i couldn`t find it at http://sources.redhat.com/cgi-bin/cvsweb.cgi/device=
-mapper/?cvsroot=3Ddm  and i`m not sure if i should take that one from ht=
tp://kernel.org/pub/linux/kernel/people/agk/patches/2.6/

TIA
roland



> Hello !
>=20
> after desparately seeking for a solution to have more than 256 loop
> devices (for a huge cd-rom server), i have recently come across
> dm-loop, which looks very promising (to replace loop.c)
>=20
> can i have more than 256 devices which this?

Hi Roland,

Yes, dm-loop will support as many loop devices as device-mapper can allow=
.

> our cd-rom server is going to have more than 256 iso-images soon and
> i need to upgrade to a more recent OS, anyway, so this won`t be a=20
> problem that dm-loop is so brand new.
>=20
> but - any timeline for dm-loop mainline inclusion ?
>=20
> should i wait for 2.6.19 or 2.6.20 ?

There isn't a fixed timeline. We are currently working to improve the
lookup code - the prototype patch uses a linear search which doesn't
scale well for large/fragmented image files. I have some tests running
at the moment and we hope to have something soon - the results so far
are good, it's just a case of selecting between a couple of different
methods.

The changes dm-loop requires in device-mapper core are pretty minor and
have already been merged in 2.6.19, so it's just the dm-loop patch
itself remaining.

> is it already useable with less recent kernels, i.e. can i download
> dm-loop patch and recent dmsetup tool and use with older kernel ?

This should work fine - there are a couple of known issues with the
existing patch, but unless you are using large images (>2G), or have a
severely fragmented filesystem you shouldn't run into these.

I'll see if we can get a revised version of the current patch for wider
testing in the next couple of weeks - let me know if you would be
interested in trying this out.

Thanks,

Bryn.
_________________________________________________________________________=
_
Erweitern Sie FreeMail zu einem noch leistungsst=E4rkeren E-Mail-Postfach=
!	=09
Mehr Infos unter http://freemail.web.de/home/landingpad/?mc=3D021131
