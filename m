From: Dennis Yang <dennisyang@qnap.com>
Subject: Re: Possible data corruption with dm-thin
Date: Mon, 27 Jun 2016 17:32:35 +0800
Message-ID: <CAAR726KCTJnbJhU-XhAn0xv3RVEHZY-NFjSNnWqnuVVO6kR4xQ@mail.gmail.com>
References: <CAAR726JWQ4VKOVR87QX6Tmuhu1JnCymm7coLT=TFn3BseKm8XA@mail.gmail.com>
	<20160624135510.GA13946@roamer.bos.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5457158760609248397=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160624135510.GA13946@roamer.bos.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dennis Yang <dennisyang@qnap.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============5457158760609248397==
Content-Type: multipart/alternative; boundary=047d7bb049c67f3d0405363f342e

--047d7bb049c67f3d0405363f342e
Content-Type: text/plain; charset=UTF-8

Hi Joe,

2016-06-24 21:55 GMT+08:00 Edward Thornber <thornber@redhat.com>:

> Hi Dennis,
>
> On Tue, Jun 21, 2016 at 03:56:26PM +0800, Dennis Yang wrote:
> > So my question is, does dm-thin have any mechanism to eliminate the race
> > when
> > discarded block is reused right away by another device?
>
> I'll try and recreate your scenario.  The transaction-manager will not
> reallocate a block that's been freed within a transaction so that we
> can always rollback.  So as long as there hasn't been a commit,
> reallocation shouldn't be possible.  This is what normally guards
> allocation, but in your case I think you may be onto something and we
> may have to hold onto the data cell until the passdown discards are
> complete.
>
> - Joe
>

In my experience, this issue is pretty hard to reproduce solely by a
thin-pool
which is built on top of a regular hard disk or RAID, since I rarely
observe the
DISCARD and WRITE coming from different thin devices get reordered in the
lower level. In my system, the thin-pool is built on top of another
device-mapper
device providing data tiering functionality which could delay the DISCARD
request a little bit and lead to a request reorder situation.

Based on the log I had, I suspect that there was metadata commit before
another
thin device reused the discarded block while the DISCARD request was still
being
processed by the lower level stacks. In this case, holding the data cell
until the
passdown discards are complete seems to only protect the discarded block
from
being reallocated by the same thin device which allocates the block in the
first place,
because only those write I/Os that are going to the same device will be
prisoned.

In my opinion, I think maybe the to-be-discard block should only be freed
after the
passdown discards have been complete. I had only written a patch in this
way and
applied it on my site since last week, and the issue had not been seen on
my site
for 72 hours. I am not very confident about whether this patch will cause
any side
effect, I would be highly appreciated if you can share your concern with me.

Thanks for your reply,
Dennis




-- 
Dennis Yang
QNAP Systems, Inc.
Skype: qnap.dennis.yang
Email: dennisyang@qnap.com
Tel: (+886)-2-2393-5152 ext. 15018
Address: 13F., No.56, Sec. 1, Xinsheng S. Rd., Zhongzheng Dist., Taipei
City, Taiwan

--047d7bb049c67f3d0405363f342e
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Joe,<div class=3D"gmail_extra"><br><div class=3D"gmail_=
quote">2016-06-24 21:55 GMT+08:00 Edward Thornber <span dir=3D"ltr">&lt;<a =
href=3D"mailto:thornber@redhat.com" target=3D"_blank">thornber@redhat.com</=
a>&gt;</span>:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .=
8ex;border-left:1px #ccc solid;padding-left:1ex">Hi Dennis,<br>
<span class=3D""><br>
On Tue, Jun 21, 2016 at 03:56:26PM +0800, Dennis Yang wrote:<br>
&gt; So my question is, does dm-thin have any mechanism to eliminate the ra=
ce<br>
&gt; when<br>
&gt; discarded block is reused right away by another device?<br>
<br>
</span>I&#39;ll try and recreate your scenario.=C2=A0 The transaction-manag=
er will not<br>
reallocate a block that&#39;s been freed within a transaction so that we<br=
>
can always rollback.=C2=A0 So as long as there hasn&#39;t been a commit,<br=
>
reallocation shouldn&#39;t be possible.=C2=A0 This is what normally guards<=
br>
allocation, but in your case I think you may be onto something and we<br>
may have to hold onto the data cell until the passdown discards are<br>
complete.<br>
<br>
- Joe<br>
</blockquote></div><br>In my experience, this issue is pretty hard to repro=
duce solely by a thin-pool=C2=A0</div><div class=3D"gmail_extra">which is b=
uilt on top of a regular hard disk or RAID, since I rarely observe the=C2=
=A0</div><div class=3D"gmail_extra">DISCARD and WRITE coming from different=
 thin devices get reordered in the=C2=A0</div><div class=3D"gmail_extra">lo=
wer level. In my system, the thin-pool is built on top of another device-ma=
pper=C2=A0</div><div class=3D"gmail_extra">device providing data tiering fu=
nctionality which could delay the DISCARD=C2=A0</div><div class=3D"gmail_ex=
tra">request a little bit and lead to a request reorder situation.=C2=A0</d=
iv><div class=3D"gmail_extra"><br></div><div class=3D"gmail_extra">Based on=
 the log I had, I suspect that there was metadata commit before another</di=
v><div class=3D"gmail_extra">thin device reused the discarded block while t=
he DISCARD request was still being</div><div class=3D"gmail_extra">processe=
d by the lower level stacks. In this case, holding the data cell until the=
=C2=A0</div><div class=3D"gmail_extra">passdown discards are complete seems=
 to only protect the discarded block from</div><div class=3D"gmail_extra">b=
eing reallocated by the same thin device which allocates the block in the f=
irst place,</div><div class=3D"gmail_extra">because only those write I/Os t=
hat are going to the same device will be prisoned.=C2=A0</div><div class=3D=
"gmail_extra"><br></div><div class=3D"gmail_extra">In my opinion, I think m=
aybe the to-be-discard block should only be freed after the</div><div class=
=3D"gmail_extra">passdown discards have been complete. I had only written a=
 patch in this way and=C2=A0</div><div class=3D"gmail_extra">applied it on =
my site since last week, and the issue had not been seen on my site=C2=A0</=
div><div class=3D"gmail_extra">for 72 hours. I am not very confident about =
whether this patch will cause any side</div><div class=3D"gmail_extra">effe=
ct, I would be highly appreciated if you can share your concern with me.</d=
iv><div class=3D"gmail_extra"><br></div><div class=3D"gmail_extra">Thanks f=
or your reply,</div><div class=3D"gmail_extra">Dennis =C2=A0=C2=A0</div><di=
v class=3D"gmail_extra"><br></div><div class=3D"gmail_extra"><br></div><div=
 class=3D"gmail_extra">=C2=A0 =C2=A0</div><div class=3D"gmail_extra"><div><=
br></div>-- <br><div class=3D"gmail_signature" data-smartmail=3D"gmail_sign=
ature"><div dir=3D"ltr"><span lang=3D"EN-US" style=3D"font-size:10pt;font-f=
amily:Arial,sans-serif">Dennis Yang=C2=A0</span><span lang=3D"EN-US" style=
=3D"font-size:10pt;font-family:Arial,sans-serif">=C2=A0</span><span lang=3D=
"EN-US" style=3D"font-size:10pt;font-family:Arial,sans-serif"><br>QNAP Syst=
ems, Inc.</span><div><span lang=3D"EN-US" style=3D"font-size:10pt;font-fami=
ly:Arial,sans-serif">Skype: qnap.dennis.yang<br>Email:</span><span lang=3D"=
EN-US" style=3D"font-size:10pt;font-family:Arial,sans-serif">=C2=A0<a href=
=3D"mailto:dennisyang@qnap.com" target=3D"_blank">dennisyang@qnap.com</a></=
span><div><span lang=3D"EN-US" style=3D"font-size:10pt;font-family:Arial,sa=
ns-serif">Tel:</span><span style=3D"font-family:Arial,sans-serif;font-size:=
13.333333969116211px">=C2=A0(+886)-2-2393-5152 ext.=C2=A0</span><span style=
=3D"font-family:Arial,sans-serif;font-size:13.333333969116211px">15018</spa=
n><div><font face=3D"Arial, sans-serif" size=3D"2">Address:=C2=A0</font><sp=
an style=3D"color:rgb(51,51,51);font-family:Verdana,Arial,Helvetica,sans-se=
rif;font-size:12px;line-height:18.66666603088379px">13F., No.56, Sec. 1, Xi=
nsheng S. Rd., Zhongzheng Dist., Taipei City, Taiwan</span></div></div></di=
v></div></div>
</div></div>

--047d7bb049c67f3d0405363f342e--


--===============5457158760609248397==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5457158760609248397==--
