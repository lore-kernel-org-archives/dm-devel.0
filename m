From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH -next] dm cache policy smq: remove duplicated include
 from dm-cache-policy-smq.c
Date: Sat, 17 Sep 2016 10:37:44 -0400
Message-ID: <20160917143743.GA73062@redhat.com>
References: <1474087703-22600-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1474087703-22600-1-git-send-email-weiyj.lk@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: Alasdair Kergon <agk@redhat.com>, Shaohua Li <shli@kernel.org>, Wei Yongjun <weiyongjun1@huawei.com>, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

On Sat, Sep 17 2016 at 12:48P -0400,
Wei Yongjun <weiyj.lk@gmail.com> wrote:

> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> Remove duplicated include.
> 
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>  drivers/md/dm-cache-policy-smq.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/md/dm-cache-policy-smq.c b/drivers/md/dm-cache-policy-smq.c
> index 8de5bd9..c33f4a6 100644
> --- a/drivers/md/dm-cache-policy-smq.c
> +++ b/drivers/md/dm-cache-policy-smq.c
> @@ -14,7 +14,6 @@
>  #include <linux/mutex.h>
>  #include <linux/vmalloc.h>
>  #include <linux/math64.h>
> -#include <linux/hash.h>
>  
>  #define DM_MSG_PREFIX "cache-policy-smq"

I resolved this by fixing the original commit (where I added hash.h
without realizing it was already included).

But thanks for the report.
