From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH for-3.14 07/20] dm thin: use bool rather than
 unsigned for flags in structures
Date: Mon, 6 Jan 2014 14:27:33 +0000
Message-ID: <20140106142732.GF6766@debian>
References: <1387582653-13647-1-git-send-email-snitzer@redhat.com>
	<1387582653-13647-8-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1387582653-13647-8-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Dec 20, 2013 at 06:37:20PM -0500, Mike Snitzer wrote:
> Also, move 'err' member in dm_thin_new_mapping structure to eliminate 4
> byte hole (reduces size from 88 bytes to 80).

ACK.  But ...

> @@ -766,6 +766,10 @@ static struct dm_thin_new_mapping *get_next_mapping(struct pool *pool)
>  
>  	memset(m, 0, sizeof(struct dm_thin_new_mapping));
>  	INIT_LIST_HEAD(&m->list);
> +	m->quiesced = false;
> +	m->prepared = false;
> +	m->pass_discard = false;
> +	m->definitely_not_shared = false;
>  	m->bio = NULL;

... this is redundant.
