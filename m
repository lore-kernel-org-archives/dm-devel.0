From: Andrew Morton <akpm@osdl.org>
Subject: Re: [patch] [2.6.12-rc6-mm1] Handle READA requests in
	dm-mpath.c
Date: Wed, 8 Jun 2005 04:33:47 -0700
Message-ID: <20050608043347.5db85317.akpm@osdl.org>
References: <20050608110436.GQ27119@marowsky-bree.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050608110436.GQ27119@marowsky-bree.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids

Lars Marowsky-Bree <lmb@suse.de> wrote:
>
> READA errors failing with EWOULDBLOCK/EAGAIN do not constitute a valid
> reason for failing the path; this lead to erratic errors on DM multipath
> devices. This error can be safely propagated upwards without failing the
> path.
> 

Why do you describe this as a -mm patch?  We want this in 2.6.12, no?

> --- linux-2.6.12-rc6-mm1.orig/drivers/md/dm-mpath.c	2005-06-08 12:51:02.741055000 +0200
> +++ linux-2.6.12-rc6-mm1/drivers/md/dm-mpath.c	2005-06-08 12:57:55.757828867 +0200
> @@ -985,6 +985,9 @@
>  	if (!error)
>  		return 0;	/* I/O complete */
>  
> +	if ((error == -EWOULDBLOCK) && bio_rw_ahead(bio))
> +		return error;
> +
>  	spin_lock(&m->lock);
>  	if (!m->nr_valid_paths) {
>  		if (!m->queue_if_no_path || m->suspended) {
> 
> 
> -- 
> High Availability & Clustering
> SUSE Labs, Research and Development
> SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
> "Ignorance more frequently begets confidence than does knowledge"
