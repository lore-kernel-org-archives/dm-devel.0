From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] device-mapper: dm-mpath.c/dm_end_io might
	dead-lock
Date: Fri, 21 Oct 2005 13:50:11 +0100
Message-ID: <20051021125011.GR30611@agk.surrey.redhat.com>
References: <OF05AB6962.4DDCCB12-ONC12570A1.0043BB4B-C12570A1.00449DA9@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <OF05AB6962.4DDCCB12-ONC12570A1.0043BB4B-C12570A1.00449DA9@de.ibm.com>
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

On Fri, Oct 21, 2005 at 02:30:43PM +0200, Stefan Bader wrote:
> We had a problem with the multipath target which seems to be a locking
> problem. The following patch fixed the problem for us by replacing the
> spin_lock calls by the _irqsave/_irqrestore counterparts.
> Alasdair, is that fix acceptable? If yes, could you please include it into
> the kernel source?
 
Yes.

Alasdair
-- 
agk@redhat.com
