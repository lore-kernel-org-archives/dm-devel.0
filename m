From: Robin Dong <robin.k.dong@gmail.com>
Subject: Re: [PATCH] dm: make alloc error info more clearly.
Date: Sun, 7 Jul 2013 20:29:35 +0800
Message-ID: <CANsebLFx6vAYZuvQULb62fdLZPbDwtF9Ru9dRsW89DHmk2n_0w@mail.gmail.com>
References: <1373180926-29264-1-git-send-email-robin.k.dong@gmail.com>
	<20130707093119.GB13191@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3566564532888043679=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130707093119.GB13191@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Robin Dong <robin.k.dong@gmail.com>, dm-devel@redhat.com, Robin Dong <sanbai@taobao.com>
List-Id: dm-devel.ids

--===============3566564532888043679==
Content-Type: multipart/alternative; boundary=20cf307abcfda670b304e0eb1493

--20cf307abcfda670b304e0eb1493
Content-Type: text/plain; charset=ISO-8859-1

2013/7/7 Alasdair G Kergon <agk@redhat.com>
>
> On Sun, Jul 07, 2013 at 03:08:46PM +0800, Robin Dong wrote:
> > If dm-delay structure allocation failed, report more precise error
information.
>
> Do you have some test result that shows this?
>
>   DMERR("%s: %s: %s", dm_device_name(t->md), type, tgt->error);
>
> ?

Oh, sorry for my omission.
But I stil think that print "Cannot allocate linear context" in dm-flakey
is puzzling...

>
> Alasdair
>



--
--
Best Regard
Robin Dong

--20cf307abcfda670b304e0eb1493
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><br><br>2013/7/7 Alasdair G Kergon &lt;<a href=3D"mail=
to:agk@redhat.com">agk@redhat.com</a>&gt;<br>&gt;<br>&gt; On Sun, Jul 07, 2=
013 at 03:08:46PM +0800, Robin Dong wrote:<br>&gt; &gt; If dm-delay structu=
re allocation failed, report more precise error information.<br>
&gt;<br>&gt; Do you have some test result that shows this?<br>&gt;<br>&gt; =
=A0 DMERR(&quot;%s: %s: %s&quot;, dm_device_name(t-&gt;md), type, tgt-&gt;e=
rror);<br>&gt;<br>&gt; ?<div><br></div><div style>Oh, sorry for my omission=
.</div>
<div style>But I stil think that print &quot;<span style=3D"font-family:ari=
al,sans-serif;font-size:13.63636302947998px">Cannot allocate linear context=
&quot; in dm-flakey is puzzling...</span></div><div><br>&gt;<br>&gt; Alasda=
ir<br>
&gt;<br><br><br><br>--<br>--<br>Best Regard<br>Robin Dong<br></div></div>

--20cf307abcfda670b304e0eb1493--


--===============3566564532888043679==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3566564532888043679==--
