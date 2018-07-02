From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v4 1/5] dm: Avoid namespace collision with bitmap API
Date: Mon, 2 Jul 2018 15:11:47 -0400
Message-ID: <20180702191146.GA22796@redhat.com>
References: <20180630201750.2588-1-andriy.shevchenko@linux.intel.com>
 <20180630201750.2588-2-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180630201750.2588-2-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Yury Norov <ynorov@caviumnetworks.com>, linux-kernel@vger.kernel.org, mika.westerberg@linux.intel.com, Joe Perches <joe@perches.com>
List-Id: dm-devel.ids

On Sat, Jun 30 2018 at  4:17pm -0400,
Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

> bitmap API (include/linux/bitmap.h) has 'bitmap' prefix for its methods.
> 
> On the other hand DM bitmap API is special case.
> Adding 'dm' prefix to it to avoid potential name space collision.
> 
> No functional changes intended.
> 
> Suggested-by: Mike Snitzer <snitzer@redhat.com>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Acked-by: Mike Snitzer <snitzer@redhat.com>
