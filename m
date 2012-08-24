From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 11/13] block: Rework bio_pair_split()
Date: Fri, 24 Aug 2012 03:37:34 -0700
Message-ID: <20120824103734.GH11977@moria.home.lan>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
 <1345655050-28199-12-git-send-email-koverstreet@google.com>
 <20120822210410.GL19212@google.com>
 <yq1y5l5hvpw.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <yq1y5l5hvpw.fsf-+q57XtR/GgMb6DWv4sQWN6xOck334EZe@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>, Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, Peter Osterlund <petero2-zq6IREYz3ykAvxtiuMwx3w@public.gmane.org>, Sage Weil <sage-4GqslpFJ+cxBDgjK7y7TUQ@public.gmane.org>
List-Id: dm-devel.ids

On Thu, Aug 23, 2012 at 10:25:47PM -0400, Martin K. Petersen wrote:
> >>>>> "Tejun" == Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> writes:
> 
> Tejun> I complained about this in the last posting and in the previous
> Tejun> patch.  Please respond.  Martin, are you okay with these
> Tejun> integrity changes?
> 
> I missed the first several iterations of all this while I was out on
> vacation. I'll have to try to wrap my head around the new approach.
> 
> However, I'm not sure I like the overall approach of the new splitting.
> Instead of all this cloning, slicing and dicing of bio_vecs I'd rather
> we bit the bullet and had an offset + length for the vector inside each
> bio. That way we could keep the bio_vec immutable and make clones more
> lightweight since their vecs would always point to the parent. This also
> makes it trivial to split I/Os in the stacking drivers and removes evils
> in the partial completion code path. It would also allow to sever the
> ties between "size of block range operated on" vs. bi_size which we need
> for copy offload, discard, etc.

Agree 110% - making bio_vecs immutable and keeping the offset in the bio
is something I've been talking about for ages, I'd love to see it
happen.

But that's going to be a much more invasive change so if I'm going to do
it (and I am willing to work on it) it's just going to be a bit. This is
really a stopgap solution.

As far as the integrity splitting, it's similar to what the existing dm
code does (main difference is dm already has the bio cloned, my
bio_split() doesn't assume anything about the bio being split). Not sure
how that affects ownership of the integrity data, honestly that part
kind of confuses me.
