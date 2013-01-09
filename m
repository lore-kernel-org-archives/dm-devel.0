From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Bcache upstreaming
Date: Wed, 9 Jan 2013 11:01:13 -0500
Message-ID: <CAMM=eLdJ18zr1kbMhK+nGKQZrzRXSN9iOaPKXt=or_iuyD3P2A@mail.gmail.com>
References: <20130104235040.GA26407@google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4526563176508570106=="
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

--===============4526563176508570106==
Content-Type: multipart/alternative; boundary=bcaec55556541d954004d2dd2d15

--bcaec55556541d954004d2dd2d15
Content-Type: text/plain; charset=ISO-8859-1

(take 2 since linux-bcache rejected the mail due to HTML parts.. gmail's
new interface is a dream ;)

Hey Kent,

On Fri, Jan 4, 2013 at 6:50 PM, Kent Overstreet <koverstreet@google.com>
wrote:
>
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

--bcaec55556541d954004d2dd2d15
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">(take 2 since linux-bcache rejected the mail due to HTML p=
arts.. gmail&#39;s new interface is a dream ;)<br><br>Hey Kent,<br><br>On F=
ri, Jan 4, 2013 at 6:50 PM, Kent Overstreet &lt;<a href=3D"mailto:koverstre=
et@google.com">koverstreet@google.com</a>&gt; wrote:<br>

&gt;<br>&gt; I&#39;ve (finally!) got a bcache branch hacked up that ought t=
o be suitable<br>&gt; to go upstream, possibly in staging initially.<br>&gt=
;<br>&gt; It&#39;s currently closer to the dev branch than the stable branc=
h, plus<br>

&gt; some additional minor changes to make it all more self contained. The<=
br>&gt; code has seen a decent amount of testing and I think it&#39;s in go=
od shape,<br>&gt; but I&#39;d like it if it could see a bit more testing be=
fore I see about<br>

&gt; pushing it upstream.<br>&gt;<br>&gt; If anyone wants to try it out, ch=
eckout the bcache-for-staging branch.<br>&gt; It&#39;s against Linux 3.7.<b=
r><br><br>I pulled your &#39;bcache-for-staging&#39; code into a &#39;dm-de=
vel-cache-bcache&#39; branch on my github:<br>

<a href=3D"https://github.com/snitm/linux">https://github.com/snitm/linux</=
a><br><br>Purpose is to have a single kernel to compare dm-cache and bcache=
. =A0My branch is against 3.8-rc2. =A0While importing your code I needed th=
e following change to get bcache to compile:<br>

<a href=3D"https://github.com/snitm/linux/commit/400b1257e93975864fd6c4b827=
537a0234551253">https://github.com/snitm/linux/commit/400b1257e93975864fd6c=
4b827537a0234551253</a><br><br>It now builds without issue but I haven&#39;=
t tested the resulting bcache to know if I broke the sysfs interface due to=
 s/cache/bcache/ on some local variables, I don&#39;t think I did but I&#39=
;ll defer to you. =A0(BTW those crafty sysfs macros you have were pretty op=
aque; not really seeing what they buy in the grand scheme. =A0And #include =
&quot;sysfs.c&quot; is different than any code I&#39;ve seen in the kernel)=
.</div>


--bcaec55556541d954004d2dd2d15--


--===============4526563176508570106==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4526563176508570106==--
