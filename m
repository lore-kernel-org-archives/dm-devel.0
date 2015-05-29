From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH for-4.2 2/3] block,
	dm: don't copy bios for	request clones
Date: Fri, 29 May 2015 18:54:51 +0200
Message-ID: <20150529165451.GA2682@lst.de>
References: <1432300445-9543-1-git-send-email-snitzer@redhat.com>
	<1432300445-9543-2-git-send-email-snitzer@redhat.com>
	<556410BB.3000103@ce.jp.nec.com> <20150527082157.GA25993@lst.de>
	<5565935A.4060408@ce.jp.nec.com> <5566B7E5.1070101@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <5566B7E5.1070101@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Junichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Jens Axboe <axboe@kernel.dk>, device-mapper development <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Thu, May 28, 2015 at 06:38:29AM +0000, Junichi Nomura wrote:
> I'm also worried about partial completion case.
> For successful partial completion, current code completes
> bio before fully completing the request.
> Your patch changes bios not completed until the request is
> fully completed.

Yes.  Why are you worried about this case?

> I'm not very sure how much impact does the removal of partial
> completion have in the real world.
> If partial completion is so negligible, I think it should be
> handled in such a way all the cases, instead of special casing
> REQ_CLONE.

It isn't negligible - under load it actually does matter that
we handle partial completions as arrays decide to just complete
a request partially, so if we don't handle them we might end
up in a loop not making progress.  But if we only do that once on
path fail over it's not an actual issue.
