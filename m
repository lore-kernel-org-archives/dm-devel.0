From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: [PATCH] dm: Fix deadlock under high i/o load in
	raid1 setup.
Date: Mon, 14 Aug 2006 16:05:09 +0100
Message-ID: <20060814150509.GO18633@agk.surrey.redhat.com>
References: <20060809164421.GC9984@antares.tat.physik.uni-tuebingen.de>
	<20060812130228.f7954b5f.akpm@osdl.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20060812130228.f7954b5f.akpm@osdl.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Morton <akpm@osdl.org>
Cc: dm-devel@redhat.com, Daniel Kobras <kobras@linux.de>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Sat, Aug 12, 2006 at 01:02:28PM -0700, Andrew Morton wrote:
> Alasdair, I'd say that this is a 2.6.18 fix and a 2.6.17.x backport.
 
Yes.

> Or move the mempool_free()ing out of kmorrord context and into
> IO-completion context, perhaps.

That's how some other dm targets handle this particular problem.
 
Alasdair
-- 
agk@redhat.com
