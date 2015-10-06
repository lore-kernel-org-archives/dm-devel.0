From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH for v4.3-rc] dm: fix request-based dm error
	reporting
Date: Tue, 6 Oct 2015 10:13:47 -0400
Message-ID: <20151006141346.GA30705@redhat.com>
References: <20151006041953.GA7948@xzibit.linux.bs1.fc.nec.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20151006041953.GA7948@xzibit.linux.bs1.fc.nec.co.jp>
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
Cc: device-mapper development <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

On Tue, Oct 06 2015 at 12:19am -0400,
Junichi Nomura <j-nomura@ce.jp.nec.com> wrote:

> end_clone_bio() is a endio callback for clone bio and should check
> and save the clone's bi_error for error reporting.  However,
> 4246a0b63bd8 ("block: add a bi_error field to struct bio") changed
> the function to check the original bio's bi_error, which is 0.
> 
> Without this fix, clone's error is ignored and reported to the
> original request as success.  Thus data corruption will be observed.
> 
> Fixes: 4246a0b63bd8 ("block: add a bi_error field to struct bio")
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> Cc: Christoph Hellwig <hch@lst.de>

Thanks, I've applied it here:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=50887bd139b83ce4489ed865a04bf1be5559c4ad

I'll send it to Linus by the end of the week for 4.3-rc5 inclusion.
