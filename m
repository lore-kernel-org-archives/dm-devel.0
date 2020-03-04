From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull] device mapper fixes for 5.6-rc5
Date: Wed, 4 Mar 2020 13:34:23 -0600
Message-ID: <CAHk-=wjdzxSGRLVHheRd1WA_FhsAMEV5pOwy08x8NaMG7ty8DQ@mail.gmail.com>
References: <20200304150257.GA19885@redhat.com>
	<CAHk-=wgP=q648JXn8Hd9q7DuNaOEpLmxQp2W3RO3vkaD2CS_9g@mail.gmail.com>
	<20200304192335.GA24296@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6447981215970492768=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200304192335.GA24296@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Theodore Ts'o <tytso@mit.edu>, linux-block <linux-block@vger.kernel.org>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Hou Tao <houtao1@huawei.com>, Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

--===============6447981215970492768==
Content-Type: multipart/alternative; boundary="000000000000a5a14a05a00c8262"

--000000000000a5a14a05a00c8262
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 4, 2020, 13:23 Mike Snitzer <snitzer@redhat.com> wrote:

>
> These versions are for userspace's benefit (be it lvm2, cryptsetup,
> multipath-tools, etc).  But yes, these versions are bogus even for
> that -- primarily because it requires userspace to know when a
> particular feature/fix it cares about was introduced.  In addition: if
> fixes, that also bump version, are marked for stable@ then we're quickly
> in versioning hell -- which is why I always try to decouple version
> bumps from fixes.
>

Yeah, I think the drm people used to have a version number too, and it's
not just fixes getting backported to stable - it's distro kernels taking
changes for new hardware without taking other parts etc.

So the versioning ends up not ever working reliably anyway - the same way
that you can't use the kernel version number to determine what system calls
are available.

So versions can not ever be anything more than informational, and it's
usually just very confusing to have multiple different version numbers (ie
"I'm running kernel v5.4, and my driver abc version is 1.4.2a" is *not* in
the least helpful).

Others have suggested setting feature flags.  I expect you'd hate those
> too.  I suspect I quickly would too given flag bits are finite and
> really tedious to deal with.
>

It also leads to some people then thinking it's ok to remove features
(perhaps to reimplement them differently) if they only clear the feature
bit.

And no, it's not how kernel interfaces work. We keep the interfaces even if
the internals change.

So I've been suggesting that people just freeze the version, or remove the
interface entirely is possible.

Because otherwise it's just a source of problems, where user space might
refuse to do something that the kernel supports because of some silly
version check...

       Linus

>

--000000000000a5a14a05a00c8262
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto"><div><br><br><div class=3D"gmail_quote"><div dir=3D"ltr" =
class=3D"gmail_attr">On Wed, Mar 4, 2020, 13:23 Mike Snitzer &lt;<a href=3D=
"mailto:snitzer@redhat.com">snitzer@redhat.com</a>&gt; wrote:</div><blockqu=
ote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc s=
olid;padding-left:1ex">
<br>
These versions are for userspace&#39;s benefit (be it lvm2, cryptsetup,<br>
multipath-tools, etc).=C2=A0 But yes, these versions are bogus even for<br>
that -- primarily because it requires userspace to know when a<br>
particular feature/fix it cares about was introduced.=C2=A0 In addition: if=
<br>
fixes, that also bump version, are marked for stable@ then we&#39;re quickl=
y<br>
in versioning hell -- which is why I always try to decouple version<br>
bumps from fixes.<br></blockquote></div></div><div dir=3D"auto"><br></div><=
div dir=3D"auto">Yeah, I think the drm people used to have a version number=
 too, and it&#39;s not just fixes getting backported to stable - it&#39;s d=
istro kernels taking changes for new hardware without taking other parts et=
c.</div><div dir=3D"auto"><br></div><div dir=3D"auto">So the versioning end=
s up not ever working reliably anyway - the same way that you can&#39;t use=
 the kernel version number to determine what system calls are available.</d=
iv><div dir=3D"auto"><br></div><div dir=3D"auto">So versions can not ever b=
e anything more than informational, and it&#39;s usually just very confusin=
g to have multiple different version numbers (ie &quot;I&#39;m running kern=
el v5.4, and my driver abc version is 1.4.2a&quot; is *not* in the least he=
lpful).</div><div dir=3D"auto"><br></div><div dir=3D"auto"><div class=3D"gm=
ail_quote"><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;bor=
der-left:1px #ccc solid;padding-left:1ex">
Others have suggested setting feature flags.=C2=A0 I expect you&#39;d hate =
those<br>
too.=C2=A0 I suspect I quickly would too given flag bits are finite and<br>
really tedious to deal with.<br></blockquote></div></div><div dir=3D"auto">=
<br></div><div dir=3D"auto">It also leads to some people then thinking it&#=
39;s ok to remove features (perhaps to reimplement them differently) if the=
y only clear the feature bit.</div><div dir=3D"auto"><br></div><div dir=3D"=
auto">And no, it&#39;s not how kernel interfaces work. We keep the interfac=
es even if the internals change.=C2=A0</div><div dir=3D"auto"><br></div><di=
v dir=3D"auto">So I&#39;ve been suggesting that people just freeze the vers=
ion, or remove the interface entirely is possible.</div><div dir=3D"auto"><=
br></div><div dir=3D"auto">Because otherwise it&#39;s just a source of prob=
lems, where user space might refuse to do something that the kernel support=
s because of some silly version check...</div><div dir=3D"auto"><br></div><=
div dir=3D"auto">=C2=A0 =C2=A0 =C2=A0 =C2=A0Linus</div><div dir=3D"auto"><d=
iv class=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"margin:=
0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
</blockquote></div></div></div>

--000000000000a5a14a05a00c8262--

--===============6447981215970492768==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6447981215970492768==--
