From: Petr Vorel <petr.vorel@gmail.com>
Subject: Re: [PATCH 1/1] kpartx: Use __kernel_daddr_t for
 solaris_x86_slice.s_start
Date: Tue, 9 Jul 2019 10:02:05 +0200
Message-ID: <20190709080204.GA12875@dell5510>
References: <20190708213551.26349-1-petr.vorel@gmail.com>
	<20190709024742.GA22293@infradead.org>
Reply-To: Petr Vorel <petr.vorel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20190709024742.GA22293@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Christoph,

> > -//typedef int daddr_t;		/* or long - check */
> > -
> >  struct solaris_x86_slice {
> >  	unsigned short	s_tag;		/* ID tag of partition */
> >  	unsigned short	s_flag;		/* permission flags */
> > -	long		s_start;	/* start sector no of partition */
> > +	__kernel_daddr_t s_start;	/* start sector no of partition */
> >  	long		s_size;		/* # of blocks in partition */
> >  };

> What this really should use is fixed size types.
If it's not specific to __kernel_daddr_t nor daddr_t ("The type of a disk
address") and long is sufficient for all platforms, that's even better.

I'd be just for removing typedef int daddr_t comment.

BTW gpart also uses struct solaris_x86_slice, with daddr_t [1].
I've filed a PR [2], but I guess I'll change it to long.

Kind regards,
Petr

[1] https://github.com/baruch/gpart/blob/master/src/gm_s86dl.h#L43
[2] https://github.com/baruch/gpart/pull/15
