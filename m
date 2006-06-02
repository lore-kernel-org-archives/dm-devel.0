From: Heinz Mauelshagen <mauelshagen@redhat.com>
Subject: Re: Maximum chunk size in dm-raid4-5.c
Date: Fri, 2 Jun 2006 08:07:56 +0200
Message-ID: <20060602060756.GA2202@redhat.com>
References: <447F8A36.30908@us.ibm.com>
Reply-To: mauelshagen@redhat.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <447F8A36.30908@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: device-mapper development <dm-devel@redhat.com>, Heinz Mauelshagen <mauelshagen@redhat.com>
List-Id: dm-devel.ids


Darrick,

this is to limit the size of the stripe cache, because the code allocates
"RAID devices * chunk_size memory * stripes". IOW: the chunk size defines the
io size.

Right now I'm working on seperating the chunk size from the io size
(i.e. the amount of memory allocated per device), which will give us
a way to optimize memory consumption for large chunk sizes and hence
the ability to have very large chunk sizes without stripe cache memory
preasure.

Regards,
Heinz

On Thu, Jun 01, 2006 at 05:45:42PM -0700, Darrick J. Wong wrote:
> Hi,
> 
> Is there a particular reason why CHUNK_SIZE_MAX is set to 512 sectors in
> the dm raid4/5 module?  I have a fakeraid controller that can create
> rather huge (1MB!) RAID5 stripes that this module rejects.  I set it to
> 2048 and as far as I can tell there haven't been any adverse stability
> effects, though I suspect that gigantic stripes do wonders for disk
> throughput. :P
> 
> Attached is a patch to increase it to 2048 sectors.  Please apply if
> it's ok.
> 
> --D
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> --- a/drivers/md/dm-raid4-5.c	2006-06-01 17:42:27.000000000 -0700
> +++ b/drivers/md/dm-raid4-5.c	2006-06-01 17:42:32.000000000 -0700
> @@ -70,7 +70,7 @@
>  #define	CHUNK_SIZE		64
> 
>  /* Maximum setable chunk size in sectors */
> -#define	CHUNK_SIZE_MAX		512
> +#define	CHUNK_SIZE_MAX		2048
> 
>  /* Recover chunk size in sectors */
>  #define	RECOVER_CHUNK_SIZE	CHUNK_SIZE_MAX
> @@ -3114,7 +3114,7 @@ static int raid_ctr(struct dm_target *ti
>  		    chunk_size > CHUNK_SIZE_MAX ||
>  		    chunk_size & (chunk_size - 1))
>  			TI_ERR("Invalid chunk size; must "
> -			       "be 2^^n and less equal 512");
> +			       "be 2^^n and less equal 2048");
> 
>  		/*
>  		 * In case we've got 2 or more variable raid parameters,

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

Heinz Mauelshagen                                 Red Hat GmbH
Consulting Development Engineer                   Am Sonnenhang 11
Storage Development                               56242 Marienrachdorf
                                                  Germany
Mauelshagen@RedHat.com                            PHONE +49  171 7803392
                                                  FAX   +49 2626 924446
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
