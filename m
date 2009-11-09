From: "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>
Subject: [Patch 2/2][RESEND] New Logging approach for Device
	Mapper
Date: Mon, 9 Nov 2009 16:37:57 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C1C93C03EA7@inbmail01.lsi.com>
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
To: "agk@redhat.com" <agk@redhat.com>, "hare@suse.de" <hare@suse.de>, "sekharan@linux.vnet.ibm.com" <sekharan@linux.vnet.ibm.com>, device-mapper development <dm-devel@redhat.com>
Cc: "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>, "Stankey,
	Robert" <Robert.Stankey@lsi.com>, "Moger, Babu" <Babu.Moger@lsi.com>
List-Id: dm-devel.ids

This patch replaces the old logging macro (DMWARN, DMERR, DMINFO ...) to =
new (DMLOG, DMLOG1, DMLOG2) in Device mapper.

Signed-off-by: Vijay Chauhan <vijay.chauhan@lsi.com>
---
diff -uprN linux-2.6.32-rc5-patch1/drivers/md/dm.c linux-2.6.32-rc5/drive=
rs/md/dm.c
--- linux-2.6.32-rc5-patch1/drivers/md/dm.c     2009-11-09 20:34:05.00000=
0000 +0530
+++ linux-2.6.32-rc5/drivers/md/dm.c    2009-11-09 20:36:59.000000000 +05=
30
@@ -271,7 +271,7 @@ static void local_exit(void)

        _major =3D 0;

-       DMINFO("cleaned up");
+       DMLOG(DMLOG_INIT, DMLOG_INFO, "cleaned up");
 }

 static int (*_inits[])(void) __initdata =3D {
@@ -548,7 +548,8 @@ int dm_set_geometry(struct mapped_device
        sector_t sz =3D (sector_t)geo->cylinders * geo->heads * geo->sect=
ors;

        if (geo->start > sz) {
-               DMWARN("Start sector is beyond the geometry limits.");
+               DMLOG1(DMLOG_ADD_DEV, DMLOG_WARN, md,
+                       "Start sector is beyond the geometry limits.");
                return -EINVAL;
        }

@@ -651,7 +652,9 @@ static void clone_endio(struct bio *bio,
                        /* The target will handle the io */
                        return;
                else if (r) {
-                       DMWARN("unimplemented target endio return value: =
%d", r);
+                       DMLOG1(DMLOG_IO, DMLOG_WARN, md,
+                               "unimplemented target endio "
+                               "return value: %d", r);
                        BUG();
                }
        }
@@ -675,6 +678,7 @@ static void end_clone_bio(struct bio *cl
        struct dm_rq_target_io *tio =3D info->tio;
        struct bio *bio =3D info->orig;
        unsigned int nr_bytes =3D info->orig->bi_size;
+       struct mapped_device *md =3D tio->md;

        bio_put(clone);

@@ -706,7 +710,8 @@ static void end_clone_bio(struct bio *cl
         * If it's not, something wrong is happening.
         */
        if (tio->orig->bio !=3D bio)
-               DMERR("bio completion is going in the middle of the reque=
st");
+               DMLOG1(DMLOG_IO, DMLOG_ERR, md,
+                       "bio completion is going in the middle of the req=
uest");

        /*
         * Update the original request.
@@ -854,6 +859,7 @@ static void dm_softirq_done(struct reque
        struct dm_rq_target_io *tio =3D clone->end_io_data;
        dm_request_endio_fn rq_end_io =3D tio->ti->type->rq_end_io;
        int error =3D tio->error;
+       struct mapped_device *md =3D tio->md;

        if (!(rq->cmd_flags & REQ_FAILED) && rq_end_io)
                error =3D rq_end_io(tio->ti, clone, error, &tio->info);
@@ -868,7 +874,9 @@ static void dm_softirq_done(struct reque
                /* The target wants to requeue the I/O */
                dm_requeue_unmapped_request(clone);
        else {
-               DMWARN("unimplemented target endio return value: %d", err=
or);
+               DMLOG1(DMLOG_IO, DMLOG_WARN, md,
+                       "unimplemented target endio return"
+                       " value: %d", error);
                BUG();
        }
 }
@@ -983,7 +991,9 @@ static void __map_bio(struct dm_target *
                bio_put(clone);
                free_tio(md, tio);
        } else if (r) {
-               DMWARN("unimplemented target map return value: %d", r);
+               md =3D tio->io->md;
+               DMLOG1(DMLOG_IO, DMLOG_WARN, md,
+                       "unimplemented target map return value: %d", r);
                BUG();
        }
 }
@@ -1458,7 +1468,8 @@ static int dm_prep_fn(struct request_que
        }

        if (unlikely(rq->special)) {
-               DMWARN("Already has something in rq->special.");
+                       DMLOG1(DMLOG_IO, DMLOG_WARN, md, "Already has som=
ething"
+                               " in rq->special.");
                return BLKPREP_KILL;
        }

@@ -1518,7 +1529,9 @@ static void map_request(struct dm_target
                break;
        default:
                if (r > 0) {
-                       DMWARN("unimplemented target map return value: %d=
", r);
+                       DMLOG1(DMLOG_IO, DMLOG_WARN, md,
+                               "unimplemented target map return value: %=
d",
+                               r);
                        BUG();
                }

@@ -1735,7 +1748,8 @@ static struct mapped_device *alloc_dev(i
        void *old_md;

        if (!md) {
-               DMWARN("unable to allocate device, out of memory.");
+               DMLOG(DMLOG_INIT, DMLOG_WARN, "unable to allocate "
+                       "device(MINOR %d), out of memory.", minor);
                return NULL;
        }

@@ -2055,6 +2069,7 @@ char *dm_gendisk_device_name(struct mapp
          struct gendisk *disk =3D dm_disk(md);
          return  disk->disk_name;
 }
+EXPORT_SYMBOL_GPL(dm_gendisk_device_name);

 struct mapped_device *dm_target_get_md(struct dm_target *ti)
 {
@@ -2225,7 +2240,8 @@ int dm_swap_table(struct mapped_device *
        /* cannot change the device type, once a table is bound */
        if (md->map &&
            (dm_table_get_type(md->map) !=3D dm_table_get_type(table))) {
-               DMWARN("can't change the device type after a table is bou=
nd");
+               DMLOG1(DMLOG_IO, DMLOG_WARN, md,
+                       "can't change the device type after a table is bo=
und");
                goto out;
        }

@@ -2289,8 +2305,9 @@ static int dm_rq_suspend_available(struc
                 * start another flush suspend while it is in use.
                 */
                BUG_ON(!rq->special); /* The marker should be invalidated=
 */
-               DMWARN("Invalidating the previous flush suspend is still =
in"
-                      " progress.  Please retry later.");
+               DMLOG1(DMLOG_IO, DMLOG_WARN, md,
+                       "Invalidating the previous flush "
+                       "suspend is still in progress. Please retry later=
.");
                r =3D 0;
        }
        spin_unlock_irqrestore(q->queue_lock, flags);
@@ -2409,8 +2426,11 @@ int dm_suspend(struct mapped_device *md,
         * DMF_NOFLUSH_SUSPENDING must be set before presuspend.
         * This flag is cleared before dm_suspend returns.
         */
-       if (noflush)
+       if (noflush) {
                set_bit(DMF_NOFLUSH_SUSPENDING, &md->flags);
+               DMLOG1(DMLOG_IOCTL, DMLOG_INFO, md,
+                       "Setting DMF_NOFLUSH_SUSPENDING flag");
+       }

        /* This does not get reverted if there's an error later. */
        dm_table_presuspend_targets(map);
@@ -2441,6 +2461,10 @@ int dm_suspend(struct mapped_device *md,
         * dm_wq_work exits and DMF_BLOCK_IO_FOR_SUSPEND will prevent any
         * further calls to __split_and_process_bio from dm_wq_work.
         */
+       DMLOG1(DMLOG_IOCTL, DMLOG_INFO, md,
+               "Setting DMF_BLOCK_IO_FOR_SUSPEND and "
+               "DMF_QUEUE_IO_TO_THREAD flags");
+
        down_write(&md->io_lock);
        set_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags);
        set_bit(DMF_QUEUE_IO_TO_THREAD, &md->flags);
@@ -2459,8 +2483,11 @@ int dm_suspend(struct mapped_device *md,
        r =3D dm_wait_for_completion(md, TASK_INTERRUPTIBLE);

        down_write(&md->io_lock);
-       if (noflush)
+       if (noflush) {
                clear_bit(DMF_NOFLUSH_SUSPENDING, &md->flags);
+               DMLOG1(DMLOG_IOCTL, DMLOG_INFO, md,
+                       "Unsetting DMF_NOFLUSH_SUSPENDING");
+       }
        up_write(&md->io_lock);

        /* were we interrupted ? */
@@ -2482,6 +2509,9 @@ int dm_suspend(struct mapped_device *md,

        dm_table_postsuspend_targets(map);

+       DMLOG1(DMLOG_IOCTL, DMLOG_INFO, md,
+               "Setting DMF_SUSPENDED flag");
+
        set_bit(DMF_SUSPENDED, &md->flags);

 out:
@@ -2521,6 +2551,8 @@ int dm_resume(struct mapped_device *md)

        unlock_fs(md);

+       DMLOG1(DMLOG_IOCTL, DMLOG_INFO, md,
+               "Unsetting DMF_SUSPENDED flag");
        clear_bit(DMF_SUSPENDED, &md->flags);

        dm_table_unplug_all(map);
diff -uprN linux-2.6.32-rc5-patch1/drivers/md/dm-ioctl.c linux-2.6.32-rc5=
/drivers/md/dm-ioctl.c
--- linux-2.6.32-rc5-patch1/drivers/md/dm-ioctl.c       2009-11-09 20:34:=
05.000000000 +0530
+++ linux-2.6.32-rc5/drivers/md/dm-ioctl.c      2009-11-09 20:36:59.00000=
0000 +0530
@@ -77,6 +77,7 @@ static void dm_hash_exit(void)
        dm_hash_remove_all(0);
 }

+
 /*-----------------------------------------------------------------
  * Hash function:
  * We're not really concerned with the str hash function being
@@ -195,6 +196,9 @@ static int dm_hash_insert(const char *na
                goto bad;
        }

+       DMLOG1(DMLOG_ADD_DEV, DMLOG_INFO, md,
+               "Inserting in hash table");
+
        list_add(&cell->name_list, _name_buckets + hash_str(name));

        if (uuid) {
@@ -202,6 +206,8 @@ static int dm_hash_insert(const char *na
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
@@ -210,6 +216,9 @@ static int dm_hash_insert(const char *na
        dm_set_mdptr(md, cell);
        up_write(&_hash_lock);

+       DMLOG1(DMLOG_ADD_DEV, DMLOG_INFO, md, "Successfully inserted "
+               "in hash table ");
+
        return 0;

  bad:
@@ -271,7 +280,8 @@ retry:
                if (dev_removed)
                        goto retry;

-               DMWARN("remove_all left %d open device(s)", dev_skipped);
+       DMLOG(DMLOG_IOCTL, DMLOG_WARN, "remove_all left "
+               "%d open device(s)", dev_skipped);
        }

        up_write(&_hash_lock);
@@ -297,8 +307,8 @@ static int dm_hash_rename(uint32_t cooki
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
@@ -310,8 +320,8 @@ static int dm_hash_rename(uint32_t cooki
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
@@ -518,7 +528,8 @@ static int list_versions(struct dm_ioctl
 static int check_name(const char *name)
 {
        if (strchr(name, '/')) {
-               DMWARN("invalid device name");
+               DMLOG(DMLOG_IOCTL, DMLOG_ERR, "%s: Invalid device name "
+                       , name);
                return -EINVAL;
        }

@@ -577,12 +588,18 @@ static int dev_create(struct dm_ioctl *p
        if (param->flags & DM_PERSISTENT_DEV_FLAG)
                m =3D MINOR(huge_decode_dev(param->dev));

+       DMLOG(DMLOG_ADD_DEV, DMLOG_INFO, "%s: Creating dm device",
+               param->name);
+
+
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
@@ -661,7 +678,8 @@ static int dev_remove(struct dm_ioctl *p
        hc =3D __find_device_hash_cell(param);

        if (!hc) {
-               DMWARN("device doesn't appear to be in the dev hash table=
.");
+               DMLOG(DMLOG_IOCTL, DMLOG_WARN, "%s: Device doesn't appear=
 "
+                        "be in the dev hash table.", param->name);
                up_write(&_hash_lock);
                return -ENXIO;
        }
@@ -673,7 +691,8 @@ static int dev_remove(struct dm_ioctl *p
         */
        r =3D dm_lock_for_deletion(md);
        if (r) {
-               DMWARN("unable to remove open device %s", hc->name);
+               DMLOG(DMLOG_IOCTL, DMLOG_WARN, "Unable to remove open "
+                       "device %s", hc->name);
                up_write(&_hash_lock);
                dm_put(md);
                return r;
@@ -710,6 +729,8 @@ static int dev_rename(struct dm_ioctl *p
        if (new_name < param->data ||
            invalid_str(new_name, (void *) param + param_size) ||
            strlen(new_name) > DM_NAME_LEN - 1) {
+               DMLOG(DMLOG_IOCTL, DMLOG_WARN, "%s: Invalid new logical "
+                       "volume name supplied.", param->name);
                DMWARN("Invalid new logical volume name supplied.");
                return -EINVAL;
        }
@@ -736,7 +757,8 @@ static int dev_set_geometry(struct dm_io

        if (geostr < param->data ||
            invalid_str(geostr, (void *) param + param_size)) {
-               DMWARN("Invalid geometry supplied.");
+               DMLOG(DMLOG_IOCTL, DMLOG_WARN, "%s: Invalid geometry "
+                       "supplied.", param->name);
                goto out;
        }

@@ -744,13 +766,16 @@ static int dev_set_geometry(struct dm_io
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
+
                goto out;
        }

@@ -807,7 +832,8 @@ static int do_resume(struct dm_ioctl *pa

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
@@ -1027,7 +1053,8 @@ static int populate_table(struct dm_tabl
        char *target_params;

        if (!param->target_count) {
-               DMWARN("populate_table: no targets specified");
+               DMLOG(DMLOG_IOCTL, DMLOG_WARN, "%s: populate_table: no ta=
rgets"
+                       " specified", param->name);
                return -EINVAL;
        }

@@ -1035,7 +1062,9 @@ static int populate_table(struct dm_tabl

                r =3D next_target(spec, next, end, &spec, &target_params)=
;
                if (r) {
-                       DMWARN("unable to find target");
+                       DMLOG(DMLOG_IOCTL, DMLOG_WARN, "%s: unable to fin=
d "
+                               "target", param->name);
+
                        return r;
                }

@@ -1044,7 +1073,9 @@ static int populate_table(struct dm_tabl
                                        (sector_t) spec->length,
                                        target_params);
                if (r) {
-                       DMWARN("error adding target to table");
+                       DMLOG(DMLOG_IOCTL, DMLOG_WARN, "%s: error adding =
"
+                               "target to table", param->name);
+
                        return r;
                }

@@ -1053,7 +1084,8 @@ static int populate_table(struct dm_tabl

        r =3D dm_table_set_type(table);
        if (r) {
-               DMWARN("unable to set table type");
+               DMLOG(DMLOG_IOCTL, DMLOG_WARN, "%s: unable to set table t=
ype",
+                       param->name);
                return r;
        }

@@ -1096,15 +1128,16 @@ static int table_load(struct dm_ioctl *p

        r =3D table_prealloc_integrity(t, md);
        if (r) {
-               DMERR("%s: could not register integrity profile.",
-                     dm_device_name(md));
+               DMLOG1(DMLOG_IOCTL, DMLOG_ERR, md,
+                       "could not register integrity profile.");
                dm_table_destroy(t);
                goto out;
        }

        r =3D dm_table_alloc_md_mempools(t);
        if (r) {
-               DMWARN("unable to allocate mempools for this table");
+               DMLOG1(DMLOG_IOCTL, DMLOG_WARN, md,
+                       "unable to allocate mempools for this table");
                dm_table_destroy(t);
                goto out;
        }
@@ -1112,7 +1145,8 @@ static int table_load(struct dm_ioctl *p
        down_write(&_hash_lock);
        hc =3D dm_get_mdptr(md);
        if (!hc || hc->md !=3D md) {
-               DMWARN("device has been removed from the dev hash table."=
);
+               DMLOG1(DMLOG_IOCTL, DMLOG_WARN, md,
+                       "device has been removed from the dev hash table.=
");
                dm_table_destroy(t);
                up_write(&_hash_lock);
                r =3D -ENXIO;
@@ -1143,7 +1177,8 @@ static int table_clear(struct dm_ioctl *

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
@@ -1278,14 +1313,16 @@ static int target_message(struct dm_ioct

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

@@ -1295,12 +1332,14 @@ static int target_message(struct dm_ioct

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

@@ -1362,7 +1401,7 @@ static int check_version(unsigned int cm

        if ((DM_VERSION_MAJOR !=3D version[0]) ||
            (DM_VERSION_MINOR < version[1])) {
-               DMWARN("ioctl interface mismatch: "
+               DMLOG(DMLOG_IOCTL, DMLOG_WARN, "ioctl interface mismatch:=
 "
                       "kernel(%u.%u.%u), user(%u.%u.%u), cmd(%d)",
                       DM_VERSION_MAJOR, DM_VERSION_MINOR,
                       DM_VERSION_PATCHLEVEL,
@@ -1423,11 +1462,13 @@ static int validate_params(uint cmd, str

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

@@ -1463,6 +1504,9 @@ static int ctl_ioctl(uint command, struc
        if (r)
                return r;

+       DMLOG(DMLOG_IOCTL, DMLOG_INFO,  "%s: IOCTL command from userspace=
 "
+               "0x%x.", user->name, command);
+
        /*
         * Nothing more to do for the version command.
         */
@@ -1471,7 +1515,8 @@ static int ctl_ioctl(uint command, struc

        fn =3D lookup_ioctl(cmd);
        if (!fn) {
-               DMWARN("dm_ctl_ioctl: unknown command 0x%x", command);
+               DMLOG(DMLOG_IOCTL, DMLOG_ERR, "%s: Unknown command 0x%x",
+                       user->name, command);
                return -ENOTTY;
        }

@@ -1550,21 +1595,23 @@ int __init dm_interface_init(void)

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
diff -uprN linux-2.6.32-rc5-patch1/drivers/md/dm-mpath.c linux-2.6.32-rc5=
/drivers/md/dm-mpath.c
--- linux-2.6.32-rc5-patch1/drivers/md/dm-mpath.c       2009-11-09 20:34:=
05.000000000 +0530
+++ linux-2.6.32-rc5/drivers/md/dm-mpath.c      2009-11-09 20:36:59.00000=
0000 +0530
@@ -141,7 +141,10 @@ static void deactivate_path(struct work_
 {
        struct pgpath *pgpath =3D
                container_of(work, struct pgpath, deactivate_path);
-
+       DMLOG2(DMLOG_PATH_DEACTIVATE, DMLOG_CRIT,
+               pgpath->pg->m->ti,
+               "Deactivating path. Aborting all I/O on %s queue",
+               pgpath->path.dev->bdev->bd_disk->disk_name);
        blk_abort_queue(pgpath->path.dev->bdev->bd_disk->queue);
 }

@@ -163,6 +166,11 @@ static void free_pgpaths(struct list_hea
        struct multipath *m =3D ti->private;

        list_for_each_entry_safe(pgpath, tmp, pgpaths, list) {
+               DMLOG2(DMLOG_PATH_DEACTIVATE, DMLOG_CRIT, ti,
+                       "Removing path %s from pathgroup index %d",
+                       pgpath->path.dev->bdev->bd_disk->disk_name,
+                       pgpath->pg->pg_num);
+
                list_del(&pgpath->list);
                if (m->hw_handler_name)
                        scsi_dh_detach(bdev_get_queue(pgpath->path.dev->b=
dev));
@@ -199,6 +207,8 @@ static struct multipath *alloc_multipath
                INIT_WORK(&m->trigger_event, trigger_event);
                m->mpio_pool =3D mempool_create_slab_pool(MIN_IOS, _mpio_=
cache);
                if (!m->mpio_pool) {
+                       DMLOG2(DMLOG_ADD_DEV, DMLOG_ERR, ti,
+                               "Failed. No mpio_pool available");
                        kfree(m);
                        return NULL;
                }
@@ -241,7 +251,8 @@ static void __switch_pg(struct multipath
                m->pg_init_required =3D 0;
                m->queue_io =3D 0;
        }
-
+       DMLOG2(DMLOG_FAILOVER, DMLOG_CRIT, m->ti,
+                        "Switching to pathgroup index %u", pgpath->pg->p=
g_num);
        m->pg_init_count =3D 0;
 }

@@ -259,6 +270,10 @@ static int __choose_path_in_pg(struct mu
        if (m->current_pg !=3D pg)
                __switch_pg(m, m->current_pgpath);

+       DMLOG2(DMLOG_FAILOVER, DMLOG_INFO, m->ti,
+               "Selecting path %s for I/O",
+               m->current_pgpath->path.dev->bdev->bd_disk->disk_name);
+
        return 0;
 }

@@ -932,7 +947,10 @@ static int fail_path(struct pgpath *pgpa
        if (!pgpath->is_active)
                goto out;

-       DMWARN("Failing path %s.", pgpath->path.dev->name);
+       DMLOG2(DMLOG_PATH_DEACTIVATE, DMLOG_CRIT,
+               m->ti, "Failing path %s",
+               pgpath->path.dev->bdev->bd_disk->disk_name);
+

        pgpath->pg->ps.type->fail_path(&pgpath->pg->ps, &pgpath->path);
        pgpath->is_active =3D 0;
@@ -970,8 +988,10 @@ static int reinstate_path(struct pgpath
                goto out;

        if (!pgpath->pg->ps.type->reinstate_path) {
-               DMWARN("Reinstate path not supported by path selector %s"=
,
-                      pgpath->pg->ps.type->name);
+               DMLOG2(DMLOG_PATH_ACTIVATE, DMLOG_WARN, m->ti,
+                       "Reinstate path not supported by path selector %s=
",
+                       pgpath->pg->ps.type->name);
+
                r =3D -EINVAL;
                goto out;
        }
@@ -980,6 +1000,10 @@ static int reinstate_path(struct pgpath
        if (r)
                goto out;

+       DMLOG2(DMLOG_PATH_ACTIVATE, DMLOG_CRIT, m->ti,
+               "Path %s sucessfuly reinstated",
+               pgpath->path.dev->bdev->bd_disk->disk_name);
+
        pgpath->is_active =3D 1;

        if (!m->nr_valid_paths++ && m->queue_size) {
@@ -1051,7 +1075,9 @@ static int switch_pg_num(struct multipat

        if (!pgstr || (sscanf(pgstr, "%u", &pgnum) !=3D 1) || !pgnum ||
            (pgnum > m->nr_priority_groups)) {
-               DMWARN("invalid PG number supplied to switch_pg_num");
+               DMLOG2(DMLOG_FAILOVER, DMLOG_WARN, m->ti,
+                       "Invalid PG number supplied to switch_pg_num");
+
                return -EINVAL;
        }

@@ -1082,7 +1108,8 @@ static int bypass_pg_num(struct multipat

        if (!pgstr || (sscanf(pgstr, "%u", &pgnum) !=3D 1) || !pgnum ||
            (pgnum > m->nr_priority_groups)) {
-               DMWARN("invalid PG number supplied to bypass_pg");
+               DMLOG2(DMLOG_FAILOVER, DMLOG_WARN, m->ti,
+                       "Invalid PG number supplied to bypass_pg");
                return -EINVAL;
        }

@@ -1105,6 +1132,10 @@ static int pg_init_limit_reached(struct

        spin_lock_irqsave(&m->lock, flags);

+       DMLOG2(DMLOG_FAILOVER, DMLOG_INFO, m->ti,
+               "pg_init_retries =3D %d, pg_init_count =3D %d",
+               m->pg_init_retries, m->pg_init_count);
+
        if (m->pg_init_count <=3D m->pg_init_retries)
                m->pg_init_required =3D 1;
        else
@@ -1123,6 +1154,9 @@ static void pg_init_done(struct dm_path
        unsigned long flags;

        /* device or driver problems */
+       DMLOG2(DMLOG_FAILOVER, DMLOG_INFO, m->ti,
+                "pg_init_done: failover status =3D %d ", errors);
+
        switch (errors) {
        case SCSI_DH_OK:
                break;
@@ -1131,8 +1165,10 @@ static void pg_init_done(struct dm_path
                        errors =3D 0;
                        break;
                }
-               DMERR("Cannot failover device because scsi_dh_%s was not =
"
-                     "loaded.", m->hw_handler_name);
+               DMLOG2(DMLOG_FAILOVER, DMLOG_ERR, m->ti,
+                       "Cannot failover device because scsi_dh_%s was "
+                       "not loaded.", m->hw_handler_name);
+
                /*
                 * Fail path for now, so we do not ping pong
                 */
@@ -1165,7 +1201,10 @@ static void pg_init_done(struct dm_path
        spin_lock_irqsave(&m->lock, flags);
        if (errors) {
                if (pgpath =3D=3D m->current_pgpath) {
-                       DMERR("Could not failover device. Error %d.", err=
ors);
+                       DMLOG2(DMLOG_FAILOVER, DMLOG_ERR,
+                               m->ti,
+                               "Could not failover device. Error %d.", e=
rrors);
+
                        m->current_pgpath =3D NULL;
                        m->current_pg =3D NULL;
                }
@@ -1220,8 +1259,13 @@ static int do_end_io(struct multipath *m
                fail_path(mpio->pgpath);

        spin_lock_irqsave(&m->lock, flags);
-       if (!m->nr_valid_paths && !m->queue_if_no_path && !__must_push_ba=
ck(m))
+       if (!m->nr_valid_paths && !m->queue_if_no_path &&
+               !__must_push_back(m)) {
                r =3D -EIO;
+       DMLOG2(DMLOG_IO, DMLOG_CRIT, m->ti,
+               "Failing I/O on %s",
+               m->current_pgpath->path.dev->bdev->bd_disk->disk_name);
+       }
        spin_unlock_irqrestore(&m->lock, flags);

        return r;
@@ -1427,8 +1471,9 @@ static int multipath_message(struct dm_t
        r =3D dm_get_device(ti, argv[1], ti->begin, ti->len,
                          dm_table_get_mode(ti->table), &dev);
        if (r) {
-               DMWARN("message: error getting device %s",
-                      argv[1]);
+               DMLOG2(DMLOG_IOCTL, DMLOG_WARN, ti,
+                       "message: error getting device %s", argv[1]);
+
                return -EINVAL;
        }

@@ -1439,7 +1484,8 @@ static int multipath_message(struct dm_t
        return r;

 error:
-       DMWARN("Unrecognised multipath message received.");
+       DMLOG2(DMLOG_IOCTL, DMLOG_WARN, ti,
+               "Unrecognised multipath message received.");
        return -EINVAL;
 }

@@ -1592,14 +1638,15 @@ static int __init dm_multipath_init(void

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
@@ -1613,14 +1660,14 @@ static int __init dm_multipath_init(void
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

diff -uprN linux-2.6.32-rc5-patch1/drivers/md/dm-path-selector.c linux-2.=
6.32-rc5/drivers/md/dm-path-selector.c
--- linux-2.6.32-rc5-patch1/drivers/md/dm-path-selector.c       2009-11-0=
9 20:34:05.000000000 +0530
+++ linux-2.6.32-rc5/drivers/md/dm-path-selector.c      2009-11-09 20:36:=
59.000000000 +0530
@@ -63,6 +63,8 @@ struct path_selector_type *dm_get_path_s
        if (!psi) {
                request_module("dm-%s", name);
                psi =3D get_path_selector(name);
+               DMLOG(DMLOG_INIT, DMLOG_INFO, "path selector module %s %s=
",
+                       name, (psi) ? "Loaded successfully" : "failed to =
load");
        }

        return psi ? &psi->pst : NULL;
@@ -108,8 +110,13 @@ int dm_register_path_selector(struct pat
        if (__find_path_selector_type(pst->name)) {
                kfree(psi);
                r =3D -EEXIST;
-       } else
+               DMLOG(DMLOG_INIT, DMLOG_ERR, "Failed: Path selector "
+               "%s already registered", pst->name);
+       } else {
                list_add(&psi->list, &_path_selectors);
+               DMLOG(DMLOG_INIT, DMLOG_INFO, "path selector %s "
+                       "registered successfully", pst->name);
+       }

        up_write(&_ps_lock);

@@ -124,12 +131,15 @@ int dm_unregister_path_selector(struct p

        psi =3D __find_path_selector_type(pst->name);
        if (!psi) {
+               DMLOG(DMLOG_INIT, DMLOG_ERR, "Failed to unregister: %s "
+                       "is not registered", pst->name);
                up_write(&_ps_lock);
                return -EINVAL;
        }

        list_del(&psi->list);
-
+       DMLOG(DMLOG_INIT, DMLOG_INFO, "path selector %s unregistered "
+               "successfully", pst->name);
        up_write(&_ps_lock);

        kfree(psi);
diff -uprN linux-2.6.32-rc5-patch1/drivers/md/dm-table.c linux-2.6.32-rc5=
/drivers/md/dm-table.c
--- linux-2.6.32-rc5-patch1/drivers/md/dm-table.c       2009-11-09 20:34:=
05.000000000 +0530
+++ linux-2.6.32-rc5/drivers/md/dm-table.c      2009-11-09 20:36:59.00000=
0000 +0530
@@ -230,8 +230,9 @@ static void free_devices(struct list_hea
        list_for_each_safe(tmp, next, devices) {
                struct dm_dev_internal *dd =3D
                    list_entry(tmp, struct dm_dev_internal, list);
-               DMWARN("dm_table_destroy: dm_put_device call missing for =
%s",
-                      dd->dm_dev.name);
+               DMLOG(DMLOG_TABLE, DMLOG_WARN, "%s :dm_table_destroy: "
+                       "dm_put_device call missing", dd->dm_dev.name);
+
                kfree(dd);
        }
 }
@@ -363,9 +364,10 @@ static int device_area_is_invalid(struct
                return 0;

        if ((start >=3D dev_size) || (start + len > dev_size)) {
-               DMWARN("%s: %s too small for target: "
+               DMLOG1(DMLOG_TABLE, DMLOG_WARN, ti->table->md,
+                      "%s too small for target: "
                       "start=3D%llu, len=3D%llu, dev_size=3D%llu",
-                      dm_device_name(ti->table->md), bdevname(bdev, b),
+                      bdevname(bdev, b),
                       (unsigned long long)start,
                       (unsigned long long)len,
                       (unsigned long long)dev_size);
@@ -376,18 +378,18 @@ static int device_area_is_invalid(struct
                return 0;

        if (start & (logical_block_size_sectors - 1)) {
-               DMWARN("%s: start=3D%llu not aligned to h/w "
+               DMLOG1(DMLOG_TABLE, DMLOG_WARN, ti->table->md,
+                      "start=3D%llu not aligned to h/w "
                       "logical block size %u of %s",
-                      dm_device_name(ti->table->md),
                       (unsigned long long)start,
                       limits->logical_block_size, bdevname(bdev, b));
                return 1;
        }

        if (len & (logical_block_size_sectors - 1)) {
-               DMWARN("%s: len=3D%llu not aligned to h/w "
+               DMLOG1(DMLOG_TABLE, DMLOG_WARN, ti->table->md,
+                      "len=3D%llu not aligned to h/w "
                       "logical block size %u of %s",
-                      dm_device_name(ti->table->md),
                       (unsigned long long)len,
                       limits->logical_block_size, bdevname(bdev, b));
                return 1;
@@ -497,16 +499,18 @@ int dm_set_device_limits(struct dm_targe
        char b[BDEVNAME_SIZE];

        if (unlikely(!q)) {
-               DMWARN("%s: Cannot set limits for nonexistent device %s",
-                      dm_device_name(ti->table->md), bdevname(bdev, b));
+               DMLOG1(DMLOG_TABLE, DMLOG_WARN, ti->table->md,
+                     "Cannot set limits for nonexistent device %s",
+                     bdevname(bdev, b));
                return 0;
        }

        if (blk_stack_limits(limits, &q->limits, start << 9) < 0)
-               DMWARN("%s: target device %s is misaligned: "
+               DMLOG1(DMLOG_TABLE, DMLOG_WARN, ti->table->md,
+                      "target device %s is misaligned: "
                       "physical_block_size=3D%u, logical_block_size=3D%u=
, "
                       "alignment_offset=3D%u, start=3D%llu",
-                      dm_device_name(ti->table->md), bdevname(bdev, b),
+                      bdevname(bdev, b),
                       q->limits.physical_block_size,
                       q->limits.logical_block_size,
                       q->limits.alignment_offset,
@@ -711,9 +715,9 @@ static int validate_hardware_logical_blo
        }

        if (remaining) {
-               DMWARN("%s: table line %u (start sect %llu len %llu) "
-                      "not aligned to h/w logical block size %u",
-                      dm_device_name(table->md), i,
+               DMLOG1(DMLOG_TABLE, DMLOG_WARN, table->md,
+                     "table line %u (start sect %llu len %llu) "
+                      "not aligned to h/w logical block size %u", i,
                       (unsigned long long) ti->begin,
                       (unsigned long long) ti->len,
                       limits->logical_block_size);
@@ -737,14 +741,17 @@ int dm_table_add_target(struct dm_table
        memset(tgt, 0, sizeof(*tgt));

        if (!len) {
-               DMERR("%s: zero-length target", dm_device_name(t->md));
+               DMLOG1(DMLOG_ADD_DEV, DMLOG_ERR,
+                       t->md,
+                       "zero-length target");
                return -EINVAL;
        }

        tgt->type =3D dm_get_target_type(type);
        if (!tgt->type) {
-               DMERR("%s: %s: unknown target type", dm_device_name(t->md=
),
-                     type);
+               DMLOG1(DMLOG_ADD_DEV, DMLOG_ERR, t->md,
+                       "unknown target type");
+
                return -EINVAL;
        }

@@ -778,7 +785,9 @@ int dm_table_add_target(struct dm_table
        return 0;

  bad:
-       DMERR("%s: %s: %s", dm_device_name(t->md), type, tgt->error);
+       DMLOG1(DMLOG_ADD_DEV, DMLOG_ERR, t->md,
+               "%s: %s", type, tgt->error);
+
        dm_put_target_type(tgt->type);
        return r;
 }
@@ -799,8 +808,9 @@ int dm_table_set_type(struct dm_table *t
                        bio_based =3D 1;

                if (bio_based && request_based) {
-                       DMWARN("Inconsistent table: different target type=
s"
-                              " can't be mixed up");
+                       DMLOG(DMLOG_TABLE, DMLOG_WARN, " Inconsistent tab=
le: "
+                               "different target types can't be mixed up=
");
+
                        return -EINVAL;
                }
        }
@@ -817,8 +827,9 @@ int dm_table_set_type(struct dm_table *t
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
+
                        return -EINVAL;
                }
        }
@@ -830,7 +841,9 @@ int dm_table_set_type(struct dm_table *t
         * (e.g. request completion process for partial completion.)
         */
        if (t->num_targets > 1) {
-               DMWARN("Request-based dm doesn't support multiple targets=
 yet");
+               DMLOG(DMLOG_TABLE, DMLOG_WARN, "Request-based dm "
+                       "doesn't support multiple targets yet");
+
                return -EINVAL;
        }

@@ -854,7 +867,8 @@ int dm_table_alloc_md_mempools(struct dm
        unsigned type =3D dm_table_get_type(t);

        if (unlikely(type =3D=3D DM_TYPE_NONE)) {
-               DMWARN("no table type is set, can't allocate mempools");
+               DMLOG(DMLOG_TABLE, DMLOG_WARN, "no table type is set, "
+                       "can't allocate mempools");
                return -EINVAL;
        }

@@ -1028,10 +1042,11 @@ combine_limits:
                 * for the table.
                 */
                if (blk_stack_limits(limits, &ti_limits, 0) < 0)
-                       DMWARN("%s: target device "
+                       DMLOG1(DMLOG_TABLE, DMLOG_WARN,
+                              table->md,
+                              "target device "
                               "(start sect %llu len %llu) "
                               "is misaligned",
-                              dm_device_name(table->md),
                               (unsigned long long) ti->begin,
                               (unsigned long long) ti->len);
        }
@@ -1055,8 +1070,8 @@ static void dm_table_set_integrity(struc
                if (prev &&
                    blk_integrity_compare(prev->dm_dev.bdev->bd_disk,
                                          dd->dm_dev.bdev->bd_disk) < 0) =
{
-                       DMWARN("%s: integrity not set: %s and %s mismatch=
",
-                              dm_device_name(t->md),
+                       DMLOG1(DMLOG_TABLE, DMLOG_WARN, t->md,
+                              "integrity not set: %s and %s mismatch",
                               prev->dm_dev.bdev->bd_disk->disk_name,
                               dd->dm_dev.bdev->bd_disk->disk_name);
                        goto no_integrity;
@@ -1201,9 +1216,11 @@ int dm_table_any_congested(struct dm_tab
                if (likely(q))
                        r |=3D bdi_congested(&q->backing_dev_info, bdi_bi=
ts);
                else
-                       DMWARN_LIMIT("%s: any_congested: nonexistent devi=
ce %s",
-                                    dm_device_name(t->md),
-                                    bdevname(dd->dm_dev.bdev, b));
+                       DMLOG1(DMLOG_TABLE, DMLOG_WARN, t->md,
+                                   "any_congested: "
+                                   "nonexistent device %s",
+                                   bdevname(dd->dm_dev.bdev, b));
+
        }

        return r;
@@ -1235,9 +1252,10 @@ void dm_table_unplug_all(struct dm_table
                if (likely(q))
                        blk_unplug(q);
                else
-                       DMWARN_LIMIT("%s: Cannot unplug nonexistent devic=
e %s",
-                                    dm_device_name(t->md),
-                                    bdevname(dd->dm_dev.bdev, b));
+                       DMLOG1(DMLOG_TABLE, DMLOG_WARN, t->md,
+                               "Cannot unplug "
+                               "nonexistent device %s",
+                               bdevname(dd->dm_dev.bdev, b));
        }
 }

--
