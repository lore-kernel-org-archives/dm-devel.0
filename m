From: Busby <chaimvy@gmail.com>
Subject: Re: create lvm2 snapshot will take a long time while
	large IO on origin lv(till large IO ends)
Date: Fri, 30 Apr 2010 09:09:21 +0800
Message-ID: <q2hb8091bb41004291809i8fa5d34cr3918144d715f0792@mail.gmail.com>
References: <w2ub8091bb41004282024i9ae427f7gf963baab82d811d0@mail.gmail.com>
	<4BD9C264.7040501@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7442042479678274366=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4BD9C264.7040501@cfl.rr.com>
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

--===============7442042479678274366==
Content-Type: multipart/alternative; boundary=000e0cd23bccab0e7c048569e43e

--000e0cd23bccab0e7c048569e43e
Content-Type: text/plain; charset=ISO-8859-1

Hi, Phillip Susi,
                 Why not suspend the origin's IO first, then create the
snapshot lv, resume the origin lv 's IO waiting Q last. the 'dd' cmd is
eariler than the snapshot's creating, if suspend the IO, the filesystem on
the snapshot will be corrupt, I get it, but I think the  snapshot is in
block layer, should suspend the user layer's data coming first, then flush
the data in the dirty buffer and create the snapshot.  like the dd cmd on
the origin, will make the snapshot's creating take a very long time, for
waiting for the dm suspend 's return, I think flush the data in the dirty
buffer (data from dd ), suspend the next data of the dd, create the
snapshot, then let the data into dirty buffer to the block layer. the dd cmd
will put the data into dirty buffer continually, can not be suspended?


Best regards,
Bubsy

2010/4/30 Phillip Susi <psusi@cfl.rr.com>

> On 4/28/2010 11:24 PM, Busby wrote:
> > it seems the vgs suspend because the lvcreate cmd don't unlock the
> > flock, but why the lvcreating of snapshot lv will be suspended while the
> > origin is on big data IO?
>
> Because when creating a snapshot it tries to flush any dirty buffers so
> that the origin is in a consistent state at the time the snapshot is
> created.  This is done to minimize the chance that the filesystem on the
> snapshot will be corrupt.
>

--000e0cd23bccab0e7c048569e43e
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Hi, Phillip Susi,</div>
<div>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Why not suspend the o=
rigin&#39;s IO first, then create the snapshot lv, resume the origin lv &#3=
9;s IO waiting Q last. the &#39;dd&#39; cmd is eariler than the snapshot&#3=
9;s creating, if suspend the IO, the filesystem on the snapshot will be cor=
rupt, I get it, but I think the =A0snapshot is in block layer,=A0should sus=
pend the user layer&#39;s data coming first, then flush the data in the dir=
ty buffer and=A0create=A0the snapshot. =A0like the dd cmd on the origin, wi=
ll make the snapshot&#39;s creating take a very long time, for waiting for =
the dm suspend &#39;s return, I think flush the data in the dirty buffer (d=
ata from dd ), suspend the next data of the dd, create the snapshot, then l=
et the data into dirty buffer to the block layer. the dd cmd will put the d=
ata into dirty buffer continually, can not be suspended?</div>

<div>=A0=A0=A0=A0=A0=A0=A0=A0 </div>
<div>=A0</div>
<div>Best regards,</div>
<div>Bubsy<br><br></div>
<div class=3D"gmail_quote">2010/4/30 Phillip Susi <span dir=3D"ltr">&lt;<a =
href=3D"mailto:psusi@cfl.rr.com">psusi@cfl.rr.com</a>&gt;</span><br>
<blockquote style=3D"BORDER-LEFT: #ccc 1px solid; MARGIN: 0px 0px 0px 0.8ex=
; PADDING-LEFT: 1ex" class=3D"gmail_quote">
<div class=3D"im">On 4/28/2010 11:24 PM, Busby wrote:<br>&gt; it seems the =
vgs suspend because the lvcreate cmd don&#39;t unlock the<br>&gt; flock, bu=
t why the lvcreating of snapshot lv will be suspended while the<br>&gt; ori=
gin is on big data IO?<br>
<br></div>Because when creating a snapshot it tries to flush any dirty buff=
ers so<br>that the origin is in a consistent state at the time the snapshot=
 is<br>created. =A0This is done to minimize the chance that the filesystem =
on the<br>
snapshot will be corrupt.<br></blockquote></div><br>

--000e0cd23bccab0e7c048569e43e--


--===============7442042479678274366==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7442042479678274366==--
