From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH block#for-2.6.31] block: add request clone
	interface
Date: Wed, 17 Jun 2009 18:19:38 +0900
Message-ID: <4A38B52A.5040304@kernel.org>
References: <4A2E1490.7060902@ct.jp.nec.com> <20090609180344.GQ11363@kernel.dk>
	<4A2F1741.8090100@ct.jp.nec.com> <4A2F66ED.80206@panasas.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4A2F66ED.80206@panasas.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

Hello, Boaz.

Boaz Harrosh wrote:
> dst->buffer is always NULL in my path so I don't know
> what that is. Tejun?

Sorry about late reply.

It points to the head of the data buffer (bio) if the address is in
addressable range (actually gets bogus value if not) and is used
mostly by PIO-only drivers.  It's set in blk_rq_bio_prep(), gets
updated on merge and partial request completion.

Thanks.

-- 
tejun
