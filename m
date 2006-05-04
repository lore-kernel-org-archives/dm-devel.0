From: "Philip R. Auld" <pauld@egenera.com>
Subject: Re: Multipath on STK OPENStorage D240
Date: Thu, 4 May 2006 08:35:23 -0400
Message-ID: <20060504123523.GA9269@vienna.egenera.com>
References: <20060504074119.GB17730@bogon.ms20.nix>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20060504074119.GB17730@bogon.ms20.nix>
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

Hi,

Rumor has it that on Thu, May 04, 2006 at 09:41:20AM +0200 Guido Guenther said:
> Hi,
> when using path_checker readsector0 on the above machine the box stalls
> every 5 seconds when checking the currently nonactive path. Same for
> path_checker tur. Is there a way to avoid this? I'd consider writing a
> specific checker but am lacking any documentation.

This thing is a preferred path array. I can see how readsector0
is probably the wrong choice of checker. I imagine it causes 
a cache flush from the preferred controller. Odd that the tur
checker has the same behavior. If you want to code something 
you might try a checker that just does a standard INQUIRY.
I'd think that would not cause a cache flush, but then
I'd have thought that about the TUR as well... Such a checker 
may be useful for other preferred path arrays. 

I've got an STK array here but haven't gotten access to it 
yet to run dm-multipath so I can't confirm having seen this
problem.


Cheers,

Phil


> Cheers,
>  -- Guido
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

-- 
Philip R. Auld, Ph.D.  	        	       Egenera, Inc.    
Software Architect                            165 Forest St.
(508) 858-2628                            Marlboro, MA 01752
