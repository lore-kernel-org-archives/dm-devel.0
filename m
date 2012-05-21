From: Kent Overstreet <koverstreet@google.com>
Subject: Re: [Bcache v13 07/16] Closures
Date: Mon, 21 May 2012 12:40:20 -0700
Message-ID: <20120521194020.GA20338@google.com>
References: <cover.1336619038.git.koverstreet@google.com>
 <82f00ebb4ee0404788c5bd7fbfa1fe4969f28ba1.1336619038.git.koverstreet@google.com>
 <20120515224137.GA15386@google.com>
 <20120518062948.GA21163@dhcp-172-18-216-138.mtv.corp.google.com>
 <20120518110247.08696cec@pyramind.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120518110247.08696cec@pyramind.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Tejun Heo <tj@kernel.org>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Fri, May 18, 2012 at 11:02:47AM +0100, Alan Cox wrote:
> > Well, I can definitely understand your reservations about the code; it's
> > strange and foreign and complicated. But having beaten my head against
> > the various problems and difficulties inherent in asynchronous
> > programming for years - well, having found a way to make it sane to me
> > it'd be madness to go back.
> 
> I think its more of a different paradigm than complicated.

Yeah, that's probably apt :) 

> The big
> question I'd have to ask is how does it fit with hard real time. That is
> a big issue given the gradual merging and getting of "hard" real time
> into the kernel proper.
> 
> In some ways it's not that strange either. A look at what happens on some
> of our kref handling in drivers is very similar but hardcoded.
> 
> Is the handling of priority inversion within closures a well understood
> and solved problem ?

Haven't really thought about it (aside from deadlocks which are a
slightly different issue). AFAICT there shouldn't be much to worry
about, at least with the way I'm using closures today; scheduling is all
handled by the existing workqueue code and you have to explicitly say
which workqueue a function is going to run out of.

There are the wait lists I've implemented but that's mostly just for
when some thread/closure is waiting on an arbitrary event to become true
- analagous to wait_event(), in which case you want everything on the
wait list to to run at once which is all it implements.

If the closure wait lists ever did end up being used in a situation
where priorities or priority inversion was more of a concern it wouldn't
be a huge deal to swap out the implementation for something more
sophisticated, or just use the existing wait_queue_t.
