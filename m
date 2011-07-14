From: "Stamper, Brian P. (ARC-D)[Stinger Ghaffarian Technologies Inc. (SGT
	Inc.)]" <brian.p.stamper@nasa.gov>
Subject: Re: Blacklist broken?
Date: Thu, 14 Jul 2011 18:37:57 -0500
Message-ID: <CA44CBE5.13C6A%brian.p.stamper@nasa.gov>
References: <CA44C487.13C5F%brian.p.stamper@nasa.gov>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7644162109922331288=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CA44C487.13C5F%brian.p.stamper@nasa.gov>
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

--===============7644162109922331288==
Content-Language: en
Content-Type: multipart/alternative;
	boundary="_000_CA44CBE513C6Abrianpstampernasagov_"

--_000_CA44CBE513C6Abrianpstampernasagov_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


Doing a bit more checking, I can't get multipath to let go.

Added this to multipath.conf:
blacklist {
        devnode "*"
}

devnode_blacklist {
        devnode "*"
        wwid 36001ec90ee4ee600105ac65e04e84e61
#       wwid 36001e4f02bc746000f60789e05a38474
        devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
        devnode "^hd[a-z]"
        devnode "^cciss!c[0-9]d[0-9]*"
        devnode "/dev/sda"
        devnode "/dev/sda1"
        devnode "/dev/disk/by-uuid/8ed92bb6-0ddb-4fbc-907d-fdf12e5550a3"
}

Yet it just comes back.

[root@bonjovi ~]# multipath -ll
mpath0 (36001ec90ee4ee600105ac65e04e84e61) dm-0 DELL,PERC 6/i
size=3D279G features=3D'0' hwhandler=3D'0' wp=3Drw
`-+- policy=3D'round-robin 0' prio=3D1 status=3Dactive
  `- 2:2:0:0 sda 8:0 active ready running

I find this particularly amusing from multipath -v3:

=3D=3D=3D=3D=3D no paths =3D=3D=3D=3D=3D
Jul 14 16:31:50 | params =3D 0 0 1 1 round-robin 0 1 1 8:0 100
Jul 14 16:31:50 | status =3D 2 0 0 0 1 1 A 0 1 0 8:0 A 0
Jul 14 16:31:50 | 8:0: not found in pathvec
Jul 14 16:31:50 | sda: mask =3D 0x1f
Jul 14 16:31:50 | sda: dev_t =3D 8:0
Jul 14 16:31:50 | sda: size =3D 584843264
Jul 14 16:31:50 | sda: subsystem =3D scsi
Jul 14 16:31:50 | sda: vendor =3D DELL
Jul 14 16:31:50 | sda: product =3D PERC 6/i
Jul 14 16:31:50 | sda: rev =3D 1.11
Jul 14 16:31:50 | sda: h:b:t:l =3D 2:2:0:0
Jul 14 16:31:50 | sda: serial =3D 00614ee8045ec65a1000e64eee90ec01
Jul 14 16:31:50 | sda: get_state
Jul 14 16:31:50 | loading /lib64/multipath/libchecktur.so checker
Jul 14 16:31:50 | sda: path checker =3D tur (config file default)
Jul 14 16:31:50 | sda: checker timeout =3D 300000 ms (internal default)
Jul 14 16:31:50 | sda: state =3D running
Jul 14 16:31:50 | sda: state =3D 3
Jul 14 16:31:50 | sda: prio =3D const (config file default)
Jul 14 16:31:50 | sda: const prio =3D 1
Jul 14 16:31:50 | sda: (DELL:PERC 6/i) device node name blacklisted

And:
[root@bonjovi ~]# multipath -v4 | grep sda
Jul 14 16:32:42 | Discover device /sys/block/sda
Jul 14 16:32:42 | sda: device node name blacklisted
Jul 14 16:32:42 | sda: mask =3D 0x1f
Jul 14 16:32:42 | sda: dev_t =3D 8:0
Jul 14 16:32:42 | sda: size =3D 584843264
Jul 14 16:32:42 | sda: subsystem =3D scsi
Jul 14 16:32:42 | sda: vendor =3D DELL
Jul 14 16:32:42 | sda: product =3D PERC 6/i
Jul 14 16:32:42 | sda: rev =3D 1.11
Jul 14 16:32:42 | sda: h:b:t:l =3D 2:2:0:0
Jul 14 16:32:42 | sda: serial =3D 00614ee8045ec65a1000e64eee90ec01
Jul 14 16:32:42 | sda: get_state
Jul 14 16:32:42 | sda: path checker =3D tur (config file default)
Jul 14 16:32:42 | sda: checker timeout =3D 300000 ms (internal default)
Jul 14 16:32:42 | sda: state =3D running
Jul 14 16:32:42 | sda: state =3D 3
Jul 14 16:32:42 | sda: prio =3D const (config file default)
Jul 14 16:32:42 | sda: const prio =3D 1
Jul 14 16:32:42 | sda: (DELL:PERC 6/i) device node name blacklisted

So it's not as if multipath doesn't know that sda should be blacklisted.  I=
t just doesn't care.

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

--_000_CA44CBE513C6Abrianpstampernasagov_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<HTML>
<HEAD>
<TITLE>Re: [dm-devel] Blacklist broken?</TITLE>
</HEAD>
<BODY>
<FONT FACE=3D"Calibri, Verdana, Helvetica, Arial"><SPAN STYLE=3D'font-size:=
11pt'><BR>
Doing a bit more checking, I can&#8217;t get multipath to let go.<BR>
<BR>
Added this to multipath.conf:<BR>
blacklist {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;devnode &quot;*&quot;<BR>
}<BR>
<BR>
devnode_blacklist {<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;devnode &quot;*&quot;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;wwid 36001ec90ee4ee600105ac=
65e04e84e61<BR>
# &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;wwid 36001e4f02bc746000f60789e05a3847=
4<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;devnode &quot;^(ram|raw|loo=
p|fd|md|dm-|sr|scd|st)[0-9]*&quot;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;devnode &quot;^hd[a-z]&quot=
;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;devnode &quot;^cciss!c[0-9]=
d[0-9]*&quot;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;devnode &quot;/dev/sda&quot=
;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;devnode &quot;/dev/sda1&quo=
t;<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;devnode &quot;/dev/disk/by-=
uuid/8ed92bb6-0ddb-4fbc-907d-fdf12e5550a3&quot;<BR>
}<BR>
<BR>
Yet it just comes back.<BR>
<BR>
[root@bonjovi ~]# multipath -ll<BR>
mpath0 (36001ec90ee4ee600105ac65e04e84e61) dm-0 DELL,PERC 6/i<BR>
size=3D279G features=3D'0' hwhandler=3D'0' wp=3Drw<BR>
`-+- policy=3D'round-robin 0' prio=3D1 status=3Dactive<BR>
&nbsp;&nbsp;`- 2:2:0:0 <B>sda </B>8:0 active ready running<BR>
<BR>
I find this particularly amusing from multipath -v3:<BR>
<BR>
=3D=3D=3D=3D=3D no paths =3D=3D=3D=3D=3D<BR>
Jul 14 16:31:50 | params =3D 0 0 1 1 round-robin 0 1 1 8:0 100 <BR>
Jul 14 16:31:50 | status =3D 2 0 0 0 1 1 A 0 1 0 8:0 A 0 <BR>
Jul 14 16:31:50 | 8:0: not found in pathvec<BR>
Jul 14 16:31:50 | sda: mask =3D 0x1f<BR>
Jul 14 16:31:50 | sda: dev_t =3D 8:0<BR>
Jul 14 16:31:50 | sda: size =3D 584843264<BR>
Jul 14 16:31:50 | sda: subsystem =3D scsi<BR>
Jul 14 16:31:50 | sda: vendor =3D DELL<BR>
Jul 14 16:31:50 | sda: product =3D PERC 6/i<BR>
Jul 14 16:31:50 | sda: rev =3D 1.11<BR>
Jul 14 16:31:50 | sda: h:b:t:l =3D 2:2:0:0<BR>
Jul 14 16:31:50 | sda: serial =3D 00614ee8045ec65a1000e64eee90ec01<BR>
Jul 14 16:31:50 | sda: get_state<BR>
Jul 14 16:31:50 | loading /lib64/multipath/libchecktur.so checker<BR>
Jul 14 16:31:50 | sda: path checker =3D tur (config file default)<BR>
Jul 14 16:31:50 | sda: checker timeout =3D 300000 ms (internal default)<BR>
Jul 14 16:31:50 | sda: state =3D running<BR>
Jul 14 16:31:50 | sda: state =3D 3<BR>
Jul 14 16:31:50 | sda: prio =3D const (config file default)<BR>
Jul 14 16:31:50 | sda: const prio =3D 1<BR>
<B>Jul 14 16:31:50 | sda: (DELL:PERC 6/i) device node name blacklisted<BR>
</B><BR>
And:<BR>
[root@bonjovi ~]# multipath -v4 | grep sda<BR>
Jul 14 16:32:42 | Discover device /sys/block/sda<BR>
<B>Jul 14 16:32:42 | sda: device node name blacklisted<BR>
</B>Jul 14 16:32:42 | sda: mask =3D 0x1f<BR>
Jul 14 16:32:42 | sda: dev_t =3D 8:0<BR>
Jul 14 16:32:42 | sda: size =3D 584843264<BR>
Jul 14 16:32:42 | sda: subsystem =3D scsi<BR>
Jul 14 16:32:42 | sda: vendor =3D DELL<BR>
Jul 14 16:32:42 | sda: product =3D PERC 6/i<BR>
Jul 14 16:32:42 | sda: rev =3D 1.11<BR>
Jul 14 16:32:42 | sda: h:b:t:l =3D 2:2:0:0<BR>
Jul 14 16:32:42 | sda: serial =3D 00614ee8045ec65a1000e64eee90ec01<BR>
Jul 14 16:32:42 | sda: get_state<BR>
Jul 14 16:32:42 | sda: path checker =3D tur (config file default)<BR>
Jul 14 16:32:42 | sda: checker timeout =3D 300000 ms (internal default)<BR>
Jul 14 16:32:42 | sda: state =3D running<BR>
Jul 14 16:32:42 | sda: state =3D 3<BR>
Jul 14 16:32:42 | sda: prio =3D const (config file default)<BR>
Jul 14 16:32:42 | sda: const prio =3D 1<BR>
<B>Jul 14 16:32:42 | sda: (DELL:PERC 6/i) device node name blacklisted<BR>
</B><BR>
So it&#8217;s not as if multipath doesn&#8217;t know that sda should be bla=
cklisted. &nbsp;It just doesn&#8217;t care.<BR>
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
</SPAN></FONT></BLOCKQUOTE>
</BODY>
</HTML>


--_000_CA44CBE513C6Abrianpstampernasagov_--


--===============7644162109922331288==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7644162109922331288==--
