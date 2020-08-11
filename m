From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Subject: Re: Recent multipath-tools patches from Huawei
Date: Tue, 11 Aug 2020 09:14:46 +0800
Message-ID: <60d7ea82-22ed-16f5-de7f-8280b90eeb7f@huawei.com>
References: <140e431094a118a5276f6964921cc120bda2dc49.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <140e431094a118a5276f6964921cc120bda2dc49.camel@suse.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>, linfeilong@huawei.com, Yanxiaodan <yanxiaodan@huawei.com>, lixiaokeng <lixiaokeng@huawei.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids



On 2020/8/10 22:34, Martin Wilck wrote:
> Hi Liu,
> 
> thanks again for your valuable contributions and meticulous code
> review. I've added your patches in my upstream-queue branch now:
> 
> https://github.com/openSUSE/multipath-tools/commits/upstream-queue
> 
> Not applied yet: 
> 
>  - libmultipath: free pp if store_path fails in disassemble_map:
>    As noted before, this will be merged with my series for
>    disassemble_map().
>  - libmultipath: fix a memory leak in set_ble_device:
>    Please fix minor issues I mentioned
>  - vector: return null when realloc fails in vector_alloc_slot func
>    Needs improvement
> 
> Please double-check if I've missed anything. 
> 
> Next time, please send your patches as a series. That makes it
> much easier for others to make sure they don't miss any.
> And please, don't add "[dm-devel]" explicitly in your email
> subject, mailman will take care of that.
> 
> Regards
> Martin
> 
Thanks for your advise.
I have checked recent patches. The following patch may be missed.
- libmultipath: free pgp if add_pathgroup fails in disassemble_map func




From e43d45a4ff838cab845bc5b5834d24743192eb75 Mon Sep 17 00:00:00 2001
From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Date: Wed, 22 Jul 2020 14:31:15 +0800
Subject: [PATCH] libmultipath: free pgp if add_pathgroup fails in disassemble_map

In disassemble_map func, pgp will be added to mpp->pg by calling
add_pathgroup after allocing a pathgroup (pgp) successfully. However,
if add_pathgroup fails, the pgp is actually not inserted into mpp->pg.
So, calling free_pgvec(mpp->pg) cannot free the pgp, then memory leak
problem occurs.

disassemble_map:
-> pgp = alloc_pathgroup()
-> if add_pathgroup(mpp, pgp) fails
	-> goto out
out:
free_pgvec(mpp->pg, KEEP_PATHS);

Here, we will call free_pathgroup(pgp) before going to out tag.

Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/dmparser.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index ac13ec06..6225838b 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -268,8 +268,10 @@ int disassemble_map(vector pathvec, char *params, struct multipath *mpp,
 		if (!pgp)
 			goto out;

-		if (add_pathgroup(mpp, pgp))
+		if (add_pathgroup(mpp, pgp)) {
+			free_pathgroup(pgp, KEEP_PATHS);
 			goto out;
+		}

 		p += get_word(p, &word);

-- 
2.24.0.windows.2





> 
> 
> .
> 
