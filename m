From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 64/74] multipathd: check_path(): set
 retrigger_delay if necessary
Date: Wed, 05 Aug 2020 18:37:35 +0200
Message-ID: <95eabfa37f3da63b27f9a68a693a9e44bba9b0d8.camel@suse.com>
References: <20200709105145.9211-1-mwilck@suse.com>
	<20200709105145.9211-12-mwilck@suse.com>
	<20200719050716.GW11089@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200719050716.GW11089@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Sun, 2020-07-19 at 00:07 -0500, Benjamin Marzinski wrote:
> On Thu, Jul 09, 2020 at 12:51:35PM +0200, mwilck@suse.com wrote:
> > From: Martin Wilck <mwilck@suse.com>
> > 
> > In a follow up patch, we will set INIT_MISSING_UDEV and set tick=1
> > (minimal) at the same time. In this case, which is new,
> > check_path()
> > must reset the delay when it first triggers an uevent.
> 
> Maybe I'm just being obtuse here, but I don't get what this does.
> pp->tick will always be 0 for any path that makes it to the check
> 
> if (!pp->mpp && pp->initialized == INIT_MISSING_UDEV) {
> 
> And then if it's not out of retries, the path will get set to
> INIT_REQUESTED_UDEV, and pathinfo() will take care of resetting pp-
> >tick
> when it gets called by the new uevent.
> 
> If it is out of retries, the path won't get pp->tick reset, which
> seems
> wrong, but it that case it should probably be set to max_checkint,
> like
> happens when the "add missing paths" code fails.
> 
> Or like I said, maybe I'm just missing something.

You're not. This was just plain stupid.

Thanks
Martin
