From: =?GB2312?B?0e7OsA==?= <csynineyang@gmail.com>
Subject: Re: about multipath path group
Date: Tue, 4 Aug 2009 18:08:49 +0800
Message-ID: <2005566d0908040308g7db2b0ebu56db9254e939b33d@mail.gmail.com>
References: <2005566d0907212349i13c7d5aft7af3506dc572b8e7@mail.gmail.com>
	<20090803193141.GQ15326@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0139211303=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090803193141.GQ15326@ether.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

--===============0139211303==
Content-Type: multipart/alternative; boundary=001636e0a91ca662ac04704e12ec

--001636e0a91ca662ac04704e12ec
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: quoted-printable

Thanks very much! your comments is helpful to me


2009/8/4 Benjamin Marzinski <bmarzins@redhat.com>

> On Wed, Jul 22, 2009 at 02:49:39PM +0800, =D1=EE=CE=B0 wrote:
> >    Dear all:
> >
> >    Q1: In RHEL 5.2, make and make install multipath-tools-0.4.8, why do=
es
> not
> >    command "multipath -p" work well?
>
> Are you using the upstream or the RHEL code.  multipath -p does work in
> the RHEL code, although, if you run multipath again, or reconfigure
> multipathd, it will notice that your devices aren't set up the way the
> config says they should be, and it will change them back.  In general,
> multipath -p is pretty worthless, you should change the configuration to
> use the path grouping policy you want.
>
> >
> >    Q2: In RHEL 5.2, configure path group policy as failover or
> group_by_prio,
> >    and then create path-prio.sh to set the priority of paths. however,
> the
> >    path group with the highest priority is not always active, if I don'=
t
> >    recreate the multipath devices. why is that? how I make the path gro=
up
> >    with the highest priority is active on-line?
>
> By default, multipath is configured for manual failback.  This means
> that multipathd won't switch from the current active pathgroup to a
> higher priority one, unless you manually force it to do so. The
> easiest way to do this is by running
>
> # service multipathd reload  or
> # multipathd -k"reconfigure"
>
> adding
>
> defaults {
>        <other_defaults>
>        failback immediate
> }
>
> to /etc/multipath.conf will make multipath immdiately switch to the
> highest priority path group.
>
> -Ben
>
> >
> >    William
>
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--001636e0a91ca662ac04704e12ec
Content-Type: text/html; charset=GB2312
Content-Transfer-Encoding: quoted-printable

<br>Thanks very much! your comments is helpful to me<br><br><br><div class=
=3D"gmail_quote">2009/8/4 Benjamin Marzinski <span dir=3D"ltr">&lt;<a href=
=3D"mailto:bmarzins@redhat.com">bmarzins@redhat.com</a>&gt;</span><br><bloc=
kquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, 204, =
204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<div class=3D"im">On Wed, Jul 22, 2009 at 02:49:39PM +0800, =D1=EE=CE=B0 wr=
ote:<br>
&gt; &nbsp; &nbsp;Dear all:<br>
&gt;<br>
&gt; &nbsp; &nbsp;Q1: In RHEL 5.2, make and make install multipath-tools-0.=
4.8, why does not<br>
&gt; &nbsp; &nbsp;command &quot;multipath -p&quot; work well?<br>
<br>
</div>Are you using the upstream or the RHEL code. &nbsp;multipath -p does =
work in<br>
the RHEL code, although, if you run multipath again, or reconfigure<br>
multipathd, it will notice that your devices aren&#39;t set up the way the<=
br>
config says they should be, and it will change them back. &nbsp;In general,=
<br>
multipath -p is pretty worthless, you should change the configuration to<br=
>
use the path grouping policy you want.<br>
<div class=3D"im"><br>
&gt;<br>
&gt; &nbsp; &nbsp;Q2: In RHEL 5.2, configure path group policy as failover =
or group_by_prio,<br>
&gt; &nbsp; &nbsp;and then create path-prio.sh to set the priority of paths=
. however, the<br>
&gt; &nbsp; &nbsp;path group with the highest priority is not always active=
, if I don&#39;t<br>
&gt; &nbsp; &nbsp;recreate the multipath devices. why is that? how I make t=
he path group<br>
&gt; &nbsp; &nbsp;with the highest priority is active on-line?<br>
<br>
</div>By default, multipath is configured for manual failback. &nbsp;This m=
eans<br>
that multipathd won&#39;t switch from the current active pathgroup to a<br>
higher priority one, unless you manually force it to do so. The<br>
easiest way to do this is by running<br>
<br>
# service multipathd reload &nbsp;or<br>
# multipathd -k&quot;reconfigure&quot;<br>
<br>
adding<br>
<br>
defaults {<br>
 &nbsp; &nbsp; &nbsp; &nbsp;&lt;other_defaults&gt;<br>
 &nbsp; &nbsp; &nbsp; &nbsp;failback immediate<br>
}<br>
<br>
to /etc/multipath.conf will make multipath immdiately switch to the<br>
highest priority path group.<br>
<br>
-Ben<br>
<br>
&gt;<br>
&gt; &nbsp; &nbsp;William<br>
<br>
&gt; --<br>
&gt; dm-devel mailing list<br>
&gt; <a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
&gt; <a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D=
"_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a><br>
<font color=3D"#888888"><br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D"_bla=
nk">https://www.redhat.com/mailman/listinfo/dm-devel</a><br>
</font></blockquote></div><br>

--001636e0a91ca662ac04704e12ec--


--===============0139211303==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0139211303==--
