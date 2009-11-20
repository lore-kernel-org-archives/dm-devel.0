From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH v9] dm snapshot: allow live exception store
	handover between tables
Date: Fri, 20 Nov 2009 13:00:15 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0911201257140.2777@hs20-bc2-1.build.redhat.com>
References: <1258652608-13646-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1258652608-13646-1-git-send-email-snitzer@redhat.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids



On Thu, 19 Nov 2009, Mike Snitzer wrote:

> Permit in-use snapshot exception data to be 'handed over' from one
> snapshot instance to another.  This is a pre-requisite for patches
> that allow the changes made in a snapshot device to be merged back into
> its origin device and also allows device resizing.
> 
> The basic call sequence is:
> 
>   dmsetup load new_snapshot (referencing the existing in-use cow device)
>      - the ctr code detects that the cow is already in use and allows the
>        two snapshot target instances to be linked together
>   dmsetup suspend original_snapshot
>   dmsetup resume new_snapshot
>      - the new_snapshot becomes live, and if anything now tries to access
>        the original one it will receive -EIO
>   dmsetup remove original_snapshot
> 
> (There can only be two snapshot targets referencing the same cow device
> simultaneously.)
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Acked-by: Mikulas Patocka <mpatocka@redhat.com>

> +	down_read(&_origins_lock);
> +	(void) __find_snapshots_sharing_cow(s, &snap_src, &snap_dest);
> +	if (snap_src && snap_dest) {
> +		down_write_nested(&snap_src->lock, SINGLE_DEPTH_NESTING);
> +		down_write(&snap_dest->lock);

I'd suggest to use the "_nested" version for the nested lock, it is a 
convention.

down_write(&snap_src->lock);
down_write_nested(&snap_dest->lock, SINGLE_DEPTH_NESTING);

Mikulas

> +		__handover_exceptions(snap_src, snap_dest);
> +		up_write(&snap_dest->lock);
> +		up_write(&snap_src->lock);
> +	}
> +	up_read(&_origins_lock);
