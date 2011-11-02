From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: multipath-tools/kpartx gpt.c
Date: Wed, 02 Nov 2011 22:53:52 +0100
Message-ID: <1320270832.16195.17.camel@lapoo.opensvc.com>
References: <20111024133718.30188.qmail@sourceware.org>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20111024133718.30188.qmail@sourceware.org>
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
Cc: dm-cvs@sourceware.org
List-Id: dm-devel.ids


> --- multipath-tools/kpartx/gpt.c	2006/10/13 23:28:47	1.3
> +++ multipath-tools/kpartx/gpt.c	2011/10/24 13:37:18	1.3.2.1
> @@ -358,6 +358,15 @@
>  		return 0;
>  	}
>  
> +	/* Check that sizeof_partition_entry has the correct value */
> +	if (__le32_to_cpu((*gpt)->sizeof_partition_entry) != sizeof(gpt_entry)) {
> +		// printf("GUID partition entry size check failed.\n");
> +		free(*gpt);
> +		*gpt = NULL;
> +		return 0;
> +	}
> +
> +
>  	if (!(*ptes = alloc_read_gpt_entries(fd, *gpt))) {
>  		free(*gpt);
>  		*gpt = NULL;
> 
Do you want this enhancement applied to upstream kpartx ? It seems the
hole is open there at the moment.

Regards,
-- 
Christophe Varoqui
OpenSVC - Tools to scale
http://www.opensvc.com/
