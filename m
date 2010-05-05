From: Busby <chaimvy@gmail.com>
Subject: Re: create lvm2 snapshot will take a long time while
	large IO on origin lv(till large IO ends)
Date: Wed, 5 May 2010 19:10:08 +0800
Message-ID: <j2nb8091bb41005050410tc0376726jaf9061685a6a5fa1@mail.gmail.com>
References: <w2ub8091bb41004282024i9ae427f7gf963baab82d811d0@mail.gmail.com>
	<4BD9C264.7040501@cfl.rr.com>
	<q2hb8091bb41004291809i8fa5d34cr3918144d715f0792@mail.gmail.com>
	<4BDAEB90.7050305@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8376303562084609810=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4BDAEB90.7050305@cfl.rr.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Phillip Susi <psusi@cfl.rr.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============8376303562084609810==
Content-Type: multipart/alternative; boundary=000e0cd7629e6f9acf0485d6dedc

--000e0cd7629e6f9acf0485d6dedc
Content-Type: text/plain; charset=ISO-8859-1

I read the source code of 'dm_suspend' in the kernel, find it will call this
function:

__filemap_fdatawrite(mapping, WB_SYNC_ALL);

so I understand
"I don't think it is possible to suspend new IO requests from user land
while allowing it from the buffer cache"
you said.
Thank you very much, :)

Best regards,
Busby
2010/4/30 Phillip Susi <psusi@cfl.rr.com>

> On 4/29/2010 9:09 PM, Busby wrote:
> > Hi, Phillip Susi,
> >                  Why not suspend the origin's IO first, then create the
> > snapshot lv, resume the origin lv 's IO waiting Q last. the 'dd' cmd is
> > eariler than the snapshot's creating, if suspend the IO, the filesystem
> > on the snapshot will be corrupt, I get it, but I think the  snapshot is
> > in block layer, should suspend the user layer's data coming first, then
> > flush the data in the dirty buffer and create the snapshot.  like the dd
> > cmd on the origin, will make the snapshot's creating take a very long
> > time, for waiting for the dm suspend 's return, I think flush the data
> > in the dirty buffer (data from dd ), suspend the next data of the dd,
> > create the snapshot, then let the data into dirty buffer to the block
> > layer. the dd cmd will put the data into dirty buffer continually, can
> > not be suspended?
>
> I don't think it is possible to suspend new IO requests from user land
> while allowing it from the buffer cache.
>

--000e0cd7629e6f9acf0485d6dedc
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>I read the source code of &#39;dm_suspend&#39; in the kernel, find it =
will call this function:</div>
<div>=A0</div>
<div>__filemap_fdatawrite(mapping, <font color=3D"#ff0000">WB_SYNC_ALL</fon=
t>);</div>
<div>=A0</div>
<div>so=A0I understand=A0</div>
<div>&quot;I don&#39;t think it is possible to suspend new IO requests from=
 user land<br>while allowing it from the buffer cache&quot;=A0</div>
<div>you said.</div>
<div>Thank you very much, :)</div>
<div>=A0</div>
<div>Best regards,</div>
<div>Busby<br></div>
<div class=3D"gmail_quote">2010/4/30 Phillip Susi <span dir=3D"ltr">&lt;<a =
href=3D"mailto:psusi@cfl.rr.com">psusi@cfl.rr.com</a>&gt;</span><br>
<blockquote style=3D"BORDER-LEFT: #ccc 1px solid; MARGIN: 0px 0px 0px 0.8ex=
; PADDING-LEFT: 1ex" class=3D"gmail_quote">
<div class=3D"im">On 4/29/2010 9:09 PM, Busby wrote:<br>&gt; Hi, Phillip Su=
si,<br>&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Why not suspend the origin&#=
39;s IO first, then create the<br>&gt; snapshot lv, resume the origin lv &#=
39;s IO waiting Q last. the &#39;dd&#39; cmd is<br>
&gt; eariler than the snapshot&#39;s creating, if suspend the IO, the files=
ystem<br>&gt; on the snapshot will be corrupt, I get it, but I think the =
=A0snapshot is<br>&gt; in block layer, should suspend the user layer&#39;s =
data coming first, then<br>
&gt; flush the data in the dirty buffer and create the snapshot. =A0like th=
e dd<br>&gt; cmd on the origin, will make the snapshot&#39;s creating take =
a very long<br>&gt; time, for waiting for the dm suspend &#39;s return, I t=
hink flush the data<br>
&gt; in the dirty buffer (data from dd ), suspend the next data of the dd,<=
br>&gt; create the snapshot, then let the data into dirty buffer to the blo=
ck<br>&gt; layer. the dd cmd will put the data into dirty buffer continuall=
y, can<br>
&gt; not be suspended?<br><br></div>I don&#39;t think it is possible to sus=
pend new IO requests from user land<br>while allowing it from the buffer ca=
che.<br></blockquote></div><br>

--000e0cd7629e6f9acf0485d6dedc--


--===============8376303562084609810==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8376303562084609810==--
