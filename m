From: "Stamper, Brian P. (ARC-D)[Stinger Ghaffarian Technologies Inc. (SGT
	Inc.)]" <brian.p.stamper@nasa.gov>
Subject: Blacklist broken?
Date: Thu, 14 Jul 2011 18:06:31 -0500
Message-ID: <CA44C487.13C5F%brian.p.stamper@nasa.gov>
References: <1310678133.2246.25.camel@f14.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0575757734835819562=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1310678133.2246.25.camel@f14.redhat.com>
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

--===============0575757734835819562==
Content-Language: en
Content-Type: multipart/alternative;
	boundary="_000_CA44C48713C5Fbrianpstampernasagov_"

--_000_CA44C48713C5Fbrianpstampernasagov_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

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

--_000_CA44C48713C5Fbrianpstampernasagov_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<HTML>
<HEAD>
<TITLE>Blacklist broken?</TITLE>
</HEAD>
<BODY>
<FONT FACE=3D"Calibri, Verdana, Helvetica, Arial"><SPAN STYLE=3D'font-size:=
11pt'>I just upgrade an FC13 system to FC15, and now multipath is grabbing =
the system drive before the normal fsck can run, which is causing the machi=
ne to not boot. &nbsp;I get the message: &#8220;Filesystem mounted or opene=
d exclusively by another program? &#8220; &nbsp;Now, I can simply control-d=
 to continue, but why is multipath grabbing the drive? &nbsp;I&#8217;ve bla=
cklisted it every way I can, using devnode, using wwid, it simply ignores i=
t and continues to create a path map for /dev/sda.<BR>
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
From multipath.conf:<BR>
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
-brian</SPAN></FONT>
</BODY>
</HTML>


--_000_CA44C48713C5Fbrianpstampernasagov_--


--===============0575757734835819562==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0575757734835819562==--
