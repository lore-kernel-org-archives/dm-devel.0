From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: Shell Scripts or Arbitrary Priority Callouts?
Date: Sun, 22 Mar 2009 17:27:30 +0200
Message-ID: <20090322152730.GC5528@edu.joroinen.fi>
References: <7bc80d500903181557x295480feia73d0c23992c6f65@mail.gmail.com>
	<1237460677.6506.5.camel@jaspav.missionsit.net.missionsit.net>
	<7bc80d500903192211k6baadc81ge1b9d8b81ea6a913@mail.gmail.com>
	<1237543283.6572.10.camel@jaspav.missionsit.net.missionsit.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1237543283.6572.10.camel@jaspav.missionsit.net.missionsit.net>
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

On Fri, Mar 20, 2009 at 06:01:23AM -0400, John A. Sullivan III wrote:
> > 
> > John:
> > 
> > Thanks for the reply.
> > 
> > I ended up writing a small C program to do the priority computation for me.
> > 
> > I have two sets of FC-AL shelves attached to two dual-channel Qlogic
> > cards. That gives me two paths to each disk. I have about 56 spindles
> > in the current configuration, and am tying them together with md
> > software raid.
> > 
> > Now, even though each disk says it handles concurrent I/O on each
> > port, my testing indicates that throughput suffers when using multibus
> > by about 1/2 (from ~60 MB/sec sustained I/O with failover to 35 MB/sec
> > when using multibus).
> > 
> > However, with failover, I am effectively using only one channel on
> > each card. With my custom priority callout, I more or less match the
> > disks with even numbers to the even numbered scsi channels with a
> > higher priority. Same with the odd numbered disks and odd numbered
> > channels. The odds are 2ndary on even and vice versa. It seems to work
> > rather well, and appears to spread the load nicely.
> > 
> > Thanks again for your help!
> > 
> I'm really glad you brought up the performance problem. I had posted
> about it a few days ago but it seems to have gotten lost.  We are really
> struggling with performance issues when attempting to combine multiple
> paths (in the case of multipath to one big target) or targets (in the
> case of software RAID0 across several targets) rather than using, in
> effect, JBODs.  In our case, we are using iSCSI.
> 
> Like you, we found that using multibus caused almost a linear drop in
> performance.  Round robin across two paths was half as much as aggregate
> throughput to two separate disks, four paths, one fourth.
> 
> We also tried striping across the targets with software RAID0 combined
> with failover multipath - roughly the same effect.
> 
> We really don't want to be forced to treated SAN attached disks as
> JDOBs.  Has anyone cracked this problem of using them in either multibus
> or RAID0 so we can present them as a single device to the OS and still
> load balance multiple paths.  This is a HUGE problem for us so any help
> is greatly appreciated.  Thanks- John

Hello.

Hmm.. just a guess, but could this be related to the fact that if your paths
to the storage are different iSCSI sessions (open-iscsi _doesn't_ support
multiple connections per session aka MC/s), then there is a separate SCSI
command queue per path.. and if SCSI requests are split across those queues 
they can get out-of-order and that causes performance drop?

See:
http://www.nabble.com/round-robin-with-vmware-initiator-and-iscsi-target-td21958346.html

Especially the reply from Ross (CC). Maybe he has some comments :) 

-- Pasi
