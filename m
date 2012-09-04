From: Damodharan K <kvdhamu@gmail.com>
Subject: Multipath issue
Date: Tue, 4 Sep 2012 21:30:42 +0200
Message-ID: <CAAMcupx82czniiX3v9uzgaFUmBzUG_NMXUeZEs8SjvOD-O3QKg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7184609100002531306=="
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

--===============7184609100002531306==
Content-Type: multipart/alternative; boundary=14dae93409b346526a04c8e54b43

--14dae93409b346526a04c8e54b43
Content-Type: text/plain; charset=ISO-8859-1

Hello Team,


It is being found that one of the path has failed on the following devices.
At the storage end, everything is okay. Have reseted the HBA adaptors as
well. Could you please help to fix it.
-----------------------------------------------------------------------------

Only failed devices

/sbin/mpath_prio_hds_modular exitted with 1
error calling out /sbin/mpath_prio_hds_modular /dev/sdo
mpath50 (360060e80100d100005304908000005dd) dm-91 HITACHI,DF600F
[size=60G][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=0][enabled]
 \_ 2:0:0:14  sdcv 70:48   [failed][faulty]
--
/sbin/mpath_prio_hds_modular exitted with 1
error calling out /sbin/mpath_prio_hds_modular /dev/sdl
mpath47 (360060e80100d100005304908000004b1) dm-88 HITACHI,DF600F
[size=60G][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=0][enabled]
 \_ 2:0:0:11  sdcs 70:0    [failed][faulty]
--
/sbin/mpath_prio_hds_modular exitted with 1
error calling out /sbin/mpath_prio_hds_modular /dev/sdk
mpath46 (360060e80100d1000053049080000044d) dm-87 HITACHI,DF600F
[size=60G][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=0][enabled]
 \_ 2:0:0:10  sdcr 69:240  [failed][faulty]
--
/sbin/mpath_prio_hds_modular exitted with 1
error calling out /sbin/mpath_prio_hds_modular /dev/sdj
mpath45 (360060e80100d100005304908000003e9) dm-86 HITACHI,DF600F
[size=60G][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=0][enabled]
 \_ 2:0:0:9   sdcq 69:224  [failed][faulty]
--
mpath59 (360060e80100d100005304908000003ea) dm-100 HITACHI,DF600F
[size=60G][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=-1][active]
 \_ 0:0:0:23  sdx  65:112  [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 2:0:0:23  sdde 70:192  [failed][faulty]
--
mpath61 (360060e80100d100005304908000004b2) dm-102 HITACHI,DF600F
[size=60G][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=-1][active]
 \_ 0:0:0:25  sdz  65:144  [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 2:0:0:25  sddg 70:224  [failed][faulty]
--
mpath26 (360060e80100d1000053049080000006e) dm-77 HITACHI,DF600F
[size=60G][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=-1][active]
 \_ 0:0:0:0   sda  8:0     [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 2:0:0:0   sdch 69:80   [failed][faulty]
--
mpath58 (360060e80100d10000530490800000386) dm-99 HITACHI,DF600F
[size=60G][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=-1][active]
 \_ 0:0:0:22  sdw  65:96   [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 2:0:0:22  sddd 70:176  [failed][faulty]
--
mpath57 (360060e80100d10000530490800000322) dm-98 HITACHI,DF600F
[size=60G][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=-1][active]
 \_ 0:0:0:21  sdv  65:80   [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 2:0:0:21  sddc 70:160  [failed][faulty]
--
mpath39 (360060e80100d1000053049080000019a) dm-80 HITACHI,DF600F
[size=60G][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=-1][active]
 \_ 0:0:0:3   sdd  8:48    [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 2:0:0:3   sdck 69:128  [failed][faulty]
--
mpath56 (360060e80100d100005304908000002be) dm-97 HITACHI,DF600F
[size=60G][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=-1][active]
 \_ 0:0:0:20  sdu  65:64   [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 2:0:0:20  sddb 70:144  [failed][faulty]
--
mpath41 (360060e80100d10000530490800000262) dm-82 HITACHI,DF600F
[size=60G][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=-1][active]
 \_ 0:0:0:5   sdf  8:80    [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 2:0:0:5   sdcm 69:160  [active][faulty]

-----------------------------------------------------------------------------


#multipath -ll

mpath57 (360060e80100d10000530490800000322) dm-98 HITACHI,DF600F
[size=60G][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=-1][active]
 \_ 0:0:0:21  sdv  65:80   [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 2:0:0:21  sddc 70:160  [failed][faulty]
/sbin/mpath_prio_hds_modular exitted with 1
error calling out /sbin/mpath_prio_hds_modular /dev/sdcn
/sbin/mpath_prio_hds_modular exitted with 1
error calling out /sbin/mpath_prio_hds_modular /dev/sdg
mpath42 (360060e80100d100005304908000002bd) dm-83 HITACHI,DF600F
[size=60G][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=-1][active]
 \_ 2:0:0:6   sdcn 69:176  [active][ready]
\_ round-robin 0 [prio=-1][enabled]
 \_ 0:0:0:6   sdg  8:96    [active][ready]
mpath74 (360060e80042bf60000002bf600001457) dm-38 HITACHI,OPEN-V
[size=55G][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=2][active]
 \_ 0:0:1:26  sdbb 67:80   [active][ready]
 \_ 2:0:1:26  sdei 128:160 [active][ready]
mpath3 (360060e80042bf60000002bf60000147e) dm-14 HITACHI,OPEN-V
[size=55G][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=2][active]
 \_ 0:0:1:2   sdad 65:208  [active][ready]
 \_ 2:0:1:2   sddk 71:32   [active][ready]
/sbin/mpath_prio_hds_modular exitted with 1
error calling out /sbin/mpath_prio_hds_modular /dev/sdd
mpath39 (360060e80100d1000053049080000019a) dm-80 HITACHI,DF600F
[size=60G][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=-1][active]
 \_ 0:0:0:3   sdd  8:48    [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 2:0:0:3   sdck 69:128  [failed][faulty]
mpath24 (360060e80042bf60000002bf600001662) dm-49 HITACHI,OPEN-V
[size=55G][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=2][active]
 \_ 0:0:1:37  sdbm 68:0    [active][ready]
 \_ 2:0:1:37  sdet 129:80  [active][ready]
/sbin/mpath_prio_hds_modular exitted with 1
error calling out /sbin/mpath_prio_hds_modular /dev/sdu
mpath56 (360060e80100d100005304908000002be) dm-97 HITACHI,DF600F
[size=60G][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=-1][active]
 \_ 0:0:0:20  sdu  65:64   [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 2:0:0:20  sddb 70:144  [failed][faulty]
/sbin/mpath_prio_hds_modular exitted with 1
error calling out /sbin/mpath_prio_hds_modular /dev/sdf
mpath41 (360060e80100d10000530490800000262) dm-82 HITACHI,DF600F
[size=60G][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=-1][active]
 \_ 0:0:0:5   sdf  8:80    [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 2:0:0:5   sdcm 69:160  [active][faulty]
mpath73 (360060e80042bf60000002bf60000168b) dm-37 HITACHI,OPEN-V
[size=55G][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=1][active]

-----------------------------------------------------------------------------

Multipath.conf output



defaults {
        user_friendly_names     yes
        polling_interval        30
        }
blacklist {
        devnode "cciss"
        }
devices {
        device {
                vendor                  "HITACHI"
                product                 "DF600F"
                path_grouping_policy    group_by_prio
                prio_callout            "/sbin/mpath_prio_hds_modular
/dev/%n"
                path_checker            tur
                getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
                failback                immediate
                features                "1 queue_if_no_path"
                no_path_retry           3
                }

-----------------------------------------------------------------------------


root@:~ #cat /etc/redhat-release
Red Hat Enterprise Linux Server release 5.5 (Tikanga)
root@:~ #uname -a
Linux xyz 2.6.18-194.26.1.el5 #1 SMP Fri Oct 29 14:21:16 EDT 2010 x86_64
x86_64 x86_64 GNU/Linux
-----------------------------------------------------------------------------

#uptime
 20:29:01 up 448 days,  5:54,  6 users,  load average: 4.62, 3.70, 2.48
-----------------------------------------------------------------------------
Multipath version

multipath-tools v0.4.7 (03/12, 2006)


-- 
Thanks and Regards
Damodharan K

--14dae93409b346526a04c8e54b43
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br clear=3D"all"><div>Hello Team,</div><div><br></div><di=
v><br></div><div>It is being found that one of the path has failed on the f=
ollowing devices. At the storage end, everything is okay. Have reseted the =
HBA adaptors as well. Could you please help to fix it.</div>

<div>----------------------------------------------------------------------=
-------
</div><div>Only failed devices</div><div><br></div><div><div>/sbin/mpath_pr=
io_hds_modular exitted with 1</div><div>error calling out /sbin/mpath_prio_=
hds_modular /dev/sdo</div><div>mpath50 (360060e80100d100005304908000005dd) =
dm-91 HITACHI,DF600F</div>
<div>[size=3D60G][features=3D1 queue_if_no_path][hwhandler=3D0][rw]</div>
<div>\_ round-robin 0 [prio=3D0][enabled]</div><div>=A0\_ 2:0:0:14 =A0sdcv =
70:48 =A0 [failed][faulty]</div><div>--</div><div>/sbin/mpath_prio_hds_modu=
lar exitted with 1</div><div>error calling out /sbin/mpath_prio_hds_modular=
 /dev/sdl</div>

<div>mpath47 (360060e80100d100005304908000004b1) dm-88 HITACHI,DF600F</div>=
<div>[size=3D60G][features=3D1 queue_if_no_path][hwhandler=3D0][rw]</div><d=
iv>\_ round-robin 0 [prio=3D0][enabled]</div><div>=A0\_ 2:0:0:11 =A0sdcs 70=
:0 =A0 =A0[failed][faulty]</div>

<div>--</div><div>/sbin/mpath_prio_hds_modular exitted with 1</div><div>err=
or calling out /sbin/mpath_prio_hds_modular /dev/sdk</div><div>mpath46 (360=
060e80100d1000053049080000044d) dm-87 HITACHI,DF600F</div><div>[size=3D60G]=
[features=3D1 queue_if_no_path][hwhandler=3D0][rw]</div>

<div>\_ round-robin 0 [prio=3D0][enabled]</div><div>=A0\_ 2:0:0:10 =A0sdcr =
69:240 =A0[failed][faulty]</div><div>--</div><div>/sbin/mpath_prio_hds_modu=
lar exitted with 1</div><div>error calling out /sbin/mpath_prio_hds_modular=
 /dev/sdj</div>

<div>mpath45 (360060e80100d100005304908000003e9) dm-86 HITACHI,DF600F</div>=
<div>[size=3D60G][features=3D1 queue_if_no_path][hwhandler=3D0][rw]</div><d=
iv>\_ round-robin 0 [prio=3D0][enabled]</div><div>=A0\_ 2:0:0:9 =A0 sdcq 69=
:224 =A0[failed][faulty]</div>

<div>--</div><div>mpath59 (360060e80100d100005304908000003ea) dm-100 HITACH=
I,DF600F</div><div>[size=3D60G][features=3D1 queue_if_no_path][hwhandler=3D=
0][rw]</div><div>\_ round-robin 0 [prio=3D-1][active]</div><div>=A0\_ 0:0:0=
:23 =A0sdx =A065:112 =A0[active][ready]</div>

<div>\_ round-robin 0 [prio=3D0][enabled]</div><div>=A0\_ 2:0:0:23 =A0sdde =
70:192 =A0[failed][faulty]</div><div>--</div><div>mpath61 (360060e80100d100=
005304908000004b2) dm-102 HITACHI,DF600F</div><div>[size=3D60G][features=3D=
1 queue_if_no_path][hwhandler=3D0][rw]</div>

<div>\_ round-robin 0 [prio=3D-1][active]</div><div>=A0\_ 0:0:0:25 =A0sdz =
=A065:144 =A0[active][ready]</div><div>\_ round-robin 0 [prio=3D0][enabled]=
</div><div>=A0\_ 2:0:0:25 =A0sddg 70:224 =A0[failed][faulty]</div><div>--</=
div><div>mpath26 (360060e80100d1000053049080000006e) dm-77 HITACHI,DF600F</=
div>

<div>[size=3D60G][features=3D1 queue_if_no_path][hwhandler=3D0][rw]</div><d=
iv>\_ round-robin 0 [prio=3D-1][active]</div><div>=A0\_ 0:0:0:0 =A0 sda =A0=
8:0 =A0 =A0 [active][ready]</div><div>\_ round-robin 0 [prio=3D0][enabled]<=
/div><div>=A0\_ 2:0:0:0 =A0 sdch 69:80 =A0 [failed][faulty]</div>

<div>--</div><div>mpath58 (360060e80100d10000530490800000386) dm-99 HITACHI=
,DF600F</div><div>[size=3D60G][features=3D1 queue_if_no_path][hwhandler=3D0=
][rw]</div><div>\_ round-robin 0 [prio=3D-1][active]</div><div>=A0\_ 0:0:0:=
22 =A0sdw =A065:96 =A0 [active][ready]</div>

<div>\_ round-robin 0 [prio=3D0][enabled]</div><div>=A0\_ 2:0:0:22 =A0sddd =
70:176 =A0[failed][faulty]</div><div>--</div><div>mpath57 (360060e80100d100=
00530490800000322) dm-98 HITACHI,DF600F</div><div>[size=3D60G][features=3D1=
 queue_if_no_path][hwhandler=3D0][rw]</div>

<div>\_ round-robin 0 [prio=3D-1][active]</div><div>=A0\_ 0:0:0:21 =A0sdv =
=A065:80 =A0 [active][ready]</div><div>\_ round-robin 0 [prio=3D0][enabled]=
</div><div>=A0\_ 2:0:0:21 =A0sddc 70:160 =A0[failed][faulty]</div><div>--</=
div><div>mpath39 (360060e80100d1000053049080000019a) dm-80 HITACHI,DF600F</=
div>

<div>[size=3D60G][features=3D1 queue_if_no_path][hwhandler=3D0][rw]</div><d=
iv>\_ round-robin 0 [prio=3D-1][active]</div><div>=A0\_ 0:0:0:3 =A0 sdd =A0=
8:48 =A0 =A0[active][ready]</div><div>\_ round-robin 0 [prio=3D0][enabled]<=
/div><div>=A0\_ 2:0:0:3 =A0 sdck 69:128 =A0[failed][faulty]</div>

<div>--</div><div>mpath56 (360060e80100d100005304908000002be) dm-97 HITACHI=
,DF600F</div><div>[size=3D60G][features=3D1 queue_if_no_path][hwhandler=3D0=
][rw]</div><div>\_ round-robin 0 [prio=3D-1][active]</div><div>=A0\_ 0:0:0:=
20 =A0sdu =A065:64 =A0 [active][ready]</div>

<div>\_ round-robin 0 [prio=3D0][enabled]</div><div>=A0\_ 2:0:0:20 =A0sddb =
70:144 =A0[failed][faulty]</div><div>--</div><div>mpath41 (360060e80100d100=
00530490800000262) dm-82 HITACHI,DF600F</div><div>[size=3D60G][features=3D1=
 queue_if_no_path][hwhandler=3D0][rw]</div>

<div>\_ round-robin 0 [prio=3D-1][active]</div><div>=A0\_ 0:0:0:5 =A0 sdf =
=A08:80 =A0 =A0[active][ready]</div><div>\_ round-robin 0 [prio=3D0][enable=
d]</div><div>=A0\_ 2:0:0:5 =A0 sdcm 69:160 =A0[active][faulty]</div></div><=
div><br></div><div>

---------------------------------------------------------------------------=
--
</div><div><br></div><div>#multipath -ll=A0</div><div><br></div><div><div>m=
path57 (360060e80100d10000530490800000322) dm-98 HITACHI,DF600F</div><div>[=
size=3D60G][features=3D1 queue_if_no_path][hwhandler=3D0][rw]</div><div>\_ =
round-robin 0 [prio=3D-1][active]</div>

<div>=A0\_ 0:0:0:21 =A0sdv =A065:80 =A0 [active][ready]</div><div>\_ round-=
robin 0 [prio=3D0][enabled]</div><div>=A0\_ 2:0:0:21 =A0sddc 70:160 =A0[fai=
led][faulty]</div><div>/sbin/mpath_prio_hds_modular exitted with 1</div><di=
v>error calling out /sbin/mpath_prio_hds_modular /dev/sdcn</div>

<div>/sbin/mpath_prio_hds_modular exitted with 1</div><div>error calling ou=
t /sbin/mpath_prio_hds_modular /dev/sdg</div><div>mpath42 (360060e80100d100=
005304908000002bd) dm-83 HITACHI,DF600F</div><div>[size=3D60G][features=3D1=
 queue_if_no_path][hwhandler=3D0][rw]</div>

<div>\_ round-robin 0 [prio=3D-1][active]</div><div>=A0\_ 2:0:0:6 =A0 sdcn =
69:176 =A0[active][ready]</div><div>\_ round-robin 0 [prio=3D-1][enabled]</=
div><div>=A0\_ 0:0:0:6 =A0 sdg =A08:96 =A0 =A0[active][ready]</div><div>mpa=
th74 (360060e80042bf60000002bf600001457) dm-38 HITACHI,OPEN-V</div>

<div>[size=3D55G][features=3D1 queue_if_no_path][hwhandler=3D0][rw]</div><d=
iv>\_ round-robin 0 [prio=3D2][active]</div><div>=A0\_ 0:0:1:26 =A0sdbb 67:=
80 =A0 [active][ready]</div><div>=A0\_ 2:0:1:26 =A0sdei 128:160 [active][re=
ady]</div><div>

mpath3 (360060e80042bf60000002bf60000147e) dm-14 HITACHI,OPEN-V</div><div>[=
size=3D55G][features=3D1 queue_if_no_path][hwhandler=3D0][rw]</div><div>\_ =
round-robin 0 [prio=3D2][active]</div><div>=A0\_ 0:0:1:2 =A0 sdad 65:208 =
=A0[active][ready]</div>

<div>=A0\_ 2:0:1:2 =A0 sddk 71:32 =A0 [active][ready]</div><div>/sbin/mpath=
_prio_hds_modular exitted with 1</div><div>error calling out /sbin/mpath_pr=
io_hds_modular /dev/sdd</div><div>mpath39 (360060e80100d1000053049080000019=
a) dm-80 HITACHI,DF600F</div>

<div>[size=3D60G][features=3D1 queue_if_no_path][hwhandler=3D0][rw]</div><d=
iv>\_ round-robin 0 [prio=3D-1][active]</div><div>=A0\_ 0:0:0:3 =A0 sdd =A0=
8:48 =A0 =A0[active][ready]</div><div>\_ round-robin 0 [prio=3D0][enabled]<=
/div><div>=A0\_ 2:0:0:3 =A0 sdck 69:128 =A0[failed][faulty]</div>

<div>mpath24 (360060e80042bf60000002bf600001662) dm-49 HITACHI,OPEN-V</div>=
<div>[size=3D55G][features=3D1 queue_if_no_path][hwhandler=3D0][rw]</div><d=
iv>\_ round-robin 0 [prio=3D2][active]</div><div>=A0\_ 0:0:1:37 =A0sdbm 68:=
0 =A0 =A0[active][ready]</div>

<div>=A0\_ 2:0:1:37 =A0sdet 129:80 =A0[active][ready]</div><div>/sbin/mpath=
_prio_hds_modular exitted with 1</div><div>error calling out /sbin/mpath_pr=
io_hds_modular /dev/sdu</div><div>mpath56 (360060e80100d100005304908000002b=
e) dm-97 HITACHI,DF600F</div>

<div>[size=3D60G][features=3D1 queue_if_no_path][hwhandler=3D0][rw]</div><d=
iv>\_ round-robin 0 [prio=3D-1][active]</div><div>=A0\_ 0:0:0:20 =A0sdu =A0=
65:64 =A0 [active][ready]</div><div>\_ round-robin 0 [prio=3D0][enabled]</d=
iv><div>=A0\_ 2:0:0:20 =A0sddb 70:144 =A0[failed][faulty]</div>

<div>/sbin/mpath_prio_hds_modular exitted with 1</div><div>error calling ou=
t /sbin/mpath_prio_hds_modular /dev/sdf</div><div>mpath41 (360060e80100d100=
00530490800000262) dm-82 HITACHI,DF600F</div><div>[size=3D60G][features=3D1=
 queue_if_no_path][hwhandler=3D0][rw]</div>

<div>\_ round-robin 0 [prio=3D-1][active]</div><div>=A0\_ 0:0:0:5 =A0 sdf =
=A08:80 =A0 =A0[active][ready]</div><div>\_ round-robin 0 [prio=3D0][enable=
d]</div><div>=A0\_ 2:0:0:5 =A0 sdcm 69:160 =A0[active][faulty]</div><div>mp=
ath73 (360060e80042bf60000002bf60000168b) dm-37 HITACHI,OPEN-V</div>

<div>[size=3D55G][features=3D1 queue_if_no_path][hwhandler=3D0][rw]</div><d=
iv>\_ round-robin 0 [prio=3D1][active]</div></div><div><br></div><div>-----=
------------------------------------------------------------------------
</div><div>Multipath.conf output</div><div><br></div><div><br></div><div><b=
r></div><div><div>defaults {</div>
<div>=A0 =A0 =A0 =A0 user_friendly_names =A0 =A0 yes</div><div>=A0 =A0 =A0 =
=A0 polling_interval =A0 =A0 =A0 =A030</div><div>=A0 =A0 =A0 =A0 }</div><di=
v>blacklist {</div><div>=A0 =A0 =A0 =A0 devnode &quot;cciss&quot;</div><div=
>=A0 =A0 =A0 =A0 }</div><div>devices {</div><div>

=A0 =A0 =A0 =A0 device {</div><div>=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vendor =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&quot;HITACHI&quot;</div><div>=A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 product =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &quot;DF600=
F&quot;</div><div>=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 path_grouping_policy =A0 =
=A0group_by_prio</div>

<div>=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 prio_callout =A0 =A0 =A0 =A0 =A0 =A0&q=
uot;/sbin/mpath_prio_hds_modular /dev/%n&quot;</div><div>=A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 path_checker =A0 =A0 =A0 =A0 =A0 =A0tur</div><div>=A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 getuid_callout =A0 =A0 =A0 =A0 =A0&quot;/sbin/scsi_=
id -g -u -s /block/%n&quot;</div>

<div>=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 failback =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0immediate</div><div>=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 features =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0&quot;1 queue_if_no_path&quot;</div><div>=A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 no_path_retry =A0 =A0 =A0 =A0 =A0 3</div><div>=A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 }</div>

</div><div><br></div><div>-------------------------------------------------=
----------------------------
</div><div><br></div><div><div>root@:~ #cat /etc/redhat-release</div><div>R=
ed Hat Enterprise Linux Server release 5.5 (Tikanga)</div><div>root@:~ #una=
me -a</div><div>Linux xyz 2.6.18-194.26.1.el5 #1 SMP Fri Oct 29 14:21:16 ED=
T 2010 x86_64 x86_64 x86_64 GNU/Linux</div>
</div><div>----------------------------------------------------------------=
-------------
</div><div><div>#uptime</div><div>=A020:29:01 up 448 days, =A05:54, =A06 us=
ers, =A0load average: 4.62, 3.70, 2.48</div></div><div>--------------------=
---------------------------------------------------------</div><div>Multipa=
th version</div>
<div><br></div><div><div>multipath-tools v0.4.7 (03/12, 2006)</div></div><d=
iv><br></div><div><br></div>-- <br><div>Thanks and Regards</div>
<div>Damodharan K</div><br>
</div>

--14dae93409b346526a04c8e54b43--


--===============7184609100002531306==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7184609100002531306==--
