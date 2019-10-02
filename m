From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 0/1] dm snapshot: Fix bug in COW throttling
 mechanism causing deadlocks
Date: Wed, 2 Oct 2019 06:10:28 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1910020608490.973@file01.intranet.prod.int.rdu2.redhat.com>
References: <20191001115747.4473-1-ntsironis@arrikto.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191001115747.4473-1-ntsironis@arrikto.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Nikos Tsironis <ntsironis@arrikto.com>
Cc: dm-devel@redhat.com, agk@redhat.com, snitzer@redhat.com, guru2018@gmail.com
List-Id: dm-devel.ids



On Tue, 1 Oct 2019, Nikos Tsironis wrote:

> Hello,
> 
> This patch fixes the deadlock issue reported in this thread:
> https://www.redhat.com/archives/dm-devel/2019-September/msg00168.html.
> 
> Although I have been really careful preparing this patch, in order to
> avoid any further issues, any extra review would be greatly appreciated.
> 
> Thanks,
> Nikos
> 
> Nikos Tsironis (1):
>   dm snapshot: Fix bug in COW throttling mechanism causing deadlocks
> 
>  drivers/md/dm-snap.c | 99 +++++++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 90 insertions(+), 9 deletions(-)

Hi

I think a better solution would be to drop all locks while waiting for 
some kcopyd job. I'll send patches for that.

Mikulas
