From: Alasdair G Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [dm-devel] [PATCH v10 8/8] block: Add bio_clone_bioset(),
	bio_clone_kmalloc()
Date: Tue, 18 Sep 2012 17:15:29 +0100
Message-ID: <20120918161529.GB17356@agk-dp.fab.redhat.com>
References: <1346970902-10931-1-git-send-email-koverstreet@google.com> <1346970902-10931-9-git-send-email-koverstreet@google.com> <20120914215059.GQ15728@agk-dp.fab.redhat.com> <20120917204227.GA14492@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120917204227.GA14492-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Jeff Garzik <jeff-o2qLIJkoznsdnm+yROfE0A@public.gmane.org>, Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

On Mon, Sep 17, 2012 at 01:42:27PM -0700, Kent Overstreet wrote:
> Previously, it was open coding __bio_clone(), that's what the setting
> bi_idx to 0 was from. With the change to bio_clone_bioset() that's no
> longer necessary (and dangerous, since bi_idx needs to be consistent
> with bi_sector/bi_size).
 
It was performing a partial clone, deleting any no-longer-needed entries
from the array.  This patch undoes that which is presumably OK because
you propose to eliminate them again in a later one of your patches.

Alasdair
