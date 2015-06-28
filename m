From: Doug Dumitru <doug@easyco.com>
Subject: Re: Device Mapper Persistent Configuration
Date: Sun, 28 Jun 2015 10:18:46 -0700
Message-ID: <CAFx4rwRQmB7EoxWOPRxqKgJ6mJPYcvVC7c58Q1aipec=Yz_u3Q@mail.gmail.com>
References: <DUB115-W2767FC5A5D22E9D12ADFB596AB0@phx.gbl>
Reply-To: doug@easyco.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4421407946300985344=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <DUB115-W2767FC5A5D22E9D12ADFB596AB0@phx.gbl>
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

--===============4421407946300985344==
Content-Type: multipart/alternative; boundary=20cf3078151c39b4cc0519972cec

--20cf3078151c39b4cc0519972cec
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 28, 2015 at 8:21 AM, Gili B <gilib123@hotmail.com> wrote:

> hi
> We are starting working on a new device mapper module which has targets
> similar
> to the ones in thin module (pool and thin),  but it adds some additional
> features.
> The user should be able to create and use file systems on the thin volume=
s.
> I wanted to know what is the recommended  way to make the configuration
> with dmsetup
> persistent ?
>

=E2=80=8BYou should probably use mdraid as an inspiration.  Put a signature=
 block
on every member device.  You can then write a user-space tool to scan
devices and find the collections.  Be sure to use a good "signature" for
your type of device, plus a good UUID signature so that different
generations can be identified.
=E2=80=8B


> We want that all file systems will be available after reboot.
>

=E2=80=8BIf you get the device running early enough, then fstab should be a=
ble to
mount file systems.
=E2=80=8B


> Should we write our own configuration tool?  should we add special
> configuration files?
>

=E2=80=8BYou will probably need a user-space tool.  You can probably get aw=
ay with
no configuration file, but you should again use mdraid as inspiration so
that your user-space tool gets limits of where to look for member pieces.
=E2=80=8B


> Should the kernel module we write , automatically discover all the
> configration and initialize accordingly?
>
>
> Regarding debug - Is there a generic way to run dmsetup for example that
> prints some inside details on the targets? (for example number of
> outstanding ios, memory used etc)
>

=E2=80=8BYou can do this three ways.  1)  build in IOCTL into your module t=
hat can
query stuff.  2) export stuff in /sys.  3) export stuff in /proc.  I
personally like exporting debug stuff into /proc.  Remember that printk is
your friend.  I have even created "command" file in proc that then dump
debug information with printk.  If you use /proc, you need to handle
multiple instances of your mapper.  I use
/proc/{my_project_name}/{instance_name}/...
=E2=80=8B


>
>
> Thanks
> -gili
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>



--=20
Doug Dumitru
EasyCo LLC

--20cf3078151c39b4cc0519972cec
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif;font-size:small"><br></div><div class=3D"gmail_extra"><b=
r><div class=3D"gmail_quote">On Sun, Jun 28, 2015 at 8:21 AM, Gili B <span =
dir=3D"ltr">&lt;<a href=3D"mailto:gilib123@hotmail.com" target=3D"_blank">g=
ilib123@hotmail.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quo=
te" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"=
>


<div><div dir=3D"ltr">hi<br>We are starting working on a new device mapper =
module which=C2=A0has targets similar<br>to the ones in thin module (pool a=
nd thin),=C2=A0 but it adds some additional features.<br>The user should be=
 able to create and use file systems on the thin volumes.<br>I wanted to kn=
ow what=C2=A0is the recommended =C2=A0way to make the configuration with dm=
setup<br>persistent ?<br></div></div></blockquote><div><br><div class=3D"gm=
ail_default" style=3D"font-family:arial,helvetica,sans-serif;font-size:smal=
l;display:inline">=E2=80=8BYou should probably use mdraid as an inspiration=
.=C2=A0 Put a signature block on every member device.=C2=A0 You can then wr=
ite a user-space tool to scan devices and find the collections.=C2=A0 Be su=
re to use a good &quot;signature&quot; for your type of device, plus a good=
 UUID signature so that different generations can be identified.<br>=E2=80=
=8B</div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 =
0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><div><div dir=3D"ltr">W=
e=C2=A0want that all file systems will be available after reboot.<br></div>=
</div></blockquote><div><br><div class=3D"gmail_default" style=3D"font-fami=
ly:arial,helvetica,sans-serif;font-size:small;display:inline">=E2=80=8BIf y=
ou get the device running early enough, then fstab should be able to mount =
file systems.<br>=E2=80=8B</div>=C2=A0</div><blockquote class=3D"gmail_quot=
e" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">=
<div><div dir=3D"ltr">Should we write our own configuration tool? =C2=A0sho=
uld we add special configuration files?<br></div></div></blockquote><div><b=
r><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-se=
rif;font-size:small;display:inline">=E2=80=8BYou will probably need a user-=
space tool.=C2=A0 You can probably get away with no configuration file, but=
 you should again use mdraid as inspiration so that your user-space tool ge=
ts limits of where to look for member pieces.<br>=E2=80=8B</div>=C2=A0</div=
><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1=
px #ccc solid;padding-left:1ex"><div><div dir=3D"ltr">Should the kernel mod=
ule we write , automatically discover all the configration and initialize a=
ccordingly?<br>=C2=A0<br>=C2=A0<br>Regarding debug - Is there a generic way=
 to run dmsetup for example that<br>prints some inside details on the targe=
ts? (for example number of outstanding ios, memory used etc)<br></div></div=
></blockquote><div><br><div class=3D"gmail_default" style=3D"font-family:ar=
ial,helvetica,sans-serif;font-size:small;display:inline">=E2=80=8BYou can d=
o this three ways.=C2=A0 1)=C2=A0 build in IOCTL into your module that can =
query stuff.=C2=A0 2) export stuff in /sys.=C2=A0 3) export stuff in /proc.=
=C2=A0 I personally like exporting debug stuff into /proc.=C2=A0 Remember t=
hat printk is your friend.=C2=A0 I have even created &quot;command&quot; fi=
le in proc that then dump debug information with printk.=C2=A0 If you use /=
proc, you need to handle multiple instances of your mapper.=C2=A0 I use /pr=
oc/{my_project_name}/{instance_name}/...<br>=E2=80=8B</div>=C2=A0</div><blo=
ckquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #c=
cc solid;padding-left:1ex"><div><div dir=3D"ltr">=C2=A0<br>=C2=A0<br>Thanks=
<span class=3D"HOEnZb"><font color=3D"#888888"><br>-gili<br> 		 	   		  </f=
ont></span></div></div>
<br>--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a>=
<br></blockquote></div><br><br clear=3D"all"><br>-- <br><div class=3D"gmail=
_signature">Doug Dumitru<br>EasyCo LLC<br></div>
</div></div>

--20cf3078151c39b4cc0519972cec--


--===============4421407946300985344==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4421407946300985344==--
