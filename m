From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] kpartx: Use __kernel_daddr_t for
 solaris_x86_slice.s_start
Date: Mon, 7 Oct 2019 09:57:32 -0700
Message-ID: <20191007165732.GA4805@infradead.org>
References: <20190708213551.26349-1-petr.vorel@gmail.com>
	<20190709024742.GA22293@infradead.org>
	<20190709080204.GA12875@dell5510>
	<20190709133436.GA2231@infradead.org> <20191002060508.GA16684@x230>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20191002060508.GA16684@x230>
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
Cc: Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Oct 02, 2019 at 08:05:09AM +0200, Petr Vorel wrote:
> I tried to search in [1], with not much success, I don't know the original name
> of the struct and struct members are quite similar. Do you have a tip, where it
> could be or would you dare to search?

No, I don't know Solaris very well.

> 
> Christophe already merged my patch as
> 129e6fe6 ("kpartx: Use __kernel_daddr_t for solaris_x86_slice.s_start")
> 
> But, according to your comments it looks to me better to use the exact structure
> kernel uses. So, if we don't find anything, I'd be for using kernel struct.

Thanks, that would be great.
