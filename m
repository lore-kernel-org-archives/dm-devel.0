From: Joe Thornber <joe.thornber@gmail.com>
Subject: Re: Make the mq policy an alias for smq
Date: Sat, 27 Feb 2016 08:18:50 +0000
Message-ID: <CAKBOSnh9yWngH5StB44cgaXqVYudvFiBG7AMNDxXS8Fgcu0WFQ@mail.gmail.com>
References: <1455100523-16922-1-git-send-email-ejt@redhat.com>
	<20160211021305.GB4481@redhat.com> <20160211104130.GB5021@rh-vpn>
	<20160226220351.GB27783@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0927098145597709848=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160226220351.GB27783@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, Joe Thornber <ejt@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

--===============0927098145597709848==
Content-Type: multipart/alternative; boundary=001a114325ec5fac9a052cbc1144

--001a114325ec5fac9a052cbc1144
Content-Type: text/plain; charset=UTF-8

Branch 2016-02-10-thin-dev-on-4.4

https://github.com/jthornber/linux-2.6/commit/9b0d197c86371bc4de01dcb7d7b1a49664d5d15e
https://github.com/jthornber/linux-2.6/commit/04a082129113de7c495eb609cdfcbbedc6cab3a3

On Fri, 26 Feb 2016 at 22:03 Mike Snitzer <snitzer@redhat.com> wrote:

> On Thu, Feb 11 2016 at  5:41am -0500,
> Joe Thornber <thornber@redhat.com> wrote:
>
> > On Wed, Feb 10, 2016 at 09:13:05PM -0500, Mike Snitzer wrote:
> > > Shouldn't get_policy()'s call to get_policy_once() resolve "mq" to be
> > > "smq" if we just add this to the bottom of dm-cache-policy-smq?:
> > >
> > > MODULE_ALIAS("dm-cache-mq");
> >
> > Yes, you're right.  See my fixup patch.
>
> Hmm, not seeing what you consider to be the latest fixed up version..
> (nothing that sets: MODULE_ALIAS("dm-cache-mq") in smq.c)
>
> But I've staged this in linux-next for 4.6, see:
>
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=8cbd0cb8cca67baa3e430fb6d636613fdc1cee1a
>

--001a114325ec5fac9a052cbc1144
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><br></div><div>Branch 2016-02-10-thin-dev-on-4.4</div=
><div><br></div><a href=3D"https://github.com/jthornber/linux-2.6/commit/9b=
0d197c86371bc4de01dcb7d7b1a49664d5d15e">https://github.com/jthornber/linux-=
2.6/commit/9b0d197c86371bc4de01dcb7d7b1a49664d5d15e</a><br><div><a href=3D"=
https://github.com/jthornber/linux-2.6/commit/04a082129113de7c495eb609cdfcb=
bedc6cab3a3">https://github.com/jthornber/linux-2.6/commit/04a082129113de7c=
495eb609cdfcbbedc6cab3a3</a><br></div></div><br><div class=3D"gmail_quote">=
<div dir=3D"ltr">On Fri, 26 Feb 2016 at 22:03 Mike Snitzer &lt;<a href=3D"m=
ailto:snitzer@redhat.com">snitzer@redhat.com</a>&gt; wrote:<br></div><block=
quote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc=
 solid;padding-left:1ex">On Thu, Feb 11 2016 at=C2=A0 5:41am -0500,<br>
Joe Thornber &lt;<a href=3D"mailto:thornber@redhat.com" target=3D"_blank">t=
hornber@redhat.com</a>&gt; wrote:<br>
<br>
&gt; On Wed, Feb 10, 2016 at 09:13:05PM -0500, Mike Snitzer wrote:<br>
&gt; &gt; Shouldn&#39;t get_policy()&#39;s call to get_policy_once() resolv=
e &quot;mq&quot; to be<br>
&gt; &gt; &quot;smq&quot; if we just add this to the bottom of dm-cache-pol=
icy-smq?:<br>
&gt; &gt;<br>
&gt; &gt; MODULE_ALIAS(&quot;dm-cache-mq&quot;);<br>
&gt;<br>
&gt; Yes, you&#39;re right.=C2=A0 See my fixup patch.<br>
<br>
Hmm, not seeing what you consider to be the latest fixed up version..<br>
(nothing that sets: MODULE_ALIAS(&quot;dm-cache-mq&quot;) in smq.c)<br>
<br>
But I&#39;ve staged this in linux-next for 4.6, see:<br>
<a href=3D"https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux=
-dm.git/commit/?h=3Dfor-next&amp;id=3D8cbd0cb8cca67baa3e430fb6d636613fdc1ce=
e1a" rel=3D"noreferrer" target=3D"_blank">https://git.kernel.org/cgit/linux=
/kernel/git/device-mapper/linux-dm.git/commit/?h=3Dfor-next&amp;id=3D8cbd0c=
b8cca67baa3e430fb6d636613fdc1cee1a</a><br>
</blockquote></div>

--001a114325ec5fac9a052cbc1144--


--===============0927098145597709848==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0927098145597709848==--
