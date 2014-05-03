From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: sg_persist triggers block kernel event ???
Date: Sat, 3 May 2014 22:12:03 +0200
Message-ID: <CABr-GnczryXtOkip_0L+0ztU2RcJ5izbucgs0GHo3DX7OFAMtg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5217473451485505306=="
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

--===============5217473451485505306==
Content-Type: multipart/alternative; boundary=089e01182d0a007ad604f884836c

--089e01182d0a007ad604f884836c
Content-Type: text/plain; charset=UTF-8

Hi list,

I observe this on a debian 7.5 server with a udevadm monitor running in the
background :

# sg_persist -n -k /dev/sdbh
  PR generation=0x0, there are NO registered reservation keys

KERNEL[448809.342461] change
/devices/pci0000:20/0000:20:02.2/0000:24:00.0/host0/rport-0:0-3/target0:0:1/0:0:1:12/block/sdbh
(block)
ACTION=change
DEVNAME=/dev/sdbh
DEVPATH=/devices/pci0000:20/0000:20:02.2/0000:24:00.0/host0/rport-0:0-3/target0:0:1/0:0:1:12/block/sdbh
DEVTYPE=disk
MAJOR=67
MINOR=176
SEQNUM=261605
SUBSYSTEM=block

Every sg_persist command, with any options, trigger events.

On this server with more than 200 scsi devices, each receiving one read-key
and one read-reservation every 10 minutes, this triggers quite a eavy load
caused by 2 udev triggers :

1/ multipath -v0 $devpath
2/ udisks-lvm-pv-export $pv_uuid


Question is, is it normal for a "--in" sg_persist command to trigger a
change event on the scsi device ? If not, what we can do about it ?

Best regards,
Christophe Varoqui
www.opensvc.com

--089e01182d0a007ad604f884836c
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi list,<div><br></div><div>I observe this on a debian 7.5=
 server with a udevadm monitor running in the background :</div><div><br></=
div><div><div># sg_persist -n -k /dev/sdbh</div><div>=C2=A0 PR generation=
=3D0x0, there are NO registered reservation keys</div>
<div><br></div><div>KERNEL[448809.342461] change =C2=A0 /devices/pci0000:20=
/0000:20:02.2/0000:24:00.0/host0/rport-0:0-3/target0:0:1/0:0:1:12/block/sdb=
h (block)</div><div>ACTION=3Dchange</div><div>DEVNAME=3D/dev/sdbh</div><div=
>DEVPATH=3D/devices/pci0000:20/0000:20:02.2/0000:24:00.0/host0/rport-0:0-3/=
target0:0:1/0:0:1:12/block/sdbh</div>
<div>DEVTYPE=3Ddisk</div><div>MAJOR=3D67</div><div>MINOR=3D176</div><div>SE=
QNUM=3D261605</div><div>SUBSYSTEM=3Dblock</div></div><div><br></div><div>Ev=
ery sg_persist command, with any options, trigger events.</div><div><br></d=
iv><div>
On this server with more than 200 scsi devices, each receiving one read-key=
 and one read-reservation every 10 minutes, this triggers quite a eavy load=
 caused by 2 udev triggers :</div><div><br></div><div>1/ multipath -v0 $dev=
path</div>
<div>2/=C2=A0udisks-lvm-pv-export $pv_uuid</div><div><br></div><div><br></d=
iv><div>Question is, is it normal for a &quot;--in&quot; sg_persist command=
 to trigger a change event on the scsi device ? If not, what we can do abou=
t it ?</div>
<div><br></div><div>Best regards,</div><div>Christophe Varoqui</div><div><a=
 href=3D"http://www.opensvc.com">www.opensvc.com</a></div><div><br></div></=
div>

--089e01182d0a007ad604f884836c--


--===============5217473451485505306==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5217473451485505306==--
