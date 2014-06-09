From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH] libmultipath: Use existing user friendly
 name if possible
Date: Mon, 9 Jun 2014 15:22:16 -0500
Message-ID: <20140609202216.GA4802@dhcp80-209.msp.redhat.com>
References: <8255ED565A0EAA4A960625E27D49DBF24AC9EB61@SACEXCMBX04-PRD.hq.netapp.com>
	<20140411160338.GA17578@localhost.localdomain>
	<1397235706.29991.8.camel@ict-vth-stewarts01.ict.englab.netapp.com>
	<1400181663.19394.17.camel@ict-vth-stewarts01.ict.englab.netapp.com>
	<CABr-GnfhTK=cG_sGyok3FZtw71EZEqAaLbEnzuN3=4DwXPQk3w@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CABr-GnfhTK=cG_sGyok3FZtw71EZEqAaLbEnzuN3=4DwXPQk3w@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>, "Stewart,
	Sean" <Sean.Stewart@netapp.com>
List-Id: dm-devel.ids

On Thu, May 15, 2014 at 11:45:40PM +0200, Christophe Varoqui wrote:
>    Ben,
>    I'd need your ack on this one.
>    Best regards,
>    Christophe Varoqui

Sorry I dropped the ball on this one.

I'm o.k. with this patch.  The biggest issue I have with it has nothing
to do with its correctness, but with rlookup_wwid()'s use of scan_device.
Previously, the only scan_device call always failed.  Now scan every
device name, but we don't ever get anything out of it. First off, if we
find a match, we will never use the id. Second, if we don't find a match we
return the id that of the alias we were looking for, but if we do find a
match we return the next id after the one we were looking for (which is
completely pointless).

It seems like we could just make rlookup_wwid() return success or failure,
and then call scan_device() from use_existing_alias() if we need to, and
take out a bunch of pointless work that rlookup_wwid() is doing.

-Ben

> =

>    On Thu, May 15, 2014 at 9:21 PM, Stewart, Sean
>    <[1]Sean.Stewart@netapp.com> wrote:
> =

>      Ping... =A0Any additional comments or suggestions for this patch?
>      Bumping in case it got lost in the backlog. :)
>      On Fri, 2014-04-11 at 17:01 +0000, Stewart, Sean wrote:
>      > On Fri, 2014-04-11 at 17:03 +0100, Bryn M. Reeves wrote:
>      > > On Fri, Mar 28, 2014 at 09:01:14PM +0000, Stewart, Sean wrote:
>      > > > When a system is booted to the SAN, a condition can occur where
>      one
>      > > > user friendly name is given to a disk during boot, but multipa=
thd
>      tries
>      > > > to allocate a different one after boot. If the second alias is
>      already
>      > > > used by another device, multipathd can't rename it. Multipathd
>      then has
>      > > > incorrect information about the alias/wwid relationships, which
>      can
>      > > > result in paths being added to the wrong map.
>      > >
>      > > This should only happen if the initramfs and root file system ha=
ve
>      > > inconsistent multipath configurations (either multipath.conf or
>      bindings
>      > > / wwids file mismatched). That's not really a valid configuration
>      for
>      > > the system to be in and leads to the type of problems you descri=
be.
>      >
>      > That is true that it only happens if they are out of sync. =A0We t=
ried
>      > remaking the initramfs to fix the problem, but it didn't help.
>      > >
>      > > > This patch works around this problem by first trying to use the
>      alias
>      > > > already bound to a device during boot. =A0If the bindings file=
 has
>      that
>      > > > alias bound to a different device, it'll auto generate a new a=
lias
>      to
>      > > > rename it to.
>      > >
>      > > To be honest I'd prefer to see this cause an error. These types =
of
>      > > configurations currently run the risk of silent data corruption -
>      I'd
>      > > much rather deal with a system that refuses to boot due to an ou=
t of
>      > > date initramfs image than one that quietly remaps paths in
>      unexpected
>      > > ways.
>      >
>      > The issue, though, is that the system does not refuse to boot. =A0=
In the
>      > case we saw, it booted anyway, our QA engineer ran a test, and it
>      ended
>      > with a data corruption. =A0A user could perform a fresh installati=
on,
>      > map
>      > new luns, reboot, and without any way of realizing it have essenti=
ally
>      a
>      > ticking time bomb on their hands, ready to go off as soon as there=
's a
>      > blip in the SAN.
> =

> References
> =

>    Visible links
>    1. mailto:Sean.Stewart@netapp.com
