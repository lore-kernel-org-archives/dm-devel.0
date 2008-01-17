From: "Nath, Varun" <varun.nath@amd.com>
Subject: Need Help
Date: Thu, 17 Jan 2008 08:35:12 -0600
Message-ID: <EEBC5C82F965344199BFA3E6047FE13302E8B7@SAUSEXMB2.amd.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1456574605=="
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

--===============1456574605==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C85916.2B2F1CFC"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C85916.2B2F1CFC
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: quoted-printable

Hi,

=20

I am trying to configure multipathing on Red hat 4 update 6 64 bit.

=20

Below is the list of RPM I have installed

=20

rpm -qa | grep mapper

device-mapper-1.02.21-1.el4

device-mapper-1.02.21-1.el4

device-mapper-multipath-0.4.5-27.RHEL4

=20

The hardware is Sun x4600 and I am using QLA cards. The system has two
LUNs presented to it of size 10 GB and size 90 GB

=20

There is a problem when I configure file system on it. I am able to
access and mount the file system. But when I add those entries in
/etc/fstab, the system would not recognize those devices.=20

=20

Below is the output from multipath command

=20

multipath -ll

mpath5 (3600508b40010541d00009000065d0000)

[size=3D90 GB][features=3D"1 queue_if_no_path"][hwhandler=3D"0"]

\_ round-robin 0 [prio=3D100][active]

 \_ 1:0:0:2 sdd 8:48  [active][ready]

 \_ 2:0:0:2 sdh 8:112 [active][ready]

\_ round-robin 0 [prio=3D20][enabled]

 \_ 1:0:1:2 sdf 8:80  [active][ready]

 \_ 2:0:1:2 sdj 8:144 [active][ready]

=20

mpath4 (3600508b40010541d00009000065a0000)

[size=3D10 GB][features=3D"1 queue_if_no_path"][hwhandler=3D"0"]

\_ round-robin 0 [prio=3D100][enabled]

 \_ 1:0:1:1 sde 8:64  [active][ready]

 \_ 2:0:1:1 sdi 8:128 [active][ready]

\_ round-robin 0 [prio=3D20][enabled]

 \_ 1:0:0:1 sdc 8:32  [active][ready]

 \_ 2:0:0:1 sdg 8:96  [active][ready]

=20

=20

Also, below is my /etc/multipath.conf

=20

# This is an example configuration file for device mapper multipath.

# For a complete list of the default configuration values, see

# /usr/share/doc/device-mapper-multipath-0.4.5/multipath.conf.defaults

# For a list of configuration options with descriptions, see

# /usr/share/doc/device-mapper-multipath-0.4.5/multipath.conf.annotated

=20

=20

# Blacklist all devices by default. Remove this to enable multipathing

# on the default devices.

#devnode_blacklist {

#        devnode "*"

#}

=20

## Use user friendly names, instead of using WWIDs as names.

defaults {

        user_friendly_names yes

        selector   "round-robin 0"

}

=20

=20

## By default, devices with vendor =3D "IBM" and product =3D "S/390.*" =
are

## blacklisted. To enable mulitpathing on these devies, uncomment the

## following lines.

#devices {

#       device {

#               vendor                  "IBM"

#               product                 "S/390 DASD ECKD"

#               path_grouping_policy    multibus

#               getuid_callout          "/sbin/dasdview -j -f /dev/%n"

#               path_checker            directio

#       }

#}

=20

=20

##

## This is a template multipath-tools configuration file

## Uncomment the lines relevent to your environment

##

#defaults {

#       udev_dir                /dev

#       polling_interval        10

#       selector                "round-robin 0"

#       path_grouping_policy    multibus

#       getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"

#       prio_callout            /bin/true

#       path_checker            readsector0

#       rr_min_io               100

#       rr_weight               priorities

#       failback                immediate

#       no_path_retry           fail

#       user_friendly_name      yes

#}

##

## The wwid line in the following blacklist section is shown as an
example

## of how to blacklist devices by wwid.  The 3 devnode lines are the

## compiled in default blacklist. If you want to blacklist entire types

## of devices, such as all scsi devices, you should use a devnode line.

## However, if you want to blacklist specific devices, you should use

## a wwid line.  Since there is no guarantee that a specific device will

## not change names on reboot (from /dev/sda to /dev/sdb for example)

## devnode lines are not recommended for blacklisting specific devices.

##

devnode_blacklist {

       wwid 3600508e000000000ed7fb52911133c06

        devnode "^(ram|raw|loop|fd|md|sr|scd|st)[0-9]*"

        devnode "^hd[a-z]"

}

#multipaths {

#       multipath {

#               wwid
3600508b4000156d700012000000b0000

#               alias                   yellow

#               path_grouping_policy    multibus

#               path_checker            readsector0

#               path_selector           "round-robin 0"

#               failback                manual

#               rr_weight               priorities

#               no_path_retry           5

#       }

#       multipath {

#               wwid                    1DEC_____321816758474

#               alias                   red

#       }

#}

#devices {

#       device {

#               vendor                  "COMPAQ  "

#               product                 "HSV110 (C)COMPAQ"

#               path_grouping_policy    multibus

#               getuid_callout          "/sbin/scsi_id -g -u -s
/block/%n"

#               path_checker            readsector0

#               path_selector           "round-robin 0"

#               hardware_handler        "0"

#               failback                15

#               rr_weight               priorities

#               no_path_retry           queue

#       }

#       device {

#               vendor                  "COMPAQ  "

#               product                 "MSA1000         "

#               path_grouping_policy    multibus

#       }

#}

=20

=20

=20

=20

Here is the contents of the /dev/mpath/

=20

[root@x mpath]# pwd

/dev/mpath

[root@x mpath]# ls -all

total 0

drwxr-xr-x   2 root root   80 Jan 16 17:34 .

drwxr-xr-x  12 root root 5260 Jan 17 08:17 ..

lrwxrwxrwx   1 root root    7 Jan 16 17:34 mpath4 -> ../dm-8

lrwxrwxrwx   1 root root    7 Jan 16 17:34 mpath5 -> ../dm-9

=20

=20

=20

=20

Can anyone please help me with this? I think I am missing some
configuration on the system which is causing this.=20

=20

Thanks,

=20

=20


------_=_NextPart_001_01C85916.2B2F1CFC
Content-Type: text/html;
 charset=us-ascii
Content-Transfer-Encoding: quoted-printable

<html xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii">
<meta name=3DGenerator content=3D"Microsoft Word 11 (filtered medium)">
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:Verdana;
	panose-1:2 11 6 4 3 5 4 4 2 4;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:12.0pt;
	font-family:"Times New Roman";}
a:link, span.MsoHyperlink
	{color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{color:purple;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:Arial;
	color:windowtext;}
@page Section1
	{size:8.5in 11.0in;
	margin:1.0in 1.25in 1.0in 1.25in;}
div.Section1
	{page:Section1;}
-->
</style>

</head>

<body lang=3DEN-US link=3Dblue vlink=3Dpurple>

<div class=3DSection1>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Hi,<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>I am trying to configure multipathing on Red hat 4 =
update 6
64 bit.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Below is the list of RPM I have =
installed<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>rpm -qa =
| grep
mapper<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>device-m=
apper-1.02.21-1.el4<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>device-m=
apper-1.02.21-1.el4<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>device-m=
apper-multipath-0.4.5-27.RHEL4<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>The hardware is Sun x4600 and I am using QLA cards. =
The
system has two LUNs presented to it of size 10 GB and size 90 =
GB<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>There is a problem when I configure file system on =
it. I am
able to access and mount the file system. But when I add those entries =
in /etc/fstab,
the system would not recognize those devices. =
<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Below is the output from multipath =
command<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>multipat=
h -ll<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>mpath5
(3600508b40010541d00009000065d0000)<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>[size=3D=
90
GB][features=3D&quot;1 =
queue_if_no_path&quot;][hwhandler=3D&quot;0&quot;]<o:p></o:p></span></fon=
t></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>\_ =
round-robin 0
[prio=3D100][active]<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>&nbsp;\_=
 1:0:0:2
sdd 8:48&nbsp; [active][ready]<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>&nbsp;\_=
 2:0:0:2
sdh 8:112 [active][ready]<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>\_ =
round-robin 0
[prio=3D20][enabled]<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>&nbsp;\_=
 1:0:1:2
sdf 8:80&nbsp; [active][ready]<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>&nbsp;\_=
 2:0:1:2
sdj 8:144 [active][ready]<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'><o:p>&nb=
sp;</o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>mpath4
(3600508b40010541d00009000065a0000)<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>[size=3D=
10
GB][features=3D&quot;1 =
queue_if_no_path&quot;][hwhandler=3D&quot;0&quot;]<o:p></o:p></span></fon=
t></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>\_ =
round-robin 0
[prio=3D100][enabled]<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>&nbsp;\_=
 1:0:1:1
sde 8:64&nbsp; [active][ready]<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>&nbsp;\_=
 2:0:1:1
sdi 8:128 [active][ready]<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>\_ =
round-robin 0
[prio=3D20][enabled]<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>&nbsp;\_=
 1:0:0:1
sdc 8:32&nbsp; [active][ready]<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>&nbsp;\_=
 2:0:0:1
sdg 8:96&nbsp; [active][ready]<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Also, below is my =
/etc/multipath.conf<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'># This =
is an
example configuration file for device mapper =
multipath.<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'># For a =
complete
list of the default configuration values, =
see<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#
/usr/share/doc/device-mapper-multipath-0.4.5/multipath.conf.defaults<o:p>=
</o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'># For a =
list of
configuration options with descriptions, =
see<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#
/usr/share/doc/device-mapper-multipath-0.4.5/multipath.conf.annotated<o:p=
></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'><o:p>&nb=
sp;</o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'><o:p>&nb=
sp;</o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'># =
Blacklist all
devices by default. Remove this to enable =
multipathing<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'># on =
the default
devices.<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#devnode=
_blacklist
{<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
devnode &quot;*&quot;<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#}<o:p><=
/o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'><o:p>&nb=
sp;</o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>## Use =
user
friendly names, instead of using WWIDs as =
names.<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>defaults=
 {<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
user_friendly_names yes<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
selector&nbsp;&nbsp; &quot;round-robin =
0&quot;<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>}<o:p></=
o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'><o:p>&nb=
sp;</o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'><o:p>&nb=
sp;</o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>## By =
default,
devices with vendor =3D &quot;IBM&quot; and product =3D =
&quot;S/390.*&quot; are<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>## =
blacklisted.
To enable mulitpathing on these devies, uncomment =
the<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>## =
following
lines.<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#devices=
 {<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
device {<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;
vendor&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&quot;IBM&quot;<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;
product&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&quot;S/390 DASD ECKD&quot;<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;
path_grouping_policy&nbsp;&nbsp;&nbsp; =
multibus<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;
getuid_callout&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&quot;/sbin/dasdview -j -f =
/dev/%n&quot;<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;
path_checker&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;
directio<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
}<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#}<o:p><=
/o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'><o:p>&nb=
sp;</o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'><o:p>&nb=
sp;</o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>##<o:p><=
/o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>## This =
is a
template multipath-tools configuration =
file<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>## =
Uncomment the
lines relevent to your environment<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>##<o:p><=
/o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#default=
s {<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
udev_dir&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;
/dev<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
polling_interval&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
10<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
selector&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;
&quot;round-robin 0&quot;<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
path_grouping_policy&nbsp;&nbsp;&nbsp; =
multibus<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
getuid_callout&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&quot;/sbin/scsi_id
-g -u -s /block/%n&quot;<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
prio_callout&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;
/bin/true<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
path_checker&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;
readsector0<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
rr_min_io&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;
100<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
rr_weight&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;
priorities<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
failback&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;
immediate<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
no_path_retry&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
 fail<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
user_friendly_name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
yes<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#}<o:p><=
/o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>##<o:p><=
/o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>## The =
wwid line
in the following blacklist section is shown as an =
example<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>## of =
how to
blacklist devices by wwid.&nbsp; The 3 devnode lines are =
the<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>## =
compiled in
default blacklist. If you want to blacklist entire =
types<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>## of =
devices,
such as all scsi devices, you should use a devnode =
line.<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>## =
However, if
you want to blacklist specific devices, you should =
use<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>## a =
wwid
line.&nbsp; Since there is no guarantee that a specific device =
will<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>## not =
change
names on reboot (from /dev/sda to /dev/sdb for =
example)<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>## =
devnode lines
are not recommended for blacklisting specific =
devices.<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>##<o:p><=
/o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>devnode_=
blacklist
{<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;
wwid 3600508e000000000ed7fb52911133c06<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
devnode =
&quot;^(ram|raw|loop|fd|md|sr|scd|st)[0-9]*&quot;<o:p></o:p></span></font=
></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
devnode &quot;^hd[a-z]&quot;<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>}<o:p></=
o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#multipa=
ths {<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
multipath {<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;
wwid&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
3600508b4000156d700012000000b0000<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;
alias&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
yellow<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;
path_grouping_policy&nbsp;&nbsp;&nbsp; =
multibus<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;
path_checker&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;
readsector0<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;
path_selector&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=

&quot;round-robin 0&quot;<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;
failback&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;
manual<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;
rr_weight&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;
priorities<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;
no_path_retry&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
 5<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
}<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
multipath {<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;
wwid&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
1DEC_____321816758474<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;
alias&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
red<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
}<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#}<o:p><=
/o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#devices=
 {<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
device {<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;
vendor&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&quot;COMPAQ&nbsp; &quot;<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;
product&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&quot;HSV110 (C)COMPAQ&quot;<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;
path_grouping_policy&nbsp;&nbsp;&nbsp; =
multibus<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;
getuid_callout&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&quot;/sbin/scsi_id -g -u -s =
/block/%n&quot;<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;
path_checker&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;
readsector0<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;
path_selector&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=

&quot;round-robin 0&quot;<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;
hardware_handler&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&quot;0&quot;<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;
failback&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;
15<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;
rr_weight&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;
priorities<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;
no_path_retry&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
 queue<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
}<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
device {<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;
vendor&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&quot;COMPAQ&nbsp; &quot;<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;
product&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&quot;MSA1000&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&quot;<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;
path_grouping_policy&nbsp;&nbsp;&nbsp; =
multibus<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
}<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>#}<o:p><=
/o:p></span></font></i></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Here is the contents of the =
/dev/mpath/<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>[root@x =
mpath]#
pwd<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>/dev/mpa=
th<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>[root@x =
mpath]#
ls -all<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>total =
0<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>drwxr-xr=
-x&nbsp;&nbsp;
2 root root&nbsp;&nbsp; 80 Jan 16 17:34 =
.<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>drwxr-xr=
-x&nbsp;
12 root root 5260 Jan 17 08:17 ..<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>lrwxrwxr=
wx&nbsp;&nbsp;
1 root root&nbsp;&nbsp;&nbsp; 7 Jan 16 17:34 mpath4 -&gt; =
../dm-8<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'>lrwxrwxr=
wx&nbsp;&nbsp;
1 root root&nbsp;&nbsp;&nbsp; 7 Jan 16 17:34 mpath5 -&gt; =
../dm-9<o:p></o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'><o:p>&nb=
sp;</o:p></span></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'><o:p>&nb=
sp;</o:p></span></font></i></p>

<p class=3DMsoNormal =
style=3D'margin-left:1.5in;text-align:justify'><font size=3D2
face=3DVerdana><span =
style=3D'font-size:10.0pt;font-family:Verdana'><o:p>&nbsp;</o:p></span></=
font></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'><o:p>&nb=
sp;</o:p></span></font></i></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Can anyone please help me with this? I think I am =
missing
some configuration on the system which is causing this. =
<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Thanks,<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:1.5in'><i><font size=3D2 =
face=3DVerdana><span
style=3D'font-size:10.0pt;font-family:Verdana;font-style:italic'><o:p>&nb=
sp;</o:p></span></font></i></p>

</div>

</body>

</html>

------_=_NextPart_001_01C85916.2B2F1CFC--



--===============1456574605==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1456574605==--
