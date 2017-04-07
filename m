From: Jens Axboe <axboe@fb.com>
Subject: Re: [PATCH 0/2] Trace completion of all bios
Date: Fri, 7 Apr 2017 09:42:09 -0600
Message-ID: <3560beb3-d60a-2d44-db82-bc21472b2881@fb.com>
References: <149152735878.17489.16036848644242802943.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <149152735878.17489.16036848644242802943.stgit@noble>
Sender: linux-block-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@infradead.org>, Ming Lei <tom.leiming@gmail.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 04/06/2017 07:10 PM, NeilBrown wrote:
> Hi Jens,
>  I think all objections to this patch have been answered so I'm
>  resending.
>  I've added a small cleanup patch first which makes some small
>  enhancements to the documentation and #defines for the bio->flags
>  field.

Added for 4.12. I hand applied 2/2, since it did not apply directly to
the 4.12 branch.

-- 
Jens Axboe
