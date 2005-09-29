From: andysayshi <andysayshi@gmail.com>
Subject: Re: multipath v0.4.5, nodes not appearing in /dev/
Date: Thu, 29 Sep 2005 18:54:12 -0400
Message-ID: <3f57d11c0509291554ae9c2d2@mail.gmail.com>
References: <3f57d11c050929140232079e87@mail.gmail.com>
Reply-To: andysayshi <andysayshi@gmail.com>,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1428607201=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <3f57d11c050929140232079e87@mail.gmail.com>
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

--===============1428607201==
Content-Type: multipart/alternative;
	boundary="----=_Part_5922_1071905.1128034452976"

------=_Part_5922_1071905.1128034452976
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

skimming thru the dm-devel archives , i came upon this, so it seems with
v0.4.5 the nodes are in /dev/mapper.

https://www.redhat.com/archives/dm-devel/2005-September/msg00064.html

that answered my question. : )

On 9/29/05, andysayshi <andysayshi@gmail.com> wrote:
>
> multipath version: multipath v0.4.5 (16/06, 2005)
> kernel: Linux 2.6.9-22.ELsmp #1 SMP Mon Sep 19 18:32:14 EDT 2005
> os: Red Hat Enterprise Linux ES release 4 (Nahant Update 2)
>
> Hello,
>
> Im new to multipath/devicemapper, so please excuse any misterminology or
> misunderstanding on my part : )
>
> Basically, if i start up the multipathd service and run multipath to scan
> for devices, it finds (as it's supposed to) and emc entry (which i define=
d
> in /etc/multipath.conf).
>
> [root@cc1-86 dev]# multipath -v2 -l
> emc1 (36006016046861000625964d94cbbd911)
> [size=3D133 GB][features=3D"0"][hwhandler=3D"1 emc"]
> \_ round-robin 0 [active]
> \_ 1:0:0:0 sdb 8:16 [active]
> \_ 2:0:0:0 sdd 8:48 [active]
> \_ round-robin 0 [enabled]
> \_ 1:0:1:0 sdc 8:32 [active]
> \_ 2:0:1:0 sde 8:64 [active]
>
> [root@cc1-86 dev]#
>
> Now, originally we were running a previous version as a seperate admin
> mentioned here:
> https://www.redhat.com/archives/dm-devel/2005-August/msg00043.html , afte=
r
> lots of back and forth for this and other issues, our redhat support
> instructed us to use a updated version of multipath (ver listed above). b=
ack
> on the previous version (v0.4.4), i would be able to find the multipath
> node in /dev so that i could mount it. but now, i dont see anything in /d=
ev,
> i do however see entries in /dev/mapper:
>
> [root@cc1-86 dev]# ls -l /dev|grep dm
> brw-r----- 1 root root 253, 0 Sep 29 13:11 dm-0
> [root@cc1-86 dev]# ls -l /dev/mapper/
> total 0
> crw------- 1 root root 10, 63 Sep 29 09:08 control
> brw-rw---- 1 root disk 253, 0 Sep 29 13:11 emc1
> [root@cc1-86 dev]#
>
> I've tried searching online for info, and i ran across this via
> http://christophe.varoqui.free.fr/wiki/wakka.php?wiki=3DFAQ :
>  5. I see my multipath nodes in /dev/mapper/ but not in /dev/ Verify you
> have a naming rule configured in udev *and* no bypass rule for dm-* devic=
es.
> The naming rule may use dmsetup or multipath-tools'-provided devmap_name.
>
> # Commented out :
> # KERNEL=3D"dm-[0-9]*", OPTIONS+=3D"ignore_device"
> KERNEL=3D"dm-[0-9]*", PROGRAM=3D"/sbin/devmap_name %M %m", NAME=3D"%k",
> SYMLINK=3D"%c"
>
> Partition mapping through kpartx won't work unless devices appear in
> /dev/.
>
> Can someone tell me if this is what I need to do as well? If so, where
> would this file be located, so that I can update it?
>
> Thanks in advance,
>
> Andy.
>

------=_Part_5922_1071905.1128034452976
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

skimming thru the dm-devel archives , i came upon this,&nbsp; so it seems w=
ith v0.4.5&nbsp; the nodes are in /dev/mapper.<br>
<br>
<a href=3D"https://www.redhat.com/archives/dm-devel/2005-September/msg00064=
.html">https://www.redhat.com/archives/dm-devel/2005-September/msg00064.htm=
l</a><br><br>
that answered my question. : )<br>
<br><div><span class=3D"gmail_quote">On 9/29/05, <b class=3D"gmail_senderna=
me">andysayshi</b> &lt;<a href=3D"mailto:andysayshi@gmail.com">andysayshi@g=
mail.com</a>&gt; wrote:</span><blockquote class=3D"gmail_quote" style=3D"bo=
rder-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding=
-left: 1ex;">
multipath version: multipath v0.4.5 (16/06, 2005)<br>
kernel: Linux 2.6.9-22.ELsmp #1 SMP Mon Sep 19 18:32:14 EDT 2005<br>
os: Red Hat Enterprise Linux ES release 4 (Nahant Update 2)<br>
<br>
Hello,<br>
<br>
Im new to multipath/devicemapper, so please excuse any misterminology or mi=
sunderstanding on my part : )<br>
<br>
Basically, if i start up the multipathd service and run multipath to
scan for devices, it finds (as it's supposed to) and emc entry (which i
defined in /etc/multipath.conf). <br>
<br>
[root@cc1-86 dev]# multipath -v2 -l<br>
emc1 (36006016046861000625964d94cbbd911)<br>
[size=3D133 GB][features=3D&quot;0&quot;][hwhandler=3D&quot;1 emc&quot;]<br=
>
\_ round-robin 0 [active]<br>
&nbsp; \_ 1:0:0:0 sdb&nbsp; 8:16&nbsp;&nbsp;&nbsp; [active]<br>
&nbsp; \_ 2:0:0:0 sdd&nbsp; 8:48&nbsp;&nbsp;&nbsp; [active]<br>
\_ round-robin 0 [enabled]<br>
&nbsp; \_ 1:0:1:0 sdc&nbsp; 8:32&nbsp;&nbsp;&nbsp; [active]<br>
&nbsp; \_ 2:0:1:0 sde&nbsp; 8:64&nbsp;&nbsp;&nbsp; [active]<br>
<br>
[root@cc1-86 dev]# <br>
<br>
Now, originally we were running a previous version as a seperate admin
mentioned here:
<a href=3D"https://www.redhat.com/archives/dm-devel/2005-August/msg00043.ht=
ml" target=3D"_blank" onclick=3D"return top.js.OpenExtLink(window,event,thi=
s)">https://www.redhat.com/archives/dm-devel/2005-August/msg00043.html</a> =
,
after lots of back and forth for this and other issues, our redhat
support instructed us to use a updated version of multipath (ver listed
above). back on the previous version (v0.4.4), i would be able to find
the multipath node in /dev so that i could mount it. but now, i dont
see anything in /dev, i do however see entries in /dev/mapper:<br>
<br>
[root@cc1-86 dev]# ls -l /dev|grep dm<br>
brw-r-----&nbsp; 1 root&nbsp;&nbsp; root&nbsp;&nbsp; 253,&nbsp;&nbsp; 0 Sep=
 29 13:11 dm-0<br>
[root@cc1-86 dev]# ls -l /dev/mapper/<br>
total 0<br>
crw-------&nbsp; 1 root root&nbsp; 10, 63 Sep 29 09:08 control<br>
brw-rw----&nbsp; 1 root disk 253,&nbsp; 0 Sep 29 13:11 emc1<br>
[root@cc1-86 dev]# <br>
<br>
I've tried searching online for info, and i ran across this via <a href=3D"=
http://christophe.varoqui.free.fr/wiki/wakka.php?wiki=3DFAQ" target=3D"_bla=
nk" onclick=3D"return top.js.OpenExtLink(window,event,this)">http://christo=
phe.varoqui.free.fr/wiki/wakka.php?wiki=3DFAQ
</a> :<br>
<h3> 5. I see my multipath nodes in /dev/mapper/ but not in /dev/ </h3>

Verify you have a naming rule configured in udev *and* no bypass rule for d=
m-* devices.<br>

The naming rule may use dmsetup or multipath-tools'-provided devmap_name.<b=
r>

<tt><br>
# Commented out :<br>
# KERNEL=3D&quot;dm-[0-9]*&quot;, OPTIONS+=3D&quot;ignore_device&quot;<br>
KERNEL=3D&quot;dm-[0-9]*&quot;, PROGRAM=3D&quot;/sbin/devmap_name %M %m&quo=
t;, NAME=3D&quot;%k&quot;, SYMLINK=3D&quot;%c&quot;<br>
</tt><br>

Partition mapping through kpartx won't work unless devices appear in /dev/.=
<br>
<br>
Can someone tell me if this is what I need to do as well? If so, where woul=
d this file be located, so that I can update it?<br>
<br>
Thanks in advance,<br>
<br>
Andy.<br>

</blockquote></div><br>

------=_Part_5922_1071905.1128034452976--


--===============1428607201==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1428607201==--
