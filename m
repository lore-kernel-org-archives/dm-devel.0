From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] block: missing break in process_queued_bios()
Date: Wed, 14 Jun 2017 11:07:42 +0200
Message-ID: <20170614090742.GA15501@lst.de>
References: <20170614090437.GA31017@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170614090437.GA31017@elgon.mountain>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mike Snitzer <snitzer@redhat.com>, kernel-janitors@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, Jun 14, 2017 at 12:04:37PM +0300, Dan Carpenter wrote:
> This used to be a fall through case, but we shifted code around and I
> think we want a break here now.
> 
> Fixes: 4e4cbee93d56 ("block: switch bios to blk_status_t")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks Dan, this looks coreect:

Acked-by: Christoph Hellwig <hch@lst.de>
