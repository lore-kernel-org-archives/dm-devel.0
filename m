From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 02/11] libmultipath: copy mpp->hwe from
	pp->hwe
Date: Fri, 25 Sep 2020 18:01:26 +0200
Message-ID: <f3b7a133b11ef4088948c76706ea088d40817039.camel@suse.com>
References: <20200924133644.14034-1-mwilck@suse.com>
	<20200924133644.14034-3-mwilck@suse.com>
	<20200924201245.GH11108@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200924201245.GH11108@octiron.msp.redhat.com>
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

On Thu, 2020-09-24 at 15:12 -0500, Benjamin Marzinski wrote:
> On Thu, Sep 24, 2020 at 03:36:35PM +0200, mwilck@suse.com wrote:
> > From: Martin Wilck <mwilck@suse.com>
> > 
> > Since f0462f0 ("libmultipath: use vector for for pp->hwe and mp-
> > >hwe"),
> > we've been trying to fix issues caused by paths getting freed and
> > mpp->hwe
> > dangling. This approach couldn't work because we need mpp->hwe to
> > persist,
> > even if all paths are removed from the map. Before f0462f0, a
> > simple
> > assignment worked, because the lifetime of the hwe wasn't bound to
> > the
> > path. But now, we need to copy the vector. It turns out that we
> > need to set
> > mpp->hwe only in two places, add_map_with_path() and setup_map(),
> > and
> > that the code is simplified overall.
> 
> Unless I'm missing someting, it looks like
> __mpath_persistent_reserve_out() will call select_all_tg_pt(), which
> uses mpp->hwe, without ever setting it.  Granted, I don't see how
> this
> was supposed to work before your patch either.

Right, it doesn't. Thanks for spotting it.
Ok to create a new, separate patch for it?

Regards,
Martin
