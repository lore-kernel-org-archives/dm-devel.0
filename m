From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [Bcache v13 09/16] Bcache: generic utility code
Date: Thu, 10 May 2012 12:35:25 -0700
Message-ID: <CAA9_cmcT0Jiz8pfj2MS+Sv55DqLrMMd=GaPMopRDCObiO5+waQ@mail.gmail.com>
References: <cover.1336619038.git.koverstreet@google.com>
	<c3f0ca2a499f532253d4c16a30837d43e237266a.1336619038.git.koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <c3f0ca2a499f532253d4c16a30837d43e237266a.1336619038.git.koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tejun-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

On Wed, May 9, 2012 at 8:10 PM, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org=
> wrote:
> Much of this code should be moved out of drivers/block/bcache, but it
> was originally written for bcache.
>
> Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---

[..]
> +#include <linux/dynamic_fault.h>
[..]
> +#define bio_alloc_pages(...) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
> + =A0 =A0 =A0 (dynamic_fault() ? -ENOMEM =A0 =A0 =A0: bio_alloc_pages=
(__VA_ARGS__))
> +

=2E..these missed the removal of the dynamic_fault bits.
