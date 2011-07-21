From: "Stamper, Brian P. (ARC-D)[Stinger Ghaffarian Technologies Inc. (SGT
	Inc.)]" <brian.p.stamper@nasa.gov>
Subject: Re: Blacklist broken?
Date: Thu, 21 Jul 2011 12:17:11 -0500
Message-ID: <CA4DAD27.14027%brian.p.stamper@nasa.gov>
References: <CA44D1AE.13C70%brian.p.stamper@nasa.gov>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5528535033197449312=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CA44D1AE.13C70%brian.p.stamper@nasa.gov>
Content-Language: en
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

--===============5528535033197449312==
Content-Language: en
Content-Type: multipart/alternative;
	boundary="_000_CA4DAD2714027brianpstampernasagov_"

--_000_CA4DAD2714027brianpstampernasagov_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


I've received 0 responses since sending this.  So either people don't have =
a clue where to start to fix it, or they don't consider it their problem.  =
Some kind of response would be nice.  Bottom line is that being able to com=
pile dm-multipath into initrd but without any way to enforce a blacklist is=
 somewhat broken.  Since the majority of people do not boot from a multipat=
h device, it would seem that the default option should be to not install dm=
-multipath into the initrd if the possibility exists of it grabbing a non-m=
ultipath boot disk and locking it up during pre-boot.

-brian


On 7/14/11 5:02 PM, "Brian Stamper" <brian.p.stamper@nasa.gov> wrote:


Ok, so I've isolated this.  It appears that dracut is loading dm_multipath =
into initram and has no blacklist configuration.  At some point initram sho=
uld release disks, but it doesn't.  At least not in time for the system to =
attempt its routine fsck on /boot.  I didn't have this problem on a very si=
milar machine that I upgraded last week that also runs multipath.  The one =
difference that comes to mind is that the most recent host was build on FC1=
1 or even potentially FC9 and has been upgraded multiple times.  The host t=
hat went smoothly was built on FC13 a couple months ago and upgraded only o=
nce.

This is a fairly serious problem, and if I hadn't had so many issues with d=
racut in the last year I would have never solved it myself.  I'm not sure i=
f the responsibility lies with the dracut team or with the dm-multipath tea=
m, but it should probably be fixed.  I was able to recompile the initrd wit=
h dracut -o dm_multipath and now my system boots cleanly.  But I don't real=
ly consider this a "fix" and I don't want to have to recompile my initrd ev=
erytime I get a kernel update across multiple systems.

-brian

On 7/14/11 4:06 PM, "Brian Stamper" <brian.p.stamper@nasa.gov> wrote:

I just upgrade an FC13 system to FC15, and now multipath is grabbing the sy=
stem drive before the normal fsck can run, which is causing the machine to =
not boot.  I get the message: "Filesystem mounted or opened exclusively by =
another program? "  Now, I can simply control-d to continue, but why is mul=
tipath grabbing the drive?  I've blacklisted it every way I can, using devn=
ode, using wwid, it simply ignores it and continues to create a path map fo=
r /dev/sda.

device-mapper-1.02.63-3.fc15.x86_64
device-mapper-multipath-0.4.9-15.fc15.x86_64
device-mapper-libs-1.02.63-3.fc15.x86_64

2.6.38.8-35.fc15.x86_64

mpath0 (36001ec90ee4ee600105ac65e04e84e61) dm-0 DELL,PERC 6/i
size=3D279G features=3D'0' hwhandler=3D'0' wp=3Drw
`-+- policy=3D'round-robin 0' prio=3D1 status=3Dactive
  `- 2:2:0:0  sda 8:0   active ready running

[root@bonjovi ~]# blkid | grep boot
/dev/sda1: LABEL=3D"/boot" UUID=3D"8ed92bb6-0ddb-4fbc-907d-fdf12e5550a3" TY=
PE=3D"ext3" SEC_TYPE=3D"ext2"
/dev/mapper/mpath0p1: LABEL=3D"/boot" UUID=3D"8ed92bb6-0ddb-4fbc-907d-fdf12=
e5550a3" TYPE=3D"ext3"

From multipath.conf:

blacklist {
        wwid 36001ec90ee4ee600105ac65e04e84e61
        devnode "/dev/sda"
        devnode "/dev/sda1"
}
devnode_blacklist {
        wwid 36001ec90ee4ee600105ac65e04e84e61
        devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
        devnode "^hd[a-z]"
        devnode "^cciss!c[0-9]d[0-9]*"
        devnode "sda"
        devnode "/dev/sda"
}

I've even tried blacklisting by /disk/by/uuid.  What does it take to get mu=
ltipath to quit grabbing this disk?

-brian


--_000_CA4DAD2714027brianpstampernasagov_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<HTML>
<HEAD>
<TITLE>Re: [dm-devel] Blacklist broken?</TITLE>
</HEAD>
<BODY>
<FONT FACE=3D"Calibri, Verdana, Helvetica, Arial"><SPAN STYLE=3D'font-size:=
11pt'><BR>
I&#8217;ve received 0 responses since sending this. &nbsp;So either people =
don&#8217;t have a clue where to start to fix it, or they don&#8217;t consi=
der it their problem. &nbsp;Some kind of response would be nice. &nbsp;Bott=
om line is that being able to compile dm-multipath into initrd but without =
any way to enforce a blacklist is somewhat broken. &nbsp;Since the majority=
 of people do not boot from a multipath device, it would seem that the defa=
ult option should be to not install dm-multipath into the initrd if the pos=
sibility exists of it grabbing a non-multipath boot disk and locking it up =
during pre-boot.<BR>
<BR>
-brian<BR>
<BR>
<BR>
On 7/14/11 5:02 PM, &quot;Brian Stamper&quot; &lt;<a href=3D"brian.p.stampe=
r@nasa.gov">brian.p.stamper@nasa.gov</a>&gt; wrote:<BR>
<BR>
</SPAN></FONT><BLOCKQUOTE><FONT FACE=3D"Calibri, Verdana, Helvetica, Arial"=
><SPAN STYLE=3D'font-size:11pt'><BR>
Ok, so I&#8217;ve isolated this. &nbsp;It appears that dracut is loading dm=
_multipath into initram and has no blacklist configuration. &nbsp;At some p=
oint initram should release disks, but it doesn&#8217;t. &nbsp;At least not=
 in time for the system to attempt its routine fsck on /boot. &nbsp;I didn&=
#8217;t have this problem on a very similar machine that I upgraded last we=
ek that also runs multipath. &nbsp;The one difference that comes to mind is=
 that the most recent host was build on FC11 or even potentially FC9 and ha=
s been upgraded multiple times. &nbsp;The host that went smoothly was built=
 on FC13 a couple months ago and upgraded only once.<BR>
<BR>
This is a fairly serious problem, and if I hadn&#8217;t had so many issues =
with dracut in the last year I would have never solved it myself. &nbsp;I&#=
8217;m not sure if the responsibility lies with the dracut team or with the=
 dm-multipath team, but it should probably be fixed. &nbsp;I was able to re=
compile the initrd with dracut &#8211;o dm_multipath and now my system boot=
s cleanly. &nbsp;But I don&#8217;t really consider this a &#8220;fix&#8221;=
 and I don&#8217;t want to have to recompile my initrd everytime I get a ke=
rnel update across multiple systems.<BR>
<BR>
-brian<BR>
<BR>
On 7/14/11 4:06 PM, &quot;Brian Stamper&quot; &lt;<a href=3D"brian.p.stampe=
r@nasa.gov">brian.p.stamper@nasa.gov</a>&gt; wrote:<BR>
<BR>
</SPAN></FONT><BLOCKQUOTE><FONT FACE=3D"Calibri, Verdana, Helvetica, Arial"=
><SPAN STYLE=3D'font-size:11pt'>I just upgrade an FC13 system to FC15, and =
now multipath is grabbing the system drive before the normal fsck can run, =
which is causing the machine to not boot. &nbsp;I get the message: &#8220;F=
ilesystem mounted or opened exclusively by another program? &#8220; &nbsp;N=
ow, I can simply control-d to continue, but why is multipath grabbing the d=
rive? &nbsp;I&#8217;ve blacklisted it every way I can, using devnode, using=
 wwid, it simply ignores it and continues to create a path map for /dev/sda=
.<BR>
<BR>
device-mapper-1.02.63-3.fc15.x86_64<BR>
device-mapper-multipath-0.4.9-15.fc15.x86_64<BR>
device-mapper-libs-1.02.63-3.fc15.x86_64<BR>
<BR>
2.6.38.8-35.fc15.x86_64<BR>
<BR>
mpath0 (36001ec90ee4ee600105ac65e04e84e61) dm-0 DELL,PERC 6/i<BR>
size=3D279G features=3D'0' hwhandler=3D'0' wp=3Drw<BR>
`-+- policy=3D'round-robin 0' prio=3D1 status=3Dactive<BR>
&nbsp;&nbsp;`- 2:2:0:0 &nbsp;sda 8:0 &nbsp;&nbsp;active ready running<BR>
<BR>
[root@bonjovi ~]# blkid | grep boot<BR>
/dev/sda1: LABEL=3D&quot;/boot&quot; UUID=3D&quot;8ed92bb6-0ddb-4fbc-907d-f=
df12e5550a3&quot; TYPE=3D&quot;ext3&quot; SEC_TYPE=3D&quot;ext2&quot; <BR>
/dev/mapper/mpath0p1: LABEL=3D&quot;/boot&quot; UUID=3D&quot;8ed92bb6-0ddb-=
4fbc-907d-fdf12e5550a3&quot; TYPE=3D&quot;ext3&quot; <BR>
<BR>
&gt;From multipath.conf:<BR>
<BR>
blacklist {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;wwid 36001ec90ee4ee600105ac=
65e04e84e61<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;devnode &quot;/dev/sda&quot=
;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;devnode &quot;/dev/sda1&quo=
t;<BR>
}<BR>
devnode_blacklist {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;wwid 36001ec90ee4ee600105ac=
65e04e84e61<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;devnode &quot;^(ram|raw|loo=
p|fd|md|dm-|sr|scd|st)[0-9]*&quot;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;devnode &quot;^hd[a-z]&quot=
;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;devnode &quot;^cciss!c[0-9]=
d[0-9]*&quot;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;devnode &#8220;sda&#8221;<B=
R>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;devnode &#8220;/dev/sda&#82=
21;<BR>
}<BR>
<BR>
I&#8217;ve even tried blacklisting by /disk/by/uuid. &nbsp;What does it tak=
e to get multipath to quit grabbing this disk?<BR>
<BR>
-brian<BR>
</SPAN></FONT></BLOCKQUOTE><FONT FACE=3D"Calibri, Verdana, Helvetica, Arial=
"><SPAN STYLE=3D'font-size:11pt'><BR>
</SPAN></FONT></BLOCKQUOTE>
</BODY>
</HTML>


--_000_CA4DAD2714027brianpstampernasagov_--


--===============5528535033197449312==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5528535033197449312==--
