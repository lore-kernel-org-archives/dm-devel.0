From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 04/19] io-controller: Modify cfq to make use
	of flat elevator fair queuing
Date: Wed, 17 Jun 2009 09:00:00 -0400
Message-ID: <20090617130000.GB15473@redhat.com>
References: <1244513342-11758-1-git-send-email-vgoyal@redhat.com>
	<1244513342-11758-5-git-send-email-vgoyal@redhat.com>
	<4A385374.7060708@cn.fujitsu.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4A385374.7060708@cn.fujitsu.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: dhaval@linux.vnet.ibm.com, snitzer@redhat.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, m-ikeda@ds.jp.nec.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, akpm@linux-foundation.org, jbaron@redhat.com, linux-kernel@vger.kernel.org, s-uchida@ap.jp.nec.com, righi.andrea@gmail.com, containers@lists.linux-foundation.org
List-Id: dm-devel.ids

On Wed, Jun 17, 2009 at 10:22:44AM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> > This patch changes cfq to use fair queuing code from elevator layer.
> > 
> 
> elevator_private2 isn't used to store cfqq now.
> 
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>

Thanks Gui. Queued up for next posting.

Vivek

> ---
>  block/cfq-iosched.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 23b24b9..7a9bbe6 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -1874,7 +1874,7 @@ static void cfq_put_request(struct request *rq)
>  		put_io_context(RQ_CIC(rq)->ioc);
>  
>  		rq->elevator_private = NULL;
> -		rq->elevator_private2 = NULL;
> +		rq->ioq = NULL;
>  
>  		cfq_put_queue(cfqq);
>  	}
> -- 
> 1.5.4.rc3
