From: Xiaoqiang Zhou <zhouxiaoqiang.mstech@gmail.com>
Subject: dm create error
Date: Tue, 27 Jan 2015 17:33:09 +0800
Message-ID: <CAE6Xo7gFEx75vBotN1KKcRriUTe6S-rUNWd1LNDciXK5uwMuaA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2806905074412900715=="
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
To: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============2806905074412900715==
Content-Type: multipart/alternative; boundary=001a11c38b2e5eb179050d9ef107

--001a11c38b2e5eb179050d9ef107
Content-Type: text/plain; charset=UTF-8

Hi ALL:
      I have some problem with dm.
      when I add a multipath occur some error in message file:

Jan 27 17:09:41 localhost kernel: device-mapper: table: 253:5: multipath:
error getting device
Jan 27 17:09:41 localhost kernel: device-mapper: ioctl: error adding target
to table
Jan 27 17:09:41 localhost multipathd: uevent 'add' from
'/devices/virtual/block/dm-5'
Jan 27 17:09:41 localhost multipathd: uevent 'remove' from
'/devices/virtual/block/dm-5'
Jan 27 17:09:41 localhost multipathd: dm-5: remove map (uevent)
Jan 27 17:09:41 localhost multipathd: dm-5: No DM_NAME in uevent, ignoring
Jan 27 17:09:41 localhost multipathd: uevent 'remove' from
'/devices/virtual/block/dm-5'
Jan 27 17:09:41 localhost multipathd: dm-5: remove map (uevent)
Jan 27 17:09:41 localhost multipathd: dm-5: No DM_NAME in uevent, ignoring


       [root@localhost ovirt-node-nfs]# multipath -l
Jan 27 17:22:56 | multipath.conf +6, invalid keyword: getuid_callout
Jan 27 17:22:56 | multipath.conf +21, invalid keyword: getuid_callout
Jan 27 17:22:56 | multipath.conf +41, invalid keyword: getuid_callout
Jan 27 17:22:56 | libdevmapper version 1.02.84-RHEL7 (2014-03-26)
Jan 27 17:22:56 | DM multipath kernel driver v1.6.0
Jan 27 17:22:56 | loading /lib64/multipath/libcheckdirectio.so checker
Jan 27 17:22:56 | loading /lib64/multipath/libprioconst.so prioritizer
Jan 27 17:22:56 | Discover device
/sys/devices/pci0000:00/0000:00:02.2/0000:03:00.0/host0/target0:2:0/0:2:0:0/block/sda
Jan 27 17:22:56 | sda: not found in pathvec
Jan 27 17:22:56 | sda: mask = 0x21
Jan 27 17:22:56 | sda: dev_t = 8:0
Jan 27 17:22:56 | open
'/sys/devices/pci0000:00/0000:00:02.2/0000:03:00.0/host0/target0:2:0/0:2:0:0/block/sda/size'
Jan 27 17:22:56 | sda: size = 3904897024
Jan 27 17:22:56 | sda: vendor = DELL
Jan 27 17:22:56 | sda: product = PERC H310
Jan 27 17:22:56 | sda: rev = 2.12
Jan 27 17:22:56 | sda: h:b:t:l = 0:2:0:0
Jan 27 17:22:56 | open
'/sys/devices/pci0000:00/0000:00:02.2/0000:03:00.0/host0/target0:2:0/0:2:0:0/state'
Jan 27 17:22:56 | sda: path state = running

Jan 27 17:22:56 | Discover device
/sys/devices/pci0000:00/0000:00:02.2/0000:03:00.0/host0/target0:2:0/0:2:0:0/block/sda/sda1
Jan 27 17:22:56 | Discover device
/sys/devices/pci0000:00/0000:00:02.2/0000:03:00.0/host0/target0:2:0/0:2:0:0/block/sda/sda2
Jan 27 17:22:56 | Discover device
/sys/devices/pci0000:00/0000:00:1f.2/ata5/host5/target5:0:0/5:0:0:0/block/sr0
Jan 27 17:22:56 | sr0: device node name blacklisted
Jan 27 17:22:56 | Discover device /sys/devices/virtual/block/loop0
Jan 27 17:22:56 | loop0: device node name blacklisted
Jan 27 17:22:56 | Discover device /sys/devices/virtual/block/loop1
Jan 27 17:22:56 | loop1: device node name blacklisted
Jan 27 17:22:56 | Discover device /sys/devices/virtual/block/dm-0
Jan 27 17:22:56 | dm-0: device node name blacklisted
Jan 27 17:22:56 | Discover device /sys/devices/virtual/block/dm-1
Jan 27 17:22:56 | dm-1: device node name blacklisted
Jan 27 17:22:56 | Discover device /sys/devices/virtual/block/dm-2
Jan 27 17:22:56 | dm-2: device node name blacklisted
Jan 27 17:22:56 | Discover device /sys/devices/virtual/block/dm-3
Jan 27 17:22:56 | dm-3: device node name blacklisted
Jan 27 17:22:56 | Discover device /sys/devices/virtual/block/dm-4
Jan 27 17:22:56 | dm-4: device node name blacklisted
Jan 27 17:22:56 | Discovery status 0
===== paths list =====
uuid hcil dev dev_t pri dm_st chk_st vend/prod/rev dev_st
0:2:0:0 sda 8:0 -1 undef undef DELL ,PERC H310 running
Jan 27 17:22:56 | unloading const prioritizer
Jan 27 17:22:56 | unloading directio checker


[root@localhost etc]# cat multipath.conf
# RHEV REVISION 1.1

defaults {
polling_interval 5
#getuid_callout "/usr/lib/udev/scsi_id --whitelisted --replace-whitespace
--device=/dev/%n"
getuid_callout "/lib/udev/scsi_id --whitelisted --replace-whitespace
--device=/dev/%n"
no_path_retry 5
user_friendly_names no
flush_on_last_del yes
fast_io_fail_tmo 5
dev_loss_tmo 30
max_fds 4096
verbosity 4
}

devices {
device {
vendor "HITACHI"
product "DF.*"
#getuid_callout "/usr/lib/udev/scsi_id --whitelisted --replace-whitespace
--device=/dev/%n"
getuid_callout "/lib/udev/scsi_id --whitelisted --replace-whitespace
--device=/dev/%n"
}
device {
vendor "COMPELNT"
product "Compellent Vol"
no_path_retry 5
}
device {
# multipath.conf.default
vendor "DGC"
product ".*"
product_blacklist "LUNZ"
path_grouping_policy "group_by_prio"
path_checker "emc_clariion"
hardware_handler "1 emc"
prio "emc"
failback immediate
rr_weight "uniform"
# vdsm required configuration
#getuid_callout "/usr/lib/udev/scsi_id --whitelisted --replace-whitespace
--device=/dev/%n"
getuid_callout "/lib/udev/scsi_id --whitelisted --replace-whitespace
--device=/dev/%n"
features "0"
no_path_retry 5
}
}
[root@localhost etc]#


I can not fix this issue . This problem is hard enough to perplex .
someone can give me some suggest with it.

--001a11c38b2e5eb179050d9ef107
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div style=3D"color:rgb(0,0,0);font-family:=E5=BE=AE=E8=BD=
=AF=E9=9B=85=E9=BB=91,Tahoma;font-size:14px;line-height:21px">Hi ALL:</div>=
<div style=3D"color:rgb(0,0,0);font-family:=E5=BE=AE=E8=BD=AF=E9=9B=85=E9=
=BB=91,Tahoma;font-size:14px;line-height:21px"><span style=3D"background-co=
lor:rgba(0,0,0,0)">=C2=A0 =C2=A0 =C2=A0 I have some problem with dm. =C2=A0=
</span></div><div style=3D"color:rgb(0,0,0);font-family:=E5=BE=AE=E8=BD=AF=
=E9=9B=85=E9=BB=91,Tahoma;font-size:14px;line-height:21px"><span style=3D"b=
ackground-color:rgba(0,0,0,0)">=C2=A0 =C2=A0 =C2=A0 when I add a multipath =
occur some error in message file:</span></div><div style=3D"color:rgb(0,0,0=
);font-family:=E5=BE=AE=E8=BD=AF=E9=9B=85=E9=BB=91,Tahoma;font-size:14px;li=
ne-height:21px"><span style=3D"background-color:rgba(0,0,0,0)">=C2=A0 =C2=
=A0 =C2=A0</span></div><div style=3D"color:rgb(0,0,0);font-family:=E5=BE=AE=
=E8=BD=AF=E9=9B=85=E9=BB=91,Tahoma;font-size:14px;line-height:21px"><span s=
tyle=3D"background-color:rgba(0,0,0,0)">Jan 27 17:09:41 localhost kernel: d=
evice-mapper: table: 253:5: multipath: error getting device=C2=A0<br>Jan 27=
 17:09:41 localhost kernel: device-mapper: ioctl: error adding target to ta=
ble=C2=A0<br>Jan 27 17:09:41 localhost multipathd: uevent &#39;add&#39; fro=
m &#39;/devices/virtual/block/dm-5&#39;=C2=A0<br>Jan 27 17:09:41 localhost =
multipathd: uevent &#39;remove&#39; from &#39;/devices/virtual/block/dm-5&#=
39;=C2=A0<br>Jan 27 17:09:41 localhost multipathd: dm-5: remove map (uevent=
)=C2=A0<br>Jan 27 17:09:41 localhost multipathd: dm-5: No DM_NAME in uevent=
, ignoring=C2=A0<br>Jan 27 17:09:41 localhost multipathd: uevent &#39;remov=
e&#39; from &#39;/devices/virtual/block/dm-5&#39;=C2=A0<br>Jan 27 17:09:41 =
localhost multipathd: dm-5: remove map (uevent)=C2=A0<br>Jan 27 17:09:41 lo=
calhost multipathd: dm-5: No DM_NAME in uevent, ignoring</span></div><div s=
tyle=3D"color:rgb(0,0,0);font-family:=E5=BE=AE=E8=BD=AF=E9=9B=85=E9=BB=91,T=
ahoma;font-size:14px;line-height:21px"><span style=3D"background-color:rgba=
(0,0,0,0)"><br></span></div><div style=3D"color:rgb(0,0,0);font-family:=E5=
=BE=AE=E8=BD=AF=E9=9B=85=E9=BB=91,Tahoma;font-size:14px;line-height:21px"><=
span style=3D"background-color:rgba(0,0,0,0)"><br></span></div><div style=
=3D"color:rgb(0,0,0);font-family:=E5=BE=AE=E8=BD=AF=E9=9B=85=E9=BB=91,Tahom=
a;font-size:14px;line-height:21px"><span style=3D"background-color:rgba(0,0=
,0,0)">=C2=A0 =C2=A0 =C2=A0 =C2=A0</span><span style=3D"font-size:10.5pt;li=
ne-height:1.5;background-color:rgba(0,0,0,0)">[root@localhost ovirt-node-nf=
s]# multipath -l=C2=A0</span></div><span style=3D"color:rgb(0,0,0);font-fam=
ily:=E5=BE=AE=E8=BD=AF=E9=9B=85=E9=BB=91,Tahoma;font-size:14px;line-height:=
21px;background-color:rgba(0,0,0,0)">Jan 27 17:22:56 | multipath.conf +6, i=
nvalid keyword: getuid_callout=C2=A0<br>Jan 27 17:22:56 | multipath.conf +2=
1, invalid keyword: getuid_callout=C2=A0<br>Jan 27 17:22:56 | multipath.con=
f +41, invalid keyword: getuid_callout=C2=A0<br>Jan 27 17:22:56 | libdevmap=
per version 1.02.84-RHEL7 (2014-03-26)=C2=A0<br>Jan 27 17:22:56 | DM multip=
ath kernel driver v1.6.0=C2=A0<br>Jan 27 17:22:56 | loading /lib64/multipat=
h/libcheckdirectio.so checker=C2=A0<br>Jan 27 17:22:56 | loading /lib64/mul=
tipath/libprioconst.so prioritizer=C2=A0<br>Jan 27 17:22:56 | Discover devi=
ce /sys/devices/pci0000:00/0000:00:02.2/0000:03:00.0/host0/target0:2:0/0:2:=
0:0/block/sda=C2=A0<br>Jan 27 17:22:56 | sda: not found in pathvec=C2=A0<br=
>Jan 27 17:22:56 | sda: mask =3D 0x21=C2=A0<br>Jan 27 17:22:56 | sda: dev_t=
 =3D 8:0=C2=A0<br>Jan 27 17:22:56 | open &#39;/sys/devices/pci0000:00/0000:=
00:02.2/0000:03:00.0/host0/target0:2:0/0:2:0:0/block/sda/size&#39;=C2=A0<br=
>Jan 27 17:22:56 | sda: size =3D 3904897024=C2=A0<br>Jan 27 17:22:56 | sda:=
 vendor =3D DELL=C2=A0<br>Jan 27 17:22:56 | sda: product =3D PERC H310=C2=
=A0<br>Jan 27 17:22:56 | sda: rev =3D 2.12=C2=A0<br>Jan 27 17:22:56 | sda: =
h:b:t:l =3D 0:2:0:0=C2=A0<br>Jan 27 17:22:56 | open &#39;/sys/devices/pci00=
00:00/0000:00:02.2/0000:03:00.0/host0/target0:2:0/0:2:0:0/state&#39;=C2=A0<=
br>Jan 27 17:22:56 | sda: path state =3D running=C2=A0<br><br>Jan 27 17:22:=
56 | Discover device /sys/devices/pci0000:00/0000:00:02.2/0000:03:00.0/host=
0/target0:2:0/0:2:0:0/block/sda/sda1=C2=A0<br>Jan 27 17:22:56 | Discover de=
vice /sys/devices/pci0000:00/0000:00:02.2/0000:03:00.0/host0/target0:2:0/0:=
2:0:0/block/sda/sda2=C2=A0<br>Jan 27 17:22:56 | Discover device /sys/device=
s/pci0000:00/0000:00:1f.2/ata5/host5/target5:0:0/5:0:0:0/block/sr0=C2=A0<br=
>Jan 27 17:22:56 | sr0: device node name blacklisted=C2=A0<br>Jan 27 17:22:=
56 | Discover device /sys/devices/virtual/block/loop0=C2=A0<br>Jan 27 17:22=
:56 | loop0: device node name blacklisted=C2=A0<br>Jan 27 17:22:56 | Discov=
er device /sys/devices/virtual/block/loop1=C2=A0<br>Jan 27 17:22:56 | loop1=
: device node name blacklisted=C2=A0<br>Jan 27 17:22:56 | Discover device /=
sys/devices/virtual/block/dm-0=C2=A0<br>Jan 27 17:22:56 | dm-0: device node=
 name blacklisted=C2=A0<br>Jan 27 17:22:56 | Discover device /sys/devices/v=
irtual/block/dm-1=C2=A0<br>Jan 27 17:22:56 | dm-1: device node name blackli=
sted=C2=A0<br>Jan 27 17:22:56 | Discover device /sys/devices/virtual/block/=
dm-2=C2=A0<br>Jan 27 17:22:56 | dm-2: device node name blacklisted=C2=A0<br=
>Jan 27 17:22:56 | Discover device /sys/devices/virtual/block/dm-3=C2=A0<br=
>Jan 27 17:22:56 | dm-3: device node name blacklisted=C2=A0<br>Jan 27 17:22=
:56 | Discover device /sys/devices/virtual/block/dm-4=C2=A0<br>Jan 27 17:22=
:56 | dm-4: device node name blacklisted=C2=A0<br>Jan 27 17:22:56 | Discove=
ry status 0=C2=A0<br>=3D=3D=3D=3D=3D paths list =3D=3D=3D=3D=3D=C2=A0<br>uu=
id hcil dev dev_t pri dm_st chk_st vend/prod/rev dev_st=C2=A0<br>0:2:0:0 sd=
a 8:0 -1 undef undef DELL ,PERC H310 running=C2=A0<br>Jan 27 17:22:56 | unl=
oading const prioritizer=C2=A0<br>Jan 27 17:22:56 | unloading directio chec=
ker</span><div style=3D"color:rgb(0,0,0);font-family:=E5=BE=AE=E8=BD=AF=E9=
=9B=85=E9=BB=91,Tahoma;font-size:14px;line-height:21px"><br></div><div styl=
e=3D"color:rgb(0,0,0);font-family:=E5=BE=AE=E8=BD=AF=E9=9B=85=E9=BB=91,Taho=
ma;font-size:14px;line-height:21px"><br></div><div style=3D"color:rgb(0,0,0=
);font-family:=E5=BE=AE=E8=BD=AF=E9=9B=85=E9=BB=91,Tahoma;font-size:14px;li=
ne-height:21px"><span style=3D"background-color:rgba(0,0,0,0)">[root@localh=
ost etc]# cat multipath.conf=C2=A0<br># RHEV REVISION 1.1=C2=A0<br><br>defa=
ults {=C2=A0<br>polling_interval 5=C2=A0<br>#getuid_callout &quot;/usr/lib/=
udev/scsi_id --whitelisted --replace-whitespace --device=3D/dev/%n&quot;=C2=
=A0<br>getuid_callout &quot;/lib/udev/scsi_id --whitelisted --replace-white=
space --device=3D/dev/%n&quot;=C2=A0<br>no_path_retry 5=C2=A0<br>user_frien=
dly_names no=C2=A0<br>flush_on_last_del yes=C2=A0<br>fast_io_fail_tmo 5=C2=
=A0<br>dev_loss_tmo 30=C2=A0<br>max_fds 4096=C2=A0<br>verbosity 4=C2=A0<br>=
}=C2=A0<br><br>devices {=C2=A0<br>device {=C2=A0<br>vendor &quot;HITACHI&qu=
ot;=C2=A0<br>product &quot;DF.*&quot;=C2=A0<br>#getuid_callout &quot;/usr/l=
ib/udev/scsi_id --whitelisted --replace-whitespace --device=3D/dev/%n&quot;=
=C2=A0<br>getuid_callout &quot;/lib/udev/scsi_id --whitelisted --replace-wh=
itespace --device=3D/dev/%n&quot;=C2=A0<br>}=C2=A0<br>device {=C2=A0<br>ven=
dor &quot;COMPELNT&quot;=C2=A0<br>product &quot;Compellent Vol&quot;=C2=A0<=
br>no_path_retry 5=C2=A0<br>}=C2=A0<br>device {=C2=A0<br># multipath.conf.d=
efault=C2=A0<br>vendor &quot;DGC&quot;=C2=A0<br>product &quot;.*&quot;=C2=
=A0<br>product_blacklist &quot;LUNZ&quot;=C2=A0<br>path_grouping_policy &qu=
ot;group_by_prio&quot;=C2=A0<br>path_checker &quot;emc_clariion&quot;=C2=A0=
<br>hardware_handler &quot;1 emc&quot;=C2=A0<br>prio &quot;emc&quot;=C2=A0<=
br>failback immediate=C2=A0<br>rr_weight &quot;uniform&quot;=C2=A0<br># vds=
m required configuration=C2=A0<br>#getuid_callout &quot;/usr/lib/udev/scsi_=
id --whitelisted --replace-whitespace --device=3D/dev/%n&quot;=C2=A0<br>get=
uid_callout &quot;/lib/udev/scsi_id --whitelisted --replace-whitespace --de=
vice=3D/dev/%n&quot;=C2=A0<br>features &quot;0&quot;=C2=A0<br>no_path_retry=
 5=C2=A0<br>}=C2=A0<br>}=C2=A0<br>[root@localhost etc]#=C2=A0</span></div><=
div style=3D"color:rgb(0,0,0);font-family:=E5=BE=AE=E8=BD=AF=E9=9B=85=E9=BB=
=91,Tahoma;font-size:14px;line-height:21px"><br></div><div style=3D"color:r=
gb(0,0,0);font-family:=E5=BE=AE=E8=BD=AF=E9=9B=85=E9=BB=91,Tahoma;font-size=
:14px;line-height:21px"><br></div><div style=3D"color:rgb(0,0,0);font-famil=
y:=E5=BE=AE=E8=BD=AF=E9=9B=85=E9=BB=91,Tahoma;font-size:14px;line-height:21=
px">I can not fix this issue .=C2=A0This problem is hard enough to perplex =
.=C2=A0</div><div style=3D"color:rgb(0,0,0);font-family:=E5=BE=AE=E8=BD=AF=
=E9=9B=85=E9=BB=91,Tahoma;font-size:14px;line-height:21px">someone can give=
 me some suggest with it.</div></div>

--001a11c38b2e5eb179050d9ef107--


--===============2806905074412900715==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2806905074412900715==--
