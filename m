From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [RFC][PATCH 1/4] dm-log: fix io_client_destroy leak
Date: Tue, 16 Dec 2008 10:57:59 -0600
Message-ID: <06327136-E451-4DBD-9BD9-D0E95903F7B7@redhat.com>
References: <492C91E1.70405@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v929.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <492C91E1.70405@redhat.com>
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

ACK - reviewed but not tested.

  brassow

On Nov 25, 2008, at 6:01 PM, Takahiro Yasui wrote:

> In create_log_context function, dm_io_client_destroy function needs
> to be called, when memory allocation of disk_header, sync_bits and
> recovering_bits failed, but dm_io_client_destroy is not called.
> This patch fixes it.
>
>
> Signed-off-by: Takahiro Yasui <tyasui@redhat.com>
> ---
> drivers/md/dm-log.c |    5 +++++
> 1 file changed, 5 insertions(+)
>
> Index: linux-2.6.28-rc4/drivers/md/dm-log.c
> ===================================================================
> --- linux-2.6.28-rc4.orig/drivers/md/dm-log.c
> +++ linux-2.6.28-rc4/drivers/md/dm-log.c
> @@ -467,6 +467,7 @@ static int create_log_context(struct dm_
> 		lc->disk_header = vmalloc(buf_size);
> 		if (!lc->disk_header) {
> 			DMWARN("couldn't allocate disk log buffer");
> +			dm_io_client_destroy(lc->io_req.client);
> 			kfree(lc);
> 			return -ENOMEM;
> 		}
> @@ -483,6 +484,8 @@ static int create_log_context(struct dm_
> 		if (!dev)
> 			vfree(lc->clean_bits);
> 		vfree(lc->disk_header);
> +		if (dev)
> +			dm_io_client_destroy(lc->io_req.client);
> 		kfree(lc);
> 		return -ENOMEM;
> 	}
> @@ -496,6 +499,8 @@ static int create_log_context(struct dm_
> 		if (!dev)
> 			vfree(lc->clean_bits);
> 		vfree(lc->disk_header);
> +		if (dev)
> +			dm_io_client_destroy(lc->io_req.client);
> 		kfree(lc);
> 		return -ENOMEM;
> 	}
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
