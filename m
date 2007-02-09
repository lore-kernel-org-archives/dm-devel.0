From: David =?UTF-8?Q?H=C3=A4rdeman?= <david@hardeman.nu>
Subject: Bug#409875: [Pkg-cryptsetup-devel] Bug#409875: bug #409875
Date: Fri, 9 Feb 2007 22:28:26 +0100
Message-ID: <20070209212826.GA10396@hardeman.nu>
References: <20070208213609.GA6406@hardeman.nu> <20070208215149.GL32661@doriath.informatik.uni-erlangen.de> <22206.145.64.134.242.1171025126.squirrel@www.hardeman.nu> <20070209134251.GO32661@doriath.informatik.uni-erlangen.de> <35325.145.64.134.242.1171035160.squirrel@www.hardeman.nu> <20070209155857.GP32661@doriath.informatik.uni-erlangen.de> <56504.145.64.134.242.1171044839.squirrel@www.hardeman.nu> <20070209183546.GQ32661@doriath.informatik.uni-erlangen.de> <20070209203247.GA5378@hardeman.nu> <20070209204431.GR32661@doriath.informatik.uni-erlangen.de>
Reply-To: David =?UTF-8?Q?H=C3=A4rdeman?= <david@hardeman.nu>,
	409875@bugs.debian.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <bounce-debian-bugs-dist=glddb-debian-bugs-dist=m.gmane.org@lists.debian.org>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.409875.B409875.11710564862336@bugs.debian.org>
Content-Disposition: inline
In-Reply-To: <20070209204431.GR32661@doriath.informatik.uni-erlangen.de>
List-Post: <mailto:debian-bugs-dist@lists.debian.org>
List-Help: <mailto:debian-bugs-dist-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=unsubscribe>
To: Johannes Schlumberger <asso@doriath.informatik.uni-erlangen.de>, 409875@bugs.debian.org
Cc: waldi@debian.org, debian-devel@lists.debian.org, pkg-lvm-maintainers@lists.alioth.debian.org, dm-devel@redhat.com, lool+alioth@via.ecp.fr, agk@redhat.com
List-Id: dm-devel.ids

reassign 409875 libdevmapper1.02
retitle 409875 libdevmapper should provide more helpful error messages
severity 409875 minor
thanks

On Fri, Feb 09, 2007 at 09:44:32PM +0100, Johannes Schlumberger wrote:
>> Thanks, this looks mighty suspicious...it looks like /dev/md0 is mount=
ed=20
>> as your root partition by the initramfs? Please provide me with "ls -a=
l=20
>> /dev/root" and "cat /proc/cmdline" as well as the contents of your gru=
b=20
>> or lilo config file.
>
>I am so sorry for stealing yours and other persons time like this. I had
>root=3D/dev/md0 in my menu.lst and / as /dev/hdd6 in my fstab. I have to=
 say I am
>strongly embarassed.

No problem, it happends to all of us. There still is a bug here=20
though...the error messages from libdevmapper are obtuse to say the=20
least.

libdevmapper explained that /dev/md0 is in use with the message:
"Command failed: device-mapper: reload ioctl failed: Invalid argument"

That is a bug in my book.

I'll reassign this bug to libdevmapper (and retitle it accordingly).

I'll also CC all people that I've bugged earlier so that they know that=20
this issue is no more.

>Thank you a lot for figuring this out and all your patience.

That's ok, you just owe me a beer.

--=20
David H=E4rdeman
