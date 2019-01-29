From: Christoph Hellwig <hch@infradead.org>
Subject: Re: block: Fix a WRITE SAME BUG_ON
Date: Tue, 29 Jan 2019 00:52:26 -0800
Message-ID: <20190129085226.GA25610@infradead.org>
References: <20190125021107.4595-1-zhangxiaoxu5@huawei.com>
	<CAMeeMh_=UVGwo-=9WtBXRmiHTXnLAswqis97bM-aiuwnzPU0QQ@mail.gmail.com>
	<20190128221441.GA24102@redhat.com> <yq1lg34f4i7.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <yq1lg34f4i7.fsf@oracle.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: axboe@kernel.dk, Mike Snitzer <snitzer@redhat.com>, John Dorminy <jdorminy@redhat.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, Zhang Xiaoxu <zhangxiaoxu5@huawei.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Jan 28, 2019 at 11:54:08PM -0500, Martin K. Petersen wrote:
> That said, now that we have REQ_OP_WRITE_ZEROES (where the LBS is
> irrelevant due to the payload being the ZERO_PAGE), it may be worthwhile
> to remove REQ_OP_WRITE_SAME. I think drbd is the only user relying on a
> non-zero payload. The target code ends up manually iterating, if I
> remember correctly...

I had a series to remove it a while ago, but you wanted to keep it at
that point.  I can resurrect it.
