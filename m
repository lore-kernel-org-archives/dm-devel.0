From: NEVEU Stephane <stephane.neveu@thalesgroup.com>
Subject: multipathd & EMC Clariion CX-4
Date: Wed, 14 Sep 2011 11:58:48 +0200
Message-ID: <21739_1315994330_4E707ADA_21739_7623_1_EEF700FCD1A35041BF2C750B4EDDCA310138F9C49D3A@THSONEA01CMS03P.one.grp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8879778186438046937=="
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: fr-FR
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
List-Id: dm-devel.ids

--===============8879778186438046937==
Content-Language: fr-FR
Content-Type: multipart/alternative;
	boundary="_000_EEF700FCD1A35041BF2C750B4EDDCA310138F9C49D3ATHSONEA01CM_"

--_000_EEF700FCD1A35041BF2C750B4EDDCA310138F9C49D3ATHSONEA01CM_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi all,

I'm experiencing problems trying to set up a multipathd config with a EMC C=
lariion CX-4 Storage.
It seems that the CX4 is actually active/passive regarding SPs. My server  =
has QLogic Fiber Cards. My multipath-tools version is 0.4.8.
Here is my multipath.conf :

##
## This is a template multipath-tools configuration file
## Uncomment the lines relevent to your environment
##
defaults {
                user_friendly_names   yes
}
blacklist {
                #devnode "*"
                devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
                devnode "^hd[a-z][[0-9]*]"
                devnode "^cciss!c[0-9]d[0-9]*[p[0-9]*]"
}
devices {
                device {
                               vendor                                "DGC  =
"
                               product                                     =
          "*"
                               path_grouping_policy   group_by_prio
                               getuid_callout          "/lib/udev/scsi_id -=
g -u -d /dev/%n"
                               prio_callout                       "/sbin/mp=
ath_prio_emc /dev/%n"
                               hardware_handler         "1 emc"
                               features "1 queue_if_no_path"
#                             failback                                15
#                             rr_weight                           prioritie=
s
                               no_path_retry                 300
                               path_checker                   emc_clarion
                               failback                                imme=
diate
#                             rr_min_io                           100
                               product_blacklist            LUN_Z
                }
}

multipaths {

                multipath {
                               wwid                                    3600=
60160174026008cf8cef961cde011
                               alias                                      N=
PCD
                }

                multipath {
                wwid                    36006016017402600f2ed610b62cde011
                alias                   NDO
        }

                multipath {
                wwid                    360060160174026000c984cc67acde011
                alias                   NAGIOS
        }


}

And here is the result of a multipath -ll :

sdg: checker msg is "directio checker reports path is down"
sdm: checker msg is "directio checker reports path is down"
NDO (36006016017402600f2ed610b62cde011) dm-8 DGC     ,RAID 5
[size=3D50G][features=3D1 queue_if_no_path][hwhandler=3D1 emc]
\_ round-robin 0 [prio=3D2][active]
 \_ 2:0:0:1 sdd 8:48  [active][ready]
 \_ 5:0:0:1 sdj 8:144 [active][ready]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 2:0:1:1 sdg 8:96  [active][faulty]
 \_ 5:0:1:1 sdm 8:192 [active][faulty]
sde: checker msg is "directio checker reports path is down"
sdk: checker msg is "directio checker reports path is down"
NAGIOS (360060160174026000c984cc67acde011) dm-6 DGC     ,RAID 5
[size=3D40G][features=3D1 queue_if_no_path][hwhandler=3D1 emc]
\_ round-robin 0 [prio=3D2][active]
 \_ 2:0:1:2 sdh 8:112 [active][ready]
 \_ 5:0:1:2 sdn 8:208 [active][ready]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 2:0:0:2 sde 8:64  [active][faulty]
 \_ 5:0:0:2 sdk 8:160 [active][faulty]
sdc: checker msg is "directio checker reports path is down"
sdi: checker msg is "directio checker reports path is down"
NPCD (360060160174026008cf8cef961cde011) dm-7 DGC     ,RAID 5
[size=3D100G][features=3D1 queue_if_no_path][hwhandler=3D1 emc]
\_ round-robin 0 [prio=3D2][active]
 \_ 2:0:1:0 sdf 8:80  [active][ready]
 \_ 5:0:1:0 sdl 8:176 [active][ready]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 2:0:0:0 sdc 8:32  [active][faulty]
 \_ 5:0:0:0 sdi 8:128 [active][faulty]


So when trying to write on a virtual device /dev/mapper/NAGIOS (for exemple=
) I see many I/O errors on 'faulty disks'. When tresspassing LUNs on the cl=
ariion, I see ready disks becoming faulty and faulty ones becoming ready ..=
. I also have udevd (udev-work) burning my CPUs while trying to rename '/de=
v/disk/by-id/wwn-0xetcetc...udev-tmp'
What's wrong with my config ? Am I missing something ?
Thx by advance for your help,
Regards,

Cordialement,

--
St=E9phane Neveu
Ing=E9nieur Opensource / RedHat Technical Manager
THALES - Critical Information Systems
DIVISION Security Solutions & Services / Server Mgmt
T=E9l 01 73 17 03 15
--


--_000_EEF700FCD1A35041BF2C750B4EDDCA310138F9C49D3ATHSONEA01CM_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; charset=3Diso-8859-1"=
>
<meta name=3DGenerator content=3D"Microsoft Word 12 (filtered medium)">
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:purple;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;}
@page Section1
	{size:612.0pt 792.0pt;
	margin:70.85pt 70.85pt 70.85pt 70.85pt;}
div.Section1
	{page:Section1;}
-->
</style>
<!--[if gte mso 9]><xml>
 <o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
 <o:shapelayout v:ext=3D"edit">
  <o:idmap v:ext=3D"edit" data=3D"1" />
 </o:shapelayout></xml><![endif]-->
</head>

<body lang=3DFR link=3Dblue vlink=3Dpurple>

<div class=3DSection1>

<p class=3DMsoNormal>Hi all,<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>I'm experiencing problems trying to set up a multipath=
d
config with a EMC Clariion CX-4 Storage.<o:p></o:p></p>

<p class=3DMsoNormal>It seems that the CX4 is actually active/passive regar=
ding
SPs. My server =A0has QLogic Fiber Cards. My multipath-tools version is 0.4=
.8.<o:p></o:p></p>

<p class=3DMsoNormal>Here is my multipath.conf :<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>##<o:p></o:p></p>

<p class=3DMsoNormal>## This is a template multipath-tools configuration fi=
le<o:p></o:p></p>

<p class=3DMsoNormal>## Uncomment the lines relevent to your environment<o:=
p></o:p></p>

<p class=3DMsoNormal>##<o:p></o:p></p>

<p class=3DMsoNormal>defaults {<o:p></o:p></p>

<p class=3DMsoNormal>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 user_fri=
endly_names=A0=A0 yes<o:p></o:p></p>

<p class=3DMsoNormal>}<o:p></o:p></p>

<p class=3DMsoNormal>blacklist {<o:p></o:p></p>

<p class=3DMsoNormal>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 #devnode=
 &quot;*&quot;<o:p></o:p></p>

<p class=3DMsoNormal>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 devnode
&quot;^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*&quot;<o:p></o:p></p>

<p class=3DMsoNormal>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 devnode =
&quot;^hd[a-z][[0-9]*]&quot;<o:p></o:p></p>

<p class=3DMsoNormal>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 devnode
&quot;^cciss!c[0-9]d[0-9]*[p[0-9]*]&quot;<o:p></o:p></p>

<p class=3DMsoNormal>}<o:p></o:p></p>

<p class=3DMsoNormal>devices {<o:p></o:p></p>

<p class=3DMsoNormal>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 device {=
<o:p></o:p></p>

<p class=3DMsoNormal>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 vendor=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 &quot;DGC=
=A0
&quot;<o:p></o:p></p>

<p class=3DMsoNormal>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 product=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 &quot;*&quot;<o:p></o:p></p>

<p class=3DMsoNormal>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 path_grouping_policy=A0=A0 group_by_pr=
io<o:p></o:p></p>

<p class=3DMsoNormal>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 getuid_callout=A0=A0=A0=A0=A0=A0=A0=A0=
=A0
&quot;/lib/udev/scsi_id -g -u -d /dev/%n&quot;<o:p></o:p></p>

<p class=3DMsoNormal>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 prio_callout =A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 &quot;/sbin/mpath_prio_emc
/dev/%n&quot;<o:p></o:p></p>

<p class=3DMsoNormal>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 hardware_handler=A0=A0=A0=A0=A0=A0=A0=
=A0 &quot;1
emc&quot;<o:p></o:p></p>

<p class=3DMsoNormal>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 features &quot;1
queue_if_no_path&quot;<o:p></o:p></p>

<p class=3DMsoNormal>#=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 failback=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 15<o:p></o:p><=
/p>

<p class=3DMsoNormal>#=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rr_weight=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 priorities<o:p></o:p></p>

<p class=3DMsoNormal>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 no_path_retry=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 300<o:p></o:p></p>

<p class=3DMsoNormal>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 path_checker=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 emc_clarion<o:p></o:p></p>

<p class=3DMsoNormal>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 failback=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 immediate<o=
:p></o:p></p>

<p class=3DMsoNormal>#=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rr_min_io=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 100<o:p></o:p></p>

<p class=3DMsoNormal>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 product_blacklist=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 LUN_Z<o:p></o:p></p>

<p class=3DMsoNormal>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }<o:p></=
o:p></p>

<p class=3DMsoNormal>}<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>multipaths {<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 multipat=
h {<o:p></o:p></p>

<p class=3DMsoNormal>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 wwid=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 36=
0060160174026008cf8cef961cde011<o:p></o:p></p>

<p class=3DMsoNormal>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 alias=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 NPCD<o:p></o:p></p>

<p class=3DMsoNormal>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }<o:p></=
o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 multipat=
h {<o:p></o:p></p>

<p class=3DMsoNormal>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 wwid=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
36006016017402600f2ed610b62cde011<o:p></o:p></p>

<p class=3DMsoNormal>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 alias=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 NDO<o:p></o:p></p>

<p class=3DMsoNormal>=A0=A0=A0=A0=A0=A0=A0 }<o:p></o:p></p>

<p class=3DMsoNormal>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 <o:p></o=
:p></p>

<p class=3DMsoNormal>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 multipat=
h {<o:p></o:p></p>

<p class=3DMsoNormal>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 wwid=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0360060160174026000c9=
84cc67acde011<o:p></o:p></p>

<p class=3DMsoNormal>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 alias=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 NAGIOS<o:p></o:p></p>

<p class=3DMsoNormal>=A0=A0=A0=A0=A0=A0=A0 }<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>}<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>And here is the result of a multipath -ll :<o:p></o:p>=
</p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>sdg: checker msg is &quot;directio checker reports pat=
h is
down&quot;<o:p></o:p></p>

<p class=3DMsoNormal>sdm: checker msg is &quot;directio checker reports pat=
h is
down&quot;<o:p></o:p></p>

<p class=3DMsoNormal>NDO (36006016017402600f2ed610b62cde011) dm-8 DGC=A0=A0=
=A0=A0 ,RAID
5=A0=A0=A0=A0=A0=A0=A0 <o:p></o:p></p>

<p class=3DMsoNormal>[size=3D50G][features=3D1 queue_if_no_path][hwhandler=
=3D1 emc]<o:p></o:p></p>

<p class=3DMsoNormal>\_ round-robin 0 [prio=3D2][active]<o:p></o:p></p>

<p class=3DMsoNormal>=A0\_ 2:0:0:1 sdd 8:48=A0 [active][ready] <o:p></o:p><=
/p>

<p class=3DMsoNormal>=A0\_ 5:0:0:1 sdj 8:144 [active][ready] <o:p></o:p></p=
>

<p class=3DMsoNormal>\_ round-robin 0 [prio=3D0][enabled]<o:p></o:p></p>

<p class=3DMsoNormal>=A0\_ 2:0:1:1 sdg 8:96=A0 [active][faulty]<o:p></o:p><=
/p>

<p class=3DMsoNormal>=A0\_ 5:0:1:1 sdm 8:192 [active][faulty]<o:p></o:p></p=
>

<p class=3DMsoNormal>sde: checker msg is &quot;directio checker reports pat=
h is
down&quot;<o:p></o:p></p>

<p class=3DMsoNormal>sdk: checker msg is &quot;directio checker reports pat=
h is
down&quot;<o:p></o:p></p>

<p class=3DMsoNormal>NAGIOS (360060160174026000c984cc67acde011) dm-6 DGC=A0=
=A0=A0=A0
,RAID 5=A0=A0=A0=A0=A0=A0=A0 <o:p></o:p></p>

<p class=3DMsoNormal>[size=3D40G][features=3D1 queue_if_no_path][hwhandler=
=3D1 emc]<o:p></o:p></p>

<p class=3DMsoNormal>\_ round-robin 0 [prio=3D2][active]<o:p></o:p></p>

<p class=3DMsoNormal>=A0\_ 2:0:1:2 sdh 8:112 [active][ready] <o:p></o:p></p=
>

<p class=3DMsoNormal>=A0\_ 5:0:1:2 sdn 8:208 [active][ready] <o:p></o:p></p=
>

<p class=3DMsoNormal>\_ round-robin 0 [prio=3D0][enabled]<o:p></o:p></p>

<p class=3DMsoNormal>=A0\_ 2:0:0:2 sde 8:64=A0 [active][faulty]<o:p></o:p><=
/p>

<p class=3DMsoNormal>=A0\_ 5:0:0:2 sdk 8:160 [active][faulty]<o:p></o:p></p=
>

<p class=3DMsoNormal>sdc: checker msg is &quot;directio checker reports pat=
h is
down&quot;<o:p></o:p></p>

<p class=3DMsoNormal>sdi: checker msg is &quot;directio checker reports pat=
h is
down&quot;<o:p></o:p></p>

<p class=3DMsoNormal>NPCD (360060160174026008cf8cef961cde011) dm-7 DGC=A0=
=A0=A0=A0 ,RAID
5=A0=A0=A0=A0=A0=A0=A0 <o:p></o:p></p>

<p class=3DMsoNormal>[size=3D100G][features=3D1 queue_if_no_path][hwhandler=
=3D1 emc]<o:p></o:p></p>

<p class=3DMsoNormal>\_ round-robin 0 [prio=3D2][active]<o:p></o:p></p>

<p class=3DMsoNormal>=A0\_ 2:0:1:0 sdf 8:80=A0 [active][ready] <o:p></o:p><=
/p>

<p class=3DMsoNormal>=A0\_ 5:0:1:0 sdl 8:176 [active][ready] <o:p></o:p></p=
>

<p class=3DMsoNormal>\_ round-robin 0 [prio=3D0][enabled]<o:p></o:p></p>

<p class=3DMsoNormal>=A0\_ 2:0:0:0 sdc 8:32=A0 [active][faulty]<o:p></o:p><=
/p>

<p class=3DMsoNormal>=A0\_ 5:0:0:0 sdi 8:128 [active][faulty]<o:p></o:p></p=
>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>So when trying to write on a virtual device
/dev/mapper/NAGIOS (for exemple) I see many I/O errors on 'faulty disks'. W=
hen
tresspassing LUNs on the clariion, I see ready disks becoming faulty and fa=
ulty
ones becoming ready ... I also have udevd (udev-work) burning my CPUs while
trying to rename '/dev/disk/by-id/wwn-0xetcetc...udev-tmp'<o:p></o:p></p>

<p class=3DMsoNormal>What's wrong with my config ? Am I missing something ?=
<o:p></o:p></p>

<p class=3DMsoNormal>Thx by advance for your help,<o:p></o:p></p>

<p class=3DMsoNormal>Regards,<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<div>

<div>

<p class=3DMsoNormal>Cordialement,<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

</div>

</div>

<p class=3DMsoNormal><span style=3D'color:#1F497D'>--<o:p></o:p></span></p>

<p class=3DMsoNormal><span style=3D'color:#1F497D'>St=E9phane Neveu<o:p></o=
:p></span></p>

<p class=3DMsoNormal><span style=3D'color:#1F497D'>Ing=E9nieur Opensource /=
 RedHat
Technical Manager<o:p></o:p></span></p>

<p class=3DMsoNormal><span style=3D'color:#1F497D'>THALES - Critical Inform=
ation
Systems<o:p></o:p></span></p>

<p class=3DMsoNormal><span style=3D'color:#1F497D'>DIVISION Security Soluti=
ons
&amp; Services / Server Mgmt<o:p></o:p></span></p>

<p class=3DMsoNormal><span style=3D'color:#1F497D'>T=E9l 01 73 17 03 15<o:p=
></o:p></span></p>

<p class=3DMsoNormal><span style=3D'color:#1F497D'>--<o:p></o:p></span></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

</div>

</body>

</html>

--_000_EEF700FCD1A35041BF2C750B4EDDCA310138F9C49D3ATHSONEA01CM_--


--===============8879778186438046937==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8879778186438046937==--
