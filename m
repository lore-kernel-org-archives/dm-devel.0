From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: User friendly names patch.
Date: Thu, 27 Oct 2005 09:51:40 +0200
Message-ID: <20051027075140.GB19754@free.fr>
References: <20051021233521.GA32160@phlogiston.msp.redhat.com>
	<1129967524.7313.65.camel@zezette>
	<20051024164902.GB19176@phlogiston.msp.redhat.com>
	<20051025084121.GA17494@free.fr>
	<20051025191749.GL19176@phlogiston.msp.redhat.com>
	<1130269061.13850.26.camel@zezette>
	<20051027021417.GC31187@phlogiston.msp.redhat.com>
	<20051027022008.GA5541@phlogiston.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20051027022008.GA5541@phlogiston.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

> > > Can you craft a patch to move the bindings file locking method from
> > > "non-block + retry" to "block + timeout", if it makes sense to you too.
> > 
> > Sure. Here is the patch. It adds both the -b <bindings_file_path> option to
> > the multipath command, and changes the locking method.
> > 
> 
> It's just one of those weeks.
> 
Applied, thanks.

Regards,
cvaroqui
