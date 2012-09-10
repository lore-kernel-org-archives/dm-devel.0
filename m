From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] block: Avoid deadlocks with bio allocation by
 stacking drivers
Date: Mon, 10 Sep 2012 14:37:10 -0700
Message-ID: <20120910213710.GA7677@google.com>
References: <1347055973-11581-1-git-send-email-koverstreet@google.com>
 <1347055973-11581-3-git-send-email-koverstreet@google.com>
 <20120908193641.GB12773@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120910002810.GA23241@moria.home.lan>
 <20120910172210.GC14103@google.com>
 <20120910202435.GG16360@google.com>
 <20120910204010.GA32310@google.com>
 <20120910213349.GH16360@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120910213349.GH16360-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
List-Id: dm-devel.ids

On Mon, Sep 10, 2012 at 02:33:49PM -0700, Kent Overstreet wrote:
> "Simpler" isn't really an objective thing though. To me the goto version
> is more obvious/idiomatic.
> 
> Eh. I'll do it your way, but consider this a formal objection :p

Thanks. :)

-- 
tejun
