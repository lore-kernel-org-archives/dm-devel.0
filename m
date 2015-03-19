From: Ilan Steinberg <ilan.steinberg@kaminario.com>
Subject: A path to a different device was added to an existing
	mapth
Date: Thu, 19 Mar 2015 10:10:36 +0000
Message-ID: <1426759835576.51213@kaminario.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0596922944359139841=="
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: Guy Keren <guy.keren@kaminario.com>, Eli Malul <eli.malul@kaminario.com>, Shahar Salzman <shahar.salzman@kaminario.com>
List-Id: dm-devel.ids

--===============0596922944359139841==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_142675983557651213kaminariocom_"

--_000_142675983557651213kaminariocom_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hello,


I have never posted here before but I can across an interesting error.


I have run into a situation were a path (sdag) to LUN 15 with a scsi serial=
 number of ending with 0xd5190010 was added to an mapth (mpathiw) which is =
for LUN 11 with scsi serial number ending with 0xd5190026 (sdz and sdw)


I would appreciate any help understanding how/why this happened.


Initiator Info:

Linux il-ksm3-044 2.6.32-431.el6.x86_64 #1

device-mapper-multipath version 0.4.9


multipath.conf:

defaults {
                   user_friendly_names     yes
                   polling_interval        10
                    verbosity               2
}
devices {
                    device  {
                             vendor                      "KMNRIO"
                             product                     "K2"
                         path_grouping_policy        multibus
                             getuid_callout          "/lib/udev/scsi_id --w=
hitelisted --device=3D/dev/%n"
                             path_checker                tur
                             path_selector               "queue-length 0"
                             no_path_retry               fail
                             hardware_handler            "0"
                             rr_weight                   priorities
                             rr_min_io               1
                             failback                15
                             fast_io_fail_tmo        5
                             dev_loss_tmo            8
                             }
}


Since I see that sdz and sdw used to belong to mapthiv (was it renamed to m=
athiw?)

This might be useful info - in the bindings file I see:

...

mpathiv 20024f400d5190010                      <---------------------------=
------------- this is the scsi_sn of sdag

mpathiw 20024f400d5190026                     <----------------------------=
------------ this is the scsi_sn of sdz/w

...


I am adding the relevant host logs (I can add the full logs if needed) - er=
ror is in the last log line:

Mar 14 09:44:36 il-ksm3-044 kernel: sdag: detected capacity change from 0 t=
o 322122547200

Mar 14 09:59:35 il-ksm3-044 kernel: sd 8:0:1:15: [sdag] Warning! Received a=
n indication that the LUN reached a thin provisioning soft threshold.

Mar 14 10:00:06 il-ksm3-044 kernel: sd 8:0:1:15: [sdag] Warning! Received a=
n indication that the LUN reached a thin provisioning soft threshold.

Mar 14 10:00:21 il-ksm3-044 kernel: sd 8:0:1:15: [sdag] Warning! Received a=
n indication that the LUN reached a thin provisioning soft threshold.

Mar 14 10:26:31 il-ksm3-044 kernel: end_request: I/O error, dev sdz, sector=
 167369280
Mar 14 10:26:31 il-ksm3-044 kernel: end_request: I/O error, dev sdz, sector=
 80032448

Mar 14 10:26:44 il-ksm3-044 multipathd: sdz: remove path (uevent)
Mar 14 10:26:44 il-ksm3-044 multipathd: sdz [65:144]: path removed from map=
 mpathiv
Mar 14 10:26:44 il-ksm3-044 multipathd: sdag: remove path (uevent)
Mar 14 10:26:44 il-ksm3-044 multipathd: sdag [66:0]: path removed from map =
mpathks

Mar 14 10:26:44 il-ksm3-044 multipathd: mpathiv: load table [0 209715200 mu=
ltipath 0 0 1 1 queue-length 0 1 1 65:96 1]
Mar 14 10:26:44 il-ksm3-044 multipathd: mpathks: load table [0 629145600 mu=
ltipath 0 0 1 1 queue-length 0 1 1 65:240 1]

Mar 14 10:53:50 il-ksm3-044 kernel: sd 8:0:1:11: [sdz] 209715200 512-byte l=
ogical blocks: (107 GB/100 GiB)
Mar 14 10:53:50 il-ksm3-044 kernel: sd 8:0:1:11: [sdz] Write Protect is off
Mar 14 10:53:50 il-ksm3-044 kernel: sd 8:0:1:11: [sdz] Write cache: disable=
d, read cache: enabled, supports DPO and FUA
Mar 14 10:53:50 il-ksm3-044 kernel: sdz:
Mar 14 10:53:50 il-ksm3-044 kernel: sd 8:0:1:11: [sdz] Attached SCSI disk
Mar 14 10:53:50 il-ksm3-044 kernel: sd 8:0:1:15: [sdag] 629145600 512-byte =
logical blocks: (322 GB/300 GiB)
Mar 14 10:53:50 il-ksm3-044 kernel: sd 8:0:1:15: [sdag] Write Protect is of=
f
Mar 14 10:53:50 il-ksm3-044 kernel: sd 8:0:1:15: [sdag] Write cache: disabl=
ed, read cache: enabled, supports DPO and FUA
Mar 14 10:53:50 il-ksm3-044 kernel: sdag: unknown partition table
Mar 14 10:53:50 il-ksm3-044 kernel: sd 8:0:1:15: [sdag] Attached SCSI disk
Mar 14 10:53:50 il-ksm3-044 multipathd: sdag: add path (uevent)
Mar 14 10:53:50 il-ksm3-044 multipathd: mpathks: failed in domap for additi=
on of new path sdag
Mar 14 10:53:50 il-ksm3-044 multipathd: sdz: add path (uevent)
Mar 14 10:53:50 il-ksm3-044 multipathd: sdz [65:144]: path added to devmap =
mpathiv

Mar 14 10:53:50 il-ksm3-044 multipathd: mpathiv: load table [0 209715200 mu=
ltipath 0 0 1 1 queue-length 0 2 1 65:96 1 65:144 1]

Mar 14 12:29:12 il-ksm3-044 multipathd: sdw: remove path (uevent)
Mar 14 12:29:12 il-ksm3-044 multipathd: mpathiv: load table [0 209715200 mu=
ltipath 0 0 1 1 queue-length 0 1 1 65:144 1]
Mar 14 12:29:12 il-ksm3-044 multipathd: sdw [65:96]: path removed from map =
mpathiv

Mar 15 12:45:59 il-ksm3-044 kernel: sd 8:0:1:11: [sdz] Warning! Received an=
 indication that the LUN assignments on this target have changed. The Linux=
 SCSI layer does not automatically remap LUN assignments.

Mar 14 12:59:18 il-ksm3-044 kernel: sd 7:0:1:11: [sdw] 209715200 512-byte l=
ogical blocks: (107 GB/100 GiB)
Mar 14 12:59:18 il-ksm3-044 kernel: sd 7:0:1:11: [sdw] Write Protect is off
Mar 14 12:59:18 il-ksm3-044 kernel: sd 7:0:1:11: [sdw] Write cache: disable=
d, read cache: enabled, supports DPO and FUA
Mar 14 12:59:18 il-ksm3-044 kernel: sd 7:0:1:11: [sdw] Attached SCSI disk

Mar 14 12:59:18 il-ksm3-044 multipathd: sdw: add path (uevent)
Mar 14 12:59:18 il-ksm3-044 multipathd: mpathiv: load table [0 209715200 mu=
ltipath 0 0 1 1 queue-length 0 2 1 65:144 1 65:96 1]
Mar 14 12:59:18 il-ksm3-044 multipathd: sdw [65:96]: path added to devmap m=
pathiv

Mar 15 11:45:27 il-ksm3-044 kernel: sdz: detected capacity change from 0 to=
 107374182400

Mar 15 11:45:33 il-ksm3-044 multipathd: mpathiw: event checker started
Mar 15 11:45:33 il-ksm3-044 multipathd: mpathiw: devmap dm-13 added

Mar 15 12:28:12 il-ksm3-044 multipathd: mpathiw: event checker exit

Mar 15 12:28:15 il-ksm3-044 multipathd: mpathiw: event checker started
Mar 15 12:28:15 il-ksm3-044 multipathd: mpathiw: devmap dm-13 added

Mar 15 12:56:35 il-ksm3-044 kernel: end_request: I/O error, dev sdz, sector=
 204563968
Mar 15 12:56:35 il-ksm3-044 kernel: end_request: I/O error, dev sdz, sector=
 193484032
Mar 15 12:56:35 il-ksm3-044 multipathd: mpathiw: remaining active paths: 1

Mar 15 12:56:48 il-ksm3-044 multipathd: sdz: remove path (uevent)
Mar 15 12:56:48 il-ksm3-044 multipathd: mpathiw: load table [0 209715200 mu=
ltipath 0 0 1 1 queue-length 0 1 1 65:96 1]
Mar 15 12:56:48 il-ksm3-044 multipathd: sdz [65:144]: path removed from map=
 mpathiw
Mar 15 12:56:48 il-ksm3-044 multipathd: sdag: remove path (uevent)

Mar 15 13:27:00 il-ksm3-044 kernel: sd 8:0:1:11: [sdz] 209715200 512-byte l=
ogical blocks: (107 GB/100 GiB)
Mar 15 13:27:00 il-ksm3-044 kernel: sd 8:0:1:11: [sdz] Write Protect is off
Mar 15 13:27:00 il-ksm3-044 kernel: sd 8:0:1:11: [sdz] Write cache: disable=
d, read cache: enabled, supports DPO and FUA
Mar 15 13:27:00 il-ksm3-044 kernel: sdz: unknown partition table
Mar 15 13:27:00 il-ksm3-044 kernel: sd 8:0:1:11: [sdz] Attached SCSI disk
Mar 15 13:27:00 il-ksm3-044 multipathd: sdz: add path (uevent)
Mar 15 13:27:00 il-ksm3-044 multipathd: mpathiw: failed in domap for additi=
on of new path sdz

Mar 15 15:20:41 il-ksm3-044 multipathd: mpathiw: devmap dm-13 added

Mar 15 17:38:36 il-ksm3-044 kernel: sd 8:0:1:11: [sdz] Warning! Received an=
 indication that the LUN assignments on this target have changed. The Linux=
 SCSI layer does not automatically remap LUN assignments.

Mar 15 18:44:54 il-ksm3-044 kernel: sd 8:0:1:15: [sdag] 629145600 512-byte =
logical blocks: (322 GB/300 GiB)
Mar 15 18:44:54 il-ksm3-044 kernel: sd 8:0:1:15: [sdag] Write Protect is of=
f
Mar 15 18:44:54 il-ksm3-044 kernel: sd 8:0:1:15: [sdag] Write cache: disabl=
ed, read cache: enabled, supports DPO and FUA
Mar 15 18:44:54 il-ksm3-044 kernel: sdag: unknown partition table
Mar 15 18:44:54 il-ksm3-044 kernel: sd 8:0:1:15: [sdag] Attached SCSI disk

Mar 15 18:44:55 il-ksm3-044 multipathd: sdag: add path (uevent)
Mar 15 18:44:55 il-ksm3-044 multipathd: mpathiw: load table [0 209715200 mu=
ltipath 0 0 1 1 queue-length 0 3 1 65:96 1 65:144 1 66:0 1]
Mar 15 18:44:55 il-ksm3-044 multipathd: sdag [66:0]: path added to devmap m=
pathiw

Thank you,
Ilan Steinberg

--_000_142675983557651213kaminariocom_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-8859-=
1">
<style type=3D"text/css" style=3D"display:none;"><!-- P {margin-top:0;margi=
n-bottom:0;} --></style>
</head>
<body dir=3D"ltr">
<div id=3D"divtagdefaultwrapper" style=3D"font-size:12pt;color:#000000;back=
ground-color:#FFFFFF;font-family:Calibri,Arial,Helvetica,sans-serif;">
<p>Hello,</p>
<p><br>
</p>
<p>I have never posted here before but I can across an interesting error.</=
p>
<p><br>
</p>
<p>I have run into a situation were a path (sdag) to LUN 15 with a scsi ser=
ial number of ending with 0xd5190010 was added to an mapth (mpathiw) which =
is for LUN 11 with scsi serial number ending with 0xd5190026 (sdz and sdw)<=
br>
</p>
<p><br>
</p>
<p>I would appreciate any help understanding how/why this happened.<br>
</p>
<p><br>
</p>
<p>Initiator Info:<br>
</p>
<p>Linux il-ksm3-044 2.6.32-431.el6.x86_64 #1</p>
<p>device-mapper-multipath version 0.4.9</p>
<p><br>
</p>
<p>multipath.conf:</p>
<p><span style=3D"font-size: 8pt;">defaults {<br style=3D"">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; user_friendly_names&nbsp;&nbsp;&nbsp;&nbs=
p; yes<br style=3D"">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; polling_interval&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp; 10<br style=3D"">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; verbosity&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2<br style=3D"">
}<br style=3D"">
devices {<br style=3D"">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; device&nbsp; {<br style=3D"">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; vendor&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; &quot;KMNRIO&quot;<br style=3D"">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; product&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &qu=
ot;K2&quot;<br style=3D"">
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; path_group=
ing_policy&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; multibus<br style=3D""=
>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; getuid_callout&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; &quot;/lib/udev/scsi_id --whitelisted --device=3D/dev/%n&quot;=
<br style=3D"">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; path_checker&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; tur<br style=3D"">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; path_selector&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;queue-length 0&quot;<br sty=
le=3D"">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; no_path_retry&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; fail<br style=3D"">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; hardware_handler&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp; &quot;0&quot;<br style=3D"">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; rr_weight&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; priorities<br=
 style=3D"">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; rr_min_io&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1<br style=3D"">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; failback&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 15<br style=3D"">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; fast_io_fail_tmo&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 5<br style=3D"">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; dev_loss_tmo&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp; 8<br style=3D"">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; }<br style=3D"">
}<br style=3D"">
</span></p>
<p><br>
</p>
<p>Since I see that sdz and sdw used to belong to mapthiv (was it renamed t=
o mathiw?)<br>
</p>
<p>This might be useful info - in the bindings file I see:</p>
<p><span style=3D"font-size: 10pt;">...</span></p>
<p><span style=3D"font-size: 10pt;">mpathiv 20024f400d5190010&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &lt;---------------------------------=
------- this is the scsi_sn of sdag</span></p>
<p><span style=3D"font-size: 10pt;">mpathiw 20024f400d5190026&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &lt;---------------------------------------=
- this is the scsi_sn of sdz/w</span></p>
<p><span style=3D"font-size: 10pt;">...<br style=3D"">
</span></p>
<p><br>
</p>
<p>I am adding the relevant host logs (I can add the full logs if needed) -=
 error is in the last log line:<br style=3D"font-size: 8pt;">
</p>
<pre class=3D"bz_comment_text" id=3D"comment_text_6"><span style=3D"font-si=
ze: 8pt;">Mar 14 09:44:36 il-ksm3-044 kernel: sdag: detected capacity chang=
e from 0 to 322122547200=0A=
=0A=
Mar 14 09:59:35 il-ksm3-044 kernel: sd 8:0:1:15: [sdag] Warning! Received a=
n indication that the LUN reached a thin provisioning soft threshold.=0A=
=0A=
Mar 14 10:00:06 il-ksm3-044 kernel: sd 8:0:1:15: [sdag] Warning! Received a=
n indication that the LUN reached a thin provisioning soft threshold.=0A=
=0A=
Mar 14 10:00:21 il-ksm3-044 kernel: sd 8:0:1:15: [sdag] Warning! Received a=
n indication that the LUN reached a thin provisioning soft threshold.=0A=
=0A=
Mar 14 10:26:31 il-ksm3-044 kernel: end_request: I/O error, dev sdz, sector=
 167369280=0A=
Mar 14 10:26:31 il-ksm3-044 kernel: end_request: I/O error, dev sdz, sector=
 80032448=0A=
=0A=
Mar 14 10:26:44 il-ksm3-044 multipathd: sdz: remove path (uevent)=0A=
Mar 14 10:26:44 il-ksm3-044 multipathd: sdz [65:144]: path removed from map=
 mpathiv=0A=
Mar 14 10:26:44 il-ksm3-044 multipathd: sdag: remove path (uevent)=0A=
Mar 14 10:26:44 il-ksm3-044 multipathd: sdag [66:0]: path removed from map =
mpathks=0A=
=0A=
Mar 14 10:26:44 il-ksm3-044 multipathd: mpathiv: load table [0 209715200 mu=
ltipath 0 0 1 1 queue-length 0 1 1 65:96 1]=0A=
Mar 14 10:26:44 il-ksm3-044 multipathd: mpathks: load table [0 629145600 mu=
ltipath 0 0 1 1 queue-length 0 1 1 65:240 1]=0A=
=0A=
Mar 14 10:53:50 il-ksm3-044 kernel: sd 8:0:1:11: [sdz] 209715200 512-byte l=
ogical blocks: (107 GB/100 GiB)=0A=
Mar 14 10:53:50 il-ksm3-044 kernel: sd 8:0:1:11: [sdz] Write Protect is off=
=0A=
Mar 14 10:53:50 il-ksm3-044 kernel: sd 8:0:1:11: [sdz] Write cache: disable=
d, read cache: enabled, supports DPO and FUA=0A=
Mar 14 10:53:50 il-ksm3-044 kernel: sdz:=0A=
Mar 14 10:53:50 il-ksm3-044 kernel: sd 8:0:1:11: [sdz] Attached SCSI disk=
=0A=
Mar 14 10:53:50 il-ksm3-044 kernel: sd 8:0:1:15: [sdag] 629145600 512-byte =
logical blocks: (322 GB/300 GiB)=0A=
Mar 14 10:53:50 il-ksm3-044 kernel: sd 8:0:1:15: [sdag] Write Protect is of=
f=0A=
Mar 14 10:53:50 il-ksm3-044 kernel: sd 8:0:1:15: [sdag] Write cache: disabl=
ed, read cache: enabled, supports DPO and FUA=0A=
Mar 14 10:53:50 il-ksm3-044 kernel: sdag: unknown partition table=0A=
Mar 14 10:53:50 il-ksm3-044 kernel: sd 8:0:1:15: [sdag] Attached SCSI disk=
=0A=
Mar 14 10:53:50 il-ksm3-044 multipathd: sdag: add path (uevent)=0A=
Mar 14 10:53:50 il-ksm3-044 multipathd: mpathks: failed in domap for additi=
on of new path sdag=0A=
Mar 14 10:53:50 il-ksm3-044 multipathd: sdz: add path (uevent)=0A=
Mar 14 10:53:50 il-ksm3-044 multipathd: sdz [65:144]: path added to devmap =
mpathiv=0A=
=0A=
Mar 14 10:53:50 il-ksm3-044 multipathd: mpathiv: load table [0 209715200 mu=
ltipath 0 0 1 1 queue-length 0 2 1 65:96 1 65:144 1]=0A=
=0A=
Mar 14 12:29:12 il-ksm3-044 multipathd: sdw: remove path (uevent)=0A=
Mar 14 12:29:12 il-ksm3-044 multipathd: mpathiv: load table [0 209715200 mu=
ltipath 0 0 1 1 queue-length 0 1 1 65:144 1]=0A=
Mar 14 12:29:12 il-ksm3-044 multipathd: sdw [65:96]: path removed from map =
mpathiv=0A=
=0A=
Mar 15 12:45:59 il-ksm3-044 kernel: sd 8:0:1:11: [sdz] Warning! Received an=
 indication that the LUN assignments on this target have changed. The Linux=
 SCSI layer does not automatically remap LUN assignments.=0A=
=0A=
Mar 14 12:59:18 il-ksm3-044 kernel: sd 7:0:1:11: [sdw] 209715200 512-byte l=
ogical blocks: (107 GB/100 GiB)=0A=
Mar 14 12:59:18 il-ksm3-044 kernel: sd 7:0:1:11: [sdw] Write Protect is off=
=0A=
Mar 14 12:59:18 il-ksm3-044 kernel: sd 7:0:1:11: [sdw] Write cache: disable=
d, read cache: enabled, supports DPO and FUA=0A=
Mar 14 12:59:18 il-ksm3-044 kernel: sd 7:0:1:11: [sdw] Attached SCSI disk=
=0A=
=0A=
Mar 14 12:59:18 il-ksm3-044 multipathd: sdw: add path (uevent)=0A=
Mar 14 12:59:18 il-ksm3-044 multipathd: mpathiv: load table [0 209715200 mu=
ltipath 0 0 1 1 queue-length 0 2 1 65:144 1 65:96 1]=0A=
Mar 14 12:59:18 il-ksm3-044 multipathd: sdw [65:96]: path added to devmap m=
pathiv=0A=
=0A=
Mar 15 11:45:27 il-ksm3-044 kernel: sdz: detected capacity change from 0 to=
 107374182400=0A=
=0A=
Mar 15 11:45:33 il-ksm3-044 multipathd: mpathiw: event checker started=0A=
Mar 15 11:45:33 il-ksm3-044 multipathd: mpathiw: devmap dm-13 added=0A=
=0A=
Mar 15 12:28:12 il-ksm3-044 multipathd: mpathiw: event checker exit=0A=
=0A=
Mar 15 12:28:15 il-ksm3-044 multipathd: mpathiw: event checker started=0A=
Mar 15 12:28:15 il-ksm3-044 multipathd: mpathiw: devmap dm-13 added=0A=
=0A=
Mar 15 12:56:35 il-ksm3-044 kernel: end_request: I/O error, dev sdz, sector=
 204563968=0A=
Mar 15 12:56:35 il-ksm3-044 kernel: end_request: I/O error, dev sdz, sector=
 193484032=0A=
Mar 15 12:56:35 il-ksm3-044 multipathd: mpathiw: remaining active paths: 1=
=0A=
=0A=
Mar 15 12:56:48 il-ksm3-044 multipathd: sdz: remove path (uevent)=0A=
Mar 15 12:56:48 il-ksm3-044 multipathd: mpathiw: load table [0 209715200 mu=
ltipath 0 0 1 1 queue-length 0 1 1 65:96 1]=0A=
Mar 15 12:56:48 il-ksm3-044 multipathd: sdz [65:144]: path removed from map=
 mpathiw=0A=
Mar 15 12:56:48 il-ksm3-044 multipathd: sdag: remove path (uevent)=0A=
=0A=
Mar 15 13:27:00 il-ksm3-044 kernel: sd 8:0:1:11: [sdz] 209715200 512-byte l=
ogical blocks: (107 GB/100 GiB)=0A=
Mar 15 13:27:00 il-ksm3-044 kernel: sd 8:0:1:11: [sdz] Write Protect is off=
=0A=
Mar 15 13:27:00 il-ksm3-044 kernel: sd 8:0:1:11: [sdz] Write cache: disable=
d, read cache: enabled, supports DPO and FUA=0A=
Mar 15 13:27:00 il-ksm3-044 kernel: sdz: unknown partition table=0A=
Mar 15 13:27:00 il-ksm3-044 kernel: sd 8:0:1:11: [sdz] Attached SCSI disk=
=0A=
Mar 15 13:27:00 il-ksm3-044 multipathd: sdz: add path (uevent)=0A=
Mar 15 13:27:00 il-ksm3-044 multipathd: mpathiw: <strong>failed in domap fo=
r addition of new path sdz</strong>=0A=
=0A=
Mar 15 15:20:41 il-ksm3-044 multipathd: mpathiw: devmap dm-13 added=0A=
=0A=
Mar 15 17:38:36 il-ksm3-044 kernel: sd 8:0:1:11: [sdz] Warning! Received an=
 indication that the LUN assignments on this target have changed. The Linux=
 SCSI layer does not automatically remap LUN assignments.=0A=
=0A=
Mar 15 18:44:54 il-ksm3-044 kernel: sd 8:0:1:15: [sdag] 629145600 512-byte =
logical blocks: (322 GB/300 GiB)=0A=
Mar 15 18:44:54 il-ksm3-044 kernel: sd 8:0:1:15: [sdag] Write Protect is of=
f=0A=
Mar 15 18:44:54 il-ksm3-044 kernel: sd 8:0:1:15: [sdag] Write cache: disabl=
ed, read cache: enabled, supports DPO and FUA=0A=
Mar 15 18:44:54 il-ksm3-044 kernel: sdag: unknown partition table=0A=
Mar 15 18:44:54 il-ksm3-044 kernel: sd 8:0:1:15: [sdag] Attached SCSI disk=
=0A=
=0A=
Mar 15 18:44:55 il-ksm3-044 multipathd: sdag: add path (uevent)=0A=
Mar 15 18:44:55 il-ksm3-044 multipathd: mpathiw: load table [0 209715200 mu=
ltipath 0 0 1 1 queue-length 0 3 1 65:96 1 65:144 1 <strong>66:0</strong> 1=
]=0A=
<strong>Mar 15 18:44:55 il-ksm3-044 multipathd: sdag [66:0]: path added to =
devmap mpathiw</strong></span></pre>
<div id=3D"Signature">
<div name=3D"divtagdefaultwrapper" style=3D"font-family:Calibri,Arial,Helve=
tica,sans-serif; font-size:; margin:0">
<br>
Thank you,<br>
Ilan Steinberg<br>
</div>
</div>
</div>
</body>
</html>

--_000_142675983557651213kaminariocom_--


--===============0596922944359139841==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0596922944359139841==--
