From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 09/16] scsi: remove gfp_flags member in
 scsi_host_cmd_pool
Date: Tue, 24 Jan 2017 09:31:51 +0100
Message-ID: <aa7a5e56-33a4-8590-2843-360a984f2229@suse.de>
References: <1485185361-29786-1-git-send-email-hch@lst.de>
	<1485185361-29786-10-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1485185361-29786-10-git-send-email-hch@lst.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On 01/23/2017 04:29 PM, Christoph Hellwig wrote:
> When using the slab allocator we already decide at cache creation time if
> an allocation comes from a GFP_DMA pool using the SLAB_CACHE_DMA flag,
> and there is no point passing the kmalloc-family only GFP_DMA flag to
> kmem_cache_alloc.  Drop all the infrastructure for doing so.
> =

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/scsi.c | 14 ++++----------
>  1 file changed, 4 insertions(+), 10 deletions(-)
> =

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
