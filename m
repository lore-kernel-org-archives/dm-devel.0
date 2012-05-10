From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Bcache v13 11/16] bcache: Core btree code
Date: Thu, 10 May 2012 14:48:49 -0700
Message-ID: <CAH+dOxLfFScjKP8XEyQjAKwqGz4zGzASi15wEoXOgvXCqaSsCQ@mail.gmail.com>
References: <cover.1336619038.git.koverstreet@google.com>
	<1188908028.170.1336674698865.JavaMail.mail@webmail09>
	<1336675787.22495.29.camel@joe2Laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1336675787.22495.29.camel@joe2Laptop>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tejun-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

I don't feel strongly one way or the other about it, but I do think
it's more just a matter of taste - the if (0) is ugly, I'll certainly
grant you that but IMO it makes the weird control flow harder to miss,
and the indentation more or less matches the control flow.

But I haven't come up with a way of writing that I actually like, I
dislike them all almost equally.

On Thu, May 10, 2012 at 11:49 AM, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org> wrote:
> On Wed, 2012-05-09 at 23:10 -0400, Kent Overstreet wrote:
>> Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> []
>> +
>> +void btree_read_done(struct closure *cl)
>> +{
> []
>> + =A0 =A0 if (b->written < btree_blocks(b))
>> + =A0 =A0 =A0 =A0 =A0 =A0 bset_init_next(b);
>> +
>> + =A0 =A0 if (0) {
>> +err: =A0 =A0 =A0 =A0 set_btree_node_io_error(b);
>> + =A0 =A0 =A0 =A0 =A0 =A0 cache_set_error(b->c, "%s at bucket %lu, b=
lock %zu, %u keys",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err, PTR_B=
UCKET_NR(b->c, &b->key, 0),
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 index(i, b=
), i->keys);
>> + =A0 =A0 }
>
> Hi Kent
>
> trivia: =A0This if (0) is an exceedingly ugly style.
>
> I'd much prefer:
>
> =A0 =A0 =A0 =A0if (foo)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bar();
>
> =A0 =A0 =A0 =A0goto exit;
>
> err:
> =A0 =A0 =A0 =A0set_btree_node_io_error(b);
> =A0 =A0 =A0 =A0cache_set_error(b->c, "%s at bucket %lu, block %zu, %u=
 keys",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err, PTR_BUCKET_NR(b->=
c, &b->key, 0),
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0index(i, b), i->keys);
>
> exit:
> =A0 =A0 =A0 =A0etc...
>
>
