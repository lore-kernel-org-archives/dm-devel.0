From: Thanos Makatos <thanos.makatos@onapp.com>
Subject: Re: dm-cache metadata memory footprint
Date: Thu, 5 Mar 2015 14:27:02 +0000
Message-ID: <CAM2wQBu2G1=Vndt+R6hh9fKVdv50j3_JHeLrAfJLC=ZuKt39Fg@mail.gmail.com>
References: <CAM2wQBvH8cjKes5MVvFQtcOkiu5NVM9DD2i8qEqDQBKSyvHboQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============9179880953332830080=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAM2wQBvH8cjKes5MVvFQtcOkiu5NVM9DD2i8qEqDQBKSyvHboQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, thornber@redhat.com, heinzm@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

--===============9179880953332830080==
Content-Type: multipart/alternative; boundary=001a11c3bcbc8bab2e05108b5cc0

--001a11c3bcbc8bab2e05108b5cc0
Content-Type: text/plain; charset=UTF-8

Ping!

I'd like to generalize my question to what is the general memory footprint
of dm-cache. Does dm-cache keeps all metadata in memory or only part of it?
Are there any other memory overheads? Are the metadata pinned or
dynamically cached, according to available memory? I need to know such
information in order to tell whether my system has currently enough
resources to create a dm-cache target.

I understand that the metadata size is dictated by the size of the SSD and
the size of the disk doesn't have anything to do with it. To test how
memory utilization is affected, I created one hundred 1 GB dm-cache targets
using 128 KB cache block size. I calculated the size of the metadata
according to
https://www.redhat.com/archives/dm-devel/2012-December/msg00046.html, which
is 4.12 MB per dm-cache target. Memory utilization did increase but not as
much as I expected: it increased by 183 MB and not by 4.12*100 which would
be the case if all metadata were kept in memory. (I didn't do any I/O to
the dm-cache targets.)

If this information is not readily available, are there any specific parts
in the code I should focus in order to figure  this out?

On Tue, Feb 17, 2015 at 12:22 PM, Thanos Makatos <thanos.makatos@onapp.com>
wrote:

> Is there some formula that could indicate the metadata memory footprint of
> dm-cache for given SSD and HDD capacities? Is there anything else that
> would affect the metadata footprint (e.g. write-through vs. write back,
> cache line size, etc.)?
>

--001a11c3bcbc8bab2e05108b5cc0
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Ping!</div><div><br></div>I&#39;d like to generalize =
my question to what is the general memory footprint of dm-cache. Does dm-ca=
che keeps all metadata in memory or only part of it? Are there any other me=
mory overheads? Are the metadata pinned or dynamically cached, according to=
 available memory? I need to know such information in order to tell whether=
 my system has currently enough resources to create a dm-cache target.<div>=
<br><div><div>I understand that the metadata size is dictated by the size o=
f the SSD and the size of the disk doesn&#39;t have anything to do with it.=
 To test how memory utilization is affected, I created one hundred 1 GB dm-=
cache targets using 128 KB cache block size. I calculated the size of the m=
etadata according to=C2=A0<a href=3D"https://www.redhat.com/archives/dm-dev=
el/2012-December/msg00046.html" target=3D"_blank">https://www.redhat.com/ar=
chives/dm-devel/2012-December/msg00046.html</a>, which is 4.12 MB per dm-ca=
che target. Memory utilization did increase but not as much as I expected: =
it increased by 183 MB and not by 4.12*100 which would be the case if all m=
etadata were kept in memory. (I didn&#39;t do any I/O to the dm-cache targe=
ts.)</div></div></div><div><br></div><div>If this information is not readil=
y available, are there any specific parts in the code I should focus in ord=
er to figure =C2=A0this out?</div><div class=3D"gmail_extra"><br><div class=
=3D"gmail_quote">On Tue, Feb 17, 2015 at 12:22 PM, Thanos Makatos <span dir=
=3D"ltr">&lt;<a href=3D"mailto:thanos.makatos@onapp.com" target=3D"_blank">=
thanos.makatos@onapp.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmai=
l_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left=
:1ex"><div dir=3D"ltr">Is there some formula that could indicate the metada=
ta memory footprint of dm-cache for given SSD and HDD capacities? Is there =
anything else that would affect the metadata footprint (e.g. write-through =
vs. write back, cache line size, etc.)?</div>
</blockquote></div><br></div></div>

--001a11c3bcbc8bab2e05108b5cc0--


--===============9179880953332830080==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============9179880953332830080==--
