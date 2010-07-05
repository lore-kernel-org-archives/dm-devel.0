From: "John A. Sullivan III" <jsullivan@opensourcedevel.com>
Subject: Re: understanding of multipathing and speed
Date: Mon, 05 Jul 2010 15:41:46 -0400
Message-ID: <1278358906.3323.18.camel@localhost>
References: <201007052037.39362.bart.coninckx@telenet.be>
	<1278356310.30539.606.camel@localhost>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1278356310.30539.606.camel@localhost>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@opensvc.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, 2010-07-05 at 20:58 +0200, Christophe Varoqui wrote:
> On lun., 2010-07-05 at 20:37 +0200, Bart Coninckx wrote:
> > Hi,
> > 
> > I would like to run my ideas by this list about multipathing and the results 
> > as far as storage speed is concerned.
> > 
> > I'm using multipathing to two iSCSI targets pointing to the same storage. It 
> > was my understanding that this provides for network path redundancy (and it 
> > does, I tested this) but also for added speed. 
> > I did some tests with Bonnie++ however while both paths were active and one 
> > path was down and the results are basically the same. 
> > 
> > Am I assuming wrong things? Or have I configured things wrong?
> > 
> can you also include a 'multipath -l' output and sketch the
> hba/switch/controller physical connections ?
> 
> thanks,
I am by no means an expert but I did find a significant speed advantage
but it depended on how we tested.  We found if we sent a single thread
of reads or writes, there was no gain. However, as we started adding
multiple, simultaneous reads and writes, there was a dramatic gain.

We were actually testing two different scenarios:
1) dm-multipath for both fault tolerance and load balancing
2) dm-multipath for fault-tolerance and software RAID0 for load
balancing


This testing was mostly performed using Linux File I/O or by imitating
Linux File I/O by setting the maximum block size to 4KB. That meant our
iSCSI connection was limited more by latency than throughput.

We found the latter gave more well rounded performance, i.e., over a
wide range of I/O characteristics.  However, we subsequently learned
that it created a consistency problem for snapshooting on the SAN
back-end.  We could not guarantee that the snapshot would be in a
consistent RAID0 state.  Thus, we plan to convert our systems back to
multibus for load balancing.

Another item that surprised us was the setting for how many commands
should be issued before switching paths (I forget the parameter name).
I would have expected a lower number to give better throughput but to
drive up CPU utilization.  That did not turn out to be true even on
systems with plenty of CPU power to spare.  We found that a setting of
100 performed marginally but consistently better than a setting of 10.
I do not know why that is.  Perhaps this is again because we were
latency and not throughput bound.  Perhaps the switching adds latency.

I do not know the internals to know if multibus could possibly help for
a single iSCSI conversation.  The blocks must still be sent in series (I
assume) so I would think the packets would just round robin around the
NICS but not be sent in parallel.  When loading multiple iSCSI
conversation, I would think all the NICs could be firing at the same
time with different iSCSI series. Again, I am guessing in my ignorance.

Can anyone else confirm or refute these deductions? Thanks - John
