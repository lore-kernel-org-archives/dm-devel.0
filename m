From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm verity: use sector_div for division
Date: Tue, 8 Dec 2015 12:10:13 -0500
Message-ID: <20151208171013.GA4263@redhat.com>
References: <2666833.eM84rj4CYY@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2666833.eM84rj4CYY@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: dm-devel@redhat.com, Neil Brown <neilb@suse.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Sami Tolvanen <samitolvanen@google.com>, linux-arm-kernel@lists.infradead.org
List-Id: dm-devel.ids

On Tue, Dec 08 2015 at 10:42am -0500,
Arnd Bergmann <arnd@arndb.de> wrote:

> The dm verity sec implementation uses do_div for dividing a sector_t,
> which is slower than necessary when sector_t is a 32-bit type, and
> we now get a warning for this case:
> 
> include/asm-generic/div64.h:224:22: warning: passing argument 1 of '__div64_32' from incompatible pointer type [-Wincompatible-pointer-types]
> drivers/md/dm-verity-fec.c:725:6: note: in expansion of macro 'do_div'
>   if (do_div(f->rounds, f->rsn))
> 
> This changes the code to use sector_div instead, which does the
> right thing and avoids the warning.

Thanks, I'll fold this in.

(Btw, I did review this use of do_div(): but only to answer whether there
was potential for a 64bit divide.  I concluded do_div() was fine but didn't
look to see the data type for f->rounds was actually sector_t.)
