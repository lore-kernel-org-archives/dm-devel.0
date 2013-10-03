From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Reworking dm-writeboost [was: Re: staging: Add
 dm-writeboost]
Date: Wed, 2 Oct 2013 20:01:45 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1310021956130.22612@file01.intranet.prod.int.rdu2.redhat.com>
References: <5223208D.4000008@gmail.com> <20130916215357.GA5015@redhat.com>
	<52384E66.6050101@gmail.com> <20130917205936.GB12001@redhat.com>
	<523E3522.2060607@gmail.com> <524183A2.9050301@gmail.com>
	<20130926034325.GO26872@dastard> <20131001082654.GA10326@debian>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20131001082654.GA10326@debian>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <thornber@redhat.com>
Cc: devel@driverdev.osuosl.org, snitzer@redhat.com, gregkh@linuxfoundation.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Akira Hayakawa <ruby.wktk@gmail.com>, dm-devel@redhat.com, dan.carpenter@oracle.com, joe@perches.com, akpm@linux-foundation.org, m.chehab@samsung.com, ejt@redhat.com, agk@redhat.com, cesarb@cesarb.net
List-Id: dm-devel.ids



On Tue, 1 Oct 2013, Joe Thornber wrote:

> > Alternatively, delaying them will stall the filesystem because it's
> > waiting for said REQ_FUA IO to complete. For example, journal writes
> > in XFS are extremely IO latency sensitive in workloads that have a
> > signifincant number of ordering constraints (e.g. O_SYNC writes,
> > fsync, etc) and delaying even one REQ_FUA/REQ_FLUSH can stall the
> > filesystem for the majority of that barrier_deadline_ms.
> 
> Yes, this is a valid concern, but I assume Akira has benchmarked.
> With dm-thin, I delay the REQ_FUA/REQ_FLUSH for a tiny amount, just to
> see if there are any other FUA requests on my queue that can be
> aggregated into a single flush.  I agree with you that the target
> should never delay waiting for new io; that's asking for trouble.
> 
> - Joe

You could send the first REQ_FUA/REQ_FLUSH request directly to the disk 
and aggregate all the requests that were received while you processed the 
initial request. This way, you can do request batching without introducing 
artifical delays.

Mikulas
