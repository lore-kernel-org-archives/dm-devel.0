From: Jens Axboe <axboe@kernel.dk>
Subject: Re: BUG: sleeping function called during table_load()
Date: Fri, 1 Mar 2013 10:06:25 +0100
Message-ID: <20130301090625.GS4727@kernel.dk>
References: <51306300.40309@suse.de>
 <51306634.2010702@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <51306634.2010702@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Mar 01 2013, Jun'ichi Nomura wrote:
> Hi Hannes,
> 
> On 03/01/13 17:12, Hannes Reinecke wrote:
> > during booting 3.8.0 I hit this:
> > 
> > BUG: sleeping function called from invalid context at kernel/rcutree.c:2208
> > in_atomic(): 1, irqs_disabled(): 0, pid: 1976, name: multipath
> > Pid: 1976, comm: multipath Not tainted 3.8.0-default+ #18
> 
> It seems the same issue with this:
>   [PATCH repost] blkcg: fix "scheduling while atomic" in blk_queue_bypass_start
>   https://patchwork.kernel.org/patch/2183891/
> 
> I've been waiting for Jens to pick it up.

I just offloaded the bigger chunk for 3.9, there will be a 2nd round
after -rc1 where this is going to be included (amongst other things).

-- 
Jens Axboe
