From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 0/9] Generate uevents for all DM events
Date: Wed, 5 Oct 2016 01:40:05 +0100
Message-ID: <20161005004004.GC28416@agk-dp.fab.redhat.com>
References: <1475522580-16723-1-git-send-email-agrover@redhat.com> <20161004072015.GA11216@kroah.com> <fe185eba-f802-6731-8da7-736c117db135@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <fe185eba-f802-6731-8da7-736c117db135@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, snitzer@redhat.com
List-Id: dm-devel.ids

On Tue, Oct 04, 2016 at 04:39:28PM -0700, Andy Grover wrote:
> devicemapper is using uevents for:
> a. dm-verity detected corruption
> b. dm-multipath: path failed or reinstated
> c. dm device renamed
> d. there's also some use in md and bcache.
>
> devicemapper uses DM_EVENT ioctl (yuck) for:
> 1. dm-thin pool data/metadata filling up (hit a threshold)
> 2. dm-cache is now clean
> 3. dm-log flushed or log failed
> 4. dm-raid error detected or sync complete

> there doesn't seem to be much technical differentiation between the  
> two lists.

The distinction in dm is that events in the first category may affect
the availability of the device: they represent major (and hopefully
rare) changes.

Events in the second category are just notifications: no impact on /dev,
no need to trigger udev rules, and their use will continue to be
extended, and (rarely at the moment) could be frequent (which is no
problem for the existing polling-based mechanism).

> Instead of using uevent for everything, we could go to a separate  
> genetlink for 1-4 instead of making them use uevent like a-d, but we'd  
> end up with two different userspace notification techniques.

We see these as two different categories of notifications, and prefer
the greater flexibility a mechanism independent of uevents would
provide.  The team has discussed several alternatives over the years but
didn't make a decision as we've not yet reached a point where we're
straining the existing mechanism too far.

Alasdair
