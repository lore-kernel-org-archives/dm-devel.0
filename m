From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: New read-balancing patch for dm-raid1.c
Date: Thu, 12 Oct 2006 15:46:14 +0100
Message-ID: <20061012144614.GY17654@agk.surrey.redhat.com>
References: <1160580794.15980.2.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1160580794.15980.2.camel@hydrogen.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Oct 11, 2006 at 10:33:14AM -0500, Jon Brassow wrote:
> This patch adds read balancing.  The round-robin method is the first
> to be implemented, but provisions are made for others to be implemented
> in the future.
 
My first thought in looking over this is that it ought to share the existing
dm-round-robin module used by multipath (which is already more flexible than
this as paths can be weighted).  It looks fairly straightforward to do this.
(And we certainly shouldn't confuse people by having 'roundrobin' in one
part of dm and 'round-robin' in another!)

When we implement more complex load balancing policies, there seems little
point doing everything twice, once for multipath and once for mirroring:-)

Alasdair
-- 
agk@redhat.com
