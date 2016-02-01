From: Dennis Yang <dennisyang@qnap.com>
Subject: Re: I/O block when removing thin device on the same pool
Date: Mon, 1 Feb 2016 11:52:25 +0800
Message-ID: <CAAR726+-K_11n9dc=L60EcLJmcn11drQMGNoKghXNML8HbjtXA@mail.gmail.com>
References: <569F6F08.1040503@redhat.com>
	<CAJFSNy4yT_8j8Jqm7qggzNgeHLOE0db6dwUxrn1auH_W=sMscA@mail.gmail.com>
	<20160121194405.GA22766@redhat.com>
	<20160122133828.GN26774@soda.linbit>
	<20160122164345.GA15295@rh-vpn>
	<CAAR726+yoWG+_2sZ=Wd9Wi4rQmYxRhXFJCJVQ0UH8kJwH0ZPJQ@mail.gmail.com>
	<20160126161919.GA19606@rh-vpn>
	<CAAR726+9=j+LJjRY+LMKfzajHdWeUYOinR6YWJF+KRVdF-0HDg@mail.gmail.com>
	<20160128104405.GA21697@rh-vpn>
	<CAAR726KUTU0Q-hYqXy7BZUke-qb7f_cbUJNrnrwdsiZLxXxLxA@mail.gmail.com>
	<20160129160515.GB23215@rh-vpn>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4040224715019302407=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160129160515.GB23215@rh-vpn>
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

--===============4040224715019302407==
Content-Type: multipart/alternative; boundary=001a1148d7ca42ad29052aad5124

--001a1148d7ca42ad29052aad5124
Content-Type: text/plain; charset=UTF-8

Hi,

2016-01-30 0:05 GMT+08:00 Joe Thornber <thornber@redhat.com>:

> On Fri, Jan 29, 2016 at 07:01:44PM +0800, Dennis Yang wrote:
> > I had tried to define MAX_DECS as 1, 16, and 8192, and here is the
> > throughput I got.
> > When #define MAX_DECS 1, throughput drops from 3.2GB/s to around 800 ~
> 950
> > MB/s.
> > When #define MAX_DECS 16, throughput drops from 3.2GB/s to around 150 ~
> 400
> > MB/s
> > When #define MAX_DECS 8192, the I/O blocks until deletion is done.
> >
> > These throughput is gathered by writing to a newly created thin device
> > which means lots of provisioning take place. So it seems that the more
> fine
> > grained lock we use here results in the higher throughput. Is there any
> > concern if I set MAX_DECS to 1 for production?
>
> Does the time taken to remove the thin device change as you drop it to one?
>
> - Joe
>

Not that I am aware of, but I redo the experiment and the results are
listed below.

#define MAX_DECS 1
Delete a fully-mapped 10TB device without concurrent I/O takes 49 secs.
Delete a fully-mapped 10TB device with concurrent I/O to pool takes 44 secs.

#define MAX_DECS 16
Delete a fully-mapped 10TB device without concurrent I/O takes 47 secs.
Delete a fully-mapped 10TB device with concurrent I/O to pool takes 46 secs.

#define MAX_DECS 8192
Delete a fully-mapped 10TB device without concurrent I/O takes 47 secs.
Delete a fully-mapped 10TB device with concurrent I/O to pool takes 50 secs.

Thanks,
Dennis

-- 
Dennis Yang
QNAP Systems, Inc.
Skype: qnap.dennis.yang
Email: dennisyang@qnap.com
Tel: (+886)-2-2393-5152 ext. 15018
Address: 13F., No.56, Sec. 1, Xinsheng S. Rd., Zhongzheng Dist., Taipei
City, Taiwan

--001a1148d7ca42ad29052aad5124
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<br><div class=3D"gmail_extra"><br><div class=3D"gmail_=
quote">2016-01-30 0:05 GMT+08:00 Joe Thornber <span dir=3D"ltr">&lt;<a href=
=3D"mailto:thornber@redhat.com" target=3D"_blank">thornber@redhat.com</a>&g=
t;</span>:<br><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px=
 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border-left=
-style:solid;padding-left:1ex"><span class=3D"">On Fri, Jan 29, 2016 at 07:=
01:44PM +0800, Dennis Yang wrote:<br>
&gt; I had tried to define MAX_DECS as 1, 16, and 8192, and here is the<br>
&gt; throughput I got.<br>
&gt; When #define MAX_DECS 1, throughput drops from 3.2GB/s to around 800 ~=
 950<br>
&gt; MB/s.<br>
&gt; When #define MAX_DECS 16, throughput drops from 3.2GB/s to around 150 =
~ 400<br>
&gt; MB/s<br>
&gt; When #define MAX_DECS 8192, the I/O blocks until deletion is done.<br>
&gt;<br>
&gt; These throughput is gathered by writing to a newly created thin device=
<br>
&gt; which means lots of provisioning take place. So it seems that the more=
 fine<br>
&gt; grained lock we use here results in the higher throughput. Is there an=
y<br>
&gt; concern if I set MAX_DECS to 1 for production?<br>
<br>
</span>Does the time taken to remove the thin device change as you drop it =
to one?<br>
<span class=3D""><font color=3D"#888888"><br>
- Joe<br></font></span></blockquote><div>=C2=A0</div></div><div class=3D"gm=
ail_extra">Not that I am aware of, but I redo the experiment and the result=
s are listed below.<br></div><div class=3D"gmail_extra"><br></div><div clas=
s=3D"gmail_extra">#define MAX_DECS 1</div><div class=3D"gmail_extra">Delete=
 a fully-mapped 10TB device without concurrent I/O takes 49 secs.</div><div=
 class=3D"gmail_extra">Delete a fully-mapped 10TB device with concurrent I/=
O to pool takes 44 secs.</div><div class=3D"gmail_extra"><br></div><div cla=
ss=3D"gmail_extra">#define MAX_DECS 16</div><div class=3D"gmail_extra"><div=
 class=3D"gmail_extra">Delete a fully-mapped 10TB device without concurrent=
 I/O takes 47 secs.</div><div class=3D"gmail_extra">Delete a fully-mapped 1=
0TB device with concurrent I/O to pool takes 46 secs.</div></div><div><br><=
/div><div><div class=3D"gmail_extra">#define MAX_DECS 8192</div><div class=
=3D"gmail_extra"><div class=3D"gmail_extra">Delete a fully-mapped 10TB devi=
ce without concurrent I/O takes 47 secs.</div><div class=3D"gmail_extra">De=
lete a fully-mapped 10TB device with concurrent I/O to pool takes 50 secs.<=
/div><div class=3D"gmail_extra"><br></div><div class=3D"gmail_extra">Thanks=
,</div><div class=3D"gmail_extra">Dennis</div><div class=3D"gmail_extra"><b=
r></div></div></div>-- <br><div class=3D"gmail_signature"><div dir=3D"ltr">=
<span lang=3D"EN-US" style=3D"font-size:10pt;font-family:Arial,sans-serif">=
Dennis Yang=C2=A0</span><span lang=3D"EN-US" style=3D"font-size:10pt;font-f=
amily:Arial,sans-serif">=C2=A0</span><span lang=3D"EN-US" style=3D"font-siz=
e:10pt;font-family:Arial,sans-serif"><br>QNAP Systems, Inc.</span><div><spa=
n lang=3D"EN-US" style=3D"font-size:10pt;font-family:Arial,sans-serif">Skyp=
e: qnap.dennis.yang<br>Email:</span><span lang=3D"EN-US" style=3D"font-size=
:10pt;font-family:Arial,sans-serif">=C2=A0<a href=3D"mailto:dennisyang@qnap=
.com" target=3D"_blank">dennisyang@qnap.com</a></span><div><span lang=3D"EN=
-US" style=3D"font-size:10pt;font-family:Arial,sans-serif">Tel:</span><span=
 style=3D"font-family:Arial,sans-serif;font-size:13.3333px">=C2=A0(+886)-2-=
2393-5152 ext.=C2=A0</span><span style=3D"font-family:Arial,sans-serif;font=
-size:13.3333px">15018</span><div><font face=3D"Arial, sans-serif" size=3D"=
2">Address:=C2=A0</font><span style=3D"color:rgb(51,51,51);font-family:Verd=
ana,Arial,Helvetica,sans-serif;font-size:12px;line-height:18.6667px">13F., =
No.56, Sec. 1, Xinsheng S. Rd., Zhongzheng Dist., Taipei City, Taiwan</span=
></div></div></div></div></div>
</div></div>

--001a1148d7ca42ad29052aad5124--


--===============4040224715019302407==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4040224715019302407==--
