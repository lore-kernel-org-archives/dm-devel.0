From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: Barriers still not passing on simple dm devices...
Date: Sun, 05 Apr 2009 04:54:46 -0700
Message-ID: <49D89C06.1060700__43896.3396977217$1239273363$gmane$org@gmail.com>
References: <20090324150517.GX27476@kernel.dk>
	<Pine.LNX.4.64.0903251106520.27750@hs20-bc2-1.build.redhat.com>
	<20090325152751.GV27476@kernel.dk>
	<Pine.LNX.4.64.0903251825310.8027@hs20-bc2-1.build.redhat.com>
	<20090326084205.GG27476@kernel.dk>
	<Pine.LNX.4.64.0903302314500.6158@hs20-bc2-1.build.redhat.com>
	<20090331104933.GJ5178@kernel.dk>
	<Pine.LNX.4.64.0904021923040.19415@hs20-bc2-1.build.redhat.com>
	<20090403081131.GP5178@kernel.dk> <49D77AC3.3020207@redhat.com>
	<20090405012839.GF7553@mit.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090405012839.GF7553@mit.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Theodore Tso <tytso@mit.edu>, Ric Wheeler <rwheeler@redhat.com>, Jens Axboe <jens.axboe@oracle.com>, Mikulas Patocka <mpatocka@redhat.com>, device-mapper development <dm-devel@redhat.c>
List-Id: dm-devel.ids

On 04/04/2009 06:28 PM, Theodore Tso wrote:
> On Sat, Apr 04, 2009 at 11:20:35AM -0400, Ric Wheeler wrote:
>    
>> Barriers do work as we have them, but as others have mentioned, it is
>> not a "free" win - fsync will actually move your data safely out to
>> persistent storage for a huge percentage of real users (including every
>> ATA/S-ATA and SAS drive I was able to test).  The file systems I
>> monitored in production use without barriers were much less reliable.
>>      
>
> The problem is that, as long as you're not under memory pressure, and
> not pushing the filesystem heavily, ext3 didn't corrupt *that* often
> without barriers.  So people got away with it "most of the time" ---
> just as applications replacing files by rewriting them in place using
> truncate and w/o fsync would "usually" not lose data after a crash if
> they were using ext3 with data=ordered mode.  This caused people to
> get lazy/sloppy.
>
> So yes, barriers were something that were largely ignored for a long
> time.  After all, in a server environment with UPS's, without crappy
> proprietary video drivers, Linux systems didn't crash that often
> anyway.  So you really needed a large base of systems and with the
> ability to root cause failures such as what Ric had at EMC to see the
> problem.
>    

One thing to point out here is that there are a lot of "servers" in high 
end data centers that do not have UPS backup. Those racks full of 1U and 
2U boxes that are used to make "grids", "clouds" and so on often are 
built with as much gear as you can stuff in a rack - no batteries or UPS 
to be seen, so they are really quite similar to the normal desktop or 
home systems that we normally run at home :-)

ric


> Even now, the reason why ext3 doesn't have barriers enabled by default
> (although we did make them the default for ext4) is because Andrew
> doesn't believe Chris's replication case is likely to be true for most
> users in practice, and he's concerned about the performance
> degradation of barriers.  He's basically depending on the fact that
> "usually" you can get away without using barriers.  Sigh....
>
> 						- Ted
>
> P.S.  Of course, distributions should feel free to consider changing
> the default on their kernels.  SLES has already if memory serves
> correctly.  I don't know if RHEL has yet.
>
>
>    
