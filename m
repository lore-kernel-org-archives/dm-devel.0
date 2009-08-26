From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm snapshot: implement .iterate_devices
Date: Wed, 26 Aug 2009 15:50:45 +0100
Message-ID: <20090826145045.GH643@agk-dp.fab.redhat.com>
References: <1251007867-13004-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1251007867-13004-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Sun, Aug 23, 2009 at 02:11:07AM -0400, Mike Snitzer wrote:
> This patch implements .iterate_devices for the origin and snapshot
> targets.  dm-snapshot's lack of .iterate_devices resulted in the
> inability to properly establish queue_limits for both targets.  
> With 4K sector drives: an unfortunate side-effect of not establishing
> proper limits in either targets' DM device was that IO to the devices
> would fail even though both had been created without error.
> Commit af4874e03ed82f050d5872d8c39ce64bf16b5c38 should have implemented
> .iterate_devices for dm-snap.c's origin and snapshot targets.
 
> +static int snapshot_iterate_devices(struct dm_target *ti,
> +				    iterate_devices_callout_fn fn, void *data)
> +{
> +	struct dm_snapshot *snap = ti->private;
> +
> +	return fn(ti, snap->origin, 0, ti->len, data);
> +}

> +static int origin_iterate_devices(struct dm_target *ti,
> +				  iterate_devices_callout_fn fn, void *data)
> +{
> +	struct dm_dev *dev = ti->private;
> +
> +	return fn(ti, dev, 0, ti->len, data);
> +}

Why are these both seemingly the same?  Is one sufficient?
And where are the characteristics of the 'cow' device taken into account?

Alasdair
