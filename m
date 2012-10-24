From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 1/2] block: Fix a buffer overrun in bio_integrity_split()
Date: Wed, 24 Oct 2012 12:42:46 -0400
Message-ID: <CAOS58YPFq_rt1Pw-v1XtX7-tnPGceXP5Chpp9JhkkMtnWnNQsg@mail.gmail.com>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
	<1350331769-14856-28-git-send-email-koverstreet@google.com>
	<20121019203015.GS13370@google.com>
	<20121022153907.GC3401@redhat.com>
	<yq1mwzbbzi1.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <yq1mwzbbzi1.fsf-+q57XtR/GgMb6DWv4sQWN6xOck334EZe@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
List-Id: dm-devel.ids

Hey, guys.

On Wed, Oct 24, 2012 at 12:34 PM, Martin K. Petersen
<martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>>>>>> "Vivek" == Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
>
> Vivek> Initially he had reordered the bio_pair fields but there were
> Vivek> couple of issues. We could not assume that there is no padding
> Vivek> between fields and secondly some of the initializtion of looked
> Vivek> plain ugly.
>
> Vivek> IMHO, introduction of bip_vec to fix this issue is small and
> Vivek> cleaner then reordering fields.
>
> I agree.

If Martin is happy with it, I'm not gonna push it but putting the
respective storage member after one containing vararray at the end is
a legit way to allocate the area statically. As long as the storage
field is marked as such and not accessed directly, it doesn't matter
whether there's padding inbetween or not. Anyways, let's push this one
to -stable then.

Thanks.

-- 
tejun
