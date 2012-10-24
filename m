From: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 2/2] block: Convert integrity to bvec_alloc_bs()
Date: Wed, 24 Oct 2012 12:54:49 -0400
Message-ID: <yq1ip9zbyjq.fsf@sermon.lab.mkp.net>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
	<1350331769-14856-29-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1350331769-14856-29-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> (Kent
	Overstreet's message of "Mon, 15 Oct 2012 13:09:02 -0700")
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

>>>>> "Kent" == Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> writes:

Kent> Also, bio_integrity_alloc() was using fs_bio_set if no bio_set was
Kent> specified. This was wrong

You did that, I didn't.


Kent> - using the bio_set doesn't protect us from memory allocation
Kent>   failures, because we just used kmalloc for the
Kent>   bio_integrity_payload.

I don't understand this comment. kmalloc where?

The bip includes an embedded bvec array and comes from either one of the
dedicated slabs or - in the case of the max bvec size - from a
mempool. These slabs and the mempool are per bio_set.

-- 
Martin K. Petersen	Oracle Linux Engineering
