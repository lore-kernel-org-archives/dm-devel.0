From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Bcache upstreaming
Date: Fri, 1 Feb 2013 07:33:18 -0800
Message-ID: <20130201153318.GW26407@google.com>
References: <20130131221711.GA13540@redhat.com>
 <CAC7rs0ue6YgqrX9Nc18GdnVtJd558F6W=BZiMXZdRqig3s7sBA@mail.gmail.com>
 <20130131230800.GB13540@redhat.com>
 <20130201003311.GJ12631@moria.home.lan>
 <20130201033810.GA14867@redhat.com>
 <20130201103944.GM8837@soda.linbit>
 <20130201141003.GA18095@redhat.com>
 <20130201145504.GS6824@mtj.dyndns.org>
 <20130201152743.GV26407@google.com>
 <20130201153019.GT6824@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130201153019.GT6824-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: dm-devel.ids

On Fri, Feb 01, 2013 at 07:30:19AM -0800, Tejun Heo wrote:
> On Fri, Feb 01, 2013 at 07:27:43AM -0800, Kent Overstreet wrote:
> > > > Kent was talking about using MD (and though he isn't opposed to DM he
> > > > doesn't care to integrate with DM himself).  Either DM or MD would
> > > > implicitly enable bcache to use this interface.  But in the near-term I
> > > > cannot see why Kent shouldn't be able to use bd_link_disk_holder too.
> > > 
> > > Being part of dm or dm should make this mostly irrelevant, no?
> > 
> > Yeah, but who knows when that'll actually happen and since this is for
> > userspace I'm just going to call it. The refcounting won't affect me,
> > and using it in bcache won't affect ripping that out.
> 
> Yeah, I don't see any problem regarding user-visible behavior.  Please
> go ahead.  It's just gross internally and I wanted someone to do
> something about it before spreading its misuse (depending on the
> refs).

Could add a new, fixed version that doesn't do the refcounting, bcache
and I imagine md could use that right away (maybe even just split the
refcounting out into different functions and have dm call those
directly, probably an easy way to refactor it anyways)
