From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Bcache upstreaming
Date: Wed, 9 Jan 2013 10:49:04 -0500
Message-ID: <CAMM=eLeeh6jb28KXGE9ZBbkMV1ysE-6NH2BjfpTsQcHAawEs+w@mail.gmail.com>
References: <20130104235040.GA26407@google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3488764363398084112=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130104235040.GA26407@google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============3488764363398084112==
Content-Type: multipart/alternative; boundary=bcaec554dd00b2ea2804d2dd015a

--bcaec554dd00b2ea2804d2dd015a
Content-Type: text/plain; charset=ISO-8859-1

Hey Kent,

On Fri, Jan 4, 2013 at 6:50 PM, Kent Overstreet <koverstreet@google.com>wrote:

> I've (finally!) got a bcache branch hacked up that ought to be suitable
> to go upstream, possibly in staging initially.
>
> It's currently closer to the dev branch than the stable branch, plus
> some additional minor changes to make it all more self contained. The
> code has seen a decent amount of testing and I think it's in good shape,
> but I'd like it if it could see a bit more testing before I see about
> pushing it upstream.
>
> If anyone wants to try it out, checkout the bcache-for-staging branch.
> It's against Linux 3.7.


I pulled your 'bcache-for-staging' code into a 'dm-devel-cache-bcache'
branch on my github:
https://github.com/snitm/linux

Purpose is to have a single kernel to compare dm-cache and bcache.  My
branch is against 3.8-rc2.  While importing your code I needed the
following change to get bcache to compile:
https://github.com/snitm/linux/commit/400b1257e93975864fd6c4b827537a0234551253

It now builds without issue but I haven't tested the resulting bcache to
know if I broke the sysfs interface due to s/cache/bcache/ on some local
variables, I don't think I did but I'll defer to you.  (BTW those crafty
sysfs macros you have were pretty opaque; not really seeing what they buy
in the grand scheme.  And #include "sysfs.c" is different than any code
I've seen in the kernel).

--bcaec554dd00b2ea2804d2dd015a
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_extra">Hey Kent,<br><br><div class=
=3D"gmail_quote">On Fri, Jan 4, 2013 at 6:50 PM, Kent Overstreet <span dir=
=3D"ltr">&lt;<a href=3D"mailto:koverstreet@google.com" target=3D"_blank">ko=
verstreet@google.com</a>&gt;</span> wrote:<br>

<blockquote class=3D"gmail_quote" style=3D"margin-top:0px;margin-right:0px;=
margin-bottom:0px;margin-left:0.8ex;border-left-width:1px;border-left-color=
:rgb(204,204,204);border-left-style:solid;padding-left:1ex">I&#39;ve (final=
ly!) got a bcache branch hacked up that ought to be suitable<br>


to go upstream, possibly in staging initially.<br>
<br>
It&#39;s currently closer to the dev branch than the stable branch, plus<br=
>
some additional minor changes to make it all more self contained. The<br>
code has seen a decent amount of testing and I think it&#39;s in good shape=
,<br>
but I&#39;d like it if it could see a bit more testing before I see about<b=
r>
pushing it upstream.<br>
<br>
If anyone wants to try it out, checkout the bcache-for-staging branch.<br>
It&#39;s against Linux 3.7.</blockquote><div><br></div><div>I pulled your &=
#39;bcache-for-staging&#39; code into a &#39;dm-devel-cache-bcache&#39; bra=
nch on my github:</div><div><a href=3D"https://github.com/snitm/linux">http=
s://github.com/snitm/linux</a><br>

</div><div><br></div><div>Purpose is to have a single kernel to compare dm-=
cache and bcache. =A0My branch is against 3.8-rc2. =A0While importing your =
code I needed the following change to get bcache to compile:</div><div><a h=
ref=3D"https://github.com/snitm/linux/commit/400b1257e93975864fd6c4b827537a=
0234551253">https://github.com/snitm/linux/commit/400b1257e93975864fd6c4b82=
7537a0234551253</a><br>

</div><div><br></div><div>It now builds without issue but I haven&#39;t tes=
ted the resulting bcache to know if I broke the sysfs interface due to s/ca=
che/bcache/ on some local variables, I don&#39;t think I did but I&#39;ll d=
efer to you. =A0(BTW those crafty sysfs macros you have were pretty opaque;=
 not really seeing what they buy in the grand scheme. =A0And #include &quot=
;sysfs.c&quot; is different than any code I&#39;ve seen in the kernel).</di=
v>

</div></div></div>

--bcaec554dd00b2ea2804d2dd015a--


--===============3488764363398084112==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3488764363398084112==--
