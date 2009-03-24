From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: Shell Scripts or Arbitrary Priority Callouts?
Date: Tue, 24 Mar 2009 20:17:35 +0200
Message-ID: <20090324181735.GR5528@edu.joroinen.fi>
References: <20090322152730.GC5528@edu.joroinen.fi>
	<1237801596.6577.28.camel@jaspav.missionsit.net.missionsit.net>
	<20090324073935.GK5528@edu.joroinen.fi>
	<1237892561.6560.19.camel@jaspav.missionsit.net.missionsit.net>
	<20090324115708.GM5528@edu.joroinen.fi>
	<1237897305.6560.26.camel@jaspav.missionsit.net.missionsit.net>
	<20090324150104.GO5528@edu.joroinen.fi>
	<1237909400.6560.80.camel@jaspav.missionsit.net.missionsit.net>
	<20090324163603.GQ5528@edu.joroinen.fi>
	<1237915811.6560.135.camel@jaspav.missionsit.net.missionsit.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1237915811.6560.135.camel@jaspav.missionsit.net.missionsit.net>
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

On Tue, Mar 24, 2009 at 01:30:10PM -0400, John A. Sullivan III wrote:
> Thanks very much, again, and, again, I'll reply in the text - John
> 

Np :)

> > 
> > iirc 2810 does not have very big buffers per port, so you might be better
> > using flow control instead of jumbos.. then again I'm not sure how good flow
> > control implementation HP has? 
> > 
> > The whole point of flow control is to prevent packet loss/drop.. this happens
> > with sending pause frames before the port buffers get full. If port buffers
> > get full then the switch doesn't have any other option than to drop the
> > packets.. and this causes tcp-retransmits -> causes delay and tcp slows down
> > to prevent further packet drops.
> > 
> > flow control "pause frames" cause less delay than tcp-retransmits. 
> > 
> > Do you see tcp retransmits with "netstat -s" ? Check both the target and the initiators.
> Thankfully this is an area of some expertise for me (unlike disk I/O -
> obviously ;)  ).  We have been pretty thorough about checking the
> network path.  We've not seen any upper layer retransmission or buffer
> overflows.

Good :)

> > > > > > What kind of performance do you get using just a single iscsi session (and
> > > > > > thus just a single path), no multipathing, no DM RAID0 ? Just a filesystem
> > > > > > directly on top of the iscsi /dev/sd? device.
> > > > > Miserable - same roughly 12 MB/s.
> > > > 
> > > > OK, Here's your problem. Was this btw reads or writes? Did you tune
> > > > readahead-settings? 
> > > 12MBps is sequential reading but sequential writing is not much
> > > different.  We did tweak readahead to 1024. We did not want to go much
> > > larger in order to maintain balance with the various data patterns -
> > > some of which are random and some of which may not read linearly.
> > 
> > I did some benchmarking earlier between two servers; other one running ietd
> > target with 'nullio' and other running open-iscsi initiator. Both using a single gigabit NIC. 
> > 
> > I remember getting very close to full gigabit speed at least with bigger
> > block sizes. I can't remember how much I got with 4 kB blocks. 
> > 
> > Those tests were made with dd.
> Yes, if we use 64KB blocks, we can saturate a Gig link.  With larger
> sizes, we can push over 3 Gpbs over the four gig links in the test
> environment.

That's good. 

> > 
> > nullio target is a good way to benchmark your network and initiator and
> > verify everything is correct. 
> > 
> > Also it's good to first test for example with FTP and Iperf to verify
> > network is working properly between target and the initiator and all the
> > other basic settings are correct.
> We did flood ping the network and had all interfaces operating at near
> capacity.  The network itself looks very healthy.

Ok. 

> > 
> > Btw have you configured tcp stacks of the servers? Bigger default tcp window
> > size, bigger maximun tcp window size etc.. 
> Yep, tweaked transmit queue length, receive and transmit windows, net
> device backlogs, buffer space, disabled nagle, and even played with the
> dirty page watermarks.

That's all taken care of then :) 

Also on the target? 

> > 
> > > > 
> > > > Can paste your iSCSI session settings negotiated with the target? 
> > > Pardon my ignorance :( but, other than packet traces, how do I show the
> > > final negotiated settings?
> > 
> > Try:
> > 
> > iscsiadm -i -m session
> > iscsiadm -m session -P3
> > 
> Here's what it says.  Pretty much as expected.  We are using COMSTAR on
> the target and took some traces to see what COMSTAR was expecting. We
> set the open-iscsi parameters to match:
> 
> Current Portal: 172.x.x.174:3260,2
>         Persistent Portal: 172.x.x.174:3260,2
>                 **********
>                 Interface:
>                 **********
>                 Iface Name: default
>                 Iface Transport: tcp
>                 Iface Initiatorname: iqn.2008-05.biz.ssi:vd-gen
>                 Iface IPaddress: 172.x.x.162
>                 Iface HWaddress: default
>                 Iface Netdev: default
>                 SID: 32
>                 iSCSI Connection State: LOGGED IN
>                 iSCSI Session State: LOGGED_IN
>                 Internal iscsid Session State: NO CHANGE
>                 ************************
>                 Negotiated iSCSI params:
>                 ************************
>                 HeaderDigest: None
>                 DataDigest: None
>                 MaxRecvDataSegmentLength: 131072
>                 MaxXmitDataSegmentLength: 8192
>                 FirstBurstLength: 65536
>                 MaxBurstLength: 524288
>                 ImmediateData: Yes
>                 InitialR2T: Yes

I guess InitialR2T could be No for a bit better performance? 

MaxXmitDataSegmentLength looks small? 

> > > > You should be able to get many times the throughput you get now.. just with
> > > > a single path/session.
> > > > 
> > > > What kind of latency do you have from the initiator to the target/storage? 
> > > > 
> > > > Try with for example 4 kB ping:
> > > > ping -s 4096 <ip_of_the_iscsi_target>
> > > We have about 400 micro seconds - that seems a bit high :(
> > > rtt min/avg/max/mdev = 0.275/0.337/0.398/0.047 ms
> > > 
> > 
> > Yeah.. that's a bit high. 
> Actually, with more testing, we're seeing it stretch up to over 700
> micro-seconds.  I'll attach a raft of data I collected at the end of
> this email.

Ok.

> > I think Ross suggested in some other thread the following settings for e1000
> > NICs:
> > 
> > "Set the e1000s InterruptThrottleRate=1 and their TxRingBufferSize=4096
> > and RxRingBufferSize=4096 (verify those option names with a modinfo)
> > and add those to modprobe.conf."
> We did try playing with the ring buffer but to no avail.  Modinfo does
> not seem to display the current settings.  We did try playing with
> setting the InterruptThrottleRate to 1 but again to no avail.  As I'll
> mention later, I suspect the issue might be the opensolaris based
> target.

Could be..

> > 
> > > I would love to use larger block sizes as you suggest in your other
> > > email but, on AMD64, I believe we are stuck with 4KB.  I've not seen any
> > > way to change it and would gladly do so if someone knows how.
> > > 
> > 
> > Are we talking about filesystem block sizes? That shouldn't be a problem if
> > your application uses larger blocksizes for read/write operations.. 
> > 
> Yes, file system block size.  When we try rough, end user style tests,
> e.g., large file copies, we seem to get the performance indicated by 4KB
> blocks, i.e., lousy!

Yep.. try upgrading to 10 Gbit Ethernet for much lower latency ;)

> > Try for example with:
> > dd if=/dev/zero of=/iscsilun/file.bin bs=1024k count=1024
> Large block sizes can make the system truly fly so we suspect you are
> absolutely correct about latency being the issue.  We did do our testing
> with raw interfaces by the way.

Ok.

> <snip>
> I did a little digging and calculating and here is what I came up with
> and sent to Nexenta.  Please tell me if I am on the right track.
> 
> I am using jumbo frames and should be able to get 2 4KB blocks
> per frame.  Total size should be 8192 + 78 (TCP + IP + Ethernet + CRC
> -oops we need to add iSCSI -what size is the iSCSI header?) + 12
> (interframe gap) = 8282 bytes.  Transmission latency should be 8282 *
> 8 / 1,000,000,000 = 66.3 micro-seconds.  Switch latency is 5.7
> microseconds so let's say network latency is 72 - well let's say 75
> micro-seconds.  The only additional latency should be added by the
> network stacks on the target and initiator.
> 
> Current round trip latency between the initiator (Linux) and target
> (Nexenta) is around 400 micro-seconds and fluctuates significantly:
> 
> Hmm . .  this is worse than the last test:
> PING 172.30.13.158 (172.30.13.158) 8192(8220) bytes of data.

> --- 172.30.13.158 ping statistics ---
> 33 packets transmitted, 33 received, 0% packet loss, time 32000ms
> rtt min/avg/max/mdev = 0.399/0.574/1.366/0.161 ms
> 
> There is nothing going on in the network.  So we are seeing 574
> micro-seconds total with only 150 micro-seconds attributed to
> transmission.  And we see a wide variation in latency.
>

Yeah something wrong there.. How much latency do you have between different
initiator machines? 
 
> I then tested the latency between interfaces on the initiator and the
> target.  Here is what I get for internal latency on the Linux initiator:
> PING 172.30.13.18 (172.30.13.18) from 172.30.13.146 : 8192(8220) bytes
> of data.
> --- 172.30.13.18 ping statistics ---
> 29 packets transmitted, 29 received, 0% packet loss, time 27999ms
> rtt min/avg/max/mdev = 0.017/0.018/0.033/0.005 ms
> 
> A very consistent 18 micro-seconds.
> 

Yeah, I take it that's not through network/switch :) 

> Here is what I get from the Z200:
> root@disk01:/etc# ping -s -i e1000g6 172.30.13.190 4096
> PING 172.30.13.190: 4096 data bytes
> ----172.30.13.190 PING Statistics----
> 31 packets transmitted, 31 packets received, 0% packet loss
> round-trip (ms)  min/avg/max/stddev = 0.042/0.066/0.104/0.019
> 

Big difference.. I'm not familiar with Solaris, so can't really suggest what
to tune there.. 

> Notice it is several times longer latency with much wider variation.
> How to we tune the opensolaris network stack to reduce it's latency? I'd
> really like to improve the individual user experience.  I can tell them
> it's like commuting to work on the train instead of the car during rush
> hour - faster when there's lots of traffic but slower when there is not,
> but they will judge the product by their individual experiences more
> than their collective experiences.  Thus, I really want to improve the
> individual disk operation throughput.
> 
> Latency seems to be our key.  If I can add only 20 micro-seconds of
> latency from initiator and target each, that would be roughly 200 micro
> seconds.  That would almost triple the throughput from what we are
> currently seeing.
> 

Indeed :) 

> Unfortunately, I'm a bit ignorant of tweaking networks on opensolaris.
> I can certainly learn but am I headed in the right direction or is this
> direction of investigation misguided? Thanks - John
> 

Low latency is the key for good (iSCSI) SAN performance, as it directly
gives you more (possible) IOPS. 

Other option is to configure software/settings so that there are multiple
outstanding IO's on the fly.. then you're not limited with the latency (so much).

-- Pasi
