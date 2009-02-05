From: =?ISO-8859-1?Q?Christian_R=F8snes?= <christian.rosnes@gmail.com>
Subject: Multipath setup and rdac questions
Date: Thu, 5 Feb 2009 14:58:59 +0100
Message-ID: <1a4a774c0902050558r661093dag83e71a06250c24aa@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1381537394=="
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

--===============1381537394==
Content-Type: multipart/alternative; boundary=001636498f115a05b604622c4ed3

--001636498f115a05b604622c4ed3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi

I have got a couple of MD3000i with dual controllers,
and two M600e blades connected two both of them.

I've setup multipath, and would appreciate if
someone could tell me whether the setup described
below looks correct, or if you'd do it any
other way.
The reason I'm asking, is that I cannot see any
reference to 'rdac hardware handler' when
I do "multipath -ll".

However, when I change the module controller
ownership one of the LUNs (while copying files to that
particular LUN), the failover seems to work -
the gilr copying continues after the controller switch.

I also see these messages in /var/log/messages when
I change the module controller ownership:

 494 [RAIDarray.mpp]MD3000i_A:0:1:0 Cmnd-failed try alt ctrl 1. vcmnd SN
351494
pdev H2:C0:T0:L0 0x05/0x94/0x01 0x08000002 mpp_status:1


Q1: What could be the reason that I'm not using the rdac hwhandler ?
 (see output from "multipath -ll" below)

Q2: Is using rdac for this kind of setup preferred ?

Q3: I've created a GPFS filesystem using the /dev/dm-0, /dev/dm-1, etc
device. Is it OK to use the dm-x devices ? I see that there
are other alternatives such as /dev/mapper/mpath<x>.
However, /dev/mapper/mpath<x> is not visible in /proc/partitions
(see below), but the dm-<x> devices are - and the GPFS filesystem complains
when
it cannot see the devices in /proc/partitions.

Q4: Does my setup described here look OK ?


The blades are running:

  SLES 10 SP2 (x86-64)

From the MD3000i Dell Resource CD the following rpm was installed:

  linuxrdac-09.03.0C06.0030-1dkms

The following modules are running on my blades:

# lsmod | egrep 'rdac|mpp|multi'
dm_rdac                24832  0
dm_multipath           42640  3  dm_rdac,dm_round_robin
dm_mod                 80528  26 dm_multipath
mppVhba               145120  24
mppUpper              127436  1  mppVhba
scsi_mod              170936  12 dm_rdac,iscsi_tcp,
                                 libiscsi,
                                 scsi_transport_iscsi,
                                 mptctl,mppVhba,mptsas,
                                 mptscsih,
                                 scsi_transport_sas,
                                 mppUpper,sg,sd_mod


My multipath.conf file contains:

#cat /etc/multipath.conf

defaults {
        udev_dir                /dev
        user_friendly_names     yes
}
blacklist {
        devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
        devnode "^hd[a-z]"
        devnode "^sda"
        devnode "^sda[0-9]"
        device {
                vendor DELL
                product "PERC|Universal"
        }
}
devices {
  device {
                vendor                  "DELL"
                product                 "MD3000i"
                product_blacklist       "Universal Xport"
                features                "1 queue_if_no_path"
                path_grouping_policy    group_by_prio
                hardware_handler        "1 rdac"
                path_checker            rdac
                prio                    "rdac"
                failback                immediate
        }
}
multipaths {
        mulitpath {
                device {
                        vendor DELL
                        product MD3000i
                }
        }
}

After changing the multipath.conf I did:

multipath -F
service multipathd restart

Now, if I've do:

# multipath -ll
mpathe (36002219000918b4c00005b6c497e6632) dm-4 DELL,MD Virtual Disk
[size=5.5T][features=0][hwhandler=0]
\_ round-robin 0 [prio=1][active]
 \_ 9:0:0:1  sdi 8:128 [active][ready]
mpathd (36002219000918b3300002e6e497e6315) dm-3 DELL,MD Virtual Disk
[size=5.5T][features=0][hwhandler=0]
\_ round-robin 0 [prio=1][active]
 \_ 9:0:0:2  sdj 8:144 [active][ready]
mpathc (36002219000918b4c00005b6f497e6695) dm-2 DELL,MD Virtual Disk
[size=5.5T][features=0][hwhandler=0]
\_ round-robin 0 [prio=1][active]
 \_ 9:0:0:3  sdk 8:160 [active][ready]
mpathb (36002219000918b3300002e71497e6378) dm-1 DELL,MD Virtual Disk
[size=5.5T][features=0][hwhandler=0]
\_ round-robin 0 [prio=1][active]
 \_ 9:0:0:4  sdl 8:176 [active][ready]
mpatha (36002219000918b4c00005b72497e66f3) dm-0 DELL,MD Virtual Disk
[size=5.5T][features=0][hwhandler=0]
\_ round-robin 0 [prio=1][active]
 \_ 9:0:0:5  sdm 8:192 [active][ready]
mpathl (36002219000918b3300002e6b497e62a6) dm-11 DELL,MD Virtual Disk
[size=5.5T][features=0][hwhandler=0]
\_ round-robin 0 [prio=1][active]
 \_ 9:0:0:0  sdb 8:16  [active][ready]
mpathk (36002219000922cdf000004a4497e53f5) dm-10 DELL,MD Virtual Disk
[size=5.5T][features=0][hwhandler=0]
\_ round-robin 0 [prio=1][active]
 \_ 9:0:1:10 sdc 8:32  [active][ready]
mpathj (36002219000918b2e000004b2497e581c) dm-9 DELL,MD Virtual Disk
[size=5.5T][features=0][hwhandler=0]
\_ round-robin 0 [prio=1][active]
 \_ 9:0:1:11 sdd 8:48  [active][ready]
mpathi (36002219000922cdf000004a7497e54dd) dm-8 DELL,MD Virtual Disk
[size=5.5T][features=0][hwhandler=0]
\_ round-robin 0 [prio=1][active]
 \_ 9:0:1:12 sde 8:64  [active][ready]
mpathh (36002219000918b2e000004b5497e587e) dm-7 DELL,MD Virtual Disk
[size=5.5T][features=0][hwhandler=0]
\_ round-robin 0 [prio=1][active]
 \_ 9:0:1:13 sdf 8:80  [active][ready]
mpathg (36002219000922cdf000004aa497e5532) dm-6 DELL,MD Virtual Disk
[size=5.5T][features=0][hwhandler=0]
\_ round-robin 0 [prio=1][active]
 \_ 9:0:1:14 sdg 8:96  [active][ready]
mpathf (36002219000918b2e000004b8497e58dc) dm-5 DELL,MD Virtual Disk
[size=5.5T][features=0][hwhandler=0]
\_ round-robin 0 [prio=1][active]
 \_ 9:0:1:15 sdh 8:112 [active][ready]


 cat /proc/partitions
major minor  #blocks  name

   8     0   71041024 sda
   8     1     530113 sda1
   8     2    8393962 sda2
   8     3   62115322 sda3
   8    16 5857419264 sdb
   8    32 5857419264 sdc
   8    48 5857419264 sdd
   8    64 5857419264 sde
   8    80 5857419264 sdf
   8    96 5857419264 sdg
   8   112 5857419264 sdh
   8   128 5857419264 sdi
   8   144 5857419264 sdj
   8   160 5857419264 sdk
   8   176 5857419264 sdl
   8   192 5857419264 sdm
 253     0 5857419264 dm-0
 253     1 5857419264 dm-1
 253     2 5857419264 dm-2
 253     3 5857419264 dm-3
 253     4 5857419264 dm-4
 253     5 5857419264 dm-5
 253     6 5857419264 dm-6
 253     7 5857419264 dm-7
 253     8 5857419264 dm-8
 253     9 5857419264 dm-9
 253    10 5857419264 dm-10
 253    11 5857419264 dm-11

Thank you


Christian

--001636498f115a05b604622c4ed3
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi<br><br>I have got a couple of MD3000i with dual controllers, <br>and two=
 M600e blades connected two both of them.<br><br>I&#39;ve setup multipath, =
and would appreciate if <br>someone could tell me whether the setup describ=
ed<br>
below looks correct, or if you&#39;d do it any<br>other way. <br>The reason=
 I&#39;m asking, is that I cannot see any <br>reference to &#39;rdac hardwa=
re handler&#39; when <br>I do &quot;multipath -ll&quot;. <br><br>However, w=
hen I change the module controller<br>
ownership one of the LUNs (while copying files to that<br>particular LUN), =
the failover seems to work - <br>the gilr copying continues after the contr=
oller switch.<br><br>I also see these messages in /var/log/messages when<br=
>
I change the module controller ownership:<br><br>&nbsp;494 [RAIDarray.mpp]M=
D3000i_A:0:1:0 Cmnd-failed try alt ctrl 1. vcmnd SN 351494 <br>pdev H2:C0:T=
0:L0 0x05/0x94/0x01 0x08000002 mpp_status:1<br><br><br>Q1: What could be th=
e reason that I&#39;m not using the rdac hwhandler ? <br>
&nbsp;(see output from &quot;multipath -ll&quot; below)<br><br>Q2: Is using=
 rdac for this kind of setup preferred ?<br><br>Q3: I&#39;ve created a GPFS=
 filesystem using the /dev/dm-0, /dev/dm-1, etc<br>device. Is it OK to use =
the dm-x devices ? I see that there<br>
are other alternatives such as /dev/mapper/mpath&lt;x&gt;.<br>However, /dev=
/mapper/mpath&lt;x&gt; is not visible in /proc/partitions <br>(see below), =
but the dm-&lt;x&gt; devices are - and the GPFS filesystem complains when<b=
r>
it cannot see the devices in /proc/partitions.<br><br>Q4: Does my setup des=
cribed here look OK ?<br><br><br>The blades are running: <br><br>&nbsp; SLE=
S 10 SP2 (x86-64)<br><br>From the MD3000i Dell Resource CD the following rp=
m was installed:<br>
<br>&nbsp; linuxrdac-09.03.0C06.0030-1dkms<br><br>The following modules are=
 running on my blades:<br><br># lsmod | egrep &#39;rdac|mpp|multi&#39;<br>d=
m_rdac&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp; 24832&nbsp; 0<br>dm_multipath&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 42640&nbsp; 3&nbsp; dm_rdac,dm_round_r=
obin<br>
dm_mod&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp; 80528&nbsp; 26 dm_multipath<br>mppVhba&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
 145120&nbsp; 24<br>mppUpper&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 127436&nbsp; 1&nbsp; mppVhba<br>scsi_mod&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
 170936&nbsp; 12 dm_rdac,iscsi_tcp,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp; libiscsi,<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; scsi_transport_iscsi,<br>&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mptctl,mppVhba,mptsas,<br>&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mptscsih,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; scsi_transport_sas,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; mppUpper,sg,sd_mod<br>
<br><br>My multipath.conf file contains:<br><br>#cat /etc/multipath.conf<br=
><br>defaults {<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; udev_dir&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; /dev<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; user_friendly=
_names&nbsp;&nbsp;&nbsp;&nbsp; yes<br>}<br>blacklist {<br>&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; devnode &quot;^(ram|raw|loop|fd|md|dm-|sr|scd|st)=
[0-9]*&quot;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; devnode &quot;^hd[a-z]&quot;<br>=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; devnode &quot;^sda&quot;<br>&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; devnode &quot;^sda[0-9]&quot;<br>&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; device {<br>&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; vendor =
DELL<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp; product &quot;PERC|Universal&quot;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<br>}<br>devices {<br>&nbsp; de=
vice {<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; vendor&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;DELL&quot=
;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; product&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;MD3000i&quot;<br>&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; product_blacklist&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;U=
niversal Xport&quot;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp; features&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;1 queue_if_no_path&quot;<br>&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; path_grouping_policy&nbsp;&nbsp;&nbsp; group_by_prio<br>&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; hardware_handler&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quo=
t;1 rdac&quot;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; path_checker&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rdac<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp; prio&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;rdac&quot=
;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; failback&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; immediate<br>&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; }<br>}<br>multipaths {<br>&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; mulitpath {<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; device {<br>&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; vendor DELL<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; product MD3=
000i<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp; }<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<b=
r>}<br><br>After changing the multipath.conf I did:<br><br>multipath -F<br>=
service multipathd restart<br><br>Now, if I&#39;ve do:<br>&nbsp; <br># mult=
ipath -ll<br>
mpathe (36002219000918b4c00005b6c497e6632) dm-4 DELL,MD Virtual Disk<br>[si=
ze=3D5.5T][features=3D0][hwhandler=3D0]<br>\_ round-robin 0 [prio=3D1][acti=
ve]<br>&nbsp;\_ 9:0:0:1&nbsp; sdi 8:128 [active][ready]<br>mpathd (36002219=
000918b3300002e6e497e6315) dm-3 DELL,MD Virtual Disk<br>
[size=3D5.5T][features=3D0][hwhandler=3D0]<br>\_ round-robin 0 [prio=3D1][a=
ctive]<br>&nbsp;\_ 9:0:0:2&nbsp; sdj 8:144 [active][ready]<br>mpathc (36002=
219000918b4c00005b6f497e6695) dm-2 DELL,MD Virtual Disk<br>[size=3D5.5T][fe=
atures=3D0][hwhandler=3D0]<br>
\_ round-robin 0 [prio=3D1][active]<br>&nbsp;\_ 9:0:0:3&nbsp; sdk 8:160 [ac=
tive][ready]<br>mpathb (36002219000918b3300002e71497e6378) dm-1 DELL,MD Vir=
tual Disk<br>[size=3D5.5T][features=3D0][hwhandler=3D0]<br>\_ round-robin 0=
 [prio=3D1][active]<br>
&nbsp;\_ 9:0:0:4&nbsp; sdl 8:176 [active][ready]<br>mpatha (36002219000918b=
4c00005b72497e66f3) dm-0 DELL,MD Virtual Disk<br>[size=3D5.5T][features=3D0=
][hwhandler=3D0]<br>\_ round-robin 0 [prio=3D1][active]<br>&nbsp;\_ 9:0:0:5=
&nbsp; sdm 8:192 [active][ready]<br>
mpathl (36002219000918b3300002e6b497e62a6) dm-11 DELL,MD Virtual Disk<br>[s=
ize=3D5.5T][features=3D0][hwhandler=3D0]<br>\_ round-robin 0 [prio=3D1][act=
ive]<br>&nbsp;\_ 9:0:0:0&nbsp; sdb 8:16&nbsp; [active][ready]<br>mpathk (36=
002219000922cdf000004a4497e53f5) dm-10 DELL,MD Virtual Disk<br>
[size=3D5.5T][features=3D0][hwhandler=3D0]<br>\_ round-robin 0 [prio=3D1][a=
ctive]<br>&nbsp;\_ 9:0:1:10 sdc 8:32&nbsp; [active][ready]<br>mpathj (36002=
219000918b2e000004b2497e581c) dm-9 DELL,MD Virtual Disk<br>[size=3D5.5T][fe=
atures=3D0][hwhandler=3D0]<br>
\_ round-robin 0 [prio=3D1][active]<br>&nbsp;\_ 9:0:1:11 sdd 8:48&nbsp; [ac=
tive][ready]<br>mpathi (36002219000922cdf000004a7497e54dd) dm-8 DELL,MD Vir=
tual Disk<br>[size=3D5.5T][features=3D0][hwhandler=3D0]<br>\_ round-robin 0=
 [prio=3D1][active]<br>
&nbsp;\_ 9:0:1:12 sde 8:64&nbsp; [active][ready]<br>mpathh (36002219000918b=
2e000004b5497e587e) dm-7 DELL,MD Virtual Disk<br>[size=3D5.5T][features=3D0=
][hwhandler=3D0]<br>\_ round-robin 0 [prio=3D1][active]<br>&nbsp;\_ 9:0:1:1=
3 sdf 8:80&nbsp; [active][ready]<br>
mpathg (36002219000922cdf000004aa497e5532) dm-6 DELL,MD Virtual Disk<br>[si=
ze=3D5.5T][features=3D0][hwhandler=3D0]<br>\_ round-robin 0 [prio=3D1][acti=
ve]<br>&nbsp;\_ 9:0:1:14 sdg 8:96&nbsp; [active][ready]<br>mpathf (36002219=
000918b2e000004b8497e58dc) dm-5 DELL,MD Virtual Disk<br>
[size=3D5.5T][features=3D0][hwhandler=3D0]<br>\_ round-robin 0 [prio=3D1][a=
ctive]<br>&nbsp;\_ 9:0:1:15 sdh 8:112 [active][ready]<br><br><br>&nbsp;cat =
/proc/partitions<br>major minor&nbsp; #blocks&nbsp; name<br><br>&nbsp;&nbsp=
; 8&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp; 71041024 sda<br>&nbsp;&nbsp; 8&nb=
sp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp;&nbsp; 530113 sda1<br>
&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp;&nbsp; 2&nbsp;&nbsp;&nbsp; 8393962 sda2<br>=
&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp;&nbsp; 3&nbsp;&nbsp; 62115322 sda3<br>&nbsp=
;&nbsp; 8&nbsp;&nbsp;&nbsp; 16 5857419264 sdb<br>&nbsp;&nbsp; 8&nbsp;&nbsp;=
&nbsp; 32 5857419264 sdc<br>&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp; 48 5857419264 =
sdd<br>&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp; 64 5857419264 sde<br>&nbsp;&nbsp; 8=
&nbsp;&nbsp;&nbsp; 80 5857419264 sdf<br>&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp; 96=
 5857419264 sdg<br>
&nbsp;&nbsp; 8&nbsp;&nbsp; 112 5857419264 sdh<br>&nbsp;&nbsp; 8&nbsp;&nbsp;=
 128 5857419264 sdi<br>&nbsp;&nbsp; 8&nbsp;&nbsp; 144 5857419264 sdj<br>&nb=
sp;&nbsp; 8&nbsp;&nbsp; 160 5857419264 sdk<br>&nbsp;&nbsp; 8&nbsp;&nbsp; 17=
6 5857419264 sdl<br>&nbsp;&nbsp; 8&nbsp;&nbsp; 192 5857419264 sdm<br>&nbsp;=
253&nbsp;&nbsp;&nbsp;&nbsp; 0 5857419264 dm-0<br>&nbsp;253&nbsp;&nbsp;&nbsp=
;&nbsp; 1 5857419264 dm-1<br>
&nbsp;253&nbsp;&nbsp;&nbsp;&nbsp; 2 5857419264 dm-2<br>&nbsp;253&nbsp;&nbsp=
;&nbsp;&nbsp; 3 5857419264 dm-3<br>&nbsp;253&nbsp;&nbsp;&nbsp;&nbsp; 4 5857=
419264 dm-4<br>&nbsp;253&nbsp;&nbsp;&nbsp;&nbsp; 5 5857419264 dm-5<br>&nbsp=
;253&nbsp;&nbsp;&nbsp;&nbsp; 6 5857419264 dm-6<br>&nbsp;253&nbsp;&nbsp;&nbs=
p;&nbsp; 7 5857419264 dm-7<br>&nbsp;253&nbsp;&nbsp;&nbsp;&nbsp; 8 585741926=
4 dm-8<br>&nbsp;253&nbsp;&nbsp;&nbsp;&nbsp; 9 5857419264 dm-9<br>
&nbsp;253&nbsp;&nbsp;&nbsp; 10 5857419264 dm-10<br>&nbsp;253&nbsp;&nbsp;&nb=
sp; 11 5857419264 dm-11<br><br>Thank you<br><br><br>Christian<br>

--001636498f115a05b604622c4ed3--


--===============1381537394==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1381537394==--
