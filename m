From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [RFC] [PATCH] lvm2: mirroredlog support
Date: Wed, 30 Sep 2009 10:50:06 -0500
Message-ID: <F5472B5D-59E5-4A38-948B-6055886E75A8@redhat.com>
References: <20090923030331.GA26449@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090923030331.GA26449@us.ibm.com>
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

Looking through the code before applying your patch, it seems that  
someone has already thought about this issue - even if it hasn't been  
implemented.  For example, already in the top most function used to  
create mirrors, 'lv_add_mirrors', we see a 'log_count' parameter.   
That parameter can be traced down through 'add_mirror_images/log',  
'_set_up_mirror_log', and even the allocation functions.  In fact, the  
first comment in 'add_mirror_log' is /* Unimplemented features */,  
followed by a check to see if 'log_count > 1'.  Your patch seems to  
ignore 'log_count' and create new parameters (like mirroredlog), which  
seem unnecessary to me...  I don't understand why any of the new  
parameters to the functions are necessary, can you explain?  [I can  
see new parameters for '_create_mirror_log' though, as it doesn't seem  
to maintain the 'log_count' parameter - but you didn't do work in that  
function.]

You also seem to have violated the allocation policies by ignoring the  
line of work that has been done up to '_set_up_mirror_log' by simply  
calling 'add_mirror_images'.  This works, but it is oversimplified, I  
think.  You can see this is incorrect by simply testing:
prompt> lvcreate -m1 -L 500M -n lv vg /dev/sd[xy]1  # will fail  
because there are only two devices
prompt> lvcreate ... --mirroredlog /dev/sd[xy]1 # should fail, but  
succeeds due to ignoring previous allocation work
You may wish to push your enhancements into '_[create |  
init]_mirror_log'?

Additionally, the 'log_count' parameter is more general than  
'mirroredlog' and can support more log types.  Consider the following:
--mirrorlog core => (log_count = 0)
--mirrorlog disk => (log_count = 1)
--mirrorlog redundant => (log_count = 2)
--mirrorlog fully_redundant => (log_count = # of mirror legs)
You are looking to add "redundant" (you can call it "mirrored" if you  
like), but if we use 'log_count' in a general way, we get  
"fully_redundant" (almost) for free.

I probably haven't given this code as much time as you have, so if  
there are reasons for the way you implemented it, please help inform me.

As long as we are on the topic of mirror logs (and this is unrelated  
to your patch), I'd like to complain about the current behavior of log  
allocation vs the log policy.  I don't think it should take  
'alloc_anywhere' for a log to be placed on the same disk as one of the  
mirror legs... that should be 'alloc_normal'.  I think it should be  
something like:
ALLOC_CONTIGUOUS: logs and images on all separate devices - no overlap
ALLOC_NORMAL: Allow logs to exist on the same devices as the mirror  
images.
ALLOC_ANYWHERE: Should we allow mirror images on the same device!?!   
(i.e. everything can be packed on one device)
It is silly to me that a user with two devices cannot create the  
default mirror.  It makes even less sense when you consider mirrors  
with redundant logs, as this just adds to the number of devices you  
need.  I'd love to see this fixed, but overthrowing and established  
policy may be difficult.

  brassow

On Sep 22, 2009, at 10:03 PM, malahal@us.ibm.com wrote:

> This patch adds '--mirroredlog' option to LVM commands to create a
> mirror with mirrored log device. Rebased to the latest LVM code
> (LVM2.2.02.51). Have not done 'lvconvert' related changes yet!
> Appreciate any comments.
>
> diff -r c70315774a35 lib/activate/activate.c
> --- a/lib/activate/activate.c	Tue Sep 15 12:08:46 2009 -0700
> +++ b/lib/activate/activate.c	Tue Sep 22 19:51:15 2009 -0700
> @@ -979,6 +979,8 @@
> {
> 	struct logical_volume *lv;
> 	struct lvinfo info;
> +	struct lv_segment *seg, *log_seg;
> +	struct segment_type *type = get_segtype_from_string(cmd, "mirror");
> 	int r = 0;
>
> 	if (!activation())
> @@ -1012,6 +1014,20 @@
> 	if (!monitor_dev_for_events(cmd, lv, 0))
> 		stack;
>
> +	if ( !dm_list_empty(&lv->segments) ) {
> +		seg = dm_list_item(dm_list_first(&lv->segments), struct  
> lv_segment);
> +		if (seg->log_lv) {
> +			log_very_verbose("lv %s is mirrored, check it's log %s...", lv- 
> >name, seg->log_lv->name);
> +			if ( !dm_list_empty(&seg->log_lv->segments) ) {
> +				log_seg = dm_list_item(dm_list_first(&seg->log_lv->segments),  
> struct lv_segment);
> +				if (log_seg->segtype == type) {
> +					log_verbose("log %s is mirrored, unregister for events",  
> log_seg->lv->name);
> +					monitor_dev_for_events(cmd, log_seg->lv, 0);
> +				}
> +			}
> +		}
> +	}
> +
> 	memlock_inc();
> 	r = _lv_deactivate(lv);
> 	memlock_dec();
> diff -r c70315774a35 lib/metadata/lv_manip.c
> --- a/lib/metadata/lv_manip.c	Tue Sep 15 12:08:46 2009 -0700
> +++ b/lib/metadata/lv_manip.c	Tue Sep 22 19:51:15 2009 -0700
> @@ -3029,14 +3029,16 @@
> 		return_0;
>
> 	if (lp->mirrors > 1) {
> -		if (!lv_add_mirrors(cmd, lv, lp->mirrors - 1, lp->stripes,
> +		if (!lv_add_mirrors(cmd, lv, lp->segtype, lp->mirrors - 1,
> +				    lp->stripes, lp->stripe_size,
> 				    adjusted_mirror_region_size(
> 						vg->extent_size,
> 						lv->le_count,
> 						lp->region_size),
> 				    lp->corelog ? 0U : 1U, lp->pvh, lp->alloc,
> 				    MIRROR_BY_LV |
> -				    (lp->nosync ? MIRROR_SKIP_INIT_SYNC : 0))) {
> +				    (lp->nosync ? MIRROR_SKIP_INIT_SYNC : 0),
> +				    lp->mirrored_log)) {
> 			stack;
> 			goto revert_new_lv;
> 		}
> diff -r c70315774a35 lib/metadata/metadata-exported.h
> --- a/lib/metadata/metadata-exported.h	Tue Sep 15 12:08:46 2009 -0700
> +++ b/lib/metadata/metadata-exported.h	Tue Sep 22 19:51:15 2009 -0700
> @@ -528,6 +528,7 @@
> 	uint32_t region_size; /* mirror */
>
> 	uint32_t mirrors; /* mirror */
> +	uint32_t mirrored_log; /* mirror */
>
> 	const struct segment_type *segtype; /* all */
>
> @@ -637,9 +638,11 @@
> */
> struct lv_segment *find_mirror_seg(struct lv_segment *seg);
> int lv_add_mirrors(struct cmd_context *cmd, struct logical_volume *lv,
> -		   uint32_t mirrors, uint32_t stripes,
> +		   const struct segment_type *segtype,
> +		   uint32_t mirrors, uint32_t stripes, uint32_t stripe_size,
> 		   uint32_t region_size, uint32_t log_count,
> -		   struct dm_list *pvs, alloc_policy_t alloc, uint32_t flags);
> +		   struct dm_list *pvs, alloc_policy_t alloc, uint32_t flags,
> +		   uint32_t mirrored_log);
> int lv_remove_mirrors(struct cmd_context *cmd, struct logical_volume  
> *lv,
> 		      uint32_t mirrors, uint32_t log_count,
> 		      struct dm_list *pvs, uint32_t status_mask);
> @@ -658,16 +661,21 @@
> int remove_mirror_images(struct logical_volume *lv, uint32_t  
> num_mirrors,
> 			 struct dm_list *removable_pvs, unsigned remove_log);
> int add_mirror_images(struct cmd_context *cmd, struct logical_volume  
> *lv,
> -		      uint32_t mirrors, uint32_t stripes, uint32_t region_size,
> +		      const struct segment_type *segtype,
> +		      uint32_t mirrors, uint32_t stripes, uint32_t stripe_size,
> +		      uint32_t region_size,
> 		      struct dm_list *allocatable_pvs, alloc_policy_t alloc,
> -		      uint32_t log_count);
> +		      uint32_t log_count, uint32_t mirrored_log);
> struct logical_volume *detach_mirror_log(struct lv_segment *seg);
> int attach_mirror_log(struct lv_segment *seg, struct logical_volume  
> *lv);
> int remove_mirror_log(struct cmd_context *cmd, struct logical_volume  
> *lv,
> 		      struct dm_list *removable_pvs);
> int add_mirror_log(struct cmd_context *cmd, struct logical_volume *lv,
> +		   const struct segment_type *segtype,
> 		   uint32_t log_count, uint32_t region_size,
> -		   struct dm_list *allocatable_pvs, alloc_policy_t alloc);
> +		   struct dm_list *allocatable_pvs, alloc_policy_t alloc,
> +		   uint32_t mirrors, uint32_t stripes, uint32_t stripe_size,
> +		   uint32_t mirrored_log);
>
> int reconfigure_mirror_images(struct lv_segment *mirrored_seg,  
> uint32_t num_mirrors,
> 			      struct dm_list *removable_pvs, unsigned remove_log);
> diff -r c70315774a35 lib/metadata/mirror.c
> --- a/lib/metadata/mirror.c	Tue Sep 15 12:08:46 2009 -0700
> +++ b/lib/metadata/mirror.c	Tue Sep 22 19:51:15 2009 -0700
> @@ -1248,7 +1248,8 @@
> 						 struct alloc_handle *ah,
> 						 alloc_policy_t alloc,
> 						 const char *lv_name,
> -						 const char *suffix)
> +						 const char *suffix,
> +						 uint32_t mirrored_log)
> {
> 	struct logical_volume *log_lv;
> 	char *log_name;
> @@ -1270,7 +1271,7 @@
> 				       alloc, lv->vg)))
> 		return_NULL;
>
> -	if (!lv_add_log_segment(ah, log_lv))
> +	if (!mirrored_log && !lv_add_log_segment(ah, log_lv))
> 		return_NULL;
>
> 	return log_lv;
> @@ -1279,10 +1280,16 @@
> static struct logical_volume *_set_up_mirror_log(struct cmd_context  
> *cmd,
> 						 struct alloc_handle *ah,
> 						 struct logical_volume *lv,
> +						 const struct segment_type *segtype,
> 						 uint32_t log_count,
> -						 uint32_t region_size __attribute((unused)),
> +						 uint32_t region_size,
> 						 alloc_policy_t alloc,
> -						 int in_sync)
> +						 int in_sync,
> +						 uint32_t mirrors,
> +						 uint32_t stripes,
> +						 uint32_t stripe_size,
> +						 struct dm_list *allocatable_pvs,
> +						 uint32_t mirrored_log)
> {
> 	struct logical_volume *log_lv;
> 	const char *suffix, *c;
> @@ -1324,11 +1331,20 @@
> 	}
>
> 	if (!(log_lv = _create_mirror_log(lv, ah, alloc,
> -					  (const char *) lv_name, suffix))) {
> +					  (const char *) lv_name, suffix, mirrored_log))) {
> 		log_error("Failed to create mirror log.");
> 		return NULL;
> 	}
>
> +	if (mirrored_log) {
> +		if (!lv_extend(log_lv, segtype, stripes, stripe_size,
> +				1u, 1u, NULL, 0u, 0u, allocatable_pvs, alloc))
> +			return NULL;
> +
> +		add_mirror_images(cmd, log_lv, segtype, mirrors, stripes,  
> stripe_size,
> +				   region_size, allocatable_pvs, alloc, 0, 0);
> +	}
> +
> 	if (!_init_mirror_log(cmd, log_lv, in_sync, &lv->tags, 1)) {
> 		log_error("Failed to create mirror log.");
> 		return NULL;
> @@ -1346,8 +1362,11 @@
> }
>
> int add_mirror_log(struct cmd_context *cmd, struct logical_volume *lv,
> +		   const struct segment_type *seg_type,
> 		   uint32_t log_count, uint32_t region_size,
> -		   struct dm_list *allocatable_pvs, alloc_policy_t alloc)
> +		   struct dm_list *allocatable_pvs, alloc_policy_t alloc,
> +		   uint32_t mirrors, uint32_t stripes, uint32_t stripe_size,
> +		   uint32_t mirrored_log)
> {
> 	struct alloc_handle *ah;
> 	const struct segment_type *segtype;
> @@ -1410,8 +1429,10 @@
> 	else
> 		in_sync = 0;
>
> -	if (!(log_lv = _set_up_mirror_log(cmd, ah, lv, log_count,
> -					  region_size, alloc, in_sync)))
> +	if (!(log_lv = _set_up_mirror_log(cmd, ah, lv, seg_type, log_count,
> +					  region_size, alloc, in_sync,
> +					  mirrors, stripes, stripe_size, allocatable_pvs,
> +					  mirrored_log)))
> 		goto_out;
>
> 	if (!attach_mirror_log(first_seg(lv), log_lv))
> @@ -1427,9 +1448,10 @@
>  * Convert "linear" LV to "mirror".
>  */
> int add_mirror_images(struct cmd_context *cmd, struct logical_volume  
> *lv,
> -		      uint32_t mirrors, uint32_t stripes, uint32_t region_size,
> +		      const struct segment_type *seg_type, uint32_t mirrors,
> +		      uint32_t stripes, uint32_t stripe_size, uint32_t region_size,
> 		      struct dm_list *allocatable_pvs, alloc_policy_t alloc,
> -		      uint32_t log_count)
> +		      uint32_t log_count, uint32_t mirrored_log)
> {
> 	struct alloc_handle *ah;
> 	const struct segment_type *segtype;
> @@ -1452,9 +1474,18 @@
> 	if (!(segtype = get_segtype_from_string(cmd, "mirror")))
> 		return_0;
>
> -	ah = allocate_extents(lv->vg, NULL, segtype,
> -			      stripes, mirrors, log_count, region_size, lv->le_count,
> -			      allocatable_pvs, alloc, parallel_areas);
> +	if (mirrored_log)
> +		/* Allocate mirror extents for the log */
> +		ah = allocate_extents(lv->vg, NULL, segtype,
> +				       stripes, mirrors, 0,
> +				       region_size, 1,
> +				       allocatable_pvs, alloc, parallel_areas);
> +	else
> +		ah = allocate_extents(lv->vg, NULL, segtype,
> +				       stripes, mirrors, log_count,
> +				       region_size, lv->le_count,
> +				       allocatable_pvs, alloc, parallel_areas);
> +
> 	if (!ah) {
> 		log_error("Unable to allocate extents for mirror(s).");
> 		return 0;
> @@ -1463,11 +1494,25 @@
> 	/*
> 	 * create and initialize mirror log
> 	 */
> -	if (log_count &&
> -	    !(log_lv = _set_up_mirror_log(cmd, ah, lv, log_count,  
> region_size,
> -					  alloc, mirror_in_sync()))) {
> -		stack;
> -		goto out_remove_images;
> +	if (log_count) {
> +		if (!(log_lv = _set_up_mirror_log(cmd, ah, lv, seg_type,  
> log_count, region_size,
> +				  alloc, mirror_in_sync(), mirrors, stripes,
> +				  stripe_size, allocatable_pvs, mirrored_log))) {
> +			stack;
> +			goto out_remove_images;
> +		}
> +		if (mirrored_log) {
> +			/* Allocate extents for the mirror legs */
> +			alloc_destroy(ah);
> +			ah = allocate_extents(lv->vg, NULL, segtype,
> +						stripes, mirrors, 0,
> +						region_size, lv->le_count,
> +						allocatable_pvs, alloc, parallel_areas);
> +			if (!ah) {
> +				stack;
> +				goto out_remove_images;
> +			}
> +		}
> 	}
>
> 	/* The log initialization involves vg metadata commit.
> @@ -1529,9 +1574,11 @@
>  * 'pvs' is either allocatable pvs.
>  */
> int lv_add_mirrors(struct cmd_context *cmd, struct logical_volume *lv,
> -		   uint32_t mirrors, uint32_t stripes,
> +		   const struct segment_type *seg_type, uint32_t mirrors,
> +		   uint32_t stripes, uint32_t stripe_size,
> 		   uint32_t region_size, uint32_t log_count,
> -		   struct dm_list *pvs, alloc_policy_t alloc, uint32_t flags)
> +		   struct dm_list *pvs, alloc_policy_t alloc, uint32_t flags,
> +		   uint32_t mirrored_log)
> {
> 	if (!mirrors && !log_count) {
> 		log_error("No conversion is requested");
> @@ -1564,11 +1611,13 @@
> 					       region_size, pvs, alloc);
> 	} else if (flags & MIRROR_BY_LV) {
> 		if (!mirrors)
> -			return add_mirror_log(cmd, lv, log_count,
> -					      region_size, pvs, alloc);
> -		return add_mirror_images(cmd, lv, mirrors,
> -					 stripes, region_size,
> -					 pvs, alloc, log_count);
> +			return add_mirror_log(cmd, lv, seg_type, log_count,
> +					      region_size, pvs, alloc, mirrors,
> +				              stripes, stripe_size, mirrored_log);
> +		return add_mirror_images(cmd, lv, seg_type, mirrors,
> +					 stripes, stripe_size, region_size,
> +					 pvs, alloc, log_count,
> +					 mirrored_log);
> 	}
>
> 	log_error("Unsupported mirror conversion type");
> diff -r c70315774a35 tools/args.h
> --- a/tools/args.h	Tue Sep 15 12:08:46 2009 -0700
> +++ b/tools/args.h	Tue Sep 22 19:51:15 2009 -0700
> @@ -45,6 +45,7 @@
> arg(alloc_ARG, '\0', "alloc", alloc_arg, 0)
> arg(separator_ARG, '\0', "separator", string_arg, 0)
> arg(mirrorsonly_ARG, '\0', "mirrorsonly", NULL, 0)
> +arg(mirroredlog_ARG, '\0', "mirroredlog", NULL, 0)
> arg(nosync_ARG, '\0', "nosync", NULL, 0)
> arg(resync_ARG, '\0', "resync", NULL, 0)
> arg(corelog_ARG, '\0', "corelog", NULL, 0)
> diff -r c70315774a35 tools/commands.h
> --- a/tools/commands.h	Tue Sep 15 12:08:46 2009 -0700
> +++ b/tools/commands.h	Tue Sep 22 19:51:15 2009 -0700
> @@ -95,8 +95,7 @@
>    "Change logical volume layout",
>    0,
>    "lvconvert "
> -   "[-m|--mirrors Mirrors [{--mirrorlog {disk|core}|--corelog}]]\n"
> -   "\t[--repair [--use-policies]]\n"
> +   "[-m|--mirrors Mirrors [{--mirrorlog {disk|core}|--corelog|-- 
> mirroredlog}]]\n"
>    "\t[-R|--regionsize MirrorLogRegionSize]\n"
>    "\t[--alloc AllocationPolicy]\n"
>    "\t[-b|--background]\n"
> @@ -122,7 +121,7 @@
>    "\tOriginalLogicalVolume[Path] SnapshotLogicalVolume[Path]\n",
>
>    alloc_ARG, background_ARG, chunksize_ARG, corelog_ARG,  
> interval_ARG,
> -   mirrorlog_ARG, mirrors_ARG, noudevsync_ARG, regionsize_ARG,  
> repair_ARG,
> +   mirrorlog_ARG, mirrors_ARG, noudevsync_ARG, regionsize_ARG,  
> repair_ARG, mirroredlog_ARG,
>    snapshot_ARG, test_ARG, use_policies_ARG, yes_ARG, force_ARG,  
> zero_ARG)
>
> xx(lvcreate,
> @@ -139,7 +138,7 @@
>    "\t{-l|--extents LogicalExtentsNumber |\n"
>    "\t -L|--size LogicalVolumeSize[bBsSkKmMgGtTpPeE]}\n"
>    "\t[-M|--persistent {y|n}] [--major major] [--minor minor]\n"
> -   "\t[-m|--mirrors Mirrors [--nosync] [{--mirrorlog {disk|core}|-- 
> corelog}]]\n"
> +   "\t[-m|--mirrors Mirrors [--nosync] [{--mirrorlog {disk|core}|-- 
> corelog|--mirroredlog}]]\n"
>    "\t[-n|--name LogicalVolumeName]\n"
>    "\t[--noudevsync]\n"
>    "\t[-p|--permission {r|rw}]\n"
> @@ -173,9 +172,9 @@
>    "\t[-t|--test]\n"
>    "\t[-v|--verbose]\n"
>    "\t[--version]\n"
> +   "\tOriginalLogicalVolume[Path] [PhysicalVolumePath...]\n\n",
>
> -   "\t[PhysicalVolumePath...]\n\n",
> -
> +   mirroredlog_ARG,
>    addtag_ARG, alloc_ARG, autobackup_ARG, chunksize_ARG,  
> contiguous_ARG,
>    corelog_ARG, extents_ARG, major_ARG, minor_ARG, mirrorlog_ARG,  
> mirrors_ARG,
>    name_ARG, nosync_ARG, noudevsync_ARG, permission_ARG,  
> persistent_ARG,
> diff -r c70315774a35 tools/lvconvert.c
> --- a/tools/lvconvert.c	Tue Sep 15 12:08:46 2009 -0700
> +++ b/tools/lvconvert.c	Tue Sep 22 19:51:15 2009 -0700
> @@ -31,6 +31,7 @@
> 	uint32_t region_size;
>
> 	uint32_t mirrors;
> +	uint32_t mirrored_log;
> 	sign_t mirrors_sign;
>
> 	struct segment_type *segtype;
> @@ -507,13 +508,16 @@
> 			       int corelog)
> {
> 	struct logical_volume *original_lv = _original_lv(lv);
> +
> 	if (_using_corelog(lv) && !corelog) {
> -		if (!add_mirror_log(cmd, original_lv, 1,
> +		if (!add_mirror_log(cmd, original_lv, lp->segtype, 1,
> 				    adjusted_mirror_region_size(
> 					lv->vg->extent_size,
> 					lv->le_count,
> 					lp->region_size),
> -				    lp->pvh, lp->alloc))
> +				    lp->pvh, lp->alloc,
> +				    lp->mirrors, 0, 0,
> +				    lp->mirrored_log))
> 			return_0;
> 	} else if (!_using_corelog(lv) && corelog) {
> 		if (!remove_mirror_log(cmd, original_lv,
> @@ -538,6 +542,8 @@
> 	int repair = arg_count(cmd, repair_ARG);
> 	int replace_log = 1, replace_mirrors = 1;
>
> +	lp->mirrored_log = arg_count(cmd, mirroredlog_ARG);
> +
> 	seg = first_seg(lv);
> 	existing_mirrors = lv_mirror_count(lv);
>
> @@ -696,13 +702,13 @@
> 		 * currently taken by the mirror? Would make more sense from
> 		 * user perspective.
> 		 */
> -		if (!lv_add_mirrors(cmd, lv, lp->mirrors - 1, 1,
> +		if (!lv_add_mirrors(cmd, lv, lp->segtype, lp->mirrors - 1, 1, 0,
> 				    adjusted_mirror_region_size(
> 						lv->vg->extent_size,
> 						lv->le_count,
> 						lp->region_size),
> 				    corelog ? 0U : 1U, lp->pvh, lp->alloc,
> -				    MIRROR_BY_LV))
> +				    MIRROR_BY_LV, lp->mirrored_log))
> 			return_0;
> 		if (lp->wait_completion)
> 			lp->need_polling = 1;
> @@ -726,13 +732,13 @@
> 			return 0;
> 		}
> 		/* FIXME: can't have multiple mlogs. force corelog. */
> -		if (!lv_add_mirrors(cmd, lv, lp->mirrors - existing_mirrors, 1,
> +		if (!lv_add_mirrors(cmd, lv, lp->segtype, lp->mirrors -  
> existing_mirrors, 1, 0,
> 				    adjusted_mirror_region_size(
> 						lv->vg->extent_size,
> 						lv->le_count,
> 						lp->region_size),
> 				    0U, lp->pvh, lp->alloc,
> -				    MIRROR_BY_LV))
> +				    MIRROR_BY_LV, lp->mirrored_log))
> 			return_0;
> 		lv->status |= CONVERTING;
> 		lp->need_polling = 1;
> @@ -743,6 +749,7 @@
> 			if (!_lv_update_log_type(cmd, lp, lv, corelog))
> 				return_0;
> 		} else {
> +			/*malahal this needs rework...*/
> 			log_error("Logical volume %s already has %"
> 				  PRIu32 " mirror(s).", lv->name,
> 				  lp->mirrors - 1);
> diff -r c70315774a35 tools/lvcreate.c
> --- a/tools/lvcreate.c	Tue Sep 15 12:08:46 2009 -0700
> +++ b/tools/lvcreate.c	Tue Sep 22 19:51:15 2009 -0700
> @@ -367,6 +367,9 @@
> 		lp->region_size = region_size;
> 	}
>
> +	if (arg_count(cmd, mirroredlog_ARG))
> +		lp->mirrored_log = 1;
> +
> 	if (!_validate_mirror_params(cmd, lp))
> 		return 0;
>
> diff -r c70315774a35 tools/pvmove.c
> --- a/tools/pvmove.c	Tue Sep 15 12:08:46 2009 -0700
> +++ b/tools/pvmove.c	Tue Sep 22 19:51:15 2009 -0700
> @@ -244,8 +244,8 @@
> 		return NULL;
> 	}
>
> -	if (!lv_add_mirrors(cmd, lv_mirr, 1, 1, 0, log_count,
> -			    allocatable_pvs, alloc, MIRROR_BY_SEG)) {
> +	if (!lv_add_mirrors(cmd, lv_mirr, NULL, 1u, 1u, 0u, 0u, log_count,
> +			    allocatable_pvs, alloc, MIRROR_BY_SEG, 0)) {
> 		log_error("Failed to convert pvmove LV to mirrored");
> 		return_NULL;
> 	}
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
