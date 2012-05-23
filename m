From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [dm-devel] [Bcache v13 09/16] Bcache: generic utility code
Date: Wed, 23 May 2012 11:33:30 -0400
Message-ID: <CAH+dOx+DhSweOvZZv3dVcedeBBZZ0=zondmKTDzMVXPdWZr=JA@mail.gmail.com>
References: <cover.1336619038.git.koverstreet@google.com>
	<c3f0ca2a499f532253d4c16a30837d43e237266a.1336619038.git.koverstreet@google.com>
	<20120522211706.GH14339@google.com>
	<20120523151538.GJ14943@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120523151538.GJ14943-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tejun-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

On Wed, May 23, 2012 at 11:15 AM, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Another thing is that keep variable names consistent. Last time I looked,
> same name "c" was being used to represent cached_dev or cache_set or
> something else too. If we keep variable name same to represent same
> data structure, it becomes easier to read the code. I was totally lost
> and always had to go back to figure out what "c" is representing, what
> "d" is representing etc.

Yeah, those examples are both cases where the struct was split -
struct cache was broken into struct cache and cache_set, struct
bcache_device was split off from cached_dev.

I've been fixing things as I go along, but probably I should just do
them all at once and be done with it, damn the code churn.
