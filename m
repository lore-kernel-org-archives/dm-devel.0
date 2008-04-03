From: malahal@us.ibm.com
Subject: Re: Desynchronizing dm-raid1
Date: Wed, 2 Apr 2008 18:40:42 -0700
Message-ID: <20080403014042.GA3789@us.ibm.com>
References: <47DEC402.10309@redhat.com>
	<Pine.LNX.4.64.0803171611430.31803@porkchop.devel.redhat.com>
	<20080317215631.GG29322@agk.fab.redhat.com>
	<Pine.LNX.4.64.0803181921380.10939@porkchop.devel.redhat.com>
	<20080318233955.GA12007@agk.fab.redhat.com>
	<Pine.LNX.4.64.0803181942140.20490@porkchop.devel.redhat.com>
	<20080319000241.GB12007@agk.fab.redhat.com>
	<Pine.LNX.4.64.0803182015001.21077@porkchop.devel.redhat.com>
	<20080319011757.GD12007@agk.fab.redhat.com>
	<Pine.LNX.4.64.0804021444120.22485@porkchop.devel.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804021444120.22485@porkchop.devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Mikulas Patocka [mpatocka@redhat.com] wrote:
> Ideas how to fix it:
>
> 1. lock the buffers and unmap the pages while they are being written.
> --- upstream developers would likely reject it. No other driver than 
> dm-raid1 has problems with this and they wouldn't damp performance because 
> of one driver.

Very few drivers require it, so how about an interface to lock the pages
of an I/O available to drivers. Only needed RAID drivers would lock the
I/O while it is in progress and they only pay the performance penalty.
mmap pages are a bit tricky. They need to go into read-only mode when an
I/O is in progress. I know this would likely be rejected too!!!

> 4. make more region states.
> --- If the region is in RH_DIRTY state and all writes drain, the state is 
> changed to RH_MAYBE_DIRTY. (we don't know if the region is synchronized or 
> not). The disk dirty flag is kept.
> --- periodically (once in few minutes, so that it doesn't affect 
> performance much), the change all regions in RH_MAYBE_DIRTY state to 
> RH_CLEAN_CANDIDATE, then issue sync() on all filesystems. If, after the 
> sync(), the region is still in RH_CLEAN_CANDIDATE (i.e. it hasn't been 
> written during the sync()), it is moved to RH_CLEAN state and the on-disk 
> bit for the region is turned off.

Sounds good except that it uses sync()! Is there a way to sync only
pages related to a certain block device? How hard it is to implement
such an interface?

--Malahal.
