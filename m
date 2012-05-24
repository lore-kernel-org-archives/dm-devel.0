From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 09/14] block: Add an explicit bio flag for bios that
 own their bvec
Date: Thu, 24 May 2012 14:31:58 -0700
Message-ID: <20120524213158.GB22664@google.com>
References: <1337817771-25038-1-git-send-email-koverstreet@google.com>
 <1337817771-25038-10-git-send-email-koverstreet@google.com>
 <4FBE687E.1030605@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4FBE687E.1030605-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org
List-Id: dm-devel.ids

On Thu, May 24, 2012 at 07:57:34PM +0300, Boaz Harrosh wrote:
> How do you insure that the original bio which owns the
> bvec is not freed before the split-out bio.
> 
> Perhaps calling code needs to make sure by taking an extra
> ref on the original bio, or something. If so a big fat comment
> at bio_split is do.

Yeah, just added that.

> 
> And I understand you did not like my suggestion of negating
> the meaning of the flag, so the default is zero?
> Please say why?

I liked it at first, but I think I prefer having the flag be set
if bio_free() must take some action; i.e. you set the flag when you
allocate bi_io_vec. Also, I think bio_alloc_bioset() getting
reimplemented is less likely than people open coding bio splitting or
something that shares bi_io_vec in the future, so it's slightlry less
likely to be used wrong this way.
