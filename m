From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 31/31] kpartx.rules: move symlink code to
	other files
Date: Wed, 13 Sep 2017 16:26:05 -0500
Message-ID: <20170913212605.GP3145@octiron.msp.redhat.com>
References: <20170902223900.7339-1-mwilck@suse.com>
	<20170902223900.7339-32-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170902223900.7339-32-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Sun, Sep 03, 2017 at 12:39:00AM +0200, Martin Wilck wrote:
> Current kpartx.rules combines two purposes: setting properties and
> creating symlinks for dm partition devices, and creating such
> partition devices on top of other devices. This is contrary to
> common conventions for udev rules files.
> 
> This patch moves the code for properties and symlinks into other
> files. The code that generates symlinks for multipath maps is moved
> to 11-dm-mpath.rules, and for partitions we introduce a new file
> 11-dm-parts.rules. Necessarily this results in minor code duplication.
> OTOH quite some code is removed because the properties are now set
> before 13-dm-disk.rules runs, so we can rely on the latter to create
> the symlinks.
> 
> The reason I put this last in the series is that it will possibly
> require changes in other packages, notably dracut, in order to make
> sure partitions mappings are cleanly set up during boot.

You need to uninstall 11-dm-parts.rules. Otherwise, I'm O.k. with this.

-Ben

> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  kpartx/Makefile             |  1 +
>  kpartx/dm-parts.rules       | 39 +++++++++++++++++++++++++++++++++++++++
>  kpartx/kpartx.rules         | 44 --------------------------------------------
>  multipath/11-dm-mpath.rules | 22 +++++++++++++++++++++-
>  4 files changed, 61 insertions(+), 45 deletions(-)
>  create mode 100644 kpartx/dm-parts.rules
> 
> diff --git a/kpartx/Makefile b/kpartx/Makefile
> index 7f5c1708..8b759b73 100644
> --- a/kpartx/Makefile
> +++ b/kpartx/Makefile
> @@ -29,6 +29,7 @@ install: $(EXEC) $(EXEC).8
>  	$(INSTALL_PROGRAM) -d $(DESTDIR)$(libudevdir)
>  	$(INSTALL_PROGRAM) -m 755 kpartx_id $(DESTDIR)$(libudevdir)
>  	$(INSTALL_PROGRAM) -d $(DESTDIR)$(libudevdir)/rules.d
> +	$(INSTALL_PROGRAM) -m 644 dm-parts.rules $(DESTDIR)$(libudevdir)/rules.d/11-dm-parts.rules
>  	$(INSTALL_PROGRAM) -m 644 kpartx.rules $(DESTDIR)$(libudevdir)/rules.d/66-kpartx.rules
>  	$(INSTALL_PROGRAM) -m 644 del-part-nodes.rules $(DESTDIR)$(libudevdir)/rules.d/68-del-part-nodes.rules
>  	$(INSTALL_PROGRAM) -d $(DESTDIR)$(man8dir)
> diff --git a/kpartx/dm-parts.rules b/kpartx/dm-parts.rules
> new file mode 100644
> index 00000000..235642fd
> --- /dev/null
> +++ b/kpartx/dm-parts.rules
> @@ -0,0 +1,39 @@
> +# Rules for partitions created by kpartx
> +
> +KERNEL!="dm-*", GOTO="dm_parts_end"
> +ACTION!="add|change", GOTO="dm_parts_end"
> +ENV{DM_UUID}!="part[0-9]*", GOTO="dm_parts_end"
> +
> +# We must take care that symlinks don't get lost,
> +# even if blkid fails in 13-dm-disk.rules later.
> +#
> +# Fixme: we have currently no way to avoid calling blkid on
> +# partitions of broken mpath maps such as DM_NOSCAN.
> +# But when partition devices appear, kpartx has likely read
> +# the partition table shortly before, so odds are not bad
> +# that blkid will also succeed.
> +
> +IMPORT{db}="ID_FS_USAGE"
> +IMPORT{db}="ID_FS_UUID_ENC"
> +IMPORT{db}="ID_FS_LABEL_ENC"
> +IMPORT{db}="ID_PART_ENTRY_NAME"
> +IMPORT{db}="ID_PART_ENTRY_UUID"
> +IMPORT{db}="ID_PART_ENTRY_SCHEME"
> +
> +# Maps should take precedence over their members.
> +ENV{DM_UDEV_LOW_PRIORITY_FLAG}!="1", OPTIONS+="link_priority=50"
> +
> +# Set some additional symlinks that typically exist for mpath
> +# path members, too, and should be overridden.
> +#
> +# kpartx_id is very robust, it works for suspended maps and maps
> +# with 0 dependencies. It sets DM_TYPE, DM_PART, DM_WWN
> +IMPORT{program}=="kpartx_id %M %m $env{DM_UUID}"
> +
> +# DM_TYPE only has a reasonable value for partitions on multipath.
> +ENV{DM_UUID}=="*-mpath-*", ENV{DM_TYPE}=="?*" \
> +	SYMLINK+="disk/by-id/$env{DM_TYPE}-$env{DM_NAME}"
> +ENV{DM_WWN}=="?*", ENV{DM_PART}=="?*", \
> +	SYMLINK+="disk/by-id/wwn-$env{DM_WWN}-part$env{DM_PART}"
> +
> +LABEL="dm_parts_end"
> diff --git a/kpartx/kpartx.rules b/kpartx/kpartx.rules
> index 1cbe9429..8f990494 100644
> --- a/kpartx/kpartx.rules
> +++ b/kpartx/kpartx.rules
> @@ -8,50 +8,6 @@ KERNEL!="dm-*", GOTO="kpartx_end"
>  ACTION!="add|change", GOTO="kpartx_end"
>  ENV{DM_UUID}!="?*", GOTO="kpartx_end"
>  
> -# kpartx_id is very robust, it works for suspended maps and maps
> -# with 0 dependencies
> -IMPORT{program}=="kpartx_id %M %m $env{DM_UUID}"
> -
> -ENV{DM_UDEV_LOW_PRIORITY_FLAG}!="1", OPTIONS+="link_priority=50"
> -
> -ENV{DM_UUID}=="*mpath-*", ENV{DM_TYPE}=="?*" \
> -	SYMLINK+="disk/by-id/$env{DM_TYPE}-$env{DM_NAME}"
> -
> -# Create persistent links for multipath tables
> -ENV{DM_WWN}=="?*", ENV{DM_PART}!="?*", \
> -	SYMLINK+="disk/by-id/wwn-$env{DM_WWN}"
> -
> -# Create persistent links for partitions
> -ENV{DM_WWN}=="?*", ENV{DM_PART}=="?*", \
> -	SYMLINK+="disk/by-id/wwn-$env{DM_WWN}-part$env{DM_PART}"
> -
> -# Create persistent by-label/by-uuid links.
> -# multipath maps with DM_NOSCAN!=1 are handled in 13-dm-disk.rules.
> -DM_UUID=="mpath-*", ENV{DM_NOSCAN}!="1", GOTO="symlink_end"
> -
> -# For partitions, we don't have DM_NOSCAN.
> -# Simply load variables from db if they aren't set.
> -# 11-dm-mpath.rules does this for mpath maps.
> -# Fixme: we have currently no way to avoid calling blkid on
> -# partitions of broken mpath maps.
> -ENV{DM_UUID}!="part*-*-*", GOTO="import_end"
> -ENV{ID_FS_USAGE}!="?*", IMPORT{db}="ID_FS_USAGE"
> -ENV{ID_FS_UUID_ENC}!="?*", IMPORT{db}="ID_FS_UUID_ENC"
> -ENV{ID_FS_LABEL_ENC}!="?*", IMPORT{db}="ID_FS_LABEL_ENC"
> -ENV{ID_PART_ENTRY_NAME}!="?*", IMPORT{db}="ID_PART_ENTRY_NAME"
> -ENV{ID_PART_ENTRY_UUID}!="?*", IMPORT{db}="ID_PART_ENTRY_UUID"
> -ENV{ID_PART_ENTRY_SCHEME}!="?*", IMPORT{db}="ID_PART_ENTRY_SCHEME"
> -LABEL="import_end"
> -
> -ENV{ID_FS_USAGE}=="filesystem|other|crypto", ENV{ID_FS_UUID_ENC}=="?*", \
> -       SYMLINK+="disk/by-uuid/$env{ID_FS_UUID_ENC}"
> -ENV{ID_FS_USAGE}=="filesystem|other", ENV{ID_FS_LABEL_ENC}=="?*", \
> -       SYMLINK+="disk/by-label/$env{ID_FS_LABEL_ENC}"
> -ENV{ID_PART_ENTRY_UUID}=="?*", SYMLINK+="disk/by-partuuid/$env{ID_PART_ENTRY_UUID}"
> -ENV{ID_PART_ENTRY_SCHEME}=="gpt", ENV{ID_PART_ENTRY_NAME}=="?*", \
> -       SYMLINK+="disk/by-partlabel/$env{ID_PART_ENTRY_NAME}"
> -LABEL="symlink_end"
> -
>  # Create dm tables for partitions on multipath devices.
>  ENV{DM_UUID}!="mpath-?*", GOTO="mpath_kpartx_end"
>  
> diff --git a/multipath/11-dm-mpath.rules b/multipath/11-dm-mpath.rules
> index 4a3f646d..132a9234 100644
> --- a/multipath/11-dm-mpath.rules
> +++ b/multipath/11-dm-mpath.rules
> @@ -80,8 +80,12 @@ ENV{MPATH_DEVICE_READY}!="0", ENV{.MPATH_DEVICE_READY_OLD}=="0",\
>  	ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="$env{DM_DISABLE_OTHER_RULES_FLAG_OLD}",\
>  	ENV{DM_DISABLE_OTHER_RULES_FLAG_OLD}=""
>  
> +# The code to check multipath state ends here. We need to set
> +# properties and symlinks regardless whether the map is usable or
> +# not. If symlinks get lost, systemd may auto-unmount file systems.
> +
>  LABEL="scan_import"
> -ENV{DM_NOSCAN}!="1", GOTO="mpath_end"
> +ENV{DM_NOSCAN}!="1", GOTO="import_end"
>  IMPORT{db}="ID_FS_TYPE"
>  IMPORT{db}="ID_FS_USAGE"
>  IMPORT{db}="ID_FS_UUID"
> @@ -90,4 +94,20 @@ IMPORT{db}="ID_FS_LABEL"
>  IMPORT{db}="ID_FS_LABEL_ENC"
>  IMPORT{db}="ID_FS_VERSION"
>  
> +LABEL="import_end"
> +
> +# Multipath maps should take precedence over their members.
> +ENV{DM_UDEV_LOW_PRIORITY_FLAG}!="1", OPTIONS+="link_priority=50"
> +
> +# Set some additional symlinks that typically exist for mpath
> +# path members, too, and should be overridden.
> +
> +# kpartx_id is very robust, it works for suspended maps and maps
> +# with 0 dependencies. It sets DM_TYPE, DM_PART, DM_WWN
> +TEST=="/usr/lib/udev/kpartx_id", \
> +	IMPORT{program}=="kpartx_id %M %m $env{DM_UUID}"
> +
> +ENV{DM_TYPE}=="?*", SYMLINK+="disk/by-id/$env{DM_TYPE}-$env{DM_NAME}"
> +ENV{DM_WWN}=="?*", SYMLINK+="disk/by-id/wwn-$env{DM_WWN}"
> +
>  LABEL="mpath_end"
> -- 
> 2.14.0
