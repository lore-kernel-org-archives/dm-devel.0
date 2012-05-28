From: "Jun'ichi Nomura" <j-nomura-JhyGz2TFV9J8UrSeD/g0lQ@public.gmane.org>
Subject: Re: [dm-devel] [PATCH v3 02/16] dm: Use bioset's front_pad for dm_rq_clone_bio_info
Date: Mon, 28 May 2012 20:41:18 +0900
Message-ID: <4FC3645E.8040901@ce.jp.nec.com>
References: <1337977539-16977-1-git-send-email-koverstreet@google.com> <1337977539-16977-3-git-send-email-koverstreet@google.com> <4FC2CD93.1080009@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FC2CD93.1080009-JhyGz2TFV9J8UrSeD/g0lQ@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org
List-Id: dm-devel.ids

On 05/28/12 09:57, Jun'ichi Nomura wrote:
> On 05/26/12 05:25, Kent Overstreet wrote:
>> -	pools->bs = bioset_create(pool_size, 0);
>> +	pools->bs = bioset_create(pool_size,
>> +				  offsetof(struct dm_rq_clone_bio_info, orig));
>>  	if (!pools->bs)
>>  		goto free_tio_pool_and_out;
> 
> Did you mean offset of *clone*?
> "offsetof(struct dm_rq_clone_bio_info, orig)" is zero.

Additional comment:
frontpad is not necessary if type is DM_TYPE_BIO_BASED.
Please check conditional switches done in the same function for
pools->tio_pool.

-- 
Jun'ichi Nomura, NEC Corporation
