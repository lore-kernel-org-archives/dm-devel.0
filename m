From: Drew Hastings <dhastings@crucialwebhost.com>
Subject: Re: Is thin provisioning still experimental?
Date: Fri, 3 Aug 2018 20:13:54 -0700
Message-ID: <CAN-y+E+9J5w8fx-UYcT9+2SxqFL8nzkn3BYE6cWpW=yP9KdDtA@mail.gmail.com>
References: <CAN-y+EK612pGsJTH-zO=FU0DpcFJxKfEHuDNs+6ufE6we9aK+g@mail.gmail.com>
	<20180723140053.GA28984@redhat.com> <20180723140734.GB28984@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4710226319292279821=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180723140734.GB28984@redhat.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============4710226319292279821==
Content-Type: multipart/alternative; boundary="00000000000030cd0f0572936fa7"

--00000000000030cd0f0572936fa7
Content-Type: text/plain; charset="UTF-8"

Thank you for that insight, I appreciate it.

Can you elaborate on your concern related to running out of space?

Assuming the metadata device always has space, is it unsafe to let the the
data device for the thin pool run out of space if queue_if_no_space is set?
Would it not be safe on the block IO level?

> No idea what, if any, filesystem you intend to run but XFS has the
ability to discontinue retries for certain error conditions.  I highly
recommend you enable that for ENOSPC, otherwise you _will_ see the kernel
block indefinitely in XFS if thinp runs out of space underneath XFS.

My use case involves doing block level IO for virtual machines with KVM...
so there's virtualization in between the thin device and whatever the VM is
doing. In that scenario, I would expect the IO requests to just hang until
the thin pool is provided more space for the data device and queued IO from
the VM would just wait for that. Maybe what you're describing with XFS
wouldn't be an issue on that setup, since XFS would be running within the
VM.

On Mon, Jul 23, 2018 at 7:07 AM, Mike Snitzer <snitzer@redhat.com> wrote:

> On Mon, Jul 23 2018 at 10:00am -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:
>
> > On Mon, Jul 23 2018 at  1:06am -0400,
> > Drew Hastings <dhastings@crucialwebhost.com> wrote:
> >
> > >    I love all of the work you guys do @dm-devel . Thanks for taking
> the time
> > >    to read this.
> > >    I would like to use thin provisioning targets in production, but
> it's hard
> > >    to ignore the warning in the documentation. It seems like, with an
> > >    understanding of how thin provisioning works, it should be safe to
> use.
> >
> > It is stale.  I just committed this update that'll go upstream for the
> > 4.19 merge window, see:
> > https://git.kernel.org/pub/scm/linux/kernel/git/device-
> mapper/linux-dm.git/commit/?h=dm-4.19&id=f88a3f746ff0047c92e8312646247b
> 08264daf35
> >
> > >    If the metadata and data device for the thin pool have enough space
> and
> > >    are both error free, the kernel has plenty of free RAM, block sizes
> are
> > >    set large enough to never run into performance issues (64 MiB), all
> of the
> > >    underlying hardware is redundant on high performance NVME (no
> worries of
> > >    fragmentation of data volume)... is it still unsafe for production?
> If so,
> > >    can you shed some light on why that is?
> >
> > It is safe.  You do just want to make sure to not run out of space.  We
> > now handle that event favorably but it is best to tempt fate.
>
> I meant: "... but it is best to _not_ tempt fate."
>

--00000000000030cd0f0572936fa7
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Thank you for that insight, I appreciate it.</div><di=
v><br></div>Can you elaborate on your concern related to running out of spa=
ce?<br><br>Assuming the metadata device always has space, is it unsafe to l=
et the the data device for the thin pool run out of space if queue_if_no_sp=
ace is set?=C2=A0<span style=3D"font-size:small;text-decoration-style:initi=
al;text-decoration-color:initial;float:none;display:inline">W</span>ould it=
 not be safe on the block IO level?<br><br>&gt;=C2=A0<span style=3D"font-si=
ze:12.8px;text-decoration-style:initial;text-decoration-color:initial;float=
:none;display:inline">No idea=C2=A0</span><span style=3D"font-size:12.8px;t=
ext-decoration-style:initial;text-decoration-color:initial;float:none;displ=
ay:inline">what, if any, filesystem you intend to run but XFS has the abili=
ty to=C2=A0</span><span style=3D"font-size:12.8px;text-decoration-style:ini=
tial;text-decoration-color:initial;float:none;display:inline">discontinue r=
etries for certain error conditions.=C2=A0 I highly recommend=C2=A0</span><=
span style=3D"font-size:12.8px;text-decoration-style:initial;text-decoratio=
n-color:initial;float:none;display:inline">you enable that for ENOSPC, othe=
rwise you _will_ see the kernel block=C2=A0</span><span style=3D"font-size:=
12.8px;text-decoration-style:initial;text-decoration-color:initial;float:no=
ne;display:inline">indefinitely in XFS if thinp runs out of space underneat=
h XFS.<br><br>My use case involves doing block level IO for virtual machine=
s with KVM... so there&#39;s virtualization in between the thin device and =
whatever the VM is doing. In that scenario, I would expect the IO requests =
to just hang until the thin pool is provided more space for the data device=
 and queued IO from the VM would just wait for that. Maybe what you&#39;re =
describing with XFS wouldn&#39;t be an issue on that setup, since XFS would=
 be running within the VM.</span></div><div class=3D"gmail_extra"><br><div =
class=3D"gmail_quote">On Mon, Jul 23, 2018 at 7:07 AM, Mike Snitzer <span d=
ir=3D"ltr">&lt;<a href=3D"mailto:snitzer@redhat.com" target=3D"_blank">snit=
zer@redhat.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" s=
tyle=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><spa=
n class=3D"">On Mon, Jul 23 2018 at 10:00am -0400,<br>
Mike Snitzer &lt;<a href=3D"mailto:snitzer@redhat.com">snitzer@redhat.com</=
a>&gt; wrote:<br>
<br>
&gt; On Mon, Jul 23 2018 at=C2=A0 1:06am -0400,<br>
&gt; Drew Hastings &lt;<a href=3D"mailto:dhastings@crucialwebhost.com">dhas=
tings@crucialwebhost.com</a>&gt; wrote:<br>
&gt; <br>
&gt; &gt;=C2=A0 =C2=A0 I love all of the work you guys do @dm-devel . Thank=
s for taking the time<br>
&gt; &gt;=C2=A0 =C2=A0 to read this.<br>
&gt; &gt;=C2=A0 =C2=A0 I would like to use thin provisioning targets in pro=
duction, but it&#39;s hard<br>
&gt; &gt;=C2=A0 =C2=A0 to ignore the warning in the documentation. It seems=
 like, with an<br>
&gt; &gt;=C2=A0 =C2=A0 understanding of how thin provisioning works, it sho=
uld be safe to use.<br>
&gt; <br>
&gt; It is stale.=C2=A0 I just committed this update that&#39;ll go upstrea=
m for the<br>
&gt; 4.19 merge window, see:<br>
&gt; <a href=3D"https://git.kernel.org/pub/scm/linux/kernel/git/device-mapp=
er/linux-dm.git/commit/?h=3Ddm-4.19&amp;id=3Df88a3f746ff0047c92e8312646247b=
08264daf35" rel=3D"noreferrer" target=3D"_blank">https://git.kernel.org/pub=
/<wbr>scm/linux/kernel/git/device-<wbr>mapper/linux-dm.git/commit/?h=3D<wbr=
>dm-4.19&amp;id=3D<wbr>f88a3f746ff0047c92e8312646247b<wbr>08264daf35</a><br=
>
&gt; <br>
&gt; &gt;=C2=A0 =C2=A0 If the metadata and data device for the thin pool ha=
ve enough space and<br>
&gt; &gt;=C2=A0 =C2=A0 are both error free, the kernel has plenty of free R=
AM, block sizes are<br>
&gt; &gt;=C2=A0 =C2=A0 set large enough to never run into performance issue=
s (64 MiB), all of the<br>
&gt; &gt;=C2=A0 =C2=A0 underlying hardware is redundant on high performance=
 NVME (no worries of<br>
&gt; &gt;=C2=A0 =C2=A0 fragmentation of data volume)... is it still unsafe =
for production? If so,<br>
&gt; &gt;=C2=A0 =C2=A0 can you shed some light on why that is?<br>
&gt; <br>
&gt; It is safe.=C2=A0 You do just want to make sure to not run out of spac=
e.=C2=A0 We<br>
&gt; now handle that event favorably but it is best to tempt fate.<br>
<br>
</span>I meant: &quot;... but it is best to _not_ tempt fate.&quot;<br>
</blockquote></div><br></div>

--00000000000030cd0f0572936fa7--


--===============4710226319292279821==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4710226319292279821==--
