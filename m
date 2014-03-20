From: Stephen Cousins <steve.cousins-e7X0jjDqjFGHXe+LvDLADg@public.gmane.org>
Subject: Re: trouble with dm-crypt and NFS: server hangs
Date: Thu, 20 Mar 2014 18:12:37 -0400
Message-ID: <CAMFqqRpagfhPcEynmTZFnyGSqvwF52UmJ0bwKTMnrKPMZa0cvw@mail.gmail.com>
References: <CAMFqqRr+hDepUv8LGWbm_RSv=K4ApDbvbsaSAb44Qp1ZaJnNTQ@mail.gmail.com>
 <532B3E8E.5080406@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6115849279999477438=="
Return-path: <dm-crypt-bounces-4q3lyFh4P1g@public.gmane.org>
In-Reply-To: <532B3E8E.5080406-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <http://www.saout.de/mailman/options/dm-crypt>,
 <mailto:dm-crypt-request-4q3lyFh4P1g@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.saout.de/pipermail/dm-crypt/>
List-Post: <mailto:dm-crypt-4q3lyFh4P1g@public.gmane.org>
List-Help: <mailto:dm-crypt-request-4q3lyFh4P1g@public.gmane.org?subject=help>
List-Subscribe: <http://www.saout.de/mailman/listinfo/dm-crypt>,
 <mailto:dm-crypt-request-4q3lyFh4P1g@public.gmane.org?subject=subscribe>
Errors-To: dm-crypt-bounces-4q3lyFh4P1g@public.gmane.org
Sender: "dm-crypt" <dm-crypt-bounces-4q3lyFh4P1g@public.gmane.org>
To: Milan Broz <gmazyland-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: dm-crypt-4q3lyFh4P1g@public.gmane.org, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

--===============6115849279999477438==
Content-Type: multipart/alternative; boundary=047d7b5d5b0a25b5be04f511117d

--047d7b5d5b0a25b5be04f511117d
Content-Type: text/plain; charset=ISO-8859-1

I'm getting mixed results but it is looking like ZFS have something to do
with the problem afterall.

I tried it with dm-crypt -> XFS -> NFS and I'm not seeing the same lag
issue. I say mixed results mainly because I've been using rsync to do the
testing and for some reason rsync has trouble with this setup. It works but
really slowly. Like around 3 MB/sec over a Gigabit link. If I use "cp -pR"
then it goes at 60 MB/sec. I use rsync all the time and I've never seen
this before so it took a while for me to realize that rsync was acting up.
Anyone run into this before?

I'll bring this to the ZFSonLinux people and see what they say.

Thanks,

Steve


On Thu, Mar 20, 2014 at 3:16 PM, Milan Broz <gmazyland-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On 03/20/2014 03:48 PM, Stephen Cousins wrote:
> > I am testing dm-crypt with a system that serves data over NFS. I'm
> > finding that when serving the data over NFS4 it will go for a little
> > while and then it will just stop copying and networking on the NFS
> > server will stall out so that other connections to other parts of the
> > storage (a non-dm-crypt volume) will become very laggy. Soon after
> > canceling the copy the other connections resume back to normal.
> >
> > I have tried this on two different servers, one with a single disk
> > with ZFS and another with a ZFS raidz2 pool and they both do the same
> > thing. CPU doesn't seem to be an issue. Doing local copies is not a
> > problem. That is, copying to/from these volumes made up of dm-crypted
> > disks from other disks on the server have no problems.
> >
> > One system (the one with the RAID pool) is CentOS 6.4 and the other
> > one is CentOS 6.5.
> >
> > I'm curious if anyone else has run into this before and if so, what
> > can be done to make it work? I'm going to test to see if taking ZFS
> > out of the equation helps. I haven't run into this with ZFS with
> > disks without dm-crypt.
>
> Hi,
>
> unfortunately the dmcrypt code in Centos 6.x is not what is upstream
> kernel (mainly because of per cpu processing changes upstream).
> (It would be interesting if it is reproducible with upstream kernel,
> but I guess it is not easy to test...)
>
> I am adding cc to dm-devel list, maybe someone there could have some idea
> how to help here.
>
> Milan
>
> >
> > Thanks,
> >
> > Steve
> >
> >
> >
> > -- ________________________________________________________________
> > Steve Cousins             Supercomputer Engineer/Administrator
> > Advanced Computing Group            University of Maine System 244
> > Neville Hall (UMS Data Center)              (207) 561-3574
> > <tel:%28207%29%20561-3574> Orono ME 04469
> > steve.cousins at maine.edu <http://maine.edu>
>



-- 
________________________________________________________________
 Steve Cousins             Supercomputer Engineer/Administrator
 Advanced Computing Group            University of Maine System
 244 Neville Hall (UMS Data Center)              (207) 561-3574
 Orono ME 04469                      steve.cousins at maine.edu

--047d7b5d5b0a25b5be04f511117d
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:courier =
new,monospace">I&#39;m getting mixed results but it is looking like ZFS hav=
e something to do with the problem afterall.=A0</div><div class=3D"gmail_de=
fault" style=3D"font-family:courier new,monospace">
<br></div><div class=3D"gmail_default" style=3D"font-family:courier new,mon=
ospace">I tried it with dm-crypt -&gt; XFS -&gt; NFS and I&#39;m not seeing=
 the same lag issue. I say mixed results mainly because I&#39;ve been using=
 rsync to do the testing and for some reason rsync has trouble with this se=
tup. It works but really slowly. Like around 3 MB/sec over a Gigabit link. =
If I use &quot;cp -pR&quot; then it goes at 60 MB/sec. I use rsync all the =
time and I&#39;ve never seen this before so it took a while for me to reali=
ze that rsync was acting up. Anyone run into this before?</div>
<div class=3D"gmail_default" style=3D"font-family:courier new,monospace"><b=
r></div><div class=3D"gmail_default" style=3D"font-family:courier new,monos=
pace">I&#39;ll bring this to the ZFSonLinux people and see what they say.</=
div>
<div class=3D"gmail_default" style=3D"font-family:courier new,monospace"><b=
r></div><div class=3D"gmail_default" style=3D"font-family:courier new,monos=
pace">Thanks,</div><div class=3D"gmail_default" style=3D"font-family:courie=
r new,monospace">
<br></div><div class=3D"gmail_default" style=3D"font-family:courier new,mon=
ospace">Steve</div>
</div><div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">On Thu,=
 Mar 20, 2014 at 3:16 PM, Milan Broz <span dir=3D"ltr">&lt;<a href=3D"mailt=
o:gmazyland-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" target=3D"_blank">gmazyland-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org</a>&gt;</span>=
 wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"">On 03/20/2014 03:48 PM, Step=
hen Cousins wrote:<br>
&gt; I am testing dm-crypt with a system that serves data over NFS. I&#39;m=
<br>
&gt; finding that when serving the data over NFS4 it will go for a little<b=
r>
&gt; while and then it will just stop copying and networking on the NFS<br>
&gt; server will stall out so that other connections to other parts of the<=
br>
&gt; storage (a non-dm-crypt volume) will become very laggy. Soon after<br>
&gt; canceling the copy the other connections resume back to normal.<br>
&gt;<br>
&gt; I have tried this on two different servers, one with a single disk<br>
&gt; with ZFS and another with a ZFS raidz2 pool and they both do the same<=
br>
&gt; thing. CPU doesn&#39;t seem to be an issue. Doing local copies is not =
a<br>
&gt; problem. That is, copying to/from these volumes made up of dm-crypted<=
br>
&gt; disks from other disks on the server have no problems.<br>
&gt;<br>
&gt; One system (the one with the RAID pool) is CentOS 6.4 and the other<br=
>
&gt; one is CentOS 6.5.<br>
&gt;<br>
&gt; I&#39;m curious if anyone else has run into this before and if so, wha=
t<br>
&gt; can be done to make it work? I&#39;m going to test to see if taking ZF=
S<br>
&gt; out of the equation helps. I haven&#39;t run into this with ZFS with<b=
r>
&gt; disks without dm-crypt.<br>
<br>
</div>Hi,<br>
<br>
unfortunately the dmcrypt code in Centos 6.x is not what is upstream<br>
kernel (mainly because of per cpu processing changes upstream).<br>
(It would be interesting if it is reproducible with upstream kernel,<br>
but I guess it is not easy to test...)<br>
<br>
I am adding cc to dm-devel list, maybe someone there could have some idea<b=
r>
how to help here.<br>
<br>
Milan<br>
<div class=3D""><br>
&gt;<br>
&gt; Thanks,<br>
&gt;<br>
&gt; Steve<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; -- ________________________________________________________________<br=
>
&gt; Steve Cousins =A0 =A0 =A0 =A0 =A0 =A0 Supercomputer Engineer/Administr=
ator<br>
&gt; Advanced Computing Group =A0 =A0 =A0 =A0 =A0 =A0University of Maine Sy=
stem 244<br>
&gt; Neville Hall (UMS Data Center) =A0 =A0 =A0 =A0 =A0 =A0 =A0<a href=3D"t=
el:%28207%29%20561-3574" value=3D"+12075613574">(207) 561-3574</a><br>
</div>&gt; &lt;tel:%28207%29%20561-3574&gt; Orono ME 04469<br>
&gt; steve.cousins at <a href=3D"http://maine.edu" target=3D"_blank">maine.=
edu</a> &lt;<a href=3D"http://maine.edu" target=3D"_blank">http://maine.edu=
</a>&gt;<br>
</blockquote></div><br><br clear=3D"all"><div><br></div>-- <br><span style=
=3D"font-family:courier new,monospace">____________________________________=
____________________________</span><br style=3D"font-family:courier new,mon=
ospace">
<span style=3D"font-family:courier new,monospace">=A0Steve Cousins=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 Supercomputer Engineer/Administrator</span><br =
style=3D"font-family:courier new,monospace"><span style=3D"font-family:cour=
ier new,monospace">=A0Advanced Computing Group=A0 =A0=A0=A0=A0=A0=A0=A0=A0=
=A0 University of Maine System</span><br style=3D"font-family:courier new,m=
onospace">
<span style=3D"font-family:courier new,monospace">=A0244 Neville Hall (UMS =
Data Center)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (207) 561-3574</span><b=
r style=3D"font-family:courier new,monospace"><span style=3D"font-family:co=
urier new,monospace">=A0Orono ME 04469=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 steve.cousins at <a href=3D"http://maine.edu" t=
arget=3D"_blank">maine.edu</a></span><br>
<br>
</div>

--047d7b5d5b0a25b5be04f511117d--

--===============6115849279999477438==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
dm-crypt mailing list
dm-crypt-4q3lyFh4P1g@public.gmane.org
http://www.saout.de/mailman/listinfo/dm-crypt

--===============6115849279999477438==--
