From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Bcache v13 11/16] bcache: Core btree code
Date: Wed, 23 May 2012 10:24:35 -0700
Message-ID: <20120523172435.GB18143@google.com>
References: <cover.1336619038.git.koverstreet@google.com>
 <7f1de39b6d7040b3fe271500776f4b985b21ea82.1336619038.git.koverstreet@google.com>
 <20120522221259.GJ14339@google.com>
 <20120523034546.GB607@dhcp-172-18-216-138.mtv.corp.google.com>
 <20120523052054.GB29976@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120523053403.GB14312@dhcp-172-18-216-138.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120523053403.GB14312-RcKxWJ4Cfj3IzGYXcIpNmNLIRw13R84JkQQo+JxHRPFibQn6LdNjmg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

Hello,

On Wed, May 23, 2012 at 01:34:03AM -0400, Kent Overstreet wrote:
> On Tue, May 22, 2012 at 10:20:54PM -0700, Tejun Heo wrote:
> > Hmmm... I would prefer it to be defined explicitly as union.  It's
> > rather easy to define it incorrectly (ie. using struct bkey) and then
> > pass it around expecting it to have the pad.
> 
> Thing is, things don't expect the pad - bkeys are normally just in a big
> chunk of memory concatenated together, and the same functions have to
> work both with those and with bare bkeys the code occasionally
> manipulates.

Hmmm... so it's actually just padding?  Padding for what?  I thought
it was there to provide space for ptr[], no?

> > I'm a bit confused.  Cache device or cached device?  Isn't the key
> > dev:offset:size of the cached device?
> 
> No - bkey->key is the offset on the cached device, PTR_OFFSET is on the
> cache.
> 
> Confusing, I know. Any ideas for better terminology?

Double confused by the "no" and the following sentence seemingly
agreeing with what I wrote.  So, bkey->key indexes the backend device
- the slow big disk and the associated PTRs point into the fast SSD
caching device, right?  If so, I think 'key' is fine, that's the only
thing which can be key anyway.  As for PTR_XXX, maybe something which
can signify they're the cache would be nicer but with proper comments
I don't think it's big deal.

Thanks.

-- 
tejun
