From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v7 9/9] block: Avoid deadlocks with bio allocation by
 stacking drivers
Date: Tue, 28 Aug 2012 16:01:08 -0700
Message-ID: <20120828230108.GI1048@moria.home.lan>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-10-git-send-email-koverstreet@google.com>
 <20120828204910.GG24608@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120828222800.GG1048@moria.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120828222800.GG1048-jC9Py7bek1znysI04z7BkA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-Id: dm-devel.ids

On Tue, Aug 28, 2012 at 03:28:00PM -0700, Kent Overstreet wrote:
> On Tue, Aug 28, 2012 at 01:49:10PM -0700, Tejun Heo wrote:
> > Overall, I *think* this is correct but need to think more about it to
> > be sure.
> 
> Please do. As much time as I've spent staring at this kind of stuff,
> I'm pretty sure I've got it correct but it still makes my head hurt to
> work out all the various possible deadlocks.

Hilarious thought: We're punting bios to a rescuer thread that's
specific to a certain bio_set, right? What if we happen to punt bios
from a different bio_set? And then the rescuer goes to resubmit those
bios, and in the process they happen to have dependencies on the
original bio_set...

I think it's actually necessary to filter out only bios from the current
bio_set to punt to the rescuer.

God I love the block layer sometimes.
