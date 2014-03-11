From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: era: use do_div for 64-bit division
Date: Tue, 11 Mar 2014 08:59:54 -0400
Message-ID: <20140311125954.GA9752@redhat.com>
References: <3014967.i7OXqBNQ5E@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3014967.i7OXqBNQ5E@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, Joe Thornber <ejt@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Mar 11 2014 at  4:31am -0400,
Arnd Bergmann <arnd@arndb.de> wrote:

> Commit 983043be0c1de "dm era: support non power-of-2 blocksize"
> introduced the use of sector_div to divide a variable of type
> dm_block_t by an integer. This fails on 32-bit machines when
> CONFIG_LBDAF is not set, because that assumes that the first
> argument is a 32-bit number.
> 
> To allow building this driver in all configurations, we either
> have to cast the dm_block_t to sector_t or use do_div(), which
> always takes a 64-bit argument. This patch uses the second
> approach in order to cope with theoretical configurations where
> dm_block_t contains a number that does not fit into sector_t.

Thanks for taking the time to look into this.

But the first approach was used on Friday (and is adequate considering
we're starting with the bio's bi_sector).  The new commit id is
1c5a63b138638d08f4dc65ed48d3d5d3bad1b08b.

The moral of the story is: don't make a mistake on Thursday because that
last linux-next of the week will plague you for the next 5 days.  I was
hoping for relief with Monday's linux-next build but alas... ;)
