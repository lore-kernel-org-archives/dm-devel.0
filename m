From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH]multipath-tools: Re-ordering of child paths
 in priority group for round-robin path selector
Date: Thu, 20 Feb 2014 23:33:42 +0100
Message-ID: <CABr-Gnd_iFSfJ9QLGEQhyPCzYH_-XSeOG6wWG6Qqc9Q6JToEvQ@mail.gmail.com>
References: <FB8A412F33166C4A930D37BD63236C902AD67628@SACEXCMBX02-PRD.hq.netapp.com>
	<CABr-Gne9CWzhfdorKWPM7o=N+HizpkamTDi=K+qUr2_CbvuKWA@mail.gmail.com>
	<FB8A412F33166C4A930D37BD63236C902AD6793A@SACEXCMBX02-PRD.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <FB8A412F33166C4A930D37BD63236C902AD6793A@SACEXCMBX02-PRD.hq.netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Merla, ShivaKrishna" <ShivaKrishna.Merla@netapp.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Yes, you are right. The added information might not be worth the extra
allocation in the global vector entries, especially now that
round-robin is not even the default selector anymore.

On Thu, Feb 20, 2014 at 6:55 PM, Merla, ShivaKrishna
<ShivaKrishna.Merla@netapp.com> wrote:
>> -----Original Message-----
>> From: christophe.varoqui@gmail.com
>> [mailto:christophe.varoqui@gmail.com] On Behalf Of Christophe Varoqui
>> Sent: Thursday, February 20, 2014 12:58 AM
>> To: Merla, ShivaKrishna
>> Cc: dm-devel@redhat.com; hare@suse.de
>> Subject: Re: [PATCH]multipath-tools: Re-ordering of child paths in priority
>> group for round-robin path selector
>>
>> Interesting work indeed.
>> With all this new information gathered, it would be nice to have new
>> 'show' wildcards to report it.
>
> Hi Christophe, thanks for your inputs. I'm not sure if users are interested in
> PCI information to be displayed. We gather the info dynamically to group
> paths and reorder and currently we don't store this information in global
> vectors or path group structures in mp.  Also this will be needed for only
> round-robin path selector as others will select paths in different order than
> pushed by multipath. So having "show" wildcards to report this data might
> not be good idea. Let me know if you think of other way.
>>
>> best regards,
>> Christophe Varoqui
>> OpenSVC
>>
>> On Thu, Feb 20, 2014 at 12:25 AM, Merla, ShivaKrishna
>> <ShivaKrishna.Merla@netapp.com> wrote:
>> > The default Linux bus scanning order is depth first. Due to this default
>> > ordering of paths in priority group is by host. With round robin path selector
>> > this will lead to i/o clumping on each host controller and starvation on other
>> > host controller for certain duration before routing i/o to alternate one.
>> > Even with multiple LUNs sharing same host controllers, it will not yield flat
>> > evenly distributed i/o pattern. This will impact performance when more
>> than
>> > eight active paths are available per LUN. This will be even more worse
>> when
>> > repeat count is more than one.
>> >
>> > This patch addresses this issue by re-ordering paths in priority group by
>> > alternate host ports and even PCI adapters. This re-ordering is only
>> necessary
>> > for round-robin path selector. We have observed better IOPS and
>> Throughput with
>> > this crafted ordering of paths.
>> >
>> > Paths belonging to same host are grouped into host groups and hosts from
>> same
>> > adapter are grouped into adapter groups. Later paths are selected to yield
>> > crafted order to help route i/o to alternate host ports and adapters
>> available
>> > within priority group of LUN.
>> >
>> > Signed-off-by: Shiva Krishna Merla<shivakrishna.merla@netapp.com>
>> > Reviewed-by: Krishnasamy
>> Somasundaram<somasundaram.krishnasamy@netapp.com>
>> > ---
>> >  libmultipath/configure.c |  224
>> ++++++++++++++++++++++++++++++++++++++++++++++
>> >  libmultipath/discovery.c |   87 ++++++++++++++++++
>> >  libmultipath/structs.c   |   84 +++++++++++++++++
>> >  libmultipath/structs.h   |   25 +++++-
>> >  4 files changed, 419 insertions(+), 1 deletions(-)
>> >
>> > diff --git a/libmultipath/configure.c b/libmultipath/configure.c
>> > index 8c09791..74e5a0b 100644
>> > --- a/libmultipath/configure.c
>> > +++ b/libmultipath/configure.c
>> > @@ -39,6 +39,214 @@
>> >  #include "uxsock.h"
>> >  #include "wwids.h"
>> >
>> > +/* group paths in pg by host adapter
>> > + */
>> > +int group_by_host_adapter(struct pathgroup *pgp, vector adapters)
>> > +{
>> > +       struct adapter_group *agp;
>> > +       struct host_group *hgp;
>> > +       struct path *pp, *pp1;
>> > +       char adapter_name1[SLOT_NAME_SIZE];
>> > +       char adapter_name2[SLOT_NAME_SIZE];
>> > +       int i, j;
>> > +       int found_hostgroup = 0;
>> > +
>> > +       while (VECTOR_SIZE(pgp->paths) > 0) {
>> > +
>> > +               pp = VECTOR_SLOT(pgp->paths, 0);
>> > +
>> > +               if (sysfs_get_host_adapter_name(pp, adapter_name1))
>> > +                       return 1;
>> > +               /* create a new host adapter group
>> > +                */
>> > +               agp = alloc_adaptergroup();
>> > +               if (!agp)
>> > +                       goto out;
>> > +               agp->pgp = pgp;
>> > +
>> > +               strncpy(agp->adapter_name, adapter_name1,
>> SLOT_NAME_SIZE);
>> > +               store_adaptergroup(adapters, agp);
>> > +
>> > +               /* create a new host port group
>> > +                */
>> > +               hgp = alloc_hostgroup();
>> > +               if (!hgp)
>> > +                       goto out;
>> > +               if (store_hostgroup(agp->host_groups, hgp))
>> > +                       goto out;
>> > +
>> > +               hgp->host_no = pp->sg_id.host_no;
>> > +               agp->num_hosts++;
>> > +               if (store_path(hgp->paths, pp))
>> > +                       goto out;
>> > +
>> > +               hgp->num_paths++;
>> > +               /* delete path from path group
>> > +                */
>> > +               vector_del_slot(pgp->paths, 0);
>> > +
>> > +               /* add all paths belonging to same host adapter
>> > +                */
>> > +               vector_foreach_slot(pgp->paths, pp1, i) {
>> > +                       if (sysfs_get_host_adapter_name(pp1, adapter_name2))
>> > +                               goto out;
>> > +                       if (strcmp(adapter_name1, adapter_name2) == 0) {
>> > +                               found_hostgroup = 0;
>> > +                               vector_foreach_slot(agp->host_groups, hgp, j) {
>> > +                                       if (hgp->host_no == pp1->sg_id.host_no) {
>> > +                                               if (store_path(hgp->paths, pp1))
>> > +                                                       goto out;
>> > +                                               hgp->num_paths++;
>> > +                                               found_hostgroup = 1;
>> > +                                               break;
>> > +                                       }
>> > +                               }
>> > +                               if (!found_hostgroup) {
>> > +                                       /* this path belongs to new host port
>> > +                                        * within this adapter
>> > +                                        */
>> > +                                       hgp = alloc_hostgroup();
>> > +                                       if (!hgp)
>> > +                                               goto out;
>> > +
>> > +                                       if (store_hostgroup(agp->host_groups, hgp))
>> > +                                               goto out;
>> > +
>> > +                                       agp->num_hosts++;
>> > +                                       if (store_path(hgp->paths, pp1))
>> > +                                               goto out;
>> > +
>> > +                                       hgp->host_no = pp1->sg_id.host_no;
>> > +                                       hgp->num_paths++;
>> > +                               }
>> > +                               /* delete paths from original path_group
>> > +                                * as they are added into adapter group now
>> > +                                */
>> > +                               vector_del_slot(pgp->paths, i);
>> > +                               i--;
>> > +                       }
>> > +               }
>> > +       }
>> > +       return 0;
>> > +
>> > +out:   /* add back paths into pg as re-ordering failed
>> > +        */
>> > +       vector_foreach_slot(adapters, agp, i) {
>> > +                       vector_foreach_slot(agp->host_groups, hgp, j) {
>> > +                               while (VECTOR_SIZE(hgp->paths) > 0) {
>> > +                                       pp = VECTOR_SLOT(hgp->paths, 0);
>> > +                                       if (store_path(pgp->paths, pp))
>> > +                                               condlog(3, "failed to restore "
>> > +                                               "path %s into path group",
>> > +                                                pp->dev);
>> > +                                       vector_del_slot(hgp->paths, 0);
>> > +                               }
>> > +                       }
>> > +               }
>> > +       free_adaptergroup(adapters);
>> > +       return 1;
>> > +}
>> > +
>> > +/* re-order paths in pg by alternating adapters and host ports
>> > + * for optimized selection
>> > + */
>> > +int order_paths_in_pg_by_alt_adapters(struct pathgroup *pgp, vector
>> adapters,
>> > +                int total_paths)
>> > +{
>> > +       int next_adapter_index = 0;
>> > +       int num_adapters = 0;
>> > +       struct adapter_group *agp;
>> > +       struct host_group *hgp;
>> > +       struct path *pp;
>> > +
>> > +       num_adapters = VECTOR_SIZE(adapters);
>> > +
>> > +       while (total_paths > 0) {
>> > +               agp = VECTOR_SLOT(adapters, next_adapter_index);
>> > +
>> > +               hgp = VECTOR_SLOT(agp->host_groups, agp->next_host_index);
>> > +
>> > +               if (!hgp->num_paths) {
>> > +                       agp->next_host_index++;
>> > +                       agp->next_host_index %= agp->num_hosts;
>> > +                       next_adapter_index++;
>> > +                       next_adapter_index %= VECTOR_SIZE(adapters);
>> > +                       continue;
>> > +               }
>> > +
>> > +               pp  = VECTOR_SLOT(hgp->paths, 0);
>> > +
>> > +               if (store_path(pgp->paths, pp))
>> > +                       return 1;
>> > +
>> > +               total_paths--;
>> > +
>> > +               vector_del_slot(hgp->paths, 0);
>> > +
>> > +               hgp->num_paths--;
>> > +
>> > +               agp->next_host_index++;
>> > +               agp->next_host_index %= agp->num_hosts;
>> > +               next_adapter_index++;
>> > +               next_adapter_index %= VECTOR_SIZE(adapters);
>> > +       }
>> > +
>> > +       /* all paths are added into path_group
>> > +        * in crafted child order
>> > +        */
>> > +       return 0;
>> > +}
>> > +
>> > +/* round-robin: order paths in path group to alternate
>> > + * between all host adapters
>> > + */
>> > +int rr_optimize_path_order(struct pathgroup *pgp)
>> > +{
>> > +       vector adapters;
>> > +       struct path *pp;
>> > +       int total_paths;
>> > +       int i;
>> > +
>> > +       total_paths = VECTOR_SIZE(pgp->paths);
>> > +       vector_foreach_slot(pgp->paths, pp, i) {
>> > +               if (pp->sg_id.proto_id != SCSI_PROTOCOL_FCP ||
>> > +                       pp->sg_id.proto_id != SCSI_PROTOCOL_SAS ||
>> > +                       pp->sg_id.proto_id != SCSI_PROTOCOL_ISCSI ||
>> > +                       pp->sg_id.proto_id != SCSI_PROTOCOL_SRP) {
>> > +                       /* return success as default path order
>> > +                        * is maintained in path group
>> > +                        */
>> > +                       return 0;
>> > +               }
>> > +       }
>> > +       adapters = vector_alloc();
>> > +       if (!adapters)
>> > +               return 0;
>> > +
>> > +       /* group paths in path group by host adapters
>> > +        */
>> > +       if (group_by_host_adapter(pgp, adapters)) {
>> > +               condlog(3, "Failed to group paths by adapters");
>> > +               free_adaptergroup(adapters);
>> > +               return 0;
>> > +       }
>> > +
>> > +       /* re-order paths in pg to alternate between adapters and host ports
>> > +        */
>> > +       if (order_paths_in_pg_by_alt_adapters(pgp, adapters, total_paths)) {
>> > +               condlog(3, "Failed to re-order paths in pg by adapters "
>> > +                       "and host ports");
>> > +               free_adaptergroup(adapters);
>> > +               /* return failure as original paths are
>> > +                * removed form pgp
>> > +                */
>> > +               return 1;
>> > +       }
>> > +
>> > +       free_adaptergroup(adapters);
>> > +       return 0;
>> > +}
>> > +
>> >  extern int
>> >  setup_map (struct multipath * mpp, char * params, int params_size)
>> >  {
>> > @@ -100,6 +308,22 @@ setup_map (struct multipath * mpp, char *
>> params, int params_size)
>> >          */
>> >         mpp->bestpg = select_path_group(mpp);
>> >
>> > +       /* re-order paths in all path groups in an optimized way
>> > +        * for round-robin path selectors to get maximum throughput.
>> > +        */
>> > +       if (!strncmp(mpp->selector, "round-robin", 11)) {
>> > +               vector_foreach_slot(mpp->pg, pgp, i) {
>> > +                       if (VECTOR_SIZE(pgp->paths) <= 2)
>> > +                               continue;
>> > +                       if (rr_optimize_path_order(pgp)) {
>> > +                               condlog(2, "cannot re-order paths for "
>> > +                                       "optimization: %s",
>> > +                                       mpp->alias);
>> > +                               return 1;
>> > +                       }
>> > +               }
>> > +       }
>> > +
>> >         /*
>> >          * transform the mp->pg vector of vectors of paths
>> >          * into a mp->params strings to feed the device-mapper
>> > diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
>> > index 228ffd3..b88edd5 100644
>> > --- a/libmultipath/discovery.c
>> > +++ b/libmultipath/discovery.c
>> > @@ -317,6 +317,93 @@ sysfs_get_tgt_nodename (struct path *pp, char *
>> node)
>> >         return 1;
>> >  }
>> >
>> > +int sysfs_get_host_adapter_name(struct path *pp, char *adapter_name)
>> > +{
>> > +       int proto_id;
>> > +
>> > +       if (!pp || !adapter_name)
>> > +               return 1;
>> > +
>> > +       proto_id = pp->sg_id.proto_id;
>> > +
>> > +       if (proto_id != SCSI_PROTOCOL_FCP ||
>> > +           proto_id != SCSI_PROTOCOL_SAS ||
>> > +           proto_id != SCSI_PROTOCOL_ISCSI ||
>> > +           proto_id != SCSI_PROTOCOL_SRP) {
>> > +               return 1;
>> > +       }
>> > +       /* iscsi doesn't have adapter info in sysfs
>> > +        * get ip_address for grouping paths
>> > +        */
>> > +       if (pp->sg_id.proto_id == SCSI_PROTOCOL_ISCSI)
>> > +               return sysfs_get_iscsi_ip_address(pp, adapter_name);
>> > +
>> > +       /* fetch adapter pci name for other protocols
>> > +        */
>> > +       return sysfs_get_host_pci_name(pp, adapter_name);
>> > +}
>> > +
>> > +int sysfs_get_host_pci_name(struct path *pp, char *pci_name)
>> > +{
>> > +       struct udev_device *hostdev, *parent;
>> > +       char host_name[HOST_NAME_LEN];
>> > +       char *driver_name, *value;
>> > +
>> > +       if (!pp || !pci_name)
>> > +               return 1;
>> > +
>> > +       sprintf(host_name, "host%d", pp->sg_id.host_no);
>> > +       hostdev = udev_device_new_from_subsystem_sysname(conf-
>> >udev,
>> > +                       "scsi_host", host_name);
>> > +       if (!hostdev)
>> > +               return 1;
>> > +
>> > +       parent = udev_device_get_parent(hostdev);
>> > +       while (parent) {
>> > +               driver_name = udev_device_get_driver(parent);
>> > +               if (!driver_name) {
>> > +                       parent = udev_device_get_parent(parent);
>> > +                       continue;
>> > +               }
>> > +               if (!strcmp(driver_name, "pcieport"))
>> > +                       break;
>> > +               parent = udev_device_get_parent(parent);
>> > +       }
>> > +       if (parent) {
>> > +               /* pci_device found
>> > +                */
>> > +               value = udev_device_get_sysname(parent);
>> > +
>> > +               strncpy(pci_name, value, SLOT_NAME_SIZE);
>> > +               udev_device_unref(hostdev);
>> > +               return 0;
>> > +       }
>> > +       udev_device_unref(hostdev);
>> > +       return 1;
>> > +}
>> > +
>> > +int sysfs_get_iscsi_ip_address(struct path *pp, char *ip_address)
>> > +{
>> > +       struct udev_device *hostdev;
>> > +       char host_name[HOST_NAME_LEN];
>> > +       char *value;
>> > +
>> > +       sprintf(host_name, "host%d", pp->sg_id.host_no);
>> > +       hostdev = udev_device_new_from_subsystem_sysname(conf-
>> >udev,
>> > +                       "iscsi_host", host_name);
>> > +       if (hostdev) {
>> > +               value = udev_device_get_sysattr_value(hostdev,
>> > +                               "ip_address");
>> > +               if (value) {
>> > +                       strncpy(ip_address, value, SLOT_NAME_SIZE);
>> > +                       udev_device_unref(hostdev);
>> > +                       return 0;
>> > +               } else
>> > +                       udev_device_unref(hostdev);
>> > +       }
>> > +       return 1;
>> > +}
>> > +
>> >  static void
>> >  sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
>> >  {
>> > diff --git a/libmultipath/structs.c b/libmultipath/structs.c
>> > index 049f17d..30d247d 100644
>> > --- a/libmultipath/structs.c
>> > +++ b/libmultipath/structs.c
>> > @@ -18,6 +18,70 @@
>> >  #include "blacklist.h"
>> >  #include "prio.h"
>> >
>> > +struct adapter_group *
>> > +alloc_adaptergroup(void)
>> > +{
>> > +       struct adapter_group *agp;
>> > +
>> > +       agp = (struct adapter_group *)MALLOC(sizeof(struct adapter_group));
>> > +
>> > +       if (!agp)
>> > +               return NULL;
>> > +
>> > +       agp->host_groups = vector_alloc();
>> > +       if (!agp->host_groups) {
>> > +               FREE(agp);
>> > +               agp = NULL;
>> > +       }
>> > +       return agp;
>> > +}
>> > +
>> > +void free_adaptergroup(vector adapters)
>> > +{
>> > +       int i;
>> > +       struct adapter_group *agp;
>> > +
>> > +       vector_foreach_slot(adapters, agp, i) {
>> > +               free_hostgroup(agp->host_groups);
>> > +               FREE(agp);
>> > +       }
>> > +       vector_free(adapters);
>> > +}
>> > +
>> > +void free_hostgroup(vector hostgroups)
>> > +{
>> > +       int i;
>> > +       struct host_group *hgp;
>> > +
>> > +       if (!hostgroups)
>> > +               return;
>> > +
>> > +       vector_foreach_slot(hostgroups, hgp, i) {
>> > +               vector_free(hgp->paths);
>> > +               FREE(hgp);
>> > +       }
>> > +       vector_free(hostgroups);
>> > +}
>> > +
>> > +struct host_group *
>> > +alloc_hostgroup(void)
>> > +{
>> > +       struct host_group *hgp;
>> > +
>> > +       hgp = (struct host_group *)MALLOC(sizeof(struct host_group));
>> > +
>> > +       if (!hgp)
>> > +               return NULL;
>> > +
>> > +       hgp->paths = vector_alloc();
>> > +
>> > +       if (!hgp->paths) {
>> > +               FREE(hgp);
>> > +               hgp = NULL;
>> > +       }
>> > +       return hgp;
>> > +}
>> > +
>> >  struct path *
>> >  alloc_path (void)
>> >  {
>> > @@ -242,6 +306,26 @@ store_pathgroup (vector pgvec, struct pathgroup *
>> pgp)
>> >         return 0;
>> >  }
>> >
>> > +int
>> > +store_hostgroup(vector hostgroupvec, struct host_group * hgp)
>> > +{
>> > +       if (!vector_alloc_slot(hostgroupvec))
>> > +               return 1;
>> > +
>> > +       vector_set_slot(hostgroupvec, hgp);
>> > +       return 0;
>> > +}
>> > +
>> > +int
>> > +store_adaptergroup(vector adapters, struct adapter_group * agp)
>> > +{
>> > +       if (!vector_alloc_slot(adapters))
>> > +               return 1;
>> > +
>> > +       vector_set_slot(adapters, agp);
>> > +       return 0;
>> > +}
>> > +
>> >  struct multipath *
>> >  find_mp_by_minor (vector mpvec, int minor)
>> >  {
>> > diff --git a/libmultipath/structs.h b/libmultipath/structs.h
>> > index 64de06e..772a7d7 100644
>> > --- a/libmultipath/structs.h
>> > +++ b/libmultipath/structs.h
>> > @@ -15,7 +15,8 @@
>> >  #define BLK_DEV_SIZE           33
>> >  #define PATH_SIZE              512
>> >  #define NAME_SIZE              512
>> > -
>> > +#define HOST_NAME_LEN          8
>> > +#define SLOT_NAME_SIZE         32
>> >
>> >  #define SCSI_VENDOR_SIZE       9
>> >  #define SCSI_PRODUCT_SIZE      17
>> > @@ -251,6 +252,20 @@ struct pathgroup {
>> >         char * selector;
>> >  };
>> >
>> > +struct adapter_group {
>> > +       char adapter_name[SLOT_NAME_SIZE];
>> > +       struct pathgroup *pgp;
>> > +       int num_hosts;
>> > +       vector host_groups;
>> > +       int next_host_index;
>> > +};
>> > +
>> > +struct host_group {
>> > +       int host_no;
>> > +       int num_paths;
>> > +       vector paths;
>> > +};
>> > +
>> >  struct path * alloc_path (void);
>> >  struct pathgroup * alloc_pathgroup (void);
>> >  struct multipath * alloc_multipath (void);
>> > @@ -263,6 +278,14 @@ void free_multipath_attributes (struct multipath
>> *);
>> >  void drop_multipath (vector mpvec, char * wwid, enum free_path_mode
>> free_paths);
>> >  void free_multipathvec (vector mpvec, enum free_path_mode
>> free_paths);
>> >
>> > +struct adapter_group * alloc_adaptergroup(void);
>> > +struct host_group * alloc_hostgroup(void);
>> > +void free_adaptergroup(vector adapters);
>> > +void free_hostgroup(vector hostgroups);
>> > +
>> > +int store_adaptergroup(vector adapters, struct adapter_group *agp);
>> > +int store_hostgroup(vector hostgroupvec, struct host_group *hgp);
>> > +
>> >  int store_path (vector pathvec, struct path * pp);
>> >  int store_pathgroup (vector pgvec, struct pathgroup * pgp);
>> > --
