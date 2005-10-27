From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: User friendly names patch.
Date: Wed, 26 Oct 2005 21:14:18 -0500
Message-ID: <20051027021417.GC31187@phlogiston.msp.redhat.com>
References: <20051021233521.GA32160@phlogiston.msp.redhat.com>
	<1129967524.7313.65.camel@zezette>
	<20051024164902.GB19176@phlogiston.msp.redhat.com>
	<20051025084121.GA17494@free.fr>
	<20051025191749.GL19176@phlogiston.msp.redhat.com>
	<1130269061.13850.26.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1130269061.13850.26.camel@zezette>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@free.fr, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Oct 25, 2005 at 09:37:41PM +0200, Christophe Varoqui wrote:
> 
> > How about I make the bindings file location configurable, so that everyone
> > can be happy with the location? I'll leave the default location where it
> > is now when I send the patch.  If you would like to change it to someplace in
> > /etc when you commit it, go ahead.
> > 
> Agreed, I guess we can get off with a multipath(8) flag to specify an
> exotic location in the init{rd,ramfs} and leave the normal location
> in /var.
> 
> I merged the patch as-is today.
> 
> Can you craft a patch to move the bindings file locking method from
> "non-block + retry" to "block + timeout", if it makes sense to you too.

Sure. Here is the patch. It adds both the -b <bindings_file_path> option to
the multipath command, and changes the locking method.

-Ben
 
> Regards,
> cvaroqui
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
