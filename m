From: siva ram <srr.kernel@gmail.com>
Subject: multipath user tools help
Date: Thu, 5 Jan 2006 14:32:38 +0530
Message-ID: <a70fc890601050102h134316aj1e3b45a0ea4a22c6@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2068512319=="
Return-path: <dm-devel-bounces@redhat.com>
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

--===============2068512319==
Content-Type: multipart/alternative;
	boundary="----=_Part_36155_1862610.1136451758152"

------=_Part_36155_1862610.1136451758152
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

hi everyone

i have some primary doughts on multipath, i installed every thing like user
tools and kernel module.

but in my case disk subsystem in other country, they told  2 paths for disk
subsystem.

but if i use multipath user command like *multipath -l* itis showing only
one path and if i say *multipath -v 1*( it has to print devmap names), but
is is giving error like error adding target table.

can any one know the details please help me.


*multipath -v 1*
device-mapper: dm-multipath: error getting device
device-mapper: error adding target to table
device-mapper: dm-multipath: error getting device
device-mapper: error adding target to table
device-mapper: dm-multipath: error getting device
device-mapper: error adding target to table
_______________________________________________
 *multipath -l*
SUNISYS__018404ST318404L3BT1AVVX000021460S66
[size=3D17 GB][features=3D"0"][hwhandler=3D"0"]
\_ round-robin 0 [active]
 \_ 0:0:1:0 sdb 8:16 [active][ready]

SSEAGATE_ST318305LC_____3JKP1HJQ000022144RSP
[size=3D16 GB][features=3D"0"][hwhandler=3D"0"]
\_ round-robin 0 [active]
 \_ 1:0:2:0 sde 8:64 [active][ready]

_________________________________________

* *

------=_Part_36155_1862610.1136451758152
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

<div>hi everyone</div>
<div>&nbsp;</div>
<div>i have some primary doughts on multipath, i installed every thing like=
 user tools and kernel module.</div>
<div>&nbsp;</div>
<div>but in my case disk subsystem in other country, they told&nbsp; 2 path=
s&nbsp;for disk subsystem. </div>
<div>&nbsp;</div>
<div>but if i use multipath user command like <strong>multipath -l</strong>=
 itis showing only one path and if i say <strong>multipath -v 1</strong>( i=
t has to print devmap names), but is is giving error like error adding targ=
et table.
</div>
<div>&nbsp;</div>
<div>can any one know the details please help me.</div>
<div>&nbsp;</div>
<div>&nbsp;</div>
<div><strong>multipath -v 1</strong></div>
<div>device-mapper: dm-multipath: error getting device<br>device-mapper: er=
ror adding target to table<br>device-mapper: dm-multipath: error getting de=
vice<br>device-mapper: error adding target to table<br>device-mapper: dm-mu=
ltipath: error getting device
<br>device-mapper: error adding target to table<br>________________________=
_______________________</div>
<div>&nbsp;<strong>multipath -l</strong><br>SUNISYS__018404ST318404L3BT1AVV=
X000021460S66<br>[size=3D17 GB][features=3D&quot;0&quot;][hwhandler=3D&quot=
;0&quot;]<br>\_ round-robin 0 [active]<br>&nbsp;\_ 0:0:1:0 sdb 8:16 [active=
][ready]</div>

<div>
<p>SSEAGATE_ST318305LC_____3JKP1HJQ000022144RSP<br>[size=3D16 GB][features=
=3D&quot;0&quot;][hwhandler=3D&quot;0&quot;]<br>\_ round-robin 0 [active]<b=
r>&nbsp;\_ 1:0:2:0 sde 8:64 [active][ready]</p>
<p>_________________________________________</p>
<p><strong>&nbsp;</strong></p></div>

------=_Part_36155_1862610.1136451758152--


--===============2068512319==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2068512319==--
