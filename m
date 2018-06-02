From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] dm-crypt: fix warning in shutdown path
Date: Sat, 2 Jun 2018 14:03:01 -0600
Message-ID: <974665e7-fa4a-230b-99d8-e773489cc6bc@kernel.dk>
References: <20180602174504.1847-1-kent.overstreet@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180602174504.1847-1-kent.overstreet@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, snitzer@redhat.com
List-Id: dm-devel.ids

On 6/2/18 11:45 AM, Kent Overstreet wrote:
> The counter for the number of allocated pages includes pages in the
> mempool's reserve, so checking that the number of allocated pages is 0
> needs to happen after we exit the mempool.

Looks good, but needs a fixes line. I'll add one.

-- 
Jens Axboe
