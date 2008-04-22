From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC][PATCH 0/10] I/O context inheritance
Date: Tue, 22 Apr 2008 16:54:18 +0200
Message-ID: <20080422145418.GL12774@kernel.dk>
References: <20080422.224935.00673711.taka@valinux.co.jp> <20080422.230318.112756414.taka@valinux.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1764713AbYDVOyf@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080422.230318.112756414.taka@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: Hirokazu Takahashi <taka@valinux.co.jp>
Cc: agk@sourceware.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Apr 22 2008, Hirokazu Takahashi wrote:
> Hi,
> 
> Sorry, these patches are for linux-2.6.25.
> 
> > This series of patches make the block I/O layer and the I/O schedulers
> > be able to determine the right io_context of every I/O.
> > 
> > The current implementation of the block I/O layer and the I/O schedulers
> > assume that the current process is the one which issued the given I/O,
> > then use the io_context of this process to control the I/O.
> > But this assumption isn't quite right because several kernel threads
> > will handle I/O requests on behalf of the processes which originated them.
> > This often happens when you want to use device mapper modules.
> > 
> > The patches make every bio has a pointer to an io_context, which will
> > be set when it is allocated or cloned. So it makes it possible to find
> > the right io_context from any bio at any place.
> > 
> > I'm waiting for your comments.

Can you give a brief summary of what you need this stuff for?

-- 
Jens Axboe
