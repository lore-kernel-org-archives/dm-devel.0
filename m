From: "John A. Sullivan III" <jsullivan@opensourcedevel.com>
Subject: Re: Shell Scripts or Arbitrary Priority Callouts?
Date: Tue, 24 Mar 2009 13:30:10 -0400
Message-ID: <1237915811.6560.135.camel@jaspav.missionsit.net.missionsit.net>
References: <7bc80d500903192211k6baadc81ge1b9d8b81ea6a913@mail.gmail.com>
	<1237543283.6572.10.camel@jaspav.missionsit.net.missionsit.net>
	<20090322152730.GC5528@edu.joroinen.fi>
	<1237801596.6577.28.camel@jaspav.missionsit.net.missionsit.net>
	<20090324073935.GK5528@edu.joroinen.fi>
	<1237892561.6560.19.camel@jaspav.missionsit.net.missionsit.net>
	<20090324115708.GM5528@edu.joroinen.fi>
	<1237897305.6560.26.camel@jaspav.missionsit.net.missionsit.net>
	<20090324150104.GO5528@edu.joroinen.fi>
	<1237909400.6560.80.camel@jaspav.missionsit.net.missionsit.net>
	<20090324163603.GQ5528@edu.joroinen.fi>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090324163603.GQ5528@edu.joroinen.fi>
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

Thanks very much, again, and, again, I'll reply in the text - John

On Tue, 2009-03-24 at 18:36 +0200, Pasi K=C3=A4rkk=C3=A4inen wrote:
> On Tue, Mar 24, 2009 at 11:43:20AM -0400, John A. Sullivan III wrote:
> > I greatly appreciate the help.  I'll answer in the thread below as we=
ll
> > as consolidating answers to the questions posed in your other email.
> >=20
> > On Tue, 2009-03-24 at 17:01 +0200, Pasi K=C3=A4rkk=C3=A4inen wrote:
> > > On Tue, Mar 24, 2009 at 08:21:45AM -0400, John A. Sullivan III wrot=
e:
> > > > >=20
> > > > > Core-iscsi developer seems to be active developing at least the=
=20
> > > > > new iSCSI target (LIO target).. I think he has been testing it =
with
> > > > > core-iscsi, so maybe there's newer version somewhere?=20
> > > > >=20
> > > > > > We did play with the multipath rr_min_io settings and smaller=
 always
> > > > > > seemed to be better until we got into very large numbers of s=
ession.  We
> > > > > > were testing on a dual quad core AMD Shanghai 2378 system wit=
h 32 GB
> > > > > > RAM, a quad port Intel e1000 card and two on-board nvidia for=
cedeth
> > > > > > ports with disktest using 4K blocks to mimic the file system =
using
> > > > > > sequential reads (and some sequential writes).
> > > > > >=20
> > > > >=20
> > > > > Nice hardware. Btw are you using jumbo frames or flow control f=
or iSCSI
> > > > > traffic?=20
> > > > >=20
> > >=20
> > > Dunno if you noticed this.. :)=20
> > We are actually quite enthusiastic about the environment and the
> > project.  We hope to have many of these hosting about 400 VServer gue=
sts
> > running virtual desktops from the X2Go project.  It's not my project =
but
> > I don't mind plugging them as I think it is a great technology.
> >=20
> > We are using jumbo frames.  The ProCurve 2810 switches explicitly sta=
te
> > to NOT use flow control and jumbo frames simultaneously.  We tried it
> > anyway but with poor results.
>=20
> Ok.=20
>=20
> iirc 2810 does not have very big buffers per port, so you might be bett=
er
> using flow control instead of jumbos.. then again I'm not sure how good=
 flow
> control implementation HP has?=20
>=20
> The whole point of flow control is to prevent packet loss/drop.. this h=
appens
> with sending pause frames before the port buffers get full. If port buf=
fers
> get full then the switch doesn't have any other option than to drop the
> packets.. and this causes tcp-retransmits -> causes delay and tcp slows=
 down
> to prevent further packet drops.
>=20
> flow control "pause frames" cause less delay than tcp-retransmits.=20
>=20
> Do you see tcp retransmits with "netstat -s" ? Check both the target an=
d the initiators.
Thankfully this is an area of some expertise for me (unlike disk I/O -
obviously ;)  ).  We have been pretty thorough about checking the
network path.  We've not seen any upper layer retransmission or buffer
overflows.
>=20
> > >=20
> > >=20
> > > > > >=20
> > > > >=20
> > > > > When you used dm RAID0 you didn't have any multipath configurat=
ion, right?=20
> > > > Correct although we also did test successfully with multipath in
> > > > failover mode and RAID0.
> > > > >=20
> > >=20
> > > OK.
> > >=20
> > > > > What kind of stripe size and other settings you had for RAID0?
> > > > Chunk size was 8KB with four disks. =20
> > > > >=20
> > >=20
> > > Did you try with much bigger sizes.. 128 kB ?
> > We tried slightly larger sizes - 16KB and 32KB I believe and observed
> > performance degradation.  In fact, in some scenarios 4KB chunk sizes
> > gave us better performance than 8KB.
>=20
> Ok.=20
>=20
> > >=20
> > > > > What kind of performance do you get using just a single iscsi s=
ession (and
> > > > > thus just a single path), no multipathing, no DM RAID0 ? Just a=
 filesystem
> > > > > directly on top of the iscsi /dev/sd? device.
> > > > Miserable - same roughly 12 MB/s.
> > >=20
> > > OK, Here's your problem. Was this btw reads or writes? Did you tune
> > > readahead-settings?=20
> > 12MBps is sequential reading but sequential writing is not much
> > different.  We did tweak readahead to 1024. We did not want to go muc=
h
> > larger in order to maintain balance with the various data patterns -
> > some of which are random and some of which may not read linearly.
>=20
> I did some benchmarking earlier between two servers; other one running =
ietd
> target with 'nullio' and other running open-iscsi initiator. Both using=
 a single gigabit NIC.=20
>=20
> I remember getting very close to full gigabit speed at least with bigge=
r
> block sizes. I can't remember how much I got with 4 kB blocks.=20
>=20
> Those tests were made with dd.
Yes, if we use 64KB blocks, we can saturate a Gig link.  With larger
sizes, we can push over 3 Gpbs over the four gig links in the test
environment.
>=20
> nullio target is a good way to benchmark your network and initiator and
> verify everything is correct.=20
>=20
> Also it's good to first test for example with FTP and Iperf to verify
> network is working properly between target and the initiator and all th=
e
> other basic settings are correct.
We did flood ping the network and had all interfaces operating at near
capacity.  The network itself looks very healthy.
>=20
> Btw have you configured tcp stacks of the servers? Bigger default tcp w=
indow
> size, bigger maximun tcp window size etc..=20
Yep, tweaked transmit queue length, receive and transmit windows, net
device backlogs, buffer space, disabled nagle, and even played with the
dirty page watermarks.
>=20
> > >=20
> > > Can paste your iSCSI session settings negotiated with the target?=20
> > Pardon my ignorance :( but, other than packet traces, how do I show t=
he
> > final negotiated settings?
>=20
> Try:
>=20
> iscsiadm -i -m session
> iscsiadm -m session -P3
>=20
Here's what it says.  Pretty much as expected.  We are using COMSTAR on
the target and took some traces to see what COMSTAR was expecting. We
set the open-iscsi parameters to match:

Current Portal: 172.x.x.174:3260,2
        Persistent Portal: 172.x.x.174:3260,2
                **********
                Interface:
                **********
                Iface Name: default
                Iface Transport: tcp
                Iface Initiatorname: iqn.2008-05.biz.ssi:vd-gen
                Iface IPaddress: 172.x.x.162
                Iface HWaddress: default
                Iface Netdev: default
                SID: 32
                iSCSI Connection State: LOGGED IN
                iSCSI Session State: LOGGED_IN
                Internal iscsid Session State: NO CHANGE
                ************************
                Negotiated iSCSI params:
                ************************
                HeaderDigest: None
                DataDigest: None
                MaxRecvDataSegmentLength: 131072
                MaxXmitDataSegmentLength: 8192
                FirstBurstLength: 65536
                MaxBurstLength: 524288
                ImmediateData: Yes
                InitialR2T: Yes
                MaxOutstandingR2T: 1
                ************************
                Attached SCSI devices:
                ************************
                Host Number: 39 State: running
                scsi39 Channel 00 Id 0 Lun: 0
                        Attached scsi disk sdah         State: running

>=20
> > >=20
> > > > >=20
> > > > > Sounds like there's some other problem if invidual throughput i=
s bad? Or did
> > > > > you mean performance with a single disktest IO thread is bad, b=
ut using multiple
> > > > > disktest threads it's good.. that would make more sense :)=20
> > > > Yes, the latter.  Single thread (I assume mimicking a single disk
> > > > operation, e.g., copying a large file) is miserable - much slower=
 than
> > > > local disk despite the availability of huge bandwidth.  We start
> > > > utilizing the bandwidth when multiplying concurrent disk activity=
 into
> > > > the hundreds.
> > > >=20
> > > > I am guessing the single thread performance problem is an open-is=
csi
> > > > issue but I was hoping multipath would help us work around it by
> > > > utilizing multiple sessions per disk operation.  I suppose that i=
s where
> > > > we run into the command ordering problem unless there is somethin=
g else
> > > > afoot.  Thanks - John
> > >=20
> > > You should be able to get many times the throughput you get now.. j=
ust with
> > > a single path/session.
> > >=20
> > > What kind of latency do you have from the initiator to the target/s=
torage?=20
> > >=20
> > > Try with for example 4 kB ping:
> > > ping -s 4096 <ip_of_the_iscsi_target>
> > We have about 400 micro seconds - that seems a bit high :(
> > rtt min/avg/max/mdev =3D 0.275/0.337/0.398/0.047 ms
> >=20
>=20
> Yeah.. that's a bit high.=20
Actually, with more testing, we're seeing it stretch up to over 700
micro-seconds.  I'll attach a raft of data I collected at the end of
this email.
>=20
> > >=20
> > > 1000ms divided by the roundtrip you get from ping should give you m=
aximum
> > > possible IOPS using a single path..=20
> > >=20
> > 1000 / 0.4 =3D 2500
> > > 4 kB * IOPS =3D=3D max bandwidth you can achieve.
> > 2500 * 4KB =3D 10 MBps
> > Hmm . . . seems like what we are getting.  Is that an abnormally high
> > latency? We have tried playing with interrupt coalescing on the
> > initiator side but without significant effect.  Thanks for putting
> > together the formula for me.  Not only does it help me understand but=
 it
> > means I can work on addressing the latency issue without setting up a=
nd
> > running disk tests.
> >=20
>=20
> I think Ross suggested in some other thread the following settings for =
e1000
> NICs:
>=20
> "Set the e1000s InterruptThrottleRate=3D1 and their TxRingBufferSize=3D=
4096
> and RxRingBufferSize=3D4096 (verify those option names with a modinfo)
> and add those to modprobe.conf."
We did try playing with the ring buffer but to no avail.  Modinfo does
not seem to display the current settings.  We did try playing with
setting the InterruptThrottleRate to 1 but again to no avail.  As I'll
mention later, I suspect the issue might be the opensolaris based
target.
>=20
> > I would love to use larger block sizes as you suggest in your other
> > email but, on AMD64, I believe we are stuck with 4KB.  I've not seen =
any
> > way to change it and would gladly do so if someone knows how.
> >=20
>=20
> Are we talking about filesystem block sizes? That shouldn't be a proble=
m if
> your application uses larger blocksizes for read/write operations..=20
>=20
Yes, file system block size.  When we try rough, end user style tests,
e.g., large file copies, we seem to get the performance indicated by 4KB
blocks, i.e., lousy!
> Try for example with:
> dd if=3D/dev/zero of=3D/iscsilun/file.bin bs=3D1024k count=3D1024
Large block sizes can make the system truly fly so we suspect you are
absolutely correct about latency being the issue.  We did do our testing
with raw interfaces by the way.
>=20
> and optionally add "oflag=3Ddirect" (or iflag=3Ddirect) if you want to =
make sure=20
> caches do not mess up the results.=20
>=20
> > CFQ was indeed a problem.  It would not scale with increasing the num=
ber
> > of threads.  noop, deadline, and anticipatory all fared much better. =
 We
> > are currently using noop for the iSCSI targets.  Thanks again - John
>=20
> Yep. And no problems.. hopefully I'm able to help and guide to right
> direction :) =20
<snip>
I did a little digging and calculating and here is what I came up with
and sent to Nexenta.  Please tell me if I am on the right track.

I am using jumbo frames and should be able to get 2 4KB blocks
per frame.  Total size should be 8192 + 78 (TCP + IP + Ethernet + CRC
-oops we need to add iSCSI -what size is the iSCSI header?) + 12
(interframe gap) =3D 8282 bytes.  Transmission latency should be 8282 *
8 / 1,000,000,000 =3D 66.3 micro-seconds.  Switch latency is 5.7
microseconds so let's say network latency is 72 - well let's say 75
micro-seconds.  The only additional latency should be added by the
network stacks on the target and initiator.

Current round trip latency between the initiator (Linux) and target
(Nexenta) is around 400 micro-seconds and fluctuates significantly:

Hmm . .  this is worse than the last test:
PING 172.30.13.158 (172.30.13.158) 8192(8220) bytes of data.
8200 bytes from 172.30.13.158: icmp_seq=3D1 ttl=3D255 time=3D1.36 ms
8200 bytes from 172.30.13.158: icmp_seq=3D2 ttl=3D255 time=3D0.638 ms
8200 bytes from 172.30.13.158: icmp_seq=3D3 ttl=3D255 time=3D0.622 ms
8200 bytes from 172.30.13.158: icmp_seq=3D4 ttl=3D255 time=3D0.603 ms
8200 bytes from 172.30.13.158: icmp_seq=3D5 ttl=3D255 time=3D0.586 ms
8200 bytes from 172.30.13.158: icmp_seq=3D6 ttl=3D255 time=3D0.564 ms
8200 bytes from 172.30.13.158: icmp_seq=3D7 ttl=3D255 time=3D0.553 ms
8200 bytes from 172.30.13.158: icmp_seq=3D8 ttl=3D255 time=3D0.525 ms
8200 bytes from 172.30.13.158: icmp_seq=3D9 ttl=3D255 time=3D0.508 ms
8200 bytes from 172.30.13.158: icmp_seq=3D10 ttl=3D255 time=3D0.490 ms
8200 bytes from 172.30.13.158: icmp_seq=3D11 ttl=3D255 time=3D0.472 ms
8200 bytes from 172.30.13.158: icmp_seq=3D12 ttl=3D255 time=3D0.454 ms
8200 bytes from 172.30.13.158: icmp_seq=3D13 ttl=3D255 time=3D0.436 ms
8200 bytes from 172.30.13.158: icmp_seq=3D14 ttl=3D255 time=3D0.674 ms
8200 bytes from 172.30.13.158: icmp_seq=3D15 ttl=3D255 time=3D0.399 ms
8200 bytes from 172.30.13.158: icmp_seq=3D16 ttl=3D255 time=3D0.638 ms
8200 bytes from 172.30.13.158: icmp_seq=3D17 ttl=3D255 time=3D0.620 ms
8200 bytes from 172.30.13.158: icmp_seq=3D18 ttl=3D255 time=3D0.601 ms
8200 bytes from 172.30.13.158: icmp_seq=3D19 ttl=3D255 time=3D0.583 ms
8200 bytes from 172.30.13.158: icmp_seq=3D20 ttl=3D255 time=3D0.563 ms
8200 bytes from 172.30.13.158: icmp_seq=3D21 ttl=3D255 time=3D0.546 ms
8200 bytes from 172.30.13.158: icmp_seq=3D22 ttl=3D255 time=3D0.518 ms
8200 bytes from 172.30.13.158: icmp_seq=3D23 ttl=3D255 time=3D0.501 ms
8200 bytes from 172.30.13.158: icmp_seq=3D24 ttl=3D255 time=3D0.481 ms
8200 bytes from 172.30.13.158: icmp_seq=3D25 ttl=3D255 time=3D0.463 ms
8200 bytes from 172.30.13.158: icmp_seq=3D26 ttl=3D255 time=3D0.443 ms
8200 bytes from 172.30.13.158: icmp_seq=3D27 ttl=3D255 time=3D0.682 ms
8200 bytes from 172.30.13.158: icmp_seq=3D28 ttl=3D255 time=3D0.404 ms
8200 bytes from 172.30.13.158: icmp_seq=3D29 ttl=3D255 time=3D0.644 ms
8200 bytes from 172.30.13.158: icmp_seq=3D30 ttl=3D255 time=3D0.624 ms
8200 bytes from 172.30.13.158: icmp_seq=3D31 ttl=3D255 time=3D0.605 ms
8200 bytes from 172.30.13.158: icmp_seq=3D32 ttl=3D255 time=3D0.586 ms
8200 bytes from 172.30.13.158: icmp_seq=3D33 ttl=3D255 time=3D0.566 ms
^C
--- 172.30.13.158 ping statistics ---
33 packets transmitted, 33 received, 0% packet loss, time 32000ms
rtt min/avg/max/mdev =3D 0.399/0.574/1.366/0.161 ms

There is nothing going on in the network.  So we are seeing 574
micro-seconds total with only 150 micro-seconds attributed to
transmission.  And we see a wide variation in latency.

I then tested the latency between interfaces on the initiator and the
target.  Here is what I get for internal latency on the Linux initiator:
PING 172.30.13.18 (172.30.13.18) from 172.30.13.146 : 8192(8220) bytes
of data.
8200 bytes from 172.30.13.18: icmp_seq=3D1 ttl=3D64 time=3D0.033 ms
8200 bytes from 172.30.13.18: icmp_seq=3D2 ttl=3D64 time=3D0.019 ms
8200 bytes from 172.30.13.18: icmp_seq=3D3 ttl=3D64 time=3D0.019 ms
8200 bytes from 172.30.13.18: icmp_seq=3D4 ttl=3D64 time=3D0.018 ms
8200 bytes from 172.30.13.18: icmp_seq=3D5 ttl=3D64 time=3D0.018 ms
8200 bytes from 172.30.13.18: icmp_seq=3D6 ttl=3D64 time=3D0.017 ms
8200 bytes from 172.30.13.18: icmp_seq=3D7 ttl=3D64 time=3D0.018 ms
8200 bytes from 172.30.13.18: icmp_seq=3D8 ttl=3D64 time=3D0.018 ms
8200 bytes from 172.30.13.18: icmp_seq=3D9 ttl=3D64 time=3D0.019 ms
8200 bytes from 172.30.13.18: icmp_seq=3D10 ttl=3D64 time=3D0.018 ms
8200 bytes from 172.30.13.18: icmp_seq=3D11 ttl=3D64 time=3D0.019 ms
8200 bytes from 172.30.13.18: icmp_seq=3D12 ttl=3D64 time=3D0.018 ms
8200 bytes from 172.30.13.18: icmp_seq=3D13 ttl=3D64 time=3D0.018 ms
8200 bytes from 172.30.13.18: icmp_seq=3D14 ttl=3D64 time=3D0.018 ms
8200 bytes from 172.30.13.18: icmp_seq=3D15 ttl=3D64 time=3D0.019 ms
8200 bytes from 172.30.13.18: icmp_seq=3D16 ttl=3D64 time=3D0.017 ms
8200 bytes from 172.30.13.18: icmp_seq=3D17 ttl=3D64 time=3D0.019 ms
8200 bytes from 172.30.13.18: icmp_seq=3D18 ttl=3D64 time=3D0.017 ms
8200 bytes from 172.30.13.18: icmp_seq=3D19 ttl=3D64 time=3D0.019 ms
8200 bytes from 172.30.13.18: icmp_seq=3D20 ttl=3D64 time=3D0.018 ms
8200 bytes from 172.30.13.18: icmp_seq=3D21 ttl=3D64 time=3D0.018 ms
8200 bytes from 172.30.13.18: icmp_seq=3D22 ttl=3D64 time=3D0.018 ms
8200 bytes from 172.30.13.18: icmp_seq=3D23 ttl=3D64 time=3D0.019 ms
8200 bytes from 172.30.13.18: icmp_seq=3D24 ttl=3D64 time=3D0.018 ms
8200 bytes from 172.30.13.18: icmp_seq=3D25 ttl=3D64 time=3D0.018 ms
8200 bytes from 172.30.13.18: icmp_seq=3D26 ttl=3D64 time=3D0.017 ms
8200 bytes from 172.30.13.18: icmp_seq=3D27 ttl=3D64 time=3D0.019 ms
8200 bytes from 172.30.13.18: icmp_seq=3D28 ttl=3D64 time=3D0.018 ms
8200 bytes from 172.30.13.18: icmp_seq=3D29 ttl=3D64 time=3D0.018 ms
^C
--- 172.30.13.18 ping statistics ---
29 packets transmitted, 29 received, 0% packet loss, time 27999ms
rtt min/avg/max/mdev =3D 0.017/0.018/0.033/0.005 ms

A very consistent 18 micro-seconds.

Here is what I get from the Z200:
root@disk01:/etc# ping -s -i e1000g6 172.30.13.190 4096
PING 172.30.13.190: 4096 data bytes
4104 bytes from 172.30.13.190: icmp_seq=3D0. time=3D0.104 ms
4104 bytes from 172.30.13.190: icmp_seq=3D1. time=3D0.081 ms
4104 bytes from 172.30.13.190: icmp_seq=3D2. time=3D0.067 ms
4104 bytes from 172.30.13.190: icmp_seq=3D3. time=3D0.083 ms
4104 bytes from 172.30.13.190: icmp_seq=3D4. time=3D0.097 ms
4104 bytes from 172.30.13.190: icmp_seq=3D5. time=3D0.043 ms
4104 bytes from 172.30.13.190: icmp_seq=3D6. time=3D0.048 ms
4104 bytes from 172.30.13.190: icmp_seq=3D7. time=3D0.050 ms
4104 bytes from 172.30.13.190: icmp_seq=3D8. time=3D0.043 ms
4104 bytes from 172.30.13.190: icmp_seq=3D9. time=3D0.043 ms
4104 bytes from 172.30.13.190: icmp_seq=3D10. time=3D0.043 ms
4104 bytes from 172.30.13.190: icmp_seq=3D11. time=3D0.042 ms
4104 bytes from 172.30.13.190: icmp_seq=3D12. time=3D0.043 ms
4104 bytes from 172.30.13.190: icmp_seq=3D13. time=3D0.043 ms
4104 bytes from 172.30.13.190: icmp_seq=3D14. time=3D0.042 ms
4104 bytes from 172.30.13.190: icmp_seq=3D15. time=3D0.047 ms
4104 bytes from 172.30.13.190: icmp_seq=3D16. time=3D0.072 ms
4104 bytes from 172.30.13.190: icmp_seq=3D17. time=3D0.080 ms
4104 bytes from 172.30.13.190: icmp_seq=3D18. time=3D0.070 ms
4104 bytes from 172.30.13.190: icmp_seq=3D19. time=3D0.066 ms
4104 bytes from 172.30.13.190: icmp_seq=3D20. time=3D0.086 ms
4104 bytes from 172.30.13.190: icmp_seq=3D21. time=3D0.068 ms
4104 bytes from 172.30.13.190: icmp_seq=3D22. time=3D0.079 ms
4104 bytes from 172.30.13.190: icmp_seq=3D23. time=3D0.068 ms
4104 bytes from 172.30.13.190: icmp_seq=3D24. time=3D0.069 ms
4104 bytes from 172.30.13.190: icmp_seq=3D25. time=3D0.070 ms
4104 bytes from 172.30.13.190: icmp_seq=3D26. time=3D0.095 ms
4104 bytes from 172.30.13.190: icmp_seq=3D27. time=3D0.095 ms
4104 bytes from 172.30.13.190: icmp_seq=3D28. time=3D0.073 ms
4104 bytes from 172.30.13.190: icmp_seq=3D29. time=3D0.071 ms
4104 bytes from 172.30.13.190: icmp_seq=3D30. time=3D0.071 ms
^C
----172.30.13.190 PING Statistics----
31 packets transmitted, 31 packets received, 0% packet loss
round-trip (ms)  min/avg/max/stddev =3D 0.042/0.066/0.104/0.019

Notice it is several times longer latency with much wider variation.
How to we tune the opensolaris network stack to reduce it's latency? I'd
really like to improve the individual user experience.  I can tell them
it's like commuting to work on the train instead of the car during rush
hour - faster when there's lots of traffic but slower when there is not,
but they will judge the product by their individual experiences more
than their collective experiences.  Thus, I really want to improve the
individual disk operation throughput.

Latency seems to be our key.  If I can add only 20 micro-seconds of
latency from initiator and target each, that would be roughly 200 micro
seconds.  That would almost triple the throughput from what we are
currently seeing.

Unfortunately, I'm a bit ignorant of tweaking networks on opensolaris.
I can certainly learn but am I headed in the right direction or is this
direction of investigation misguided? Thanks - John

--=20
John A. Sullivan III
Open Source Development Corporation
+1 207-985-7880
jsullivan@opensourcedevel.com

http://www.spiritualoutreach.com
Making Christianity intelligible to secular society
