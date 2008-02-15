From: "Rogan, Julian" <Julian.Rogan@Unilever.com>
Subject: multipath errors on first set-up
Date: Fri, 15 Feb 2008 16:22:07 -0000
Message-ID: <DFB2D7E03264FB4392B70A38BFF9FC7101FFB4C3@BRBSEVS20000.s2.ms.unilever.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1774348186=="
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

--===============1774348186==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C86FEE.E8C1F53A"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C86FEE.E8C1F53A
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable


Hi,
I am using multipath for the first time with little joy.

=20
1. The requirement was to test SAN storage on a Redhat RHEL V4 Q2.
   I have a 1 TByte lun pointed at the server from the SAN.
   The are 4 QLOGIC HBAs attached.
  =20
   From /etc/sysconfig/hwconf:
   driver: qla2300
   desc: "QLogic Corp. QLA2312 Fibre Channel Adapter"

2. After correcting the qlogic firmware setup (during server boot) and
running ql-dynamic-tgt-lun-disc.sh ( utility from the QLOGIC website) I
could see 4 new disk devices. sda - sdd.
The ouput from ql-dynamic-tgt-lun-disc.sh looks like this:

DEVICE
[H:C:T:L]
[0:0:0:0]
[0:0:0:1]
[1:0:0:0]
[1:0:0:1]
[2:0:0:0]
[2:0:0:1]
[3:0:0:0]
[3:0:0:1]

3. I installed the following rpms for multipath support ( from the
Redhat site).
   rpm -ivh sysfsutils-1.2.0-1.i386.rpm - pre-req
   device-mapper-multipath-0.4.5-6.0.RHEL4.i386.rpm

4.Starting the multipathd daemon at first did nothing.

I then did some google'ing and did the following:

modprobe dm-multipath
modprobe dm-round-robin

based on some other documents I made the following changes to
/etc/multipath.conf

# Blacklist all devices by default. Remove this to enable multipathing #
on the default devices.

#devnode_blacklist {
#       devnode "*"
#}
above paragraph commented out

##
## This is a template multipath-tools configuration file ## Uncomment
the lines relevent to your environment ## defaults {
        multipath_tool  "/sbin/multipath -v0"
        udev_dir        /dev
        polling_interval 10
        default_selector        "round-robin 0"
        default_path_grouping_policy    multibus
        default_getuid_callout  "/sbin/scsi_id -g -u -s /block/%n"
        default_prio_callout    "/bin/true"
        default_features        "0"
        rr_wmin_io              100
        failback                immediate
}

Removed comments from above default stanza=20

device {
       vendor                  "COMPAQ  "
       product                 "MSA1000 VOLUME  "
       path_grouping_policy    multibus
       path_checker            tur
}

Removed comments from above device stanza for MSA1000 VOLUME

The rest of the config file is all commented out.

I ran=20
multipath -v3 to recreate I get the following:

[root@brli036a mapper]# multipath -v3
cciss!c0d0 blacklisted
deleted rest of blacklist output

path sda not found in pathvec

=3D=3D=3D=3D=3D path sda =3D=3D=3D=3D=3D
bus =3D 1
dev_t =3D 8:0
size =3D 3906810493
vendor =3D HP
product =3D MSA VOLUME
rev =3D 6.86
h:b:t:l =3D 0:0:0:1
tgt_node_name =3D 0x500508b300930230
serial =3D PB9840PX3TF0C0
path checker =3D readsector0 (internal default)
state =3D 2
getprio =3D /bin/true (internal default)
prio =3D 0
getuid =3D /sbin/scsi_id -g -u -s /block/%n (internal default)
uid =3D 3600508b300930230a7495ae1b9500074 (callout)

path sdb not found in pathvec

=3D=3D=3D=3D=3D path sdb =3D=3D=3D=3D=3D
bus =3D 1
dev_t =3D 8:16
size =3D 3906810493
vendor =3D HP
product =3D MSA VOLUME
rev =3D 6.86
h:b:t:l =3D 1:0:0:1
tgt_node_name =3D 0x500508b300930230
serial =3D PB9840PX3TJ0FU
path checker =3D readsector0 (internal default)
state =3D 2
getprio =3D /bin/true (internal default)
prio =3D 0
getuid =3D /sbin/scsi_id -g -u -s /block/%n (internal default)
uid =3D 3600508b300930230a7495ae1b9500074 (callout)

path sdc not found in pathvec

=3D=3D=3D=3D=3D path sdc =3D=3D=3D=3D=3D
bus =3D 1
dev_t =3D 8:32
size =3D 3906810493
vendor =3D HP
product =3D MSA VOLUME
rev =3D 6.86
h:b:t:l =3D 2:0:0:1
tgt_node_name =3D 0x500508b300930230
serial =3D PB9840PX3TF0C0
path checker =3D readsector0 (internal default)
state =3D 2
getprio =3D /bin/true (internal default)
prio =3D 0
getuid =3D /sbin/scsi_id -g -u -s /block/%n (internal default)
uid =3D 3600508b300930230a7495ae1b9500074 (callout)

path sdd not found in pathvec

=3D=3D=3D=3D=3D path sdd =3D=3D=3D=3D=3D
bus =3D 1
dev_t =3D 8:48
size =3D 3906810493
vendor =3D HP
product =3D MSA VOLUME
rev =3D 6.86
h:b:t:l =3D 3:0:0:1
tgt_node_name =3D 0x500508b300930230
serial =3D PB9840PX3TJ0FU
path checker =3D readsector0 (internal default)
state =3D 2
getprio =3D /bin/true (internal default)
prio =3D 0
getuid =3D /sbin/scsi_id -g -u -s /block/%n (internal default)
uid =3D 3600508b300930230a7495ae1b9500074 (callout)
#
# all paths :
#
3600508b300930230a7495ae1b9500074 0:0:0:1 sda  8:0     [MSA VOLUME
]
3600508b300930230a7495ae1b9500074 1:0:0:1 sdb  8:16    [MSA VOLUME
]
3600508b300930230a7495ae1b9500074 2:0:0:1 sdc  8:32    [MSA VOLUME
]
3600508b300930230a7495ae1b9500074 3:0:0:1 sdd  8:48    [MSA VOLUME
]
pgpolicy =3D multibus (config file default)
selector =3D round-robin 0 (internal default)
features =3D 0 (internal default)
hwhandler =3D 0 (internal default)
0 3906810493 multipath 0 0 1 1 round-robin 0 4 1 8:0 1000 8:16 1000 8:32
1000 8:48 1000
action preset to 0
action set to 4
create: 3600508b300930230a7495ae1b9500074
[size=3D1 TB][features=3D"0"][hwhandler=3D"0"]
\_ round-robin 0
  \_ 0:0:0:1 sda  8:0
  \_ 1:0:0:1 sdb  8:16
  \_ 2:0:0:1 sdc  8:32
  \_ 3:0:0:1 sdd  8:48

device-mapper ioctl cmd 14 failed: Invalid argument
message 3600508b300930230a7495ae1b9500074 0 switch_group 1
failed


Note sure if "path sdX not found in pathvec" relevant

anyway no mpaths have been created.

I hope there is someone out there who can give me some help with this.
 =20
with regards,
Julian Rogan




------_=_NextPart_001_01C86FEE.E8C1F53A
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Dus-ascii">
<META NAME=3D"Generator" CONTENT=3D"MS Exchange Server version =
6.5.7651.59">
<TITLE>multipath errors on first set-up</TITLE>
</HEAD>
<BODY>
<!-- Converted from text/rtf format -->
<BR>

<P><FONT SIZE=3D2 FACE=3D"Arial">Hi,</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">I am using multipath for the first =
time with little joy.</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial">&nbsp;</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">1. The requirement was to test SAN =
storage on a Redhat RHEL V4 Q2.</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">&nbsp;&nbsp; I have a 1 TByte lun =
pointed at the server from the SAN.</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">&nbsp;&nbsp; The are 4 QLOGIC HBAs =
attached.</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">&nbsp;&nbsp; </FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">&nbsp;&nbsp; From =
/etc/sysconfig/hwconf:</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">&nbsp;&nbsp; driver: qla2300</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">&nbsp;&nbsp; desc: &quot;QLogic Corp. =
QLA2312 Fibre Channel Adapter&quot;</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial">2. After correcting the qlogic firmware =
setup (during server boot) and running ql-dynamic-tgt-lun-disc.sh ( =
utility from the QLOGIC website) I could see 4 new disk devices. sda - =
sdd.</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Arial">The ouput from =
ql-dynamic-tgt-lun-disc.sh looks like this:</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial">DEVICE</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">[H:C:T:L]</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">[0:0:0:0]</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">[0:0:0:1]</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">[1:0:0:0]</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">[1:0:0:1]</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">[2:0:0:0]</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">[2:0:0:1]</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">[3:0:0:0]</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">[3:0:0:1]</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial">3. I installed the following rpms for =
multipath support ( from the Redhat site).</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">&nbsp;&nbsp; rpm -ivh =
sysfsutils-1.2.0-1.i386.rpm - pre-req</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">&nbsp;&nbsp; =
device-mapper-multipath-0.4.5-6.0.RHEL4.i386.rpm</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial">4.Starting the multipathd daemon at =
first did nothing.</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial">I then did some google'ing and did the =
following:</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial">modprobe dm-multipath</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">modprobe dm-round-robin</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial">based on some other documents I made =
the following changes to /etc/multipath.conf</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial"># Blacklist all devices by default. =
Remove this to enable multipathing # on the default devices.</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial">#devnode_blacklist {</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
devnode &quot;*&quot;</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">#}</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">above paragraph commented out</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial">##</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">## This is a template multipath-tools =
configuration file ## Uncomment the lines relevent to your environment =
## defaults {</FONT></P>

<P><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
multipath_tool&nbsp; &quot;/sbin/multipath -v0&quot;</FONT>

<BR><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
udev_dir&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /dev</FONT>

<BR><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
polling_interval 10</FONT>

<BR><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
default_selector&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&quot;round-robin 0&quot;</FONT>

<BR><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
default_path_grouping_policy&nbsp;&nbsp;&nbsp; multibus</FONT>

<BR><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
default_getuid_callout&nbsp; &quot;/sbin/scsi_id -g -u -s =
/block/%n&quot;</FONT>

<BR><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
default_prio_callout&nbsp;&nbsp;&nbsp; &quot;/bin/true&quot;</FONT>

<BR><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
default_features&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&quot;0&quot;</FONT>

<BR><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
rr_wmin_io&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp; 100</FONT>

<BR><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
failback&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; immediate</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">}</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial">Removed comments from above default =
stanza </FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial">device {</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
vendor&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;COMPAQ&nbsp; &quot;</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
product&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;MSA1000 VOLUME&nbsp; &quot;</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
path_grouping_policy&nbsp;&nbsp;&nbsp; multibus</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
path_checker&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; tur</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">}</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial">Removed comments from above device =
stanza for MSA1000 VOLUME</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial">The rest of the config file is all =
commented out.</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial">I ran </FONT>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">multipath =
&#8211;v3 to recreate I get the following:</FONT></SPAN>
</P>

<P><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">[root@brli036a =
mapper]# multipath -v3</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">cciss!c0d0 =
blacklisted</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">deleted rest of =
blacklist output</FONT></SPAN>
</P>

<P><SPAN LANG=3D"en-us"><B><FONT SIZE=3D2 FACE=3D"Arial">path sda not =
found in pathvec</FONT></B></SPAN>
</P>

<P><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">=3D=3D=3D=3D=3D =
path sda =3D=3D=3D=3D=3D</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">bus =3D =
1</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">dev_t =3D =
8:0</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">size =3D =
3906810493</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">vendor =3D =
HP</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">product =3D MSA =
VOLUME</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">rev =3D =
6.86</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">h:b:t:l =3D =
0:0:0:1</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">tgt_node_name =3D =
0x500508b300930230</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">serial =3D =
PB9840PX3TF0C0</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">path checker =3D =
readsector0 (internal default)</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">state =3D =
2</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">getprio =3D =
/bin/true (internal default)</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">prio =3D =
0</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">getuid =3D =
/sbin/scsi_id -g -u -s /block/%n (internal default)</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">uid =3D =
3600508b300930230a7495ae1b9500074 (callout)</FONT></SPAN>
</P>

<P><SPAN LANG=3D"en-us"><B><FONT SIZE=3D2 FACE=3D"Arial">path sdb not =
found in pathvec</FONT></B></SPAN>
</P>

<P><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">=3D=3D=3D=3D=3D =
path sdb =3D=3D=3D=3D=3D</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">bus =3D =
1</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">dev_t =3D =
8:16</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">size =3D =
3906810493</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">vendor =3D =
HP</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">product =3D MSA =
VOLUME</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">rev =3D =
6.86</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">h:b:t:l =3D =
1:0:0:1</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">tgt_node_name =3D =
0x500508b300930230</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">serial =3D =
PB9840PX3TJ0FU</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">path checker =3D =
readsector0 (internal default)</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">state =3D =
2</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">getprio =3D =
/bin/true (internal default)</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">prio =3D =
0</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">getuid =3D =
/sbin/scsi_id -g -u -s /block/%n (internal default)</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">uid =3D =
3600508b300930230a7495ae1b9500074 (callout)</FONT></SPAN>
</P>

<P><SPAN LANG=3D"en-us"><B><FONT SIZE=3D2 FACE=3D"Arial">path sdc not =
found in pathvec</FONT></B></SPAN>
</P>

<P><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">=3D=3D=3D=3D=3D =
path sdc =3D=3D=3D=3D=3D</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">bus =3D =
1</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">dev_t =3D =
8:32</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">size =3D =
3906810493</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">vendor =3D =
HP</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">product =3D MSA =
VOLUME</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">rev =3D =
6.86</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">h:b:t:l =3D =
2:0:0:1</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">tgt_node_name =3D =
0x500508b300930230</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">serial =3D =
PB9840PX3TF0C0</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">path checker =3D =
readsector0 (internal default)</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">state =3D =
2</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">getprio =3D =
/bin/true (internal default)</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">prio =3D =
0</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">getuid =3D =
/sbin/scsi_id -g -u -s /block/%n (internal default)</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">uid =3D =
3600508b300930230a7495ae1b9500074 (callout)</FONT></SPAN>
</P>

<P><SPAN LANG=3D"en-us"><B><FONT SIZE=3D2 FACE=3D"Arial">path sdd not =
found in pathvec</FONT></B></SPAN>
</P>

<P><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">=3D=3D=3D=3D=3D =
path sdd =3D=3D=3D=3D=3D</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">bus =3D =
1</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">dev_t =3D =
8:48</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">size =3D =
3906810493</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">vendor =3D =
HP</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">product =3D MSA =
VOLUME</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">rev =3D =
6.86</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">h:b:t:l =3D =
3:0:0:1</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">tgt_node_name =3D =
0x500508b300930230</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">serial =3D =
PB9840PX3TJ0FU</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">path checker =3D =
readsector0 (internal default)</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">state =3D =
2</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">getprio =3D =
/bin/true (internal default)</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">prio =3D =
0</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">getuid =3D =
/sbin/scsi_id -g -u -s /block/%n (internal default)</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">uid =3D =
3600508b300930230a7495ae1b9500074 (callout)</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">#</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial"># all paths =
:</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">#</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">3600508b300930230a7495ae1b9500074 0:0:0:1 sda&nbsp; =
8:0&nbsp;&nbsp;&nbsp;&nbsp; [MSA VOLUME&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
]</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">3600508b300930230a7495ae1b9500074 1:0:0:1 sdb&nbsp; =
8:16&nbsp;&nbsp;&nbsp; [MSA VOLUME&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
]</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">3600508b300930230a7495ae1b9500074 2:0:0:1 sdc&nbsp; =
8:32&nbsp;&nbsp;&nbsp; [MSA VOLUME&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
]</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">3600508b300930230a7495ae1b9500074 3:0:0:1 sdd&nbsp; =
8:48&nbsp;&nbsp;&nbsp; [MSA VOLUME&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
]</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">pgpolicy =3D =
multibus (config file default)</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">selector =3D =
round-robin 0 (internal default)</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">features =3D 0 =
(internal default)</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">hwhandler =3D 0 =
(internal default)</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">0 3906810493 =
multipath 0 0 1 1 round-robin 0 4 1 8:0 1000 8:16 1000 8:32 1000 8:48 =
1000</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">action preset to =
0</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">action set to =
4</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">create: =
3600508b300930230a7495ae1b9500074</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">[size=3D1 =
TB][features=3D&quot;0&quot;][hwhandler=3D&quot;0&quot;]</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">\_ round-robin =
0</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">&nbsp; \_ 0:0:0:1 =
sda&nbsp; 8:0</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">&nbsp; \_ 1:0:0:1 =
sdb&nbsp; 8:16</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">&nbsp; \_ 2:0:0:1 =
sdc&nbsp; 8:32</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">&nbsp; \_ 3:0:0:1 =
sdd&nbsp; 8:48</FONT></SPAN>
</P>

<P><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">device-mapper =
ioctl cmd 14 failed: Invalid argument</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">message =
3600508b300930230a7495ae1b9500074 0 switch_group 1</FONT></SPAN>

<BR><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Arial">failed</FONT></SPAN>
</P>
<BR>

<P><SPAN LANG=3D"en-gb"><FONT SIZE=3D2 FACE=3D"Arial">Note sure if =
&quot;</FONT></SPAN><SPAN LANG=3D"en-gb"><B></B></SPAN><B><SPAN =
LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Arial">path sdX not found in =
pathvec&quot; relevant</FONT></SPAN></B><SPAN =
LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-gb"></SPAN>
</P>

<P><SPAN LANG=3D"en-gb"><FONT SIZE=3D2 FACE=3D"Arial">anyway no mpaths =
have been created.</FONT></SPAN>
</P>

<P><SPAN LANG=3D"en-gb"><FONT SIZE=3D2 FACE=3D"Arial">I hope there is =
someone out there who can give me some help with this.</FONT></SPAN>

<BR><SPAN LANG=3D"en-gb"><FONT SIZE=3D2 FACE=3D"Arial">&nbsp; =
</FONT></SPAN>

<BR><SPAN LANG=3D"en-gb"><FONT SIZE=3D2 FACE=3D"Arial">with =
regards,</FONT></SPAN>

<BR><SPAN LANG=3D"en-gb"><FONT SIZE=3D2 FACE=3D"Arial">Julian =
Rogan</FONT></SPAN>
</P>
<BR>
<BR>

</BODY>
</HTML>
------_=_NextPart_001_01C86FEE.E8C1F53A--


--===============1774348186==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1774348186==--
