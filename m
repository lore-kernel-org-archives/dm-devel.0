From: =?ISO-8859-1?Q?Christian_R=F8snes?= <christian.rosnes@gmail.com>
Subject: Re: FW: Multipath setup and rdac questions
Date: Thu, 5 Feb 2009 21:23:50 +0100
Message-ID: <1a4a774c0902051223g3a70ee45k946b9338d5d3c2df@mail.gmail.com>
References: <E463DF2B2E584B4A82673F53D62C2EF4663976BB@cosmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0350106598=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF4663976BB@cosmail01.lsi.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Moger, Babu" <Babu.Moger@lsi.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============0350106598==
Content-Type: multipart/alternative; boundary=001636458198b7db8c046231ae7a

--001636458198b7db8c046231ae7a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On Thu, Feb 5, 2009 at 8:34 PM, Moger, Babu <Babu.Moger@lsi.com> wrote:

>  It is still not correct.  The product id "MD Virtual Disk" is the device
> claimed by MPP. That means you still have mpp in your system.
>
>
>
> Please follow the steps below..
>
>
>
>    1. Remove the MPP from your system.
>
> Find the directory where MPP sources are located. It should be somewhere in
> /opt/.  Then run "make uninstall"
>
>
>
>       2. Send me output of /proc/scsi/scsi
>

Ok. Thank you for spotting this.

The Makefile resided in /usr/src/linuxrdac-09.03.0C06.0030
I did the following to stop the mpp modules from loading at boot:

i first did:

 # cd /usr/src/linuxrdac-09.03.0C06.0030
 /usr/src/linuxrdac-09.03.0C06.0030 # make uninstall

This removed some files (amongst others the files in /opt/mpp)

I rebooted, but the the mpp* drivers still were loaded after reboot.

I then changed the /etc/modprobde.conf and commented out the mpp drivers:

#alias scsi_hostadapter0 mppVhba
#alias scsi_hostadapter1 mppUpper

This was not enough, I still had the mpp* drivers after reboot.

So I looked in /boot and found an "old" version of initrd, and I assume
this was the initrd used before the mpp driver was installed.
So I changed /boot/grub/menu.lst to use the "previous" initrd, and then
rebooted.
Now, I don't have any mpp drivers loaded anymore.

And here's the output of /proc/scsi/scsi:

# cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: SEAGATE  Model: ST973451SS       Rev: SM04
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi0 Channel: 00 Id: 01 Lun: 00
  Vendor: SEAGATE  Model: ST973451SS       Rev: SM04
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi0 Channel: 01 Id: 00 Lun: 00
  Vendor: Dell     Model: VIRTUAL DISK     Rev: 1028
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi5 Channel: 00 Id: 00 Lun: 00
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi6 Channel: 00 Id: 00 Lun: 00
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi7 Channel: 00 Id: 00 Lun: 00
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi8 Channel: 00 Id: 00 Lun: 00
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi3 Channel: 00 Id: 00 Lun: 00
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi4 Channel: 00 Id: 00 Lun: 00
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi5 Channel: 00 Id: 00 Lun: 10
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi6 Channel: 00 Id: 00 Lun: 10
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi3 Channel: 00 Id: 00 Lun: 01
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi4 Channel: 00 Id: 00 Lun: 01
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi5 Channel: 00 Id: 00 Lun: 11
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi6 Channel: 00 Id: 00 Lun: 11
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi5 Channel: 00 Id: 00 Lun: 12
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi6 Channel: 00 Id: 00 Lun: 12
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi7 Channel: 00 Id: 00 Lun: 10
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi8 Channel: 00 Id: 00 Lun: 10
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi7 Channel: 00 Id: 00 Lun: 11
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi8 Channel: 00 Id: 00 Lun: 11
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi3 Channel: 00 Id: 00 Lun: 02
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi4 Channel: 00 Id: 00 Lun: 02
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi3 Channel: 00 Id: 00 Lun: 03
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi4 Channel: 00 Id: 00 Lun: 03
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 01
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 01
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 02
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 02
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi6 Channel: 00 Id: 00 Lun: 13
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi5 Channel: 00 Id: 00 Lun: 13
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi5 Channel: 00 Id: 00 Lun: 14
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi6 Channel: 00 Id: 00 Lun: 14
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi7 Channel: 00 Id: 00 Lun: 12
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi8 Channel: 00 Id: 00 Lun: 12
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi7 Channel: 00 Id: 00 Lun: 13
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi8 Channel: 00 Id: 00 Lun: 13
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi3 Channel: 00 Id: 00 Lun: 04
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi4 Channel: 00 Id: 00 Lun: 04
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi3 Channel: 00 Id: 00 Lun: 05
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi4 Channel: 00 Id: 00 Lun: 05
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi3 Channel: 00 Id: 00 Lun: 31
  Vendor: DELL     Model: Universal Xport  Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi4 Channel: 00 Id: 00 Lun: 31
  Vendor: DELL     Model: Universal Xport  Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 03
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 03
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 04
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 04
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi6 Channel: 00 Id: 00 Lun: 15
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi5 Channel: 00 Id: 00 Lun: 15
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi7 Channel: 00 Id: 00 Lun: 14
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi8 Channel: 00 Id: 00 Lun: 14
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi7 Channel: 00 Id: 00 Lun: 15
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi8 Channel: 00 Id: 00 Lun: 15
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi5 Channel: 00 Id: 00 Lun: 31
  Vendor: DELL     Model: Universal Xport  Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi6 Channel: 00 Id: 00 Lun: 31
  Vendor: DELL     Model: Universal Xport  Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi8 Channel: 00 Id: 00 Lun: 31
  Vendor: DELL     Model: Universal Xport  Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi7 Channel: 00 Id: 00 Lun: 31
  Vendor: DELL     Model: Universal Xport  Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 05
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 05
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 31
  Vendor: DELL     Model: Universal Xport  Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 31
  Vendor: DELL     Model: Universal Xport  Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05


Thank you
Christian

--001636458198b7db8c046231ae7a
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<br><br><div class=3D"gmail_quote">On Thu, Feb 5, 2009 at 8:34 PM, Moger, B=
abu <span dir=3D"ltr">&lt;<a href=3D"mailto:Babu.Moger@lsi.com">Babu.Moger@=
lsi.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D=
"border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padd=
ing-left: 1ex;">











<div link=3D"blue" vlink=3D"blue" lang=3D"EN-US">

<div>

<p><font color=3D"navy" face=3D"Arial" size=3D"2"><span style=3D"font-size:=
 10pt; font-family: Arial; color: navy;">It is still not correct. &nbsp;The=
 product id "</span></font>MD
Virtual Disk" is the device claimed by MPP. That means you still have mpp
in your system.</p>

<p><font face=3D"Times New Roman" size=3D"3"><span style=3D"font-size: 12pt=
;">&nbsp;</span></font></p>

<p><font face=3D"Times New Roman" size=3D"3"><span style=3D"font-size: 12pt=
;">Please follow the steps below..</span></font></p>

<p><font face=3D"Times New Roman" size=3D"3"><span style=3D"font-size: 12pt=
;">&nbsp;</span></font></p>

<ol style=3D"margin-top: 0in;" start=3D"1" type=3D"1">
 <li><font face=3D"Times New Roman" size=3D"3"><span style=3D"font-size: 12=
pt;">Remove the MPP from
     your system.</span></font></li>
</ol>

<p style=3D"margin-left: 0.5in;"><font face=3D"Times New Roman" size=3D"3">=
<span style=3D"font-size: 12pt;">Find the directory where MPP sources are l=
ocated. It
should be somewhere in /opt/. &nbsp;Then run "make uninstall"</span></font>=
</p>

<p><font face=3D"Times New Roman" size=3D"3"><span style=3D"font-size: 12pt=
;">&nbsp;</span></font></p>

<p><font face=3D"Times New Roman" size=3D"3"><span style=3D"font-size: 12pt=
;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2. Send me output of /proc/scsi/scsi</spa=
n></font></p></div></div></blockquote><div><br>Ok. Thank you for spotting t=
his.<br><br>The Makefile resided in /usr/src/linuxrdac-09.03.0C06.0030<br>
I did the following to stop the mpp modules from loading at boot:<br><br>i =
first did:<br><br>&nbsp;# cd /usr/src/linuxrdac-09.03.0C06.0030<br>&nbsp;/u=
sr/src/linuxrdac-09.03.0C06.0030 # make uninstall<br><br>This removed some =
files (amongst others the files in /opt/mpp)<br>
<br>I rebooted, but the the mpp* drivers still were loaded after reboot.<br=
><br>I then changed the /etc/modprobde.conf and commented out the mpp drive=
rs:<br><br>#alias scsi_hostadapter0 mppVhba<br>#alias scsi_hostadapter1 mpp=
Upper<br>
<br>This was not enough, I still had the mpp* drivers after reboot.<br><br>=
So I looked in /boot and found an &quot;old&quot; version of initrd, and I =
assume<br>this was the initrd used before the mpp driver was installed.<br>
So I changed /boot/grub/menu.lst to use the &quot;previous&quot; initrd, an=
d then rebooted.<br>Now, I don&#39;t have any mpp drivers loaded anymore.<b=
r><br>And here&#39;s the output of /proc/scsi/scsi:<br><br># cat /proc/scsi=
/scsi<br>
Attached devices:<br>Host: scsi0 Channel: 00 Id: 00 Lun: 00<br>&nbsp; Vendo=
r: SEAGATE&nbsp; Model: ST973451SS&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev:=
 SM04<br>&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; ANSI SCSI revision: 05<br>Host: scsi0 Channel: 00 Id: 01 Lun: 0=
0<br>
&nbsp; Vendor: SEAGATE&nbsp; Model: ST973451SS&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; Rev: SM04<br>&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 05<br>Host: scsi0 Channel: 01 I=
d: 00 Lun: 00<br>&nbsp; Vendor: Dell&nbsp;&nbsp;&nbsp;&nbsp; Model: VIRTUAL=
 DISK&nbsp;&nbsp;&nbsp;&nbsp; Rev: 1028<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; ANSI SCSI revision: 05<br>Host: scsi5 Channel: 00 Id: 00 Lun: 00<br>&nbs=
p; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model: MD3000i&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>&nbsp; Type:&nbsp;&nbsp; Dir=
ect-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 05<br=
>
Host: scsi6 Channel: 00 Id: 00 Lun: 00<br>&nbsp; Vendor: DELL&nbsp;&nbsp;&n=
bsp;&nbsp; Model: MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; Rev: 0735<br>&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 05<br>Host: scsi7 Channel: 00 Id: =
00 Lun: 00<br>&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model: MD3000i&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; ANSI SCSI revision: 05<br>Host: scsi8 Channel: 00 Id: 00 Lun: 00<br>&nbs=
p; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model: MD3000i&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>&nbsp; Type:&nbsp;&nbsp; Dir=
ect-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 05<br=
>
Host: scsi3 Channel: 00 Id: 00 Lun: 00<br>&nbsp; Vendor: DELL&nbsp;&nbsp;&n=
bsp;&nbsp; Model: MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; Rev: 0735<br>&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 05<br>Host: scsi4 Channel: 00 Id: =
00 Lun: 00<br>&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model: MD3000i&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; ANSI SCSI revision: 05<br>Host: scsi5 Channel: 00 Id: 00 Lun: 10<br>&nbs=
p; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model: MD3000i&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>&nbsp; Type:&nbsp;&nbsp; Dir=
ect-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 05<br=
>
Host: scsi6 Channel: 00 Id: 00 Lun: 10<br>&nbsp; Vendor: DELL&nbsp;&nbsp;&n=
bsp;&nbsp; Model: MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; Rev: 0735<br>&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 05<br>Host: scsi3 Channel: 00 Id: =
00 Lun: 01<br>&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model: MD3000i&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; ANSI SCSI revision: 05<br>Host: scsi4 Channel: 00 Id: 00 Lun: 01<br>&nbs=
p; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model: MD3000i&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>&nbsp; Type:&nbsp;&nbsp; Dir=
ect-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 05<br=
>
Host: scsi1 Channel: 00 Id: 00 Lun: 00<br>&nbsp; Vendor: DELL&nbsp;&nbsp;&n=
bsp;&nbsp; Model: MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; Rev: 0735<br>&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 05<br>Host: scsi2 Channel: 00 Id: =
00 Lun: 00<br>&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model: MD3000i&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; ANSI SCSI revision: 05<br>Host: scsi5 Channel: 00 Id: 00 Lun: 11<br>&nbs=
p; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model: MD3000i&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>&nbsp; Type:&nbsp;&nbsp; Dir=
ect-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 05<br=
>
Host: scsi6 Channel: 00 Id: 00 Lun: 11<br>&nbsp; Vendor: DELL&nbsp;&nbsp;&n=
bsp;&nbsp; Model: MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; Rev: 0735<br>&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 05<br>Host: scsi5 Channel: 00 Id: =
00 Lun: 12<br>&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model: MD3000i&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; ANSI SCSI revision: 05<br>Host: scsi6 Channel: 00 Id: 00 Lun: 12<br>&nbs=
p; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model: MD3000i&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>&nbsp; Type:&nbsp;&nbsp; Dir=
ect-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 05<br=
>
Host: scsi7 Channel: 00 Id: 00 Lun: 10<br>&nbsp; Vendor: DELL&nbsp;&nbsp;&n=
bsp;&nbsp; Model: MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; Rev: 0735<br>&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 05<br>Host: scsi8 Channel: 00 Id: =
00 Lun: 10<br>&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model: MD3000i&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; ANSI SCSI revision: 05<br>Host: scsi7 Channel: 00 Id: 00 Lun: 11<br>&nbs=
p; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model: MD3000i&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>&nbsp; Type:&nbsp;&nbsp; Dir=
ect-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 05<br=
>
Host: scsi8 Channel: 00 Id: 00 Lun: 11<br>&nbsp; Vendor: DELL&nbsp;&nbsp;&n=
bsp;&nbsp; Model: MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; Rev: 0735<br>&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 05<br>Host: scsi3 Channel: 00 Id: =
00 Lun: 02<br>&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model: MD3000i&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; ANSI SCSI revision: 05<br>Host: scsi4 Channel: 00 Id: 00 Lun: 02<br>&nbs=
p; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model: MD3000i&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>&nbsp; Type:&nbsp;&nbsp; Dir=
ect-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 05<br=
>
Host: scsi3 Channel: 00 Id: 00 Lun: 03<br>&nbsp; Vendor: DELL&nbsp;&nbsp;&n=
bsp;&nbsp; Model: MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; Rev: 0735<br>&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 05<br>Host: scsi4 Channel: 00 Id: =
00 Lun: 03<br>&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model: MD3000i&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; ANSI SCSI revision: 05<br>Host: scsi1 Channel: 00 Id: 00 Lun: 01<br>&nbs=
p; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model: MD3000i&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>&nbsp; Type:&nbsp;&nbsp; Dir=
ect-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 05<br=
>
Host: scsi2 Channel: 00 Id: 00 Lun: 01<br>&nbsp; Vendor: DELL&nbsp;&nbsp;&n=
bsp;&nbsp; Model: MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; Rev: 0735<br>&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 05<br>Host: scsi1 Channel: 00 Id: =
00 Lun: 02<br>&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model: MD3000i&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; ANSI SCSI revision: 05<br>Host: scsi2 Channel: 00 Id: 00 Lun: 02<br>&nbs=
p; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model: MD3000i&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>&nbsp; Type:&nbsp;&nbsp; Dir=
ect-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 05<br=
>
Host: scsi6 Channel: 00 Id: 00 Lun: 13<br>&nbsp; Vendor: DELL&nbsp;&nbsp;&n=
bsp;&nbsp; Model: MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; Rev: 0735<br>&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 05<br>Host: scsi5 Channel: 00 Id: =
00 Lun: 13<br>&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model: MD3000i&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; ANSI SCSI revision: 05<br>Host: scsi5 Channel: 00 Id: 00 Lun: 14<br>&nbs=
p; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model: MD3000i&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>&nbsp; Type:&nbsp;&nbsp; Dir=
ect-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 05<br=
>
Host: scsi6 Channel: 00 Id: 00 Lun: 14<br>&nbsp; Vendor: DELL&nbsp;&nbsp;&n=
bsp;&nbsp; Model: MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; Rev: 0735<br>&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 05<br>Host: scsi7 Channel: 00 Id: =
00 Lun: 12<br>&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model: MD3000i&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; ANSI SCSI revision: 05<br>Host: scsi8 Channel: 00 Id: 00 Lun: 12<br>&nbs=
p; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model: MD3000i&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>&nbsp; Type:&nbsp;&nbsp; Dir=
ect-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 05<br=
>
Host: scsi7 Channel: 00 Id: 00 Lun: 13<br>&nbsp; Vendor: DELL&nbsp;&nbsp;&n=
bsp;&nbsp; Model: MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; Rev: 0735<br>&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 05<br>Host: scsi8 Channel: 00 Id: =
00 Lun: 13<br>&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model: MD3000i&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; ANSI SCSI revision: 05<br>Host: scsi3 Channel: 00 Id: 00 Lun: 04<br>&nbs=
p; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model: MD3000i&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>&nbsp; Type:&nbsp;&nbsp; Dir=
ect-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 05<br=
>
Host: scsi4 Channel: 00 Id: 00 Lun: 04<br>&nbsp; Vendor: DELL&nbsp;&nbsp;&n=
bsp;&nbsp; Model: MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; Rev: 0735<br>&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 05<br>Host: scsi3 Channel: 00 Id: =
00 Lun: 05<br>&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model: MD3000i&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; ANSI SCSI revision: 05<br>Host: scsi4 Channel: 00 Id: 00 Lun: 05<br>&nbs=
p; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model: MD3000i&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>&nbsp; Type:&nbsp;&nbsp; Dir=
ect-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 05<br=
>
Host: scsi3 Channel: 00 Id: 00 Lun: 31<br>&nbsp; Vendor: DELL&nbsp;&nbsp;&n=
bsp;&nbsp; Model: Universal Xport&nbsp; Rev: 0735<br>&nbsp; Type:&nbsp;&nbs=
p; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision:=
 05<br>Host: scsi4 Channel: 00 Id: 00 Lun: 31<br>&nbsp; Vendor: DELL&nbsp;&=
nbsp;&nbsp;&nbsp; Model: Universal Xport&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; ANSI SCSI revision: 05<br>Host: scsi1 Channel: 00 Id: 00 Lun: 03<br>&nbs=
p; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model: MD3000i&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>&nbsp; Type:&nbsp;&nbsp; Dir=
ect-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 05<br=
>
Host: scsi2 Channel: 00 Id: 00 Lun: 03<br>&nbsp; Vendor: DELL&nbsp;&nbsp;&n=
bsp;&nbsp; Model: MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; Rev: 0735<br>&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 05<br>Host: scsi1 Channel: 00 Id: =
00 Lun: 04<br>&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model: MD3000i&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; ANSI SCSI revision: 05<br>Host: scsi2 Channel: 00 Id: 00 Lun: 04<br>&nbs=
p; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model: MD3000i&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>&nbsp; Type:&nbsp;&nbsp; Dir=
ect-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 05<br=
>
Host: scsi6 Channel: 00 Id: 00 Lun: 15<br>&nbsp; Vendor: DELL&nbsp;&nbsp;&n=
bsp;&nbsp; Model: MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; Rev: 0735<br>&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 05<br>Host: scsi5 Channel: 00 Id: =
00 Lun: 15<br>&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model: MD3000i&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; ANSI SCSI revision: 05<br>Host: scsi7 Channel: 00 Id: 00 Lun: 14<br>&nbs=
p; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model: MD3000i&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>&nbsp; Type:&nbsp;&nbsp; Dir=
ect-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 05<br=
>
Host: scsi8 Channel: 00 Id: 00 Lun: 14<br>&nbsp; Vendor: DELL&nbsp;&nbsp;&n=
bsp;&nbsp; Model: MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; Rev: 0735<br>&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 05<br>Host: scsi7 Channel: 00 Id: =
00 Lun: 15<br>&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model: MD3000i&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; ANSI SCSI revision: 05<br>Host: scsi8 Channel: 00 Id: 00 Lun: 15<br>&nbs=
p; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model: MD3000i&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>&nbsp; Type:&nbsp;&nbsp; Dir=
ect-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 05<br=
>
Host: scsi5 Channel: 00 Id: 00 Lun: 31<br>&nbsp; Vendor: DELL&nbsp;&nbsp;&n=
bsp;&nbsp; Model: Universal Xport&nbsp; Rev: 0735<br>&nbsp; Type:&nbsp;&nbs=
p; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision:=
 05<br>Host: scsi6 Channel: 00 Id: 00 Lun: 31<br>&nbsp; Vendor: DELL&nbsp;&=
nbsp;&nbsp;&nbsp; Model: Universal Xport&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; ANSI SCSI revision: 05<br>Host: scsi8 Channel: 00 Id: 00 Lun: 31<br>&nbs=
p; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model: Universal Xport&nbsp; Rev: 0=
735<br>&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp; ANSI SCSI revision: 05<br>
Host: scsi7 Channel: 00 Id: 00 Lun: 31<br>&nbsp; Vendor: DELL&nbsp;&nbsp;&n=
bsp;&nbsp; Model: Universal Xport&nbsp; Rev: 0735<br>&nbsp; Type:&nbsp;&nbs=
p; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision:=
 05<br>Host: scsi1 Channel: 00 Id: 00 Lun: 05<br>&nbsp; Vendor: DELL&nbsp;&=
nbsp;&nbsp;&nbsp; Model: MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; ANSI SCSI revision: 05<br>Host: scsi2 Channel: 00 Id: 00 Lun: 05<br>&nbs=
p; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model: MD3000i&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>&nbsp; Type:&nbsp;&nbsp; Dir=
ect-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 05<br=
>
Host: scsi1 Channel: 00 Id: 00 Lun: 31<br>&nbsp; Vendor: DELL&nbsp;&nbsp;&n=
bsp;&nbsp; Model: Universal Xport&nbsp; Rev: 0735<br>&nbsp; Type:&nbsp;&nbs=
p; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision:=
 05<br>Host: scsi2 Channel: 00 Id: 00 Lun: 31<br>&nbsp; Vendor: DELL&nbsp;&=
nbsp;&nbsp;&nbsp; Model: Universal Xport&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; ANSI SCSI revision: 05<br><br><br>Thank you<br>Christian<br><br>&nbsp;</=
div></div><br>

--001636458198b7db8c046231ae7a--


--===============0350106598==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0350106598==--
