From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 0/9] Generate uevents for all DM events
Date: Tue, 4 Oct 2016 09:20:15 +0200
Message-ID: <20161004072015.GA11216@kroah.com>
References: <1475522580-16723-1-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1475522580-16723-1-git-send-email-agrover@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: snitzer@redhat.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Oct 03, 2016 at 12:22:51PM -0700, Andy Grover wrote:
> Hi Mike and GregKH,
> 
> I want a way to get devicemapper events without using the DM ioctl,
> because that requires creating a thread to sleep in the ioctl for each
> dm device I want events from.
> 
> It would seem like using uevents and KOBJ_CHANGE would be a good way
> to do this, but Mike said that the uevent maintainers (Greg that's
> you?) did not think this was a good idea?

KBOJ_CHANGE is a tricky one.  It has been used for a variety of
different things, but usually it is used to show that a major change has
happened with a device like a docking station plug in or out.

How often do DM events happen?  What is triggering them?  How do you
want to send them to userspace?  Through a sysfs file?  Why not just use
your own netlink connection?

thanks,

greg k-h
