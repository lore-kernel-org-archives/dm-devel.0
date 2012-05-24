From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 07/14] pktcdvd: Switch to bio_kmalloc()
Date: Thu, 24 May 2012 15:42:52 -0400
Message-ID: <20120524194252.GF27550@redhat.com>
References: <1337817771-25038-1-git-send-email-koverstreet@google.com>
 <1337817771-25038-8-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1337817771-25038-8-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org
List-Id: dm-devel.ids

On Wed, May 23, 2012 at 05:02:44PM -0700, Kent Overstreet wrote:

[..]
> @@ -567,10 +569,13 @@ static struct packet_data *pkt_alloc_packet_data(int frames)
>  		goto no_pkt;
>  
>  	pkt->frames = frames;
> -	pkt->w_bio = pkt_bio_alloc(frames);
> +	pkt->w_bio = bio_kmalloc(GFP_KERNEL, frames);

So previously bios allocated were being kfreed by pkt_bio_destructor().
Now where are we doing kfree() on bio being allocated by bio_kmalloc()?

Thanks
Vivek
