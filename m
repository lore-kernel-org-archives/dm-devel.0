From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm log userspace: use mempool_create_kmalloc_pool()
Date: Wed, 18 Mar 2015 18:30:46 -0400
Message-ID: <20150318223045.GA17765@redhat.com>
References: <alpine.DEB.2.10.1503071642540.2772@chino.kir.corp.google.com>
 <20150311125852.GA28768@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150311125852.GA28768@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Rientjes <rientjes@google.com>
Cc: Alasdair Kergon <agk@redhat.com>, Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Mar 11 2015 at  8:58am -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Sat, Mar 07 2015 at  7:43pm -0500,
> David Rientjes <rientjes@google.com> wrote:
> 
> > Mempools created for kmalloc caches should use
> > mempool_create_kmalloc_pool().
> > 
> > Cc: Alasdair Kergon <agk@redhat.com>
> > Cc: Mike Snitzer <snitzer@redhat.com>
> > Cc: Neil Brown <neilb@suse.de>
> > Signed-off-by: David Rientjes <rientjes@google.com>
> 
> Thanks David, I'll get this queued up.

Turns out I already fixed this a different way about a month ago and
staged it for 4.1, see:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=db57216e710ea5c517f1030fafe7eb21ac938dc5

You'll be interested to note this portion of that commit's header:
"This _should_ eliminate DM's need for io_schedule_timeout() in
mempool_alloc(); so io_schedule() should be sufficient now."

I'll defer to you on whether you'd like to pursue switching to
io_schedule() in mempool_alloc().
