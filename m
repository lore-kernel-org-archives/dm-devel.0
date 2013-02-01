From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Bcache upstreaming
Date: Fri, 1 Feb 2013 08:18:09 -0800
Message-ID: <20130201161809.GB31863@mtj.dyndns.org>
References: <20130201003311.GJ12631@moria.home.lan>
 <20130201033810.GA14867@redhat.com>
 <20130201103944.GM8837@soda.linbit>
 <20130201141003.GA18095@redhat.com>
 <20130201145504.GS6824@mtj.dyndns.org>
 <20130201152743.GV26407@google.com>
 <20130201153019.GT6824@mtj.dyndns.org>
 <20130201153318.GW26407@google.com>
 <20130201160820.GA31863@mtj.dyndns.org>
 <20130201161547.GY26407@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130201161547.GY26407-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: dm-devel.ids

Hello, Kent.

On Fri, Feb 01, 2013 at 08:15:47AM -0800, Kent Overstreet wrote:
> Eww, not a flag. I meant a completely separate functions, rip out the
> refcounting entirely and have the refcounting-manipulating versions
> available as

No, I mean, internally there needs to be a way whether the currently
existing linkage is from the old or new interface for exclusive close
to be able to decide whether it can remove it or not.  Anyways, let's
wait for Mike for now.

Thanks.

-- 
tejun
