From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: fix uninitialized variable reference
Date: Mon, 11 Dec 2017 08:50:16 -0500
Message-ID: <20171211135015.GA22786@redhat.com>
References: <20171211113358.3599287-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171211113358.3599287-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.com>, Bart Van Assche <bart.vanassche@wdc.com>, NeilBrown <neilb@suse.com>, Mikulas Patocka <mpatocka@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Damien Le Moal <damien.lemoal@wdc.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Dec 11 2017 at  6:33am -0500,
Arnd Bergmann <arnd@arndb.de> wrote:

> The last bugfix apparently introduced another problem, as shown
> by this gcc warning:
> 
> drivers/md/dm.c: In function '__send_changing_extent_only':
> drivers/md/dm.c:1365:28: error: 'ti' is used uninitialized in this function [-Werror=uninitialized]
> 
> This restores the intialization of the 'ti' variable.
> 
> Fixes: aecefd4919de ("dm: fix __send_changing_extent_only() to send first bio and chain remainder")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> I did not test this or give the patch much thought, this just seemed
> to be the most likely fix I could come up with in a short time, so
> please review carefully, and ignore if the solution is something
> else.
> ---
>  drivers/md/dm.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 05aa9c094352..f19e9787076e 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1356,6 +1356,10 @@ static int __send_changing_extent_only(struct clone_info *ci,
>  	unsigned len;
>  	unsigned num_bios;
>  
> +	ti = dm_table_find_target(ci->map, ci->sector);
> +	if (!dm_target_is_valid(ti))
> +		return -EIO;
> +
>  	/*
>  	 * Even though the device advertised support for this type of
>  	 * request, that does not mean every target supports it, and
> -- 
> 2.9.0
> 

Already resolved this thanks to Stephen Rothwell's earlier
(substantially more discrete) mail.

I always enjoy a good public shaming but this cc list is particularly
wide.  Why?

Anyway, I resolved this differently:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.16&id=496cc64f4d10ba112aa0679a3bf29ae6ea74ff3d
