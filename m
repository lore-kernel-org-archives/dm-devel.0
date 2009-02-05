From: =?ISO-8859-1?Q?Christian_R=F8snes?= <christian.rosnes@gmail.com>
Subject: Re: FW: Multipath setup and rdac questions
Date: Thu, 5 Feb 2009 21:45:06 +0100
Message-ID: <1a4a774c0902051245k68db6848w8e4ede611fc1f05e@mail.gmail.com>
References: <E463DF2B2E584B4A82673F53D62C2EF4663976BB@cosmail01.lsi.com>
	<1a4a774c0902051223g3a70ee45k946b9338d5d3c2df@mail.gmail.com>
	<E463DF2B2E584B4A82673F53D62C2EF46653B584@cosmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1578018310=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF46653B584@cosmail01.lsi.com>
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============1578018310==
Content-Type: multipart/alternative; boundary=001636498f11c2a55c046231fa94

--001636498f11c2a55c046231fa94
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On Thu, Feb 5, 2009 at 9:32 PM, Moger, Babu <Babu.Moger@lsi.com> wrote:

>  Your Vendor id is DELL   and Product id is MD3000i
>
>
>
> Now update the multipath.conf with the above information and reboot the
> system.
>
>
>
> vendor                  "DELL"
>
>       product                 "MD3000i"
>
>
>
> You should see the devices.  Let me know if you need more information..
>
Ok. Changed multipath.conf and now multipath -ll shows:

# multipath -ll
mpathe (36002219000918b4c00005b6c497e6632) dm-4 DELL,MD3000i
[size=5.5T][features=1 queue_if_no_path][hwhandler=1 rdac]
\_ round-robin 0 [prio=12][active]
 \_ 4:0:0:1  sdm  8:192  [active][ready]
 \_ 3:0:0:1  sdl  8:176  [active][ready]
\_ round-robin 0 [prio=2][enabled]
 \_ 2:0:0:1  sds  65:32  [active][ghost]
 \_ 1:0:0:1  sdr  65:16  [active][ghost]
mpathd (36002219000918b3300002e6e497e6315) dm-6 DELL,MD3000i
[size=5.5T][features=1 queue_if_no_path][hwhandler=1 rdac]
\_ round-robin 0 [prio=6][active]
 \_ 4:0:0:2  sdo  8:224  [active][ready]
 \_ 3:0:0:2  sdn  8:208  [active][ready]
mpathc (36002219000918b4c00005b6f497e6695) dm-1 DELL,MD3000i
[size=5.5T][features=1 queue_if_no_path][hwhandler=1 rdac]
\_ round-robin 0 [prio=6][active]
 \_ 3:0:0:3  sdz  65:144 [active][ready]
mpatha (36002219000918b4c00005b72497e66f3) dm-0 DELL,MD3000i
[size=5.5T][features=1 queue_if_no_path][hwhandler=1 rdac]
\_ round-robin 0 [prio=3][active]
 \_ 2:0:0:5  sdba 67:64  [active][ready]
mpathl (36002219000918b3300002e6b497e62a6) dm-8 DELL,MD3000i
[size=5.5T][features=1 queue_if_no_path][hwhandler=1 rdac]
\_ round-robin 0 [prio=12][active]
 \_ 4:0:0:0  sde  8:64   [active][ready]
 \_ 3:0:0:0  sdd  8:48   [active][ready]
\_ round-robin 0 [prio=2][enabled]
 \_ 2:0:0:0  sdc  8:32   [active][ghost]
 \_ 1:0:0:0  sdb  8:16   [active][ghost]
mpathk (36002219000922cdf000004a4497e53f5) dm-7 DELL,MD3000i
[size=5.5T][features=1 queue_if_no_path][hwhandler=1 rdac]
\_ round-robin 0 [prio=12][active]
 \_ 6:0:0:10 sdi  8:128  [active][ready]
 \_ 5:0:0:10 sdh  8:112  [active][ready]
\_ round-robin 0 [prio=2][enabled]
 \_ 8:0:0:10 sdg  8:96   [active][ghost]
 \_ 7:0:0:10 sdf  8:80   [active][ghost]
mpathj (36002219000918b2e000004b2497e581c) dm-5 DELL,MD3000i
[size=5.5T][features=1 queue_if_no_path][hwhandler=1 rdac]
\_ round-robin 0 [prio=12][active]
 \_ 8:0:0:11 sdq  65:0   [active][ready]
 \_ 7:0:0:11 sdp  8:240  [active][ready]
\_ round-robin 0 [prio=2][enabled]
 \_ 6:0:0:11 sdk  8:160  [active][ghost]
 \_ 5:0:0:11 sdj  8:144  [active][ghost]
mpathi (36002219000922cdf000004a7497e54dd) dm-3 DELL,MD3000i
[size=5.5T][features=1 queue_if_no_path][hwhandler=1 rdac]
\_ round-robin 0 [prio=12][active]
 \_ 6:0:0:12 sdw  65:96  [active][ready]
 \_ 5:0:0:12 sdv  65:80  [active][ready]
\_ round-robin 0 [prio=2][enabled]
 \_ 8:0:0:12 sdu  65:64  [active][ghost]
 \_ 7:0:0:12 sdt  65:48  [active][ghost]
mpathh (36002219000918b2e000004b5497e587e) dm-2 DELL,MD3000i
[size=5.5T][features=1 queue_if_no_path][hwhandler=1 rdac]
\_ round-robin 0 [prio=6][active]
 \_ 6:0:0:13 sdy  65:128 [active][ready]
 \_ 5:0:0:13 sdx  65:112 [active][ready]

Thank you
Christian

--001636498f11c2a55c046231fa94
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<br><br><div class=3D"gmail_quote">On Thu, Feb 5, 2009 at 9:32 PM, Moger, B=
abu <span dir=3D"ltr">&lt;<a href=3D"mailto:Babu.Moger@lsi.com">Babu.Moger@=
lsi.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D=
"border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padd=
ing-left: 1ex;">










<div link=3D"blue" vlink=3D"blue" lang=3D"EN-US">

<div>

<p><font face=3D"Times New Roman" size=3D"3"><span style=3D"font-size: 12pt=
;">Your Vendor id is DELL&nbsp;&nbsp;&nbsp;and Product id is MD3000i&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></font></p>

<p><font face=3D"Times New Roman" size=3D"3"><span style=3D"font-size: 12pt=
;">&nbsp;</span></font></p>

<p><font face=3D"Times New Roman" size=3D"3"><span style=3D"font-size: 12pt=
;">Now update the multipath.conf with the above information and reboot the
system.</span></font></p>

<p style=3D""><font face=3D"Courier New" size=3D"2"><span style=3D"font-siz=
e: 10pt; font-family: &quot;Courier New&quot;;">&nbsp;</span></font></p>

<p style=3D"text-indent: 0.5in;"><font face=3D"Courier New" size=3D"2"><spa=
n style=3D"font-size: 10pt; font-family: &quot;Courier New&quot;;">vendor&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;
&quot;DELL&quot;</span></font></p>

<p style=3D""><font face=3D"Courier New" size=3D"2"><span style=3D"font-siz=
e: 10pt; font-family: &quot;Courier New&quot;;">&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;
product&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;MD3000i&quot;</span></font></p>

<p><font color=3D"navy" face=3D"Arial" size=3D"2"><span style=3D"font-size:=
 10pt; font-family: Arial; color: navy;">&nbsp;</span></font></p>

<p><font color=3D"navy" face=3D"Arial" size=3D"2"><span style=3D"font-size:=
 10pt; font-family: Arial; color: navy;">You should see the devices. &nbsp;=
Let me know
if you need more information..</span></font></p></div></div></blockquote><d=
iv>Ok. Changed multipath.conf and now multipath -ll shows:<br><br># multipa=
th -ll<br>mpathe (36002219000918b4c00005b6c497e6632) dm-4 DELL,MD3000i<br>
[size=3D5.5T][features=3D1 queue_if_no_path][hwhandler=3D1 rdac]<br>\_ roun=
d-robin 0 [prio=3D12][active]<br>&nbsp;\_ 4:0:0:1&nbsp; sdm&nbsp; 8:192&nbs=
p; [active][ready]<br>&nbsp;\_ 3:0:0:1&nbsp; sdl&nbsp; 8:176&nbsp; [active]=
[ready]<br>\_ round-robin 0 [prio=3D2][enabled]<br>
&nbsp;\_ 2:0:0:1&nbsp; sds&nbsp; 65:32&nbsp; [active][ghost]<br>&nbsp;\_ 1:=
0:0:1&nbsp; sdr&nbsp; 65:16&nbsp; [active][ghost]<br>mpathd (36002219000918=
b3300002e6e497e6315) dm-6 DELL,MD3000i<br>[size=3D5.5T][features=3D1 queue_=
if_no_path][hwhandler=3D1 rdac]<br>\_ round-robin 0 [prio=3D6][active]<br>
&nbsp;\_ 4:0:0:2&nbsp; sdo&nbsp; 8:224&nbsp; [active][ready]<br>&nbsp;\_ 3:=
0:0:2&nbsp; sdn&nbsp; 8:208&nbsp; [active][ready]<br>mpathc (36002219000918=
b4c00005b6f497e6695) dm-1 DELL,MD3000i<br>[size=3D5.5T][features=3D1 queue_=
if_no_path][hwhandler=3D1 rdac]<br>\_ round-robin 0 [prio=3D6][active]<br>
&nbsp;\_ 3:0:0:3&nbsp; sdz&nbsp; 65:144 [active][ready]<br>mpatha (36002219=
000918b4c00005b72497e66f3) dm-0 DELL,MD3000i<br>[size=3D5.5T][features=3D1 =
queue_if_no_path][hwhandler=3D1 rdac]<br>\_ round-robin 0 [prio=3D3][active=
]<br>&nbsp;\_ 2:0:0:5&nbsp; sdba 67:64&nbsp; [active][ready]<br>
mpathl (36002219000918b3300002e6b497e62a6) dm-8 DELL,MD3000i<br>[size=3D5.5=
T][features=3D1 queue_if_no_path][hwhandler=3D1 rdac]<br>\_ round-robin 0 [=
prio=3D12][active]<br>&nbsp;\_ 4:0:0:0&nbsp; sde&nbsp; 8:64&nbsp;&nbsp; [ac=
tive][ready]<br>&nbsp;\_ 3:0:0:0&nbsp; sdd&nbsp; 8:48&nbsp;&nbsp; [active][=
ready]<br>
\_ round-robin 0 [prio=3D2][enabled]<br>&nbsp;\_ 2:0:0:0&nbsp; sdc&nbsp; 8:=
32&nbsp;&nbsp; [active][ghost]<br>&nbsp;\_ 1:0:0:0&nbsp; sdb&nbsp; 8:16&nbs=
p;&nbsp; [active][ghost]<br>mpathk (36002219000922cdf000004a4497e53f5) dm-7=
 DELL,MD3000i<br>[size=3D5.5T][features=3D1 queue_if_no_path][hwhandler=3D1=
 rdac]<br>
\_ round-robin 0 [prio=3D12][active]<br>&nbsp;\_ 6:0:0:10 sdi&nbsp; 8:128&n=
bsp; [active][ready]<br>&nbsp;\_ 5:0:0:10 sdh&nbsp; 8:112&nbsp; [active][re=
ady]<br>\_ round-robin 0 [prio=3D2][enabled]<br>&nbsp;\_ 8:0:0:10 sdg&nbsp;=
 8:96&nbsp;&nbsp; [active][ghost]<br>&nbsp;\_ 7:0:0:10 sdf&nbsp; 8:80&nbsp;=
&nbsp; [active][ghost]<br>
mpathj (36002219000918b2e000004b2497e581c) dm-5 DELL,MD3000i<br>[size=3D5.5=
T][features=3D1 queue_if_no_path][hwhandler=3D1 rdac]<br>\_ round-robin 0 [=
prio=3D12][active]<br>&nbsp;\_ 8:0:0:11 sdq&nbsp; 65:0&nbsp;&nbsp; [active]=
[ready]<br>&nbsp;\_ 7:0:0:11 sdp&nbsp; 8:240&nbsp; [active][ready]<br>
\_ round-robin 0 [prio=3D2][enabled]<br>&nbsp;\_ 6:0:0:11 sdk&nbsp; 8:160&n=
bsp; [active][ghost]<br>&nbsp;\_ 5:0:0:11 sdj&nbsp; 8:144&nbsp; [active][gh=
ost]<br>mpathi (36002219000922cdf000004a7497e54dd) dm-3 DELL,MD3000i<br>[si=
ze=3D5.5T][features=3D1 queue_if_no_path][hwhandler=3D1 rdac]<br>
\_ round-robin 0 [prio=3D12][active]<br>&nbsp;\_ 6:0:0:12 sdw&nbsp; 65:96&n=
bsp; [active][ready]<br>&nbsp;\_ 5:0:0:12 sdv&nbsp; 65:80&nbsp; [active][re=
ady]<br>\_ round-robin 0 [prio=3D2][enabled]<br>&nbsp;\_ 8:0:0:12 sdu&nbsp;=
 65:64&nbsp; [active][ghost]<br>&nbsp;\_ 7:0:0:12 sdt&nbsp; 65:48&nbsp; [ac=
tive][ghost]<br>
mpathh (36002219000918b2e000004b5497e587e) dm-2 DELL,MD3000i<br>[size=3D5.5=
T][features=3D1 queue_if_no_path][hwhandler=3D1 rdac]<br>\_ round-robin 0 [=
prio=3D6][active]<br>&nbsp;\_ 6:0:0:13 sdy&nbsp; 65:128 [active][ready]<br>=
&nbsp;\_ 5:0:0:13 sdx&nbsp; 65:112 [active][ready]<br>
&nbsp;<br></div></div>Thank you<br>Christian<br>

--001636498f11c2a55c046231fa94--


--===============1578018310==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1578018310==--
