From: "V.Kukushkin" <vlkukushkin@yandex.ru>
Subject: HOW to install software to mapped device persistently
Date: Thu, 01 Jun 2006 14:11:43 +0400
Message-ID: <optago9tmrbp19rg@devel.lan.internet2.ru>
Reply-To: vlkukushkin@yandex.ru,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; delsp=yes; charset=windows-1251
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

Hi

All we know the good way to make read-only ROOT device be read-write =20
looking.
It is the use of dmsetup in initrd. It works perfect. But ..

Question1: HOW to install software to this mapped device persistently ?

For example, if you need to upgrade something and ROOT device is read-wri=
te
in fact (e.g. flash) but used as read-only for safety.

I tried to do this by sequence of commands:
(/dev/hdc1 "snapshotted" to / by devmapper)
# mount /dev/hdc1 /mnt/disk
# chroot /mnt/disk
# rpm -Uv <pkg> or whateveer else
# exit
# umount /mnt/disk
Of course, my changes were not seen from "/" because mapper know nothing
about that changes. So, I need to reboot the system to make changes =20
visible.
Another and more clear way is to reboot to standard
configuration (without device mapper)and install/update software,
then reboot again to devmapper configuration. Both these ways are =20
inacceptible
in production system.

Question2: How to make devmapper to know that base (snapshot'ed) device =20
have
been changed ?

1( My thoughs was to remap root from snapshot to disk, upgrade software =20
and remap
root back to snapshot. It doesn't work.
2( We may delete snapshot and snapshot-orig and disk mappings, then =20
upgrade soft, then restore
snapshotting back. It doen't work also.

The case, I think, in initrd nature of mapping. I.e. mapping devices are
in /inird/dev/mapper instead of /dev/mapper.
My device-mapper configuration as following (by initrd)
--
root-orig: 0 430048 snapshot-origin 254:000
ram: 0 430048 linear 007:000 0
root: 0 430048 snapshot 254:000 254:001 P 8
hd: 0 430048 linear 022:001 0
--
"hd" - base device (compact flash in my case, /dev/hdc1)
"ram" - temporary loop device on file in ramfs.
"root" - snapshot of "hd" to "ram"
"root-orig" - snapshot-orig to "hd"
Rootfs mounted on /dev/mapper/root.

Question3stupid: Where rootfs must be mounted - on /dev/mapper/root or =20
/dev/mapper/root-orig ?
--=20
regards,
Vladimir
