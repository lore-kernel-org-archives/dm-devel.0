From: "John A. Sullivan III" <jsullivan@opensourcedevel.com>
Subject: Re: multipath prio_callout broke from 5.2 to 5.3
Date: Thu, 23 Apr 2009 23:44:24 -0400
Message-ID: <1240544664.6374.15.camel@jaspav.missionsit.net.missionsit.net>
References: <1779195765.1578721239520436084.JavaMail.root@zimbra16-e3.priv.proxad.net>
	<1239613205.6376.16.camel@jaspav.missionsit.net.missionsit.net>
	<20090413185745.GF15911@ether.msp.redhat.com>
	<1239652565.30476.41.camel@jaspav.missionsit.net.missionsit.net>
	<20090413203711.GH15911@ether.msp.redhat.com>
	<1239659354.30476.49.camel@jaspav.missionsit.net.missionsit.net>
	<49F0AEA0.9050803@nrel.colostate.edu>
	<1240510951.6395.22.camel@jaspav.missionsit.net.missionsit.net>
	<49F12D53.4020109@nrel.colostate.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49F12D53.4020109@nrel.colostate.edu>
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
List-Id: dm-devel.ids

On Thu, 2009-04-23 at 21:09 -0600, Ty! Boyack wrote:
> Thanks John.  I think that you and I are doing very similar things, but 
> there is one thing in your technique that would cause me problems.  I 
> start multipathd at system boot time, but my iscsi devices get connected 
> (and disconnected) later as the system runs, so the list you generate 
> when you start multipathd (to map /dev/sdX names to their 
> /dev/disk/by-path counterpart) is not available when multipathd starts 
> for me. 
We do intentionally delay multipathd until later in the process.  We
first add some logic to ensure the SAN is available (for example when
bootstrapping the entire environment), then setup the sessions, then
activate multipath, then set the read ahead buffer and finally setup the
final devices, e.g., RAID0, encryption, etc. (although we have found
encryption intolerably slow on iSCSI).
> 
> However, it seems we are indeed facing the same issue:  We want to be 
> able to specify path priorities based on some criteria in the 
> /dev/disk/by-path name.  I usually get this from '/sbin/udevadm info 
> --query=env --name=/dev/sdX', and in fact I usually only care about the 
> ID_PATH variable out of that.  Would you also be able to get the 
> information you need out of this type of output? (If the 'env' query is 
> not enough, maybe 'all' would be better)
It sounds like you know much more about this than I do.  I'm one of
those management types who has been plunged back into engineering while
awaiting our funding so I'm fumbling my way through badly.  I would
assume your approach is superior to mine.
> 
> Ben mentioned that if this was something that was a common need that 
> maybe a shared object could be added upstream to make this a general 
> solution.  I'm thinking that a module could be written that would do 
> this type of query on the device, and then look up the priority in a 
> simple expression file that might look something like:
> 
> <regular expression><priority>
I think there is a problem in using a separate file in that it is not
available to multipathd.  Somehow, it needs to be incorporated into
whatever multipathd has in memory. That is why we have our priomaker
script which sews together the list and the bash script into the final
bash script which is then loaded into multipathd.  Then again, maybe we
can use the "dummy device" trick to pull the expression file into the
multipathd namespace.
> 
> In my case I could just look for something like /ID_PATH=ip-10.0.x/ to 
> see if it is on the particular network in question, and then set the 
> priority.  You might search for entire iqn names.  But this would be 
> flexible to allow anyone to set priority based on the udev parameters of 
> vendor, model, serial numbers, iqn path, etc.
> 
> I don't know if it is feasible to query udev in this environment -- 
> perhaps someone closer to the internals could answer that.  (It looks 
> like it could also be pulled from /sys, but I'm not too familiar with 
> that structure, and we would need to make sure it was not too dependent 
> on kernel changes which might change that structure).
> 
> Thoughts?
> 
> -Ty!
> 
> John A. Sullivan III wrote:
> > On Thu, 2009-04-23 at 12:08 -0600, Ty! Boyack wrote:
> >   
> >> This thread has been great information since I'm looking at the same 
> >> type of thing.  However it raises a couple of (slightly off-topic) 
> >> questions for me. 
> >>
> >> My recent upgrade to fedora 10 broke my prio_callout bash script just 
> >> like you described, but my getuid_callout (a bash script that calls 
> >> udevadm, grep, sed, and iscsi_id) runs just fine.  Are the two callouts 
> >> handled differently?
> >>
> >> Also, is there an easy way to know what tools are in the private 
> >> namespace already?  My prio_callout script calls two other binaries: 
> >> /sbin/udevadm and grep.  If I go to C-code, handling grep's functions 
> >> myself is no problem, but I'm not confident about re-implementing what 
> >> udevadm does.  Can I assume that since /sbin/udevadm is in /sbin that it 
> >> will be available to call via exec()?  Or would I be right back where we 
> >> are with the bash scripting, as in having to include a dummy device as 
> >> you described?
> >>
> >> Finally, in my case I've got two redundant iscsi networks, one is 1GbE, 
> >> and the other is 10GbE.  In the past I've always had symetric paths, so 
> >> I've used round-robin/multibus.  But I want to focus traffic on the 
> >> 10GbE path, so I was looking at using the prio callout.  Is this even 
> >> necessary?  Or will round-robin/multibus take full advantage of both 
> >> paths?  I can see round-robin on that setup resulting in either around 
> >> 11Gbps or 2 Gbps, depending on whether the slower link becomes a 
> >> limiting factor.  I'm just wondering if I am making things unnecessarily 
> >> complex by trying to set priorities.
> >>
> >> Thanks for all the help.
> >>
> >> -Ty!
> >>
> >>     
> > I can't answer the questions regarding the internals.  I did make sure
> > my bash scripts called not external applications and I placed everything
> > in /sbin.
> >
> > I did find I was able to pick and choose which connections had which
> > priorities - that was the whole purpose of my script.  In my case, there
> > were many networks and I wanted prioritized failover to try to balance
> > the load across interfaces and keep failover traffic on the same switch
> > rather than crossing a bonded link to another switch.  I did it by cross
> > referencing the mappings in /dev/disk/by-path with a prioritized list of
> > mappings.  I believe I posted the entire setup in an earlier e-mail.  If
> > you'd like, I can post the details again.
> >
> > As I reread your post a little more closely, I wonder if using multibus
> > as you describe will not slow you down to the lowest common denominator.
> > I know when I tested with RAID0 across several interfaces to load
> > balance traffic (this seemed to give better average performance across a
> > wide range of I/O patterns than multi-bus with varying rr_min_io
> > settings), I had three e1000e NICs and one on board NIC. When I replaced
> > the on-board with another e1000e, I saw a substantial performance
> > improvement.  I don't know if that will be your experience for sure but
> > pass it along as a caveat. Hope this helps - John
> >   
> 
> 
-- 
John A. Sullivan III
Open Source Development Corporation
+1 207-985-7880
jsullivan@opensourcedevel.com

http://www.spiritualoutreach.com
Making Christianity intelligible to secular society
