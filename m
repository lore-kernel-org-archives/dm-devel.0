From: Arunachalam <k.arunachalam@gmail.com>
Subject: Re: udevsettle command takes long time to settle in RHEL
 5.9 & 5.10
Date: Fri, 21 Mar 2014 20:00:06 +0530
Message-ID: <CABJr3_5r4GjKq1L-gkypEN+G1VJA9i_8Lrv27zPR=yZwy1ZdsA@mail.gmail.com>
References: <CABJr3_4T2XKLoRrXVp7CCnFG-Qvrmfr+ZXFX7cbWfugCQcw_Fg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4264009861302758448=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABJr3_4T2XKLoRrXVp7CCnFG-Qvrmfr+ZXFX7cbWfugCQcw_Fg@mail.gmail.com>
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

--===============4264009861302758448==
Content-Type: multipart/alternative; boundary=089e013cba62ea5c0504f51eb898

--089e013cba62ea5c0504f51eb898
Content-Type: text/plain; charset=ISO-8859-1

adding bmarzins


On Fri, Mar 21, 2014 at 7:57 PM, Arunachalam <k.arunachalam@gmail.com>wrote:

> hi,
> We are looking for some more info on this...
>
> the RHEL 5u9 and 5U10 containt the udev 40-multipath.rules like this..
>
> HERE this rule line
> RUN+="/bin/bash -c '/sbin/mpath_wait /dev/mapper/%c; /sbin/kpartx -a -p p
> /dev/mapper/%c'"
>
> is causing the vgdisplay hanging issues a lot of times...mpath-* and
> part1-mapth-* devices are handled in the initial and last stages of this
> rule file.. What this above line is handling, with out checking for the
> device existence its waiting and doing kpartx and some times it got stuck
> in kpartx and later if vgdisplay hangs for the dg handled by the above
> hanging mulipath device..
>
> in RHEL 5u6 we have this line..instead of the above one...
>
> PROGRAM=="/sbin/dmsetup info -c --noheadings -o name -j %M -m
> %m",RESULT=="?*", NAME="%k", SYMLINK="mpath/%c", RUN+="/bin/bash -c
> '/sbin/mpath_wait /dev/mapper/%c; /sbin/kpartx -a -p p /dev/mapper/%c'"
>
>
> [root@x336-207-55 home]# cat /etc/udev/rules.d/40-multipath.rules
> # multipath wants the devmaps presented as meaninglful device names
> # so name them after their devmap name
> SUBSYSTEM!="block", GOTO="end_mpath"
> KERNEL!="dm-[0-9]*", GOTO="end_mpath"
> PROGRAM!="/sbin/mpath_wait %M %m", GOTO="end_mpath"
> PROGRAM!="/sbin/dmsetup info -c --noheadings -j %M -m %m", GOTO="end_mpath"
> RESULT!="*:*:*:*:*:*:*:mpath-*", GOTO="kpartx_check"
> PROGRAM!="/sbin/dmsetup info -c --noheadings -o name -j %M -m %m",
> GOTO="end_mpath"
> RESULT!="?*", GOTO="end_mpath"
> NAME="%k", SYMLINK="mpath/%c"
> ACTION!="change", GOTO="skip_kpartx"
> RUN+="/bin/bash -c '/sbin/mpath_wait /dev/mapper/%c; /sbin/kpartx -a -p p
> /dev/mapper/%c'"
> LABEL="skip_kpartx"
> OPTIONS="last_rule"
> LABEL="kpartx_check"
> RESULT!="*:*:*:*:*:*:*:part*-mpath-*", GOTO="end_mpath"
> PROGRAM=="/sbin/dmsetup info -c --noheadings -o name -j %M -m %m",
> RESULT=="?*", NAME="%k", SYMLINK="mpath/%c"
> OPTIONS="last_rule"
> LABEL="end_mpath"
>
>
> So removing the line is not causing any big issues ...
> RUN+="/bin/bash -c '/sbin/mpath_wait /dev/mapper/%c; /sbin/kpartx -a -p p
> /dev/mapper/%c'"
>
>

--089e013cba62ea5c0504f51eb898
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">adding bmarzins</div><div class=3D"gmail_extra"><br><br><d=
iv class=3D"gmail_quote">On Fri, Mar 21, 2014 at 7:57 PM, Arunachalam <span=
 dir=3D"ltr">&lt;<a href=3D"mailto:k.arunachalam@gmail.com" target=3D"_blan=
k">k.arunachalam@gmail.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div dir=3D"ltr">hi,<div>We are looking for =
some more info on this...</div><div><br></div><div>the RHEL 5u9 and 5U10 co=
ntaint the udev 40-multipath.rules like this..</div>
<div><br></div><div>HERE this rule line=A0</div><div>RUN+=3D&quot;/bin/bash=
 -c &#39;/sbin/mpath_wait /dev/mapper/%c; /sbin/kpartx -a -p p /dev/mapper/=
%c&#39;&quot;<br>
</div><div><br></div><div>is causing the vgdisplay hanging issues a lot of =
times...mpath-* and part1-mapth-* devices are handled in the initial and la=
st stages of this rule file.. What this above line is handling, with out ch=
ecking for the device existence its waiting and doing kpartx and some times=
 it got stuck in kpartx and later if vgdisplay hangs for the dg handled by =
the above hanging mulipath device..</div>

<div><br></div><div>in RHEL 5u6 we have this line..instead of the above one=
...</div><div><br></div><div><div>PROGRAM=3D=3D&quot;/sbin/dmsetup info -c =
--noheadings -o name -j %M -m %m&quot;,RESULT=3D=3D&quot;?*&quot;, NAME=3D&=
quot;%k&quot;, SYMLINK=3D&quot;mpath/%c&quot;, RUN+=3D&quot;/bin/bash -c &#=
39;/sbin/mpath_wait /dev/mapper/%c; /sbin/kpartx -a -p p /dev/mapper/%c&#39=
;&quot;</div>

</div><div><br></div><div><br></div><div><div>[root@x336-207-55 home]# cat =
/etc/udev/rules.d/40-multipath.rules</div><div># multipath wants the devmap=
s presented as meaninglful device names</div><div># so name them after thei=
r devmap name</div>

<div>SUBSYSTEM!=3D&quot;block&quot;, GOTO=3D&quot;end_mpath&quot;</div><div=
>KERNEL!=3D&quot;dm-[0-9]*&quot;, GOTO=3D&quot;end_mpath&quot;</div><div>PR=
OGRAM!=3D&quot;/sbin/mpath_wait %M %m&quot;, GOTO=3D&quot;end_mpath&quot;</=
div><div>

PROGRAM!=3D&quot;/sbin/dmsetup info -c --noheadings -j %M -m %m&quot;, GOTO=
=3D&quot;end_mpath&quot;</div><div>RESULT!=3D&quot;*:*:*:*:*:*:*:mpath-*&qu=
ot;, GOTO=3D&quot;kpartx_check&quot;</div><div>PROGRAM!=3D&quot;/sbin/dmset=
up info -c --noheadings -o name -j %M -m %m&quot;, GOTO=3D&quot;end_mpath&q=
uot;</div>

<div>RESULT!=3D&quot;?*&quot;, GOTO=3D&quot;end_mpath&quot;</div><div>NAME=
=3D&quot;%k&quot;, SYMLINK=3D&quot;mpath/%c&quot;</div><div>ACTION!=3D&quot=
;change&quot;, GOTO=3D&quot;skip_kpartx&quot;</div><div>RUN+=3D&quot;/bin/b=
ash -c &#39;/sbin/mpath_wait /dev/mapper/%c; /sbin/kpartx -a -p p /dev/mapp=
er/%c&#39;&quot;</div>

<div>LABEL=3D&quot;skip_kpartx&quot;<br></div><div>OPTIONS=3D&quot;last_rul=
e&quot;</div><div>LABEL=3D&quot;kpartx_check&quot;</div><div>RESULT!=3D&quo=
t;*:*:*:*:*:*:*:part*-mpath-*&quot;, GOTO=3D&quot;end_mpath&quot;</div><div=
>PROGRAM=3D=3D&quot;/sbin/dmsetup info -c --noheadings -o name -j %M -m %m&=
quot;, RESULT=3D=3D&quot;?*&quot;, NAME=3D&quot;%k&quot;, SYMLINK=3D&quot;m=
path/%c&quot;</div>

<div>OPTIONS=3D&quot;last_rule&quot;</div><div>LABEL=3D&quot;end_mpath&quot=
;</div></div><div><br></div><div><br></div><div>So removing the line is not=
 causing any big issues ...</div><div>RUN+=3D&quot;/bin/bash -c &#39;/sbin/=
mpath_wait /dev/mapper/%c; /sbin/kpartx -a -p p /dev/mapper/%c&#39;&quot;<b=
r>

</div><div><br></div></div>
</blockquote></div><br></div>

--089e013cba62ea5c0504f51eb898--


--===============4264009861302758448==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4264009861302758448==--
