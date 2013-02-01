From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Bcache upstreaming
Date: Fri, 1 Feb 2013 08:08:20 -0800
Message-ID: <20130201160820.GA31863@mtj.dyndns.org>
References: <CAC7rs0ue6YgqrX9Nc18GdnVtJd558F6W=BZiMXZdRqig3s7sBA@mail.gmail.com>
 <20130131230800.GB13540@redhat.com>
 <20130201003311.GJ12631@moria.home.lan>
 <20130201033810.GA14867@redhat.com>
 <20130201103944.GM8837@soda.linbit>
 <20130201141003.GA18095@redhat.com>
 <20130201145504.GS6824@mtj.dyndns.org>
 <20130201152743.GV26407@google.com>
 <20130201153019.GT6824@mtj.dyndns.org>
 <20130201153318.GW26407@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130201153318.GW26407-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: dm-devel.ids

Hey,

On Fri, Feb 01, 2013 at 07:33:18AM -0800, Kent Overstreet wrote:
> Could add a new, fixed version that doesn't do the refcounting, bcache
> and I imagine md could use that right away (maybe even just split the
> refcounting out into different functions and have dm call those
> directly, probably an easy way to refactor it anyways)

I don't know.  We then would have two interfaces doing about the same
thing and a flag indicating whether the new or old one was used to
create the link so that exclusive close can decide to remove it or
not, which seems a bit complicated.  Let's see whether Mike can remove
the weirdness from dm side.

Thanks.

-- 
tejun
