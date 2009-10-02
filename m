From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 0/8] SECURITY ISSUE with connector
Date: Fri, 2 Oct 2009 06:58:59 -0700
Message-ID: <20091002135859.GA9383@kroah.com>
References: <1254487211-11810-1-git-send-email-philipp.reisner@linbit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1254487211-11810-1-git-send-email-philipp.reisner@linbit.com>
Sender: netdev-owner@vger.kernel.org
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, dm-devel@redhat.com, Evgeniy Polyakov <zbr@ioremap.net>, linux-fbdev-devel@lists.sourceforge.net
List-Id: dm-devel.ids

On Fri, Oct 02, 2009 at 02:40:03PM +0200, Philipp Reisner wrote:
> Affected: All code that uses connector, in kernel and out of mainline
> 
> The connector, as it is today, does not allow the in kernel receiving
> parts to do any checks on privileges of a message's sender.

So, assume I know nothing about the connector architecture, what does
this mean in a security context?

> I know, there are not many out there that like connector, but as
> long as it is in the kernel, we have to fix the security issues it has!

And what specifically are the security issues?

> Please either drop connector, or someone who feels a bit responsible
> and has our beloved dictator's blessing, PLEASE PLEASE PLEASE take 
> this into your tree, and send the pull request to Linus.
> 
> Patches 1 to 4 are already Acked-by Evgeny, the connector's maintainer.
> Patches 5 to 7 are the obvious fixes to the connector user's code.

Obvious in what way?

thanks,

greg k-h
