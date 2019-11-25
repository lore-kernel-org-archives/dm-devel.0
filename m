From: Drew Hastings <dhastings@crucialwebhost.com>
Subject: Re: multipath - unable to use multiple active paths at
 once, and deprecated example in docs
Date: Mon, 25 Nov 2019 13:42:30 -0700
Message-ID: <CAN-y+E+65bgiUSL6VMvRJLd3AiqD7xApbm1nA69ue_M6tTsGrA@mail.gmail.com>
References: <CAN-y+EJOt=MRDEXCx9_U4zmDs+i9yXj364E4+z=xC=u8+Ao1PQ@mail.gmail.com>
	<329fd408ea605f1f14c0eebb46209fd3c46c3af8.camel@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1772977514116751290=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <329fd408ea605f1f14c0eebb46209fd3c46c3af8.camel@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.de>, dm-devel@redhat.com
List-Id: dm-devel.ids

--===============1772977514116751290==
Content-Type: multipart/alternative; boundary="00000000000014c4cb059831ce1b"

--00000000000014c4cb059831ce1b
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 25, 2019 at 12:48 PM Martin Wilck <mwilck@suse.de> wrote:

>
> I think you are seeing this FIXME:
>
> https://elixir.bootlin.com/linux/v4.19.79/source/drivers/md/dm-mpath.c#L6=
12
>
> For your testing, perhaps you just remove that if(!pgpath) condition.
>
> Regards,
> Martin
>

That's correct, thanks. It works as expected after removing that condition.

With some limited testing using fio, I don't see any obvious negative
impacts of allowing choose_pgpath to run each bio mapping. I also don't see
any significant increase in CPU usage or IO latency during benchmarking.

The FIXME comment acknowledges that this sort of defeats the balancing
function of multipath, so I'm assuming this was removed for a good reason.
Does anyone know why this was done? In my particular use case, I benefit
from balancing the paths for throughput, so it's useful to me.

Thanks!
- Drew

--00000000000014c4cb059831ce1b
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr" class=3D"gmail_attr">On Mon, Nov 25, 2019=
 at 12:48 PM Martin Wilck &lt;<a href=3D"mailto:mwilck@suse.de">mwilck@suse=
.de</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"marg=
in:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1e=
x"><br>
I think you are seeing this FIXME:<br>
<br>
<a href=3D"https://elixir.bootlin.com/linux/v4.19.79/source/drivers/md/dm-m=
path.c#L612" rel=3D"noreferrer" target=3D"_blank">https://elixir.bootlin.co=
m/linux/v4.19.79/source/drivers/md/dm-mpath.c#L612</a><br>
<br>
For your testing, perhaps you just remove that if(!pgpath) condition.<br>
<br>
Regards,<br>
Martin<br></blockquote><br>That&#39;s correct, thanks. It works as expected=
 after removing that condition.<br><br>With some limited testing using fio,=
 I don&#39;t see any obvious negative impacts of allowing=C2=A0choose_pgpat=
h to run each bio mapping. I also don&#39;t see any significant increase in=
 CPU usage or IO latency during benchmarking.<br><br>The FIXME comment ackn=
owledges that this sort of defeats the balancing function of multipath, so =
I&#39;m assuming this was removed for a good reason. Does anyone know why t=
his was done? In my particular use case, I benefit from balancing the paths=
 for throughput, so it&#39;s useful to me.<br><br>Thanks!<br>- Drew</div>

--00000000000014c4cb059831ce1b--

--===============1772977514116751290==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1772977514116751290==--
