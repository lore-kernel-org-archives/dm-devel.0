From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 02/26] block: Add bio_advance()
Date: Thu, 20 Sep 2012 16:38:20 -0700
Message-ID: <20120920233820.GD5519@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-3-git-send-email-koverstreet@google.com>
 <20120920215827.GF7264@google.com>
 <20120920231308.GB5519@google.com>
 <20120920232506.GI7264@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120920232506.GI7264-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org
List-Id: dm-devel.ids

On Thu, Sep 20, 2012 at 04:25:06PM -0700, Tejun Heo wrote:
> Hello,
> 
> On Thu, Sep 20, 2012 at 04:13:08PM -0700, Kent Overstreet wrote:
> > I just cut and pasted that from blk_update_request(), which is what the
> > next patch refactors...
> 
> Yeah, well, that was written when we didn't have WARNs.
> 
> > But yes it would be a bug. It gets converted to a BUG_ON() in a later
> > patch (not in this series), as this gets further abstracted into a
> > wrapper around bvec_advance_iter() which doesn't know about struct bio
> > (as bio integrity gets its own iterator).
> 
> WARN() generally preferable unless there's no way at all to continue.
> Storage layer could be a bit different if immediate danger for data
> corruption exists but the general consensus seems that we're too
> trigger happy with BUG_ON()s.

Yeah. Changed it to a WARN_ONCE().
