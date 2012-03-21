From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [dm-devel] [PATCH] Fix I/O counts in vmstat
Date: Wed, 21 Mar 2012 19:04:08 +0900
Message-ID: <4F69A798.4000200@ce.jp.nec.com>
References: <Pine.LNX.4.64.1203202336370.15617@file.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1203202336370.15617@file.rdu.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: "Alasdair G. Kergon" <agk@redhat.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hi Mikulas,

> The decision whether bio is counted or not is made by the code that
> submits the bio. This leads to some problems:

How about convering dm targets to use generic_make_request?

Since submit_bio counts vm events, it seems natural for
caller to decide which function to use.
Device driver does not know whether the requested I/O is
for vm-to-device or device-to-device.
We could still use iostat to measure throughput of individual
block devices. 

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation
