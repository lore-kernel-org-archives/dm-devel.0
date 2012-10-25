From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/2] block: move blk_queue_bypass_{start,end} to include/linux/blkdev.h
Date: Thu, 25 Oct 2012 11:55:44 +0200
Message-ID: <50890CA0.1070608@kernel.dk>
References: <50890931.3050906@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <50890931.3050906@ce.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Vivek Goyal <vgoyal@redhat.com>, Tejun Heo <tj@kernel.org>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 2012-10-25 11:41, Jun'ichi Nomura wrote:
> [PATCH] block: move blk_queue_bypass_{start,end} to include/linux/blkdev.h
> 
> dm wants to use those functions to control the bypass status of
> half-initialized device.
> 
> This patch is a preparation for:
>   [PATCH] dm: stay in blk_queue_bypass until queue becomes initialized

Applied. The previous state of private blk.h declaration but the symbols
exported was wrong, too.

-- 
Jens Axboe
