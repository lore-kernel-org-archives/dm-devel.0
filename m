From: Adarsh <adarshanto@gmail.com>
Subject: udevsettle command takes long time to settle in RHEL 5.9
	& 5.10
Date: Wed, 12 Mar 2014 04:56:11 +0530
Message-ID: <CAH2zp-jiktuuN-xkF+uo1X92XHLNZuiCceOLmD8wciAwTWNpng@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2152191089073677925=="
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
To: dm-devel@redhat.com, bmarzins@redhat.com
Cc: multipath@lists.linux.ibm.com
List-Id: dm-devel.ids

--===============2152191089073677925==
Content-Type: multipart/alternative; boundary=001a11c2a20ca9c79a04f45d0beb

--001a11c2a20ca9c79a04f45d0beb
Content-Type: text/plain; charset=ISO-8859-1

Hi All,

Can you please help me with an issue which I am facing in RHEL 5.9 & 5.10
setups.

udevsettle command takes quite long time (60-150 seconds) to return
sometimes.
This is mostly after creating a LUN & issuing a "rescan-scsi-bus.sh"
Please note that only around 10-20 LUNs are present while this issue is hit.

Looked into the udev logs & looks like the culprit is the following line in
"/etc/udev/rules.d/40-multipath.rules":
     RUN+="/bin/bash -c '/sbin/mpath_wait /dev/mapper/%c; /sbin/kpartx -a
-p p /dev/mapper/%c'"

The rule is getting called multiple times for the same device & hence
udevsettle keeps waiting for all these to finish

Mar 10 13:47:00 x336-207-55 udevd-event[8013]: run_program: '/bin/bash -c
'/sbin/mpath_wait /dev/mapper/360a98000316b61396a2b3946424b6f2d;
/sbin/kpartx -a -p p /dev/mapper/360a98000316b61396a2b3946424b6f2d'

Mar 10 13:47:04 x336-207-55 udevd-event[8033]: run_program: '/bin/bash -c
'/sbin/mpath_wait /dev/mapper/360a98000316b61396a2b3946424b6f2d;
/sbin/kpartx -a -p p /dev/mapper/360a98000316b61396a2b3946424b6f2d'

Mar 10 13:47:04 x336-207-55 udevd-event[8107]: run_program: '/bin/bash -c
'/sbin/mpath_wait /dev/mapper/360a98000316b61396a2b3946424b6f2d;
/sbin/kpartx -a -p p /dev/mapper/360a98000316b61396a2b3946424b6f2d'

Mar 10 13:47:10 x336-207-55 udevd-event[8212]: run_program: '/bin/bash -c
'/sbin/mpath_wait /dev/mapper/360a98000316b61396a2b3946424b6f2d;
/sbin/kpartx -a -p p /dev/mapper/360a98000316b61396a2b3946424b6f2d'


Hence, I commented out the line from "multipath.rules" & it started working
fine:
    RUN+="/bin/bash -c '/sbin/mpath_wait /dev/mapper/%c; /sbin/kpartx -a -p
p /dev/mapper/%c'"

Couple of queries:

1. Please let me know if there are any side effects for commenting out the
above mentioned line.
    Ben mentions that block device addition is now taken care of by NETLINK
events as long as multipath is running & no need for udev to fire off
multipath: https://bugzilla.redhat.com/show_bug.cgi?id=460301

2. Please let me know if this is a known issue. I observe it only in
RHEL 5.9 and 5.10 setups.


Any pointers is highly appreciated.


Setup:
======
Red Hat Enterprise Linux Server release 5.10 (Tikanga)
Kernel \r on an \m

Multipath.conf:
===========
defaults {
        user_friendly_names             no
        queue_without_daemon            no
        flush_on_last_del               yes
        max_fds                         max
        pg_prio_calc                    avg
}
blacklist {
        wwid                            SIBM-ESXSMAW3073NC_FDAR9P6402NE0
        wwid                            SIBM-ESXSMAW3073NC_FDAR9P6402PP2
        devnode                         "^cciss.*"
}
devices {
        device {
                vendor                    "NETAPP"
                product                   "LUN"
                features                  "3 queue_if_no_path
pg_init_retries 50"
                path_grouping_policy    group_by_prio
                prio_callout             "/sbin/mpath_prio_alua /dev/%n"
                path_checker            tur
                failback                      immediate
                hardware_handler     "1 alua"
                rr_weight                    uniform
                rr_min_io                    128
                getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
       }
}

regards,
Adarsh.

--001a11c2a20ca9c79a04f45d0beb
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div style=3D"font-family:arial,sans-serif;font-size:12.66=
6666984558105px">Hi All,</div><div style=3D"font-family:arial,sans-serif;fo=
nt-size:12.666666984558105px"><br></div><div style=3D"font-family:arial,san=
s-serif;font-size:12.666666984558105px">
Can you please help me with an issue which I am facing in RHEL 5.9 &amp; 5.=
10 setups.</div><div style=3D"font-family:arial,sans-serif;font-size:12.666=
666984558105px"><br></div><div style=3D"font-family:arial,sans-serif;font-s=
ize:12.666666984558105px">
udevsettle command takes quite long time (60-150 seconds) to return sometim=
es.<br></div><div style=3D"font-family:arial,sans-serif;font-size:12.666666=
984558105px">This is mostly after creating a LUN &amp; issuing a &quot;resc=
an-scsi-bus.sh&quot;</div>
<div style=3D"font-family:arial,sans-serif;font-size:12.666666984558105px">=
Please note that only around 10-20 LUNs are present while this issue is hit=
.</div><div style=3D"font-family:arial,sans-serif;font-size:12.666666984558=
105px">
<br></div><div style=3D"font-family:arial,sans-serif;font-size:12.666666984=
558105px">Looked into the udev logs &amp; looks like the culprit is the fol=
lowing line in &quot;/etc/udev/rules.d/40-multipath.rules&quot;:</div><div =
style=3D"font-family:arial,sans-serif;font-size:12.666666984558105px">
=A0 =A0 =A0RUN+=3D&quot;/bin/bash -c &#39;/sbin/mpath_wait
/dev/mapper/%c; /sbin/kpartx -a -p p /dev/mapper/%c&#39;&quot;<br></div><di=
v style=3D"font-family:arial,sans-serif;font-size:12.666666984558105px"><p =
class=3D"MsoNormal"></p></div><div style=3D"font-family:arial,sans-serif;fo=
nt-size:12.666666984558105px">
The rule is getting called multiple times for the same device &amp; hence u=
devsettle keeps waiting for all these to finish<br></div><div style=3D"font=
-family:arial,sans-serif;font-size:12.666666984558105px"><br></div><div sty=
le=3D"font-family:arial,sans-serif;font-size:12.666666984558105px">
<p class=3D"MsoNormal">Mar 10 <span style=3D"background-color:yellow">13:47=
:00</span>
x336-207-55 udevd-event[8013]: run_program: &#39;/bin/bash -c &#39;/sbin/mp=
ath_wait
/dev/mapper/360a98000316b61396a2b3946424b6f2d; /sbin/kpartx -a -p p
/dev/mapper/360a98000316b61396a2b3946424b6f2d&#39;</p>

<p class=3D"MsoNormal">Mar 10 <span style=3D"background-color:yellow">13:47=
:04</span>
x336-207-55 udevd-event[8033]: run_program: &#39;/bin/bash -c &#39;/sbin/mp=
ath_wait
/dev/mapper/360a98000316b61396a2b3946424b6f2d; /sbin/kpartx -a -p p
/dev/mapper/360a98000316b61396a2b3946424b6f2d&#39;</p>

<p class=3D"MsoNormal">Mar 10 <span style=3D"background-color:yellow">13:47=
:04</span>
x336-207-55 udevd-event[8107]: run_program: &#39;/bin/bash -c &#39;/sbin/mp=
ath_wait
/dev/mapper/360a98000316b61396a2b3946424b6f2d; /sbin/kpartx -a -p p
/dev/mapper/360a98000316b61396a2b3946424b6f2d&#39;</p>

<p class=3D"MsoNormal">Mar 10 <span style=3D"background-color:yellow">13:47=
:10</span>
x336-207-55 udevd-event[8212]: run_program: &#39;/bin/bash -c &#39;/sbin/mp=
ath_wait
/dev/mapper/360a98000316b61396a2b3946424b6f2d; /sbin/kpartx -a -p p
/dev/mapper/360a98000316b61396a2b3946424b6f2d&#39;</p></div><div style=3D"f=
ont-family:arial,sans-serif;font-size:12.666666984558105px"><br></div><div =
style=3D"font-family:arial,sans-serif;font-size:12.666666984558105px"><br>
</div><div style=3D"font-family:arial,sans-serif;font-size:12.6666669845581=
05px">Hence, I commented out the line from &quot;multipath.rules&quot; &amp=
; it started working fine:</div><div>=A0 =A0=A0<span style=3D"font-family:a=
rial,sans-serif;font-size:12.666666984558105px">RUN+=3D&quot;/bin/bash -c &=
#39;/sbin/mpath_wait /dev/mapper/%c; /sbin/kpartx -a -p p /dev/mapper/%c&#3=
9;&quot;</span></div>
<div style=3D"font-family:arial,sans-serif;font-size:12.666666984558105px">=
<br></div><div style=3D"font-family:arial,sans-serif;font-size:12.666666984=
558105px">Couple of queries:</div><div style=3D"font-family:arial,sans-seri=
f;font-size:12.666666984558105px">
<br></div><div style=3D"font-family:arial,sans-serif;font-size:12.666666984=
558105px">1. Please let me know if there are any side effects for commentin=
g out the above mentioned line.</div><div style=3D"font-family:arial,sans-s=
erif;font-size:12.666666984558105px">
=A0 =A0 Ben mentions that block device addition is now taken care of by NET=
LINK events as long as multipath is running &amp; no need for udev to fire =
off multipath:=A0<a href=3D"https://bugzilla.redhat.com/show_bug.cgi?id=3D4=
60301">https://bugzilla.redhat.com/show_bug.cgi?id=3D460301</a></div>
<div style=3D"font-family:arial,sans-serif;font-size:12.666666984558105px">=
<pre class=3D"" style=3D"font-size:small;white-space:pre-wrap;word-wrap:bre=
ak-word;width:50em;color:rgb(0,0,0)"><span style=3D"color:rgb(34,34,34);fon=
t-family:arial,sans-serif;font-size:12.666666984558105px">2. Please let me =
know if this is a known issue. I observe it only in RHEL 5.9 and 5.10 setup=
s.</span></pre>
<pre class=3D"" style=3D"font-size:small;white-space:pre-wrap;word-wrap:bre=
ak-word;width:50em;color:rgb(0,0,0)"><span style=3D"color:rgb(34,34,34);fon=
t-family:arial,sans-serif;font-size:12.666666984558105px"><br></span></pre>=
<pre class=3D"" style=3D"font-size:small;white-space:pre-wrap;word-wrap:bre=
ak-word;width:50em;color:rgb(0,0,0)">
<span style=3D"color:rgb(34,34,34);font-family:arial,sans-serif;font-size:1=
2.666666984558105px">Any pointers is highly appreciated.</span><br></pre></=
div><div style=3D"font-family:arial,sans-serif;font-size:12.666666984558105=
px">
<font color=3D"#222222" face=3D"arial, sans-serif"><br></font></div><div st=
yle=3D"font-family:arial,sans-serif;font-size:12.666666984558105px"><font c=
olor=3D"#222222" face=3D"arial, sans-serif">Setup:</font></div><div style=
=3D"font-family:arial,sans-serif;font-size:12.666666984558105px">
<font color=3D"#222222" face=3D"arial, sans-serif">=3D=3D=3D=3D=3D=3D</font=
></div><div><font color=3D"#222222" face=3D"arial, sans-serif"><div><span s=
tyle=3D"font-size:12.666666984558105px">Red Hat Enterprise Linux Server rel=
ease 5.10 (Tikanga)</span></div>
<div><span style=3D"font-size:12.666666984558105px">Kernel \r on an \m</spa=
n></div><div style=3D"font-family:arial,sans-serif;font-size:12.66666698455=
8105px"><br></div><div style=3D"font-family:arial,sans-serif;font-size:12.6=
66666984558105px">
Multipath.conf:</div><div style=3D"font-family:arial,sans-serif;font-size:1=
2.666666984558105px">=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D</div><div><div><span=
 style=3D"font-size:12.666666984558105px">defaults {</span></div><div><span=
 style=3D"font-size:12.666666984558105px">=A0 =A0 =A0 =A0 user_friendly_nam=
es =A0 =A0 =A0 =A0 =A0 =A0 no</span></div>
<div><span style=3D"font-size:12.666666984558105px">=A0 =A0 =A0 =A0 queue_w=
ithout_daemon =A0 =A0 =A0 =A0 =A0 =A0no</span></div><div><span style=3D"fon=
t-size:12.666666984558105px">=A0 =A0 =A0 =A0 flush_on_last_del =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 yes</span></div><div><span style=3D"font-size:12.6666669845=
58105px">=A0 =A0 =A0 =A0 max_fds =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 max</span></div>
<div><span style=3D"font-size:12.666666984558105px">=A0 =A0 =A0 =A0 pg_prio=
_calc =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0avg</span></div><div><span sty=
le=3D"font-size:12.666666984558105px">}</span></div><div><span style=3D"fon=
t-size:12.666666984558105px">blacklist {</span></div>
<div><span style=3D"font-size:12.666666984558105px">=A0 =A0 =A0 =A0 wwid =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0SIBM-ESXSMAW3073NC_F=
DAR9P6402NE0</span></div><div><span style=3D"font-size:12.666666984558105px=
">=A0 =A0 =A0 =A0 wwid =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0SIBM-ESXSMAW3073NC_FDAR9P6402PP2</span></div>
<div><span style=3D"font-size:12.666666984558105px">=A0 =A0 =A0 =A0 devnode=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &quot;^cciss.*&quot;</span=
></div><div><span style=3D"font-size:12.666666984558105px">}</span></div><d=
iv><span style=3D"font-size:12.666666984558105px">devices {</span></div>
<div><span style=3D"font-size:12.666666984558105px">=A0 =A0 =A0 =A0 device =
{</span></div><div><span style=3D"font-size:12.666666984558105px">=A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 vendor =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&quot=
;NETAPP&quot;</span></div><div><span style=3D"font-size:12.666666984558105p=
x">=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 product =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 &quot;LUN&quot;</span></div>
<div><span style=3D"font-size:12.666666984558105px">=A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 features =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&quot;3 queue_if_no_pa=
th pg_init_retries 50&quot;</span></div><div><span style=3D"font-size:12.66=
6666984558105px">=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 path_grouping_policy =A0 =
=A0group_by_prio</span></div>
<div><span style=3D"font-size:12.666666984558105px">=A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 prio_callout =A0 =A0 =A0 =A0 =A0 =A0 &quot;/sbin/mpath_prio_alua /=
dev/%n&quot;</span></div><div><span style=3D"font-size:12.666666984558105px=
">=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 path_checker =A0 =A0 =A0 =A0 =A0 =A0tur</=
span></div>
<div><span style=3D"font-size:12.666666984558105px">=A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 failback =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0immediate</spa=
n></div><div><span style=3D"font-size:12.666666984558105px">=A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 hardware_handler =A0 =A0 &quot;1 alua&quot;</span></div>
<div><span style=3D"font-size:12.666666984558105px">=A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 rr_weight =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0uniform</span></d=
iv><div><span style=3D"font-size:12.666666984558105px">=A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 rr_min_io =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0128</span></di=
v>
<div><span style=3D"font-size:12.666666984558105px">=A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 getuid_callout =A0 =A0 =A0 =A0 =A0&quot;/sbin/scsi_id -g -u -s /bl=
ock/%n&quot;</span></div><div><span style=3D"font-size:12.666666984558105px=
">=A0 =A0 =A0 =A0}</span></div><div>
<span style=3D"font-size:12.666666984558105px">}</span></div><div style=3D"=
font-family:arial,sans-serif;font-size:12.666666984558105px"><br></div></di=
v></font></div><div style=3D"font-family:arial,sans-serif;font-size:12.6666=
66984558105px">
regards,</div><div style=3D"font-family:arial,sans-serif;font-size:12.66666=
6984558105px"><font color=3D"#222222" face=3D"arial, sans-serif"><span clas=
s=3D"" style=3D"background-color:rgb(255,255,204)">Adarsh</span>.</font></d=
iv></div>

--001a11c2a20ca9c79a04f45d0beb--


--===============2152191089073677925==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2152191089073677925==--
