From: "Ignatius, Gianni" <Gianni.Ignatius@innovianet.it>
Subject: multipath + raid software
Date: Tue, 20 Feb 2007 15:27:02 +0100
Message-ID: <0D9CA0B6CBC93846B92708012E8994740CADC6@srvmbx01.innovianet.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1801551954=="
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
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


This is a multi-part message in MIME format.

--===============1801551954==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C754FB.306F6A3F"


This is a multi-part message in MIME format.

------_=_NextPart_001_01C754FB.306F6A3F
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi all,
I've a sun storedge 3120 with 4 disks. I've implemented device mapper =
multipath on 4 disks.=20
I want to know if is possible to implement and raid 1 configuration with =
multipath because when i try i obtain this error

b 20 13:03:35 itcnagiosnd1 kernel: mptscsi: ioc2: attempting task abort! =
(sc=3Dee112dc0)
Feb 20 13:03:35 itcnagiosnd1 kernel: scsi2 : destination target 10, lun =
0
Feb 20 13:03:35 itcnagiosnd1 kernel:         command =3D Write (10) 00 =
03 f1 8c 3f 00 00 80 00=20
Feb 20 13:03:37 itcnagiosnd1 kernel: mptbase: Initiating ioc2 recovery
Feb 20 13:03:42 itcnagiosnd1 kernel: mptscsi: ioc2: task abort: SUCCESS =
(sc=3Dee112dc0)
Feb 20 13:03:42 itcnagiosnd1 kernel: SCSI error : <2 0 10 0> return code =
=3D 0x6000000
Feb 20 13:03:42 itcnagiosnd1 kernel: end_request: I/O error, dev sdc, =
sector 66161855
Feb 20 13:03:42 itcnagiosnd1 kernel: end_request: I/O error, dev sdc, =
sector 66161863
Feb 20 13:03:42 itcnagiosnd1 kernel: device-mapper: dm-multipath: =
Failing path 8:32.
Feb 20 13:03:42 itcnagiosnd1 kernel: SCSI error : <2 0 10 0> return code =
=3D 0x6000000
Feb 20 13:03:42 itcnagiosnd1 kernel: end_request: I/O error, dev sdc, =
sector 66161983
Feb 20 13:03:42 itcnagiosnd1 kernel: end_request: I/O error, dev sdc, =
sector 66161991
Feb 20 13:03:42 itcnagiosnd1 kernel: raid1: Disk failure on dm-14, =
disabling device.=20
Feb 20 13:03:42 itcnagiosnd1 kernel:    Operation continuing on 1 =
devices

if anyone have implemented multipath + mirror configuration please write =
me

this is my chain scsi
[root@itcnagiosnd1 ~]# cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 13 Lun: 00
  Vendor: QUANTUM  Model: SDLT320          Rev: 5E5E
  Type:   Sequential-Access                ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 08 Lun: 00
  Vendor: SEAGATE  Model: ST330000LSUN300G Rev: 045A
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi1 Channel: 00 Id: 09 Lun: 00
  Vendor: SEAGATE  Model: ST330000LSUN300G Rev: 045A
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi2 Channel: 00 Id: 05 Lun: 00
  Vendor: SUN      Model: StorEdge 3120  D Rev: 1180
  Type:   Processor                        ANSI SCSI revision: 02
Host: scsi2 Channel: 00 Id: 10 Lun: 00
  Vendor: SEAGATE  Model: ST330000LSUN300G Rev: 045A
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi2 Channel: 00 Id: 11 Lun: 00
  Vendor: SEAGATE  Model: ST330000LSUN300G Rev: 045A
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi3 Channel: 00 Id: 00 Lun: 00
  Vendor: LSILOGIC Model: Logical Volume   Rev: 3000
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi4 Channel: 00 Id: 00 Lun: 00
  Vendor: AMI      Model: Virtual CDROM    Rev: 1.00
  Type:   CD-ROM                           ANSI SCSI revision: 02
Host: scsi5 Channel: 00 Id: 00 Lun: 00
  Vendor: AMI      Model: Virtual Floppy   Rev: 1.00
  Type:   Direct-Access                    ANSI SCSI revision: 02

and this is my multipath configuration

[root@itcnagiosnd1 ~]# multipath -v3
load path identifiers cache
ux_socket_connect error
#
# all paths in cache :
#
dm-0 blacklisted
dm-10 blacklisted
dm-11 blacklisted
dm-12 blacklisted
dm-13 blacklisted
dm-14 blacklisted
dm-15 blacklisted
dm-1 blacklisted
dm-2 blacklisted
dm-3 blacklisted
dm-4 blacklisted
dm-5 blacklisted
dm-6 blacklisted
dm-7 blacklisted
dm-8 blacklisted
dm-9 blacklisted
hda blacklisted
md0 blacklisted
ram0 blacklisted
ram10 blacklisted
ram11 blacklisted
ram12 blacklisted
ram13 blacklisted
ram14 blacklisted
ram15 blacklisted
ram1 blacklisted
ram2 blacklisted
ram3 blacklisted
ram4 blacklisted
ram5 blacklisted
ram6 blacklisted
ram7 blacklisted
ram8 blacklisted
ram9 blacklisted
path sda not found in pathvec

=3D=3D=3D=3D=3D path info sda (mask 0x1f) =3D=3D=3D=3D=3D
bus =3D 1
dev_t =3D 8:0
size =3D 585937500
vendor =3D SEAGATE=20
product =3D ST330000LSUN300G
rev =3D 045A
h:b:t:l =3D 1:0:8:0
tgt_node_name =3D=20
serial =3D 20527F8H            3KR27F8H
path checker =3D readsector0 (internal default)
state =3D 2
getprio =3D (null) (internal default)
prio =3D 1
getuid =3D /sbin/scsi_id -g -u -s /block/%n (internal default)
uid =3D SSEAGATE_ST330000LSUN30020527F8H____________3KR27F8H (callout)
path sdb not found in pathvec

=3D=3D=3D=3D=3D path info sdb (mask 0x1f) =3D=3D=3D=3D=3D
bus =3D 1
dev_t =3D 8:16
size =3D 585937500
vendor =3D SEAGATE=20
product =3D ST330000LSUN300G
rev =3D 045A
h:b:t:l =3D 1:0:9:0
tgt_node_name =3D=20
serial =3D 20526Y8S            3KR26Y8S
path checker =3D readsector0 (internal default)
state =3D 2
getprio =3D (null) (internal default)
prio =3D 1
getuid =3D /sbin/scsi_id -g -u -s /block/%n (internal default)
uid =3D SSEAGATE_ST330000LSUN30020526Y8S____________3KR26Y8S (callout)
path sdc not found in pathvec

=3D=3D=3D=3D=3D path info sdc (mask 0x1f) =3D=3D=3D=3D=3D
bus =3D 1
dev_t =3D 8:32
size =3D 585937500
vendor =3D SEAGATE=20
product =3D ST330000LSUN300G
rev =3D 045A
h:b:t:l =3D 2:0:10:0
tgt_node_name =3D=20
serial =3D 205263GA            3KR263GA
path checker =3D readsector0 (internal default)
state =3D 2
getprio =3D (null) (internal default)
prio =3D 1
getuid =3D /sbin/scsi_id -g -u -s /block/%n (internal default)
uid =3D SSEAGATE_ST330000LSUN300205263GA____________3KR263GA (callout)
path sdd not found in pathvec

=3D=3D=3D=3D=3D path info sdd (mask 0x1f) =3D=3D=3D=3D=3D
bus =3D 1
dev_t =3D 8:48
size =3D 585937500
vendor =3D SEAGATE=20
product =3D ST330000LSUN300G
rev =3D 045A
h:b:t:l =3D 2:0:11:0
tgt_node_name =3D=20
serial =3D 20526WQK            3KR26WQK
path checker =3D readsector0 (internal default)
state =3D 2
getprio =3D (null) (internal default)
prio =3D 1
getuid =3D /sbin/scsi_id -g -u -s /block/%n (internal default)
uid =3D SSEAGATE_ST330000LSUN30020526WQK____________3KR26WQK (callout)
path sde not found in pathvec

=3D=3D=3D=3D=3D path info sde (mask 0x1f) =3D=3D=3D=3D=3D
bus =3D 1
dev_t =3D 8:64
size =3D 142577664
vendor =3D LSILOGIC
product =3D Logical Volume =20
rev =3D 3000
h:b:t:l =3D 3:0:0:0
tgt_node_name =3D=20
serial =3D=20
path checker =3D readsector0 (internal default)
state =3D 2
getprio =3D (null) (internal default)
prio =3D 1
getuid =3D /sbin/scsi_id -g -u -s /block/%n (internal default)
uid =3D 3600508e0000000001d1979b4e1f32803 (callout)
path sdf not found in pathvec

=3D=3D=3D=3D=3D path info sdf (mask 0x1f) =3D=3D=3D=3D=3D
bus =3D 1
dev_t =3D 8:80
size =3D 0
vendor =3D AMI    =20
product =3D Virtual Floppy =20
rev =3D 1.00
h:b:t:l =3D 5:0:0:0
tgt_node_name =3D=20
sr0 blacklisted
#
# all paths :
#
SSEAGATE_ST330000LSUN30020527F8H____________3KR27F8H  1:0:8:0 sda 8:0 1 =
[ready
SSEAGATE_ST330000LSUN30020526Y8S____________3KR26Y8S  1:0:9:0 sdb 8:16 1 =
[read
SSEAGATE_ST330000LSUN300205263GA____________3KR263GA  2:0:10:0 sdc 8:32 =
1 [rea
SSEAGATE_ST330000LSUN30020526WQK____________3KR26WQK  2:0:11:0 sdd 8:48 =
1 [rea
3600508e0000000001d1979b4e1f32803  3:0:0:0 sde 8:64 1 [ready] =
LSILOGIC/Logical
  5:0:0:0 sdf 8:80  [faulty] AMI     /Virtual Floppy  /1.00
params =3D 0 0 1 1 round-robin 0 1 1 8:32 1000=20
status =3D 1 0 0 1 1 A 0 1 0 8:32 A 0=20
params =3D 0 0 1 1 round-robin 0 1 1 8:16 1000=20
status =3D 1 0 0 1 1 A 0 1 0 8:16 A 0=20
params =3D 0 0 1 1 round-robin 0 1 1 8:0 1000=20
status =3D 1 0 0 1 1 A 0 1 0 8:0 A 0=20
params =3D 0 0 1 1 round-robin 0 1 1 8:48 1000=20
status =3D 1 0 0 1 1 A 0 1 0 8:48 A 0=20
Found matching wwid =
[SSEAGATE_ST330000LSUN30020527F8H____________3KR27F8H] in bindings file.
Setting alias to mpath0
pgpolicy =3D failover (internal default)
selector =3D round-robin 0 (internal default)
features =3D 0 (internal default)
hwhandler =3D 0 (internal default)
rr_weight =3D 1 (internal default)
no_path_retry =3D NONE (internal default)
pg_timeout =3D NONE (internal default)
0 585937500 multipath 0 0 1 1 round-robin 0 1 1 8:0 1000
set ACT_NOTHING: map unchanged
Found matching wwid =
[SSEAGATE_ST330000LSUN30020526Y8S____________3KR26Y8S] in bindings file.
Setting alias to mpath1
pgpolicy =3D failover (internal default)
selector =3D round-robin 0 (internal default)
features =3D 0 (internal default)
hwhandler =3D 0 (internal default)
rr_weight =3D 1 (internal default)
no_path_retry =3D NONE (internal default)
pg_timeout =3D NONE (internal default)
0 585937500 multipath 0 0 1 1 round-robin 0 1 1 8:16 1000
set ACT_NOTHING: map unchanged
Found matching wwid =
[SSEAGATE_ST330000LSUN300205263GA____________3KR263GA] in bindings file.
Setting alias to mpath2
pgpolicy =3D failover (internal default)
selector =3D round-robin 0 (internal default)
features =3D 0 (internal default)
hwhandler =3D 0 (internal default)
rr_weight =3D 1 (internal default)
no_path_retry =3D NONE (internal default)
pg_timeout =3D NONE (internal default)
0 585937500 multipath 0 0 1 1 round-robin 0 1 1 8:32 1000
set ACT_NOTHING: map unchanged
Found matching wwid =
[SSEAGATE_ST330000LSUN30020526WQK____________3KR26WQK] in bindings file.
Setting alias to mpath3
pgpolicy =3D failover (internal default)
selector =3D round-robin 0 (internal default)
features =3D 0 (internal default)
hwhandler =3D 0 (internal default)
rr_weight =3D 1 (internal default)
no_path_retry =3D NONE (internal default)
pg_timeout =3D NONE (internal default)
0 585937500 multipath 0 0 1 1 round-robin 0 1 1 8:48 1000
set ACT_NOTHING: map unchanged
Found matching wwid [3600508e0000000001d1979b4e1f32803] in bindings =
file.
Setting alias to mpath4
pgpolicy =3D failover (internal default)
selector =3D round-robin 0 (internal default)
features =3D 0 (internal default)
hwhandler =3D 0 (internal default)
rr_weight =3D 1 (internal default)
no_path_retry =3D NONE (internal default)
pg_timeout =3D NONE (internal default)
0 142577664 multipath 0 0 1 1 round-robin 0 1 1 8:64 1000
set ACT_CREATE: map does not exists

best regards

Gianni Ignatius



------_=_NextPart_001_01C754FB.306F6A3F
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Diso-8859-1">
<META NAME=3D"Generator" CONTENT=3D"MS Exchange Server version =
6.5.7638.1">
<TITLE>multipath + raid software</TITLE>
</HEAD>
<BODY>
<!-- Converted from text/plain format -->

<P><FONT SIZE=3D2>Hi all,<BR>
I've a sun storedge 3120 with 4 disks. I've implemented device mapper =
multipath on 4 disks.<BR>
I want to know if is possible to implement and raid 1 configuration with =
multipath because when i try i obtain this error<BR>
<BR>
b 20 13:03:35 itcnagiosnd1 kernel: mptscsi: ioc2: attempting task abort! =
(sc=3Dee112dc0)<BR>
Feb 20 13:03:35 itcnagiosnd1 kernel: scsi2 : destination target 10, lun =
0<BR>
Feb 20 13:03:35 itcnagiosnd1 =
kernel:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; command =3D =
Write (10) 00 03 f1 8c 3f 00 00 80 00<BR>
Feb 20 13:03:37 itcnagiosnd1 kernel: mptbase: Initiating ioc2 =
recovery<BR>
Feb 20 13:03:42 itcnagiosnd1 kernel: mptscsi: ioc2: task abort: SUCCESS =
(sc=3Dee112dc0)<BR>
Feb 20 13:03:42 itcnagiosnd1 kernel: SCSI error : &lt;2 0 10 0&gt; =
return code =3D 0x6000000<BR>
Feb 20 13:03:42 itcnagiosnd1 kernel: end_request: I/O error, dev sdc, =
sector 66161855<BR>
Feb 20 13:03:42 itcnagiosnd1 kernel: end_request: I/O error, dev sdc, =
sector 66161863<BR>
Feb 20 13:03:42 itcnagiosnd1 kernel: device-mapper: dm-multipath: =
Failing path 8:32.<BR>
Feb 20 13:03:42 itcnagiosnd1 kernel: SCSI error : &lt;2 0 10 0&gt; =
return code =3D 0x6000000<BR>
Feb 20 13:03:42 itcnagiosnd1 kernel: end_request: I/O error, dev sdc, =
sector 66161983<BR>
Feb 20 13:03:42 itcnagiosnd1 kernel: end_request: I/O error, dev sdc, =
sector 66161991<BR>
Feb 20 13:03:42 itcnagiosnd1 kernel: raid1: Disk failure on dm-14, =
disabling device.<BR>
Feb 20 13:03:42 itcnagiosnd1 kernel:&nbsp;&nbsp;&nbsp; Operation =
continuing on 1 devices<BR>
<BR>
if anyone have implemented multipath + mirror configuration please write =
me<BR>
<BR>
this is my chain scsi<BR>
[root@itcnagiosnd1 ~]# cat /proc/scsi/scsi<BR>
Attached devices:<BR>
Host: scsi0 Channel: 00 Id: 13 Lun: 00<BR>
&nbsp; Vendor: QUANTUM&nbsp; Model: =
SDLT320&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: =
5E5E<BR>
&nbsp; Type:&nbsp;&nbsp; =
Sequential-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI revision: 02<BR>
Host: scsi1 Channel: 00 Id: 08 Lun: 00<BR>
&nbsp; Vendor: SEAGATE&nbsp; Model: ST330000LSUN300G Rev: 045A<BR>
&nbsp; Type:&nbsp;&nbsp; =
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI =
revision: 03<BR>
Host: scsi1 Channel: 00 Id: 09 Lun: 00<BR>
&nbsp; Vendor: SEAGATE&nbsp; Model: ST330000LSUN300G Rev: 045A<BR>
&nbsp; Type:&nbsp;&nbsp; =
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI =
revision: 03<BR>
Host: scsi2 Channel: 00 Id: 05 Lun: 00<BR>
&nbsp; Vendor: SUN&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Model: StorEdge =
3120&nbsp; D Rev: 1180<BR>
&nbsp; Type:&nbsp;&nbsp; =
Processor&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; ANSI SCSI revision: 02<BR>
Host: scsi2 Channel: 00 Id: 10 Lun: 00<BR>
&nbsp; Vendor: SEAGATE&nbsp; Model: ST330000LSUN300G Rev: 045A<BR>
&nbsp; Type:&nbsp;&nbsp; =
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI =
revision: 03<BR>
Host: scsi2 Channel: 00 Id: 11 Lun: 00<BR>
&nbsp; Vendor: SEAGATE&nbsp; Model: ST330000LSUN300G Rev: 045A<BR>
&nbsp; Type:&nbsp;&nbsp; =
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI =
revision: 03<BR>
Host: scsi3 Channel: 00 Id: 00 Lun: 00<BR>
&nbsp; Vendor: LSILOGIC Model: Logical Volume&nbsp;&nbsp; Rev: 3000<BR>
&nbsp; Type:&nbsp;&nbsp; =
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI =
revision: 02<BR>
Host: scsi4 Channel: 00 Id: 00 Lun: 00<BR>
&nbsp; Vendor: AMI&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Model: Virtual =
CDROM&nbsp;&nbsp;&nbsp; Rev: 1.00<BR>
&nbsp; Type:&nbsp;&nbsp; =
CD-ROM&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp; ANSI SCSI revision: 02<BR>
Host: scsi5 Channel: 00 Id: 00 Lun: 00<BR>
&nbsp; Vendor: AMI&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Model: Virtual =
Floppy&nbsp;&nbsp; Rev: 1.00<BR>
&nbsp; Type:&nbsp;&nbsp; =
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ANSI SCSI =
revision: 02<BR>
<BR>
and this is my multipath configuration<BR>
<BR>
[root@itcnagiosnd1 ~]# multipath -v3<BR>
load path identifiers cache<BR>
ux_socket_connect error<BR>
#<BR>
# all paths in cache :<BR>
#<BR>
dm-0 blacklisted<BR>
dm-10 blacklisted<BR>
dm-11 blacklisted<BR>
dm-12 blacklisted<BR>
dm-13 blacklisted<BR>
dm-14 blacklisted<BR>
dm-15 blacklisted<BR>
dm-1 blacklisted<BR>
dm-2 blacklisted<BR>
dm-3 blacklisted<BR>
dm-4 blacklisted<BR>
dm-5 blacklisted<BR>
dm-6 blacklisted<BR>
dm-7 blacklisted<BR>
dm-8 blacklisted<BR>
dm-9 blacklisted<BR>
hda blacklisted<BR>
md0 blacklisted<BR>
ram0 blacklisted<BR>
ram10 blacklisted<BR>
ram11 blacklisted<BR>
ram12 blacklisted<BR>
ram13 blacklisted<BR>
ram14 blacklisted<BR>
ram15 blacklisted<BR>
ram1 blacklisted<BR>
ram2 blacklisted<BR>
ram3 blacklisted<BR>
ram4 blacklisted<BR>
ram5 blacklisted<BR>
ram6 blacklisted<BR>
ram7 blacklisted<BR>
ram8 blacklisted<BR>
ram9 blacklisted<BR>
path sda not found in pathvec<BR>
<BR>
=3D=3D=3D=3D=3D path info sda (mask 0x1f) =3D=3D=3D=3D=3D<BR>
bus =3D 1<BR>
dev_t =3D 8:0<BR>
size =3D 585937500<BR>
vendor =3D SEAGATE<BR>
product =3D ST330000LSUN300G<BR>
rev =3D 045A<BR>
h:b:t:l =3D 1:0:8:0<BR>
tgt_node_name =3D<BR>
serial =3D =
20527F8H&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; 3KR27F8H<BR>
path checker =3D readsector0 (internal default)<BR>
state =3D 2<BR>
getprio =3D (null) (internal default)<BR>
prio =3D 1<BR>
getuid =3D /sbin/scsi_id -g -u -s /block/%n (internal default)<BR>
uid =3D SSEAGATE_ST330000LSUN30020527F8H____________3KR27F8H =
(callout)<BR>
path sdb not found in pathvec<BR>
<BR>
=3D=3D=3D=3D=3D path info sdb (mask 0x1f) =3D=3D=3D=3D=3D<BR>
bus =3D 1<BR>
dev_t =3D 8:16<BR>
size =3D 585937500<BR>
vendor =3D SEAGATE<BR>
product =3D ST330000LSUN300G<BR>
rev =3D 045A<BR>
h:b:t:l =3D 1:0:9:0<BR>
tgt_node_name =3D<BR>
serial =3D =
20526Y8S&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; 3KR26Y8S<BR>
path checker =3D readsector0 (internal default)<BR>
state =3D 2<BR>
getprio =3D (null) (internal default)<BR>
prio =3D 1<BR>
getuid =3D /sbin/scsi_id -g -u -s /block/%n (internal default)<BR>
uid =3D SSEAGATE_ST330000LSUN30020526Y8S____________3KR26Y8S =
(callout)<BR>
path sdc not found in pathvec<BR>
<BR>
=3D=3D=3D=3D=3D path info sdc (mask 0x1f) =3D=3D=3D=3D=3D<BR>
bus =3D 1<BR>
dev_t =3D 8:32<BR>
size =3D 585937500<BR>
vendor =3D SEAGATE<BR>
product =3D ST330000LSUN300G<BR>
rev =3D 045A<BR>
h:b:t:l =3D 2:0:10:0<BR>
tgt_node_name =3D<BR>
serial =3D =
205263GA&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; 3KR263GA<BR>
path checker =3D readsector0 (internal default)<BR>
state =3D 2<BR>
getprio =3D (null) (internal default)<BR>
prio =3D 1<BR>
getuid =3D /sbin/scsi_id -g -u -s /block/%n (internal default)<BR>
uid =3D SSEAGATE_ST330000LSUN300205263GA____________3KR263GA =
(callout)<BR>
path sdd not found in pathvec<BR>
<BR>
=3D=3D=3D=3D=3D path info sdd (mask 0x1f) =3D=3D=3D=3D=3D<BR>
bus =3D 1<BR>
dev_t =3D 8:48<BR>
size =3D 585937500<BR>
vendor =3D SEAGATE<BR>
product =3D ST330000LSUN300G<BR>
rev =3D 045A<BR>
h:b:t:l =3D 2:0:11:0<BR>
tgt_node_name =3D<BR>
serial =3D =
20526WQK&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; 3KR26WQK<BR>
path checker =3D readsector0 (internal default)<BR>
state =3D 2<BR>
getprio =3D (null) (internal default)<BR>
prio =3D 1<BR>
getuid =3D /sbin/scsi_id -g -u -s /block/%n (internal default)<BR>
uid =3D SSEAGATE_ST330000LSUN30020526WQK____________3KR26WQK =
(callout)<BR>
path sde not found in pathvec<BR>
<BR>
=3D=3D=3D=3D=3D path info sde (mask 0x1f) =3D=3D=3D=3D=3D<BR>
bus =3D 1<BR>
dev_t =3D 8:64<BR>
size =3D 142577664<BR>
vendor =3D LSILOGIC<BR>
product =3D Logical Volume&nbsp;<BR>
rev =3D 3000<BR>
h:b:t:l =3D 3:0:0:0<BR>
tgt_node_name =3D<BR>
serial =3D<BR>
path checker =3D readsector0 (internal default)<BR>
state =3D 2<BR>
getprio =3D (null) (internal default)<BR>
prio =3D 1<BR>
getuid =3D /sbin/scsi_id -g -u -s /block/%n (internal default)<BR>
uid =3D 3600508e0000000001d1979b4e1f32803 (callout)<BR>
path sdf not found in pathvec<BR>
<BR>
=3D=3D=3D=3D=3D path info sdf (mask 0x1f) =3D=3D=3D=3D=3D<BR>
bus =3D 1<BR>
dev_t =3D 8:80<BR>
size =3D 0<BR>
vendor =3D AMI&nbsp;&nbsp;&nbsp;&nbsp;<BR>
product =3D Virtual Floppy&nbsp;<BR>
rev =3D 1.00<BR>
h:b:t:l =3D 5:0:0:0<BR>
tgt_node_name =3D<BR>
sr0 blacklisted<BR>
#<BR>
# all paths :<BR>
#<BR>
SSEAGATE_ST330000LSUN30020527F8H____________3KR27F8H&nbsp; 1:0:8:0 sda =
8:0 1 [ready<BR>
SSEAGATE_ST330000LSUN30020526Y8S____________3KR26Y8S&nbsp; 1:0:9:0 sdb =
8:16 1 [read<BR>
SSEAGATE_ST330000LSUN300205263GA____________3KR263GA&nbsp; 2:0:10:0 sdc =
8:32 1 [rea<BR>
SSEAGATE_ST330000LSUN30020526WQK____________3KR26WQK&nbsp; 2:0:11:0 sdd =
8:48 1 [rea<BR>
3600508e0000000001d1979b4e1f32803&nbsp; 3:0:0:0 sde 8:64 1 [ready] =
LSILOGIC/Logical<BR>
&nbsp; 5:0:0:0 sdf 8:80&nbsp; [faulty] AMI&nbsp;&nbsp;&nbsp;&nbsp; =
/Virtual Floppy&nbsp; /1.00<BR>
params =3D 0 0 1 1 round-robin 0 1 1 8:32 1000<BR>
status =3D 1 0 0 1 1 A 0 1 0 8:32 A 0<BR>
params =3D 0 0 1 1 round-robin 0 1 1 8:16 1000<BR>
status =3D 1 0 0 1 1 A 0 1 0 8:16 A 0<BR>
params =3D 0 0 1 1 round-robin 0 1 1 8:0 1000<BR>
status =3D 1 0 0 1 1 A 0 1 0 8:0 A 0<BR>
params =3D 0 0 1 1 round-robin 0 1 1 8:48 1000<BR>
status =3D 1 0 0 1 1 A 0 1 0 8:48 A 0<BR>
Found matching wwid =
[SSEAGATE_ST330000LSUN30020527F8H____________3KR27F8H] in bindings =
file.<BR>
Setting alias to mpath0<BR>
pgpolicy =3D failover (internal default)<BR>
selector =3D round-robin 0 (internal default)<BR>
features =3D 0 (internal default)<BR>
hwhandler =3D 0 (internal default)<BR>
rr_weight =3D 1 (internal default)<BR>
no_path_retry =3D NONE (internal default)<BR>
pg_timeout =3D NONE (internal default)<BR>
0 585937500 multipath 0 0 1 1 round-robin 0 1 1 8:0 1000<BR>
set ACT_NOTHING: map unchanged<BR>
Found matching wwid =
[SSEAGATE_ST330000LSUN30020526Y8S____________3KR26Y8S] in bindings =
file.<BR>
Setting alias to mpath1<BR>
pgpolicy =3D failover (internal default)<BR>
selector =3D round-robin 0 (internal default)<BR>
features =3D 0 (internal default)<BR>
hwhandler =3D 0 (internal default)<BR>
rr_weight =3D 1 (internal default)<BR>
no_path_retry =3D NONE (internal default)<BR>
pg_timeout =3D NONE (internal default)<BR>
0 585937500 multipath 0 0 1 1 round-robin 0 1 1 8:16 1000<BR>
set ACT_NOTHING: map unchanged<BR>
Found matching wwid =
[SSEAGATE_ST330000LSUN300205263GA____________3KR263GA] in bindings =
file.<BR>
Setting alias to mpath2<BR>
pgpolicy =3D failover (internal default)<BR>
selector =3D round-robin 0 (internal default)<BR>
features =3D 0 (internal default)<BR>
hwhandler =3D 0 (internal default)<BR>
rr_weight =3D 1 (internal default)<BR>
no_path_retry =3D NONE (internal default)<BR>
pg_timeout =3D NONE (internal default)<BR>
0 585937500 multipath 0 0 1 1 round-robin 0 1 1 8:32 1000<BR>
set ACT_NOTHING: map unchanged<BR>
Found matching wwid =
[SSEAGATE_ST330000LSUN30020526WQK____________3KR26WQK] in bindings =
file.<BR>
Setting alias to mpath3<BR>
pgpolicy =3D failover (internal default)<BR>
selector =3D round-robin 0 (internal default)<BR>
features =3D 0 (internal default)<BR>
hwhandler =3D 0 (internal default)<BR>
rr_weight =3D 1 (internal default)<BR>
no_path_retry =3D NONE (internal default)<BR>
pg_timeout =3D NONE (internal default)<BR>
0 585937500 multipath 0 0 1 1 round-robin 0 1 1 8:48 1000<BR>
set ACT_NOTHING: map unchanged<BR>
Found matching wwid [3600508e0000000001d1979b4e1f32803] in bindings =
file.<BR>
Setting alias to mpath4<BR>
pgpolicy =3D failover (internal default)<BR>
selector =3D round-robin 0 (internal default)<BR>
features =3D 0 (internal default)<BR>
hwhandler =3D 0 (internal default)<BR>
rr_weight =3D 1 (internal default)<BR>
no_path_retry =3D NONE (internal default)<BR>
pg_timeout =3D NONE (internal default)<BR>
0 142577664 multipath 0 0 1 1 round-robin 0 1 1 8:64 1000<BR>
set ACT_CREATE: map does not exists<BR>
<BR>
best regards<BR>
<BR>
Gianni Ignatius<BR>
<BR>
<BR>
</FONT>
</P>

</BODY>
</HTML>
------_=_NextPart_001_01C754FB.306F6A3F--


--===============1801551954==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1801551954==--
