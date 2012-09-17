From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [dm-devel] [PATCH v10 8/8] block: Add bio_clone_bioset(),
 bio_clone_kmalloc()
Date: Mon, 17 Sep 2012 13:42:27 -0700
Message-ID: <20120917204227.GA14492@google.com>
References: <1346970902-10931-1-git-send-email-koverstreet@google.com>
 <1346970902-10931-9-git-send-email-koverstreet@google.com>
 <20120914215059.GQ15728@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120914215059.GQ15728-FDJ95KluN3Z0klwcnFlA1dvLeJWuRmrY@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Jeff Garzik <jeff-o2qLIJkoznsdnm+yROfE0A@public.gmane.org>, Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

On Fri, Sep 14, 2012 at 10:50:59PM +0100, Alasdair G Kergon wrote:
> On Thu, Sep 06, 2012 at 03:35:02PM -0700, Kent Overstreet wrote:
> > Previously, there was bio_clone() but it only allocated from the fs bio
> > set; as a result various users were open coding it and using
> > __bio_clone().
> 
> Explain in the header the reasoning behind the change to dm-crypt so that 
> it no longer resets bi_idx to 0 too?
> 
> > -	clone->bi_idx = 0;

Previously, it was open coding __bio_clone(), that's what the setting
bi_idx to 0 was from. With the change to bio_clone_bioset() that's no
longer necessary (and dangerous, since bi_idx needs to be consistent
with bi_sector/bi_size).
