From: Paras pradhan <pradhanparas@gmail.com>
Subject: Odd detection and failover
Date: Thu, 7 Jan 2010 21:59:42 -0600
Message-ID: <8b711df41001071959h6ff98ad4s7d4282b4c16f61be@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7219384837434546700=="
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============7219384837434546700==
Content-Type: multipart/alternative; boundary=001485f27c20ab3ef7047c9f37b7

--001485f27c20ab3ef7047c9f37b7
Content-Type: text/plain; charset=ISO-8859-1

HI,

My host is RHEL 5.4. I have a single qlogic HBA with 2 ports. Both of the
ports are connected to Hitachi Open V*9 storage (via 2 different McData
switches). I believe in this case I should see 2 devices under /dev/ or
should I see 4?. My storage admin assigned 2 Luns for the 2 WWN for the HBA.
When only one LUN (301GB) was assinged there were 8 devices under /dev/ from
sdb to sdi. And when a 2nd Lun (335GB) was added there is now 12 devices
under /dev/ sdb to sdm. The qlogic driver I am using is the default one
thats comes with RH5.4

Now,

When I configure multipath. My multipath -ll reports as:

mpath1 (360060e8004770d000000770d0000018c) dm-1 HITACHI,OPEN-V*10
[size=335G][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=4][active]
 \_ 5:0:0:1     sdc 8:32  [active][ready]
 \_ 5:0:0:16385 sdf 8:80  [active][ready]
 \_ 5:0:0:32769 sdi 8:128 [active][ready]
 \_ 5:0:0:49153 sdl 8:176 [active][ready]
mpath0 (360060e8004770d000000770d00000154) dm-0 HITACHI,OPEN-V*9
[size=301G][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=8][active]
 \_ 5:0:0:0     sdb 8:16  [active][ready]
 \_ 6:0:0:0     sdd 8:48  [active][ready]
 \_ 5:0:0:16384 sde 8:64  [active][ready]
 \_ 6:0:0:16384 sdg 8:96  [active][ready]
 \_ 5:0:0:32768 sdh 8:112 [active][ready]
 \_ 6:0:0:32768 sdj 8:144 [active][ready]
 \_ 5:0:0:49152 sdk 8:160 [active][ready]
 \_ 6:0:0:49152 sdm 8:192 [active][ready]

Is this correct?

But multipath -l reports:

mpath1 (360060e8004770d000000770d0000018c) dm-1 HITACHI,OPEN-V*10
[size=335G][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=0][active]
 \_ 5:0:0:1     sdc 8:32  [active][undef]
 \_ 5:0:0:16385 sdf 8:80  [active][undef]
 \_ 5:0:0:32769 sdi 8:128 [active][undef]
 \_ 5:0:0:49153 sdl 8:176 [active][undef]
mpath0 (360060e8004770d000000770d00000154) dm-0 HITACHI,OPEN-V*9
[size=301G][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=0][active]
 \_ 5:0:0:0     sdb 8:16  [active][undef]
 \_ 6:0:0:0     sdd 8:48  [active][undef]
 \_ 5:0:0:16384 sde 8:64  [active][undef]
 \_ 6:0:0:16384 sdg 8:96  [active][undef]
 \_ 5:0:0:32768 sdh 8:112 [active][undef]
 \_ 6:0:0:32768 sdj 8:144 [active][undef]
 \_ 5:0:0:49152 sdk 8:160 [active][undef]
 \_ 6:0:0:49152 sdm 8:192 [active][undef]

I donot have anything in /etc/multipath.conf execpt

---
blacklist {
    devnode "^sda"
}

## Use user friendly names, instead of using WWIDs as names.
defaults {
    user_friendly_names yes
    failback immediate
---


I do not know if I need to add anything to multipath.conf for HItachu Open
V*9.

When I pull out the fibre cable on the port 1 of my HBA, there is no
failover going on and so wired to notice that my server is restarted . When
I plug the cable back it there is not automatic recovery and have to restart
server again.


I do not know what is going on in here.

Need help !

Thanks a lot
Paras.

--001485f27c20ab3ef7047c9f37b7
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

HI,<br><br>My host is RHEL 5.4. I have a single qlogic HBA with 2 ports. Bo=
th of the ports are connected to Hitachi Open V*9 storage (via 2 different =
McData switches). I believe in this case I should see 2 devices under /dev/=
 or should I see 4?. My storage admin assigned 2 Luns for the 2 WWN for the=
 HBA. When only one LUN (301GB) was assinged there were 8 devices under /de=
v/ from sdb to sdi. And when a 2nd Lun (335GB) was added there is now 12 de=
vices under /dev/ sdb to sdm. The qlogic driver I am using is the default o=
ne thats comes with RH5.4<br>
<br>Now,<br><br>When I configure multipath. My multipath -ll reports as:<br=
><br>mpath1 (360060e8004770d000000770d0000018c) dm-1 HITACHI,OPEN-V*10<br>[=
size=3D335G][features=3D1 queue_if_no_path][hwhandler=3D0][rw]<br>\_ round-=
robin 0 [prio=3D4][active]<br>
=A0\_ 5:0:0:1=A0=A0=A0=A0 sdc 8:32=A0 [active][ready]<br>=A0\_ 5:0:0:16385 =
sdf 8:80=A0 [active][ready]<br>=A0\_ 5:0:0:32769 sdi 8:128 [active][ready]<=
br>=A0\_ 5:0:0:49153 sdl 8:176 [active][ready]<br>mpath0 (360060e8004770d00=
0000770d00000154) dm-0 HITACHI,OPEN-V*9<br>
[size=3D301G][features=3D1 queue_if_no_path][hwhandler=3D0][rw]<br>\_ round=
-robin 0 [prio=3D8][active]<br>=A0\_ 5:0:0:0=A0=A0=A0=A0 sdb 8:16=A0 [activ=
e][ready]<br>=A0\_ 6:0:0:0=A0=A0=A0=A0 sdd 8:48=A0 [active][ready]<br>=A0\_=
 5:0:0:16384 sde 8:64=A0 [active][ready]<br>
=A0\_ 6:0:0:16384 sdg 8:96=A0 [active][ready]<br>=A0\_ 5:0:0:32768 sdh 8:11=
2 [active][ready]<br>=A0\_ 6:0:0:32768 sdj 8:144 [active][ready]<br>=A0\_ 5=
:0:0:49152 sdk 8:160 [active][ready]<br>=A0\_ 6:0:0:49152 sdm 8:192 [active=
][ready]<br>
<br>Is this correct?<br><br>But multipath -l reports:<br><br>mpath1 (360060=
e8004770d000000770d0000018c) dm-1 HITACHI,OPEN-V*10<br>[size=3D335G][featur=
es=3D1 queue_if_no_path][hwhandler=3D0][rw]<br>\_ round-robin 0 [prio=3D0][=
active]<br>
=A0\_ 5:0:0:1=A0=A0=A0=A0 sdc 8:32=A0 [active][undef]<br>=A0\_ 5:0:0:16385 =
sdf 8:80=A0 [active][undef]<br>=A0\_ 5:0:0:32769 sdi 8:128 [active][undef]<=
br>=A0\_ 5:0:0:49153 sdl 8:176 [active][undef]<br>mpath0 (360060e8004770d00=
0000770d00000154) dm-0 HITACHI,OPEN-V*9<br>
[size=3D301G][features=3D1 queue_if_no_path][hwhandler=3D0][rw]<br>\_ round=
-robin 0 [prio=3D0][active]<br>=A0\_ 5:0:0:0=A0=A0=A0=A0 sdb 8:16=A0 [activ=
e][undef]<br>=A0\_ 6:0:0:0=A0=A0=A0=A0 sdd 8:48=A0 [active][undef]<br>=A0\_=
 5:0:0:16384 sde 8:64=A0 [active][undef]<br>
=A0\_ 6:0:0:16384 sdg 8:96=A0 [active][undef]<br>=A0\_ 5:0:0:32768 sdh 8:11=
2 [active][undef]<br>=A0\_ 6:0:0:32768 sdj 8:144 [active][undef]<br>=A0\_ 5=
:0:0:49152 sdk 8:160 [active][undef]<br>=A0\_ 6:0:0:49152 sdm 8:192 [active=
][undef]<br>
<br>I donot have anything in /etc/multipath.conf execpt<br><br>---<br>black=
list {<br>=A0=A0=A0 devnode &quot;^sda&quot;<br>}<br><br>## Use user friend=
ly names, instead of using WWIDs as names.<br>defaults {<br>=A0=A0=A0 user_=
friendly_names yes<br>
=A0=A0=A0 failback immediate<br>---<br><br><br>I do not know if I need to a=
dd anything to multipath.conf for HItachu Open V*9. <br><br>When I pull out=
 the fibre cable on the port 1 of my HBA, there is no failover going on and=
 so wired to notice that my server is restarted . When I plug the cable bac=
k it there is not automatic recovery and have to restart server again.<br>
<br><br>I do not know what is going on in here.<br><br>Need help !<br><br>T=
hanks a lot<br>Paras.<br><br><br><br><br><br><br><br>

--001485f27c20ab3ef7047c9f37b7--


--===============7219384837434546700==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7219384837434546700==--
