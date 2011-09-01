From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH] multipath: strdup multipath alias,
	so that	it isn't deleted.
Date: Thu, 1 Sep 2011 13:30:20 -0500
Message-ID: <20110901183020.GK11793@ether.msp.redhat.com>
References: <20110725182700.GK15149@ether.msp.redhat.com>
	<20110901024542.GA11793@ether.msp.redhat.com>
	<1314860118.14056.78.camel@lapoo.opensvc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1314860118.14056.78.camel@lapoo.opensvc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@opensvc.com
Cc: device-mapper development <dm-devel@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On Thu, Sep 01, 2011 at 08:55:18AM +0200, Christophe Varoqui wrote:
> On mer., 2011-08-31 at 21:45 -0500, Benjamin Marzinski wrote:
> > When a multipath device is added to multipathd with ev_add_map(),
> > > the alias is not duplicated, and is freed immediately after
> > ev_add_map()
> > > returns, causing a memory error. This patch corrects that.
> > > 
> Merged.
> 
> Do you think the "mpp->alias = NULL" is still necessary in the following
> setup_multipath() error code path ? alias is set to NULL by
> free_multipath() these days ...
> 

Yeah, that looks like it can safely go.

-Ben

> >       if (setup_multipath(vecs, mpp)) {
> >               mpp->alias = NULL;                <========
