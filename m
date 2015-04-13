From: Thomas Wouters <thomas@kangaroot.net>
Subject: ALUA - rescan device capacity on zero sized block devices
Date: Mon, 13 Apr 2015 17:32:25 +0200 (CEST)
Message-ID: <1887682221.152035.1428939145196.JavaMail.zimbra@kangaroot.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5355798768951305989=="
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

--===============5355798768951305989==
Content-Type: multipart/alternative;
	boundary="----=_Part_152034_1201946263.1428939145195"

------=_Part_152034_1201946263.1428939145195
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hi, 

We're performing some tests with open-iscsi and multipath on two 3par servers and their peer persistence feature. 
3par is a commercial storage solution that uses ALUA to allow failover. 
We have two connections from each 3par server to a linux server. 

Every 3par server has two network controllers, so on our linux server we initiate 4 iscsi connections. 
Multipath detects that two of these connections are active paths (both to the same 3par device, that is active at that point) and two are ghost paths, to the passive 3par device. 

At this moment we have four block devices, the active paths show the actual device size and the standby paths show the devices as zero sized: 

# multipath -ll 
360002ac000000000000000420001510c dm-3 3PARdata,VV 
size=100G features='1 queue_if_no_path' hwhandler='1 alua' wp=rw 
|-+- policy='round-robin 0' prio=130 status=active 
| |- 48:0:0:123 sdc 8:32 active ready running 
| `- 50:0:0:123 sdb 8:16 active ready running 
`-+- policy='round-robin 0' prio=1 status=enabled 
|- 49:0:0:123 sdd 8:48 active ghost running 
`- 51:0:0:123 sde 8:64 active ghost running 

# cat /sys/block/sdb/size 
209715200 
# cat /sys/block/sdc/size 
209715200 
# cat /sys/block/sdd/size 
0 
# cat /sys/block/sde/size 
0 

As soon as we perform a switchover on the 3par systems, multipath detects the priority changes and switches paths but the new active paths fail. 
We believe this is because 3par doesn't allow us to read the capacity of the disk on a standby path - and we have proof of this in the logs: 

Apr 13 15:05:12 deb-3par-test kernel: [ 40.079736] sd 5:0:0:0: [sdc] READ CAPACITY failed 

Unfortunately, once we perform the switchover on 3par, the capacity of those old ghost paths, now active paths, is not re-read. The multipath device is therefore reduced to a size of 0 and the filesystem becomes unavailable. 

If we only login on the two active paths without starting multipath, perform a switchover, then login on the two new active paths and start multipath, we have four block devices with a non-zero size and we can perform switchovers at will without any issues. 

We've found some older discussions describing these issues on the scsi target-devel and dm-devel mailinglists: 
- http://permalink.gmane.org/gmane.linux.scsi.target.devel/6531 
- https://www.redhat.com/archives/dm-devel/2014-July/msg00156.html 

As far as we can conclude after reading these messages, it is correct behavior for disallowing READ CAPACITY on ghost paths. However, once the path becomes active, we do need a reread of the capacity in order for the path to be functional... 

We've created a workaround for our issue but we're not sure we're going in the right direction. 

diff --git a/multipathd/main.c b/multipathd/main.c 
index f876258..ff32681 100644 
--- a/multipathd/main.c 
+++ b/multipathd/main.c 
@@ -1235,6 +1235,11 @@ check_path (struct vectors * vecs, struct path * pp) 

pp->chkrstate = newstate; 
if (newstate != pp->state) { 
+ 
+ if (newstate == PATH_UP && pp->size != pp->mpp->size ) { 
+ sysfs_attr_set_value(pp->udev, "device/rescan", "1\n",2); 
+ } 
+ 
int oldstate = pp->state; 
pp->state = newstate; 


------=_Part_152034_1201946263.1428939145195
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: quoted-printable

<html><body><div style=3D"font-family: arial, helvetica, sans-serif; font-s=
ize: 12pt; color: #000000"><div data-marker=3D"__QUOTED_TEXT__">Hi,<br><br>=
We're performing some tests with open-iscsi and multipath on two 3par serve=
rs and their peer persistence feature.<br>3par is a commercial storage solu=
tion that uses ALUA to allow failover.<br>We have two connections from each=
 3par server to a linux server.<br><br>Every 3par server has two network co=
ntrollers, so on our linux server we initiate 4 iscsi connections.<br>Multi=
path detects that two of these connections are active paths (both to the sa=
me 3par device, that is active at that point) and two are ghost paths, to t=
he passive 3par device.<br><br>At this moment we have four block devices, t=
he active paths show the actual device size and the standby paths show the =
devices as zero sized:<br><br># multipath -ll<br>360002ac000000000000000420=
001510c dm-3 3PARdata,VV<br>size=3D100G features=3D'1 queue_if_no_path' hwh=
andler=3D'1 alua' wp=3Drw<br>|-+- policy=3D'round-robin 0' prio=3D130 statu=
s=3Dactive<br>| |- 48:0:0:123 sdc 8:32 active ready running<br>| `- 50:0:0:=
123 sdb 8:16 active ready running<br>`-+- policy=3D'round-robin 0' prio=3D1=
 status=3Denabled<br>&nbsp;&nbsp;|- 49:0:0:123 sdd 8:48 active ghost runnin=
g<br>&nbsp;&nbsp;`- 51:0:0:123 sde 8:64 active ghost running<br><br># cat /=
sys/block/sdb/size <br>209715200<br># cat /sys/block/sdc/size <br>209715200=
<br># cat /sys/block/sdd/size <br>0<br># cat /sys/block/sde/size <br>0<br><=
br>As soon as we perform a switchover on the 3par systems, multipath detect=
s the priority changes and switches paths but the new active paths fail.<br=
>We believe this is because 3par doesn't allow us to read the capacity of t=
he disk on a standby path - and we have proof of this in the logs:<br><br>A=
pr 13 15:05:12 deb-3par-test kernel: [ &nbsp; 40.079736] sd 5:0:0:0: [sdc] =
READ CAPACITY failed<br><br>Unfortunately, once we perform the switchover o=
n 3par, the capacity of those old ghost paths, now active paths, is not re-=
read. &nbsp;The multipath device is therefore reduced to a size of 0 and th=
e filesystem becomes unavailable.<br><br>If we only login on the two active=
 paths without starting multipath, perform a switchover, then login on the =
two new active paths and start multipath, we have four block devices with a=
 non-zero size and we can perform switchovers at will without any issues.<b=
r><br>We've found some older discussions describing these issues on the scs=
i target-devel and dm-devel mailinglists:<br>- http://permalink.gmane.org/g=
mane.linux.scsi.target.devel/6531<br>- https://www.redhat.com/archives/dm-d=
evel/2014-July/msg00156.html<br><br>As far as we can conclude after reading=
 these messages, it is correct behavior for disallowing READ CAPACITY on gh=
ost paths. &nbsp;However, once the path becomes active, we do need a reread=
 of the capacity in order for the path to be functional...<br></div><div da=
ta-marker=3D"__QUOTED_TEXT__"><br data-mce-bogus=3D"1"></div><div data-mark=
er=3D"__QUOTED_TEXT__">We've created a workaround for our issue but we're n=
ot sure we're going in the right direction.</div><div data-marker=3D"__QUOT=
ED_TEXT__"><br data-mce-bogus=3D"1"></div><div data-marker=3D"__QUOTED_TEXT=
__">diff --git a/multipathd/main.c b/multipathd/main.c<br>index f876258..ff=
32681 100644<br>--- a/multipathd/main.c<br>+++ b/multipathd/main.c<br>@@ -1=
235,6 +1235,11 @@ check_path (struct vectors * vecs, struct path * pp)<br> =
<br> pp-&gt;chkrstate =3D newstate;<br> if (newstate !=3D pp-&gt;state) {<b=
r>+<br>+ if (newstate =3D=3D PATH_UP &amp;&amp; pp-&gt;size !=3D pp-&gt;mpp=
-&gt;size ) {<br>+ sysfs_attr_set_value(pp-&gt;udev, "device/rescan", "1\n"=
,2);<br>+ }<br>+<br> int oldstate =3D pp-&gt;state;<br> pp-&gt;state =3D ne=
wstate;<br> <br></div></div></body></html>
------=_Part_152034_1201946263.1428939145195--


--===============5355798768951305989==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5355798768951305989==--
