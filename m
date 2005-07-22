From: michael.n.murray@census.gov
Subject: Multipath Config Question
Date: Fri, 22 Jul 2005 13:54:57 -0400
Message-ID: <OF3BA6523C.F10DBB18-ON85257046.00626A41-85257046.00626A4F@census.gov>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2010881917=="
Return-path: <dm-devel-bounces@redhat.com>
MIME-Version: 1.0
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

--===============2010881917==
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=ISO-8859-1

<font face=3D"monospace" size=3D"3">Hi,<br>
&nbsp;&nbsp;&nbsp; Sorry if this is the wrong place to request
this.&nbsp; I'm new to this and trying to setup multipathing with the
following config:<br>
<br>
</font><font face=3D"monospace" size=3D"3">SW:<br>&nbsp;Suse SLES 9<br>&nbs=
p;SP2<br>
<br>
</font><font face=3D"monospace" size=3D"3">HW:<br>&nbsp;3Par SAN<br>&nbsp;2=
 Qlogic HBAs QLA2310s (fiber)<br>&nbsp;drivers: qla2300/qla2xxx<br><br>
</font><font face=3D"monospace" size=3D"3">I can mount the SAN device just =
fine:<br>&nbsp;#mount /dev/disk/by-name/350002ac000070240 /test<br><br>I ve=
rified both HBAs work by disconnecting the fiber to each one and testing th=
at I could mount/write/read (requires reboots).<br>
</font><font face=3D"monospace" size=3D"3"><br>
 I believe however that multipath -ll should be seeing the second HBA, corr=
ect?&nbsp; Currently all I get is:<br>&nbsp;# multipath -ll<br>&nbsp;350002=
ac000070240<br>&nbsp;[size=3D100 GB][features=3D0][hwhandler=3D0]<br>&nbsp;=
\=5Fround-robin 0 [active][best]<br>&nbsp; \=5F 2:0:0:0 sdg 8:96 [ready][ac=
tive]<br><br>...when I expected something like:<br>
</font><font face=3D"monospace" size=3D"3"># multipath -ll</font><font face=
=3D"monospace" size=3D"3"><br>
350002ac000070240</font><span style=3D"font-family: monospace;"> <br>
[</span>size=3D100 GB][features=3D"0"][hwhandler=3D"0"]<span style=3D"font-=
family: monospace;"><br>
</span>\=5F round-robin 0 [active][first]<span style=3D"font-family: monosp=
ace;"><br>
&nbsp;</span>\=5F 1:0:1:2 sdav 66:240  [ready ][active]<span style=3D"font-=
family: monospace;"><br>
</span>&nbsp; \=5F 0:0:1:2 sdr  65:16   [ready ][active]<span style=3D"font=
-family: monospace;"><br>
</span>\=5F round-robin 0 [enabled]<span style=3D"font-family: monospace;">=
<br>
&nbsp; </span>\=5F 1:0:0:2 sdag 66:0    [ready ][active]<br>


&nbsp; &nbsp; \=5F 0:0:0:2 sdc  8:32    [ready ][active]<br>


<font face=3D"monospace" size=3D"3"><br>
Not sure what to do, like modify multipath.conf?<br>
<br>
Suggestions/FAQs/How-Tos (I've read most of what I could Google).<br>
<br>
Thanks,<br>
Mike M.</font>=


--===============2010881917==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2010881917==--
