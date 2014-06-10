From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] libmultipath: Use existing user friendly
 name if possible
Date: Tue, 10 Jun 2014 08:00:57 +0200
Message-ID: <CABr-GncXu7DD=1NbBE763buJV8grBv2VUX36Tpuys2M-Fx6O9w@mail.gmail.com>
References: <8255ED565A0EAA4A960625E27D49DBF24AC9EB61@SACEXCMBX04-PRD.hq.netapp.com>
	<20140411160338.GA17578@localhost.localdomain>
	<1397235706.29991.8.camel@ict-vth-stewarts01.ict.englab.netapp.com>
	<1400181663.19394.17.camel@ict-vth-stewarts01.ict.englab.netapp.com>
	<CABr-GnfhTK=cG_sGyok3FZtw71EZEqAaLbEnzuN3=4DwXPQk3w@mail.gmail.com>
	<20140609202216.GA4802@dhcp80-209.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6619985652976966341=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140609202216.GA4802@dhcp80-209.msp.redhat.com>
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

--===============6619985652976966341==
Content-Type: multipart/alternative; boundary=001a11330d682eddbf04fb750d2d

--001a11330d682eddbf04fb750d2d
Content-Type: text/plain; charset=UTF-8

Ok, I guess those changes can come incrementally over this patch then.

Applied.

Christophe Varoqui
www.opensvc.com


On Mon, Jun 9, 2014 at 10:22 PM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> On Thu, May 15, 2014 at 11:45:40PM +0200, Christophe Varoqui wrote:
> >    Ben,
> >    I'd need your ack on this one.
> >    Best regards,
> >    Christophe Varoqui
>
> Sorry I dropped the ball on this one.
>
> I'm o.k. with this patch.  The biggest issue I have with it has nothing
> to do with its correctness, but with rlookup_wwid()'s use of scan_device.
> Previously, the only scan_device call always failed.  Now scan every
> device name, but we don't ever get anything out of it. First off, if we
> find a match, we will never use the id. Second, if we don't find a match we
> return the id that of the alias we were looking for, but if we do find a
> match we return the next id after the one we were looking for (which is
> completely pointless).
>
> It seems like we could just make rlookup_wwid() return success or failure,
> and then call scan_device() from use_existing_alias() if we need to, and
> take out a bunch of pointless work that rlookup_wwid() is doing.
>
> -Ben
>
> >
> >    On Thu, May 15, 2014 at 9:21 PM, Stewart, Sean
> >    <[1]Sean.Stewart@netapp.com> wrote:
> >
> >      Ping...  Any additional comments or suggestions for this patch?
> >      Bumping in case it got lost in the backlog. :)
> >      On Fri, 2014-04-11 at 17:01 +0000, Stewart, Sean wrote:
> >      > On Fri, 2014-04-11 at 17:03 +0100, Bryn M. Reeves wrote:
> >      > > On Fri, Mar 28, 2014 at 09:01:14PM +0000, Stewart, Sean wrote:
> >      > > > When a system is booted to the SAN, a condition can occur
> where
> >      one
> >      > > > user friendly name is given to a disk during boot, but
> multipathd
> >      tries
> >      > > > to allocate a different one after boot. If the second alias is
> >      already
> >      > > > used by another device, multipathd can't rename it. Multipathd
> >      then has
> >      > > > incorrect information about the alias/wwid relationships,
> which
> >      can
> >      > > > result in paths being added to the wrong map.
> >      > >
> >      > > This should only happen if the initramfs and root file system
> have
> >      > > inconsistent multipath configurations (either multipath.conf or
> >      bindings
> >      > > / wwids file mismatched). That's not really a valid
> configuration
> >      for
> >      > > the system to be in and leads to the type of problems you
> describe.
> >      >
> >      > That is true that it only happens if they are out of sync.  We
> tried
> >      > remaking the initramfs to fix the problem, but it didn't help.
> >      > >
> >      > > > This patch works around this problem by first trying to use
> the
> >      alias
> >      > > > already bound to a device during boot.  If the bindings file
> has
> >      that
> >      > > > alias bound to a different device, it'll auto generate a new
> alias
> >      to
> >      > > > rename it to.
> >      > >
> >      > > To be honest I'd prefer to see this cause an error. These types
> of
> >      > > configurations currently run the risk of silent data corruption
> -
> >      I'd
> >      > > much rather deal with a system that refuses to boot due to an
> out of
> >      > > date initramfs image than one that quietly remaps paths in
> >      unexpected
> >      > > ways.
> >      >
> >      > The issue, though, is that the system does not refuse to boot.
>  In the
> >      > case we saw, it booted anyway, our QA engineer ran a test, and it
> >      ended
> >      > with a data corruption.  A user could perform a fresh
> installation,
> >      > map
> >      > new luns, reboot, and without any way of realizing it have
> essentially
> >      a
> >      > ticking time bomb on their hands, ready to go off as soon as
> there's a
> >      > blip in the SAN.
> >
> > References
> >
> >    Visible links
> >    1. mailto:Sean.Stewart@netapp.com
>

--001a11330d682eddbf04fb750d2d
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Ok, I guess those changes can come incrementally over=
 this patch then.<br><br></div>Applied.<br><div><div><br></div>Christophe V=
aroqui<br></div><a href=3D"http://www.opensvc.com">www.opensvc.com</a><br><=
/div>
<div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">On Mon, Jun 9=
, 2014 at 10:22 PM, Benjamin Marzinski <span dir=3D"ltr">&lt;<a href=3D"mai=
lto:bmarzins@redhat.com" target=3D"_blank">bmarzins@redhat.com</a>&gt;</spa=
n> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"">On Thu, May 15, 2014 at 11:4=
5:40PM +0200, Christophe Varoqui wrote:<br>
&gt; =C2=A0 =C2=A0Ben,<br>
&gt; =C2=A0 =C2=A0I&#39;d need your ack on this one.<br>
&gt; =C2=A0 =C2=A0Best regards,<br>
&gt; =C2=A0 =C2=A0Christophe Varoqui<br>
<br>
</div>Sorry I dropped the ball on this one.<br>
<br>
I&#39;m o.k. with this patch. =C2=A0The biggest issue I have with it has no=
thing<br>
to do with its correctness, but with rlookup_wwid()&#39;s use of scan_devic=
e.<br>
Previously, the only scan_device call always failed. =C2=A0Now scan every<b=
r>
device name, but we don&#39;t ever get anything out of it. First off, if we=
<br>
find a match, we will never use the id. Second, if we don&#39;t find a matc=
h we<br>
return the id that of the alias we were looking for, but if we do find a<br=
>
match we return the next id after the one we were looking for (which is<br>
completely pointless).<br>
<br>
It seems like we could just make rlookup_wwid() return success or failure,<=
br>
and then call scan_device() from use_existing_alias() if we need to, and<br=
>
take out a bunch of pointless work that rlookup_wwid() is doing.<br>
<br>
-Ben<br>
<div class=3D""><br>
&gt;<br>
&gt; =C2=A0 =C2=A0On Thu, May 15, 2014 at 9:21 PM, Stewart, Sean<br>
</div><div><div class=3D"h5">&gt; =C2=A0 =C2=A0&lt;[1]<a href=3D"mailto:Sea=
n.Stewart@netapp.com">Sean.Stewart@netapp.com</a>&gt; wrote:<br>
&gt;<br>
&gt; =C2=A0 =C2=A0 =C2=A0Ping... =C2=A0Any additional comments or suggestio=
ns for this patch?<br>
&gt; =C2=A0 =C2=A0 =C2=A0Bumping in case it got lost in the backlog. :)<br>
&gt; =C2=A0 =C2=A0 =C2=A0On Fri, 2014-04-11 at 17:01 +0000, Stewart, Sean w=
rote:<br>
&gt; =C2=A0 =C2=A0 =C2=A0&gt; On Fri, 2014-04-11 at 17:03 +0100, Bryn M. Re=
eves wrote:<br>
&gt; =C2=A0 =C2=A0 =C2=A0&gt; &gt; On Fri, Mar 28, 2014 at 09:01:14PM +0000=
, Stewart, Sean wrote:<br>
&gt; =C2=A0 =C2=A0 =C2=A0&gt; &gt; &gt; When a system is booted to the SAN,=
 a condition can occur where<br>
&gt; =C2=A0 =C2=A0 =C2=A0one<br>
&gt; =C2=A0 =C2=A0 =C2=A0&gt; &gt; &gt; user friendly name is given to a di=
sk during boot, but multipathd<br>
&gt; =C2=A0 =C2=A0 =C2=A0tries<br>
&gt; =C2=A0 =C2=A0 =C2=A0&gt; &gt; &gt; to allocate a different one after b=
oot. If the second alias is<br>
&gt; =C2=A0 =C2=A0 =C2=A0already<br>
&gt; =C2=A0 =C2=A0 =C2=A0&gt; &gt; &gt; used by another device, multipathd =
can&#39;t rename it. Multipathd<br>
&gt; =C2=A0 =C2=A0 =C2=A0then has<br>
&gt; =C2=A0 =C2=A0 =C2=A0&gt; &gt; &gt; incorrect information about the ali=
as/wwid relationships, which<br>
&gt; =C2=A0 =C2=A0 =C2=A0can<br>
&gt; =C2=A0 =C2=A0 =C2=A0&gt; &gt; &gt; result in paths being added to the =
wrong map.<br>
&gt; =C2=A0 =C2=A0 =C2=A0&gt; &gt;<br>
&gt; =C2=A0 =C2=A0 =C2=A0&gt; &gt; This should only happen if the initramfs=
 and root file system have<br>
&gt; =C2=A0 =C2=A0 =C2=A0&gt; &gt; inconsistent multipath configurations (e=
ither multipath.conf or<br>
&gt; =C2=A0 =C2=A0 =C2=A0bindings<br>
&gt; =C2=A0 =C2=A0 =C2=A0&gt; &gt; / wwids file mismatched). That&#39;s not=
 really a valid configuration<br>
&gt; =C2=A0 =C2=A0 =C2=A0for<br>
&gt; =C2=A0 =C2=A0 =C2=A0&gt; &gt; the system to be in and leads to the typ=
e of problems you describe.<br>
&gt; =C2=A0 =C2=A0 =C2=A0&gt;<br>
&gt; =C2=A0 =C2=A0 =C2=A0&gt; That is true that it only happens if they are=
 out of sync. =C2=A0We tried<br>
&gt; =C2=A0 =C2=A0 =C2=A0&gt; remaking the initramfs to fix the problem, bu=
t it didn&#39;t help.<br>
&gt; =C2=A0 =C2=A0 =C2=A0&gt; &gt;<br>
&gt; =C2=A0 =C2=A0 =C2=A0&gt; &gt; &gt; This patch works around this proble=
m by first trying to use the<br>
&gt; =C2=A0 =C2=A0 =C2=A0alias<br>
&gt; =C2=A0 =C2=A0 =C2=A0&gt; &gt; &gt; already bound to a device during bo=
ot. =C2=A0If the bindings file has<br>
&gt; =C2=A0 =C2=A0 =C2=A0that<br>
&gt; =C2=A0 =C2=A0 =C2=A0&gt; &gt; &gt; alias bound to a different device, =
it&#39;ll auto generate a new alias<br>
&gt; =C2=A0 =C2=A0 =C2=A0to<br>
&gt; =C2=A0 =C2=A0 =C2=A0&gt; &gt; &gt; rename it to.<br>
&gt; =C2=A0 =C2=A0 =C2=A0&gt; &gt;<br>
&gt; =C2=A0 =C2=A0 =C2=A0&gt; &gt; To be honest I&#39;d prefer to see this =
cause an error. These types of<br>
&gt; =C2=A0 =C2=A0 =C2=A0&gt; &gt; configurations currently run the risk of=
 silent data corruption -<br>
&gt; =C2=A0 =C2=A0 =C2=A0I&#39;d<br>
&gt; =C2=A0 =C2=A0 =C2=A0&gt; &gt; much rather deal with a system that refu=
ses to boot due to an out of<br>
&gt; =C2=A0 =C2=A0 =C2=A0&gt; &gt; date initramfs image than one that quiet=
ly remaps paths in<br>
&gt; =C2=A0 =C2=A0 =C2=A0unexpected<br>
&gt; =C2=A0 =C2=A0 =C2=A0&gt; &gt; ways.<br>
&gt; =C2=A0 =C2=A0 =C2=A0&gt;<br>
&gt; =C2=A0 =C2=A0 =C2=A0&gt; The issue, though, is that the system does no=
t refuse to boot. =C2=A0In the<br>
&gt; =C2=A0 =C2=A0 =C2=A0&gt; case we saw, it booted anyway, our QA enginee=
r ran a test, and it<br>
&gt; =C2=A0 =C2=A0 =C2=A0ended<br>
&gt; =C2=A0 =C2=A0 =C2=A0&gt; with a data corruption. =C2=A0A user could pe=
rform a fresh installation,<br>
&gt; =C2=A0 =C2=A0 =C2=A0&gt; map<br>
&gt; =C2=A0 =C2=A0 =C2=A0&gt; new luns, reboot, and without any way of real=
izing it have essentially<br>
&gt; =C2=A0 =C2=A0 =C2=A0a<br>
&gt; =C2=A0 =C2=A0 =C2=A0&gt; ticking time bomb on their hands, ready to go=
 off as soon as there&#39;s a<br>
&gt; =C2=A0 =C2=A0 =C2=A0&gt; blip in the SAN.<br>
&gt;<br>
</div></div>&gt; References<br>
&gt;<br>
&gt; =C2=A0 =C2=A0Visible links<br>
&gt; =C2=A0 =C2=A01. mailto:<a href=3D"mailto:Sean.Stewart@netapp.com">Sean=
.Stewart@netapp.com</a><br>
</blockquote></div><br></div>

--001a11330d682eddbf04fb750d2d--


--===============6619985652976966341==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6619985652976966341==--
