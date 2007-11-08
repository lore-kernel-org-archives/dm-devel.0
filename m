From: devzero@web.de
Subject: device-errors and multipath device access issue
Date: Thu, 08 Nov 2007 10:21:03 +0100
Message-ID: <2072641508@web.de>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello !

we are using multipath on sles9 and access those devices via /dev/mapper/=
devicename

on boot, we get lot`s of error messages like

> Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical b=
lock 64239
> Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical b=
lock 64240
> Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical b=
lock 64241
> Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical b=
lock 64242
> Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical b=
lock 64243
> Aug 28 10:30:16 rac02 kernel: Device sdf not ready.
> Aug 28 10:30:16 rac02 kernel: end_request: I/O error, dev sdf, sector 5=
13824
> Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical b=
lock 64228
> Aug 28 10:30:16 rac02 kernel: Device sdf not ready.
> Aug 28 10:30:16 rac02 kernel: end_request: I/O error, dev sdf, sector 5=
13824
> Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical b=
lock 64228
> Aug 28 10:30:16 rac02 kernel: Device sdf not ready.
> Aug 28 10:30:16 rac02 kernel: end_request: I/O error, dev sdf, sector 5=
14064
> Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical b=
lock 64258
> Aug 28 10:30:16 rac02 kernel: Device sdf not ready.
> Aug 28 10:30:16 rac02 kernel: end_request: I/O error, dev sdf, sector 5=
13680
> Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical b=
lock 64210
> Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical b=
lock 64211
> Aug 28 10:30:16 rac02 kernel: Buffer I/O error on device sdf, logical b=
lock 64212

for each alternative path to a lun.

we also get those messages when the system is up and running because some=
 proprietary monitoring software is checking for device availability in r=
egular intervals and there seems no way to tell that software to skip cer=
tain devices - so we get spammed with this messages like this in /var/log=
/messages and are not able to see the real errors anymore.

is there a way to hide those "classic" scsi devices from userspace?
i`m not sure if "blacklist" in multipath.conf is what i need here (?) or =
if i safely could delete those device-nodes - i`m not very deep into mult=
ipathing for now.


furthermore, we have some strange problem with ocfs2 i tracked down to /e=
tc/init.d/boot.multipath.
sometimes (e.g. after adding a LUN in the SAN) cannot start anymore, beca=
use the device-mapper "links" to the partitions on the multipath device a=
re inaccessible.

eg we have

/dev/mapper/000123largenumber456
/dev/mapper/000123largenumber789
/dev/mapper/000123largenumber456p1
/dev/mapper/000123largenumber456p2
/dev/mapper/000123largenumber456p3
/dev/mapper/000123largenumber456p4

the first 2 devices show recent timestamp, but the p# devices show old ti=
mestamp and aren`t accessible after reboot.
if we reboot a second or third time, this helps sometimes - also manually=
 restarting multipath seems to help and the partitions get accessible aga=
in.

looks like they are setup with kpartx from within boot.multipath on every=
 reboot and this goes wrong under certain circumstances because the devic=
e is not ready when kpartx want`s access that device.=20

i found some reference at=20
http://bugs.donarmstrong.com/cgi-bin/bugreport.cgi?bug=3D376161
and it looks similar:

>I think that the problem is that multipath is too slow creating the devi=
ces and
>udev is too fast launching kpartx.

in that bugreport it`s being told that  multipath-tools (0.4.7-8) has a f=
ix, but i don`t get the point what`s the exact problem and what is being =
fixed=20

>   * since Debian's dmestup doesn't include the "export" patch used by o=
ther
>     distros (#434241), work around this by implementing a minimal dmset=
up_env
>     that can be used by kpartx.udev (Closes: #376161)


in our case, kpartx doesn`t seem to be launched by udev but from within b=
oot.multipath, but it looks like a timing issue because it sometimes happ=
ens and sometimes not.

any help or some input (links?docs?) to enlighten me would be highly appr=
eciated

thank you!

roland
sysadmin

ps:
please forgive if these questions sound a little bit dumb and unexperienc=
ed - i didn`t setup that environment and it also lacks documentations, bu=
t i want to help some other people solving these problems.






_______________________________________________________________________
Jetzt neu! Sch=FCtzen Sie Ihren PC mit McAfee und WEB.DE. 3 Monate
kostenlos testen. http://www.pc-sicherheit.web.de/startseite/?mc=3D022220
