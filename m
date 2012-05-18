From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [Bcache v13 00/16]
Date: Fri, 18 May 2012 10:06:04 +0000
Message-ID: <201205181006.04575.arnd@arndb.de>
References: <cover.1336619038.git.koverstreet@google.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1336619038.git.koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tejun-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

On Thursday 10 May 2012, Kent Overstreet wrote:
> TODO/known issues:
> 
> __up_write() needs to be exported for bcache to compile as a module - it's
> used for bypassing lockdep when traversing the btree during garbage
> collection. If someone else knows a better solution, please let me know.
> 
> The userspace interface is going to change before it goes in. The general
> consensus at LSF was that we don't want yet another interface for
> probing/managing block devices, and dm exists so we may as well use that. I
> don't think anyone's started on that yet, though.
> 
> Documentation needs to be updated. That's being actively worked on, though.

Hi Kent,

Sorry for jumping in late in the discussion. I believe we discussed the
requirements for the low-end media when you posted v12 and it seemed that
there are issues with a lot of the low-end media you were planning to
support. I have seen devices with 12MB or 16MB erase block size, which you 
didn't handle well, and many devices are severely limited on the number of
buckets (erase blocks that a device can write to concurrently), typically
3 to 8 for an SD card and slightly more for a USB drive.

Are you still planning to support those devices or are you focusing now
on other hardware? If you plan to support them, what are you current
limits on the bucket size and the number of buckets?

FWIW, Tixy has written a tool named flashsim[1] to simulate the behavior
of all kinds of flash drives, so you can use a blocktrace file as
input and it will tell you the write amplification factor that a given
drive would suffer given that workload. You can use it to find out how
your algorithms would interact with devices that can only support a
smaller number of buckets that you would actually want.

	Arnd

[1] http://yxit.co.uk/public/flash-performance/
