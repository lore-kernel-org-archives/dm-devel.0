From: Takahiro Yasui <tyasui@redhat.com>
Subject: Re: [RFC][PATCH 2/4] dm-log: unify rw_header to
	read/write_header
Date: Mon, 01 Dec 2008 02:24:01 -0500
Message-ID: <49339111.7000403@redhat.com>
References: <492C91E3.5020700@redhat.com>
	<20081128233747.GC13235@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20081128233747.GC13235@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Alasdair G Kergon wrote:
> On Tue, Nov 25, 2008 at 07:01:39PM -0500, Takahiro Yasui wrote:
>> rw_header function updates three members of io_req data every time
>> when I/O is processed. bi_rw and notify.fn are never modified once
>> they get initialized, and also they can be set in advance.
>> This patch removes unnecessary update operations.
>  
> Indeed.
> 
> And it also removes header_to_disk() from the disk_flush() code
> path but doesn't mention changing that:-)  I assume that's also
> OK because there'll always have been a resume before the flush
> and the data can only change during a resume?

Oh, I'm sorry not to mention it on the patch description, but
your explanation is exactly what I need to do.

>> +++ linux-2.6.28-rc4/drivers/md/dm-log.c
>> @@ -323,20 +323,13 @@ static void header_from_disk(struct log_
> 
>> -static int rw_header(struct log_c *lc, int rw)
> 
> I reckon that little function improves readability/maintainability and I've
> left it in.
> 
> http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/
>     dm-log-avoid-reinitialising-io_req-on-every-operation.patch

Thanks, Alasdair. I have removed rw_header function in my patch
since the last two patches don't use it, but your improvement is
fine as a separate patch.

Thanks,
---
Takahiro Yasui
Hitachi Computer Products (America) Inc.
