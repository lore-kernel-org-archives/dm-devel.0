From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: CONFIG_DM_MQ_DEFAULT makes my kernel unhappy..
Date: Sat, 25 Apr 2015 11:28:57 -0400
Message-ID: <20150425152856.GB28453@redhat.com>
References: <20150425092358.GA15550@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150425092358.GA15550@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Sat, Apr 25 2015 at  5:23am -0400,
Christoph Hellwig <hch@infradead.org> wrote:

> Running dm-mpath against a tcm_loop target with two ALUA paths makes
> the kernel very unhappy when CONFIG_DM_MQ_DEFAULT is set.  Without it
> it's perfectly happy.

Wonder if commit 63a4f065ec ("dm: fix add_disk() NULL pointer due to
race with free_dev()") left something not quite right relative to
blk-mq?  Or maybe this is a problem confined to blk-mq itself.

What were you actually testing when this happened?  Were you failing
paths under IO load or something?

Also, which upstream commit was your tree based on?  Did you have any
non-upstream patches applied that I should be aware of?

Thanks,
Mike
