From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-bufio: check watermark periodically each 30
	seconds
Date: Mon, 1 May 2017 15:51:05 -0400
Message-ID: <20170501195104.GA14140@redhat.com>
References: <alpine.LRH.2.02.1704301733270.25063@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1704301733270.25063@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Sun, Apr 30 2017 at  5:34pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> dm-bufio checks a watermark when it allocates a new buffer in the function
> __bufio_new. However, it doesn't check the watermark when the user changes
> the value /sys/module/dm_bufio/parameters/max_cache_size_bytes.
> 
> This may result in a problem - if the watermark is high enough so that all
> possible buffers are allocated and if the user lowers the value
> "max_cache_size_bytes", the watermark will never be checked against the
> new value because no new buffer would be allocated.
> 
> This patch changes the function __evict_old_buffers so that it checks the
> watermark. __evict_old_buffers is called every 30 seconds, so if the user
> lowes "max_cache_size_bytes", dm-bufio will react to this change within
> 30 seconds and decrease memory consumption.
> 
> This patch requires the previous patch "dm-bufio: avoid a possible
> deadlock due to lock ordering" to be applied. Applying this patch without
> the previous patch would result in a deadlock.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org

I've applied the 2 stable@ fixes for 4.12 but the optimizations will
have to wait for 4.13 (the 4.12 merge window is already open, I need to
draw a line in the sand now).

Mike
