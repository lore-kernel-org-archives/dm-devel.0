From: Alasdair G Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [dm-devel] [PATCH v10 1/8] block: Generalized bio pool freeing
Date: Tue, 18 Sep 2012 17:31:57 +0100
Message-ID: <20120918163156.GC17356@agk-dp.fab.redhat.com>
References: <1346970902-10931-1-git-send-email-koverstreet@google.com> <1346970902-10931-2-git-send-email-koverstreet@google.com> <20120914182828.GK15728@agk-dp.fab.redhat.com> <20120917205139.GB14492@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120917205139.GB14492-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
List-Id: dm-devel.ids

On Mon, Sep 17, 2012 at 01:51:39PM -0700, Kent Overstreet wrote:
> That isn't a very good patch - it says it's clearing bi_end_io as a
> precaution, but as a precaution to what?
 
As a precaution against the endio function being called an extra time by
mistake if a stray reference remains after the bio has been freed.
Wipe this field when dm frees it.  Defensive programming, basically,
in response to a tricky bug he had to deal with.

Alasdair
