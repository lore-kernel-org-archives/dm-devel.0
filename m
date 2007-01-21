From: devzero@web.de
Subject: bug in dm-loop? - was:Re: Re: device mapper integrated
 loops - and one more year !
Date: Sun, 21 Jan 2007 18:16:43 +0100
Message-ID: <1574903375@web.de>
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
To: agk@redhat.com, breeves@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

hello !

if these is the most recent versions of dm-loop patch (don`t actually kno=
w for sure, see my last mail):

http://kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-loop=
.patch
http://kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-add-=
loop.patch

then i may have found some bug, i`d like to report.

i was doing some testing of dm-loop with latest dmsetup on a 2.6.20-rc5 s=
ystem.

i did some basic test, which seems to work ok.

i can now map a file to become /dev/mapper/loop0

dmlosetup loop0 test.img=20

-> device-mapper: loop: Finalized extent map of 1232 bytes, 44 entries.

root@localhost ~ # ls -la /dev/mapper/loop0
brw------- 1 root root 252, 0 21. Jan 17:25 /dev/mapper/loop0

works !

hooray - great work !


while fiddling around a little bit, i accidentally tried to map that file=
 a second time - anyway, i would expect this is quite ok and should work.

dmlosetup loop1 test.img=20

this bails out with the following error, leaving trace in dmesg: =20

device-mapper: loop: file is already in use: /root/device-mapper/dmsetup/=
test.dat
BUG: unable to handle kernel NULL pointer dereference at virtual address =
00000000
 printing eip:
d097589c
*pde =3D 00000000
Oops: 0000 [#1]
PREEMPT SMP=20
Modules linked in: dm_loop ipv6 snd_ens1371 gameport snd_rawmidi snd_ac97=
_codec ac97_bus pcnet32 i2c_piix4 i2c_core agpgart
CPU:    0
EIP:    0060:[<d097589c>]    Not tainted VLI
EFLAGS: 00010292   (2.6.20-rc5 #1)
EIP is at loop_setup_size+0x1c/0x1f0 [dm_loop]
eax: 00000000   ebx: cb3289c0   ecx: d097105c   edx: d0971020
esi: ffffffea   edi: 00000001   ebp: d0971020   esp: cad47e58
ds: 007b   es: 007b   ss: 0068
Process dmlosetup (pid: 1787, ti=3Dcad46000 task=3Dcfe13aa0 task.ti=3Dcad=
46000)
Stack: c018ab46 00000008 cd08fbc0 c017a806 00000000 00000000 cfec9ee8 cfe=
c9ec0=20
       c018fcd3 cd4bc180 cacbe118 d097105c d0971020 cb3289c0 cb3289c0 fff=
fffea=20
       00000001 d0971020 d0975bd3 d0978181 d09761b5 cb3289f8 cb3280c0 d09=
71020=20
Call Trace:
 [<c018ab46>] dput+0x86/0x140
 [<c017a806>] __fput+0xf6/0x170
 [<c018fcd3>] mntput_no_expire+0x13/0x70
 [<d0975bd3>] loop_ctr+0xd3/0x170 [dm_loop]
 [<c049016b>] dm_table_add_target+0x12b/0x1e0
 [<c04928c0>] populate_table+0x80/0xe0
 [<c049297e>] table_load+0x5e/0x110
 [<c0492920>] table_load+0x0/0x110
 [<c04930db>] ctl_ioctl+0xcb/0x130
 [<c0534ebc>] __up+0x1c/0x20
 [<c018595a>] do_ioctl+0x6a/0xa0
 [<c0185b1e>] vfs_ioctl+0x5e/0x1d0
 [<c0185ccd>] sys_ioctl+0x3d/0x70
 [<c0103252>] sysenter_past_esp+0x5f/0x85
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Code: d0 e8 f9 19 7b ef eb b3 8d b4 26 00 00 00 00 55 57 56 53 83 ec 38 8=
9 44 24 34 89 54 24 30 89 4c 24 2c 8b 40 04 8b 80 8c 00 00 00 <8b> 18 8b =
4b 44 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90 90 89=20
EIP: [<d097589c>] loop_setup_size+0x1c/0x1f0 [dm_loop] SS:ESP 0068:cad47e=
58
=20
after this, if i do=20
dmlosetup -d loop1
dmlosetup -d loop0

i cannot "rmmod dm-loop" , now telling me "device is in use", but it isn`=
t !=20

so, this looks like a bug to me, leaving dm-loop in an inconsitent state.


furthermore, one question about naming conventions :

dmlosetup testloop1 test.dat
dmlosetup: Could not parse loop_device testloop1
Usage:

losetup [-d|-a] [-e encryption] [-o offset] [-f|loop_device] [file]

Couldn't process command line.


so, it`s mandatory that loop_device needs to begin with "loop...." !?

regards
roland



> -----Urspr=FCngliche Nachricht-----
> Von: devzero@web.de
> Gesendet: 20.01.07 15:57:23
> An: breeves@redhat.com
> CC: dm-devel@redhat.com
> Betreff: Re: Re: device mapper integrated loops - and one more year !


> Hello Bryn,=20
>=20
>=20
> >I'll see if we can get a revised version of the current patch for wide=
r
> >testing in the next couple of weeks - let me know if you would be
> >interested in trying this out.
>=20
> not sure if i sent a reply to this or have missed this -  but, yes - i`=
m still interested very much in using dm-loop !
>=20
> is there anything new with this?
> do i have to expect issues with files >2gb ? (i need to loopback mount =
dvd iso-images)
>=20
> is there a download url for the latest dm-loop patch so i can do some t=
ests and report feedback ?
>=20
> i couldn`t find it at http://sources.redhat.com/cgi-bin/cvsweb.cgi/devi=
ce-mapper/?cvsroot=3Ddm  and i`m not sure if i should take that one from =
http://kernel.org/pub/linux/kernel/people/agk/patches/2.6/
>=20
> TIA
> roland
>=20
>=20
>=20
> > Hello !
> >=20
> > after desparately seeking for a solution to have more than 256 loop
> > devices (for a huge cd-rom server), i have recently come across
> > dm-loop, which looks very promising (to replace loop.c)
> >=20
> > can i have more than 256 devices which this?
>=20
> Hi Roland,
>=20
> Yes, dm-loop will support as many loop devices as device-mapper can all=
ow.
>=20
> > our cd-rom server is going to have more than 256 iso-images soon and
> > i need to upgrade to a more recent OS, anyway, so this won`t be a=20
> > problem that dm-loop is so brand new.
> >=20
> > but - any timeline for dm-loop mainline inclusion ?
> >=20
> > should i wait for 2.6.19 or 2.6.20 ?
>=20
> There isn't a fixed timeline. We are currently working to improve the
> lookup code - the prototype patch uses a linear search which doesn't
> scale well for large/fragmented image files. I have some tests running
> at the moment and we hope to have something soon - the results so far
> are good, it's just a case of selecting between a couple of different
> methods.
>=20
> The changes dm-loop requires in device-mapper core are pretty minor and
> have already been merged in 2.6.19, so it's just the dm-loop patch
> itself remaining.
>=20
> > is it already useable with less recent kernels, i.e. can i download
> > dm-loop patch and recent dmsetup tool and use with older kernel ?
>=20
> This should work fine - there are a couple of known issues with the
> existing patch, but unless you are using large images (>2G), or have a
> severely fragmented filesystem you shouldn't run into these.
>=20
> I'll see if we can get a revised version of the current patch for wider
> testing in the next couple of weeks - let me know if you would be
> interested in trying this out.
>=20
> Thanks,
>=20
> Bryn.


_____________________________________________________________________
Der WEB.DE SmartSurfer hilft bis zu 70% Ihrer Onlinekosten zu sparen!
http://smartsurfer.web.de/?mc=3D100071&distributionid=3D000000000066
