From: "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>
Subject: RE: [RFC] New  Logging approach for Device Mapper
Date: Tue, 22 Sep 2009 11:15:20 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C1C8ECC2CFF@inbmail01.lsi.com>
References: <0D1E8821739E724A86F4D16902CE275C1C8ECC2CE0@inbmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <0D1E8821739E724A86F4D16902CE275C1C8ECC2CE0@inbmail01.lsi.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "agk@redhat.com" <agk@redhat.com>, device-mapper development <dm-devel@redhat.com>
Cc: "sekharan@linux.vnet.ibm.com" <sekharan@linux.vnet.ibm.com>, "Moger,
	Babu" <Babu.Moger@lsi.com>
List-Id: dm-devel.ids


On Mon, Sep 7, 2009 at 12:58 PM, Chauhan, Vijay <Vijay.Chauhan@lsi.com> w=
rote:
> > > Each logging type is represented with 2 bits in
> > dm_logging_level. Following are the logging types currently
> defined :
> >
> > Does that mean there's a limit we'll soon exceed?
>
>
> Yes true. In that case we can further split the logging
> across the targets , such as multipath, linear so on. Your
> thoughts please.
>
>
> >
> > > Sep  5 18:32:02 localhost kernel: device-mapper: core:
> > DEBUG: dm_resume: Unsetting DMF_SUSPENDED flag for 253:1
> >
> > I was hoping the next extension to the macro code would
> > somehow add info
> > like '253:1' (and maybe corresponding device name) automatically to
> > every message related to a device.
> >
>
>
> Ok. I will so that.
>
>
> >
> > But do we really need this level of runtime debugging
> configurability?
> > I can't say I've come across problems where I'd have needed it: Can
> > anyone else offer examples where it would have helped them?
> >
>
>
> Both approaches ("without level" and "with level") looks fine
> to me. Advantage with going for "Without level" approach is
> that we will be having further more space for defining log types.
>
> Advantage with "with level" approach is that it will log more
> relevant logs. Just giving a hypothetical example here, Lets
> assume I/O getting killed during all path failure condition
> when no_path_retry feature was set. To debug that I may want
> to check what all messages communicated from userspace to
> kernel. Also I may want to check DM_NOFLUSH_FLAG being set
> properly here. For the same I would set following log levels:
>
> ---------------------------
> LOG TYPES               LOG LEVEL
> ----------------------------
> DM_IOCTL                DM_INFO       --> It will print all
> the communication between userspace and kernel space
> DM_IO                   DM_ERR        --> It will tell
> exactly where I/O error was hit.
>
>
> "without level" approach in this scenario will log more
> messages here in comparison.
>
> Third approach I could think of it is having flexible level.
> i.e we can ignore levels for those types which populates
> syslog less(such as DM_INIT, DM_FAILOVER ..) and can have
> levels for those which are logging heavily (such as DM_IO,
> DM_IOCTL .. ). But it may add some complexity in calculating
> and setting the log levels.

Hi Alasdair,

I have made the changes for printing device name with the log messages wh=
ere ever it was needed. As dm-mpath.c does not have access to mapped_devi=
ce structure, I had to add one new function dm_target_device_name in dm.c=
 to get the device name. Also I have added #ifdef in dm-mpath.c such that=
 dm_target_device_name function is called only in case when CONFIG_DM_DEB=
UG is set in .config. Current implementaion needs developer to add device=
 name in order to print it as I didnt find any consistent way to print de=
vice name(by adding in macro). For example :

Following messages prints device name as "253:12"

Sep 22 00:31:26 localhost kernel: device-mapper: multipath: DEBUG: __swit=
ch_pg: 253:12: Swtiching to pathgroup 1

where as in ctl_ioctl function, device name is available with respect to =
its WWN name and I didn't find way to print in major/minor. Please correc=
t me if I am wrong here. Also if you have any better thoughts then please=
 let me know.

Sep 22 00:31:26 localhost kernel: device-mapper: ioctl: DEBUG: ctl_ioctl:=
 3600a0b80003908f9000057d44a83946c: IOCTL command 0xc138fd0c.

Thanks,
Vijay


---------------------------------------------------
Syslog snippet after the changes looks like below:
---------------------------------------------------
Sep 22 00:31:26 localhost kernel: device-mapper: multipath: DEBUG: __swit=
ch_pg: 253:12: Swtiching to pathgroup 1
Sep 22 00:31:26 localhost kernel: device-mapper: multipath: DEBUG: __choo=
se_path_in_pg: 253:12: Selecting path 8:224 for I/O
Sep 22 00:31:26 localhost kernel: device-mapper: multipath: DEBUG: fail_p=
ath: 253:12: Failing path 8:224
Sep 22 00:31:26 localhost kernel: device-mapper: ioctl: DEBUG: ctl_ioctl:=
 3600a0b80003908f9000057d44a83946c: IOCTL command 0xc138fd0c.
Sep 22 00:31:26 localhost kernel: device-mapper: ioctl: DEBUG: ctl_ioctl:=
 3600a0b80003908f9000057d44a83946c: IOCTL command 0xc138fd0c.
Sep 22 00:31:26 localhost kernel: device-mapper: ioctl: DEBUG: ctl_ioctl:=
 3600a0b80003908f9000057d44a83946c: IOCTL command 0xc138fd0e.
Sep 22 00:31:26 localhost kernel: device-mapper: multipath: DEBUG: reinst=
ate_path: 253:13: Path 8:240 sucessfuly reinstated
Sep 22 00:31:26 localhost kernel: device-mapper: ioctl: DEBUG: ctl_ioctl:=
 3600a0b80003908f9000057d44a83946c: IOCTL command 0xc138fd0e.
Sep 22 00:31:26 localhost kernel: device-mapper: multipath: DEBUG: deacti=
vate_path: Deactivating path. Aborting all I/O on 8:224 queue



Patch for dm logging, adding device name with log messages.
---

diff -uprN linux-2.6.31-rc8-orig/drivers/md/dm.c linux-2.6.31-rc8/drivers=
/md/dm.c
--- linux-2.6.31-rc8-orig/drivers/md/dm.c       2009-08-28 06:29:04.00000=
0000 +0530
+++ linux-2.6.31-rc8/drivers/md/dm.c    2009-09-22 01:17:45.000000000 +05=
30
@@ -23,6 +23,8 @@
 #include <trace/events/block.h>

 #define DM_MSG_PREFIX "core"
+unsigned int dm_logging_level;
+EXPORT_SYMBOL(dm_logging_level);

 /*
  * Cookies are numeric values sent with CHANGE and REMOVE
@@ -266,7 +268,7 @@ static void local_exit(void)

        _major =3D 0;

-       DMINFO("cleaned up");
+       DMLOG(DMLOG_INIT, DMLOG_INFO, "cleaned up");
 }

 static int (*_inits[])(void) __initdata =3D {
@@ -541,7 +543,8 @@ int dm_set_geometry(struct mapped_device
        sector_t sz =3D (sector_t)geo->cylinders * geo->heads * geo->sect=
ors;

        if (geo->start > sz) {
-               DMWARN("Start sector is beyond the geometry limits.");
+               DMLOG(DMLOG_ADD_DEV, DMLOG_WARN, "Start sector is beyond =
the "
+                       "geometry limits.");
                return -EINVAL;
        }

@@ -644,7 +647,8 @@ static void clone_endio(struct bio *bio,
                        /* The target will handle the io */
                        return;
                else if (r) {
-                       DMWARN("unimplemented target endio return value: =
%d", r);
+                       DMLOG(DMLOG_IO, DMLOG_WARN, "unimplemented target=
 endio"
+                               " return value: %d", r);
                        BUG();
                }
        }
@@ -699,7 +703,8 @@ static void end_clone_bio(struct bio *cl
         * If it's not, something wrong is happening.
         */
        if (tio->orig->bio !=3D bio)
-               DMERR("bio completion is going in the middle of the reque=
st");
+               DMLOG(DMLOG_IO, DMLOG_ERR, "bio completion is going in "
+                       "the middle of the request");

        /*
         * Update the original request.
@@ -856,7 +861,8 @@ static void dm_softirq_done(struct reque
                /* The target wants to requeue the I/O */
                dm_requeue_unmapped_request(clone);
        else {
-               DMWARN("unimplemented target endio return value: %d", err=
or);
+               DMLOG(DMLOG_IO, DMLOG_WARN, "unimplemented target endio r=
eturn"
+                       " value: %d", error);
                BUG();
        }
 }
@@ -971,7 +977,8 @@ static void __map_bio(struct dm_target *
                bio_put(clone);
                free_tio(md, tio);
        } else if (r) {
-               DMWARN("unimplemented target map return value: %d", r);
+               DMLOG(DMLOG_IO, DMLOG_WARN, "unimplemented target map "
+                       "return value: %d", r);
                BUG();
        }
 }
@@ -1446,7 +1453,8 @@ static int dm_prep_fn(struct request_que
        }

        if (unlikely(rq->special)) {
-               DMWARN("Already has something in rq->special.");
+               DMLOG(DMLOG_IO, DMLOG_WARN, "Already has something"
+                       " in rq->special.");
                return BLKPREP_KILL;
        }

@@ -1506,7 +1514,8 @@ static void map_request(struct dm_target
                break;
        default:
                if (r > 0) {
-                       DMWARN("unimplemented target map return value: %d=
", r);
+                       DMLOG(DMLOG_IO, DMLOG_WARN, "%s: unimplemented ta=
rget map"
+                               " return value: %d", md->name, r);
                        BUG();
                }

@@ -1723,7 +1732,8 @@ static struct mapped_device *alloc_dev(i
        void *old_md;

        if (!md) {
-               DMWARN("unable to allocate device, out of memory.");
+               DMLOG(DMLOG_INIT, DMLOG_WARN, "unable to allocate device(=
MINOR %d), "
+                       "out of memory.", minor);
                return NULL;
        }

@@ -2037,6 +2047,14 @@ const char *dm_device_name(struct mapped
 }
 EXPORT_SYMBOL_GPL(dm_device_name);

+void dm_target_device_name(struct dm_target *ti, char *name)
+{
+       struct mapped_device *md =3D dm_table_get_md(ti->table);
+       strncpy(name,dm_device_name(md), 16);
+       dm_put(md);
+}
+EXPORT_SYMBOL_GPL(dm_target_device_name);
+
 void dm_put(struct mapped_device *md)
 {
        struct dm_table *map;
@@ -2199,7 +2217,8 @@ int dm_swap_table(struct mapped_device *
        /* cannot change the device type, once a table is bound */
        if (md->map &&
            (dm_table_get_type(md->map) !=3D dm_table_get_type(table))) {
-               DMWARN("can't change the device type after a table is bou=
nd");
+               DMLOG(DMLOG_IO, DMLOG_WARN, "%s: can't change the device =
type "
+                       "after a table is bound", md->name);
                goto out;
        }

@@ -2263,8 +2282,9 @@ static int dm_rq_suspend_available(struc
                 * start another flush suspend while it is in use.
                 */
                BUG_ON(!rq->special); /* The marker should be invalidated=
 */
-               DMWARN("Invalidating the previous flush suspend is still =
in"
-                      " progress.  Please retry later.");
+               DMLOG(DMLOG_IO, DMLOG_WARN, "%s: Invalidating the previou=
s flush "
+                       "suspend is still in progress. Please retry later=
.",
+                       md->name);
                r =3D 0;
        }
        spin_unlock_irqrestore(q->queue_lock, flags);
@@ -2383,8 +2403,11 @@ int dm_suspend(struct mapped_device *md,
         * DMF_NOFLUSH_SUSPENDING must be set before presuspend.
         * This flag is cleared before dm_suspend returns.
         */
-       if (noflush)
+       if (noflush) {
                set_bit(DMF_NOFLUSH_SUSPENDING, &md->flags);
+               DMLOG(DMLOG_IOCTL, DMLOG_INFO, "%s: Setting DMF_NOFLUSH_S=
USPENDING "
+                       "flag", md->name);
+       }

        /* This does not get reverted if there's an error later. */
        dm_table_presuspend_targets(map);
@@ -2415,6 +2438,8 @@ int dm_suspend(struct mapped_device *md,
         * dm_wq_work exits and DMF_BLOCK_IO_FOR_SUSPEND will prevent any
         * further calls to __split_and_process_bio from dm_wq_work.
         */
+       DMLOG(DMLOG_IOCTL, DMLOG_INFO, "%s: Setting DMF_BLOCK_IO_FOR_SUSP=
END and "
+               "DMF_QUEUE_IO_TO_THREAD flags", md->name);
        down_write(&md->io_lock);
        set_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags);
        set_bit(DMF_QUEUE_IO_TO_THREAD, &md->flags);
@@ -2433,8 +2458,11 @@ int dm_suspend(struct mapped_device *md,
        r =3D dm_wait_for_completion(md, TASK_INTERRUPTIBLE);

        down_write(&md->io_lock);
-       if (noflush)
+       if (noflush) {
                clear_bit(DMF_NOFLUSH_SUSPENDING, &md->flags);
+               DMLOG(DMLOG_IOCTL, DMLOG_INFO, "%s: Unsetting "
+                       "DMF_NOFLUSH_SUSPENDING", md->name);
+       }
        up_write(&md->io_lock);

        /* were we interrupted ? */
@@ -2455,7 +2483,8 @@ int dm_suspend(struct mapped_device *md,
         */

        dm_table_postsuspend_targets(map);
-
+       DMLOG(DMLOG_IOCTL, DMLOG_INFO, "%s: Setting DMF_SUSPENDED flag",
+               md->name);
        set_bit(DMF_SUSPENDED, &md->flags);

 out:
@@ -2494,7 +2523,8 @@ int dm_resume(struct mapped_device *md)
                start_queue(md->queue);

        unlock_fs(md);
-
+       DMLOG(DMLOG_IOCTL, DMLOG_INFO, "%s: Unsetting DMF_SUSPENDED flag"=
,
+               md->name);
        clear_bit(DMF_SUSPENDED, &md->flags);

        dm_table_unplug_all(map);
@@ -2670,6 +2700,9 @@ EXPORT_SYMBOL(dm_get_mapinfo);
 module_init(dm_init);
 module_exit(dm_exit);

+module_param(dm_logging_level, uint, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(dm_logging_level, "a bit mask of logging levels");
+
 module_param(major, uint, 0);
 MODULE_PARM_DESC(major, "The major number of the device mapper");
 MODULE_DESCRIPTION(DM_NAME " driver");
diff -uprN linux-2.6.31-rc8-orig/drivers/md/dm-ioctl.c linux-2.6.31-rc8/d=
rivers/md/dm-ioctl.c
--- linux-2.6.31-rc8-orig/drivers/md/dm-ioctl.c 2009-08-28 06:29:04.00000=
0000 +0530
+++ linux-2.6.31-rc8/drivers/md/dm-ioctl.c      2009-09-22 01:17:47.00000=
0000 +0530
@@ -193,6 +193,7 @@ static int dm_hash_insert(const char *na
                dm_put(hc->md);
                goto bad;
        }
+       DMLOG(DMLOG_ADD_DEV, DMLOG_INFO, "%s: Inserting in hash table", n=
ame);

        list_add(&cell->name_list, _name_buckets + hash_str(name));

@@ -201,6 +202,8 @@ static int dm_hash_insert(const char *na
                if (hc) {
                        list_del(&cell->name_list);
                        dm_put(hc->md);
+                       DMLOG(DMLOG_ADD_DEV, DMLOG_CRIT, "%s: Failed to a=
dd."
+                               " Already exists in hash table", name);
                        goto bad;
                }
                list_add(&cell->uuid_list, _uuid_buckets + hash_str(uuid)=
);
@@ -208,7 +211,8 @@ static int dm_hash_insert(const char *na
        dm_get(md);
        dm_set_mdptr(md, cell);
        up_write(&_hash_lock);
-
+       DMLOG(DMLOG_ADD_DEV, DMLOG_INFO, "%s: Successfully inserted "
+               "in hash table ", name);
        return 0;

  bad:
@@ -269,8 +273,8 @@ retry:
        if (dev_skipped) {
                if (dev_removed)
                        goto retry;
-
-               DMWARN("remove_all left %d open device(s)", dev_skipped);
+               DMLOG(DMLOG_IOCTL, DMLOG_WARN, "remove_all left "
+                       "%d open device(s)", dev_skipped);
        }

        up_write(&_hash_lock);
@@ -296,8 +300,8 @@ static int dm_hash_rename(uint32_t cooki
         */
        hc =3D __get_name_cell(new);
        if (hc) {
-               DMWARN("asked to rename to an already existing name %s ->=
 %s",
-                      old, new);
+               DMLOG(DMLOG_IOCTL, DMLOG_WARN, "asked to rename to an "
+                       "already existing name %s -> %s", old, new);
                dm_put(hc->md);
                up_write(&_hash_lock);
                kfree(new_name);
@@ -309,8 +313,8 @@ static int dm_hash_rename(uint32_t cooki
         */
        hc =3D __get_name_cell(old);
        if (!hc) {
-               DMWARN("asked to rename a non existent device %s -> %s",
-                      old, new);
+               DMLOG(DMLOG_IOCTL, DMLOG_WARN, "asked to rename a non "
+                       "existent device %s -> %s", old, new);
                up_write(&_hash_lock);
                kfree(new_name);
                return -ENXIO;
@@ -517,7 +521,8 @@ static int list_versions(struct dm_ioctl
 static int check_name(const char *name)
 {
        if (strchr(name, '/')) {
-               DMWARN("invalid device name");
+               DMLOG(DMLOG_IOCTL, DMLOG_ERR, "%s: Invalid device name "
+                       , name);
                return -EINVAL;
        }

@@ -576,12 +581,16 @@ static int dev_create(struct dm_ioctl *p
        if (param->flags & DM_PERSISTENT_DEV_FLAG)
                m =3D MINOR(huge_decode_dev(param->dev));

+       DMLOG(DMLOG_ADD_DEV, DMLOG_INFO, "%s: Creating dm device",
+               param->name);
        r =3D dm_create(m, &md);
        if (r)
                return r;

        r =3D dm_hash_insert(param->name, *param->uuid ? param->uuid : NU=
LL, md);
        if (r) {
+               DMLOG(DMLOG_ADD_DEV, DMLOG_CRIT, "%s: Unable to create"
+                       "new device", param->name);
                dm_put(md);
                return r;
        }
@@ -660,7 +669,8 @@ static int dev_remove(struct dm_ioctl *p
        hc =3D __find_device_hash_cell(param);

        if (!hc) {
-               DMWARN("device doesn't appear to be in the dev hash table=
.");
+               DMLOG(DMLOG_IOCTL, DMLOG_WARN, "%s: Device doesn't appear=
 "
+                       "to be in the dev hash table.", param->name);
                up_write(&_hash_lock);
                return -ENXIO;
        }
@@ -672,7 +682,8 @@ static int dev_remove(struct dm_ioctl *p
         */
        r =3D dm_lock_for_deletion(md);
        if (r) {
-               DMWARN("unable to remove open device %s", hc->name);
+               DMLOG(DMLOG_IOCTL, DMLOG_WARN, "%s: Unable to remove open=
 "
+                       "device %s", hc->name);
                up_write(&_hash_lock);
                dm_put(md);
                return r;
@@ -709,7 +720,8 @@ static int dev_rename(struct dm_ioctl *p
        if (new_name < param->data ||
            invalid_str(new_name, (void *) param + param_size) ||
            strlen(new_name) > DM_NAME_LEN - 1) {
-               DMWARN("Invalid new logical volume name supplied.");
+               DMLOG(DMLOG_IOCTL, DMLOG_WARN, "%s: Invalid new logical "
+                       "volume name supplied.", param->name);
                return -EINVAL;
        }

@@ -735,7 +747,8 @@ static int dev_set_geometry(struct dm_io

        if (geostr < param->data ||
            invalid_str(geostr, (void *) param + param_size)) {
-               DMWARN("Invalid geometry supplied.");
+               DMLOG(DMLOG_IOCTL, DMLOG_WARN, "%s: Invalid geometry "
+                       "supplied.", param->name);
                goto out;
        }

@@ -743,13 +756,15 @@ static int dev_set_geometry(struct dm_io
                   indata + 1, indata + 2, indata + 3);

        if (x !=3D 4) {
-               DMWARN("Unable to interpret geometry settings.");
+               DMLOG(DMLOG_IOCTL, DMLOG_WARN, "%s: Unable to interpret "
+                       "geometry settings.", param->name);
                goto out;
        }

        if (indata[0] > 65535 || indata[1] > 255 ||
            indata[2] > 255 || indata[3] > ULONG_MAX) {
-               DMWARN("Geometry exceeds range limits.");
+               DMLOG(DMLOG_IOCTL, DMLOG_WARN, "%s: Geometry exceeds "
+                       "range limits.", param->name);
                goto out;
        }

@@ -806,7 +821,8 @@ static int do_resume(struct dm_ioctl *pa

        hc =3D __find_device_hash_cell(param);
        if (!hc) {
-               DMWARN("device doesn't appear to be in the dev hash table=
.");
+               DMLOG(DMLOG_IOCTL, DMLOG_WARN, "%s: device doesn't appear=
 to be "
+                       "in the dev hash table.", param->name);
                up_write(&_hash_lock);
                return -ENXIO;
        }
@@ -1026,7 +1042,8 @@ static int populate_table(struct dm_tabl
        char *target_params;

        if (!param->target_count) {
-               DMWARN("populate_table: no targets specified");
+               DMLOG(DMLOG_IOCTL, DMLOG_WARN, "%s: populate_table: no ta=
rgets"
+                       " specified", param->name);
                return -EINVAL;
        }

@@ -1034,7 +1051,8 @@ static int populate_table(struct dm_tabl

                r =3D next_target(spec, next, end, &spec, &target_params)=
;
                if (r) {
-                       DMWARN("unable to find target");
+                       DMLOG(DMLOG_IOCTL, DMLOG_WARN, "%s: unable to fin=
d target",
+                               param->name);
                        return r;
                }

@@ -1043,7 +1061,8 @@ static int populate_table(struct dm_tabl
                                        (sector_t) spec->length,
                                        target_params);
                if (r) {
-                       DMWARN("error adding target to table");
+                       DMLOG(DMLOG_IOCTL, DMLOG_WARN, "%s: error adding =
target "
+                               "to table", param->name);
                        return r;
                }

@@ -1052,7 +1071,8 @@ static int populate_table(struct dm_tabl

        r =3D dm_table_set_type(table);
        if (r) {
-               DMWARN("unable to set table type");
+               DMLOG(DMLOG_IOCTL, DMLOG_WARN, "%s: unable to set table t=
ype",
+                       param->name);
                return r;
        }

@@ -1095,15 +1115,16 @@ static int table_load(struct dm_ioctl *p

        r =3D table_prealloc_integrity(t, md);
        if (r) {
-               DMERR("%s: could not register integrity profile.",
-                     dm_device_name(md));
+               DMLOG(DMLOG_IOCTL, DMLOG_ERR, "%s: could not register "
+                       "integrity profile.", dm_device_name(md));
                dm_table_destroy(t);
                goto out;
        }

        r =3D dm_table_alloc_md_mempools(t);
        if (r) {
-               DMWARN("unable to allocate mempools for this table");
+               DMLOG(DMLOG_IOCTL, DMLOG_WARN, "%s: unable to allocate me=
mpools"
+                       " for this table", dm_device_name(md));
                dm_table_destroy(t);
                goto out;
        }
@@ -1111,7 +1132,8 @@ static int table_load(struct dm_ioctl *p
        down_write(&_hash_lock);
        hc =3D dm_get_mdptr(md);
        if (!hc || hc->md !=3D md) {
-               DMWARN("device has been removed from the dev hash table."=
);
+               DMLOG(DMLOG_IOCTL, DMLOG_WARN, "%s: device has been remov=
ed from"
+                       " the dev hash table.", dm_device_name(md));
                dm_table_destroy(t);
                up_write(&_hash_lock);
                r =3D -ENXIO;
@@ -1142,7 +1164,8 @@ static int table_clear(struct dm_ioctl *

        hc =3D __find_device_hash_cell(param);
        if (!hc) {
-               DMWARN("device doesn't appear to be in the dev hash table=
.");
+               DMLOG(DMLOG_IOCTL, DMLOG_WARN, "%s: device doesn't appear=
 "
+                       "to be in the dev hash table.", param->name);
                up_write(&_hash_lock);
                return -ENXIO;
        }
@@ -1277,14 +1300,16 @@ static int target_message(struct dm_ioct

        if (tmsg < (struct dm_target_msg *) param->data ||
            invalid_str(tmsg->message, (void *) param + param_size)) {
-               DMWARN("Invalid target message parameters.");
+               DMLOG(DMLOG_IOCTL, DMLOG_WARN, "%s: Invalid target messag=
e"
+                       " parameters.", param->name);
                r =3D -EINVAL;
                goto out;
        }

        r =3D dm_split_args(&argc, &argv, tmsg->message);
        if (r) {
-               DMWARN("Failed to split target message parameters");
+               DMLOG(DMLOG_IOCTL, DMLOG_WARN, "%s: Failed to split targe=
t"
+                       " message parameters", param->name);
                goto out;
        }

@@ -1294,12 +1319,14 @@ static int target_message(struct dm_ioct

        ti =3D dm_table_find_target(table, tmsg->sector);
        if (!dm_target_is_valid(ti)) {
-               DMWARN("Target message sector outside device.");
+               DMLOG(DMLOG_IOCTL, DMLOG_WARN, "%s: Target message sector=
 "
+                       "outside device.", param->name);
                r =3D -EINVAL;
        } else if (ti->type->message)
                r =3D ti->type->message(ti, argc, argv);
        else {
-               DMWARN("Target type does not support messages");
+               DMLOG(DMLOG_IOCTL, DMLOG_WARN, "%s: Target type does not =
"
+                       "support messages", param->name);
                r =3D -EINVAL;
        }

@@ -1361,7 +1388,7 @@ static int check_version(unsigned int cm

        if ((DM_VERSION_MAJOR !=3D version[0]) ||
            (DM_VERSION_MINOR < version[1])) {
-               DMWARN("ioctl interface mismatch: "
+               DMLOG(DMLOG_IOCTL, DMLOG_WARN, "ioctl interface mismatch:=
 "
                       "kernel(%u.%u.%u), user(%u.%u.%u), cmd(%d)",
                       DM_VERSION_MAJOR, DM_VERSION_MINOR,
                       DM_VERSION_PATCHLEVEL,
@@ -1422,11 +1449,13 @@ static int validate_params(uint cmd, str

        if ((cmd =3D=3D DM_DEV_CREATE_CMD)) {
                if (!*param->name) {
-                       DMWARN("name not supplied when creating device");
+                       DMLOG(DMLOG_IOCTL, DMLOG_WARN, "Name not supplied=
"
+                               " when creating device");
                        return -EINVAL;
                }
        } else if ((*param->uuid && *param->name)) {
-               DMWARN("only supply one of name or uuid, cmd(%u)", cmd);
+               DMLOG(DMLOG_IOCTL, DMLOG_WARN, "only supply one of name o=
r"
+                       "uuid, cmd(%u)", cmd);
                return -EINVAL;
        }

@@ -1461,6 +1490,8 @@ static int ctl_ioctl(uint command, struc
        r =3D check_version(cmd, user);
        if (r)
                return r;
+       DMLOG(DMLOG_IOCTL, DMLOG_INFO,  "%s: IOCTL command "
+               "0x%x.", user->name, command );

        /*
         * Nothing more to do for the version command.
@@ -1470,7 +1501,7 @@ static int ctl_ioctl(uint command, struc

        fn =3D lookup_ioctl(cmd);
        if (!fn) {
-               DMWARN("dm_ctl_ioctl: unknown command 0x%x", command);
+               DMLOG(DMLOG_IOCTL, DMLOG_ERR, "%s: Unknown command 0x%x",=
 user->name, command);
                return -ENOTTY;
        }

@@ -1549,21 +1580,23 @@ int __init dm_interface_init(void)

        r =3D misc_register(&_dm_misc);
        if (r) {
-               DMERR("misc_register failed for control device");
+               DMLOG(DMLOG_IOCTL, DMLOG_ERR, "misc_register failed "
+                       "for control device");
                dm_hash_exit();
                return r;
        }

-       DMINFO("%d.%d.%d%s initialised: %s", DM_VERSION_MAJOR,
-              DM_VERSION_MINOR, DM_VERSION_PATCHLEVEL, DM_VERSION_EXTRA,
-              DM_DRIVER_EMAIL);
+       DMLOG(DMLOG_IOCTL, DMLOG_INFO, "%d.%d.%d%s initialised: %s",
+               DM_VERSION_MAJOR, DM_VERSION_MINOR, DM_VERSION_PATCHLEVEL=
,
+               DM_VERSION_EXTRA, DM_DRIVER_EMAIL);
        return 0;
 }

 void dm_interface_exit(void)
 {
        if (misc_deregister(&_dm_misc) < 0)
-               DMERR("misc_deregister failed for control device");
+               DMLOG(DMLOG_IOCTL, DMLOG_ERR, "misc_deregister"
+                       "failed for control device");

        dm_hash_exit();
 }
diff -uprN linux-2.6.31-rc8-orig/drivers/md/dm-mpath.c linux-2.6.31-rc8/d=
rivers/md/dm-mpath.c
--- linux-2.6.31-rc8-orig/drivers/md/dm-mpath.c 2009-08-28 06:29:04.00000=
0000 +0530
+++ linux-2.6.31-rc8/drivers/md/dm-mpath.c      2009-09-22 01:17:45.00000=
0000 +0530
@@ -141,7 +141,8 @@ static void deactivate_path(struct work_
 {
        struct pgpath *pgpath =3D
                container_of(work, struct pgpath, deactivate_path);
-
+       DMLOG(DMLOG_PATH_DEACTIVATE, DMLOG_CRIT, "Deactivating path."
+               " Aborting all I/O on %s queue", pgpath->path.dev->name);
        blk_abort_queue(pgpath->path.dev->bdev->bd_disk->queue);
 }

@@ -163,6 +164,9 @@ static void free_pgpaths(struct list_hea
        struct multipath *m =3D ti->private;

        list_for_each_entry_safe(pgpath, tmp, pgpaths, list) {
+               DMLOG(DMLOG_PATH_DEACTIVATE, DMLOG_CRIT,
+                       "Removing path %s from pathgroup %d",
+                       pgpath->path.dev->name, pgpath->pg->pg_num);
                list_del(&pgpath->list);
                if (m->hw_handler_name)
                        scsi_dh_detach(bdev_get_queue(pgpath->path.dev->b=
dev));
@@ -188,7 +192,6 @@ static void free_priority_group(struct p
 static struct multipath *alloc_multipath(struct dm_target *ti)
 {
        struct multipath *m;
-
        m =3D kzalloc(sizeof(*m), GFP_KERNEL);
        if (m) {
                INIT_LIST_HEAD(&m->priority_groups);
@@ -199,6 +202,8 @@ static struct multipath *alloc_multipath
                INIT_WORK(&m->trigger_event, trigger_event);
                m->mpio_pool =3D mempool_create_slab_pool(MIN_IOS, _mpio_=
cache);
                if (!m->mpio_pool) {
+                       DMLOG(DMLOG_ADD_DEV, DMLOG_ERR, "Failed. No mpio_=
pool"
+                               " available");
                        kfree(m);
                        return NULL;
                }
@@ -230,6 +235,11 @@ static void free_multipath(struct multip

 static void __switch_pg(struct multipath *m, struct pgpath *pgpath)
 {
+       #ifdef CONFIG_DM_DEBUG
+        char name[16];
+        dm_target_device_name(m->ti, name);
+       #endif
+
        m->current_pg =3D pgpath->pg;

        /* Must we initialise the PG first, and queue I/O till it's ready=
? */
@@ -240,7 +250,8 @@ static void __switch_pg(struct multipath
                m->pg_init_required =3D 0;
                m->queue_io =3D 0;
        }
-
+       DMLOG(DMLOG_FAILOVER, DMLOG_CRIT, "%s: Swtiching to pathgroup %u"=
,
+               name , pgpath->pg->pg_num);
        m->pg_init_count =3D 0;
 }

@@ -248,7 +259,10 @@ static int __choose_path_in_pg(struct mu
                               size_t nr_bytes)
 {
        struct dm_path *path;
-
+       #ifdef CONFIG_DM_DEBUG
+               char name[16];
+               dm_target_device_name(m->ti, name);
+       #endif
        path =3D pg->ps.type->select_path(&pg->ps, &m->repeat_count, nr_b=
ytes);
        if (!path)
                return -ENXIO;
@@ -257,6 +271,8 @@ static int __choose_path_in_pg(struct mu

        if (m->current_pg !=3D pg)
                __switch_pg(m, m->current_pgpath);
+       DMLOG(DMLOG_FAILOVER, DMLOG_INFO, "%s: Selecting path %s for I/O"=
,
+               name, m->current_pgpath->path.dev->name);

        return 0;
 }
@@ -352,10 +368,11 @@ static int map_io(struct multipath *m, s
                bdev =3D pgpath->path.dev->bdev;
                clone->q =3D bdev_get_queue(bdev);
                clone->rq_disk =3D bdev->bd_disk;
-       } else if (__must_push_back(m))
+       } else if (__must_push_back(m)) {
                r =3D DM_MAPIO_REQUEUE;
-       else
+       } else {
                r =3D -EIO;       /* Failed */
+       }

        mpio->pgpath =3D pgpath;
        mpio->nr_bytes =3D nr_bytes;
@@ -384,6 +401,7 @@ static int queue_if_no_path(struct multi
        else
                m->saved_queue_if_no_path =3D queue_if_no_path;
        m->queue_if_no_path =3D queue_if_no_path;
+
        if (!m->queue_if_no_path && m->queue_size)
                queue_work(kmultipathd, &m->process_queued_ios);

@@ -706,7 +724,10 @@ static int parse_hw_handler(struct arg_s
 {
        unsigned hw_argc;
        struct dm_target *ti =3D m->ti;
-
+       #ifdef CONFIG_DM_DEBUG
+        char name[16];
+        dm_target_device_name(ti, name);
+       #endif
        static struct param _params[] =3D {
                {0, 1024, "invalid number of hardware handler args"},
        };
@@ -732,8 +753,9 @@ static int parse_hw_handler(struct arg_s
        }

        if (hw_argc > 1)
-               DMWARN("Ignoring user-specified arguments for "
-                      "hardware handler \"%s\"", m->hw_handler_name);
+               DMLOG(DMLOG_INIT, DMLOG_WARN, "%s: Ignoring user-specifie=
d "
+                       "arguments for hardware handler \"%s\"",
+                       name, m->hw_handler_name);
        consume(as, hw_argc - 1);

        return 0;
@@ -898,12 +920,18 @@ static int fail_path(struct pgpath *pgpa
        unsigned long flags;
        struct multipath *m =3D pgpath->pg->m;

+       #ifdef CONFIG_DM_DEBUG
+        char name[16];
+        dm_target_device_name(m->ti, name);
+       #endif
+
        spin_lock_irqsave(&m->lock, flags);

        if (!pgpath->is_active)
                goto out;

-       DMWARN("Failing path %s.", pgpath->path.dev->name);
+       DMLOG(DMLOG_PATH_DEACTIVATE, DMLOG_CRIT, "%s: Failing path %s",
+               name, pgpath->path.dev->name);

        pgpath->pg->ps.type->fail_path(&pgpath->pg->ps, &pgpath->path);
        pgpath->is_active =3D 0;
@@ -911,6 +939,7 @@ static int fail_path(struct pgpath *pgpa

        m->nr_valid_paths--;

+
        if (pgpath =3D=3D m->current_pgpath)
                m->current_pgpath =3D NULL;

@@ -935,14 +964,20 @@ static int reinstate_path(struct pgpath
        unsigned long flags;
        struct multipath *m =3D pgpath->pg->m;

+       #ifdef CONFIG_DM_DEBUG
+        char name[16];
+        dm_target_device_name(m->ti, name);
+       #endif
+
        spin_lock_irqsave(&m->lock, flags);

        if (pgpath->is_active)
                goto out;

        if (!pgpath->pg->ps.type->reinstate_path) {
-               DMWARN("Reinstate path not supported by path selector %s"=
,
-                      pgpath->pg->ps.type->name);
+               DMLOG(DMLOG_PATH_ACTIVATE, DMLOG_WARN, "%s: Reinstate pat=
h "
+                       "not supported by path selector %s",
+                       name, pgpath->pg->ps.type->name);
                r =3D -EINVAL;
                goto out;
        }
@@ -951,6 +986,9 @@ static int reinstate_path(struct pgpath
        if (r)
                goto out;

+       DMLOG(DMLOG_PATH_ACTIVATE, DMLOG_CRIT, "%s: Path %s sucessfuly re=
instated",
+               name, pgpath->path.dev->name);
+
        pgpath->is_active =3D 1;

        if (!m->nr_valid_paths++ && m->queue_size) {
@@ -1020,9 +1058,15 @@ static int switch_pg_num(struct multipat
        unsigned pgnum;
        unsigned long flags;

+       #ifdef CONFIG_DM_DEBUG
+        char name[16];
+        dm_target_device_name(m->ti, name);
+       #endif
+
        if (!pgstr || (sscanf(pgstr, "%u", &pgnum) !=3D 1) || !pgnum ||
            (pgnum > m->nr_priority_groups)) {
-               DMWARN("invalid PG number supplied to switch_pg_num");
+               DMLOG(DMLOG_FAILOVER, DMLOG_WARN, "%s: invalid PG number"
+                       " supplied to switch_pg_num", name);
                return -EINVAL;
        }

@@ -1051,9 +1095,15 @@ static int bypass_pg_num(struct multipat
        struct priority_group *pg;
        unsigned pgnum;

+       #ifdef CONFIG_DM_DEBUG
+        char name[16];
+        dm_target_device_name(m->ti, name);
+       #endif
+
        if (!pgstr || (sscanf(pgstr, "%u", &pgnum) !=3D 1) || !pgnum ||
            (pgnum > m->nr_priority_groups)) {
-               DMWARN("invalid PG number supplied to bypass_pg");
+               DMLOG(DMLOG_FAILOVER, DMLOG_WARN, "%s: invalid PG number =
"
+                       "supplied to bypass_pg", name);
                return -EINVAL;
        }

@@ -1074,8 +1124,17 @@ static int pg_init_limit_reached(struct
        unsigned long flags;
        int limit_reached =3D 0;

+       #ifdef CONFIG_DM_DEBUG
+        char name[16];
+        dm_target_device_name(m->ti, name);
+       #endif
+
        spin_lock_irqsave(&m->lock, flags);

+       DMLOG(DMLOG_FAILOVER, DMLOG_INFO, "%s: pg_init_retries =3D %d, "
+               "pg_init_count =3D %d", name, m->pg_init_retries,
+               m->pg_init_count);
+
        if (m->pg_init_count <=3D m->pg_init_retries)
                m->pg_init_required =3D 1;
        else
@@ -1093,7 +1152,15 @@ static void pg_init_done(struct dm_path
        struct multipath *m =3D pg->m;
        unsigned long flags;

+       #ifdef CONFIG_DM_DEBUG
+        char name[16];
+        dm_target_device_name(m->ti, name);
+       #endif
+
        /* device or driver problems */
+       DMLOG(DMLOG_FAILOVER, DMLOG_INFO, "%s: failover status =3D %d ",
+               pgpath->path.dev->name, errors);
+
        switch (errors) {
        case SCSI_DH_OK:
                break;
@@ -1102,8 +1169,9 @@ static void pg_init_done(struct dm_path
                        errors =3D 0;
                        break;
                }
-               DMERR("Cannot failover device because scsi_dh_%s was not =
"
-                     "loaded.", m->hw_handler_name);
+               DMLOG(DMLOG_FAILOVER, DMLOG_ERR, "%s: Cannot failover "
+                       "device because scsi_dh_%s was not loaded.",
+                       name, m->hw_handler_name);
                /*
                 * Fail path for now, so we do not ping pong
                 */
@@ -1136,7 +1204,8 @@ static void pg_init_done(struct dm_path
        spin_lock_irqsave(&m->lock, flags);
        if (errors) {
                if (pgpath =3D=3D m->current_pgpath) {
-                       DMERR("Could not failover device. Error %d.", err=
ors);
+                       DMLOG(DMLOG_FAILOVER, DMLOG_ERR, "%s: Could not f=
ailover "
+                               "device. Error %d.", name, errors);
                        m->current_pgpath =3D NULL;
                        m->current_pg =3D NULL;
                }
@@ -1178,9 +1247,15 @@ static int do_end_io(struct multipath *m
         * request into dm core, which will remake a clone request and
         * clone bios for it and resubmit it later.
         */
+       #ifdef CONFIG_DM_DEBUG
+         char name[16];
+         dm_target_device_name(m->ti, name);
+        #endif
+
        int r =3D DM_ENDIO_REQUEUE;
        unsigned long flags;

+
        if (!error && !clone->errors)
                return 0;       /* I/O complete */

@@ -1191,8 +1266,12 @@ static int do_end_io(struct multipath *m
                fail_path(mpio->pgpath);

        spin_lock_irqsave(&m->lock, flags);
-       if (!m->nr_valid_paths && !m->queue_if_no_path && !__must_push_ba=
ck(m))
+       if (!m->nr_valid_paths && !m->queue_if_no_path &&
+               !__must_push_back(m)) {
                r =3D -EIO;
+               DMLOG(DMLOG_IO, DMLOG_CRIT, "%s: Failing I/O on %s",
+                       name, m->current_pgpath->path.dev->name);
+       }
        spin_unlock_irqrestore(&m->lock, flags);

        return r;
@@ -1372,6 +1451,10 @@ static int multipath_message(struct dm_t
        struct multipath *m =3D (struct multipath *) ti->private;
        action_fn action;

+       #ifdef CONFIG_DM_DEBUG
+        char name[16];
+        dm_target_device_name(m->ti, name);
+       #endif
        if (argc =3D=3D 1) {
                if (!strnicmp(argv[0], MESG_STR("queue_if_no_path")))
                        return queue_if_no_path(m, 1, 0);
@@ -1382,6 +1465,7 @@ static int multipath_message(struct dm_t
        if (argc !=3D 2)
                goto error;

+
        if (!strnicmp(argv[0], MESG_STR("disable_group")))
                return bypass_pg_num(m, argv[1], 1);
        else if (!strnicmp(argv[0], MESG_STR("enable_group")))
@@ -1398,8 +1482,8 @@ static int multipath_message(struct dm_t
        r =3D dm_get_device(ti, argv[1], ti->begin, ti->len,
                          dm_table_get_mode(ti->table), &dev);
        if (r) {
-               DMWARN("message: error getting device %s",
-                      argv[1]);
+               DMLOG(DMLOG_IOCTL, DMLOG_WARN, "%s: message: error gettin=
g "
+                       "device %s", name, argv[1]);
                return -EINVAL;
        }

@@ -1410,7 +1494,8 @@ static int multipath_message(struct dm_t
        return r;

 error:
-       DMWARN("Unrecognised multipath message received.");
+       DMLOG(DMLOG_IOCTL, DMLOG_WARN, "%s: Unrecognised multipath "
+               "message received.", name);
        return -EINVAL;
 }

@@ -1563,14 +1648,15 @@ static int __init dm_multipath_init(void

        r =3D dm_register_target(&multipath_target);
        if (r < 0) {
-               DMERR("register failed %d", r);
+               DMLOG(DMLOG_INIT, DMLOG_ERR, " register failed %d", r);
                kmem_cache_destroy(_mpio_cache);
                return -EINVAL;
        }

        kmultipathd =3D create_workqueue("kmpathd");
        if (!kmultipathd) {
-               DMERR("failed to create workqueue kmpathd");
+               DMLOG(DMLOG_INIT, DMLOG_ERR, "failed to create "
+                       "workqueue kmpathd");
                dm_unregister_target(&multipath_target);
                kmem_cache_destroy(_mpio_cache);
                return -ENOMEM;
@@ -1584,14 +1670,14 @@ static int __init dm_multipath_init(void
         */
        kmpath_handlerd =3D create_singlethread_workqueue("kmpath_handler=
d");
        if (!kmpath_handlerd) {
-               DMERR("failed to create workqueue kmpath_handlerd");
+               DMLOG(DMLOG_INIT, DMLOG_ERR, "failed to create workqueue =
"
+                       "kmpath_handlerd");
                destroy_workqueue(kmultipathd);
                dm_unregister_target(&multipath_target);
                kmem_cache_destroy(_mpio_cache);
                return -ENOMEM;
        }
-
-       DMINFO("version %u.%u.%u loaded",
+       DMLOG(DMLOG_INIT, DMLOG_INFO, "version %u.%u.%u loaded",
               multipath_target.version[0], multipath_target.version[1],
               multipath_target.version[2]);

diff -uprN linux-2.6.31-rc8-orig/drivers/md/dm-path-selector.c linux-2.6.=
31-rc8/drivers/md/dm-path-selector.c
--- linux-2.6.31-rc8-orig/drivers/md/dm-path-selector.c 2009-08-28 06:29:=
04.000000000 +0530
+++ linux-2.6.31-rc8/drivers/md/dm-path-selector.c      2009-09-22 01:17:=
46.000000000 +0530
@@ -15,6 +15,8 @@

 #include <linux/slab.h>

+#define DM_MSG_PREFIX "dm-path-selector"
+
 struct ps_internal {
        struct path_selector_type pst;
        struct list_head list;
@@ -61,6 +63,8 @@ struct path_selector_type *dm_get_path_s
        if (!psi) {
                request_module("dm-%s", name);
                psi =3D get_path_selector(name);
+               DMLOG(DMLOG_INIT, DMLOG_INFO, "path selector module %s %s=
",
+                       name, (psi) ? "Loaded successfully" : "failed to =
load");
        }

        return psi ? &psi->pst : NULL;
@@ -106,8 +110,13 @@ int dm_register_path_selector(struct pat
        if (__find_path_selector_type(pst->name)) {
                kfree(psi);
                r =3D -EEXIST;
-       } else
+               DMLOG(DMLOG_INIT, DMLOG_ERR, "Failed: Path selector "
+                       "%s already registered", pst->name);
+       } else {
                list_add(&psi->list, &_path_selectors);
+               DMLOG(DMLOG_INIT, DMLOG_INFO, "path selector %s "
+                       "registered successfully", pst->name);
+       }

        up_write(&_ps_lock);

@@ -122,12 +131,16 @@ int dm_unregister_path_selector(struct p

        psi =3D __find_path_selector_type(pst->name);
        if (!psi) {
+               DMLOG(DMLOG_INIT, DMLOG_ERR, "Failed to unregister: %s "
+                       "is not registered", pst->name);
                up_write(&_ps_lock);
                return -EINVAL;
        }

        list_del(&psi->list);

+       DMLOG(DMLOG_INIT, DMLOG_INFO, "path selector %s unregistered "
+               "successfully", pst->name);
        up_write(&_ps_lock);

        kfree(psi);
diff -uprN linux-2.6.31-rc8-orig/drivers/md/dm-table.c linux-2.6.31-rc8/d=
rivers/md/dm-table.c
--- linux-2.6.31-rc8-orig/drivers/md/dm-table.c 2009-08-28 06:29:04.00000=
0000 +0530
+++ linux-2.6.31-rc8/drivers/md/dm-table.c      2009-09-22 01:17:45.00000=
0000 +0530
@@ -227,8 +227,9 @@ static void free_devices(struct list_hea
        list_for_each_safe(tmp, next, devices) {
                struct dm_dev_internal *dd =3D
                    list_entry(tmp, struct dm_dev_internal, list);
-               DMWARN("dm_table_destroy: dm_put_device call missing for =
%s",
-                      dd->dm_dev.name);
+               DMLOG(DMLOG_TABLE, DMLOG_WARN, "%s :dm_table_destroy: "
+                       "dm_put_device call missing",
+                       dd->dm_dev.name);
                kfree(dd);
        }
 }
@@ -360,8 +361,9 @@ static int device_area_is_valid(struct d
                return 1;

        if ((start >=3D dev_size) || (start + len > dev_size)) {
-               DMWARN("%s: %s too small for target",
-                      dm_device_name(ti->table->md), bdevname(bdev, b));
+               DMLOG(DMLOG_TABLE, DMLOG_WARN, "%s: %s too small "
+                       "for target", dm_device_name(ti->table->md),
+                       bdevname(bdev, b));
                return 0;
        }

@@ -369,17 +371,17 @@ static int device_area_is_valid(struct d
                return 1;

        if (start & (logical_block_size_sectors - 1)) {
-               DMWARN("%s: start=3D%llu not aligned to h/w "
-                      "logical block size %hu of %s",
-                      dm_device_name(ti->table->md),
+               DMLOG(DMLOG_TABLE, DMLOG_WARN, "%s: start=3D%llu not alig=
ned "
+                       "to h/w logical block size %hu of %s",
+                       dm_device_name(ti->table->md),
                       (unsigned long long)start,
                       limits->logical_block_size, bdevname(bdev, b));
                return 0;
        }

        if (len & (logical_block_size_sectors - 1)) {
-               DMWARN("%s: len=3D%llu not aligned to h/w "
-                      "logical block size %hu of %s",
+               DMLOG(DMLOG_TABLE, DMLOG_WARN, "%s: len=3D%llu not "
+                       "aligned to h/w logical block size %hu of %s",
                       dm_device_name(ti->table->md),
                       (unsigned long long)len,
                       limits->logical_block_size, bdevname(bdev, b));
@@ -490,14 +492,16 @@ int dm_set_device_limits(struct dm_targe
        char b[BDEVNAME_SIZE];

        if (unlikely(!q)) {
-               DMWARN("%s: Cannot set limits for nonexistent device %s",
+               DMLOG(DMLOG_TABLE, DMLOG_WARN, "%s: Cannot set limits "
+                      "for nonexistent device %s",
                       dm_device_name(ti->table->md), bdevname(bdev, b));
                return 0;
        }

        if (blk_stack_limits(limits, &q->limits, start << 9) < 0)
-               DMWARN("%s: target device %s is misaligned",
-                      dm_device_name(ti->table->md), bdevname(bdev, b));
+               DMLOG(DMLOG_TABLE, DMLOG_WARN, "%s: target device %s "
+                       "is misaligned", dm_device_name(ti->table->md),
+                       bdevname(bdev, b));

        /*
         * Check if merge fn is supported.
@@ -697,12 +701,12 @@ static int validate_hardware_logical_blo
        }

        if (remaining) {
-               DMWARN("%s: table line %u (start sect %llu len %llu) "
-                      "not aligned to h/w logical block size %hu",
-                      dm_device_name(table->md), i,
-                      (unsigned long long) ti->begin,
-                      (unsigned long long) ti->len,
-                      limits->logical_block_size);
+               DMLOG(DMLOG_TABLE, DMLOG_WARN, "%s: table line %u "
+                       "(start sect %llu len %llu) not aligned to "
+                       "h/w logical block size %hu", dm_device_name(tabl=
e->md),
+                       i, (unsigned long long) ti->begin,
+                       (unsigned long long) ti->len,
+                       limits->logical_block_size);
                return -EINVAL;
        }

@@ -723,14 +727,15 @@ int dm_table_add_target(struct dm_table
        memset(tgt, 0, sizeof(*tgt));

        if (!len) {
-               DMERR("%s: zero-length target", dm_device_name(t->md));
+               DMLOG(DMLOG_ADD_DEV, DMLOG_ERR, "%s: zero-length target",
+                       dm_device_name(t->md));
                return -EINVAL;
        }

        tgt->type =3D dm_get_target_type(type);
        if (!tgt->type) {
-               DMERR("%s: %s: unknown target type", dm_device_name(t->md=
),
-                     type);
+               DMLOG(DMLOG_ADD_DEV, DMLOG_ERR, "%s: %s: unknown target "
+                       "type", dm_device_name(t->md));
                return -EINVAL;
        }

@@ -764,7 +769,8 @@ int dm_table_add_target(struct dm_table
        return 0;

  bad:
-       DMERR("%s: %s: %s", dm_device_name(t->md), type, tgt->error);
+       DMLOG(DMLOG_ADD_DEV, DMLOG_ERR, "%s: %s: %s",
+               dm_device_name(t->md), type, tgt->error);
        dm_put_target_type(tgt->type);
        return r;
 }
@@ -785,8 +791,8 @@ int dm_table_set_type(struct dm_table *t
                        bio_based =3D 1;

                if (bio_based && request_based) {
-                       DMWARN("Inconsistent table: different target type=
s"
-                              " can't be mixed up");
+                       DMLOG(DMLOG_TABLE, DMLOG_WARN, " Inconsistent tab=
le: "
+                               "different target types can't be mixed up=
");
                        return -EINVAL;
                }
        }
@@ -803,8 +809,8 @@ int dm_table_set_type(struct dm_table *t
        devices =3D dm_table_get_devices(t);
        list_for_each_entry(dd, devices, list) {
                if (!blk_queue_stackable(bdev_get_queue(dd->dm_dev.bdev))=
) {
-                       DMWARN("table load rejected: including"
-                              " non-request-stackable devices");
+                       DMLOG(DMLOG_TABLE, DMLOG_WARN, "table load reject=
ed: "
+                               "including non-request-stackable devices"=
);
                        return -EINVAL;
                }
        }
@@ -816,7 +822,8 @@ int dm_table_set_type(struct dm_table *t
         * (e.g. request completion process for partial completion.)
         */
        if (t->num_targets > 1) {
-               DMWARN("Request-based dm doesn't support multiple targets=
 yet");
+               DMLOG(DMLOG_TABLE, DMLOG_WARN, "Request-based dm "
+                       "doesn't support multiple targets yet");
                return -EINVAL;
        }

@@ -840,7 +847,8 @@ int dm_table_alloc_md_mempools(struct dm
        unsigned type =3D dm_table_get_type(t);

        if (unlikely(type =3D=3D DM_TYPE_NONE)) {
-               DMWARN("no table type is set, can't allocate mempools");
+               DMLOG(DMLOG_TABLE, DMLOG_WARN, "no table type is set, "
+                       "can't allocate mempools");
                return -EINVAL;
        }

@@ -1010,7 +1018,7 @@ combine_limits:
                 * for the table.
                 */
                if (blk_stack_limits(limits, &ti_limits, 0) < 0)
-                       DMWARN("%s: target device "
+                       DMLOG(DMLOG_TABLE, DMLOG_WARN, "%s: target device=
 "
                               "(start sect %llu len %llu) "
                               "is misaligned",
                               dm_device_name(table->md),
@@ -1037,7 +1045,8 @@ static void dm_table_set_integrity(struc
                if (prev &&
                    blk_integrity_compare(prev->dm_dev.bdev->bd_disk,
                                          dd->dm_dev.bdev->bd_disk) < 0) =
{
-                       DMWARN("%s: integrity not set: %s and %s mismatch=
",
+                       DMLOG(DMLOG_TABLE, DMLOG_WARN, "%s: integrity not=
 "
+                              "set: %s and %s mismatch",
                               dm_device_name(t->md),
                               prev->dm_dev.bdev->bd_disk->disk_name,
                               dd->dm_dev.bdev->bd_disk->disk_name);
@@ -1183,9 +1192,10 @@ int dm_table_any_congested(struct dm_tab
                if (likely(q))
                        r |=3D bdi_congested(&q->backing_dev_info, bdi_bi=
ts);
                else
-                       DMWARN_LIMIT("%s: any_congested: nonexistent devi=
ce %s",
-                                    dm_device_name(t->md),
-                                    bdevname(dd->dm_dev.bdev, b));
+                       DMLOG(DMLOG_TABLE, DMLOG_WARN, "%s: any_congested=
: "
+                               "nonexistent device %s",
+                               dm_device_name(t->md),
+                               bdevname(dd->dm_dev.bdev, b));
        }

        return r;
@@ -1217,9 +1227,10 @@ void dm_table_unplug_all(struct dm_table
                if (likely(q))
                        blk_unplug(q);
                else
-                       DMWARN_LIMIT("%s: Cannot unplug nonexistent devic=
e %s",
-                                    dm_device_name(t->md),
-                                    bdevname(dd->dm_dev.bdev, b));
+                       DMLOG(DMLOG_TABLE, DMLOG_WARN, "%s: Cannot unplug=
 "
+                               "nonexistent device %s",
+                               dm_device_name(t->md),
+                               bdevname(dd->dm_dev.bdev, b));
        }
 }

diff -uprN linux-2.6.31-rc8-orig/drivers/md/dm-uevent.c linux-2.6.31-rc8/=
drivers/md/dm-uevent.c
--- linux-2.6.31-rc8-orig/drivers/md/dm-uevent.c        2009-08-28 06:29:=
04.000000000 +0530
+++ linux-2.6.31-rc8/drivers/md/dm-uevent.c     2009-09-22 01:17:45.00000=
0000 +0530
@@ -78,40 +78,42 @@ static struct dm_uevent *dm_build_path_u

        event =3D dm_uevent_alloc(md);
        if (!event) {
-               DMERR("%s: dm_uevent_alloc() failed", __func__);
+               DMLOG(DMLOG_UEVENT, DMLOG_ERR, "%s: dm_uevent_alloc() fai=
led",
+                       dm_device_name(md));
                goto err_nomem;
        }

        event->action =3D action;

        if (add_uevent_var(&event->ku_env, "DM_TARGET=3D%s", ti->type->na=
me)) {
-               DMERR("%s: add_uevent_var() for DM_TARGET failed",
-                     __func__);
+               DMLOG(DMLOG_UEVENT, DMLOG_ERR, "%s: add_uevent_var() "
+                       "for DM_TARGET failed", dm_device_name(md));
                goto err_add;
        }

        if (add_uevent_var(&event->ku_env, "DM_ACTION=3D%s", dm_action)) =
{
-               DMERR("%s: add_uevent_var() for DM_ACTION failed",
-                     __func__);
+               DMLOG(DMLOG_UEVENT, DMLOG_ERR, "%s: add_uevent_var() for =
"
+                       "DM_ACTION failed", dm_device_name(md));
                goto err_add;
        }

        if (add_uevent_var(&event->ku_env, "DM_SEQNUM=3D%u",
                           dm_next_uevent_seq(md))) {
-               DMERR("%s: add_uevent_var() for DM_SEQNUM failed",
-                     __func__);
+               DMLOG(DMLOG_UEVENT, DMLOG_ERR, "%s: add_uevent_var() for =
"
+                       "DM_SEQNUM failed", dm_device_name(md));
                goto err_add;
        }

        if (add_uevent_var(&event->ku_env, "DM_PATH=3D%s", path)) {
-               DMERR("%s: add_uevent_var() for DM_PATH failed", __func__=
);
+               DMLOG(DMLOG_UEVENT, DMLOG_ERR, "%s: add_uevent_var() for =
"
+                       "DM_PATH failed", dm_device_name(md));
                goto err_add;
        }

        if (add_uevent_var(&event->ku_env, "DM_NR_VALID_PATHS=3D%d",
                           nr_valid_paths)) {
-               DMERR("%s: add_uevent_var() for DM_NR_VALID_PATHS failed"=
,
-                     __func__);
+               DMLOG(DMLOG_UEVENT, DMLOG_ERR, "%s: add_uevent_var() for =
"
+                       "DM_NR_VALID_PATHS failed", dm_device_name(md));
                goto err_add;
        }

@@ -145,26 +147,28 @@ void dm_send_uevents(struct list_head *e
                 */
                if (dm_copy_name_and_uuid(event->md, event->name,
                                          event->uuid)) {
-                       DMERR("%s: dm_copy_name_and_uuid() failed",
-                             __func__);
+                       DMLOG(DMLOG_UEVENT, DMLOG_ERR, "%s: "
+                               "dm_copy_name_and_uuid() failed",
+                                       event->name);
                        goto uevent_free;
                }

                if (add_uevent_var(&event->ku_env, "DM_NAME=3D%s", event-=
>name)) {
-                       DMERR("%s: add_uevent_var() for DM_NAME failed",
-                             __func__);
+                       DMLOG(DMLOG_UEVENT, DMLOG_ERR, "%s: add_uevent_va=
r() "
+                               "for DM_NAME failed", event->name);
                        goto uevent_free;
                }

                if (add_uevent_var(&event->ku_env, "DM_UUID=3D%s", event-=
>uuid)) {
-                       DMERR("%s: add_uevent_var() for DM_UUID failed",
-                             __func__);
+                       DMLOG(DMLOG_UEVENT, DMLOG_ERR, "%s: add_uevent_va=
r() "
+                               "for DM_UUID failed", event->name);
                        goto uevent_free;
                }

                r =3D kobject_uevent_env(kobj, event->action, event->ku_e=
nv.envp);
                if (r)
-                       DMERR("%s: kobject_uevent_env failed", __func__);
+                       DMLOG(DMLOG_UEVENT, DMLOG_ERR,
+                               "%s: kobject_uevent_env failed", event->n=
ame);
 uevent_free:
                dm_uevent_free(event);
        }
@@ -187,7 +191,8 @@ void dm_path_uevent(enum dm_uevent_type
        struct dm_uevent *event;

        if (event_type >=3D ARRAY_SIZE(_dm_uevent_type_names)) {
-               DMERR("%s: Invalid event_type %d", __func__, event_type);
+               DMLOG(DMLOG_UEVENT, DMLOG_ERR,
+                       "Invalid event_type %d", event_type);
                goto out;
        }

@@ -211,7 +216,7 @@ int dm_uevent_init(void)
        if (!_dm_event_cache)
                return -ENOMEM;

-       DMINFO("version 1.0.3");
+       DMLOG(DMLOG_UEVENT, DMLOG_INFO, "version 1.0.3");

        return 0;
 }
diff -uprN linux-2.6.31-rc8-orig/include/linux/device-mapper.h linux-2.6.=
31-rc8/include/linux/device-mapper.h
--- linux-2.6.31-rc8-orig/include/linux/device-mapper.h 2009-08-28 06:29:=
04.000000000 +0530
+++ linux-2.6.31-rc8/include/linux/device-mapper.h      2009-09-22 01:17:=
11.000000000 +0530
@@ -334,18 +334,52 @@ void *dm_vcalloc(unsigned long nmemb, un
                               "\n", ## arg); \
        } while (0)

+/*
+* DM LOGGING MACRO
+*/
+extern unsigned int dm_logging_level;
+
 #ifdef CONFIG_DM_DEBUG
-#  define DMDEBUG(f, arg...) \
-       printk(KERN_DEBUG DM_NAME ": " DM_MSG_PREFIX " DEBUG: " f "\n", #=
# arg)
-#  define DMDEBUG_LIMIT(f, arg...) \
-       do { \
-               if (printk_ratelimit()) \
-                       printk(KERN_DEBUG DM_NAME ": " DM_MSG_PREFIX ": "=
 f \
-                              "\n", ## arg); \
+
+/* DM Logging level */
+#define DMLOG_CRIT                     0
+#define DMLOG_ERR                      1
+#define DMLOG_WARN                     2
+#define DMLOG_INFO                     3
+
+#define DMLOG_BITS                     2
+
+/*DM Logging types */
+enum {
+DMLOG_INIT =3D 0,
+DMLOG_ADD_DEV,
+DMLOG_REMOVE_DEV,
+DMLOG_IOCTL,
+DMLOG_IO,
+DMLOG_UEVENT,
+DMLOG_TABLE,
+
+DMLOG_FAILOVER,
+DMLOG_PATH_ACTIVATE,
+DMLOG_PATH_DEACTIVATE,
+};
+
+
+
+#  define DMLOG_LEVEL(SHIFT)                             \
+       ((dm_logging_level >> (SHIFT * DMLOG_BITS)) & ((1 << (DMLOG_BITS)=
) - 1))
+
+#  define DMLOG(SHIFT, LEVEL, f, arg...) \
+       do {                                         \
+               if ((DMLOG_LEVEL(SHIFT)) >=3D (LEVEL)) \
+                       do {                                \
+                               printk(DM_NAME ": " DM_MSG_PREFIX ": " \
+                               "DEBUG: %s: " f "\n", __func__, ## arg); =
\
+                       } while (0);                                    \
        } while (0)
+
 #else
-#  define DMDEBUG(f, arg...) do {} while (0)
-#  define DMDEBUG_LIMIT(f, arg...) do {} while (0)
+#define DMLOG(SHIFT, LEVEL, f, arg...) do {} while (0)
 #endif

 #define DMEMIT(x...) sz +=3D ((sz >=3D maxlen) ? \
@@ -404,5 +438,6 @@ void dm_dispatch_request(struct request
 void dm_requeue_unmapped_request(struct request *rq);
 void dm_kill_unmapped_request(struct request *rq, int error);
 int dm_underlying_device_busy(struct request_queue *q);
+void dm_target_device_name(struct dm_target *ti , char *name);

 #endif /* _LINUX_DEVICE_MAPPER_H */

--
