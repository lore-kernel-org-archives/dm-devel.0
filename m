From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v3] kvmalloc: always use vmalloc if CONFIG_DEBUG_SG
Date: Tue, 24 Apr 2018 06:51:21 -0600
Message-ID: <20180424125121.GA17484@dhcp22.suse.cz>
References: <alpine.LRH.2.02.1804181350050.17942@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1804191207380.31175@file01.intranet.prod.int.rdu2.redhat.com>
	<20180420130852.GC16083@dhcp22.suse.cz>
	<alpine.LRH.2.02.1804201635180.25408@file01.intranet.prod.int.rdu2.redhat.com>
	<20180420210200.GH10788@bombadil.infradead.org>
	<alpine.LRH.2.02.1804201704580.25408@file01.intranet.prod.int.rdu2.redhat.com>
	<20180421144757.GC14610@bombadil.infradead.org>
	<alpine.LRH.2.02.1804221733520.7995@file01.intranet.prod.int.rdu2.redhat.com>
	<20180423151545.GU17484@dhcp22.suse.cz>
	<alpine.LRH.2.02.1804232003100.2299@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1804232003100.2299@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, eric.dumazet@gmail.com, mst@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, virtualization@lists.linux-foundation.org, linux-mm@kvack.org, edumazet@google.com, Andrew Morton <akpm@linux-foundation.org>, David Miller <davem@davemloft.net>, Vlastimil Babka <vbabka@suse.cz>
List-Id: dm-devel.ids

On Mon 23-04-18 20:06:16, Mikulas Patocka wrote:
[...]
> @@ -404,6 +405,12 @@ void *kvmalloc_node(size_t size, gfp_t f
>  	 */
>  	WARN_ON_ONCE((flags & GFP_KERNEL) != GFP_KERNEL);
>  
> +#ifdef CONFIG_DEBUG_SG
> +	/* Catch bugs when the caller uses DMA API on the result of kvmalloc. */
> +	if (!(prandom_u32_max(2) & 1))
> +		goto do_vmalloc;
> +#endif

I really do not think there is anything DEBUG_SG specific here. Why you
simply do not follow should_failslab path or even reuse the function?

> +
>  	/*
>  	 * We want to attempt a large physically contiguous block first because
>  	 * it is less likely to fragment multiple larger blocks and therefore
> @@ -427,6 +434,9 @@ void *kvmalloc_node(size_t size, gfp_t f
>  	if (ret || size <= PAGE_SIZE)
>  		return ret;
>  
> +#ifdef CONFIG_DEBUG_SG
> +do_vmalloc:
> +#endif
>  	return __vmalloc_node_flags_caller(size, node, flags,
>  			__builtin_return_address(0));
>  }

-- 
Michal Hocko
SUSE Labs
