From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: staged dm_internal_{suspend,
 resume} related changes for wider review
Date: Mon, 3 Nov 2014 19:17:36 -0500
Message-ID: <CAMM=eLd8iuMDtNr7f4Cu97ZEua3-pOW4pdSdVKji7g02mKXFwQ@mail.gmail.com>
References: <20141028014825.GA21949@redhat.com> <544F988D.7090901@redhat.com>
	<20141028134012.GA25229@redhat.com>
	<20141028141749.GD25229@redhat.com>
	<20141028143742.GE25229@redhat.com>
	<20141028171003.GG25229@redhat.com>
	<20141028224753.GA29288@redhat.com>
	<20141028232638.GB29288@redhat.com>
	<20141029002125.GC29288@redhat.com>
	<20141029012256.GF29288@redhat.com>
	<alpine.LRH.2.02.1411031823100.29299@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3143489642695859123=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1411031823100.29299@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: ejt@redhat.com, "Bryn M. Reeves" <breeves@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

--===============3143489642695859123==
Content-Type: multipart/alternative; boundary=047d7b342ba6ea4f4e0506fd63c0

--047d7b342ba6ea4f4e0506fd63c0
Content-Type: text/plain; charset=UTF-8

On Nov 3, 2014 6:27 PM, "Mikulas Patocka" <mpatocka@redhat.com> wrote:
>
>
>
> On Tue, 28 Oct 2014, Mike Snitzer wrote:
>
> > I pushed rebased versions of these patches to linux-dm.git's
> > 'dm-for-3.19' branch (and pulled into 'for-next' purely to get the
> > kernel.org autobuilders testing the code).  See top 3 commits here:
> >
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-for-3.19
> >
> > I'm open to any and all changes or dropping code entirely; so me staging
> > like this is just to keep the review ball rolling as quickly as
> > possible.
> >
> > But in particular we need to get Mikulas' and Bryn's feedback on how the
> > dm_internal_{suspend,resume} changes impact dm-stats.
> >
> > Mike
>
> Hi
>
> As I said on irc - it is not correct to take a mutex from one syscall and
> drop the mutex from another syscall.

I didn't modify that aspect of dm_internal_suspend+resume.  I only extended
the interface to other targets via export.

> I hope Joe can use the bio prison to block bios while the pool is
> suspended.

We'll see.

--047d7b342ba6ea4f4e0506fd63c0
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<p dir=3D"ltr"><br>
On Nov 3, 2014 6:27 PM, &quot;Mikulas Patocka&quot; &lt;<a href=3D"mailto:m=
patocka@redhat.com">mpatocka@redhat.com</a>&gt; wrote:<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; On Tue, 28 Oct 2014, Mike Snitzer wrote:<br>
&gt;<br>
&gt; &gt; I pushed rebased versions of these patches to linux-dm.git&#39;s<=
br>
&gt; &gt; &#39;dm-for-3.19&#39; branch (and pulled into &#39;for-next&#39; =
purely to get the<br>
&gt; &gt; <a href=3D"http://kernel.org">kernel.org</a> autobuilders testing=
 the code).=C2=A0 See top 3 commits here:<br>
&gt; &gt; <a href=3D"https://git.kernel.org/cgit/linux/kernel/git/device-ma=
pper/linux-dm.git/log/?h=3Ddm-for-3.19">https://git.kernel.org/cgit/linux/k=
ernel/git/device-mapper/linux-dm.git/log/?h=3Ddm-for-3.19</a><br>
&gt; &gt;<br>
&gt; &gt; I&#39;m open to any and all changes or dropping code entirely; so=
 me staging<br>
&gt; &gt; like this is just to keep the review ball rolling as quickly as<b=
r>
&gt; &gt; possible.<br>
&gt; &gt;<br>
&gt; &gt; But in particular we need to get Mikulas&#39; and Bryn&#39;s feed=
back on how the<br>
&gt; &gt; dm_internal_{suspend,resume} changes impact dm-stats.<br>
&gt; &gt;<br>
&gt; &gt; Mike<br>
&gt;<br>
&gt; Hi<br>
&gt;<br>
&gt; As I said on irc - it is not correct to take a mutex from one syscall =
and<br>
&gt; drop the mutex from another syscall.</p>
<p dir=3D"ltr">I didn&#39;t modify that aspect of dm_internal_suspend+resum=
e.=C2=A0 I only extended the interface to other targets via export.</p>
<p dir=3D"ltr">&gt; I hope Joe can use the bio prison to block bios while t=
he pool is<br>
&gt; suspended.</p>
<p dir=3D"ltr">We&#39;ll see.<br>
</p>

--047d7b342ba6ea4f4e0506fd63c0--


--===============3143489642695859123==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3143489642695859123==--
