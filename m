From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] libmultipath: Use existing user friendly
 name if possible
Date: Thu, 15 May 2014 23:45:40 +0200
Message-ID: <CABr-GnfhTK=cG_sGyok3FZtw71EZEqAaLbEnzuN3=4DwXPQk3w@mail.gmail.com>
References: <8255ED565A0EAA4A960625E27D49DBF24AC9EB61@SACEXCMBX04-PRD.hq.netapp.com>
	<20140411160338.GA17578@localhost.localdomain>
	<1397235706.29991.8.camel@ict-vth-stewarts01.ict.englab.netapp.com>
	<1400181663.19394.17.camel@ict-vth-stewarts01.ict.englab.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6467307819050460479=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1400181663.19394.17.camel@ict-vth-stewarts01.ict.englab.netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, "Stewart,
	Sean" <Sean.Stewart@netapp.com>
List-Id: dm-devel.ids

--===============6467307819050460479==
Content-Type: multipart/alternative; boundary=90e6ba476ad3e1821e04f977377e

--90e6ba476ad3e1821e04f977377e
Content-Type: text/plain; charset=UTF-8

Ben,

I'd need your ack on this one.

Best regards,
Christophe Varoqui


On Thu, May 15, 2014 at 9:21 PM, Stewart, Sean <Sean.Stewart@netapp.com>wrote:

> Ping...  Any additional comments or suggestions for this patch?
> Bumping in case it got lost in the backlog. :)
>
> On Fri, 2014-04-11 at 17:01 +0000, Stewart, Sean wrote:
> > On Fri, 2014-04-11 at 17:03 +0100, Bryn M. Reeves wrote:
> > > On Fri, Mar 28, 2014 at 09:01:14PM +0000, Stewart, Sean wrote:
> > > > When a system is booted to the SAN, a condition can occur where one
> > > > user friendly name is given to a disk during boot, but multipathd
> tries
> > > > to allocate a different one after boot. If the second alias is
> already
> > > > used by another device, multipathd can't rename it. Multipathd then
> has
> > > > incorrect information about the alias/wwid relationships, which can
> > > > result in paths being added to the wrong map.
> > >
> > > This should only happen if the initramfs and root file system have
> > > inconsistent multipath configurations (either multipath.conf or
> bindings
> > > / wwids file mismatched). That's not really a valid configuration for
> > > the system to be in and leads to the type of problems you describe.
> >
> > That is true that it only happens if they are out of sync.  We tried
> > remaking the initramfs to fix the problem, but it didn't help.
> > >
> > > > This patch works around this problem by first trying to use the alias
> > > > already bound to a device during boot.  If the bindings file has that
> > > > alias bound to a different device, it'll auto generate a new alias to
> > > > rename it to.
> > >
> > > To be honest I'd prefer to see this cause an error. These types of
> > > configurations currently run the risk of silent data corruption - I'd
> > > much rather deal with a system that refuses to boot due to an out of
> > > date initramfs image than one that quietly remaps paths in unexpected
> > > ways.
> >
> > The issue, though, is that the system does not refuse to boot.  In the
> > case we saw, it booted anyway, our QA engineer ran a test, and it ended
> > with a data corruption.  A user could perform a fresh installation,
> > map
> > new luns, reboot, and without any way of realizing it have essentially a
> > ticking time bomb on their hands, ready to go off as soon as there's a
> > blip in the SAN.
>
>

--90e6ba476ad3e1821e04f977377e
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Ben,<div><br></div><div>I&#39;d need your ack on this one.=
</div><div><br></div><div>Best regards,</div><div>Christophe Varoqui</div><=
/div><div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">On Thu, =
May 15, 2014 at 9:21 PM, Stewart, Sean <span dir=3D"ltr">&lt;<a href=3D"mai=
lto:Sean.Stewart@netapp.com" target=3D"_blank">Sean.Stewart@netapp.com</a>&=
gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">Ping... =C2=A0Any additional comments or sug=
gestions for this patch?<br>
Bumping in case it got lost in the backlog. :)<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
On Fri, 2014-04-11 at 17:01 +0000, Stewart, Sean wrote:<br>
&gt; On Fri, 2014-04-11 at 17:03 +0100, Bryn M. Reeves wrote:<br>
&gt; &gt; On Fri, Mar 28, 2014 at 09:01:14PM +0000, Stewart, Sean wrote:<br=
>
&gt; &gt; &gt; When a system is booted to the SAN, a condition can occur wh=
ere one<br>
&gt; &gt; &gt; user friendly name is given to a disk during boot, but multi=
pathd tries<br>
&gt; &gt; &gt; to allocate a different one after boot. If the second alias =
is already<br>
&gt; &gt; &gt; used by another device, multipathd can&#39;t rename it. Mult=
ipathd then has<br>
&gt; &gt; &gt; incorrect information about the alias/wwid relationships, wh=
ich can<br>
&gt; &gt; &gt; result in paths being added to the wrong map.<br>
&gt; &gt;<br>
&gt; &gt; This should only happen if the initramfs and root file system hav=
e<br>
&gt; &gt; inconsistent multipath configurations (either multipath.conf or b=
indings<br>
&gt; &gt; / wwids file mismatched). That&#39;s not really a valid configura=
tion for<br>
&gt; &gt; the system to be in and leads to the type of problems you describ=
e.<br>
&gt;<br>
&gt; That is true that it only happens if they are out of sync. =C2=A0We tr=
ied<br>
&gt; remaking the initramfs to fix the problem, but it didn&#39;t help.<br>
&gt; &gt;<br>
&gt; &gt; &gt; This patch works around this problem by first trying to use =
the alias<br>
&gt; &gt; &gt; already bound to a device during boot. =C2=A0If the bindings=
 file has that<br>
&gt; &gt; &gt; alias bound to a different device, it&#39;ll auto generate a=
 new alias to<br>
&gt; &gt; &gt; rename it to.<br>
&gt; &gt;<br>
&gt; &gt; To be honest I&#39;d prefer to see this cause an error. These typ=
es of<br>
&gt; &gt; configurations currently run the risk of silent data corruption -=
 I&#39;d<br>
&gt; &gt; much rather deal with a system that refuses to boot due to an out=
 of<br>
&gt; &gt; date initramfs image than one that quietly remaps paths in unexpe=
cted<br>
&gt; &gt; ways.<br>
&gt;<br>
&gt; The issue, though, is that the system does not refuse to boot. =C2=A0I=
n the<br>
&gt; case we saw, it booted anyway, our QA engineer ran a test, and it ende=
d<br>
&gt; with a data corruption. =C2=A0A user could perform a fresh installatio=
n,<br>
&gt; map<br>
&gt; new luns, reboot, and without any way of realizing it have essentially=
 a<br>
&gt; ticking time bomb on their hands, ready to go off as soon as there&#39=
;s a<br>
&gt; blip in the SAN.<br>
<br>
</div></div></blockquote></div><br></div>

--90e6ba476ad3e1821e04f977377e--


--===============6467307819050460479==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6467307819050460479==--
