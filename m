From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: [PATCH] multipath-tools: Fix Makefile for libmultipath
Date: Mon, 13 Mar 2006 14:50:46 +0100
Message-ID: <20060313135046.GB6902@pundit>
References: <4415641B.3030706@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4415641B.3030706@suse.de>
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

On Mon, Mar 13, 2006 at 01:22:51PM +0100, Hannes Reinecke wrote:
> Hi Christophe,
> 
> libmultipath/Makefile resets CFLAGS, so we can't pass anything from the
> top-level makefile.
> The attached patch corrects this.
> 
> Please apply.
> 
Applied, thanks.

Regards,
cvaroqui
