From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 07/18] Replicator: suspend/deactivate
	replicator
Date: Tue, 3 Nov 2009 11:46:14 -0500
Message-ID: <20091103164613.GA26722@redhat.com>
References: <1257171622-8380-1-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-2-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-3-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-4-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-5-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-6-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-7-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-8-git-send-email-zkabelac@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1257171622-8380-8-git-send-email-zkabelac@redhat.com>
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
Cc: Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Mon, Nov 02 2009 at  9:20am -0500,
Zdenek Kabelac <zkabelac@redhat.com> wrote:

> Introducing dm_tree_set_replicator_suspend() to suspend
> replicator control device before actual deactivation of replicator-dev
> head device.
> 
> Signed-off-by: Zdenek Kabelac <zkabelac@redhat.com>
> ---
>  libdm/.exported_symbols |    1 +
>  libdm/libdevmapper.h    |    2 +
>  libdm/libdm-deptree.c   |   63 +++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 66 insertions(+), 0 deletions(-)
> 
> diff --git a/libdm/.exported_symbols b/libdm/.exported_symbols
> index 7b5e3f0..3217e03 100644
> --- a/libdm/.exported_symbols
> +++ b/libdm/.exported_symbols
> @@ -79,6 +79,7 @@ dm_tree_node_add_mirror_target_log
>  dm_tree_node_add_target_area
>  dm_tree_node_add_replicator_target
>  dm_tree_node_add_replicator_dev_target
> +dm_tree_set_replicator_suspend
>  dm_tree_node_set_read_ahead
>  dm_tree_skip_lockfs
>  dm_tree_use_no_flush_suspend
> diff --git a/libdm/libdevmapper.h b/libdm/libdevmapper.h
> index f96aed3..66ce055 100644
> --- a/libdm/libdevmapper.h
> +++ b/libdm/libdevmapper.h
> @@ -457,6 +457,8 @@ int dm_tree_node_add_replicator_dev_target(struct dm_tree_node *node,
>  					   uint32_t slog_flags,		/* Mirror log flags */
>  					   uint32_t slog_size);
>  
> +int dm_tree_set_replicator_suspend(struct dm_tree *dtree, const char *uuid);
> +
>  int dm_tree_node_add_target_area(struct dm_tree_node *node,
>  				    const char *dev_name,
>  				    const char *dlid,
> diff --git a/libdm/libdm-deptree.c b/libdm/libdm-deptree.c
> index 0ba4e7e..652b9e8 100644
> --- a/libdm/libdm-deptree.c
> +++ b/libdm/libdm-deptree.c
> @@ -157,6 +157,7 @@ struct dm_tree_node {
>          struct dm_list used_by;    	/* Nodes that use this node */
>  
>  	int activation_priority;	/* 0 gets activated first */
> +	int replicator_suspend;		/* 1 gets suspend first */
>  
>  	uint16_t udev_flags;		/* Udev control flags */
>  

I think it would be wise to make this more generic,
e.g. "suspend_priority".

It could be that other future devices would like to prioritize the
suspend sequence too.  Having a means to do so (without using a
seemingly replicator-specific node attribute) would be good.

So this really just amounts to: s/replicator_suspend/suspend_priority/

Mike
