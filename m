From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] Add human-readable units modifier to vsnprintf()
Date: Tue, 22 May 2012 22:42:40 -0700
Message-ID: <1337751760.13111.47.camel@joe2Laptop>
References: <cover.1336619038.git.koverstreet@google.com>
	 <c3f0ca2a499f532253d4c16a30837d43e237266a.1336619038.git.koverstreet@google.com>
	 <20120522211706.GH14339@google.com>
	 <20120523031214.GA607@dhcp-172-18-216-138.mtv.corp.google.com>
	 <1337744190.13111.33.camel@joe2Laptop>
	 <20120523045023.GE607@dhcp-172-18-216-138.mtv.corp.google.com>
	 <1337749848.13111.40.camel@joe2Laptop>
	 <20120523052236.GA14312@dhcp-172-18-216-138.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120523052236.GA14312-RcKxWJ4Cfj3IzGYXcIpNmNLIRw13R84JkQQo+JxHRPFibQn6LdNjmg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tejun-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

On Wed, 2012-05-23 at 01:22 -0400, Kent Overstreet wrote:
> On Tue, May 22, 2012 at 10:10:48PM -0700, Joe Perches wrote:
> > On Wed, 2012-05-23 at 00:50 -0400, Kent Overstreet wrote:
> > > diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> > []
> > > @@ -1002,6 +1023,7 @@ int format_decode(const char *fmt, struct printf_spec *spec)
> > >  		case ' ': spec->flags |= SPACE;   break;
> > >  		case '#': spec->flags |= SPECIAL; break;
> > >  		case '0': spec->flags |= ZEROPAD; break;
> > > +		case 'h': spec->flags |= HUNITS;  break;
> > >  		default:  found = false;
> > >  		}
> > >  
> > 
> > I think that doesn't work well because
> > gcc __attribute__((format(printf, x, y)))
> > verification fails.
> 
> Yeah, I already ran into that. I was looking through the gcc docs to see
> if there was a way to add modifiers (how is it done for the other kernel
> specific format strings?) but I haven't found anything yet

It's done via %p extensions.
gcc doesn't care as long as the %p argument is a pointer.

> > It's also possible
> > to confuse it with printf's own 'h' / 
> > integer precision use.
> 
> Well, that's annoying. Any suggestions?

I gave you one already.

Use a new lib/vsprintf.c %p pointer extension like 
"%pD" or "%pH" and use a pointer to the type as the
argument.

It's how it's done for an ipv4 address.
For instance:
	be32 address = cpu_to_be32(0xc0a80101);
	printk("%pI4" &address);
emits "192.168.1.1"
