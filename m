From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: [PATCH] Fix Null pointer Exception
Date: Tue, 7 Oct 2008 22:18:40 +0100
Message-ID: <20081007211840.GC23898@agk.fab.redhat.com>
References: <48C5478B.2040401@linux.vnet.ibm.com>
	<20080908172153.05268f6d.akpm@linux-foundation.org>
	<20080923165628.GI5288@agk.fab.redhat.com>
	<48DA3DF1.6060403@linux.vnet.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <48DA3DF1.6060403@linux.vnet.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: raspl@linux.vnet.ibm.com
Cc: wein@de.ibm.com, heiko.carstens@de.ibm.com, device-mapper development <dm-devel@redhat.com>, Jens Axboe <jens.axboe@oracle.com>, schwidefsky@de.ibm.com, Andrew Morton <akpm@linux-foundation.org>
List-Id: dm-devel.ids

On Wed, Sep 24, 2008 at 03:17:37PM +0200, Stefan Raspl wrote:
> Alasdair G Kergon wrote:
> > Have you had chance to look at old kernel versions to see in which
> > commit this was introduced?
> The next best thing I can come up with is that it has been around in
> 2.6.9 already. But I believe the DASD driver did the NULL thing to
> its internal queue also back then, still.
 
Well, in the absence of further information and being unaware of any
other driver doing this, rather than changing several places in the
block layer to cope with one out-of-the-ordinary driver, I wish to see
the driver fixed to work within the existing block layer design.  If
that is difficult or impossible (which I doubt), then we need more
information to justify that position.

Meanwhile I will not be applying that patch, though I may take a patch
to provide clean diagnostics should a situation like this occur again.

Alasdair
-- 
agk@redhat.com
