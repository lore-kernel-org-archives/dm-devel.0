From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: [PATCH] multipath-tools: fix minor compilation issues
Date: Mon, 13 Mar 2006 14:50:26 +0100
Message-ID: <20060313135026.GA6902@pundit>
References: <4415653C.4050702@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4415653C.4050702@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

On Mon, Mar 13, 2006 at 01:27:40PM +0100, Hannes Reinecke wrote:
> Hi Christophe,
> 
> our checker found some minor issues:
> 
> - refwwid in libmultipath/configure.c:get_refwwid() might be used
>   uninitialized. As dev_type is a simple 'int' there is nothing which
>   prevents the unsuspecting user to call it with an unhandled value.
>   We shoud rather use an enum and set refwwid to NULL to be on the safe
>   side.
> - attr in libmultipath/discovery.c:devt2devname() might be used
>   uninitialized. Quite unlikely, but might happen in principle.
>   So better have it initialized.
> - r in multipath/main.c:main() might be used uninitialized.
>   True. So have it initialized.
> 
> Please apply.
> 
Applied, thanks.

Regards,
cvaroqui
