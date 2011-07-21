From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] backing-dev: use synchronize_rcu_expedited instead of
  synchronize_rcu
Date: Thu, 21 Jul 2011 09:27:06 +0200
Message-ID: <4E27D4CA.8020900@kernel.dk>
References: <Pine.LNX.4.64.1107202019420.26781@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1107202019420.26781@hs20-bc2-1.build.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: "Alasdair G. Kergon" <agk@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On 2011-07-21 02:29, Mikulas Patocka wrote:
> Hi Jens
> 
> Please would you consider taking this into the block tree? It seems to 
> speed up device deletion enormously.

Sure, looks like a good fix. Reminds me of a similar problem we had in
block core.


-- 
Jens Axboe
