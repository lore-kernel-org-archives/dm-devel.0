From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH UPDATED 4/5] dm: implement REQ_FLUSH/FUA
 support for request-based dm
Date: Mon, 30 Aug 2010 15:18:29 -0400
Message-ID: <20100830191829.GB8458__31725.0957167291$1283196337$gmane$org@redhat.com>
References: <1283162296-13650-1-git-send-email-tj@kernel.org>
	<1283162296-13650-5-git-send-email-tj@kernel.org>
	<20100830132836.GB5283@redhat.com> <4C7BB932.1070405@kernel.org>
	<4C7BD202.4040700@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Resent-Message-ID: <20100830192345.GC9195@redhat.com>
Resent-To: dm-devel@redhat.com
Content-Disposition: inline
In-Reply-To: <4C7BD202.4040700@kernel.org>
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

On Mon, Aug 30 2010 at 11:45am -0400,
Tejun Heo <tj@kernel.org> wrote:

> This patch converts request-based dm to support the new REQ_FLUSH/FUA.
> 
> The original request-based flush implementation depended on
> request_queue blocking other requests while a barrier sequence is in
> progress, which is no longer true for the new REQ_FLUSH/FUA.
> 
> In general, request-based dm doesn't have infrastructure for cloning
> one source request to multiple targets, but the original flush
> implementation had a special mostly independent path which can issue
> flushes to multiple targets and sequence them.  However, the
> capability isn't currently in use and adds a lot of complexity.
> Moreoever, it's unlikely to be useful in its current form as it
> doesn't make sense to be able to send out flushes to multiple targets
> when write requests can't be.
> 
> This patch rips out special flush code path and deals handles
> REQ_FLUSH/FUA requests the same way as other requests.  The only
> special treatment is that REQ_FLUSH requests use the block address 0
> when finding target, which is enough for now.
> 
> * added BUG_ON(!dm_target_is_valid(ti)) in dm_request_fn() as
>   suggested by Mike Snitzer
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Looks good.

Acked-by: Mike Snitzer <snitzer@redhat.com>

Junichi and/or Kiyoshi,
Could you please review this patch and add your Acked-by if it is OK?
(Alasdair will want to see NEC's Ack to accept this patch).

Thanks,
Mike
