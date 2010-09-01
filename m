From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH UPDATED 4/5] dm: implement REQ_FLUSH/FUA
 support for request-based dm
Date: Wed, 1 Sep 2010 08:54:40 -0400
Message-ID: <20100901125439.GA25097@redhat.com>
References: <1283162296-13650-1-git-send-email-tj@kernel.org>
	<1283162296-13650-5-git-send-email-tj@kernel.org>
	<20100830132836.GB5283@redhat.com> <4C7BB932.1070405@kernel.org>
	<4C7BD202.4040700@kernel.org> <20100830194731.GA10702@redhat.com>
	<Pine.LNX.4.64.1009010625070.16035@hs20-bc2-1.build.redhat.com>
	<4C7E36E8.2000705@kernel.org>
	<Pine.LNX.4.64.1009010811001.23591@hs20-bc2-1.build.redhat.com>
	<4C7E4A2D.2090309@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4C7E4A2D.2090309@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Tejun Heo <tj@kernel.org>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Wed, Sep 01 2010 at  8:42am -0400,
Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On 09/01/2010 02:12 PM, Mikulas Patocka wrote:
> > That may be true for request-based dm (I don't know).
> 
> Oh, okay, this part of thread was for request based dm, so I assumed
> you were talking about it.
> 
> > But bio-based dm doesn't depend on it, I wrote it and I didn't rely on 
> > that.
> 
> If you look at the two patches for bio-based ones.  The first one is
> basically what you're talking about w/ s/barrier/flush/ renames and
> dropping of -EOPNOTSUPP.  It doesn't really change the mechanism much.
> If you don't feel comfortable about the second one, we sure can
> postpone it but it's still quite away from the next merge window and
> what would be the point of delaying it?

Right, we have a window of opportunity to sort this out now.  No sense
in wasting it.

Mike
