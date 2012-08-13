From: Kent Overstreet <koverstreet@google.com>
Subject: Re: [PATCH v5 12/12] block: Only clone bio vecs that are in use
Date: Mon, 13 Aug 2012 14:46:54 -0700
Message-ID: <20120813214654.GD9541@google.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
 <1344290921-25154-13-git-send-email-koverstreet@google.com>
 <20120809173700.GB6644@dhcp-172-17-108-109.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120809173700.GB6644@dhcp-172-17-108-109.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk, agk@redhat.com, neilb@suse.de, drbd-dev@lists.linbit.com, vgoyal@redhat.com, mpatocka@redhat.com, sage@newdream.net, yehuda@hq.newdream.net
List-Id: dm-devel.ids

On Thu, Aug 09, 2012 at 10:37:00AM -0700, Tejun Heo wrote:
> Hello,
> 
> On Mon, Aug 06, 2012 at 03:08:41PM -0700, Kent Overstreet wrote:
> > bcache creates large bios internally, and then splits them according to
> > the device requirements before it sends them down. If a lower level
> > device tries to clone the bio, and the original bio had more than
> > BIO_MAX_PAGES, the clone will fail unecessarily.
> > 
> > We can fix this by only cloning the bio vecs that are actually in use.
> 
> How was this tested?

This code has been in the bcache tree for months, and I added it to fix
a real bug (think I saw it with bcache on top of dm) - and since then
it's been tested in probably just about all the relevant configurations,
certainly both dm and md.
