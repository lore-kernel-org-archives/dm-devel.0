From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/3] per-cpu in_flight counters for bio-based
	drivers
Date: Fri, 30 Nov 2018 10:50:54 -0500
Message-ID: <20181130155054.GA13744@redhat.com>
References: <20181128004211.368810060@debian.vm>
	<20181130144343.GA13483@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181130144343.GA13483@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>, Christoph Hellwig <hch@infradead.org>
List-Id: dm-devel.ids

On Fri, Nov 30 2018 at  9:43am -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Tue, Nov 27 2018 at  7:42pm -0500,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > These are the patches for per-cpu in_flight counters.
> 
> Do you have updated before vs after performance results for these
> changes?
> 
> I'd imagine they are comparable to your previous run (though that run
> included some other DM changes that I already staged).

Would like to see before vs after with:

http://git.kernel.dk/cgit/linux-block/log/?h=for-4.21/block
vs
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=block-dm-4.21-inflight

(block-dm-4.21-inflight is based on latest for-4.21/block -- and it
contains DM changes in front of the block changes from this thread; I'd
prefer Jens take the changes like this rather than leave DM in a bit of
a mess for me/us to have to cleanup later)
