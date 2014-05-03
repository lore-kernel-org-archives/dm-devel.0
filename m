From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: sg_persist triggers block kernel event ???
Date: Sat, 3 May 2014 22:38:38 +0200
Message-ID: <CABr-Gne=kRCJ4qNz9Vuz-u-gmj1g9Htm3oqUBdoOvFCv9=5bNQ@mail.gmail.com>
References: <CABr-GnczryXtOkip_0L+0ztU2RcJ5izbucgs0GHo3DX7OFAMtg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6325875164327752783=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABr-GnczryXtOkip_0L+0ztU2RcJ5izbucgs0GHo3DX7OFAMtg@mail.gmail.com>
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

--===============6325875164327752783==
Content-Type: multipart/alternative; boundary=90e6ba613c3a0bae4104f884e266

--90e6ba613c3a0bae4104f884e266
Content-Type: text/plain; charset=UTF-8

Reproduced on a fairly recent kernel :

cvaroqui@clementine:~$ sudo sg_persist -k /dev/sda
  ATA       SAMSUNG MZMTD512  DXT4
  Peripheral device type: disk
PR in: command not supported

KERNEL[227056.238465] change
/devices/pci0000:00/0000:00:1f.2/ata2/host1/target1:0:0/1:0:0:0/block/sda
(block)
ACTION=change
DEVNAME=/dev/sda
DEVPATH=/devices/pci0000:00/0000:00:1f.2/ata2/host1/target1:0:0/1:0:0:0/block/sda
DEVTYPE=disk
MAJOR=8
MINOR=0
SEQNUM=2603
SUBSYSTEM=block

cvaroqui@clementine:~$ cat /etc/lsb-release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=14.04
DISTRIB_CODENAME=trusty
DISTRIB_DESCRIPTION="Ubuntu Trusty Tahr (development branch)"

cvaroqui@clementine:~$ uname -a
Linux clementine 3.13.0-23-generic #45-Ubuntu SMP Fri Apr 4 06:58:38 UTC
2014 x86_64 x86_64 x86_64 GNU/Linux

Regards,
Christophe Varoqui
www.opensvc.com


On Sat, May 3, 2014 at 10:12 PM, Christophe Varoqui <
christophe.varoqui@opensvc.com> wrote:

> Hi list,
>
> I observe this on a debian 7.5 server with a udevadm monitor running in
> the background :
>
> # sg_persist -n -k /dev/sdbh
>   PR generation=0x0, there are NO registered reservation keys
>
> KERNEL[448809.342461] change
> /devices/pci0000:20/0000:20:02.2/0000:24:00.0/host0/rport-0:0-3/target0:0:1/0:0:1:12/block/sdbh
> (block)
> ACTION=change
> DEVNAME=/dev/sdbh
>
> DEVPATH=/devices/pci0000:20/0000:20:02.2/0000:24:00.0/host0/rport-0:0-3/target0:0:1/0:0:1:12/block/sdbh
> DEVTYPE=disk
> MAJOR=67
> MINOR=176
> SEQNUM=261605
> SUBSYSTEM=block
>
> Every sg_persist command, with any options, trigger events.
>
> On this server with more than 200 scsi devices, each receiving one
> read-key and one read-reservation every 10 minutes, this triggers quite a
> eavy load caused by 2 udev triggers :
>
> 1/ multipath -v0 $devpath
> 2/ udisks-lvm-pv-export $pv_uuid
>
>
> Question is, is it normal for a "--in" sg_persist command to trigger a
> change event on the scsi device ? If not, what we can do about it ?
>
> Best regards,
> Christophe Varoqui
> www.opensvc.com
>
>

--90e6ba613c3a0bae4104f884e266
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Reproduced on a fairly recent kernel :<div><br></div><div>=
<div>cvaroqui@clementine:~$ sudo sg_persist -k /dev/sda</div><div>=C2=A0 AT=
A =C2=A0 =C2=A0 =C2=A0 SAMSUNG MZMTD512 =C2=A0DXT4</div><div>=C2=A0 Periphe=
ral device type: disk</div><div>
PR in: command not supported</div><div><br></div><div>KERNEL[227056.238465]=
 change =C2=A0 /devices/pci0000:00/0000:00:1f.2/ata2/host1/target1:0:0/1:0:=
0:0/block/sda (block)</div><div>ACTION=3Dchange</div><div>DEVNAME=3D/dev/sd=
a</div>
<div>DEVPATH=3D/devices/pci0000:00/0000:00:1f.2/ata2/host1/target1:0:0/1:0:=
0:0/block/sda</div><div>DEVTYPE=3Ddisk</div><div>MAJOR=3D8</div><div>MINOR=
=3D0</div><div>SEQNUM=3D2603</div><div>SUBSYSTEM=3Dblock</div><div><br></di=
v><div>cvaroqui@clementine:~$ cat /etc/lsb-release=C2=A0<br>
</div><div>DISTRIB_ID=3DUbuntu</div><div>DISTRIB_RELEASE=3D14.04</div><div>=
DISTRIB_CODENAME=3Dtrusty</div><div>DISTRIB_DESCRIPTION=3D&quot;Ubuntu Trus=
ty Tahr (development branch)&quot;</div><div><br></div><div>cvaroqui@clemen=
tine:~$ uname -a</div>
<div>Linux clementine 3.13.0-23-generic #45-Ubuntu SMP Fri Apr 4 06:58:38 U=
TC 2014 x86_64 x86_64 x86_64 GNU/Linux</div></div><div><br></div><div>Regar=
ds,</div><div>Christophe Varoqui</div><div><a href=3D"http://www.opensvc.co=
m">www.opensvc.com</a></div>
</div><div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">On Sat,=
 May 3, 2014 at 10:12 PM, Christophe Varoqui <span dir=3D"ltr">&lt;<a href=
=3D"mailto:christophe.varoqui@opensvc.com" target=3D"_blank">christophe.var=
oqui@opensvc.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div dir=3D"ltr">Hi list,<div><br></div><div=
>I observe this on a debian 7.5 server with a udevadm monitor running in th=
e background :</div>
<div><br></div><div><div># sg_persist -n -k /dev/sdbh</div><div>=C2=A0 PR g=
eneration=3D0x0, there are NO registered reservation keys</div>
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
 href=3D"http://www.opensvc.com" target=3D"_blank">www.opensvc.com</a></div=
><div><br></div></div>
</blockquote></div><br></div>

--90e6ba613c3a0bae4104f884e266--


--===============6325875164327752783==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6325875164327752783==--
