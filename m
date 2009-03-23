From: "John A. Sullivan III" <jsullivan@opensourcedevel.com>
Subject: Re: Shell Scripts or Arbitrary Priority Callouts?
Date: Mon, 23 Mar 2009 09:07:38 -0400
Message-ID: <1237813658.6577.46.camel@jaspav.missionsit.net.missionsit.net>
References: <7bc80d500903181557x295480feia73d0c23992c6f65@mail.gmail.com>
	<1237460677.6506.5.camel@jaspav.missionsit.net.missionsit.net>
	<7bc80d500903192211k6baadc81ge1b9d8b81ea6a913@mail.gmail.com>
	<1237543283.6572.10.camel@jaspav.missionsit.net.missionsit.net>
	<20090322152730.GC5528@edu.joroinen.fi>
	<1237801596.6577.28.camel@jaspav.missionsit.net.missionsit.net>
	<CF307021-DE23-4BB1-BC6D-F4F520464208@medallion.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CF307021-DE23-4BB1-BC6D-F4F520464208@medallion.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Ross S. W. Walker" <RWalker@medallion.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, 2009-03-23 at 08:50 -0400, Ross S. W. Walker wrote:
> On Mar 23, 2009, at 5:46 AM, "John A. Sullivan III"
> <jsullivan@opensourcedevel.com> wrote:
>=20
>=20
>=20
>=20
> > On Sun, 2009-03-22 at 17:27 +0200, Pasi K=C3=A4rkk=C3=A4inen wrote:
> > > On Fri, Mar 20, 2009 at 06:01:23AM -0400, John A. Sullivan III
> > wrote:
> > > > >
> > > > > John:
> > > > >
> > > > > Thanks for the reply.
> > > > >
> > > > > I ended up writing a small C program to do the priority
> > computation for me.
> > > > >
> > > > > I have two sets of FC-AL shelves attached to two dual-channel
> > Qlogic
> > > > > cards. That gives me two paths to each disk. I have about 56
> > spindles
> > > > > in the current configuration, and am tying them together with
> > md
> > > > > software raid.
> > > > >
> > > > > Now, even though each disk says it handles concurrent I/O on
> > each
> > > > > port, my testing indicates that throughput suffers when using
> > multibus
> > > > > by about 1/2 (from ~60 MB/sec sustained I/O with failover to
> > 35 MB/sec
> > > > > when using multibus).
> > > > >
> > > > > However, with failover, I am effectively using only one
> > channel on
> > > > > each card. With my custom priority callout, I more or less
> > match the
> > > > > disks with even numbers to the even numbered scsi channels
> > with a
> > > > > higher priority. Same with the odd numbered disks and odd
> > numbered
> > > > > channels. The odds are 2ndary on even and vice versa. It seems
> > to work
> > > > > rather well, and appears to spread the load nicely.
> > > > >
> > > > > Thanks again for your help!
> > > > >
> > > > I'm really glad you brought up the performance problem. I had
> > posted
> > > > about it a few days ago but it seems to have gotten lost.  We
> > are really
> > > > struggling with performance issues when attempting to combine
> > multiple
> > > > paths (in the case of multipath to one big target) or targets
> > (in the
> > > > case of software RAID0 across several targets) rather than
> > using, in
> > > > effect, JBODs.  In our case, we are using iSCSI.
> > > >
> > > > Like you, we found that using multibus caused almost a linear
> > drop in
> > > > performance.  Round robin across two paths was half as much as
> > aggregate
> > > > throughput to two separate disks, four paths, one fourth.
> > > >
> > > > We also tried striping across the targets with software RAID0
> > combined
> > > > with failover multipath - roughly the same effect.
> > > >
> > > > We really don't want to be forced to treated SAN attached disks
> > as
> > > > JDOBs.  Has anyone cracked this problem of using them in either
> > multibus
> > > > or RAID0 so we can present them as a single device to the OS and
> > still
> > > > load balance multiple paths.  This is a HUGE problem for us so
> > any help
> > > > is greatly appreciated.  Thanks- John
> > >
> > > Hello.
> > >
> > > Hmm.. just a guess, but could this be related to the fact that if
> > your paths
> > > to the storage are different iSCSI sessions (open-iscsi _doesn't_
> > support
> > > multiple connections per session aka MC/s), then there is a
> > separate SCSI
> > > command queue per path.. and if SCSI requests are split across
> > those queues
> > > they can get out-of-order and that causes performance drop?
> > >
> > > See:
> > >
> > http://www.nabble.com/round-robin-with-vmware-initiator-and-iscsi-tar=
get-td21958346.html
> > >
> > > Especially the reply from Ross (CC). Maybe he has some comments :)
> > >
> > > -- Pasi
> > <snip>
> > I'm trying to spend a little time on this today and am really
> > feeling my
> > ignorance on the way iSCSI works :(  It looks like linux-iscsi
> > supports
> > MC/S but has not been in active development and will not even
> > compile on
> > my 2.6.27 kernel.
> >=20
> > To simplify matters, I did put each SAN interface on a separate
> > network.
> > Thus, all the different sessions.  If I place them all on the same
> > network and use the iface parameters of open-iscsi, does that
> > eliminate
> > the out-of-order problem and allow me to achieve the performance
> > scalability I'm seeking from dm-multipath in multibus mode? Thanks -
> > John
> >=20
> >=20
> >=20
> No, the only way to eliminate the out-of-order problem is MC/s. You
> can mask the issue when using IET by using fileio which caches these
> in page cache which will coalesce these before actually going to disk.
>=20
>=20
> The issue here seems it might be dm-multipath though.
>=20
>=20
> If your workload is random though, which most is, then sequential
> performance is inconsequential.
>=20
>=20
> -Ross
<snip>
Thanks very much, Ross.  As I was working through the iface options of
open-iscsi this morning, I began to realize, just as you point out, they
are still separate sessions.  We are not using Linux on the target end
but rather ZFS on opensolaris via Nexenta.  I'll have to find out from
them what the equivalent to fileio is.  Thanks again - John
>=20
--=20
John A. Sullivan III
Open Source Development Corporation
+1 207-985-7880
jsullivan@opensourcedevel.com

http://www.spiritualoutreach.com
Making Christianity intelligible to secular society
