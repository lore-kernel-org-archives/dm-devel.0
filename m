From: Kaul <mykaul@gmail.com>
Subject: Substantial performance difference when reading/writing
 to device-mapper vs. the individual device
Date: Mon, 22 Jul 2013 14:47:16 +0300
Message-ID: <CAKLAu3bqSff-She6hiRB6+2e0syu0AgxtwYiR0A9CP-yLVBm6Q@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5455903886219857072=="
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

--===============5455903886219857072==
Content-Type: multipart/alternative; boundary=047d7b15b1615ade9f04e2183f44

--047d7b15b1615ade9f04e2183f44
Content-Type: text/plain; charset=ISO-8859-1

We are seeing a substantial difference in performance when we perform a
read/write to /dev/mapper/... vs. the specific device (/dev/sdXX)
What can we do to further isolate the issue?

We are using CentOS 6.4, with all updates, 2 CPUs, 4 FC ports:
Here's a table comparing the results:

# of LUNs

# of Paths per device

Native Multipath Device

IO Pattern

IOPS

Latency Micro

BW KBps

4

16

No

100% Read

605,661.4

3,381

2,420,736

4

16

No

100% Write

477,515.1

4,288

1,908,736

8

16

No

100% Read

663,339.4

6,174

2,650,112

8

16

No

100% Write

536,936.9

7,628

2,146,304

4

16

Yes

100% Read

456,108.9

1,122

1,824,256

4

16

Yes

100% Write

371,665.8

1,377

1,486,336

8

16

Yes

100% Read

519,450.2

1,971

2,077,696

8

16

Yes

100% Write

448,840.4

2,281

1,795,072

--047d7b15b1615ade9f04e2183f44
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">We are seeing a substantial difference in performance when=
 we perform a read/write to /dev/mapper/... vs. the specific device (/dev/s=
dXX)<div>What can we do to further isolate the issue?</div><div><br></div>

<div>We are using CentOS 6.4, with all updates, 2 CPUs, 4 FC ports:</div><d=
iv>Here&#39;s a table comparing the results:</div><div><table class=3D"" bo=
rder=3D"0" cellspacing=3D"0" cellpadding=3D"0" style=3D"border-collapse:col=
lapse">


 <tbody><tr style=3D"height:15pt">
  <td nowrap valign=3D"bottom" style=3D"border-style:solid solid solid none=
;border-top-color:windowtext;border-right-color:windowtext;border-bottom-co=
lor:windowtext;border-top-width:1pt;border-right-width:1pt;border-bottom-wi=
dth:1pt;padding:0cm 5.4pt;height:15pt">


  <p class=3D""><span style=3D"color:black"># of LUNs</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:solid solid solid none=
;border-top-color:windowtext;border-right-color:windowtext;border-bottom-co=
lor:windowtext;border-top-width:1pt;border-right-width:1pt;border-bottom-wi=
dth:1pt;padding:0cm 5.4pt;height:15pt">


  <p class=3D""><span style=3D"color:black"># of Paths per device</span></p=
>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:solid solid solid none=
;border-top-color:windowtext;border-right-color:windowtext;border-bottom-co=
lor:windowtext;border-top-width:1pt;border-right-width:1pt;border-bottom-wi=
dth:1pt;padding:0cm 5.4pt;height:15pt">


  <p class=3D""><span style=3D"color:black">Native Multipath Device</span><=
/p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:solid solid solid none=
;border-top-color:windowtext;border-right-color:windowtext;border-bottom-co=
lor:windowtext;border-top-width:1pt;border-right-width:1pt;border-bottom-wi=
dth:1pt;padding:0cm 5.4pt;height:15pt">


  <p class=3D""><span style=3D"color:black">IO Pattern</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:solid solid solid none=
;border-top-color:windowtext;border-right-color:windowtext;border-bottom-co=
lor:windowtext;border-top-width:1pt;border-right-width:1pt;border-bottom-wi=
dth:1pt;padding:0cm 5.4pt;height:15pt">


  <p class=3D""><span style=3D"color:black">IOPS</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:solid solid solid none=
;border-top-color:windowtext;border-right-color:windowtext;border-bottom-co=
lor:windowtext;border-top-width:1pt;border-right-width:1pt;border-bottom-wi=
dth:1pt;padding:0cm 5.4pt;height:15pt">


  <p class=3D""><span style=3D"color:black">Latency Micro</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:solid solid solid none=
;border-top-color:windowtext;border-right-color:windowtext;border-bottom-co=
lor:windowtext;border-top-width:1pt;border-right-width:1pt;border-bottom-wi=
dth:1pt;padding:0cm 5.4pt;height:15pt">


  <p class=3D""><span style=3D"color:black">BW KBps</span></p>
  </td>
 </tr>
 <tr style=3D"height:15pt">
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D"" align=3D"right" style=3D"text-align:right"><span style=3D"c=
olor:black">4</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D"" align=3D"right" style=3D"text-align:right"><span style=3D"c=
olor:black">16</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D""><span style=3D"color:black">No</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D""><span style=3D"color:black">100% Read</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D"" align=3D"right" style=3D"text-align:right"><span style=3D"c=
olor:black">605,661.4</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D"" align=3D"right" style=3D"text-align:right"><span style=3D"c=
olor:black">3,381</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D"" align=3D"right" style=3D"text-align:right"><span style=3D"c=
olor:black">2,420,736</span></p>
  </td>
 </tr>
 <tr style=3D"height:15pt">
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D"" align=3D"right" style=3D"text-align:right"><span style=3D"c=
olor:black">4</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D"" align=3D"right" style=3D"text-align:right"><span style=3D"c=
olor:black">16</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D""><span style=3D"color:black">No</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D""><span style=3D"color:black">100% Write</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D"" align=3D"right" style=3D"text-align:right"><span style=3D"c=
olor:black">477,515.1</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D"" align=3D"right" style=3D"text-align:right"><span style=3D"c=
olor:black">4,288</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D"" align=3D"right" style=3D"text-align:right"><span style=3D"c=
olor:black">1,908,736</span></p>
  </td>
 </tr>
 <tr style=3D"height:15pt">
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D"" align=3D"right" style=3D"text-align:right"><span style=3D"c=
olor:black">8</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D"" align=3D"right" style=3D"text-align:right"><span style=3D"c=
olor:black">16</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D""><span style=3D"color:black">No</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D""><span style=3D"color:black">100% Read</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D"" align=3D"right" style=3D"text-align:right"><span style=3D"c=
olor:black">663,339.4</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D"" align=3D"right" style=3D"text-align:right"><span style=3D"c=
olor:black">6,174</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D"" align=3D"right" style=3D"text-align:right"><span style=3D"c=
olor:black">2,650,112</span></p>
  </td>
 </tr>
 <tr style=3D"height:15pt">
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D"" align=3D"right" style=3D"text-align:right"><span style=3D"c=
olor:black">8</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D"" align=3D"right" style=3D"text-align:right"><span style=3D"c=
olor:black">16</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D""><span style=3D"color:black">No</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D""><span style=3D"color:black">100% Write</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D"" align=3D"right" style=3D"text-align:right"><span style=3D"c=
olor:black">536,936.9</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D"" align=3D"right" style=3D"text-align:right"><span style=3D"c=
olor:black">7,628</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D"" align=3D"right" style=3D"text-align:right"><span style=3D"c=
olor:black">2,146,304</span></p>
  </td>
 </tr>
 <tr style=3D"height:15pt">
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D"" align=3D"right" style=3D"text-align:right"><span style=3D"c=
olor:black">4</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D"" align=3D"right" style=3D"text-align:right"><span style=3D"c=
olor:black">16</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D""><span style=3D"color:black">Yes</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D""><span style=3D"color:black">100% Read</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D"" align=3D"right" style=3D"text-align:right"><span style=3D"c=
olor:black">456,108.9</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D"" align=3D"right" style=3D"text-align:right"><span style=3D"c=
olor:black">1,122</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D"" align=3D"right" style=3D"text-align:right"><span style=3D"c=
olor:black">1,824,256</span></p>
  </td>
 </tr>
 <tr style=3D"height:15pt">
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D"" align=3D"right" style=3D"text-align:right"><span style=3D"c=
olor:black">4</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D"" align=3D"right" style=3D"text-align:right"><span style=3D"c=
olor:black">16</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D""><span style=3D"color:black">Yes</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D""><span style=3D"color:black">100% Write</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D"" align=3D"right" style=3D"text-align:right"><span style=3D"c=
olor:black">371,665.8</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D"" align=3D"right" style=3D"text-align:right"><span style=3D"c=
olor:black">1,377</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D"" align=3D"right" style=3D"text-align:right"><span style=3D"c=
olor:black">1,486,336</span></p>
  </td>
 </tr>
 <tr style=3D"height:15pt">
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D"" align=3D"right" style=3D"text-align:right"><span style=3D"c=
olor:black">8</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D"" align=3D"right" style=3D"text-align:right"><span style=3D"c=
olor:black">16</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D""><span style=3D"color:black">Yes</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D""><span style=3D"color:black">100% Read</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D"" align=3D"right" style=3D"text-align:right"><span style=3D"c=
olor:black">519,450.2</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D"" align=3D"right" style=3D"text-align:right"><span style=3D"c=
olor:black">1,971</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D"" align=3D"right" style=3D"text-align:right"><span style=3D"c=
olor:black">2,077,696</span></p>
  </td>
 </tr>
 <tr style=3D"height:15pt">
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D"" align=3D"right" style=3D"text-align:right"><span style=3D"c=
olor:black">8</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D"" align=3D"right" style=3D"text-align:right"><span style=3D"c=
olor:black">16</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D""><span style=3D"color:black">Yes</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D""><span style=3D"color:black">100% Write</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D"" align=3D"right" style=3D"text-align:right"><span style=3D"c=
olor:black">448,840.4</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D"" align=3D"right" style=3D"text-align:right"><span style=3D"c=
olor:black">2,281</span></p>
  </td>
  <td nowrap valign=3D"bottom" style=3D"border-style:none solid solid none;=
border-bottom-color:windowtext;border-bottom-width:1pt;border-right-color:w=
indowtext;border-right-width:1pt;padding:0cm 5.4pt;height:15pt">
  <p class=3D"" align=3D"right" style=3D"text-align:right"><span style=3D"c=
olor:black">1,795,072</span></p>
  </td>
 </tr>
</tbody></table></div></div>

--047d7b15b1615ade9f04e2183f44--


--===============5455903886219857072==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5455903886219857072==--
