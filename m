From: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Subject: Re: [PATCH v5 02/12] dm: Use bioset's front_pad for dm_rq_clone_bio_info
Date: Sat, 11 Aug 2012 15:24:45 +1000
Message-ID: <CAOzFzEhPW5-edb6mnL2gNbb4956u2MbWqQovv01010PyBCbc+g@mail.gmail.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
	<1344290921-25154-3-git-send-email-koverstreet@google.com>
	<20120808220612.GA6983@dhcp-172-17-108-109.mtv.corp.google.com>
	<20120808235731.GA7262@moria.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120808235731.GA7262-jC9Py7bek1znysI04z7BkA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org, snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

Hi Kent, Tejun

On 9 August 2012 09:57, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>> Also, how was this tested?
>
> Well, AFAICT the only request based dm target is multipath, and from the
> documentation I've seen it doesn't appear to work without multipath
> hardware, or at least I haven't seen it documented how. So, unless
> there's another user I missed it's not been tested.

Multipath can be tested quite easily with a loopback scsi target, you
don't require specialized hardware.
The easiest way to do this would probably be the built in LIO target +
open_iscsi initiator.

I haven't attempted running this current version of the patch series
but I haven't run into issues with bcache+multipath in the past.

>
>>
>> Thanks.
>>
>> --
>> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
CTO | Orion Virtualisation Solutions | www.orionvm.com.au
Phone: 1300 56 99 52 | Mobile: 0428 754 846
