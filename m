From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] multipath-tools:Prioritizer based on a
 time-delay algorithm
Date: Thu, 11 May 2017 00:36:47 +0200
Message-ID: <d5205a96-32cb-3832-a93a-0057c445ef55@gmail.com>
References: <1494215904-7564-1-git-send-email-philip.yang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1494215904-7564-1-git-send-email-philip.yang@huawei.com>
Content-Language: en-GB
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Yang Feng <philip.yang@huawei.com>, dm-devel@redhat.com, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: guanjunxiong@huawei.com, hege09@huawei.com, zouming.zouming@huawei.com, shenhong09@huawei.com
List-Id: dm-devel.ids

On 05/08/2017 05:58 AM, Yang Feng wrote:

> Prioritizer for device mapper multipath, where the corresponding priority
> values of specific paths are provided by a time-delay algorithm. And the
> time-delay algorithm is dependent on the following arguments(delay_interval,
> cons_num).
This new feature should be documented in multipath/multipath.conf.5

> diff --git a/libmultipath/checkers/Makefile b/libmultipath/checkers/Makefile
> index 4970fc0..7e433ca 100644
> --- a/libmultipath/checkers/Makefile
> +++ b/libmultipath/checkers/Makefile
> @@ -14,19 +14,16 @@ LIBS= \
>  	libcheckemc_clariion.so \
>  	libcheckhp_sw.so \
>  	libcheckrdac.so
> -ifneq ($(ENABLE_RADOS),0)
> -LIBS += libcheckrbd.so
> -endif

Is it right?
