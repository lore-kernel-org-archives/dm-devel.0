From: Jason Price <japrice@gmail.com>
Subject: dm-multipath fails when one path is taken offline.
Date: Wed, 29 Jun 2011 11:55:04 -0400
Message-ID: <BANLkTinvO+3RTa48ND+EVTWq_g+dxLBW-A@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5743126028789904793=="
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

--===============5743126028789904793==
Content-Type: multipart/alternative; boundary=00504502bf4fcdcdc904a6dbced6

--00504502bf4fcdcdc904a6dbced6
Content-Type: text/plain; charset=ISO-8859-1

I seem to have multipath setup correctly:

# multipath -ll
vrp (360060e8010053b90052fb06900000190) dm-8 HITACHI,DF600F
size=70G features='1 queue_if_no_path' hwhandler='0' wp=rw
|-+- policy='round-robin 0' prio=1 status=enabled
| `- 6:0:0:0 sdc 8:32 active ready running
`-+- policy='round-robin 0' prio=0 status=enabled
 `- 5:0:0:0 sdb 8:16 active ready running

When I fail the /dev/sdb path, things work fine.  I can fail and restore the
path all day.  When I fail the /dev/sdc path, the kernel marks the
filesystem as read-only.

Background:
Running v0.4.9 of device-mapper-multipath
Hitachi AMS2500 array, using ports 0F and 1F
Brocade 5300 switches, split into two fabrics.  (fabric A, port 30,
fabric B port 30)
Host has a qlogic 2462 card with two ports in use.
device-mapper names the devices, LVM2 PV created from that, made into a VG,
and then an LV (see below)
Failures produced by disabling the fabric port at the switch level (or
physically disconnecting the fiber).

Current multipath.conf:

blacklist {
       devnode "^sda$"
}

defaults {
               checker_timeout         5
               polling_interval        5
}

multipaths {
       multipath {
               wwid 360060e8010053b90052fb06900000190
               alias                   vrp
#               path_selector           "round-robin 0"
       }
}

results of 'multipath -ll'

# multipath -ll
vrp (360060e8010053b90052fb06900000190) dm-8 HITACHI,DF600F
size=70G features='1 queue_if_no_path' hwhandler='0' wp=rw
|-+- policy='round-robin 0' prio=1 status=enabled
| `- 6:0:0:0 sdc 8:32 active ready running
`-+- policy='round-robin 0' prio=0 status=enabled
 `- 5:0:0:0 sdb 8:16 active ready running

I've also worked with several revisions of the multipath.conf file.  If I
remember correctly, with some device stanza revisions, I've had multipath
-ll
returning this result instead:

# multipath -ll
vrp (360060e8010053b90052fb06900000190) dm-8 HITACHI,DF600F
size=70G features='0' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=1 status=active
|- 6:0:0:0 sdc 8:32 active ready running
`- 5:0:0:0 sdb 8:16 active ready running

However, both are affected by the same problem.

Excerpt from /etc/fstab:
LABEL=vrp-db            /vrp-db                 ext3    defaults        0 2

relevant line from pvscan:
 PV /dev/mpath/vrp   VG vrpdg     lvm2 [70.00 GB / 0    free]

relevant line from vgscan:
 Found volume group "vrpdg" using metadata type lvm2

While I'd prefer an 'active-active' setup, I'd accept an active/passive
setup, provided it failed over correctly... preferably with a fast failback.

I'm more than happy to provide any other information.

--Jason

--00504502bf4fcdcdc904a6dbced6
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<span class=3D"Apple-style-span" style=3D"border-collapse: collapse; font-f=
amily: arial, sans-serif; font-size: 13px; "><div><span class=3D"Apple-styl=
e-span" style=3D"border-collapse: collapse; font-family: arial, sans-serif;=
 font-size: 13px; ">I seem to have multipath setup correctly:</span></div>
<div><span class=3D"Apple-style-span" style=3D"border-collapse: collapse; f=
ont-family: arial, sans-serif; font-size: 13px; "><br></span></div></span><=
span class=3D"Apple-style-span" style=3D"border-collapse: collapse; font-fa=
mily: arial, sans-serif; font-size: 13px; "># multipath -ll<br>
vrp (360060e8010053b90052fb06900000190) dm-8 HITACHI,DF600F<br>size=3D70G f=
eatures=3D&#39;1 queue_if_no_path&#39; hwhandler=3D&#39;0&#39; wp=3Drw<br>|=
-+- policy=3D&#39;round-robin 0&#39; prio=3D1 status=3Denabled<br>| `- 6:0:=
0:0 sdc 8:32 active ready running<br>
`-+- policy=3D&#39;round-robin 0&#39; prio=3D0 status=3Denabled<br>=A0`- 5:=
0:0:0 sdb 8:16 active ready running<br></span><span class=3D"Apple-style-sp=
an" style=3D"border-collapse: collapse; font-family: arial, sans-serif; fon=
t-size: 13px; "><div>
<span class=3D"Apple-style-span" style=3D"border-collapse: collapse; font-f=
amily: arial, sans-serif; font-size: 13px; "><br></span></div><div>When I f=
ail the /dev/sdb path, things work fine. =A0I can fail and restore the path=
 all day. =A0When I fail the /dev/sdc path, the kernel marks the filesystem=
 as read-only.</div>
<div><br></div>Background:<br>Running v0.4.9 of device-mapper-multipath<br>=
Hitachi AMS2500 array, using ports 0F and 1F<br>Brocade 5300 switches, spli=
t into two fabrics. =A0(fabric A, port 30,<br>fabric B port 30)<br></span><=
span class=3D"Apple-style-span" style=3D"border-collapse: collapse; font-fa=
mily: arial, sans-serif; font-size: 13px; ">Host has a qlogic 2462 card wit=
h two por</span><span class=3D"Apple-style-span" style=3D"border-collapse: =
collapse; font-family: arial, sans-serif; font-size: 13px; ">ts in use.</sp=
an><div>
<font class=3D"Apple-style-span" face=3D"arial, sans-serif"><span class=3D"=
Apple-style-span" style=3D"border-collapse: collapse;">device-mapper names =
the devices, LVM2 PV created from that, made into a VG, and then an LV (see=
 below)<br>
</span></font><div><span class=3D"Apple-style-span" style=3D"border-collaps=
e: collapse; font-family: arial, sans-serif; font-size: 13px; ">Failures pr=
oduced by disabling the fabric port at the switch level (or physically disc=
onnecting the fiber).<br>
<br>Current multipath.conf:<br><br>blacklist {<br>=A0 =A0 =A0 =A0devnode &q=
uot;^sda$&quot;<br>}<br><br>defaults {<br>=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ch=
ecker_timeout =A0 =A0 =A0 =A0 5<br>=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0polling_i=
nterval =A0 =A0 =A0 =A05<br>}<br><br>multipaths {<br>
=A0 =A0 =A0 =A0multipath {<br>=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wwid 360060e80=
10053b90052fb06900000190<br>=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0alias =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 vrp<br># =A0 =A0 =A0 =A0 =A0 =A0 =A0 path_selec=
tor =A0 =A0 =A0 =A0 =A0 &quot;round-robin 0&quot;<br>=A0 =A0 =A0 =A0}<br>}<=
br><br>results of &#39;multipath -ll&#39;<br>
<br># multipath -ll<br>vrp (360060e8010053b90052fb06900000190) dm-8 HITACHI=
,DF600F<br>size=3D70G features=3D&#39;1 queue_if_no_path&#39; hwhandler=3D&=
#39;0&#39; wp=3Drw<br>|-+- policy=3D&#39;round-robin 0&#39; prio=3D1 status=
=3Denabled<br>
| `- 6:0:0:0 sdc 8:32 active ready running<br>`-+- policy=3D&#39;round-robi=
n 0&#39; prio=3D0 status=3Denabled<br>=A0`- 5:0:0:0 sdb 8:16 active ready r=
unning<br><br>I&#39;ve also worked with several revisions of the multipath.=
conf file. =A0If I<br>
remember correctly, with some device stanza revisions, I&#39;ve had multipa=
th -ll<br>returning this result instead:<br><br># multipath -ll<br>vrp (360=
060e8010053b90052fb06900000190) dm-8 HITACHI,DF600F<br>size=3D70G features=
=3D&#39;0&#39; hwhandler=3D&#39;0&#39; wp=3Drw<br>
`-+- policy=3D&#39;round-robin 0&#39; prio=3D1 status=3Dactive<br>|- 6:0:0:=
0 sdc 8:32 active ready running<br>`- 5:0:0:0 sdb 8:16 active ready running=
<br><br>However, both are affected by the same problem.<br><br>Excerpt from=
 /etc/fstab:<br>
LABEL=3Dvrp-db =A0 =A0 =A0 =A0 =A0 =A0/vrp-db =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 ext3 =A0 =A0defaults =A0 =A0 =A0 =A00 2<br><br>relevant line from pvsca=
n:<br>=A0PV /dev/mpath/vrp =A0 VG vrpdg =A0 =A0 lvm2 [70.00 GB / 0 =A0 =A0f=
ree]<br><br>relevant line from vgscan:<br>=A0Found volume group &quot;vrpdg=
&quot; using metadata type lvm2<br>
<br>While I&#39;d prefer an &#39;active-active&#39; setup, I&#39;d accept a=
n active/passive<br>setup, provided it failed over correctly... preferably =
with a fast failback.<br><br>I&#39;m more than happy to provide any other i=
nformation.<br>
<br>--<span class=3D"il" style=3D"background-image: initial; background-att=
achment: initial; background-origin: initial; background-clip: initial; bac=
kground-color: rgb(255, 255, 204); ">Jason</span></span><div><div><div></di=
v>
</div></div></div></div>

--00504502bf4fcdcdc904a6dbced6--


--===============5743126028789904793==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5743126028789904793==--
