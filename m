From: "John A. Sullivan III" <jsullivan@opensourcedevel.com>
Subject: Re: [Multipath] Round-robin performance limit
Date: Thu, 22 Dec 2011 19:54:46 -0500
Message-ID: <1324601686.10184.6.camel@denise.theartistscloset.com>
References: <BANLkTikyCtPX8L=7h94hTm4TjOYDyb7nxQ@mail.gmail.com>
	<20110502072528.GW32595@reaktio.net>
	<BANLkTi=h0AwEy0S4Miv-SYTEu3jF0DXXJQ@mail.gmail.com>
	<1304375238.3134.23.camel@denise.theartistscloset.com>
	<20110503050406.GA11442@us.ibm.com>
	<1304417561.25728.16.camel@denise.theartistscloset.com>
	<CANtKaxLFSvg-iMGJ-fKPM=9HR1ORWOdMoEs2uQJkSGR-JpesYg@mail.gmail.com>
	<CANtKax+RqXJeor4dBzQewWT+k8EG2s63NFYSi=pRN0v3MLPKBA@mail.gmail.com>
	<1317784026.31536.7.camel@denise.theartistscloset.com>
	<CANtKax+PzU=yVepQh3Kq7NK671-bSpYfms2Xu_YgdXQ0cDG6kA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CANtKax+PzU=yVepQh3Kq7NK671-bSpYfms2Xu_YgdXQ0cDG6kA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: "Paul T. Bibaud" <paul.b@pogolinux.com>
List-Id: dm-devel.ids

On Wed, 2011-10-05 at 15:54 -0400, Adam Chasen wrote:
> John,
> I am limited in a similar fashion. I would much prefer to use multibus
> multipath, but was unable to achieve bandwidth which would exceed a
> single link even though it was spread over the 4 available links. Were
> you able to gain even a similar performance of the RAID0 setup with
> the multibus multipath?
> 
> Thanks,
> Adam
<snip>
We just ran a quick benchmark before optimizing.  Using multibus rather
than RAID0 with four GbE NICs, and testing with a simple cat /dev/zero >
zeros, we hit 3.664 Gbps!

This is still on CentOS 5.4 so we are not able to play with
rr_min_io_rq.  We have not yet activated jumbo frames. We are also
thinking of using SFQ as a qdisc instead of the default pfifo_fast.  So,
we think we can make it go even faster.

We are delighted to be achieving this with multibus rather than RAID0 as
it means we can take transactionally consistent snapshots on the SAN.

Many thanks to whomever pointed out that tag queueing should solve the
4KB block size latency problem.  The problem turned out to not be
latency as we were told but simply an under resources SAN.  We brought
in new Nexenta SANs with much more RAM and they are flying - John
