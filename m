From: "John A. Sullivan III" <jsullivan@opensourcedevel.com>
Subject: Re: multipath prio_callout broke from 5.2 to 5.3
Date: Thu, 23 Apr 2009 14:22:31 -0400
Message-ID: <1240510951.6395.22.camel@jaspav.missionsit.net.missionsit.net>
References: <1779195765.1578721239520436084.JavaMail.root@zimbra16-e3.priv.proxad.net>
	<1239613205.6376.16.camel@jaspav.missionsit.net.missionsit.net>
	<20090413185745.GF15911@ether.msp.redhat.com>
	<1239652565.30476.41.camel@jaspav.missionsit.net.missionsit.net>
	<20090413203711.GH15911@ether.msp.redhat.com>
	<1239659354.30476.49.camel@jaspav.missionsit.net.missionsit.net>
	<49F0AEA0.9050803@nrel.colostate.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49F0AEA0.9050803@nrel.colostate.edu>
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

On Thu, 2009-04-23 at 12:08 -0600, Ty! Boyack wrote:
> This thread has been great information since I'm looking at the same 
> type of thing.  However it raises a couple of (slightly off-topic) 
> questions for me. 
> 
> My recent upgrade to fedora 10 broke my prio_callout bash script just 
> like you described, but my getuid_callout (a bash script that calls 
> udevadm, grep, sed, and iscsi_id) runs just fine.  Are the two callouts 
> handled differently?
> 
> Also, is there an easy way to know what tools are in the private 
> namespace already?  My prio_callout script calls two other binaries: 
> /sbin/udevadm and grep.  If I go to C-code, handling grep's functions 
> myself is no problem, but I'm not confident about re-implementing what 
> udevadm does.  Can I assume that since /sbin/udevadm is in /sbin that it 
> will be available to call via exec()?  Or would I be right back where we 
> are with the bash scripting, as in having to include a dummy device as 
> you described?
> 
> Finally, in my case I've got two redundant iscsi networks, one is 1GbE, 
> and the other is 10GbE.  In the past I've always had symetric paths, so 
> I've used round-robin/multibus.  But I want to focus traffic on the 
> 10GbE path, so I was looking at using the prio callout.  Is this even 
> necessary?  Or will round-robin/multibus take full advantage of both 
> paths?  I can see round-robin on that setup resulting in either around 
> 11Gbps or 2 Gbps, depending on whether the slower link becomes a 
> limiting factor.  I'm just wondering if I am making things unnecessarily 
> complex by trying to set priorities.
> 
> Thanks for all the help.
> 
> -Ty!
> 
I can't answer the questions regarding the internals.  I did make sure
my bash scripts called not external applications and I placed everything
in /sbin.

I did find I was able to pick and choose which connections had which
priorities - that was the whole purpose of my script.  In my case, there
were many networks and I wanted prioritized failover to try to balance
the load across interfaces and keep failover traffic on the same switch
rather than crossing a bonded link to another switch.  I did it by cross
referencing the mappings in /dev/disk/by-path with a prioritized list of
mappings.  I believe I posted the entire setup in an earlier e-mail.  If
you'd like, I can post the details again.

As I reread your post a little more closely, I wonder if using multibus
as you describe will not slow you down to the lowest common denominator.
I know when I tested with RAID0 across several interfaces to load
balance traffic (this seemed to give better average performance across a
wide range of I/O patterns than multi-bus with varying rr_min_io
settings), I had three e1000e NICs and one on board NIC. When I replaced
the on-board with another e1000e, I saw a substantial performance
improvement.  I don't know if that will be your experience for sure but
pass it along as a caveat. Hope this helps - John
-- 
John A. Sullivan III
Open Source Development Corporation
+1 207-985-7880
jsullivan@opensourcedevel.com

http://www.spiritualoutreach.com
Making Christianity intelligible to secular society
