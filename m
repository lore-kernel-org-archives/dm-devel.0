From: Chip Coldwell <coldwell@redhat.com>
Subject: Re: [PATCH 3/3] multipath: implement controller framework
	for hardware handlers (fwd)
Date: Mon, 19 Nov 2007 08:41:46 -0500 (EST)
Message-ID: <alpine.LFD.0.9999.0711190838590.3253@localhost.localdomain>
References: <alpine.LFD.0.9999.0711190838370.3253@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LFD.0.9999.0711190838370.3253@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

From: Hannes Reinecke <hare@suse.de>
diff --git a/drivers/md/dm-hw-handler.h b/drivers/md/dm-hw-handler.h
> index 9216682..6f91b55 100644
> --- a/drivers/md/dm-hw-handler.h
> +++ b/drivers/md/dm-hw-handler.h
> @@ -15,10 +15,31 @@
>  
>  struct hw_handler_type;
>  
> +#define CTLR_ID_LEN 256
> +
> +struct hw_controller {
> +	struct list_head node;
> +	struct hw_controller_type *type;
> +	unsigned char ctlr_id[CTLR_ID_LEN];
> +	struct kref kref;
> +	spinlock_t lock;
> +	struct list_head cmd_list;
> +	int submitted;
> +	void *context;
> +};
> +
> +struct hw_controller_type {
> +	char *name;
> +
> +	int (*create) (struct hw_controller *ctlr);
> +	void (*destroy) (struct hw_controller *ctlr);
> +};
> +

Would it make sense to make hw_controller_type a kobj_type?  That way,
the controller topology could be reflected in sysfs, where it can be
reached by tools such as lsscsi.

Chip

-- 
Charles M. "Chip" Coldwell
Senior Software Engineer
Red Hat, Inc
978-392-2426
