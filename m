From: Doug Dumitru <doug@easyco.com>
Subject: Re: A small question about Device Mapper
Date: Sun, 23 Aug 2015 08:01:47 -0700
Message-ID: <CAFx4rwRHKQ5JQmXE3MtDZysU+BtbYO8XLZSGq069Cgjkzgg5TQ@mail.gmail.com>
References: <91E2D863603AD4478F101CE81E76E45D01D2D23C@SHSMSX103.ccr.corp.intel.com>
Reply-To: doug@easyco.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0828087031151750887=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <91E2D863603AD4478F101CE81E76E45D01D2D23C@SHSMSX103.ccr.corp.intel.com>
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

--===============0828087031151750887==
Content-Type: multipart/alternative; boundary=bcaec5486056684559051dfbc96e

--bcaec5486056684559051dfbc96e
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Xun,

This is a little off-topic for this list.  Device mapper is the low level
structure to create the devices.  Configuration is done in user space and
is more a topic for system startup people (is there a sysinit list?).

Regardless, I will try to help.

Exactly how and where you do this depends a lot of your environment and
when you need the dm device to become available.  You basically have to
include your dmsetup command in the startup scripts early enough to meet
your needs.

In some cases, this might be all the way into initramfs (or initrd
depending on your distro).  This would start the dm device before even your
root file system mounted.

You might be able to start the device later, which implies a system
"service" that runs as a part of the boot.  If you can take the start very
late, you might want to consider just adding it to rc.local (most distros
still support this), which runs last.  This would go into
/etc/init.d/rc.local (again, your distro may vary).

Doug

On Sun, Aug 23, 2015 at 12:29 AM, Ni, Xun <xun.ni@intel.com> wrote:

> Hi, all:
>
> I use device mapper to config a thin-provision for a block device, with
> dmsetup, with the following command:
>
> Dmsetup create pool =E2=80=93table =E2=80=9C0 `blockdev =E2=80=93getsize =
/dev/sdd1` thin-pool
> /dev/sdd2 /dev/sdd1 128 0=E2=80=9D
> Dmsetup message /dev/mapper/pool 0 =E2=80=9Ccreate_thin 0=E2=80=9D
> Dmsetup create snap1 =E2=80=93tabe =E2=80=9C0 `blockdev =E2=80=93getsize =
/dev/sdd3` thin
> /dev/mapper/pool 0 /dev/sdd3=E2=80=9D
>
> Everything works well, but when I reboot the system, the block device is
> gone, I need to create the pool again=E2=80=A6
>
> Anyone has idea on how to make this config persistent?  I need to boot th=
e
> kernel , the dm pool device shows after the MD device found.
>
> Thanks,
> Xun
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>



--=20
Doug Dumitru
EasyCo LLC

--bcaec5486056684559051dfbc96e
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif;font-size:small">Xun,<br><br></div><div class=3D"gmail_d=
efault" style=3D"font-family:arial,helvetica,sans-serif;font-size:small">Th=
is is a little off-topic for this list.=C2=A0 Device mapper is the low leve=
l structure to create the devices.=C2=A0 Configuration is done in user spac=
e and is more a topic for system startup people (is there a sysinit list?).=
<br><br></div><div class=3D"gmail_default" style=3D"font-family:arial,helve=
tica,sans-serif;font-size:small">Regardless, I will try to help.<br><br></d=
iv><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-s=
erif;font-size:small">Exactly how and where you do this depends a lot of yo=
ur environment and when you need the dm device to become available.=C2=A0 Y=
ou basically have to include your dmsetup command in the startup scripts ea=
rly enough to meet your needs.<br><br>In some cases, this might be all the =
way into initramfs (or initrd depending on your distro).=C2=A0 This would s=
tart the dm device before even your root file system mounted.<br><br></div>=
<div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-seri=
f;font-size:small">You might be able to start the device later, which impli=
es a system &quot;service&quot; that runs as a part of the boot.=C2=A0 If y=
ou can take the start very late, you might want to consider just adding it =
to rc.local (most distros still support this), which runs last.=C2=A0 This =
would go into /etc/init.d/rc.local (again, your distro may vary).<br><br></=
div><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-=
serif;font-size:small">Doug<br></div></div><div class=3D"gmail_extra"><br><=
div class=3D"gmail_quote">On Sun, Aug 23, 2015 at 12:29 AM, Ni, Xun <span d=
ir=3D"ltr">&lt;<a href=3D"mailto:xun.ni@intel.com" target=3D"_blank">xun.ni=
@intel.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">






<div>
<font face=3D"Calibri" size=3D"2"><span style=3D"font-size:11pt">
<div>Hi, all:</div>
<div>=C2=A0</div>
<div style=3D"text-indent:9.6pt">I use device mapper to config a thin-provi=
sion for a block device, with dmsetup, with the following command:</div>
<div style=3D"text-indent:9.6pt">=C2=A0</div>
<div style=3D"text-indent:9.6pt">Dmsetup create pool =E2=80=93table =E2=80=
=9C0 `blockdev =E2=80=93getsize /dev/sdd1` thin-pool /dev/sdd2 /dev/sdd1 12=
8 0=E2=80=9D</div>
<div style=3D"text-indent:9.6pt">Dmsetup message /dev/mapper/pool 0 =E2=80=
=9Ccreate_thin 0=E2=80=9D</div>
<div style=3D"text-indent:9.6pt">Dmsetup create snap1 =E2=80=93tabe =E2=80=
=9C0 `blockdev =E2=80=93getsize /dev/sdd3` thin /dev/mapper/pool 0 /dev/sdd=
3=E2=80=9D</div>
<div style=3D"text-indent:9.6pt">=C2=A0</div>
<div style=3D"text-indent:9.6pt">Everything works well, but when I reboot t=
he system, the block device is gone, I need to create the pool again=E2=80=
=A6</div>
<div style=3D"text-indent:9.6pt">=C2=A0</div>
<div style=3D"text-indent:9.6pt">Anyone has idea on how to make this config=
 persistent?=C2=A0 I need to boot the kernel , the dm pool device shows aft=
er the MD device found.</div>
<div><font face=3D"Times New Roman">=C2=A0</font></div>
<div>Thanks,</div>
<div>Xun </div>
<div><font face=3D"Times New Roman">=C2=A0</font></div>
</span></font>
</div>

<br>--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a>=
<br></blockquote></div><br><br clear=3D"all"><br>-- <br><div class=3D"gmail=
_signature">Doug Dumitru<br>EasyCo LLC<br></div>
</div>

--bcaec5486056684559051dfbc96e--


--===============0828087031151750887==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0828087031151750887==--
