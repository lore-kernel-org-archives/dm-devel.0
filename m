From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [Bcache v13 09/16] Bcache: generic utility code
Date: Tue, 22 May 2012 20:36:30 -0700
Message-ID: <1337744190.13111.33.camel@joe2Laptop>
References: <cover.1336619038.git.koverstreet@google.com>
	 <c3f0ca2a499f532253d4c16a30837d43e237266a.1336619038.git.koverstreet@google.com>
	 <20120522211706.GH14339@google.com>
	 <20120523031214.GA607@dhcp-172-18-216-138.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120523031214.GA607-RcKxWJ4Cfj3IzGYXcIpNmNLIRw13R84JkQQo+JxHRPFibQn6LdNjmg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tejun-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

On Tue, 2012-05-22 at 23:12 -0400, Kent Overstreet wrote:
> On Tue, May 22, 2012 at 02:17:06PM -0700, Tejun Heo wrote:
[]
> > > +ssize_t hprint(char *buf, int64_t v)
> > > +{
> > > +	static const char units[] = "?kMGTPEZY";
> > > +	char dec[3] = "";
> > > +	int u, t = 0;
> > > +
> > > +	for (u = 0; v >= 1024 || v <= -1024; u++) {
> > > +		t = v & ~(~0 << 10);
> > > +		v >>= 10;
> > > +	}
> > > +
> > > +	if (!u)
> > > +		return sprintf(buf, "%llu", v);
> > > +
> > > +	if (v < 100 && v > -100)
> > > +		sprintf(dec, ".%i", t / 100);
> > > +
> > > +	return sprintf(buf, "%lli%s%c", v, dec, units[u]);
> > > +}
> > > +EXPORT_SYMBOL_GPL(hprint);
> > 
> > Not your fault but maybe we want integer vsnprintf modifier for this.
> 
> Yes.

or maybe yet another lib/vsprintf pointer extension
like %pD with some descriptors after the %pD for
type, width and precision.
