From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: Write barriers on MD RAID1
Date: Wed, 24 Jun 2009 08:09:17 +0100
Message-ID: <20090624070917.GB27500@agk-dp.fab.redhat.com>
References: <4A188CAD.1080009@googlemail.com>
	<0fa4b1e19d3edb12931e0d641ce2c7d7.squirrel@neil.brown.name>
	<4A3E3C49.7010907@googlemail.com>
	<19009.41191.662901.179565@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <19009.41191.662901.179565@notabene.brown>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Ken Milmore <ken.milmore@googlemail.com>, device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

On Wed, Jun 24, 2009 at 01:43:35PM +1000, Neil Brown wrote:
> Since this test was added, barriers have not worked on md, and (I
> think) dm and similar devices that don't use __make_request and so
> don't bother to set next_ordered.
 
In dm, we added this:

+       blk_queue_ordered(md->queue, QUEUE_ORDERED_DRAIN, NULL);

Alasdair
