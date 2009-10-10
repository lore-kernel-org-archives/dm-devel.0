From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: dmcache project
Date: Sat, 10 Oct 2009 22:02:16 +0100
Message-ID: <20091010210216.GD19397@agk-dp.fab.redhat.com>
References: <4bbcfcd40910101336t4cf3824bsf6fb58e12c350953@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4bbcfcd40910101336t4cf3824bsf6fb58e12c350953@mail.gmail.com>
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

On Sun, Oct 11, 2009 at 02:06:41AM +0530, ganesh kumar wrote:
>       I am working on the dmcacheio project which is described in the
> http://kernelnewbies.org/KernelProjects/DmCache.I am newbie to he
> kernel modules..kindly give me the ideas to implement the project
> through device mapper.hoping replies
 
Quite a difficult project in my opinion.

I'd suggest first isolating some features that you believe would
contribute to a solution to part of the stated problem and implementing
them as building blocks to use later.   Above that, a complex tunable
logic layer (mostly in userspace perhaps) making the decisions about
which building blocks to use and how to connect and tune them based on
live system information and feedback from small changes it attempts
('experiments') to see if they make the system perform better or worse
(based on clear configurable criteria you'll need to develop).

Start by understanding what we have in dm targets already - both
upstream (snapshots, multipath) and not yet upstream (replication,
raid45, iostats, shared snapshots) and consider ways of hooking into
relevant parts of that by improving or extending interfaces.  (You may
discover some of the building blocks and interfaces you need already
exist.)

Alasdair
