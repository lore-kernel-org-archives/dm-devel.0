From: "Ross S. W. Walker" <RWalker@medallion.com>
Subject: RE: Shell Scripts or Arbitrary Priority Callouts?
Date: Fri, 27 Mar 2009 14:23:58 -0400
Message-ID: <E2BB8074E5500C42984D980D4BD78EF9029E3CFF@MFG-NYC-EXCH2.mfg.prv>
References: <20090324073935.GK5528@edu.joroinen.fi>
	<1237892561.6560.19.camel@jaspav.missionsit.net.missionsit.net>
	<20090324115708.GM5528@edu.joroinen.fi>
	<1237897305.6560.26.camel@jaspav.missionsit.net.missionsit.net>
	<20090324150104.GO5528@edu.joroinen.fi>
	<1237909400.6560.80.camel@jaspav.missionsit.net.missionsit.net>
	<20090324163603.GQ5528@edu.joroinen.fi>
	<1237915811.6560.135.camel@jaspav.missionsit.net.missionsit.net>
	<20090324181735.GR5528@edu.joroinen.fi>
	<1237952460.6560.204.camel@jaspav.missionsit.net.missionsit.net>
	<20090325155207.GE24960@edu.joroinen.fi>
	<1237998092.6560.233.camel@jaspav.missionsit.net.missionsit.net>
	<1238137415.6574.48.camel@jaspav.missionsit.net.missionsit.net>
	<2A4646CA-45AF-460A-8E43-A6D9C070842A@medallion.com>
	<1238165063.6574.97.camel@jaspav.missionsit.net.missionsit.net>
	<E2BB8074E5500C42984D980D4BD78EF9029E3CFA@MFG-NYC-EXCH2.mfg.prv>
	<1238174141.6574.109.camel@jaspav.missionsit.net.missionsit.net>
	<1238177178.6574.131.camel@jaspav.miss! ionsit.net.missionsit .net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <1238177178.6574.131.camel@jaspav.missionsit.net.missionsit.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "John A. Sullivan III" <jsullivan@opensourcedevel.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

John A. Sullivan III wrote:
>=20
> Ah, I forgot another issue in our environment which mitigates=20
> again NFS.
> It is very heavily virtualized so there are not a lot of physical
> devices.  They do have multiple Ethernet interfaces, (e.g., there are
> ten GbE interfaces on the SAN).  However, we have a problem aggregating
> throughput.  Because there are only a handful of actual (but very large=
)
> systems, Ethernet bonding doesn't help us very much.  Anything that
> passes through the ProCurve switches is mapped by MAC address (as
> opposed to being able to hash upon socket).  Thus, all traffic flows
> through a single interface.

With virtualization it's not about the bandwidth, it's about the random
IOPS. All that random io really does mean that most throughput is
measured in 100s of KB not MB. Most storage will assemble sequential
reads in the read cache on shared storage.

Think of my suggestion of NFS for VM OS configuration and system
images, then inside those VMs use iSCSI for application specific
storage. If running iSCSI inside the VM is too problematic due to
virtual networking issues, you can always have the host system
run the initiator and present the SCSI devices to the VMs. It's
just a PITA when you re-allocate VMs from one host to another.

> Moreover, opensolaris only seems to support 802.3ad bonding.  Our
> ProCurve switches do not support 802.3ad bonding across multiple
> switches so using leaves use vulnerable to a single point of failure
> (ironically).  I believe Nortel supports this though I'm not sure about
> Cisco.  HP is releasing that capability this or next quarter but not in
> our lowly 2810 models.  We thought we got around the problems by using
> Linux based balance-xor using hash 3+4 and it seemed to work until we
> noticed than the switch CPU shot to 99% under even light traffic
> loads :(

Yes, the ProCurves and PowerConnects only use IEEE protocols and
IEEE doesn't have a protocol for splitting a LAG yet :-(

And yes the XOR load-balance will drive your switches to their knees
with gratuitous ARPs. I too found that out the hard way... :-(

> That's initially why we wanted to go the RAID0 route with each interfac=
e
> on a different network for aggregating throughput and dm-multipath
> underneath it for fault tolerance.  If we go with NFS, I believe we wil=
l
> lose the ability to aggregate bandwidth.  Thanks - John

With NFS you can use 802.3ad, which is, as the scary man in Old Country
for Old Man said, "Is the best offer your going to get", and with Solaris=
'
IPMP you can protect the NFS SPoF, if you couple that with application
specific iSCSI running over different LAG groups using multi-pathing
then you can probably make use of all that bandwidth.

-Ross

______________________________________________________________________
This e-mail, and any attachments thereto, is intended only for use by
the addressee(s) named herein and may contain legally privileged
and/or confidential information. If you are not the intended recipient
of this e-mail, you are hereby notified that any dissemination,
distribution or copying of this e-mail, and any attachments thereto,
is strictly prohibited. If you have received this e-mail in error,
please immediately notify the sender and permanently delete the
original and any copy or printout thereof.
