From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] md: dm-verity: Fix to avoid a deadlock in dm-bufio
Date: Mon, 4 Mar 2013 17:42:54 +0000
Message-ID: <20130304174254.GF8913@agk.fab.redhat.com>
References: <1362415549-18653-1-git-send-email-taysom@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1362415549-18653-1-git-send-email-taysom@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Taysom <taysom@chromium.org>
Cc: agk@redhat.com, dm-devel@redhat.com, neilb@suse.de, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, msb@chromium.org, mpatocka@redhat.com, olofj@chromium.org
List-Id: dm-devel.ids

On Mon, Mar 04, 2013 at 08:45:48AM -0800, Paul Taysom wrote:
> @@ -449,8 +468,14 @@ static void verity_prefetch_io(struct dm_verity *v, struct dm_verity_io *io)
>  				hash_block_end = v->hash_blocks - 1;
>  		}
>  no_prefetch_cluster:
> -		dm_bufio_prefetch(v->bufio, hash_block_start,
> -				  hash_block_end - hash_block_start + 1);
> +		vw = kmalloc(sizeof(*vw), GFP_KERNEL);

kmalloc?  mempool? ...

Alasdair
