From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] libmultipath: fix memory API logic error
Date: Mon, 15 Aug 2016 13:46:32 +0000
Message-ID: <SN1PR0201MB18703D0169FED76519FD686881120@SN1PR0201MB1870.namprd02.prod.outlook.com>
References: <1471258749-12176-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
To: "tang.junhui@zte.com.cn" <tang.junhui@zte.com.cn>, christophe varoqui <christophe.varoqui@free.fr>
Cc: "zhang.kai16@zte.com.cn" <zhang.kai16@zte.com.cn>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 08/15/16 03:59, tang.junhui@zte.com.cn wrote:
> From: "tang.junhui" <tang.junhui@zte.com.cn>
>
> Memroy API use mem_allocated to record the total size of used memory,
> however, it's wrong to use size(p) as the length of freed memory in xfree(),
> and memory may also be allocated by STRDUP() or REALLOC(), which is
> not calculated into mem_allocated, so the total size of used memory is
> not correctly. For these reasons, we removed these incorrectly code to keep
> the code clean.

Nice work. BTW, I think it's worth mentioning that this patch also fixes 
a data race. Without this patch the global variable mem_allocated is 
manipulated by multiple threads without using atomics and without 
serializing concurrent accesses.

Bart.
