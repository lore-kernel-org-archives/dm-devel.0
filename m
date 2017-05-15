From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/4] dm mpath: don't return -EIO from dm_report_EIO
Date: Mon, 15 May 2017 14:41:08 -0400
Message-ID: <20170515184108.GB6257@redhat.com>
References: <20170515152839.23375-1-hch@lst.de>
 <20170515152839.23375-3-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170515152839.23375-3-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

On Mon, May 15 2017 at 11:28am -0400,
Christoph Hellwig <hch@lst.de> wrote:

> Instead just turn the macro into a helper for the warning message.
> This removes an unessecary assignment in this patch, and will allow
> to fix a place where -EIO is the wrong error value in th next.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Something clearlyy got screwed up in my rebase.  Because I specifically
recall casting the multipath_clone_and_map()'s !pgpath call with:
(void) dm_report_EIO(m);

Very weird.  Anyway, thanks for catching these issues.

Mike
