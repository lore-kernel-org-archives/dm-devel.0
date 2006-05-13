From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Remove softlockup from
 invalidate_mapping_pages. (might be dm related)
Date: Sat, 13 May 2006 08:43:17 -0700
Message-ID: <20060513084317.50356155.akpm@osdl.org>
References: <1060420062955.7727@suse.de>
	<20060420003839.1a41c36f.akpm@osdl.org>
	<20060426204809.GA15462@uio.no>
	<20060426135809.10a37ec3.akpm@osdl.org>
	<20060513134908.GA4480@uio.no>
	<20060513073344.4fcbc46b.akpm@osdl.org>
	<20060513144334.GA6013@uio.no>
	<20060513075147.423d18bd.akpm@osdl.org>
	<20060513150003.GA6096@uio.no>
	<20060513082409.4d173ccc.akpm@osdl.org>
	<20060513153231.GA6277@uio.no>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060513153231.GA6277@uio.no>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

"Steinar H. Gunderson" <sgunderson@bigfoot.com> wrote:
>
>  > Which kind of implies that we passed a null (or very small small) `struct
>  > kmem_cache' pointer into kmem_cache_free().  But that doesn't seem like the
>  > sort of thing which will take hours to reproduce.
>  > 
>  > Do you have CONFIG_NUMA set?
> 
>  Hm, yes, for some reason CONFIG_NUMA, CONFIG_K8_NUMA and
>  CONFIG_x86_64_ACPI_NUMA are all set; I guess they're left from the stock
>  config I use at a base. (For those tuning in; this is a dual-core amd64. That
>  might be relevant somehow.)

Please try it without NUMA - we've had a few problems there of late.  If
that fixes it then I have patches for you to test ;)
