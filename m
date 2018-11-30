From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/3] per-cpu in_flight counters for bio-based
	drivers
Date: Fri, 30 Nov 2018 09:43:43 -0500
Message-ID: <20181130144343.GA13483@redhat.com>
References: <20181128004211.368810060@debian.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181128004211.368810060@debian.vm>
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

On Tue, Nov 27 2018 at  7:42pm -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> These are the patches for per-cpu in_flight counters.

Do you have updated before vs after performance results for these
changes?

I'd imagine they are comparable to your previous run (though that run
included some other DM changes that I already staged).

Thanks,
Mike
