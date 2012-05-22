From: "Jun'ichi Nomura" <j-nomura-JhyGz2TFV9J8UrSeD/g0lQ@public.gmane.org>
Subject: Re: [dm-devel] [PATCH 02/13] dm: kill dm_rq_bio_destructor
Date: Tue, 22 May 2012 13:29:01 +0900
Message-ID: <4FBB160D.9040600@ce.jp.nec.com>
References: <cover.1337308722.git.koverstreet@google.com> <f07bc0f57562d98078e0f4c507cae165aa159e7c.1337308722.git.koverstreet@google.com> <20120518155729.GB19388@google.com> <20120518164319.GJ29330@agk-dp.fab.redhat.com> <20120518185027.GA9673@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120518185027.GA9673-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

Hi,

On 05/19/12 03:50, Kent Overstreet wrote:
> On Fri, May 18, 2012 at 05:43:19PM +0100, Alasdair G Kergon wrote:
>> On Fri, May 18, 2012 at 08:57:29AM -0700, Tejun Heo wrote:
>>> Please explain why this is done and how it's safe.  Alasdair / dm
>>> folks, can you please ack this?
>>  
>> I think it's relying on there being never more than one reference on those 
>> bios so that that endio fn, called exactly once, always frees it and there
>> are no dm_puts elsewhere.
> 
> Is that a safe assumption? From my perusal of the code it certainly
> looks like it should be, but I don't know dm all that well.

Doing free_bio_info() in end_clone_bio() is safe.

But there is other problem.
This bio may be put by blk_rq_unprep_clone() and leak memory
without the destructor.

So could it be possible to keep bi_destructor available for this case?

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation
