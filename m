From: Paul Lawrence <paullawrence@google.com>
Subject: Re: [RFC] dm-bow working prototype
Date: Mon, 19 Nov 2018 07:35:27 -0800
Message-ID: <CAL=UVf5bKS61ZNfWj6So+Cr3FGn6yYTTKQS2Lobi-=RZ83g3ww@mail.gmail.com>
References: <20181023212358.60292-1-paullawrence@google.com>
	<20181023221819.GB17552@agk-dp.fab.redhat.com>
	<296148c2-f2d9-5818-ea76-d71a0d6f5cd4@google.com>
	<alpine.LRH.2.02.1810241514310.4080@file01.intranet.prod.int.rdu2.redhat.com>
	<4a934593-1bd1-be5f-35c0-945c42762627@google.com>
	<alpine.LRH.2.02.1810261558460.28906@file01.intranet.prod.int.rdu2.redhat.com>
	<fba91b2e-4b2e-8daf-ff64-a12c9139cada@google.com>
	<alpine.LRH.2.02.1811151809380.25860@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1792148113842923750=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1811151809380.25860@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Shaohua Li <shli@kernel.org>, linux-doc@vger.kernel.org, Linux kernel <linux-kernel@vger.kernel.org>, dm-devel@redhat.com, kernel-team@android.com, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

--===============1792148113842923750==
Content-Type: multipart/alternative; boundary="000000000000ef1ec2057b0644f5"

--000000000000ef1ec2057b0644f5
Content-Type: text/plain; charset="UTF-8"

Understand. I will be looking for a way to upstream the functionality we
need, but will spend time trying to work out how to integrate it into
dm-snap or leverage dm-snap in some other way to avoid duplication.

Thanks,

Paul

On Thu, Nov 15, 2018 at 3:15 PM Mikulas Patocka <mpatocka@redhat.com> wrote:

>
>
> On Mon, 29 Oct 2018, Paul Lawrence wrote:
>
> >
> > > The snapshot target could be hacked so that it remembers space trimmed
> > > with REQ_OP_DISCARD and won't reallocate these blocks.
> > >
> > > But I suspect that running discard over the whole device would degrade
> > > performance more than copying some unneeded data.
> > >
> > > How much data do you intend to backup with this solution?
> > >
> > >
> > We are space-constrained - we will have to free up space for the backup
> before
> > we apply the update, so we have to predict the size and keeping usage as
> low
> > as possible is thus very important.
> >
> > Also, we've discussed the resizing requirement of the dm-snap solution
> and
> > that part is not attractive at all - it seems it would be impossible to
> > guarantee that the resizing happens in a timely fashion during the (very
> busy)
> > update cycle.
> >
> > Thanks everyone for the insights, especially into how dm-snap works,
> which I
> > hadn't fully appreciated. At the moment, and for the above reasons, we
> intend
> > to continue with the dm-bow solution, but do want to keep this discussion
> > open. If anyone is going to be at Linux Plumbers, I'll be presenting
> this work
> > and would love to chat about it more.
>
> dm-snapshot took 9 years to fix the last data corruption bug (2004-2013 -
> the commit e9c6a182649f4259db704ae15a91ac820e63b0ca).
>
> And with the new target duplicating the snapshot functionality, it may be
> the same.
>
> Mikulas
>

--000000000000ef1ec2057b0644f5
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:tahoma,s=
ans-serif;font-size:small">Understand. I will be looking for a way to upstr=
eam the functionality we need, but will spend time trying to work out how t=
o integrate it into dm-snap or leverage dm-snap in some other way to avoid =
duplication.</div><div class=3D"gmail_default" style=3D"font-family:tahoma,=
sans-serif;font-size:small"><br></div><div class=3D"gmail_default" style=3D=
"font-family:tahoma,sans-serif;font-size:small">Thanks,</div><div class=3D"=
gmail_default" style=3D"font-family:tahoma,sans-serif;font-size:small"><br>=
</div><div class=3D"gmail_default" style=3D"font-family:tahoma,sans-serif;f=
ont-size:small">Paul</div></div><br><div class=3D"gmail_quote"><div dir=3D"=
ltr">On Thu, Nov 15, 2018 at 3:15 PM Mikulas Patocka &lt;<a href=3D"mailto:=
mpatocka@redhat.com">mpatocka@redhat.com</a>&gt; wrote:<br></div><blockquot=
e class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc sol=
id;padding-left:1ex"><br>
<br>
On Mon, 29 Oct 2018, Paul Lawrence wrote:<br>
<br>
&gt; <br>
&gt; &gt; The snapshot target could be hacked so that it remembers space tr=
immed<br>
&gt; &gt; with REQ_OP_DISCARD and won&#39;t reallocate these blocks.<br>
&gt; &gt; <br>
&gt; &gt; But I suspect that running discard over the whole device would de=
grade<br>
&gt; &gt; performance more than copying some unneeded data.<br>
&gt; &gt; <br>
&gt; &gt; How much data do you intend to backup with this solution?<br>
&gt; &gt; <br>
&gt; &gt; <br>
&gt; We are space-constrained - we will have to free up space for the backu=
p before<br>
&gt; we apply the update, so we have to predict the size and keeping usage =
as low<br>
&gt; as possible is thus very important.<br>
&gt; <br>
&gt; Also, we&#39;ve discussed the resizing requirement of the dm-snap solu=
tion and<br>
&gt; that part is not attractive at all - it seems it would be impossible t=
o<br>
&gt; guarantee that the resizing happens in a timely fashion during the (ve=
ry busy)<br>
&gt; update cycle.<br>
&gt; <br>
&gt; Thanks everyone for the insights, especially into how dm-snap works, w=
hich I<br>
&gt; hadn&#39;t fully appreciated. At the moment, and for the above reasons=
, we intend<br>
&gt; to continue with the dm-bow solution, but do want to keep this discuss=
ion<br>
&gt; open. If anyone is going to be at Linux Plumbers, I&#39;ll be presenti=
ng this work<br>
&gt; and would love to chat about it more.<br>
<br>
dm-snapshot took 9 years to fix the last data corruption bug (2004-2013 - <=
br>
the commit e9c6a182649f4259db704ae15a91ac820e63b0ca).<br>
<br>
And with the new target duplicating the snapshot functionality, it may be <=
br>
the same.<br>
<br>
Mikulas<br>
</blockquote></div>

--000000000000ef1ec2057b0644f5--


--===============1792148113842923750==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1792148113842923750==--
