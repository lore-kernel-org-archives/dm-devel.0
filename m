From: "Jun'ichi Nomura" <j-nomura-JhyGz2TFV9J8UrSeD/g0lQ@public.gmane.org>
Subject: Re: [dm-devel] [PATCH v2 02/14] dm: kill dm_rq_bio_destructor
Date: Thu, 24 May 2012 10:16:09 +0900
Message-ID: <4FBD8BD9.8070708@ce.jp.nec.com>
References: <1337817771-25038-1-git-send-email-koverstreet@google.com> <1337817771-25038-3-git-send-email-koverstreet@google.com> <4FBD7E80.4020005@ce.jp.nec.com> <20120524003915.GA27443@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120524003915.GA27443-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: dm-devel.ids

On 05/24/12 09:39, Kent Overstreet wrote:
> On Thu, May 24, 2012 at 09:19:12AM +0900, Jun'ichi Nomura wrote:
>> The destructor may also be called from blk_rq_unprep_clone(),
>> which just puts bio.
>> So this patch will introduce a memory leak.
> 
> Well, keeping around bi_destructor solely for that reason would be
> pretty lousy. Can you come up with a better solution?

I don't have good one but here are some ideas:
  a) Do bio_endio() rather than bio_put() in blk_rq_unprep_clone()
     and let bi_end_io reap additional data.
     It looks ugly.
  b) Separate the constructor from blk_rq_prep_clone().
     dm has to do rq_for_each_bio loop again for constructor.
     Possible performance impact.
  c) Open code blk_rq_prep/unprep_clone() in dm.
     It exposes unnecessary block-internals to dm.
  d) Pass destructor function to blk_rq_prep/unprep_clone()
     for them to callback.

Umm, is "d)" better?
-- 
Jun'ichi Nomura, NEC Corporation
