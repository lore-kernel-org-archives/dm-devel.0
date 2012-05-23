From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [dm-devel] [Bcache v13 09/16] Bcache: generic utility code
Date: Wed, 23 May 2012 11:15:38 -0400
Message-ID: <20120523151538.GJ14943@redhat.com>
References: <cover.1336619038.git.koverstreet@google.com>
 <c3f0ca2a499f532253d4c16a30837d43e237266a.1336619038.git.koverstreet@google.com>
 <20120522211706.GH14339@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120522211706.GH14339-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tejun-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

On Tue, May 22, 2012 at 02:17:06PM -0700, Tejun Heo wrote:
> Hello, Kent.
> 
> I've been reading the code and am still very far from understanding
> the whole thing but here are general impressions upto this point.
> 
> * I started reading from get_bucket(), mostly because I wasn't sure
>   where to start.  It would be very helpful to the reviewers and
>   future participants if there's a design doc and more comments (much
>   more).  The code is on the big side and the problem is exacerbated
>   by use of somewhat unconventional constructs and conventions and
>   lack of documentation and comments.

I totally agreed. There is a lot going on and design doc is going to 
help a lot while reviewing.

> * Too many smart macros.  Macros suck.  Smart ones double suck.

I had the same impression when I tried to read the code last. Too many
macros and it makes reading code really difficult.

[..]
> * Somewhat related to the above, I'm not a fan of super-verbose
>   symbols but I *hope* that the variable names were just a tiny bit
>   more descriptive.  At least, the ones used as arguments.

Another thing is that keep variable names consistent. Last time I looked,
same name "c" was being used to represent cached_dev or cache_set or 
something else too. If we keep variable name same to represent same
data structure, it becomes easier to read the code. I was totally lost
and always had to go back to figure out what "c" is representing, what
"d" is representing etc.

Thanks
Vivek
