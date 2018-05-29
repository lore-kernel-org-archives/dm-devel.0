From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH][next] dm writecache: fix missing goto in error handling
 code
Date: Tue, 29 May 2018 14:09:03 -0400
Message-ID: <20180529180903.GB32763@redhat.com>
References: <20180527222512.25280-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180527222512.25280-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Sun, May 27 2018 at  6:25pm -0400,
Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently, the -EFBIG error condition when n_bitmaps_bits is
> too large is falling through to the next statement and the
> error assignment to r is potentially being ignored.  The code
> should be exiting to the error path via label 'bad'. Fix
> this by adding the missing goto statement.
> 
> Detected by CoverityScan, CID#1469377 ("Unused value")
> 
> Fixes: bb15b431d650 ("dm: add writecache target")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Thanks, I've picked this up.
