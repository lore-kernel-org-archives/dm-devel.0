From: "George ." <george@ucdn.com>
Subject: Re: dm-cache: dm-3.14-fixes-4
Date: Mon, 17 Mar 2014 16:30:01 +0200
Message-ID: <CAPi_w4y=xGjupEsz7UgHOOH3qFSbcrh+W80Y0QpxvEZR-Uyrzg@mail.gmail.com>
References: <CAPi_w4w8+A=ZPANQRJDzcQWCaxj-aOJbbOePWVjsx8r7pxeWrg@mail.gmail.com>
	<20140317140117.GA7539@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0314904971975814889=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140317140117.GA7539@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

--===============0314904971975814889==
Content-Type: multipart/alternative; boundary=047d7bea39f43a9c8e04f4ce4171

--047d7bea39f43a9c8e04f4ce4171
Content-Type: text/plain; charset=ISO-8859-1

Hi Mike,

Thank you a lot for your very fast response. I'll backport  commit
e0d849fad7 to 3.11.10 and will let you know how dm-cache behaves on
large cache SSD. Probably I will check the code for other truncation
issues.



On Mon, Mar 17, 2014 at 4:01 PM, Mike Snitzer <snitzer@redhat.com> wrote:

> On Mon, Mar 17 2014 at  9:43am -0400,
> George . <george@ucdn.com> wrote:
>
> > Hi,
> >
> > In dm-3.14-fixes-4, there is a description that :
> >
> > - fix corruption with >2TB fast device due to truncation bug
> > But looking at the diffidence I can't find anything related to such bug.
>
> Commit 8b9d96666529 ("dm cache: fix truncation bug when copying a block
> to/from >2TB fast device") follows the same pattern as commit e0d849fad7
> ("dm cache: fix truncation bug when mapping I/O to >2TB fast device").
> Which is that from_cblock() only returns a 32bit value, so any 64bit
> math operation must use a type that can accomodate 64bit.  That is why
> an intermediate sector_t value is now used in both commits.
>
> > I'm asking this, because we are trying to use dm-cache on machine with
> 2.4
> > TB SDD cache and after I took following fix:
> >
> > dm-3.14-fixes-1
> > dm cache: fix truncation bug when mapping I/O to >2TB fast device
> > dm-3.14-fixes-1<
> http://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/tag/?id=dm-3.14-fixes-1
> >
> >
> > our cached device got corrupted again.
>
> Commit e0d849fad7 wouldn't have been the cause.  If you didn't also
> apply 8b9d96666529 then you could have hit that one.
>
> > My question is: is there another truncation bug discovered?
>
> Yeah, both the above referenced commits (commit 8b9d96666529 being the
> most recent).
>
> > I've back ported  dm-3.14-fixes-1 to 3.11.10 kernel, because when we
> tested
> > v3.14-rc5<
> http://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/tag/?id=v3.14-rc5
> >
> > -
> > cached device was corrupted after ~15 minutes and seems to be more
> > unstable.
>
> OK, well upstream dm-cache saw very little change for 3.14.  Just a
> handful of bug fixes.  So you're likely hitting an outstanding bug that
> we've yet to fix.  One issue that is being actively pursued is the
> thought that discards could be contributing to corruption.  Heinz will
> have an update on this line of discovery soon.
>

--047d7bea39f43a9c8e04f4ce4171
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><pre style=3D"color:rgb(0,0,0)">Hi Mike,</pre><pre style=
=3D"color:rgb(0,0,0)">Thank you a lot for your very fast response. I&#39;ll=
 backport <span style=3D"font-family:arial"> commit e0d849fad7 to 3.11.10 a=
nd will let you know how dm-cache behaves on large cache SSD. Probably I wi=
ll check the code for other truncation issues.</span></pre>
</div><div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">On Mon,=
 Mar 17, 2014 at 4:01 PM, Mike Snitzer <span dir=3D"ltr">&lt;<a href=3D"mai=
lto:snitzer@redhat.com" target=3D"_blank">snitzer@redhat.com</a>&gt;</span>=
 wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"">On Mon, Mar 17 2014 at =A09:=
43am -0400,<br>
George . &lt;<a href=3D"mailto:george@ucdn.com">george@ucdn.com</a>&gt; wro=
te:<br>
<br>
&gt; Hi,<br>
&gt;<br>
&gt; In dm-3.14-fixes-4, there is a description that :<br>
&gt;<br>
&gt; - fix corruption with &gt;2TB fast device due to truncation bug<br>
&gt; But looking at the diffidence I can&#39;t find anything related to suc=
h bug.<br>
<br>
</div>Commit 8b9d96666529 (&quot;dm cache: fix truncation bug when copying =
a block<br>
to/from &gt;2TB fast device&quot;) follows the same pattern as commit e0d84=
9fad7<br>
(&quot;dm cache: fix truncation bug when mapping I/O to &gt;2TB fast device=
&quot;).<br>
Which is that from_cblock() only returns a 32bit value, so any 64bit<br>
math operation must use a type that can accomodate 64bit. =A0That is why<br=
>
an intermediate sector_t value is now used in both commits.<br>
<div class=3D""><br>
&gt; I&#39;m asking this, because we are trying to use dm-cache on machine =
with 2.4<br>
&gt; TB SDD cache and after I took following fix:<br>
&gt;<br>
&gt; dm-3.14-fixes-1<br>
&gt; dm cache: fix truncation bug when mapping I/O to &gt;2TB fast device<b=
r>
</div>&gt; dm-3.14-fixes-1&lt;<a href=3D"http://git.kernel.org/cgit/linux/k=
ernel/git/device-mapper/linux-dm.git/tag/?id=3Ddm-3.14-fixes-1" target=3D"_=
blank">http://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.g=
it/tag/?id=3Ddm-3.14-fixes-1</a>&gt;<br>

<div class=3D"">&gt;<br>
&gt; our cached device got corrupted again.<br>
<br>
</div>Commit e0d849fad7 wouldn&#39;t have been the cause. =A0If you didn&#3=
9;t also<br>
apply 8b9d96666529 then you could have hit that one.<br>
<div class=3D""><br>
&gt; My question is: is there another truncation bug discovered?<br>
<br>
</div>Yeah, both the above referenced commits (commit 8b9d96666529 being th=
e<br>
most recent).<br>
<div class=3D""><br>
&gt; I&#39;ve back ported =A0dm-3.14-fixes-1 to 3.11.10 kernel, because whe=
n we tested<br>
</div>&gt; v3.14-rc5&lt;<a href=3D"http://git.kernel.org/cgit/linux/kernel/=
git/device-mapper/linux-dm.git/tag/?id=3Dv3.14-rc5" target=3D"_blank">http:=
//git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/tag/?id=
=3Dv3.14-rc5</a>&gt;<br>

<div class=3D"">&gt; -<br>
&gt; cached device was corrupted after ~15 minutes and seems to be more<br>
&gt; unstable.<br>
<br>
</div>OK, well upstream dm-cache saw very little change for 3.14. =A0Just a=
<br>
handful of bug fixes. =A0So you&#39;re likely hitting an outstanding bug th=
at<br>
we&#39;ve yet to fix. =A0One issue that is being actively pursued is the<br=
>
thought that discards could be contributing to corruption. =A0Heinz will<br=
>
have an update on this line of discovery soon.<br>
</blockquote></div><br></div>

--047d7bea39f43a9c8e04f4ce4171--


--===============0314904971975814889==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0314904971975814889==--
