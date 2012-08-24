From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v6 11/13] block: Rework bio_pair_split()
Date: Fri, 24 Aug 2012 13:58:12 -0700
Message-ID: <20120824205812.GJ21325@google.com>
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
Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>, Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, Peter Osterlund <petero2-zq6IREYz3ykAvxtiuMwx3w@public.gmane.org>, Sage Weil <sage-4GqslpFJ+cxBDgjK7y7TUQ@public.gmane.org>
List-Id: dm-devel.ids

Hello, Martin.

On Thu, Aug 23, 2012 at 10:25:47PM -0400, Martin K. Petersen wrote:
> However, I'm not sure I like the overall approach of the new splitting.
> Instead of all this cloning, slicing and dicing of bio_vecs I'd rather
> we bit the bullet and had an offset + length for the vector inside each
> bio. That way we could keep the bio_vec immutable and make clones more
> lightweight since their vecs would always point to the parent. This also
> makes it trivial to split I/Os in the stacking drivers and removes evils
> in the partial completion code path. It would also allow to sever the
> ties between "size of block range operated on" vs. bi_size which we need
> for copy offload, discard, etc.

Yeah, I'm fairly sure we all want that but that's gonna have to be a
separate not-so-small project.  Also, how we split underlying bvec
doesn't affect the split interface update being done here.  This
patchset is updating split so that it can handle arbirarily sized
bios, which is useful whether its implementation is using immutable
bvec or COWing it.

Thanks.

-- 
tejun
