From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: dm-mpath: Work with blk multi-queue drivers
Date: Mon, 29 Sep 2014 23:58:31 +0000
Message-ID: <5429F227.4080604@ce.jp.nec.com>
References: <1411491802-7356-1-git-send-email-keith.busch@intel.com>
	<20140924145215.GA26398@infradead.org>
	<alpine.LRH.2.03.1409241020540.4696@AMR>
	<20140924183453.GA23052@redhat.com>
	<20140924184834.GB23052@redhat.com> <20140925001341.GA25145@redhat.com>
	<alpine.LRH.2.03.1409250923390.4696@AMR>
	<20140925161215.GA29645@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140925161215.GA29645@redhat.com>
Content-Language: ja-JP
Content-ID: <F58F7F122AE2D947B4B49132F26A377D@gisp.nec.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, Keith Busch <keith.busch@intel.com>, Christoph Hellwig <hch@infradead.org>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 09/26/14 01:12, Mike Snitzer wrote:
> On Thu, Sep 25 2014 at 11:57am -0400,
> Keith Busch <keith.busch@intel.com> wrote:
>> For my part, the goal was to change as little as possible to get basic
>> blk-mq support working safely without regressing, and performance is
>> not even on my radar yet. I purposefully did not try to understand the
>> existing design well enough to propose re-arching. If we can address the
>> 'request' life cycle management duality issue, would this be acceptable
>> as a stopgap for blk-mq support?
> 
> We can ignore my desire to cleanup existing request-based DM's bio
> cloning for now.  And yes, resolving the duality issue would need to
> happen.  But your proposed change still has the issue of no longer using
> a dedicated mempool per rq-based DM device to allocate requests from.
> If we were to do that I'm pretty sure this new dm.c:dm_get_request()
> wrapper would need to call blk_get_request() with GFP_ATOMIC.
> 
> Either GFP_ATOMIC or I think we _could_ relax to GFP_NOWAIT if and only
> if we were willing to explicitly disallow stacking request-based DM
> devices (which nothing uses at this point).  So I'd like to get Junichi
> and Alasdair's feedback on the implications.  Junichi and/or Alasdair?

The problem with "stacking request-based DM devices" is
caused by shared mempool (i.e. the pool gets emptied by
upper layer and we can't make forward progress).
So it should be ok if request has per-device mempool
(I think it does.)

However, using blk_get_request() in map function will
require more changes in the code as blk_get_request()
assumes interrupt-enabled context.

-- 
Jun'ichi Nomura, NEC Corporation
