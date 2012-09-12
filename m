From: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 25/26] bio-integrity: Add explicit field for owner of bip_buf
Date: Wed, 12 Sep 2012 15:41:36 -0400
Message-ID: <yq1sjanrpu7.fsf@sermon.lab.mkp.net>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
	<1347322957-25260-26-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1347322957-25260-26-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> (Kent
	Overstreet's message of "Mon, 10 Sep 2012 17:22:36 -0700")
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

>>>>> "Kent" == Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> writes:

Kent> This was the only real user of BIO_CLONED, which didn't have very
Kent> clear semantics. Convert to its own flag so we can get rid of
Kent> BIO_CLONED.

I already have a patch in my queue that moves all integrity-relevant
flags from struct bio to the bip. So I'm ok with removing BIO_CLONED but
I'll send a separate patch for the integrity flags.

-- 
Martin K. Petersen	Oracle Linux Engineering
