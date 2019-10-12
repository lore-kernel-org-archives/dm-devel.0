From: Petr Vorel <petr.vorel@gmail.com>
Subject: Re: [PATCH 1/1] kpartx: Use __kernel_daddr_t for
 solaris_x86_slice.s_start
Date: Sat, 12 Oct 2019 21:08:36 +0200
Message-ID: <20191012190835.GA6490@x230>
References: <20190708213551.26349-1-petr.vorel@gmail.com>
	<20190709024742.GA22293@infradead.org>
	<20190709080204.GA12875@dell5510>
	<20190709133436.GA2231@infradead.org> <20191002060508.GA16684@x230>
	<20191007165732.GA4805@infradead.org>
	<20191008081831.GA29132@dell5510>
	<CAC9+an+8SgNnR7Sr=Q8MKEN9ykPwL2q4LvSTE3C9OisDrN=pKg@mail.gmail.com>
Reply-To: Petr Vorel <petr.vorel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAC9+an+8SgNnR7Sr=Q8MKEN9ykPwL2q4LvSTE3C9OisDrN=pKg@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Baruch Even <baruch@ev-en.org>
Cc: Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Baruch,

> Hi,

> The patch looks good to me, as for gpart, I needed it so I've taken the
> bits and pieces that floated around and merged them all into one place from
> all distributions that I could find.   As for users, in Debian the number
> of users is around 250 so it's a very low usage program but I guess that
> would always be unless very many people lost their partitions every day :-)

> https://qa.debian.org/popcon-graph.php?packages=gpart

> Cheers,
> Baruch

> P.S. While I'm sort of maintaining the program, it's only maintenance, no
> active development is going on with it and very rarely do I get a patch or
> an issue reported.

Thanks for info. FYI (even you don't do active development), although this patch
was merged, it's IMHO wrong approach.
I've sent better approach [1] and I'm going to send v2, which uses uint{16,32}_t
instead of uint{16,32}_t (fixed size types are good enough).
I'll Cc you in new patch, but feel free to ignore it.

Kind regards,
Petr

[1] https://www.redhat.com/archives/dm-devel/2019-October/msg00058.html
