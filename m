From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCHES]: dm lock optimization
Date: Thu, 19 Apr 2012 14:17:14 +0900
Message-ID: <4F8F9FDA.1000103@ce.jp.nec.com>
References: <Pine.LNX.4.64.1204182249060.12984@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1204182249060.12984@file.rdu.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello Mikulas,

On 04/19/12 12:03, Mikulas Patocka wrote:
> http://people.redhat.com/mpatocka/patches/kernel/dm-lock-optimization/
> 
> The patches remove cache-line bouncing from device mapper when multiple 
> processors submit requests simultaneously.

I think the idea of optimization is nice.

From a quick look, however, I have some comments:

dm-optimize-no-irqsave-map-lock.patch:
  - dm_get_live_table() is called from request_fn,
    that can be called from in_interrupt context.
    So the added BUG_ON will be triggered.

dm-optimize-percpu-io-lock.patch:
  - The following existing mechanisms could be used:
      * include/linux/rcupdate.h
      * include/linux/lglock.h
    (or extended if necessary).

dm-optimize-get_live_table_fast.patch:
  - dm_lld_busy() can (theoretically, if dm-mpath is stacked)
    be called from in_interrupt context and trigger the
    BUG_ON.

-- 
Jun'ichi Nomura, NEC Corporation
