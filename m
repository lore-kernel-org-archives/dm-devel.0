From: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 11/13] block: Rework bio_pair_split()
Date: Thu, 23 Aug 2012 22:25:47 -0400
Message-ID: <yq1y5l5hvpw.fsf@sermon.lab.mkp.net>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
	<1345655050-28199-12-git-send-email-koverstreet@google.com>
	<20120822210410.GL19212@google.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120822210410.GL19212-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> (Tejun Heo's message of "Wed,
	22 Aug 2012 14:04:10 -0700")
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>, Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, Peter Osterlund <petero2-zq6IREYz3ykAvxtiuMwx3w@public.gmane.org>, Sage Weil <sage-4GqslpFJ+cxBDgjK7y7TUQ@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

>>>>> "Tejun" == Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> writes:

Tejun> I complained about this in the last posting and in the previous
Tejun> patch.  Please respond.  Martin, are you okay with these
Tejun> integrity changes?

I missed the first several iterations of all this while I was out on
vacation. I'll have to try to wrap my head around the new approach.

However, I'm not sure I like the overall approach of the new splitting.
Instead of all this cloning, slicing and dicing of bio_vecs I'd rather
we bit the bullet and had an offset + length for the vector inside each
bio. That way we could keep the bio_vec immutable and make clones more
lightweight since their vecs would always point to the parent. This also
makes it trivial to split I/Os in the stacking drivers and removes evils
in the partial completion code path. It would also allow to sever the
ties between "size of block range operated on" vs. bi_size which we need
for copy offload, discard, etc.

-- 
Martin K. Petersen	Oracle Linux Engineering
