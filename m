From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH 1/5] ALUA prioritizer: Remove an unused
	variable
Date: Thu, 24 Jul 2014 16:37:23 +0200
Message-ID: <20140724163723.0000481e@localhost>
References: <53C91871.9070402@acm.org>
	<53C9189A.3070204@acm.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <53C9189A.3070204@acm.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bvanassche@acm.org>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Bart Van Assche wrote:
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  libmultipath/prioritizers/alua.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/libmultipath/prioritizers/alua.c b/libmultipath/prioritizers/alua.c
> index b967ec7..39ed1c8 100644
> --- a/libmultipath/prioritizers/alua.c
> +++ b/libmultipath/prioritizers/alua.c
> @@ -55,7 +55,6 @@ get_alua_info(int fd)
>  {
>  	int	rc;
>  	int	tpg;
> -	int	aas;
>  
>  	rc = get_target_port_group_support(fd);
>  	if (rc < 0)
> @@ -72,7 +71,6 @@ get_alua_info(int fd)
>  	rc = get_asymmetric_access_state(fd, tpg);
>  	if (rc < 0)
>  		return -ALUA_PRIO_GETAAS_FAILED;
> -	aas = (rc & 0x0f);
>  
>  	condlog(3, "aas = %02x [%s]%s", rc, aas_print_string(rc),
>  		(rc & 0x80) ? " [preferred]" : "");

Question is what Hannes intended to output here with his change in a87a2aa4.

The aas field is just 4 bits. The rc variable contains more than the aas
field. If I don't mistake it is d->b0 & 0x8f. So it does contain pref and
aas, but not rtpg_fmt. aas_print_string on the other hand tries to check
the format, but always gets rtpg_fmt as 0.

Sebastian
