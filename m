From: Devin <delldudedevin@gmail.com>
Subject: Multipath not balancing I/O across paths evenly.
Date: Wed, 10 Jul 2013 13:52:27 -0700
Message-ID: <CAEctU6q8AjjZpGMoK5Goe5YQK9L9gqpcGc5+kRUqaQ3gXtry0Q@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1926560636345889027=="
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============1926560636345889027==
Content-Type: multipart/alternative; boundary=089e0116014e96c4c004e12e74f6

--089e0116014e96c4c004e12e74f6
Content-Type: text/plain; charset=ISO-8859-1

We started to notice that on our iSCSI hosts that are using Multipath that
they seem to be sending most of the traffic across one port even though
they have 4 paths for each mpath device. We are using a Hitachi SAN.

Here is my multipath configuration:
defaults {
        user_friendly_names yes
}

devices {
        device {
                vendor                   "HITACHI"
                product                  "DF.*"
                path_grouping_policy  multibus
                path_checker              tur
                getuid_callout            "/sbin/scsi_id -g -u -s /block/%n"
                no_path_retry             1
                features                  "1 queue_if_no_path"
                }
}


The output of multipath looks like:

mpath2 (360060e80101af190058baee900000007) dm-6 HITACHI,DF600F
size=1.5T features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=0 status=active
  |- 8:0:0:1   sdg  8:96   active ready running
  |- 9:0:0:1   sdh  8:112  active ready running
  |- 7:0:0:1   sdf  8:80   active ready running
  `- 10:0:0:1  sdi  8:128  active ready running
mpath0 (360060e80101af190058baee900000005) dm-5 HITACHI,DF600F
size=1.0T features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=0 status=active
  |- 9:0:0:0   sdd  8:48   active ready running
  |- 8:0:0:0   sdc  8:32   active ready running
  |- 10:0:0:0  sde  8:64   active ready running
  `- 7:0:0:0   sdb  8:16   active ready running

However when I do a tcpdump and count the number of packets to each of the
IQN's they are not equal, not even close.


IQN1: 19,579

IQN2: 12,778

IQN3: 70,674

IQN4: 67


Is there anything I need to do in order to ensure that Multipath balances
more evenly across all the paths???

Any help would be appreciated.


Devin

--089e0116014e96c4c004e12e74f6
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div>We started to notice that on our iSCSI hosts that=
 are using Multipath that they seem to be sending most of the traffic acros=
s one port even though they have 4 paths for each mpath device. We are usin=
g a Hitachi SAN.</div>
<div><br></div><div>Here is my multipath configuration:</div><font face=3D"=
courier new, monospace">defaults {<br>=A0 =A0 =A0 =A0 user_friendly_names y=
es<br>}<br><br>devices {<br>=A0 =A0 =A0 =A0 device {<br>=A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 vendor =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &quot;HITACHI&quot;=
<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 product =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
&quot;DF.*&quot;<br>=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 path_grouping_policy =
=A0multibus<br>=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 path_checker =A0 =A0 =A0 =A0=
 =A0 =A0 =A0tur<br>=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 getuid_callout =A0 =A0 =
=A0 =A0 =A0 =A0&quot;/sbin/scsi_id -g -u -s /block/%n&quot;<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 no_path_retry =A0 =A0 =A0 =A0 =A0 =A0 1<br>=
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 features =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0&quot;1 queue_if_no_path&quot;<br>=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }<br>}=
</font><div><font face=3D"courier new, monospace"><br></font></div><div><fo=
nt face=3D"courier new, monospace"><br>
</font></div><div><font face=3D"courier new, monospace">The output of multi=
path looks like:</font></div><div><font face=3D"courier new, monospace"><br=
></font></div><div><font face=3D"courier new, monospace"><div>mpath2 (36006=
0e80101af190058baee900000007) dm-6 HITACHI,DF600F</div>
<div>size=3D1.5T features=3D&#39;1 queue_if_no_path&#39; hwhandler=3D&#39;0=
&#39; wp=3Drw</div><div>`-+- policy=3D&#39;round-robin 0&#39; prio=3D0 stat=
us=3Dactive</div><div>=A0 |- 8:0:0:1 =A0 sdg =A08:96 =A0 active ready runni=
ng</div><div>=A0 |- 9:0:0:1 =A0 sdh =A08:112 =A0active ready running</div>
<div>=A0 |- 7:0:0:1 =A0 sdf =A08:80 =A0 active ready running</div><div>=A0 =
`- 10:0:0:1 =A0sdi =A08:128 =A0active ready running</div><div>mpath0 (36006=
0e80101af190058baee900000005) dm-5 HITACHI,DF600F</div><div>size=3D1.0T fea=
tures=3D&#39;1 queue_if_no_path&#39; hwhandler=3D&#39;0&#39; wp=3Drw</div>
<div>`-+- policy=3D&#39;round-robin 0&#39; prio=3D0 status=3Dactive</div><d=
iv>=A0 |- 9:0:0:0 =A0 sdd =A08:48 =A0 active ready running</div><div>=A0 |-=
 8:0:0:0 =A0 sdc =A08:32 =A0 active ready running</div><div>=A0 |- 10:0:0:0=
 =A0sde =A08:64 =A0 active ready running</div>
<div>=A0 `- 7:0:0:0 =A0 sdb =A08:16 =A0 active ready running</div><div><br>=
</div><div>However when I do a tcpdump and count the number of packets to e=
ach of the IQN&#39;s they are not equal, not even close.</div><div>=A0 =A0 =
=A0 =A0 =A0=A0<br>
</div><div>
<p class=3D"">IQN1: 19,579</p>
<p class=3D"">IQN2: 12,778</p>
<p class=3D"">IQN3: 70,674</p>
<p class=3D"">IQN4: 67<br></p><p class=3D""><br></p><p class=3D"">Is there =
anything I need to do in order to ensure that Multipath balances more evenl=
y across all the paths???</p><p class=3D"">Any help would be appreciated.</=
p><p class=3D"">
<br></p><p class=3D"">Devin</p></div></font></div></div>

--089e0116014e96c4c004e12e74f6--


--===============1926560636345889027==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1926560636345889027==--
