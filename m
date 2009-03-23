From: "John A. Sullivan III" <jsullivan@opensourcedevel.com>
Subject: Re: Shell Scripts or Arbitrary Priority Callouts?
Date: Mon, 23 Mar 2009 05:46:36 -0400
Message-ID: <1237801596.6577.28.camel@jaspav.missionsit.net.missionsit.net>
References: <7bc80d500903181557x295480feia73d0c23992c6f65@mail.gmail.com>
	<1237460677.6506.5.camel@jaspav.missionsit.net.missionsit.net>
	<7bc80d500903192211k6baadc81ge1b9d8b81ea6a913@mail.gmail.com>
	<1237543283.6572.10.camel@jaspav.missionsit.net.missionsit.net>
	<20090322152730.GC5528@edu.joroinen.fi>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090322152730.GC5528@edu.joroinen.fi>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: "Ross S. W. Walker" <rwalker@medallion.com>
List-Id: dm-devel.ids

On Sun, 2009-03-22 at 17:27 +0200, Pasi K=C3=A4rkk=C3=A4inen wrote:
> On Fri, Mar 20, 2009 at 06:01:23AM -0400, John A. Sullivan III wrote:
> > >=20
> > > John:
> > >=20
> > > Thanks for the reply.
> > >=20
> > > I ended up writing a small C program to do the priority computation=
 for me.
> > >=20
> > > I have two sets of FC-AL shelves attached to two dual-channel Qlogi=
c
> > > cards. That gives me two paths to each disk. I have about 56 spindl=
es
> > > in the current configuration, and am tying them together with md
> > > software raid.
> > >=20
> > > Now, even though each disk says it handles concurrent I/O on each
> > > port, my testing indicates that throughput suffers when using multi=
bus
> > > by about 1/2 (from ~60 MB/sec sustained I/O with failover to 35 MB/=
sec
> > > when using multibus).
> > >=20
> > > However, with failover, I am effectively using only one channel on
> > > each card. With my custom priority callout, I more or less match th=
e
> > > disks with even numbers to the even numbered scsi channels with a
> > > higher priority. Same with the odd numbered disks and odd numbered
> > > channels. The odds are 2ndary on even and vice versa. It seems to w=
ork
> > > rather well, and appears to spread the load nicely.
> > >=20
> > > Thanks again for your help!
> > >=20
> > I'm really glad you brought up the performance problem. I had posted
> > about it a few days ago but it seems to have gotten lost.  We are rea=
lly
> > struggling with performance issues when attempting to combine multipl=
e
> > paths (in the case of multipath to one big target) or targets (in the
> > case of software RAID0 across several targets) rather than using, in
> > effect, JBODs.  In our case, we are using iSCSI.
> >=20
> > Like you, we found that using multibus caused almost a linear drop in
> > performance.  Round robin across two paths was half as much as aggreg=
ate
> > throughput to two separate disks, four paths, one fourth.
> >=20
> > We also tried striping across the targets with software RAID0 combine=
d
> > with failover multipath - roughly the same effect.
> >=20
> > We really don't want to be forced to treated SAN attached disks as
> > JDOBs.  Has anyone cracked this problem of using them in either multi=
bus
> > or RAID0 so we can present them as a single device to the OS and stil=
l
> > load balance multiple paths.  This is a HUGE problem for us so any he=
lp
> > is greatly appreciated.  Thanks- John
>=20
> Hello.
>=20
> Hmm.. just a guess, but could this be related to the fact that if your =
paths
> to the storage are different iSCSI sessions (open-iscsi _doesn't_ suppo=
rt
> multiple connections per session aka MC/s), then there is a separate SC=
SI
> command queue per path.. and if SCSI requests are split across those qu=
eues=20
> they can get out-of-order and that causes performance drop?
>=20
> See:
> http://www.nabble.com/round-robin-with-vmware-initiator-and-iscsi-targe=
t-td21958346.html
>=20
> Especially the reply from Ross (CC). Maybe he has some comments :)=20
>=20
> -- Pasi
<snip>
I'm trying to spend a little time on this today and am really feeling my
ignorance on the way iSCSI works :(  It looks like linux-iscsi supports
MC/S but has not been in active development and will not even compile on
my 2.6.27 kernel.

To simplify matters, I did put each SAN interface on a separate network.
Thus, all the different sessions.  If I place them all on the same
network and use the iface parameters of open-iscsi, does that eliminate
the out-of-order problem and allow me to achieve the performance
scalability I'm seeking from dm-multipath in multibus mode? Thanks -
John
--=20
John A. Sullivan III
Open Source Development Corporation
+1 207-985-7880
jsullivan@opensourcedevel.com

http://www.spiritualoutreach.com
Making Christianity intelligible to secular society
