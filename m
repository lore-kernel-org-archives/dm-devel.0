From: Dong-Jae Kang <baramsori72@gmail.com>
Subject: Re: [Test Result] I/O bandwidth Control by dm-ioband -
	partition-based environment
Date: Thu, 27 Aug 2009 20:03:56 +0900
Message-ID: <2891419e0908270403kd439d29gedeea6fcae753d6d@mail.gmail.com>
References: <2891419e0908261846v4fa19791q4552975f10dd64e5@mail.gmail.com>
	<20090827.152042.104028330.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1812370655=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090827.152042.104028330.ryov@valinux.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: ioband-devel@lists.sourceforge.net, containers@lists.linux-foundation.org, dm-devel@redhat.com, corsetproject@googlegroups.com
List-Id: dm-devel.ids

--===============1812370655==
Content-Type: multipart/alternative; boundary=0022152d5cf918749c04721d86b1

--0022152d5cf918749c04721d86b1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Ryo

2009/8/27 Ryo Tsuruta <ryov@valinux.co.jp>

> Hi Dong-Jae,
>
> # I've added dm-devel to Cc:.
>
> Dong-Jae Kang <baramsori72@gmail.com> wrote:
> > Hi Ryo
> >
> > I attached new test result file(ioband-partition-based-evaluation.xls)in
> > this mail.
>
> Thanks for your great job.
>
> > In this time, it is not virtualization environment.
> > I evaluated partition-based use cases before I do it in vitualization
> > environment.
> > because I think the two cases are smilar each other.
> >
> > The detailed information about the evaluation can be referred in attached
> > file.
> >
> > If you have any questions or comments after examine it,
> > please give me your opinion.
>
> I would like to know the throughput without dm-ioband in your
> environment. Because the total throughput of range-bw policy is
> 8000KB/s, which means the device has a capability to perform over
> 8000KB/s, but the total throughput of weight policy is lower than
> the range-bw policy. In my environment, there is no significant
> difference in average throughput between with and without dm-ioband.
> I ran fio in the way described in your result file. Here are the
> results of my environment. The throughputs were calculated from
> "iostat -k 1" outputs.
>
>            buffered write test
>           Avg. throughput [KB/s]
>        w/o ioband     w/ioband
> sdb2         14485         5788
> sdb3         12494        22295
> total        26979        28030
>

OK, good comments.
I omitted the total bandwidth of the evaluation system.

I will reply to you about it tomorrow after I check and re-test it again.

>
> Thanks,
> Ryo Tsuruta
>

Thank you for comments.

-- 
Best Regards,
Dong-Jae Kang

--0022152d5cf918749c04721d86b1
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Ryo<br><br>
<div class=3D"gmail_quote">2009/8/27 Ryo Tsuruta <span dir=3D"ltr">&lt;<a h=
ref=3D"mailto:ryov@valinux.co.jp">ryov@valinux.co.jp</a>&gt;</span><br>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">Hi Dong-Jae,<br><br># I&#39;ve a=
dded dm-devel to Cc:.<br>
<div class=3D"im"><br>Dong-Jae Kang &lt;<a href=3D"mailto:baramsori72@gmail=
.com">baramsori72@gmail.com</a>&gt; wrote:<br>&gt; Hi Ryo<br>&gt;<br>&gt; I=
 attached new test result file(ioband-partition-based-evaluation.xls)in<br>
&gt; this mail.<br><br></div>Thanks for your great job.<br>
<div class=3D"im"><br>&gt; In this time, it is not virtualization environme=
nt.<br>&gt; I evaluated partition-based use cases before I do it in vituali=
zation<br>&gt; environment.<br>&gt; because I think the two cases are smila=
r each other.<br>
&gt;<br>&gt; The detailed information about the evaluation can be referred =
in attached<br>&gt; file.<br>&gt;<br>&gt; If you have any questions or comm=
ents after examine it,<br>&gt; please give me your opinion.<br><br></div>
I would like to know the throughput without dm-ioband in your<br>environmen=
t. Because the total throughput of range-bw policy is<br>8000KB/s, which me=
ans the device has a capability to perform over<br>8000KB/s, but the total =
throughput of weight policy is lower than<br>
the range-bw policy. In my environment, there is no significant<br>differen=
ce in average throughput between with and without dm-ioband.<br>I ran fio i=
n the way described in your result file. Here are the<br>results of my envi=
ronment. The throughputs were calculated from<br>
&quot;iostat -k 1&quot; outputs.<br><br>=A0 =A0 =A0 =A0 =A0 =A0buffered wri=
te test<br>=A0 =A0 =A0 =A0 =A0 Avg. throughput [KB/s]<br>=A0 =A0 =A0 =A0w/o=
 ioband =A0 =A0 w/ioband<br>sdb2 =A0 =A0 =A0 =A0 14485 =A0 =A0 =A0 =A0 5788=
<br>sdb3 =A0 =A0 =A0 =A0 12494 =A0 =A0 =A0 =A022295<br>total =A0 =A0 =A0 =
=A026979 =A0 =A0 =A0 =A028030<br>
</blockquote>
<div>=A0</div>
<div>OK, good comments.</div>
<div>I omitted the total bandwidth of the evaluation system.</div>
<div>=A0</div>
<div>I will reply to you about it tomorrow after I check=A0and re-test it a=
gain.</div>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid"><span id=3D""></span><br>Thanks,=
<br><font color=3D"#888888">Ryo Tsuruta<br></font></blockquote></div><br>Th=
ank you for comments.<br clear=3D"all">

<div></div><br>-- <br>Best Regards,<br>Dong-Jae Kang<br>

--0022152d5cf918749c04721d86b1--


--===============1812370655==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1812370655==--
