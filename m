From: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 1/2] block: Fix a buffer overrun in bio_integrity_split()
Date: Wed, 24 Oct 2012 12:57:45 -0400
Message-ID: <yq1ehknbyeu.fsf@sermon.lab.mkp.net>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
	<1350331769-14856-28-git-send-email-koverstreet@google.com>
	<20121019203015.GS13370@google.com> <20121022153907.GC3401@redhat.com>
	<yq1mwzbbzi1.fsf@sermon.lab.mkp.net>
	<CAOS58YPFq_rt1Pw-v1XtX7-tnPGceXP5Chpp9JhkkMtnWnNQsg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOS58YPFq_rt1Pw-v1XtX7-tnPGceXP5Chpp9JhkkMtnWnNQsg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Tejun Heo's message of "Wed, 24 Oct 2012 12:42:46 -0400")
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
List-Id: dm-devel.ids

>>>>> "Tejun" == Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> writes:

Tejun> If Martin is happy with it, I'm not gonna push it but putting the
Tejun> respective storage member after one containing vararray at the
Tejun> end is a legit way to allocate the area statically. As long as
Tejun> the storage field is marked as such and not accessed directly, it
Tejun> doesn't matter whether there's padding inbetween or not. 

The embedded array is still at the end. Kent just added an explicit
pointer for use in the bio_pair corner case.

-- 
Martin K. Petersen	Oracle Linux Engineering
