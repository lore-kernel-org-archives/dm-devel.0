From: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [dm-devel] [PATCH v2 01/26] block: Convert integrity to bvec_alloc_bs(), and a bugfix
Date: Wed, 12 Sep 2012 15:39:18 -0400
Message-ID: <yq1wqzzrpy1.fsf@sermon.lab.mkp.net>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
	<1347322957-25260-2-git-send-email-koverstreet@google.com>
	<20120911203643.GC17113@redhat.com>
	<20120911220750.GM19739@google.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120911220750.GM19739-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> (Kent Overstreet's message of
	"Tue, 11 Sep 2012 15:07:50 -0700")
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

>>>>> "Kent" == Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> writes:

Kent,

Kent> To fix the bug first, I'd have to reorder struct bio_pair and then
Kent> just delete two lines of code from bio_integrity_split(). But the
Kent> reordering is unnecessary with the refactoring.

Well, a bug is a bug and the fix needs to go into stable. So we will
need a patch that does not depend on your changes.

I don't have a problem with adding a pointer so clones can point to the
parent's vector. But embedding the vector into the bip was a feature.
If you check the git log you'll see that originally I did use separate
vector allocations.

-- 
Martin K. Petersen	Oracle Linux Engineering
