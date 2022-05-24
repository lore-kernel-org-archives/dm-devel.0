Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C654DC433F5
	for <dm-devel@archiver.kernel.org>; Tue, 24 May 2022 07:30:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-45-2SVsV4CqNa6zRHfLuwXZKw-1; Tue, 24 May 2022 03:30:52 -0400
X-MC-Unique: 2SVsV4CqNa6zRHfLuwXZKw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 618DB801E80;
	Tue, 24 May 2022 07:30:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 431CF2026D6A;
	Tue, 24 May 2022 07:30:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EBFF71947065;
	Tue, 24 May 2022 07:30:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 65E96194704A
 for <dm-devel@listman.corp.redhat.com>; Tue, 24 May 2022 07:30:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4625B40D1B9A; Tue, 24 May 2022 07:30:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 416A240D1B99
 for <dm-devel@redhat.com>; Tue, 24 May 2022 07:30:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 10E43185A7A4
 for <dm-devel@redhat.com>; Tue, 24 May 2022 07:30:49 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-381-uB_pXWFNMDONL54bZEHhyw-1; Tue, 24 May 2022 03:30:46 -0400
X-MC-Unique: uB_pXWFNMDONL54bZEHhyw-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220524073045euoutp01ca2921a8360049c65b2e1c3136e62547~x_gblG86j1717417174euoutp01y
 for <dm-devel@redhat.com>; Tue, 24 May 2022 07:30:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220524073045euoutp01ca2921a8360049c65b2e1c3136e62547~x_gblG86j1717417174euoutp01y
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220524073045eucas1p1bf1186652cd6072397942e3781e1d8bd~x_ga5MrHj2945429454eucas1p1z;
 Tue, 24 May 2022 07:30:45 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id 80.FB.10260.4A98C826; Tue, 24
 May 2022 08:30:44 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220524073044eucas1p2bc05d83d40c029793af050f6cdbdd158~x_gaR5M7W0257402574eucas1p2J;
 Tue, 24 May 2022 07:30:44 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220524073044eusmtrp183beb394729a256f4fd7b0124abba89a~x_gaQ_8CV1483114831eusmtrp1Z;
 Tue, 24 May 2022 07:30:44 +0000 (GMT)
X-AuditID: cbfec7f5-bf3ff70000002814-e7-628c89a4ae72
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 3E.FE.09522.4A98C826; Tue, 24
 May 2022 08:30:44 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20220524073044eusmtip2c82c9dd2b779a52d6bbea6a809cb08dd~x_gaHfcnE2704727047eusmtip2f;
 Tue, 24 May 2022 07:30:44 +0000 (GMT)
Received: from [192.168.8.130] (106.210.248.20) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Tue, 24 May 2022 08:30:41 +0100
Message-ID: <7656fdc2-0511-722e-de6a-c2a2460cb048@samsung.com>
Date: Tue, 24 May 2022 09:30:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
To: kernel test robot <lkp@intel.com>, <axboe@kernel.dk>, <hch@lst.de>,
 <snitzer@redhat.com>, <damien.lemoal@opensource.wdc.com>, <hare@suse.de>,
 <Johannes.Thumshirn@wdc.com>
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <202205241034.izkLMTcH-lkp@intel.com>
X-Originating-IP: [106.210.248.20]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNKsWRmVeSWpSXmKPExsWy7djP87pLOnuSDKZeNLFYfbefzeL32fPM
 FnvfzWa1uPCjkcliz6JJTBYrVx9lsniyfhazRc+BDywWf7vuMVmc7b7GaLH3lrbF5V1z2Czm
 L3vKbvGq+RGbxZMp+9ksbkx4ymjRtvEro4Ogx78Ta9g8Fu95yeRx+Wypx6ZVnWwe3bP/sXhs
 XlLv8WLzTEaP3Tcb2Dx2tt5n9Xi/7yqbx/otV4GSp6s9Pm+S82g/0M0UwBfFZZOSmpNZllqk
 b5fAlTF/9UGWgnMSFf8ONjE3MP4W7WLk5JAQMJHY/f0HYxcjF4eQwApGiZYnH9ghnC+MEqt+
 zmGBcD4zSvydc4uti5EDrOXBVj+I+HJGieOTDzDDFT16dpANwtnFKHHrGkg7JwevgJ3E1bev
 2UBsFgFVictvzkPFBSVOznwCZosKREisbH0DZgsLeEi0nrrDDmIzC4hL3HoynwlkqIjAJkaJ
 LY3PwG5iFtjFJLFn6zlmkJvYBLQkGjvBGjgFjCTOXH4A1awp0br9N5QtL7H97RxmiBeUJLb9
 MoEEQK3E2mNnwH6WEGjjkpiybhUTRMJF4uanxSwQtrDEq+Nb2CFsGYnTk3ug4tUST2/8ZoZo
 bmGU6N+5HhpG1hJ9Z3Igahwlvr+8CxXmk7jxVhDiHD6JSdumM09gVJ2FFBSzkLw8C8kHs5B8
 sICRZRWjeGppcW56arFxXmq5XnFibnFpXrpecn7uJkZg+jz97/jXHYwrXn3UO8TIxMF4iFGC
 g1lJhDclrCdJiDclsbIqtSg/vqg0J7X4EKM0B4uSOG9y5oZEIYH0xJLU7NTUgtQimCwTB6dU
 A5PPtGadcj/7muyQlB2MC4tehRvsE7VMVBcNal5z5rID33pWtnWmNj+V33y0nLjX6erCTre4
 OUrFljZqj/99r3oZzZXnwdZ8osM78K+49bQLd2QO/eWbvtIhPUzZVEQ//GPAkefWD/4tkVzf
 ePv34u3Tzn/dPGnJglxNw+bKyHmfHZ2mMlaYsM3R+TDb4ffDy4d1GfU/5tjyhokLF/XozVz8
 Yu+czWn6nQ7JU6aFZqxrWVbLlju7lpNzp++qvvLffJq9V5iUTd5NmRwZMq/Z/7XdNl+jnWbu
 cxc6LU63PHKOVZrpyR0XOc/wv8L3Uown/Diu+2KhNBfv76XG+ivfTJopZfKG7dS3pN+veM4z
 bVRiKc5INNRiLipOBAA/JY5UDgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPKsWRmVeSWpSXmKPExsVy+t/xe7pLOnuSDBpPClisvtvPZvH77Hlm
 i73vZrNaXPjRyGSxZ9EkJouVq48yWTxZP4vZoufABxaLv133mCzOdl9jtNh7S9vi8q45bBbz
 lz1lt3jV/IjN4smU/WwWNyY8ZbRo2/iV0UHQ49+JNWwei/e8ZPK4fLbUY9OqTjaP7tn/WDw2
 L6n3eLF5JqPH7psNbB47W++zerzfd5XNY/2Wq0DJ09UenzfJebQf6GYK4IvSsynKLy1JVcjI
 Ly6xVYo2tDDSM7S00DMysdQzNDaPtTIyVdK3s0lJzcksSy3St0vQy5i/+iBLwTmJin8Hm5gb
 GH+LdjFycEgImEg82OrXxcjJISSwlFFiwpYkEFtCQEbi05WP7BC2sMSfa11sXYxcQDUfGSX+
 NZ5nhHB2MUqc3d/JAlLFK2AncfXtazYQm0VAVeLym/NQcUGJkzOfgNmiAhESn5ZNYAWxhQU8
 JFpP3QHbwCwgLnHryXwmkKEiApsYJbY0PmMBcZgFdjFJ7Nl6jhli3VZGifamwywgd7MJaEk0
 doJ1cwoYSZy5/ABqkqZE6/bfULa8xPa3c5gh3lSS2PbLBOKdWolX93czTmAUnYXkvllI7piF
 ZNIsJJMWMLKsYhRJLS3OTc8tNtQrTswtLs1L10vOz93ECEw524793LyDcd6rj3qHGJk4GA8x
 SnAwK4nwpoT1JAnxpiRWVqUW5ccXleakFh9iNAUG0kRmKdHkfGDSyyuJNzQzMDU0MbM0MLU0
 M1YS5/Us6EgUEkhPLEnNTk0tSC2C6WPi4JRqYJLVP3prCvMb1/x3fVMZTTfWVInZ8c73lJl7
 N5sl2i3gVpGdClPulrl6QRFK6qfPZLA+N/ibvVP7pVT4Gx33LMWJNx7GThJwNdhR9FGpojx7
 c8hOjYcF++Me/Ah1Fe6y0WP3+9/dsKGvpDPEcy2r1iTBq2sOP+zjU3LQENM7ViKpczyzzmh+
 VaH3Li2/vwFMm85zccQvb2jbsuN+x4GZ3j0bL+g4Gc/e4+d0TEEqYNuvHXs4Jb5mBQUnBx94
 e8hHUb9jaWRNj+XiHV+MDgu9YH80edOi22ybS95PnvPskZBrjMFUy6RHSjxPXrSUCCnsW/cv
 YdbZ8+JL6g5Oub/txrGMyyGWl6z/zLT69GZdihJLcUaioRZzUXEiAJ7OY7zCAwAA
X-CMS-MailID: 20220524073044eucas1p2bc05d83d40c029793af050f6cdbdd158
X-Msg-Generator: CA
X-RootMTR: 20220524024108eucas1p26a6384cd77f143bb0fa628f01866e0a0
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220524024108eucas1p26a6384cd77f143bb0fa628f01866e0a0
References: <20220523161601.58078-6-p.raghav@samsung.com>
 <CGME20220524024108eucas1p26a6384cd77f143bb0fa628f01866e0a0@eucas1p2.samsung.com>
 <202205241034.izkLMTcH-lkp@intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v5 5/7] null_blk: allow non power of 2 zoned
 devices
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: kbuild-all@lists.01.org, gost.dev@samsung.com, llvm@lists.linux.dev,
 jiangbo.365@bytedance.com, linux-nvme@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 Luis Chamberlain <mcgrof@kernel.org>, dsterba@suse.com, jaegeuk@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 5/24/22 04:40, kernel test robot wrote:
> Hi Pankaj,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on axboe-block/for-next]
> [also build test ERROR on device-mapper-dm/for-next linus/master hch-configfs/for-next v5.18 next-20220523]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
> 
> url:    https://protect2.fireeye.com/v1/url?k=8acc50e6-d557681b-8acddba9-000babff317b-0ca211d60a57a8c6&q=1&e=5ef82219-ef70-445f-a7d0-0ae0a30be69f&u=https%3A%2F%2Fgithub.com%2Fintel-lab-lkp%2Flinux%2Fcommits%2FPankaj-Raghav%2Fblock-make-blkdev_nr_zones-and-blk_queue_zone_no-generic-for-npo2-zsze%2F20220524-011616
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
> config: hexagon-randconfig-r045-20220523 (https://protect2.fireeye.com/v1/url?k=0dc32741-52581fbc-0dc2ac0e-000babff317b-fb6f258f0c80ebb9&q=1&e=5ef82219-ef70-445f-a7d0-0ae0a30be69f&u=https%3A%2F%2Fdownload.01.org%2F0day-ci%2Farchive%2F20220524%2F202205241034.izkLMTcH-lkp%40intel.com%2Fconfig)
> compiler: clang version 15.0.0 (https://protect2.fireeye.com/v1/url?k=afbb4f4f-f02077b2-afbac400-000babff317b-a4413fa4cefe1877&q=1&e=5ef82219-ef70-445f-a7d0-0ae0a30be69f&u=https%3A%2F%2Fgithub.com%2Fllvm%2Fllvm-project 10c9ecce9f6096e18222a331c5e7d085bd813f75)
> reproduce (this is a W=1 build):
>         wget https://protect2.fireeye.com/v1/url?k=718573dc-2e1e4b21-7184f893-000babff317b-b6c06a1c569b0d77&q=1&e=5ef82219-ef70-445f-a7d0-0ae0a30be69f&u=https%3A%2F%2Fraw.githubusercontent.com%2Fintel%2Flkp-tests%2Fmaster%2Fsbin%2Fmake.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://protect2.fireeye.com/v1/url?k=247d070f-7be63ff2-247c8c40-000babff317b-6fd7f2f6a5a5bc60&q=1&e=5ef82219-ef70-445f-a7d0-0ae0a30be69f&u=https%3A%2F%2Fgithub.com%2Fintel-lab-lkp%2Flinux%2Fcommit%2F3d3c81da0adbd40eb0d2125327b7e227582b2a37
>         git remote add linux-review https://protect2.fireeye.com/v1/url?k=081be8db-5780d026-081a6394-000babff317b-d12fdca0fccd0493&q=1&e=5ef82219-ef70-445f-a7d0-0ae0a30be69f&u=https%3A%2F%2Fgithub.com%2Fintel-lab-lkp%2Flinux
>         git fetch --no-tags linux-review Pankaj-Raghav/block-make-blkdev_nr_zones-and-blk_queue_zone_no-generic-for-npo2-zsze/20220524-011616
>         git checkout 3d3c81da0adbd40eb0d2125327b7e227582b2a37
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash
> 
> If you fix the issue, kindly add following tag where applicable
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>, old ones prefixed by <<):
> 
>>> ERROR: modpost: "__hexagon_umoddi3" [drivers/block/null_blk/null_blk.ko] undefined!

I am able to apply my patches cleanly against next-20220523, build it
without any errors with GCC and boot into it in my x86_64 machine. Not
sure why this error is popping up.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

