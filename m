From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [PATCH] fix bug on invalid chunksize
Date: Wed, 7 Oct 2009 12:50:28 -0500
Message-ID: <0DF06CB2-9182-48E2-BD55-7F11D87DBE93@redhat.com>
References: <20090930144110.GA16605@redhat.com>
	<20091002222716.GA5351@agk-dp.fab.redhat.com>
	<Pine.LNX.4.64.0910061857390.20258@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0910061857390.20258@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

good catch.

Reviewed-by: Jonathan Brassow <jbrassow@redhat.com>

  brassow

On Oct 6, 2009, at 5:59 PM, Mikulas Patocka wrote:

>
>
> On Fri, 2 Oct 2009, Alasdair G Kergon wrote:
>
>> On Wed, Sep 30, 2009 at 10:41:10AM -0400, Mike Snitzer wrote:
>>> Maximum chunk size is 512kB,
>>
>> Can you confirm that a supplied chunk size of 4294971392, for  
>> example, still
>> gets rejected?
>
> It gets rejected but there's a bug that device is left open after a
> failure. See this patch:
>
> Properly close the device if failing because of an invalid chunk size.
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>
> ---
> drivers/md/dm-exception-store.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: linux-2.6.31-fast-new/drivers/md/dm-exception-store.c
> ===================================================================
> --- linux-2.6.31-fast-new.orig/drivers/md/dm-exception-store.c	 
> 2009-10-07 00:05:28.000000000 +0200
> +++ linux-2.6.31-fast-new/drivers/md/dm-exception-store.c	2009-10-07  
> 00:05:35.000000000 +0200
> @@ -237,7 +237,7 @@ int dm_exception_store_create(struct dm_
>
> 	r = set_chunk_size(tmp_store, argv[2], &ti->error);
> 	if (r)
> -		goto bad_cow;
> +		goto bad_ctr;
>
> 	r = type->ctr(tmp_store, 0, NULL);
> 	if (r) {
