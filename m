From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 1/2] dm-zoned: add SPDX license identifiers
Date: Fri, 2 Aug 2019 23:20:21 +0000
Message-ID: <BYAPR04MB5816FF243F61F64FF397622CE7D90@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20190802220251.1217-1-dmitry.fomichev@wdc.com>
	<20190802220251.1217-2-dmitry.fomichev@wdc.com>
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
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 2019/08/03 7:02, Dmitry Fomichev wrote:
> Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
> ---
>  drivers/md/dm-zoned-metadata.c | 1 +
>  drivers/md/dm-zoned-reclaim.c  | 1 +
>  drivers/md/dm-zoned-target.c   | 1 +
>  drivers/md/dm-zoned.h          | 1 +
>  4 files changed, 4 insertions(+)
> 
> diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
> index 8545dcee9fd0..23e9a6d9350b 100644
> --- a/drivers/md/dm-zoned-metadata.c
> +++ b/drivers/md/dm-zoned-metadata.c
> @@ -1,3 +1,4 @@
> +// SPDX-License-Identifier: GPL-2.0-only
>  /*
>   * Copyright (C) 2017 Western Digital Corporation or its affiliates.
>   *
> diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
> index edf4b95eb075..387894e2add1 100644
> --- a/drivers/md/dm-zoned-reclaim.c
> +++ b/drivers/md/dm-zoned-reclaim.c
> @@ -1,3 +1,4 @@
> +// SPDX-License-Identifier: GPL-2.0-only
>  /*
>   * Copyright (C) 2017 Western Digital Corporation or its affiliates.
>   *
> diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
> index 51d029bbb740..1bf6e6eebee1 100644
> --- a/drivers/md/dm-zoned-target.c
> +++ b/drivers/md/dm-zoned-target.c
> @@ -1,3 +1,4 @@
> +// SPDX-License-Identifier: GPL-2.0-only
>  /*
>   * Copyright (C) 2017 Western Digital Corporation or its affiliates.
>   *
> diff --git a/drivers/md/dm-zoned.h b/drivers/md/dm-zoned.h
> index ed8de49c9a08..1a3b06de2c00 100644
> --- a/drivers/md/dm-zoned.h
> +++ b/drivers/md/dm-zoned.h
> @@ -1,3 +1,4 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
>  /*
>   * Copyright (C) 2017 Western Digital Corporation or its affiliates.
>   *
> 

Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>

-- 
Damien Le Moal
Western Digital Research
