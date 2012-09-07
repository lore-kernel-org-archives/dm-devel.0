From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH v10 0/8] Block cleanups
Date: Thu, 06 Sep 2012 19:37:10 -0600
Message-ID: <50494FC6.3050502@kernel.dk>
References: <1346970902-10931-1-git-send-email-koverstreet@google.com> <20120906234805.GD9426@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120906234805.GD9426-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>
List-Id: dm-devel.ids

On 2012-09-06 17:48, Tejun Heo wrote:
> Hello, guys.
> 
> (cc'ing Jens, Alasdair and Neil)
> 
> On Thu, Sep 06, 2012 at 03:34:54PM -0700, Kent Overstreet wrote:
>> Screwed up the bio_reset() patch in the last patch series when I went to edit
>> the description, fixed that here.
>>
>> Only other change is the dm patch - made the front_pad conditional on
>> DM_TYPE_BIO_BASED.
>>
>> Kent Overstreet (8):
>>   block: Generalized bio pool freeing
>>   block: Ues bi_pool for bio_integrity_alloc()
>>   dm: Use bioset's front_pad for dm_rq_clone_bio_info
>>   block: Add bio_reset()
>>   pktcdvd: Switch to bio_kmalloc()
>>   block: Kill bi_destructor
>>   block: Consolidate bio_alloc_bioset(), bio_kmalloc()
>>   block: Add bio_clone_bioset(), bio_clone_kmalloc()
> 
> This series looks good to me now.  If someone can ack the dm patch, I
> think it's good to go.  Jens, what do you think?

Looks OK to me too. I'll run a quick perf test on this tomorrow, and get
it queued up for 3.7 if it looks fine.

Kent, are to resend 3+5 to me?

-- 
Jens Axboe
