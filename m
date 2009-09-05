From: "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>
Subject: [RFC PATCH] New  Logging approach for Device Mapper
Date: Sun, 6 Sep 2009 00:36:39 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C1C8EAE093C@inbmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
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
To: "agk@redhat.com" <agk@redhat.com>, "'dm-devel@redhat.com'" <dm-devel@redhat.com>
Cc: "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>, "Stankey,
	Robert" <Robert.Stankey@lsi.com>, "sekharan@linux.vnet.ibm.com" <sekharan@linux.vnet.ibm.com>, "Moger, Babu" <Babu.Moger@lsi.com>
List-Id: dm-devel.ids

This patch add is for logging level in device mapper. It adds new module =
param to dm-mod module which provides inteface for setting DM logging lev=
el.

Signed-off-by: Vijay Chauhan <vijay.chauhan@lsi.com>
---

diff -uprN linux-2.6.31-rc8-orig/drivers/md/dm.c linux-2.6.31-rc8/drivers=
/md/dm.c
--- linux-2.6.31-rc8-orig/drivers/md/dm.c       2009-08-28 06:29:04.00000=
0000 +0530
+++ linux-2.6.31-rc8/drivers/md/dm.c    2009-09-06 05:26:01.000000000 +05=
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
+                       DMLOG(DMLOG_IO, DMLOG_WARN, "unimplemented target=
 map"
+                               " return value: %d", r);
                        BUG();
                }

@@ -1723,7 +1732,8 @@ static struct mapped_device *alloc_dev(i
        void *old_md;

        if (!md) {
-               DMWARN("unable to allocate device, out of memory.");
+               DMLOG(DMLOG_INIT, DMLOG_WARN, "unable to allocate device,=
 "
+                       "out of memory.");
                return NULL;
        }

@@ -2199,7 +2209,8 @@ int dm_swap_table(struct mapped_device *
        /* cannot change the device type, once a table is bound */
        if (md->map &&
            (dm_table_get_type(md->map) !=3D dm_table_get_type(table))) {
-               DMWARN("can't change the device type after a table is bou=
nd");
+               DMLOG(DMLOG_IO, DMLOG_WARN, "can't change the device type=
 "
+                       "after a table is bound");
                goto out;
        }

@@ -2263,8 +2274,8 @@ static int dm_rq_suspend_available(struc
                 * start another flush suspend while it is in use.
                 */
                BUG_ON(!rq->special); /* The marker should be invalidated=
 */
-               DMWARN("Invalidating the previous flush suspend is still =
in"
-                      " progress.  Please retry later.");
+               DMLOG(DMLOG_IO, DMLOG_WARN, "Invalidating the previous fl=
ush "
+                       "suspend is still in progress. Please retry later=
.");
                r =3D 0;
        }
        spin_unlock_irqrestore(q->queue_lock, flags);
@@ -2383,8 +2394,11 @@ int dm_suspend(struct mapped_device *md,
         * DMF_NOFLUSH_SUSPENDING must be set before presuspend.
         * This flag is cleared before dm_suspend returns.
         */
-       if (noflush)
+       if (noflush) {
                set_bit(DMF_NOFLUSH_SUSPENDING, &md->flags);
+               DMLOG(DMLOG_IOCTL, DMLOG_INFO, "Setting DMF_NOFLUSH_SUSPE=
NDING "
+                       "flag for %s ", md->name);
+       }

        /* This does not get reverted if there's an error later. */
        dm_table_presuspend_targets(map);
@@ -2415,6 +2429,8 @@ int dm_suspend(struct mapped_device *md,
         * dm_wq_work exits and DMF_BLOCK_IO_FOR_SUSPEND will prevent any
         * further calls to __split_and_process_bio from dm_wq_work.
         */
+       DMLOG(DMLOG_IOCTL, DMLOG_INFO, "Setting DMF_BLOCK_IO_FOR_SUSPEND =
and "
+               "DMF_QUEUE_IO_TO_THREAD flags for %s", md->name);
        down_write(&md->io_lock);
        set_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags);
        set_bit(DMF_QUEUE_IO_TO_THREAD, &md->flags);
@@ -2433,8 +2449,11 @@ int dm_suspend(struct mapped_device *md,
        r =3D dm_wait_for_completion(md, TASK_INTERRUPTIBLE);

        down_write(&md->io_lock);
-       if (noflush)
+       if (noflush) {
                clear_bit(DMF_NOFLUSH_SUSPENDING, &md->flags);
+               DMLOG(DMLOG_IOCTL, DMLOG_INFO, "Unsetting "
+                       "DMF_NOFLUSH_SUSPENDING for %s", md->name);
+       }
        up_write(&md->io_lock);

        /* were we interrupted ? */
@@ -2455,7 +2474,8 @@ int dm_suspend(struct mapped_device *md,
         */

        dm_table_postsuspend_targets(map);
-
+       DMLOG(DMLOG_IOCTL, DMLOG_INFO, "Setting DMF_SUSPENDED flag for %s=
 ",
+               md->name);
        set_bit(DMF_SUSPENDED, &md->flags);

 out:
@@ -2494,7 +2514,8 @@ int dm_resume(struct mapped_device *md)
                start_queue(md->queue);

        unlock_fs(md);
-
+       DMLOG(DMLOG_IOCTL, DMLOG_INFO, "Unsetting DMF_SUSPENDED flag for =
%s ",
+               md->name);
        clear_bit(DMF_SUSPENDED, &md->flags);

        dm_table_unplug_all(map);
@@ -2670,6 +2691,9 @@ EXPORT_SYMBOL(dm_get_mapinfo);
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
+++ linux-2.6.31-rc8/drivers/md/dm-ioctl.c      2009-09-06 05:05:26.00000=
0000 +0530
@@ -193,6 +193,7 @@ static int dm_hash_insert(const char *na
                dm_put(hc->md);
                goto bad;
        }
+       DMLOG(DMLOG_ADD_DEV, DMLOG_INFO, "inserting %s in hash table", na=
me);

        list_add(&cell->name_list, _name_buckets + hash_str(name));

@@ -201,6 +202,8 @@ static int dm_hash_insert(const char *na
                if (hc) {
                        list_del(&cell->name_list);
                        dm_put(hc->md);
+                       DMLOG(DMLOG_ADD_DEV, DMLOG_CRIT, "Failed to add. =
%s "
+                               "already exists in hash table", name);
                        goto bad;
                }
                list_add(&cell->uuid_list, _uuid_buckets + hash_str(uuid)=
);
@@ -208,7 +211,8 @@ static int dm_hash_insert(const char *na
        dm_get(md);
        dm_set_mdptr(md, cell);
        up_write(&_hash_lock);
-
+       DMLOG(DMLOG_ADD_DEV, DMLOG_INFO, "Successfully inserted %s "
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
@@ -517,7 +521,7 @@ static int list_versions(struct dm_ioctl
 static int check_name(const char *name)
 {
        if (strchr(name, '/')) {
-               DMWARN("invalid device name");
+               DMLOG(DMLOG_IOCTL, DMLOG_ERR, "invalid device name");
                return -EINVAL;
        }

@@ -576,12 +580,16 @@ static int dev_create(struct dm_ioctl *p
        if (param->flags & DM_PERSISTENT_DEV_FLAG)
                m =3D MINOR(huge_decode_dev(param->dev));

+       DMLOG(DMLOG_ADD_DEV, DMLOG_INFO, "Creating dm device for %s",
+               param->name);
        r =3D dm_create(m, &md);
        if (r)
                return r;

        r =3D dm_hash_insert(param->name, *param->uuid ? param->uuid : NU=
LL, md);
        if (r) {
+               DMLOG(DMLOG_ADD_DEV, DMLOG_CRIT, "Unable to create "
+                       "new device %s", param->name);
                dm_put(md);
                return r;
        }
@@ -660,7 +668,8 @@ static int dev_remove(struct dm_ioctl *p
        hc =3D __find_device_hash_cell(param);

        if (!hc) {
-               DMWARN("device doesn't appear to be in the dev hash table=
.");
+               DMLOG(DMLOG_IOCTL, DMLOG_WARN, "device doesn't appear "
+                       "to be in the dev hash table.");
                up_write(&_hash_lock);
                return -ENXIO;
        }
@@ -672,7 +681,8 @@ static int dev_remove(struct dm_ioctl *p
         */
        r =3D dm_lock_for_deletion(md);
        if (r) {
-               DMWARN("unable to remove open device %s", hc->name);
+               DMLOG(DMLOG_IOCTL, DMLOG_WARN, "unable to remove open "
+                       "device %s", hc->name);
                up_write(&_hash_lock);
                dm_put(md);
                return r;
@@ -709,7 +719,8 @@ static int dev_rename(struct dm_ioctl *p
        if (new_name < param->data ||
            invalid_str(new_name, (void *) param + param_size) ||
            strlen(new_name) > DM_NAME_LEN - 1) {
-               DMWARN("Invalid new logical volume name supplied.");
+               DMLOG(DMLOG_IOCTL, DMLOG_WARN, "Invalid new logical "
+                       "volume name supplied.");
                return -EINVAL;
        }

@@ -735,7 +746,7 @@ static int dev_set_geometry(struct dm_io

        if (geostr < param->data ||
            invalid_str(geostr, (void *) param + param_size)) {
-               DMWARN("Invalid geometry supplied.");
+               DMLOG(DMLOG_IOCTL, DMLOG_WARN, "Invalid geometry supplied=
.");
                goto out;
        }

@@ -743,13 +754,15 @@ static int dev_set_geometry(struct dm_io
                   indata + 1, indata + 2, indata + 3);

        if (x !=3D 4) {
-               DMWARN("Unable to interpret geometry settings.");
+               DMLOG(DMLOG_IOCTL, DMLOG_WARN, "Unable to interpret "
+                       "geometry settings.");
                goto out;
        }

        if (indata[0] > 65535 || indata[1] > 255 ||
            indata[2] > 255 || indata[3] > ULONG_MAX) {
-               DMWARN("Geometry exceeds range limits.");
+               DMLOG(DMLOG_IOCTL, DMLOG_WARN, "Geometry exceeds "
+                       "range limits.");
                goto out;
        }

@@ -806,7 +819,8 @@ static int do_resume(struct dm_ioctl *pa

        hc =3D __find_device_hash_cell(param);
        if (!hc) {
-               DMWARN("device doesn't appear to be in the dev hash table=
.");
+               DMLOG(DMLOG_IOCTL, DMLOG_WARN, "device doesn't appear to =
be "
+                       "in the dev hash table.");
                up_write(&_hash_lock);
                return -ENXIO;
        }
@@ -1026,7 +1040,8 @@ static int populate_table(struct dm_tabl
        char *target_params;

        if (!param->target_count) {
-               DMWARN("populate_table: no targets specified");
+               DMLOG(DMLOG_IOCTL, DMLOG_WARN, "populate_table: no target=
s"
+                       " specified");
                return -EINVAL;
        }

@@ -1034,7 +1049,7 @@ static int populate_table(struct dm_tabl

                r =3D next_target(spec, next, end, &spec, &target_params)=
;
                if (r) {
-                       DMWARN("unable to find target");
+                       DMLOG(DMLOG_IOCTL, DMLOG_WARN, "unable to find ta=
rget");
                        return r;
                }

@@ -1043,7 +1058,8 @@ static int populate_table(struct dm_tabl
                                        (sector_t) spec->length,
                                        target_params);
                if (r) {
-                       DMWARN("error adding target to table");
+                       DMLOG(DMLOG_IOCTL, DMLOG_WARN, "error adding targ=
et "
+                               "to table");
                        return r;
                }

@@ -1052,7 +1068,7 @@ static int populate_table(struct dm_tabl

        r =3D dm_table_set_type(table);
        if (r) {
-               DMWARN("unable to set table type");
+               DMLOG(DMLOG_IOCTL, DMLOG_WARN, "unable to set table type"=
);
                return r;
        }

@@ -1095,15 +1111,16 @@ static int table_load(struct dm_ioctl *p

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
+               DMLOG(DMLOG_IOCTL, DMLOG_WARN, "unable to allocate mempoo=
ls"
+                       " for this table");
                dm_table_destroy(t);
                goto out;
        }
@@ -1111,7 +1128,8 @@ static int table_load(struct dm_ioctl *p
        down_write(&_hash_lock);
        hc =3D dm_get_mdptr(md);
        if (!hc || hc->md !=3D md) {
-               DMWARN("device has been removed from the dev hash table."=
);
+               DMLOG(DMLOG_IOCTL, DMLOG_WARN, "device has been removed f=
rom"
+                       " the dev hash table.");
                dm_table_destroy(t);
                up_write(&_hash_lock);
                r =3D -ENXIO;
@@ -1142,7 +1160,8 @@ static int table_clear(struct dm_ioctl *

        hc =3D __find_device_hash_cell(param);
        if (!hc) {
-               DMWARN("device doesn't appear to be in the dev hash table=
.");
+               DMLOG(DMLOG_IOCTL, DMLOG_WARN, "device doesn't appear "
+                       "to be in the dev hash table.");
                up_write(&_hash_lock);
                return -ENXIO;
        }
@@ -1277,14 +1296,16 @@ static int target_message(struct dm_ioct

        if (tmsg < (struct dm_target_msg *) param->data ||
            invalid_str(tmsg->message, (void *) param + param_size)) {
-               DMWARN("Invalid target message parameters.");
+               DMLOG(DMLOG_IOCTL, DMLOG_WARN, "Invalid target message"
+                       " parameters.");
                r =3D -EINVAL;
                goto out;
        }

        r =3D dm_split_args(&argc, &argv, tmsg->message);
        if (r) {
-               DMWARN("Failed to split target message parameters");
+               DMLOG(DMLOG_IOCTL, DMLOG_WARN, "Failed to split target"
+                       " message parameters");
                goto out;
        }

@@ -1294,12 +1315,14 @@ static int target_message(struct dm_ioct

        ti =3D dm_table_find_target(table, tmsg->sector);
        if (!dm_target_is_valid(ti)) {
-               DMWARN("Target message sector outside device.");
+               DMLOG(DMLOG_IOCTL, DMLOG_WARN, "Target message sector "
+                       "outside device.");
                r =3D -EINVAL;
        } else if (ti->type->message)
                r =3D ti->type->message(ti, argc, argv);
        else {
-               DMWARN("Target type does not support messages");
+               DMLOG(DMLOG_IOCTL, DMLOG_WARN, "Target type does not "
+                       "support messages");
                r =3D -EINVAL;
        }

@@ -1361,7 +1384,7 @@ static int check_version(unsigned int cm

        if ((DM_VERSION_MAJOR !=3D version[0]) ||
            (DM_VERSION_MINOR < version[1])) {
-               DMWARN("ioctl interface mismatch: "
+               DMLOG(DMLOG_IOCTL, DMLOG_WARN, "ioctl interface mismatch:=
 "
                       "kernel(%u.%u.%u), user(%u.%u.%u), cmd(%d)",
                       DM_VERSION_MAJOR, DM_VERSION_MINOR,
                       DM_VERSION_PATCHLEVEL,
@@ -1422,11 +1445,13 @@ static int validate_params(uint cmd, str

        if ((cmd =3D=3D DM_DEV_CREATE_CMD)) {
                if (!*param->name) {
-                       DMWARN("name not supplied when creating device");
+                       DMLOG(DMLOG_IOCTL, DMLOG_WARN, "name not supplied=
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

@@ -1461,6 +1486,8 @@ static int ctl_ioctl(uint command, struc
        r =3D check_version(cmd, user);
        if (r)
                return r;
+       DMLOG(DMLOG_IOCTL, DMLOG_INFO,  "IOCTL command "
+               "0x%x called from userspace.", command);

        /*
         * Nothing more to do for the version command.
@@ -1470,7 +1497,7 @@ static int ctl_ioctl(uint command, struc

        fn =3D lookup_ioctl(cmd);
        if (!fn) {
-               DMWARN("dm_ctl_ioctl: unknown command 0x%x", command);
+               DMLOG(DMLOG_IOCTL, DMLOG_ERR, "unknown command 0x%x", com=
mand);
                return -ENOTTY;
        }

@@ -1549,21 +1576,23 @@ int __init dm_interface_init(void)

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
+++ linux-2.6.31-rc8/drivers/md/dm-mpath.c      2009-09-06 05:07:31.00000=
0000 +0530
@@ -141,7 +141,8 @@ static void deactivate_path(struct work_
 {
        struct pgpath *pgpath =3D
                container_of(work, struct pgpath, deactivate_path);
-
+       DMLOG(DMLOG_PATH_DEACTIVATE, DMLOG_CRIT, "Deactivating path:"
+               " Aborting all I/O on %s queue", pgpath->path.dev->name);
        blk_abort_queue(pgpath->path.dev->bdev->bd_disk->queue);
 }

@@ -161,8 +162,15 @@ static void free_pgpaths(struct list_hea
 {
        struct pgpath *pgpath, *tmp;
        struct multipath *m =3D ti->private;
+       #ifdef CONFIG_DM_DEBUG
+               char name[16];
+               dm_target_device_name(ti, name);
+       #endif

        list_for_each_entry_safe(pgpath, tmp, pgpaths, list) {
+               DMLOG(DMLOG_PATH_DEACTIVATE, DMLOG_CRIT,
+                       "Removing path %s from pathgroup %d",
+                       pgpath->path.dev->name, pgpath->pg->pg_num, name)=
;
                list_del(&pgpath->list);
                if (m->hw_handler_name)
                        scsi_dh_detach(bdev_get_queue(pgpath->path.dev->b=
dev));
@@ -188,7 +196,6 @@ static void free_priority_group(struct p
 static struct multipath *alloc_multipath(struct dm_target *ti)
 {
        struct multipath *m;
-
        m =3D kzalloc(sizeof(*m), GFP_KERNEL);
        if (m) {
                INIT_LIST_HEAD(&m->priority_groups);
@@ -199,6 +206,8 @@ static struct multipath *alloc_multipath
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
@@ -240,7 +249,8 @@ static void __switch_pg(struct multipath
                m->pg_init_required =3D 0;
                m->queue_io =3D 0;
        }
-
+       DMLOG(DMLOG_FAILOVER, DMLOG_CRIT, "Swtiching to pathgroup %u",
+               pgpath->pg->pg_num);
        m->pg_init_count =3D 0;
 }

@@ -257,6 +267,8 @@ static int __choose_path_in_pg(struct mu

        if (m->current_pg !=3D pg)
                __switch_pg(m, m->current_pgpath);
+       DMLOG(DMLOG_FAILOVER, DMLOG_INFO, "Selecting path %s for I/O",
+               m->current_pgpath->path.dev->name);

        return 0;
 }
@@ -352,10 +364,11 @@ static int map_io(struct multipath *m, s
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
@@ -384,6 +397,7 @@ static int queue_if_no_path(struct multi
        else
                m->saved_queue_if_no_path =3D queue_if_no_path;
        m->queue_if_no_path =3D queue_if_no_path;
+
        if (!m->queue_if_no_path && m->queue_size)
                queue_work(kmultipathd, &m->process_queued_ios);

@@ -732,8 +746,9 @@ static int parse_hw_handler(struct arg_s
        }

        if (hw_argc > 1)
-               DMWARN("Ignoring user-specified arguments for "
-                      "hardware handler \"%s\"", m->hw_handler_name);
+               DMLOG(DMLOG_INIT, DMLOG_WARN, "Ignoring user-specified "
+                       "arguments for hardware handler \"%s\"",
+                       m->hw_handler_name);
        consume(as, hw_argc - 1);

        return 0;
@@ -903,7 +918,8 @@ static int fail_path(struct pgpath *pgpa
        if (!pgpath->is_active)
                goto out;

-       DMWARN("Failing path %s.", pgpath->path.dev->name);
+       DMLOG(DMLOG_PATH_DEACTIVATE, DMLOG_CRIT, "Failing path %s",
+               pgpath->path.dev->name);

        pgpath->pg->ps.type->fail_path(&pgpath->pg->ps, &pgpath->path);
        pgpath->is_active =3D 0;
@@ -911,6 +927,7 @@ static int fail_path(struct pgpath *pgpa

        m->nr_valid_paths--;

+
        if (pgpath =3D=3D m->current_pgpath)
                m->current_pgpath =3D NULL;

@@ -935,14 +952,16 @@ static int reinstate_path(struct pgpath
        unsigned long flags;
        struct multipath *m =3D pgpath->pg->m;

+
        spin_lock_irqsave(&m->lock, flags);

        if (pgpath->is_active)
                goto out;

        if (!pgpath->pg->ps.type->reinstate_path) {
-               DMWARN("Reinstate path not supported by path selector %s"=
,
-                      pgpath->pg->ps.type->name);
+               DMLOG(DMLOG_PATH_ACTIVATE, DMLOG_WARN, "Reinstate path "
+                       "not supported by path selector %s",
+                       pgpath->pg->ps.type->name);
                r =3D -EINVAL;
                goto out;
        }
@@ -951,6 +970,9 @@ static int reinstate_path(struct pgpath
        if (r)
                goto out;

+       DMLOG(DMLOG_PATH_ACTIVATE, DMLOG_CRIT, "Path %s sucessfuly reinst=
ated",
+               pgpath->path.dev->name);
+
        pgpath->is_active =3D 1;

        if (!m->nr_valid_paths++ && m->queue_size) {
@@ -1022,7 +1044,8 @@ static int switch_pg_num(struct multipat

        if (!pgstr || (sscanf(pgstr, "%u", &pgnum) !=3D 1) || !pgnum ||
            (pgnum > m->nr_priority_groups)) {
-               DMWARN("invalid PG number supplied to switch_pg_num");
+               DMLOG(DMLOG_FAILOVER, DMLOG_WARN, "invalid PG number"
+                       " supplied to switch_pg_num");
                return -EINVAL;
        }

@@ -1053,7 +1076,8 @@ static int bypass_pg_num(struct multipat

        if (!pgstr || (sscanf(pgstr, "%u", &pgnum) !=3D 1) || !pgnum ||
            (pgnum > m->nr_priority_groups)) {
-               DMWARN("invalid PG number supplied to bypass_pg");
+               DMLOG(DMLOG_FAILOVER, DMLOG_WARN, "invalid PG number "
+                       "supplied to bypass_pg");
                return -EINVAL;
        }

@@ -1076,6 +1100,10 @@ static int pg_init_limit_reached(struct

        spin_lock_irqsave(&m->lock, flags);

+       DMLOG(DMLOG_FAILOVER, DMLOG_INFO, "pg_init_retries =3D %d, "
+               "pg_init_count =3D %d", m->pg_init_retries,
+               m->pg_init_count);
+
        if (m->pg_init_count <=3D m->pg_init_retries)
                m->pg_init_required =3D 1;
        else
@@ -1094,6 +1122,9 @@ static void pg_init_done(struct dm_path
        unsigned long flags;

        /* device or driver problems */
+       DMLOG(DMLOG_FAILOVER, DMLOG_INFO, "%s: failover status =3D %d ",
+               pgpath->path.dev->name, errors);
+
        switch (errors) {
        case SCSI_DH_OK:
                break;
@@ -1102,8 +1133,9 @@ static void pg_init_done(struct dm_path
                        errors =3D 0;
                        break;
                }
-               DMERR("Cannot failover device because scsi_dh_%s was not =
"
-                     "loaded.", m->hw_handler_name);
+               DMLOG(DMLOG_FAILOVER, DMLOG_ERR, "Cannot failover "
+                       "device because scsi_dh_%s was not loaded.",
+                       m->hw_handler_name);
                /*
                 * Fail path for now, so we do not ping pong
                 */
@@ -1136,7 +1168,8 @@ static void pg_init_done(struct dm_path
        spin_lock_irqsave(&m->lock, flags);
        if (errors) {
                if (pgpath =3D=3D m->current_pgpath) {
-                       DMERR("Could not failover device. Error %d.", err=
ors);
+                       DMLOG(DMLOG_FAILOVER, DMLOG_ERR, "Could not failo=
ver "
+                               "device. Error %d.", errors);
                        m->current_pgpath =3D NULL;
                        m->current_pg =3D NULL;
                }
@@ -1181,6 +1214,7 @@ static int do_end_io(struct multipath *m
        int r =3D DM_ENDIO_REQUEUE;
        unsigned long flags;

+
        if (!error && !clone->errors)
                return 0;       /* I/O complete */

@@ -1191,8 +1225,12 @@ static int do_end_io(struct multipath *m
                fail_path(mpio->pgpath);

        spin_lock_irqsave(&m->lock, flags);
-       if (!m->nr_valid_paths && !m->queue_if_no_path && !__must_push_ba=
ck(m))
+       if (!m->nr_valid_paths && !m->queue_if_no_path &&
+               !__must_push_back(m)) {
                r =3D -EIO;
+               DMLOG(DMLOG_IO, DMLOG_CRIT, "Failing I/O on %s",
+                       m->current_pgpath->path.dev->name);
+       }
        spin_unlock_irqrestore(&m->lock, flags);

        return r;
@@ -1382,6 +1420,7 @@ static int multipath_message(struct dm_t
        if (argc !=3D 2)
                goto error;

+
        if (!strnicmp(argv[0], MESG_STR("disable_group")))
                return bypass_pg_num(m, argv[1], 1);
        else if (!strnicmp(argv[0], MESG_STR("enable_group")))
@@ -1398,8 +1437,8 @@ static int multipath_message(struct dm_t
        r =3D dm_get_device(ti, argv[1], ti->begin, ti->len,
                          dm_table_get_mode(ti->table), &dev);
        if (r) {
-               DMWARN("message: error getting device %s",
-                      argv[1]);
+               DMLOG(DMLOG_IOCTL, DMLOG_WARN, "message: error getting "
+                       "device %s", argv[1]);
                return -EINVAL;
        }

@@ -1410,7 +1449,8 @@ static int multipath_message(struct dm_t
        return r;

 error:
-       DMWARN("Unrecognised multipath message received.");
+       DMLOG(DMLOG_IOCTL, DMLOG_WARN, "Unrecognised multipath "
+               "message received.");
        return -EINVAL;
 }

@@ -1563,14 +1603,15 @@ static int __init dm_multipath_init(void

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
@@ -1584,14 +1625,14 @@ static int __init dm_multipath_init(void
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
+++ linux-2.6.31-rc8/drivers/md/dm-path-selector.c      2009-09-06 04:30:=
01.000000000 +0530
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
+++ linux-2.6.31-rc8/drivers/md/dm-table.c      2009-09-06 05:20:22.00000=
0000 +0530
@@ -227,8 +227,9 @@ static void free_devices(struct list_hea
        list_for_each_safe(tmp, next, devices) {
                struct dm_dev_internal *dd =3D
                    list_entry(tmp, struct dm_dev_internal, list);
-               DMWARN("dm_table_destroy: dm_put_device call missing for =
%s",
-                      dd->dm_dev.name);
+               DMLOG(DMLOG_TABLE, DMLOG_WARN, "dm_table_destroy: "
+                       "dm_put_device call missing for %s",
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
+                       "h/w logical block size %hu" dm_device_name(table=
->md),
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
+                       DMLOG(DMLOG_TABLE, DMLOG_WARN, "Inconsistent tabl=
e: "
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
+++ linux-2.6.31-rc8/drivers/md/dm-uevent.c     2009-09-06 04:52:26.00000=
0000 +0530
@@ -78,40 +78,41 @@ static struct dm_uevent *dm_build_path_u

        event =3D dm_uevent_alloc(md);
        if (!event) {
-               DMERR("%s: dm_uevent_alloc() failed", __func__);
+               DMLOG(DMLOG_UEVENT, DMLOG_ERR, " dm_uevent_alloc() failed=
");
                goto err_nomem;
        }

        event->action =3D action;

        if (add_uevent_var(&event->ku_env, "DM_TARGET=3D%s", ti->type->na=
me)) {
-               DMERR("%s: add_uevent_var() for DM_TARGET failed",
-                     __func__);
+               DMLOG(DMLOG_UEVENT, DMLOG_ERR, "add_uevent_var() "
+                       "for DM_TARGET failed");
                goto err_add;
        }

        if (add_uevent_var(&event->ku_env, "DM_ACTION=3D%s", dm_action)) =
{
-               DMERR("%s: add_uevent_var() for DM_ACTION failed",
-                     __func__);
+               DMLOG(DMLOG_UEVENT, DMLOG_ERR, "add_uevent_var() for "
+                       "DM_ACTION failed");
                goto err_add;
        }

        if (add_uevent_var(&event->ku_env, "DM_SEQNUM=3D%u",
                           dm_next_uevent_seq(md))) {
-               DMERR("%s: add_uevent_var() for DM_SEQNUM failed",
-                     __func__);
+               DMLOG(DMLOG_UEVENT, DMLOG_ERR, "add_uevent_var() for "
+                       "DM_SEQNUM failed");
                goto err_add;
        }

        if (add_uevent_var(&event->ku_env, "DM_PATH=3D%s", path)) {
-               DMERR("%s: add_uevent_var() for DM_PATH failed", __func__=
);
+               DMLOG(DMLOG_UEVENT, DMLOG_ERR, "add_uevent_var() for "
+                       "DM_PATH failed");
                goto err_add;
        }

        if (add_uevent_var(&event->ku_env, "DM_NR_VALID_PATHS=3D%d",
                           nr_valid_paths)) {
-               DMERR("%s: add_uevent_var() for DM_NR_VALID_PATHS failed"=
,
-                     __func__);
+               DMLOG(DMLOG_UEVENT, DMLOG_ERR, "add_uevent_var() for "
+                       "DM_NR_VALID_PATHS failed");
                goto err_add;
        }

@@ -145,26 +146,27 @@ void dm_send_uevents(struct list_head *e
                 */
                if (dm_copy_name_and_uuid(event->md, event->name,
                                          event->uuid)) {
-                       DMERR("%s: dm_copy_name_and_uuid() failed",
-                             __func__);
+                       DMLOG(DMLOG_UEVENT, DMLOG_ERR, "%s: "
+                               "dm_copy_name_and_uuid() "
                        goto uevent_free;
                }

                if (add_uevent_var(&event->ku_env, "DM_NAME=3D%s", event-=
>name)) {
-                       DMERR("%s: add_uevent_var() for DM_NAME failed",
-                             __func__);
+                       DMLOG(DMLOG_UEVENT, DMLOG_ERR, "add_uevent_var() =
"
+                               "for DM_NAME failed");
                        goto uevent_free;
                }

                if (add_uevent_var(&event->ku_env, "DM_UUID=3D%s", event-=
>uuid)) {
-                       DMERR("%s: add_uevent_var() for DM_UUID failed",
-                             __func__);
+                       DMLOG(DMLOG_UEVENT, DMLOG_ERR, "add_uevent_var() =
"
+                               "for DM_UUID failed");
                        goto uevent_free;
                }

                r =3D kobject_uevent_env(kobj, event->action, event->ku_e=
nv.envp);
                if (r)
-                       DMERR("%s: kobject_uevent_env failed", __func__);
+                       DMLOG(DMLOG_UEVENT, DMLOG_ERR,
+                               "kobject_uevent_env failed");
 uevent_free:
                dm_uevent_free(event);
        }
@@ -187,7 +189,8 @@ void dm_path_uevent(enum dm_uevent_type
        struct dm_uevent *event;

        if (event_type >=3D ARRAY_SIZE(_dm_uevent_type_names)) {
-               DMERR("%s: Invalid event_type %d", __func__, event_type);
+               DMLOG(DMLOG_UEVENT, DMLOG_ERR,
+                       "Invalid event_type %d", event_type);
                goto out;
        }

@@ -211,7 +214,7 @@ int dm_uevent_init(void)
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
+++ linux-2.6.31-rc8/include/linux/device-mapper.h      2009-09-06 05:25:=
39.000000000 +0530
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

--
