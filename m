From: Christoph Hellwig <hch@infradead.org>
Subject: Re: device mapper and the BLKFLSBUF ioctl
Date: Tue, 25 Oct 2016 06:07:12 -0700
Message-ID: <20161025130712.GA12717@infradead.org>
References: <alpine.LRH.2.02.1610211406290.9197@file01.intranet.prod.int.rdu2.redhat.com>
	<20161021200022.GA12580@redhat.com>
	<alpine.LRH.2.02.1610211616450.31606@file01.intranet.prod.int.rdu2.redhat.com>
	<20161024155756.GA48306@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20161024155756.GA48306@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

I think the right fix is to kill off the BLKFLSBUF special case in
brd.  Yes, it break compatibility - but in this case the compatibility
breaks more than it helps.
