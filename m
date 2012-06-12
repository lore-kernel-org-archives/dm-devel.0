From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Bcache v14 16/16] bcache: Debug and tracing code
Date: Tue, 12 Jun 2012 10:45:28 -0700
Message-ID: <20120612174528.GB11365@google.com>
References: <1339515562-14638-1-git-send-email-koverstreet@google.com>
 <1339515562-14638-17-git-send-email-koverstreet@google.com>
 <1339519858.2017.10.camel@joe2Laptop>
 <20120612172444.GA11365@google.com>
 <1339522543.2404.3.camel@joe2Laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1339522543.2404.3.camel@joe2Laptop>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Cc: g@google.com, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tejun-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: dm-devel.ids

On Tue, Jun 12, 2012 at 10:35:43AM -0700, Joe Perches wrote:
> "(uint64_t *)k - i->d" is what type again?
> What is a %zu?
> 
> Isn't that a mismatch?

You're right - ssize_t and size_t. I think gcc just isn't checking
signedness at all, that %i should be a %u too. Good catch.

> 
> > > > +static int debug_seq_show(struct seq_file *f, void *data)
> > > > +{
> > > > +	static const char *tabs = "\t\t\t\t\t";
> > > 
> > > Seems a _very_ odd use.
> > 
> > It is a strange hack.
> > 
> > The idea is that we want to indent more as we recurse; we could build up
> > a new string of tabs each time we recurse that's got one more tab than
> > our parent's, but that'd be a pain in the ass and it'd use more stack
> > space (though that should be fine here), so instead it's just
> > decrementing the pointer to the tab string to produce a string with one
> > more tab.
> 
> It's a nice idea, but that's not what's happening
> as I believe you reference tabs only once as &tabs[4]

bch_btree_dump() prints out tabs, and passes tabs - 1 when it recurses.
