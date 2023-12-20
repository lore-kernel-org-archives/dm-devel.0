Received: from 1wt.eu (ded1.1wt.eu [163.172.96.212])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B762C18E08
	for <dm-devel@lists.linux.dev>; Wed, 20 Dec 2023 06:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=1wt.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=1wt.eu
Received: (from willy@localhost)
	by pcw.home.local (8.15.2/8.15.2/Submit) id 3BK6hl4H029479;
	Wed, 20 Dec 2023 07:43:47 +0100
Date: Wed, 20 Dec 2023 07:43:47 +0100
From: Willy Tarreau <w@1wt.eu>
To: "Yang, Chenyuan" <cy54@illinois.edu>
Cc: "security@kernel.org" <security@kernel.org>,
        "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
        "agk@redhat.com" <agk@redhat.com>,
        "snitzer@kernel.org" <snitzer@kernel.org>,
        "mpatocka@redhat.com" <mpatocka@redhat.com>,
        "syzkaller@googlegroups.com" <syzkaller@googlegroups.com>,
        "Zhang, Lingming" <lingming@illinois.edu>,
        "Marinov, Darko" <marinov@illinois.edu>,
        "Zhao, Zijie" <zijie4@illinois.edu>
Subject: Re: [Linux Kernel Crash] "WARNING: kmalloc bug in dm_table_create"
Message-ID: <20231220064347.GA29411@1wt.eu>
References: <PH7PR11MB5768D4593870E9515DEE6334A097A@PH7PR11MB5768.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH7PR11MB5768D4593870E9515DEE6334A097A@PH7PR11MB5768.namprd11.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hello,

On Tue, Dec 19, 2023 at 08:55:13PM +0000, Yang, Chenyuan wrote:
> Hello,
> 
> We detected another crash bug for the `md` driver implemented in `drivers/md/dm-ioctl.c` and `dm-table.c` by using Syzkaller. This is kind of like "kmalloc bug in ctl_ioctl" but it is related to another CMD value and argument. (`DM_TABLE_LOAD_CMD` and `struct dm_ioctl.target_count`.
> 
> Based on our understanding, this bug is caused by ` n_highs = kvcalloc(num, sizeof(struct dm_target) + sizeof(sector_t), GFP_KERNEL); in `dm-table.c` (https://github.com/torvalds/linux/blob/3bd7d748816927202268cb335921f7f68b3ca723/drivers/md/dm-table.c#L112). This allocates an array with a size over INT_MAX.
> 
> A possible patch is to have a check for the `struct dm_ioctl.target_count`, which is the argument for the `ioctl` with ` DM_TABLE_LOAD_CMD` as the command value. Currently, there is no any check for this argument.
> 
> We reproduced this bug in the latest Linux Kernel (reproducible on 3bd7d748816927202268cb335921f7f68b3ca723 and found on d2f51b3516dade79269ff45eae2a7668ae711b25), and the config for the kernel is attached.
> 
> Here is the log and Syzkaller reproducer. C reproducer is also attached, which can compiled by `gcc -pthread`.
(...)

Quick note, there's no need to Cc the security list since this was
cross-posted to a public list:

   https://lore.kernel.org/dm-devel/PH7PR11MB5768D4593870E9515DEE6334A097A@PH7PR11MB5768.namprd11.prod.outlook.com/T/#u

Thanks,
Willy
