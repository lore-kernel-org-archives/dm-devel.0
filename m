From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 11/14] block: Rework bio splitting
Date: Fri, 25 May 2012 14:48:27 -0400
Message-ID: <20120525184827.GA8300@redhat.com>
References: <1337817771-25038-1-git-send-email-koverstreet@google.com>
 <1337817771-25038-12-git-send-email-koverstreet@google.com>
 <4FBE6823.50904@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4FBE6823.50904-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org
List-Id: dm-devel.ids

On Thu, May 24, 2012 at 07:56:03PM +0300, Boaz Harrosh wrote:

[..]
> In the split you have a single bio with or without bvects allocation
> should you not let the caller make sure not to set __GFP_WAIT.
> 
> For me, inspecting current->bio_list is out of context and a complete
> hack. The caller should take care of it, which has more context.
> 
> For example I might want to use split from OSD code where I do
> not use an elevator at all, and current->bio_list could belong
> to a completely different device. (Maybe)

FWIW, I too think that checking for current->bio_list in bio_split() sounds
hackish and it should be left to caller to set right gfp flags. And it should
be commented well.

Thanks
Vivek
