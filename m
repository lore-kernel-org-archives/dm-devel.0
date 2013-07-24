From: Kaul <mykaul@gmail.com>
Subject: Re: Substantial performance difference when
 reading/writing to device-mapper vs. the individual device
Date: Wed, 24 Jul 2013 14:49:05 +0300
Message-ID: <CAKLAu3bcJEggXFbdR2qh=yJ=H6nyq2DZKHxUXoYQJ6o3Jk1Qfg@mail.gmail.com>
References: <CAKLAu3bqSff-She6hiRB6+2e0syu0AgxtwYiR0A9CP-yLVBm6Q@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5527200849341125565=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAKLAu3bqSff-She6hiRB6+2e0syu0AgxtwYiR0A9CP-yLVBm6Q@mail.gmail.com>
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

--===============5527200849341125565==
Content-Type: multipart/alternative; boundary=047d7b15a0d581f5d604e24081e5

--047d7b15a0d581f5d604e24081e5
Content-Type: text/plain; charset=ISO-8859-1

Reply to self:

Could it be explained by the difference in max_segments between the
different devices and the dm device?
Sounds like https://bugzilla.redhat.com/show_bug.cgi?id=755046 which is
supposed to be fixed in 6.4, I reckon:



3514f0c5615a00003 dm-3 XtremIO,XtremApp

size=1.0T features='0' hwhandler='0' wp=rw

`-+- policy='queue-length 0' prio=1 status=active

  |- 0:0:2:2 sdi  8:128  active ready running

  |- 0:0:3:2 sdl  8:176  active ready running

  |- 0:0:1:2 sdf  8:80   active ready running

  |- 0:0:0:2 sdc  8:32   active ready running

  |- 1:0:0:2 sds  65:32  active ready running

  |- 1:0:3:2 sdab 65:176 active ready running

  |- 1:0:2:2 sdy  65:128 active ready running

  `- 1:0:1:2 sdv  65:80  active ready running



[root@lg545 ~]# cat /sys/class/block/dm-3/queue/max_segments

128

[root@lg545 ~]# cat /sys/class/block/sdi/queue/max_segments

1024

[root@lg545 ~]# cat /sys/class/block/sdl/queue/max_segments

1024

[root@lg545 ~]# cat /sys/class/block/sdf/queue/max_segments

1024

[root@lg545 ~]# cat /sys/class/block/sdc/queue/max_segments

1024

[root@lg545 ~]# cat /sys/class/block/sds/queue/max_segments

1024

[root@lg545 ~]# cat /sys/class/block/sdab/queue/max_segments

1024

[root@lg545 ~]# cat /sys/class/block/sdy/queue/max_segments

1024

[root@lg545 ~]# cat /sys/class/block/sdv/queue/max_segments

1024


On Mon, Jul 22, 2013 at 2:47 PM, Kaul <mykaul@gmail.com> wrote:

> We are seeing a substantial difference in performance when we perform a
> read/write to /dev/mapper/... vs. the specific device (/dev/sdXX)
> What can we do to further isolate the issue?
>
> We are using CentOS 6.4, with all updates, 2 CPUs, 4 FC ports:
> Here's a table comparing the results:
>
> # of LUNs
>
> # of Paths per device
>
> Native Multipath Device
>
> IO Pattern
>
> IOPS
>
> Latency Micro
>
> BW KBps
>
> 4
>
> 16
>
> No
>
> 100% Read
>
> 605,661.4
>
> 3,381
>
> 2,420,736
>
> 4
>
> 16
>
> No
>
> 100% Write
>
> 477,515.1
>
> 4,288
>
> 1,908,736
>
> 8
>
> 16
>
> No
>
> 100% Read
>
> 663,339.4
>
> 6,174
>
> 2,650,112
>
> 8
>
> 16
>
> No
>
> 100% Write
>
> 536,936.9
>
> 7,628
>
> 2,146,304
>
> 4
>
> 16
>
> Yes
>
> 100% Read
>
> 456,108.9
>
> 1,122
>
> 1,824,256
>
> 4
>
> 16
>
> Yes
>
> 100% Write
>
> 371,665.8
>
> 1,377
>
> 1,486,336
>
> 8
>
> 16
>
> Yes
>
> 100% Read
>
> 519,450.2
>
> 1,971
>
> 2,077,696
>
> 8
>
> 16
>
> Yes
>
> 100% Write
>
> 448,840.4
>
> 2,281
>
> 1,795,072
>

--047d7b15a0d581f5d604e24081e5
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Reply to self:<div><br></div><div>Could it be explained by=
 the difference in max_segments between the different devices and the dm de=
vice?</div><div>Sounds like=A0<a href=3D"https://bugzilla.redhat.com/show_b=
ug.cgi?id=3D755046" style=3D"font-family:Calibri,sans-serif">https://bugzil=
la.redhat.com/show_bug.cgi?id=3D755046</a>=A0which is supposed to be fixed =
in 6.4, I reckon:</div>

<div><p></p>

<p>=A0</p>

<p>3514f0c5615a00003 dm-3 XtremIO,XtremApp</p>

<p>size=3D1.0T features=3D&#39;0&#39; hwhandler=3D&#39;0&#39; wp=3Drw</p>

<p>`-+- policy=3D&#39;queue-length 0&#39; prio=3D1 status=3Dactive</p>

<p>=A0 |- 0:0:2:2 sdi=A0 8:128=A0 active ready running</p>

<p>=A0 |- 0:0:3:2 sdl=A0 8:176=A0 active ready running</p>

<p>=A0 |- 0:0:1:2 sdf=A0 8:80=A0=A0 active ready running</p>

<p>=A0 |- 0:0:0:2 sdc=A0 8:32=A0=A0 active ready running</p>

<p>=A0 |- 1:0:0:2 sds=A0 65:32=A0 active ready running</p>

<p>=A0 |- 1:0:3:2 sdab 65:176 active ready running</p>

<p>=A0 |- 1:0:2:2 sdy=A0 65:128 active ready running</p>

<p>=A0 `- 1:0:1:2 sdv=A0 65:80=A0 active ready running</p>

<p>=A0</p>

<p>[root@lg545 ~]# cat /sys/class/block/dm-3/queue/max_segments</p>

<p>128</p>

<p>[root@lg545 ~]# cat /sys/class/block/sdi/queue/max_segments</p>

<p>1024</p>

<p>[root@lg545 ~]# cat /sys/class/block/sdl/queue/max_segments</p>

<p>1024</p>

<p>[root@lg545 ~]# cat /sys/class/block/sdf/queue/max_segments</p>

<p>1024</p>

<p>[root@lg545 ~]# cat /sys/class/block/sdc/queue/max_segments</p>

<p>1024</p>

<p>[root@lg545 ~]# cat /sys/class/block/sds/queue/max_segments</p>

<p>1024</p>

<p>[root@lg545 ~]# cat /sys/class/block/sdab/queue/max_segments</p>

<p>1024</p>

<p>[root@lg545 ~]# cat /sys/class/block/sdy/queue/max_segments</p>

<p>1024</p>

<p>[root@lg545 ~]# cat /sys/class/block/sdv/queue/max_segments</p>

<p>1024</p></div></div><div class=3D"gmail_extra"><br><br><div class=3D"gma=
il_quote">On Mon, Jul 22, 2013 at 2:47 PM, Kaul <span dir=3D"ltr">&lt;<a hr=
ef=3D"mailto:mykaul@gmail.com" target=3D"_blank">mykaul@gmail.com</a>&gt;</=
span> wrote:<br>

<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div dir=3D"ltr">We are seeing a substantial=
 difference in performance when we perform a read/write to /dev/mapper/... =
vs. the specific device (/dev/sdXX)<div>

What can we do to further isolate the issue?</div><div><br></div>
<div>We are using CentOS 6.4, with all updates, 2 CPUs, 4 FC ports:</div><d=
iv>Here&#39;s a table comparing the results:</div><div><table border=3D"0" =
cellspacing=3D"0" cellpadding=3D"0" style=3D"border-collapse:collapse">

 <tbody><tr style=3D"min-height:15pt">
  <td nowrap valign=3D"bottom" style=3D"border-style:solid solid solid none=
;border-top-color:windowtext;border-right-color:windowtext;border-bottom-co=
lor:windowtext;border-top-width:1pt;border-right-width:1pt;border-bottom-wi=
dth:1pt;padding:0cm 5.4pt;min-height:15pt">



  <p><span style># of LUNs</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:solid solid solid none=
;border-top-color:windowtext;border-right-color:windowtext;border-bottom-co=
lor:windowtext;border-top-width:1pt;border-right-width:1pt;border-bottom-wi=
dth:1pt;padding:0cm 5.4pt;min-height:15pt">



  <p><span style># of Paths per device</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:solid solid solid none=
;border-top-color:windowtext;border-right-color:windowtext;border-bottom-co=
lor:windowtext;border-top-width:1pt;border-right-width:1pt;border-bottom-wi=
dth:1pt;padding:0cm 5.4pt;min-height:15pt">



  <p><span style>Native Multipath Device</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:solid solid solid none=
;border-top-color:windowtext;border-right-color:windowtext;border-bottom-co=
lor:windowtext;border-top-width:1pt;border-right-width:1pt;border-bottom-wi=
dth:1pt;padding:0cm 5.4pt;min-height:15pt">



  <p><span style>IO Pattern</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:solid solid solid none=
;border-top-color:windowtext;border-right-color:windowtext;border-bottom-co=
lor:windowtext;border-top-width:1pt;border-right-width:1pt;border-bottom-wi=
dth:1pt;padding:0cm 5.4pt;min-height:15pt">



  <p><span style>IOPS</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:solid solid solid none=
;border-top-color:windowtext;border-right-color:windowtext;border-bottom-co=
lor:windowtext;border-top-width:1pt;border-right-width:1pt;border-bottom-wi=
dth:1pt;padding:0cm 5.4pt;min-height:15pt">



  <p><span style>Latency Micro</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:solid solid solid none=
;border-top-color:windowtext;border-right-color:windowtext;border-bottom-co=
lor:windowtext;border-top-width:1pt;border-right-width:1pt;border-bottom-wi=
dth:1pt;padding:0cm 5.4pt;min-height:15pt">



  <p><span style>BW KBps</span></p>
  </td>
 </tr>
 <tr style=3D"min-height:15pt">
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p align=3D"right" style=3D"text-align:right"><span style>4</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p align=3D"right" style=3D"text-align:right"><span style>16</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p><span style>No</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p><span style>100% Read</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p align=3D"right" style=3D"text-align:right"><span style>605,661.4</span=
></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p align=3D"right" style=3D"text-align:right"><span style>3,381</span></p=
>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p align=3D"right" style=3D"text-align:right"><span style>2,420,736</span=
></p>
  </td>
 </tr>
 <tr style=3D"min-height:15pt">
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p align=3D"right" style=3D"text-align:right"><span style>4</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p align=3D"right" style=3D"text-align:right"><span style>16</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p><span style>No</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p><span style>100% Write</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p align=3D"right" style=3D"text-align:right"><span style>477,515.1</span=
></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p align=3D"right" style=3D"text-align:right"><span style>4,288</span></p=
>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p align=3D"right" style=3D"text-align:right"><span style>1,908,736</span=
></p>
  </td>
 </tr>
 <tr style=3D"min-height:15pt">
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p align=3D"right" style=3D"text-align:right"><span style>8</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p align=3D"right" style=3D"text-align:right"><span style>16</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p><span style>No</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p><span style>100% Read</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p align=3D"right" style=3D"text-align:right"><span style>663,339.4</span=
></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p align=3D"right" style=3D"text-align:right"><span style>6,174</span></p=
>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p align=3D"right" style=3D"text-align:right"><span style>2,650,112</span=
></p>
  </td>
 </tr>
 <tr style=3D"min-height:15pt">
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p align=3D"right" style=3D"text-align:right"><span style>8</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p align=3D"right" style=3D"text-align:right"><span style>16</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p><span style>No</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p><span style>100% Write</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p align=3D"right" style=3D"text-align:right"><span style>536,936.9</span=
></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p align=3D"right" style=3D"text-align:right"><span style>7,628</span></p=
>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p align=3D"right" style=3D"text-align:right"><span style>2,146,304</span=
></p>
  </td>
 </tr>
 <tr style=3D"min-height:15pt">
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p align=3D"right" style=3D"text-align:right"><span style>4</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p align=3D"right" style=3D"text-align:right"><span style>16</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p><span style>Yes</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p><span style>100% Read</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p align=3D"right" style=3D"text-align:right"><span style>456,108.9</span=
></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p align=3D"right" style=3D"text-align:right"><span style>1,122</span></p=
>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p align=3D"right" style=3D"text-align:right"><span style>1,824,256</span=
></p>
  </td>
 </tr>
 <tr style=3D"min-height:15pt">
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p align=3D"right" style=3D"text-align:right"><span style>4</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p align=3D"right" style=3D"text-align:right"><span style>16</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p><span style>Yes</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p><span style>100% Write</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p align=3D"right" style=3D"text-align:right"><span style>371,665.8</span=
></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p align=3D"right" style=3D"text-align:right"><span style>1,377</span></p=
>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p align=3D"right" style=3D"text-align:right"><span style>1,486,336</span=
></p>
  </td>
 </tr>
 <tr style=3D"min-height:15pt">
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p align=3D"right" style=3D"text-align:right"><span style>8</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p align=3D"right" style=3D"text-align:right"><span style>16</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p><span style>Yes</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p><span style>100% Read</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p align=3D"right" style=3D"text-align:right"><span style>519,450.2</span=
></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p align=3D"right" style=3D"text-align:right"><span style>1,971</span></p=
>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p align=3D"right" style=3D"text-align:right"><span style>2,077,696</span=
></p>
  </td>
 </tr>
 <tr style=3D"min-height:15pt">
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p align=3D"right" style=3D"text-align:right"><span style>8</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p align=3D"right" style=3D"text-align:right"><span style>16</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p><span style>Yes</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p><span style>100% Write</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p align=3D"right" style=3D"text-align:right"><span style>448,840.4</span=
></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p align=3D"right" style=3D"text-align:right"><span style>2,281</span></p=
>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;min-height:15pt">
  <p align=3D"right" style=3D"text-align:right"><span style>1,795,072</span=
></p>
  </td>
 </tr>
</tbody></table></div></div>
</blockquote></div><br></div>

--047d7b15a0d581f5d604e24081e5--


--===============5527200849341125565==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5527200849341125565==--
