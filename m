From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH for-next] dm: fix missing bi_remaining accounting
Date: Fri, 01 Nov 2013 09:03:20 -0600
Message-ID: <5273C2B8.5030608@kernel.dk>
References: <20131101135931.GA22903@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20131101135931.GA22903@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Kent Overstreet <kmo@daterainc.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On 11/01/2013 07:59 AM, Mike Snitzer wrote:
> Add the missing bi_remaining increment, required by the block layer's
> new bio-chaining code, to both the verity and old snapshot DM targets.
> 
> Otherwise users will hit the bi_remaining <= 0 BUG_ON in bio_endio().

Thanks Mike, added to the mix.

-- 
Jens Axboe
