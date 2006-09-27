From: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
Subject: Re: dm-snapshot scalability - chained delta snapshots
	approach
Date: Wed, 27 Sep 2006 10:47:59 -0400
Message-ID: <20060927144759.GA27027@ti64.telemetry-investments.com>
References: <44DA246B020000B60000BD22@lucius.provo.novell.com>
	<44DB5BDD020000B60000BD96@lucius.provo.novell.com>
	<44DB5C21.F25D.00B6.0@novell.com> <451A5915.F25D.00B6.0@novell.com>
	<20060927091700.GA6314@X40.redhat.com>
	<20060927104035.GA4939@computer-surgery.co.uk>
Reply-To: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20060927104035.GA4939@computer-surgery.co.uk>
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

On Wed, Sep 27, 2006 at 11:40:35AM +0100, rgammans@computer-surgery.co.uk wrote:
> I was considering some sort of B or B+ -tree type arrangement as then
> we can use the buffer-cache (I'm assuming something similiar still
> exists after the bh -> bio rewrite but I 'm a lttle behind) to store
> the commonly referenced exceptions, which should keep the memory
> required by the tables down at times of high memory pressure.
> 
> > There are still ongoing discussions about the snapshot target. It would be
> > nice if you have additional thoughts about this proposal. I guess it is
> > similar to one of your prototypes.
> 
> Is this where those discussion are taking place if I want to help 
> and particpate?
 
Daniel Phillips's csnap target was based on BTree design:

  http://sources.redhat.com/cluster/csnap/

There are papers there describing the design in great detail.

Unfortunately, his various projects (csnap, ddraid, ...) seem to have
been abandoned.

Regards,

    Bill Rugolsky
