From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] kpartx: Use __kernel_daddr_t for
 solaris_x86_slice.s_start
Date: Mon, 8 Jul 2019 19:47:43 -0700
Message-ID: <20190709024742.GA22293@infradead.org>
References: <20190708213551.26349-1-petr.vorel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20190708213551.26349-1-petr.vorel@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Petr Vorel <petr.vorel@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

> -//typedef int daddr_t;		/* or long - check */
> -
>  struct solaris_x86_slice {
>  	unsigned short	s_tag;		/* ID tag of partition */
>  	unsigned short	s_flag;		/* permission flags */
> -	long		s_start;	/* start sector no of partition */
> +	__kernel_daddr_t s_start;	/* start sector no of partition */
>  	long		s_size;		/* # of blocks in partition */
>  };

What this really should use is fixed size types.
