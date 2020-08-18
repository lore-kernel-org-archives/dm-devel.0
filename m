From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 76/80] libmultipath: select_action():
 force udev reload for uninitialized maps
Date: Tue, 18 Aug 2020 09:37:00 +0200
Message-ID: <3f3a9bf677107e868f8935db7e82fc39b916a272.camel@suse.com>
References: <20200812113543.26576-1-mwilck@suse.com>
	<20200812113543.26576-2-mwilck@suse.com>
	<20200817213105.GH19233@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200817213105.GH19233@octiron.msp.redhat.com>
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

On Mon, 2020-08-17 at 16:31 -0500, Benjamin Marzinski wrote:
> On Wed, Aug 12, 2020 at 01:35:40PM +0200, mwilck@suse.com wrote:
> > From: Martin Wilck <mwilck@suse.com>
> > 
> > If we are in the reconfigure() code path, and we encounter maps to
> > be reloaded, we usually set the DM_SUBSYSTEM_UDEV_FLAG0 flag to
> > tell
> > udev not to repeat device detection steps above the multipath
> > layer.
> > However, if the map was previously uninitialized, we have to force
> > udev to reload.
> 
> Actually, this patch looks all broken now. select_reload_action()
> doesn't have a cmpp argument, but still has
> 
> mpp_ud = get_udev_for_mpp(cmpp);
> 
> Also, it's setting the action on cmpp from select_action, not mpp.
> I'm
> pretty sure that the next patch makes everything work o.k. again.

Right. Thank you for reviewing and spotting it, and apologies for the
mistake.

Martin
