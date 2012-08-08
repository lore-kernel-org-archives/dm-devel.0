From: Muthu Kumar <muthu.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [dm-devel] [PATCH v5 12/12] block: Only clone bio vecs that are
 in use
Date: Wed, 8 Aug 2012 16:47:46 -0700
Message-ID: <CAFR8uedZiG0NWgWQQa03r+kKh8rT0jzpj+hwPzq+i7K6zhpT_A@mail.gmail.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
	<1344290921-25154-13-git-send-email-koverstreet@google.com>
	<Pine.LNX.4.64.1208061913500.21956@file.rdu.redhat.com>
	<20120808232804.GL6983@dhcp-172-17-108-109.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120808232804.GL6983-RcKxWJ4Cfj1J2suj2OqeGauc2jM2gXBXkQQo+JxHRPFibQn6LdNjmg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: dm-devel.ids

Tejun,

This is changing the semantics of the clone. Sorry, I missed this
thread and replied separately. But anyway, replying it again here:


On Wed, Aug 8, 2012 at 4:28 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Mon, Aug 06, 2012 at 07:16:33PM -0400, Mikulas Patocka wrote:
>> Hi Kent
>>
>> When you change the semantics of an exported function, rename that
>> function. There may be external modules that use __bio_clone and this
>> change could silently introduce bugs in them.
>>
>> Otherwise, the patchset looks fine.
>
> I don't know.  This doesn't change the main functionality and should
> be transparent unless the caller is doing something crazy.  It *might*
> be nice to rename but I don't think that's a must here.
>
> Thanks.

--
You are changing the meaning of __bio_clone() here. In old code, the
number of io_vecs, bi_idx, bi_vcnt are preserved. But in this modified
code, you are mapping bio_src's bi_iovec[bi_idx] to bio_dests
bi_iovec[0] and also restricting the number of allocated io_vecs of
the clone. It may be useful for cases were we would like a identical
copy of the original bio (may not be in current code base, but this
implementation is definitely not what one would expect from the name
"clone").

May be, call this new implementation some thing else (and use it for bcache)?

---

Like Mikulas pointed out, this is an exported function and silently
changing the semantics will break external modules.

Regards,
Muthu


>
> --
> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
