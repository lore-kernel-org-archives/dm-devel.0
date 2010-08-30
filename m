From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 4/5] dm: implement REQ_FLUSH/FUA support for
 request-based dm
Date: Mon, 30 Aug 2010 15:08:35 -0400
Message-ID: <20100830190835.GA8458__38236.7785824046$1283196351$gmane$org@redhat.com>
References: <1283162296-13650-1-git-send-email-tj@kernel.org>
	<1283162296-13650-5-git-send-email-tj@kernel.org>
	<20100830132836.GB5283@redhat.com> <4C7BB932.1070405@kernel.org>
	<4C7BC942.7070703@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Resent-Message-ID: <20100830192344.GB9195@redhat.com>
Resent-To: dm-devel@redhat.com
Content-Disposition: inline
In-Reply-To: <4C7BC942.7070703@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Tejun Heo <tj@kernel.org>
Cc: k-ueda@ct.jp.nec.com, jaxboe@fusionio.com, jamie@shareable.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, j-nomura@ce.jp.nec.com, hch@lst.de
List-Id: dm-devel.ids

On Mon, Aug 30 2010 at 11:07am -0400,
Tejun Heo <tj@kernel.org> wrote:

> On 08/30/2010 03:59 PM, Tejun Heo wrote:
> > Ah... that's probably from "if (!elv_queue_empty(q))" check below,
> > flushes are on a separate queue but I forgot to update
> > elv_queue_empty() to check the flush queue.  elv_queue_empty() can
> > return %true spuriously in which case the queue won't be plugged and
> > restarted later leading to queue hang.  I'll fix elv_queue_empty().
> 
> I think I was too quick to blame elv_queue_empty().  Can you please
> test whether the following patch fixes the hang?

It does, thanks!

Tested-by: Mike Snitzer <snitzer@redhat.com>
