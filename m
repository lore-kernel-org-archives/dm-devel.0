From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] lib/memweight.c: optimize by inlining bitmap_weight()
Date: Wed, 21 Aug 2019 18:25:07 -0700
Message-ID: <20190821182507.b0dea16f57360cf0ac40deb6@linux-foundation.org>
References: <20190821074200.2203-1-efremov@ispras.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190821074200.2203-1-efremov@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: Denis Efremov <efremov@ispras.ru>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Jan Kara <jack@suse.cz>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org, Erdem Tumurov <erdemus@gmail.com>, Vladimir Shelekhov <vshel@iis.nsk.su>
List-Id: dm-devel.ids

On Wed, 21 Aug 2019 10:42:00 +0300 Denis Efremov <efremov@ispras.ru> wrote:

> This patch inlines bitmap_weight() call.

It is better to say the patch "open codes" the bitmap_weight() call.

> Thus, removing the BUG_ON,

Why is that OK to do?

I expect all the code size improvements are from doing this?

> and 'longs to bits -> bits to longs' conversion by directly calling
> hweight_long().
> 
> ./scripts/bloat-o-meter lib/memweight.o.old lib/memweight.o.new
> add/remove: 0/0 grow/shrink: 0/1 up/down: 0/-10 (-10)
> Function                                     old     new   delta
> memweight                                    162     152     -10
> 
