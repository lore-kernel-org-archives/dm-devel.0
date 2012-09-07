From: Alasdair G Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [dm-devel] [PATCH v10 4/8] block: Add bio_reset()
Date: Sat, 8 Sep 2012 00:14:33 +0100
Message-ID: <20120907231433.GE10309@agk-dp.fab.redhat.com>
References: <1346970902-10931-1-git-send-email-koverstreet@google.com> <1346970902-10931-5-git-send-email-koverstreet@google.com> <50494F1A.4080207@kernel.dk> <20120907205823.GD16360@google.com> <504A6D57.1030607@kernel.dk> <504A6FF5.3090603@kernel.dk> <20120907222522.GE16360@google.com> <504A78B0.8010105@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <504A78B0.8010105-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

As I indicated already in this discussion, dm started to use
merge_bvec_fn as a cheap way of avoiding splitting and this improved
overall efficiency.  Often it's better to pay the small price of calling
that function to ensure the bio is created the right size in the first
place so it won't have to get split later.

I'm as yet unconvinced that removing merge_bvec_fn would be an overall
win.  Some of Kent's other changes that make splitting cheaper will
improve the balance in some situations, but that might be handled by
simplifying the merge_bvec_fn calculations in those situations.
(Or changing the mechanism to avoid repeating performing the mapping
when it hasn't changed.)

IOW Any proposal to remove merge_bvec_fn from dm needs careful 
evaluation to ensure it doesn't introduce any significant
performance regressions for some sets of users.

Alasdair
