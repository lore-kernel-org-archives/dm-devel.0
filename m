From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH v3 1/1] multipath-tools: Prioritizer based on
 a latency algorithm
Date: Mon, 5 Jun 2017 18:43:02 +0200
Message-ID: <4005a390-9db7-ff4b-f503-2801a80815ab@gmail.com>
References: <1496630622-24648-1-git-send-email-philip.yang@huawei.com>
	<1496630622-24648-2-git-send-email-philip.yang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1496630622-24648-2-git-send-email-philip.yang@huawei.com>
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
To: Yang Feng <philip.yang@huawei.com>, dm-devel@redhat.com, christophe.varoqui@opensvc.com, bmarzins@redhat.com, mwilck@suse.com
Cc: zouming.zouming@huawei.com, hege09@huawei.com, guanjunxiong@huawei.com, shenhong09@huawei.com, qiuxin@huawei.com
List-Id: dm-devel.ids

On 06/05/2017 04:43 AM, Yang Feng wrote:

> diff --git a/libmultipath/prioritizers/path_latency.c b/libmultipath/prioritizers/path_latency.c
> new file mode 100644
> index 0000000..081f546
> --- /dev/null
> +++ b/libmultipath/prioritizers/path_latency.c
> @@ -0,0 +1,272 @@
> +/*
> + * (C) Copyright HUAWEI Technology Corp. 2017, 2021   All Rights Reserved.

                                                  ^^^^  <-----------
2021 ???

> + *
> + * main.c
> + *
> + * Prioritizer for device mapper multipath, where the corresponding priority
> + * values of specific paths are provided by a latency algorithm. And the
> + * latency algorithm is dependent on arguments.
> + *
> + * The principle of the algorithm as follows:
> + * 1. By sending a certain number "io_num" of read IOs to the current path
> + *    continuously, the IOs' average latency can be calculated.
> + * 2. According to the average latency of each path and the weight value
> + *    "latency_interval", the priority "rc" of each path can be provided.
> + *
> + * Author(s): Yang Feng <philip.yang@huawei.com>
> + *            Zou Ming <zouming.zouming@huawei.com>
> + *            Guan Junxiong <guanjunxiong@huawei.com>
> + *
> + * This file is released under the GPL.
                                      ^^^  <-----------

"GPL" is not a licence. The *version* must be specified.


And it would be nice to start using SPDX tags ( https://spdx.org/ )
for new files.


BTW: LFC191 Compliance Basics for Developers course is FREE
     https://training.linuxfoundation.org/linux-courses/open-source-compliance-courses/compliance-basics-for-developers
