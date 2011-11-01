From: Sanjana Shari <sanjana.linux@gmail.com>
Subject: Re: creating two device mapper files for an underline
	blockdevice
Date: Tue, 1 Nov 2011 11:40:43 +0530
Message-ID: <CABMcfaOvUyg95vLc=dq05nSvfqDBtNvGnHNsa5qQ+DrpHN1yZQ@mail.gmail.com>
References: <CABMcfaMVsagfFdtg+f1eYR501wWSMbxsEAHTYD_5MTF1bABu0A@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0602107623656588787=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABMcfaMVsagfFdtg+f1eYR501wWSMbxsEAHTYD_5MTF1bABu0A@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: sanjana.linux@gmail.com
List-Id: dm-devel.ids

--===============0602107623656588787==
Content-Type: multipart/alternative; boundary=bcaec548a81b25bab804b0a63752

--bcaec548a81b25bab804b0a63752
Content-Type: text/plain; charset=ISO-8859-1

Please do put me in cc list while replying.

On Tue, Nov 1, 2011 at 11:38 AM, Sanjana Shari <sanjana.linux@gmail.com>wrote:

> Hello,
>
> I am trying to create two device mapper files for an underline
> blockdevice. One file( half1) will be mapped to the first half of the
> block-device. and the second half (half2) will be mapped to the rest of the
> space in the same block device.
>
> 1.Using dd command I have created a 100 MB file.
>
> # dd if=/dev/zero of=dm_test bs=512 count=204800
>
> 2. associated it with loop device:
> # losetup /dev/loop0 /tmp/dm_test
>
> # blockdev --getsize /dev/loop0
> 204800
>
> using dmsetup to create dm file.
> # dmsetup create half --table "0 102400 linear /dev/loop0 0"
>
> [root@bladelinux01 root]# dmsetup table half
> 0 102400 linear 7:0 0
> [root@bladelinux01 root]# dmsetup info half
> Name:              half
> State:             ACTIVE
> Read Ahead:        256
> Tables present:    LIVE
> Open count:        0
> Event number:      0
> Major, minor:      253, 6
> Number of targets: 1
>
>
> [root@bladelinux01 root]# ls -l /dev/mapper/half
> lrwxrwxrwx. 1 root root 7 Nov  1 01:44 /dev/mapper/half -> ../dm-6
>
> But if I use the other part of the disk to map. The command is not
> successful
>
> [root@bladelinux01 root]#  dmsetup create half1 --table "102401 102399
> linear /dev/loop0 102400"
> device-mapper: reload ioctl failed: Invalid argument
> Command failed
>
> [root@bladelinux01 root]#  dmsetup create half1 --table "102401 102399
> linear /dev/loop0 0"
> device-mapper: reload ioctl failed: Invalid argument
> Command failed
>
> The format used seems to be correct according to the man page of dmsetup.
> Please guide me. I am not sure what am I missing.
>
> -- sanjana
>
>

--bcaec548a81b25bab804b0a63752
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Please do put me in cc list while replying.<br><br><div class=3D"gmail_quot=
e">On Tue, Nov 1, 2011 at 11:38 AM, Sanjana Shari <span dir=3D"ltr">&lt;<a =
href=3D"mailto:sanjana.linux@gmail.com">sanjana.linux@gmail.com</a>&gt;</sp=
an> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex;"><span style=3D"font-family:courier new,mono=
space">Hello,</span><br style=3D"font-family:courier new,monospace"><br sty=
le=3D"font-family:courier new,monospace">
<span style=3D"font-family:courier new,monospace">I am trying to create two=
 device mapper files for an underline blockdevice. One file( half1) will be=
 mapped to the first half of the block-device. and the second half (half2) =
will be mapped to the rest of the space in the same block device.</span><br=
 style=3D"font-family:courier new,monospace">

<br style=3D"font-family:courier new,monospace"><span style=3D"font-family:=
courier new,monospace">1.Using dd command I have created a 100 MB file.</sp=
an><br style=3D"font-family:courier new,monospace"><br style=3D"font-family=
:courier new,monospace">

<span style=3D"font-family:courier new,monospace"># dd if=3D/dev/zero of=3D=
dm_test bs=3D512 count=3D204800</span><br style=3D"font-family:courier new,=
monospace"><br style=3D"font-family:courier new,monospace"><span style=3D"f=
ont-family:courier new,monospace">2. associated it with loop device:</span>=
<br style=3D"font-family:courier new,monospace">

<span style=3D"font-family:courier new,monospace"># losetup /dev/loop0 /tmp=
/dm_test</span><br style=3D"font-family:courier new,monospace"><br style=3D=
"font-family:courier new,monospace"><span style=3D"font-family:courier new,=
monospace"># blockdev --getsize /dev/loop0</span><br style=3D"font-family:c=
ourier new,monospace">

<span style=3D"font-family:courier new,monospace">204800</span><br style=3D=
"font-family:courier new,monospace"><br style=3D"font-family:courier new,mo=
nospace"><span style=3D"font-family:courier new,monospace">using dmsetup to=
 create dm file.</span><br style=3D"font-family:courier new,monospace">

<span style=3D"font-family:courier new,monospace"># dmsetup create half --t=
able &quot;0 102400 linear /dev/loop0 0&quot;</span><br style=3D"font-famil=
y:courier new,monospace"><br style=3D"font-family:courier new,monospace">
<span style=3D"font-family:courier new,monospace">[root@bladelinux01 root]#=
 dmsetup table half</span><br style=3D"font-family:courier new,monospace"><=
span style=3D"font-family:courier new,monospace">0 102400 linear 7:0 0</spa=
n><br style=3D"font-family:courier new,monospace">

<span style=3D"font-family:courier new,monospace">[root@bladelinux01 root]#=
 dmsetup info half</span><br style=3D"font-family:courier new,monospace"><s=
pan style=3D"font-family:courier new,monospace">Name:=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 half</span><br style=3D"font-family:courier new,monospac=
e">

<span style=3D"font-family:courier new,monospace">State:=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 ACTIVE</span><br style=3D"font-family:courier new,monosp=
ace"><span style=3D"font-family:courier new,monospace">Read Ahead:=A0=A0=A0=
=A0=A0=A0=A0 256</span><br style=3D"font-family:courier new,monospace">

<span style=3D"font-family:courier new,monospace">Tables present:=A0=A0=A0 =
LIVE</span><br style=3D"font-family:courier new,monospace"><span style=3D"f=
ont-family:courier new,monospace">Open count:=A0=A0=A0=A0=A0=A0=A0 0</span>=
<br style=3D"font-family:courier new,monospace">

<span style=3D"font-family:courier new,monospace">Event number:=A0=A0=A0=A0=
=A0 0</span><br style=3D"font-family:courier new,monospace"><span style=3D"=
font-family:courier new,monospace">Major, minor:=A0=A0=A0=A0=A0 253, 6</spa=
n><br style=3D"font-family:courier new,monospace">

<span style=3D"font-family:courier new,monospace">Number of targets: 1</spa=
n><br style=3D"font-family:courier new,monospace"><br style=3D"font-family:=
courier new,monospace"><br style=3D"font-family:courier new,monospace">
<span style=3D"font-family:courier new,monospace">[root@bladelinux01 root]#=
 ls -l /dev/mapper/half</span><br style=3D"font-family:courier new,monospac=
e"><span style=3D"font-family:courier new,monospace">lrwxrwxrwx. 1 root roo=
t 7 Nov=A0 1 01:44 /dev/mapper/half -&gt; ../dm-6</span><br style=3D"font-f=
amily:courier new,monospace">

<br style=3D"font-family:courier new,monospace"><span style=3D"font-family:=
courier new,monospace">But if I use the other part of the disk to map. The =
command is not successful</span><br style=3D"font-family:courier new,monosp=
ace">

<br style=3D"font-family:courier new,monospace"><span style=3D"font-family:=
courier new,monospace">[root@bladelinux01 root]#=A0 dmsetup create half1 --=
table &quot;102401 102399 linear /dev/loop0 102400&quot;</span><br style=3D=
"font-family:courier new,monospace">

<span style=3D"font-family:courier new,monospace">device-mapper: reload ioc=
tl failed: Invalid argument</span><br style=3D"font-family:courier new,mono=
space"><span style=3D"font-family:courier new,monospace">Command failed</sp=
an><br style=3D"font-family:courier new,monospace">

<br style=3D"font-family:courier new,monospace"><span style=3D"font-family:=
courier new,monospace">[root@bladelinux01 root]#=A0 dmsetup create half1 --=
table &quot;102401 102399 linear /dev/loop0 0&quot;</span><br style=3D"font=
-family:courier new,monospace">

<span style=3D"font-family:courier new,monospace">device-mapper: reload ioc=
tl failed: Invalid argument</span><br style=3D"font-family:courier new,mono=
space"><span style=3D"font-family:courier new,monospace">Command failed</sp=
an><br style=3D"font-family:courier new,monospace">

<br style=3D"font-family:courier new,monospace"><span style=3D"font-family:=
courier new,monospace">The format used seems to be correct according to the=
 man page of dmsetup. Please guide me. I am not sure what am I missing</spa=
n>.<br>
<font color=3D"#888888">
<br>-- sanjana<br><br>
</font></blockquote></div><br>

--bcaec548a81b25bab804b0a63752--


--===============0602107623656588787==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0602107623656588787==--
