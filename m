From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [RFC][PATCH 2/4] dm-log: unify rw_header to
	read/write_header
Date: Fri, 28 Nov 2008 23:37:47 +0000
Message-ID: <20081128233747.GC13235@agk.fab.redhat.com>
References: <492C91E3.5020700@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <492C91E3.5020700@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Takahiro Yasui <tyasui@redhat.com>
Cc: dm-devel@redhat.com, Masami Hiramatsu <mhiramat@redhat.com>
List-Id: dm-devel.ids

On Tue, Nov 25, 2008 at 07:01:39PM -0500, Takahiro Yasui wrote:
> rw_header function updates three members of io_req data every time
> when I/O is processed. bi_rw and notify.fn are never modified once
> they get initialized, and also they can be set in advance.
> This patch removes unnecessary update operations.
 
Indeed.

And it also removes header_to_disk() from the disk_flush() code
path but doesn't mention changing that:-)  I assume that's also
OK because there'll always have been a resume before the flush
and the data can only change during a resume?
 
> +++ linux-2.6.28-rc4/drivers/md/dm-log.c
> @@ -323,20 +323,13 @@ static void header_from_disk(struct log_

> -static int rw_header(struct log_c *lc, int rw)

I reckon that little function improves readability/maintainability and I've
left it in.

http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/
    dm-log-avoid-reinitialising-io_req-on-every-operation.patch

Alasdair
-- 
agk@redhat.com
