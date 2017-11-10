From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] brd: remove unused brd_mutex
Date: Fri, 10 Nov 2017 11:18:42 -0700
Message-ID: <0f7fd0e5-985c-f17a-de0b-92003c316738@kernel.dk>
References: <alpine.LRH.2.02.1711101228030.15978@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1711101228030.15978@file01.intranet.prod.int.rdu2.redhat.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>, linux-block@vger.kernel.org
Cc: Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

On 11/10/2017 10:29 AM, Mikulas Patocka wrote:
> Remove unused mutex brd_mutex. It is unused since the commit ff26956875c2
> ("brd: remove support for BLKFLSBUF").

Thanks, applied.

-- 
Jens Axboe
