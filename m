From: Muthu Kumar <muthu.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [dm-devel] [PATCH v5 12/12] block: Only clone bio vecs that are
 in use
Date: Thu, 9 Aug 2012 18:50:59 -0700
Message-ID: <CAFR8uecQwi1HhcWbVfE_2L-3Z0duYPgSHryoJdrH09C-u6VbLg@mail.gmail.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
	<1344290921-25154-13-git-send-email-koverstreet@google.com>
	<Pine.LNX.4.64.1208061913500.21956@file.rdu.redhat.com>
	<20120808232804.GL6983@dhcp-172-17-108-109.mtv.corp.google.com>
	<CAFR8uedZiG0NWgWQQa03r+kKh8rT0jzpj+hwPzq+i7K6zhpT_A@mail.gmail.com>
	<20120809031936.GM7262@moria.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120809031936.GM7262-jC9Py7bek1znysI04z7BkA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: dm-devel.ids

Kent,

>> --
>> You are changing the meaning of __bio_clone() here. In old code, the
>> number of io_vecs, bi_idx, bi_vcnt are preserved. But in this modified
>> code, you are mapping bio_src's bi_iovec[bi_idx] to bio_dests
>> bi_iovec[0] and also restricting the number of allocated io_vecs of
>> the clone. It may be useful for cases were we would like a identical
>> copy of the original bio (may not be in current code base, but this
>> implementation is definitely not what one would expect from the name
>> "clone").
>
> The problem is that bio_clone() is used on bios that were not allocated
> or submitted by the cloning module.
>
> If some code somewher submits a bio that points to 500 pages, but by the
> time it gets to a driver it only points to 200 pages (say, because it
> was split), that clone should succeed; it shouldn't fail simply because
> it was trying to clone more than was necessary.
>


I would say, the code that submits bio with 500 pages is broken. It
needs to take care of underlying restrictions before submitting bios.
And that's one of the reason for having bio_add_page(), especially for
stackable modules.


> Bios have certain (poorly documented) semantics, and if this breaks
> anything it's probably because that code was doing something crazy in
> the first place.
>

Agree. But doing the above doesn't help in improving the situation,
just makes it even less clear.

Regards,
Muthu.


> In particular, if this change breaks anything then the new bio_split()
> _will_ break things.
>
> We need to be clear about our interfaces; in this case bi_idx and
> bi_vcnt, in particular. Either this is a safe change, or it's not. If
> no one knows... that's a bigger problem, and not just for this patch...
>
> Fortunately this code actually has been tested quite a bit (and the bio
> splitting code for even longer), and (somewhat to my surprise) I haven't
> run into any bugs caused by it.
