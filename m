From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: [PATCH] Fix whitespace issues in multipath-tools
Date: Wed, 23 Jul 2008 22:56:52 +0200
Message-ID: <1216846612.9122.6.camel@plop>
References: <4886E57C.2000106@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4886E57C.2000106@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Le mercredi 23 juillet 2008 =C3=A0 10:02 +0200, Hannes Reinecke a =C3=A9c=
rit :
> Hi Christophe,
>=20
> one day I got fed up with all of those whitespace issues.
> Here's a patch to fix up (most) of them.
> So no guarantee for completeness, but a good step in
> that direction.
>=20
Sure, committed with 2 left-overs :

1/ in uxsock.c, the patch unduly removed addr declaration

2/ in config.c, there was traces of something I smelling like a good
fix, but not fully fonctionnal (use of alloc_keyword where not
available). As this fix should not be merged in a format patch anyway,
I'll let you juge if you want to submit the complete fix separetely.

Thanks.

> Cheers,
>=20
> Hannes
> pi=C3=A8ce jointe document texte brut (multipath-tools-whitespace-fixes=
)
> Fix whitespace issues
>=20
> One wouldn't believe how many of them are in the code ...
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.de>
>=20
> diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
> index 8658731..7be11bf 100644
> --- a/kpartx/kpartx.c
> +++ b/kpartx/kpartx.c
> @@ -257,7 +257,7 @@ main(int argc, char **argv){
>  	}
> =20
>  	if (dm_prereq(DM_TARGET, 0, 0, 0) && (what =3D=3D ADD || what =3D=3D =
DELETE)) {
> -		fprintf(stderr, "device mapper prerequisites not met\n");=20
> +		fprintf(stderr, "device mapper prerequisites not met\n");
>  		exit(1);
>  	}
> =20
> @@ -423,7 +423,7 @@ main(int argc, char **argv){
>  			break;
> =20
>  		case ADD:
> -			for (j=3D0, c =3D 0; j<n; j++) {
> +			for (j =3D 0, c =3D 0; j < n; j++) {
>  				if (slices[j].size =3D=3D 0)
>  					continue;
> =20
> diff --git a/libmultipath/alias.c b/libmultipath/alias.c
> index 517b055..8473187 100644
> --- a/libmultipath/alias.c
> +++ b/libmultipath/alias.c
> @@ -86,7 +86,7 @@ lock_bindings_file(int fd)
>  	sigset_t set, oldset;
>  	struct flock lock;
>  	int err;
> -=09
> +
>  	memset(&lock, 0, sizeof(lock));
>  	lock.l_type =3D F_WRLCK;
>  	lock.l_whence =3D SEEK_SET;
> @@ -149,7 +149,7 @@ open_bindings_file(char *file, int *can_write)
>  	}
>  	if (*can_write && lock_bindings_file(fd) < 0)
>  		goto fail;
> -=09
> +
>  	memset(&s, 0, sizeof(s));
>  	if (fstat(fd, &s) < 0){
>  		condlog(0, "Cannot stat bindings file : %s", strerror(errno));
> @@ -171,7 +171,7 @@ open_bindings_file(char *file, int *can_write)
>  		fsync(fd);
>  		condlog(3, "Initialized new bindings file [%s]", file);
>  	}
> -=09
> +
>  	return fd;
> =20
>  fail:
> diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
> index d85b385..7db43c6 100644
> --- a/libmultipath/blacklist.c
> +++ b/libmultipath/blacklist.c
> @@ -16,7 +16,7 @@ extern int
>  store_ble (vector blist, char * str, int origin)
>  {
>  	struct blentry * ble;
> -=09
> +
>  	if (!str)
>  		return 0;
> =20
> @@ -61,12 +61,12 @@ alloc_ble_device (vector blist)
>  	vector_set_slot(blist, ble);
>  	return 0;
>  }
> -=09
> +
>  extern int
>  set_ble_device (vector blist, char * vendor, char * product, int origi=
n)
>  {
>  	struct blentry_device * ble;
> -=09
> +
>  	if (!blist)
>  		return 1;
> =20
> @@ -142,14 +142,14 @@ setup_default_blist (struct config * conf)
>  int
>  _blacklist_exceptions (vector elist, char * str)
>  {
> -        int i;
> -        struct blentry * ele;
> +	int i;
> +	struct blentry * ele;
> =20
> -        vector_foreach_slot (elist, ele, i) {
> -                if (!regexec(&ele->regex, str, 0, NULL, 0))
> +	vector_foreach_slot (elist, ele, i) {
> +		if (!regexec(&ele->regex, str, 0, NULL, 0))
>  			return 1;
>  	}
> -        return 0;
> +	return 0;
>  }
> =20
>  int
> @@ -194,11 +194,11 @@ _blacklist_device (vector blist, char * vendor, c=
har * product)
>  }
> =20
>  #define LOG_BLIST(M) \
> -	if (vendor && product)                                           \
> +	if (vendor && product)						 \
>  		condlog(3, "%s: (%s:%s) %s", dev, vendor, product, (M)); \
> -	else if (wwid)                                                   \
> -		condlog(3, "%s: (%s) %s", dev, wwid, (M));               \
> -	else                                                             \
> +	else if (wwid)							 \
> +		condlog(3, "%s: (%s) %s", dev, wwid, (M));		 \
> +	else								 \
>  		condlog(3, "%s: %s", dev, (M))
> =20
>  void
> @@ -300,7 +300,7 @@ _filter_path (struct config * conf, struct path * p=
p)
>  	if (r > 0)
>  		return r;
>  	r =3D _filter_device(conf->blist_device, conf->elist_device,
> -		 	   pp->vendor_id, pp->product_id);
> +			   pp->vendor_id, pp->product_id);
>  	if (r > 0)
>  		return r;
>  	r =3D _filter_wwid(conf->blist_wwid, conf->elist_wwid, pp->wwid);
> diff --git a/libmultipath/config.c b/libmultipath/config.c
> index a109cd9..4e6bfc2 100644
> --- a/libmultipath/config.c
> +++ b/libmultipath/config.c
> @@ -289,25 +289,25 @@ store_hwe (vector hwtable, struct hwentry * dhwe)
> =20
>  	if (find_hwe_strmatch(hwtable, dhwe))
>  		return 0;
> -=09
> +
>  	if (!(hwe =3D alloc_hwe()))
>  		return 1;
> =20
>  	if (!dhwe->vendor || !(hwe->vendor =3D set_param_str(dhwe->vendor)))
>  		goto out;
> -=09
> +
>  	if (!dhwe->product || !(hwe->product =3D set_param_str(dhwe->product)=
))
>  		goto out;
> -=09
> +
>  	if (dhwe->revision && !(hwe->revision =3D set_param_str(dhwe->revisio=
n)))
>  		goto out;
> -=09
> +
>  	if (dhwe->getuid && !(hwe->getuid =3D set_param_str(dhwe->getuid)))
>  		goto out;
> =20
>  	if (dhwe->features && !(hwe->features =3D set_param_str(dhwe->feature=
s)))
>  		goto out;
> -=09
> +
>  	if (dhwe->hwhandler && !(hwe->hwhandler =3D set_param_str(dhwe->hwhan=
dler)))
>  		goto out;
> =20
> @@ -443,12 +443,15 @@ load_config (char * file)
>  	/*
>  	 * read the config file
>  	 */
> +	set_current_keywords(&conf->keywords);
> +	alloc_keywords();
>  	if (filepresent(file)) {
> -		set_current_keywords(&conf->keywords);
>  		if (init_data(file, init_keywords)) {
>  			condlog(0, "error parsing config file");
>  			goto out;
>  		}
> +	} else {
> +	    init_keywords();
>  	}
> =20
>  	/*
> @@ -503,7 +506,6 @@ load_config (char * file)
> =20
>  	if (conf->mptable =3D=3D NULL) {
>  		conf->mptable =3D vector_alloc();
> -
>  		if (!conf->mptable)
>  			goto out;
>  	}
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index d329781..70e10c2 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -161,9 +161,9 @@ dm_simplecmd (int task, const char *name) {
>  		goto out;
> =20
>  	dm_task_no_open_count(dmt);
> -	dm_task_skip_lockfs(dmt);       /* for DM_DEVICE_RESUME */
> +	dm_task_skip_lockfs(dmt);	/* for DM_DEVICE_RESUME */
>  #ifdef LIBDM_API_FLUSH
> -	dm_task_no_flush(dmt);          /* for DM_DEVICE_SUSPEND/RESUME */
> +	dm_task_no_flush(dmt);		/* for DM_DEVICE_SUSPEND/RESUME */
>  #endif
> =20
>  	r =3D dm_task_run (dmt);
> @@ -340,11 +340,11 @@ dm_get_uuid(char *name, char *uuid)
>  	if (!dmt)
>  		return 1;
> =20
> -        if (!dm_task_set_name (dmt, name))
> -                goto uuidout;
> +	if (!dm_task_set_name (dmt, name))
> +		goto uuidout;
> =20
>  	if (!dm_task_run(dmt))
> -                goto uuidout;
> +		goto uuidout;
> =20
>  	uuidtmp =3D dm_task_get_uuid(dmt);
>  	if (uuidtmp) {
> @@ -466,7 +466,7 @@ out:
>  	dm_task_destroy(dmt);
>  	return r;
>  }
> -=09
> +
>  int
>  dm_get_opencount (const char * mapname)
>  {
> @@ -491,7 +491,7 @@ out:
>  	dm_task_destroy(dmt);
>  	return r;
>  }
> -=09
> +
>  int
>  dm_get_minor (char * mapname)
>  {
> @@ -516,7 +516,7 @@ out:
>  	dm_task_destroy(dmt);
>  	return r;
>  }
> -=09
> +
>  extern int
>  dm_flush_map (const char * mapname)
>  {
> @@ -534,7 +534,7 @@ dm_flush_map (const char * mapname)
>  	if (dm_get_opencount(mapname)) {
>  		condlog(2, "%s: map in use", mapname);
>  		return 1;
> -	}=09
> +	}
> =20
>  	r =3D dm_simplecmd(DM_DEVICE_REMOVE, mapname);
> =20
> @@ -746,8 +746,8 @@ dm_get_maps (vector mp)
>  		vector_set_slot(mp, mpp);
>  		mpp =3D NULL;
>  next:
> -                next =3D names->next;
> -                names =3D (void *) names + next;
> +		next =3D names->next;
> +		names =3D (void *) names + next;
>  	} while (next);
> =20
>  	r =3D 0;
> @@ -927,7 +927,7 @@ dm_remove_partmaps (const char * mapname)
>  		     */
>  		    strstr(params, dev_t)
>  		   ) {
> -		    		/*
> +				/*
>  				 * then it's a kpartx generated partition.
>  				 * remove it.
>  				 */
> @@ -957,7 +957,7 @@ dm_get_info (char * mapname, struct dm_info ** dmi)
>  {
>  	int r =3D 1;
>  	struct dm_task *dmt =3D NULL;
> -=09
> +
>  	if (!mapname)
>  		return 1;
> =20
> @@ -1045,7 +1045,7 @@ dm_rename_partmaps (char * old, char * new)
>  		     */
>  		    strstr(buff, dev_t)
>  		   ) {
> -		    		/*
> +				/*
>  				 * then it's a kpartx generated partition.
>  				 * Rename it.
>  				 */
> @@ -1083,7 +1083,7 @@ dm_rename (char * old, char * new)
> =20
>  	if (!dm_task_set_newname(dmt, new))
>  		goto out;
> -=09
> +
>  	dm_task_no_open_count(dmt);
> =20
>  	if (!dm_task_run(dmt))
> diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> index f5bca30..2429a93 100644
> --- a/libmultipath/dict.c
> +++ b/libmultipath/dict.c
> @@ -88,7 +88,7 @@ def_getuid_callout_handler(vector strvec)
> =20
>  	if (!conf->getuid)
>  		return 1;
> -=09
> +
>  	return 0;
>  }
> =20
> @@ -338,12 +338,12 @@ ble_wwid_handler(vector strvec)
>  static int
>  ble_except_wwid_handler(vector strvec)
>  {
> -        char * buff;
> +	char * buff;
> =20
> -        buff =3D set_value(strvec);
> +	buff =3D set_value(strvec);
> =20
> -        if (!buff)
> -                return 1;
> +	if (!buff)
> +		return 1;
> =20
>  	return store_ble(conf->elist_wwid, buff, ORIGIN_CONFIG);
>  }
> @@ -453,7 +453,7 @@ vendor_handler(vector strvec)
> =20
>  	if (!hwe)
>  		return 1;
> -=09
> +
>  	hwe->vendor =3D set_value(strvec);
> =20
>  	if (!hwe->vendor)
> @@ -469,7 +469,7 @@ product_handler(vector strvec)
> =20
>  	if (!hwe)
>  		return 1;
> -=09
> +
>  	hwe->product =3D set_value(strvec);
> =20
>  	if (!hwe->product)
> @@ -527,7 +527,7 @@ static int
>  hw_selector_handler(vector strvec)
>  {
>  	struct hwentry * hwe =3D VECTOR_LAST_SLOT(conf->hwtable);
> -=09
> +
>  	if (!hwe)
>  		return 1;
> =20
> @@ -559,7 +559,7 @@ static int
>  hw_features_handler(vector strvec)
>  {
>  	struct hwentry * hwe =3D VECTOR_LAST_SLOT(conf->hwtable);
> -=09
> +
>  	if (!hwe)
>  		return 1;
> =20
> @@ -575,7 +575,7 @@ static int
>  hw_handler_handler(vector strvec)
>  {
>  	struct hwentry * hwe =3D VECTOR_LAST_SLOT(conf->hwtable);
> -=09
> +
>  	if (!hwe)
>  		return 1;
> =20
> @@ -781,7 +781,7 @@ alias_handler(vector strvec)
>  	if (!mpe)
>  		return 1;
> =20
> -        mpe->alias =3D set_value(strvec);
> +	mpe->alias =3D set_value(strvec);
> =20
>  	if (!mpe->alias)
>  		return 1;
> @@ -813,7 +813,7 @@ static int
>  mp_selector_handler(vector strvec)
>  {
>  	struct mpentry * mpe =3D VECTOR_LAST_SLOT(conf->mptable);
> -=09
> +
>  	if (!mpe)
>  		return 1;
> =20
> @@ -981,7 +981,7 @@ snprint_mp_path_grouping_policy (char * buff, int l=
en, void * data)
>  	if (!mpe->pgpolicy)
>  		return 0;
>  	get_pgpolicy_name(str, POLICY_NAME_SIZE, mpe->pgpolicy);
> -=09
> +
>  	return snprintf(buff, len, "%s", str);
>  }
> =20
> @@ -1194,7 +1194,7 @@ snprint_hw_path_grouping_policy (char * buff, int=
 len, void * data)
>  		return 0;
> =20
>  	get_pgpolicy_name(str, POLICY_NAME_SIZE, hwe->pgpolicy);
> -=09
> +
>  	return snprintf(buff, len, "%s", str);
>  }
> =20
> @@ -1362,7 +1362,7 @@ snprint_def_path_grouping_policy (char * buff, in=
t len, void * data)
>  		return 0;
> =20
>  	get_pgpolicy_name(str, POLICY_NAME_SIZE, conf->pgpolicy);
> -=09
> +
>  	return snprintf(buff, len, "%s", str);
>  }
> =20
> @@ -1454,7 +1454,7 @@ snprint_max_fds (char * buff, int len, void * dat=
a)
>  		return 0;
> =20
>  	if (conf->max_fds < 0)
> -		return snprintf(buff, len, "unlimited");=09
> +		return snprintf(buff, len, "unlimited");
>  	return snprintf(buff, len, "%d", conf->max_fds);
>  }
> =20
> @@ -1534,7 +1534,7 @@ snprint_bled_vendor (char * buff, int len, void *=
 data)
> =20
>  	return snprintf(buff, len, "\"%s\"", bled->vendor);
>  }
> -=09
> +
>  static int
>  snprint_bled_product (char * buff, int len, void * data)
>  {
> @@ -1542,7 +1542,7 @@ snprint_bled_product (char * buff, int len, void =
* data)
> =20
>  	return snprintf(buff, len, "\"%s\"", bled->product);
>  }
> -=09
> +
>  #define __deprecated
> =20
>  void
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 7baa9e7..dd45e03 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -70,7 +70,7 @@ path_discover (vector pathvec, struct config * conf, =
char * devname, int flag)
>  		condlog(0, "path too small");
>  		return 1;
>  	}
> -		=09
> +
>  	if (strncmp(devname,"cciss",5) && !filepresent(path)) {
>  		condlog(4, "path %s not present", path);
>  		return 0;
> @@ -179,7 +179,7 @@ sysfs_get_size (struct sysfs_device * dev, unsigned=
 long long * size)
> =20
>  	return 0;
>  }
> -=09
> +
>  int
>  sysfs_get_fc_nodename (struct sysfs_device * dev, char * node,
>  		       unsigned int host, unsigned int channel,
> @@ -187,7 +187,7 @@ sysfs_get_fc_nodename (struct sysfs_device * dev, c=
har * node,
>  {
>  	char attr_path[SYSFS_PATH_SIZE], *attr;
> =20
> -	if (safe_sprintf(attr_path,=20
> +	if (safe_sprintf(attr_path,
>  			 "/class/fc_transport/target%i:%i:%i",
>  			 host, channel, target)) {
>  		condlog(0, "attr_path too small");
> @@ -202,10 +202,7 @@ sysfs_get_fc_nodename (struct sysfs_device * dev, =
char * node,
> =20
>  	return 1;
>  }
> -=09
> -/*
> - * udev might be slow creating node files : wait
> - */
> +
>  static int
>  opennode (char * dev, int mode)
>  {
> @@ -244,11 +241,11 @@ devt2devname (char *devname, char *devt)
>  		condlog(0, "Cannot open /proc/partitions");
>  		return 1;
>  	}
> -=09
> +
>  	while (!feof(fd)) {
>  		int r =3D fscanf(fd,"%u %u %*d %s",&tmpmaj, &tmpmin, dev);
>  		if (!r) {
> -			fscanf(fd,"%*s\n");
> +			r =3D fscanf(fd,"%*s\n");
>  			continue;
>  		}
>  		if (r !=3D 3)
> @@ -280,62 +277,62 @@ int
>  do_inq(int sg_fd, int cmddt, int evpd, unsigned int pg_op,
>         void *resp, int mx_resp_len, int noisy)
>  {
> -        unsigned char inqCmdBlk[INQUIRY_CMDLEN] =3D
> -            { INQUIRY_CMD, 0, 0, 0, 0, 0 };
> -        unsigned char sense_b[SENSE_BUFF_LEN];
> -        struct sg_io_hdr io_hdr;
> -
> -        if (cmddt)
> -                inqCmdBlk[1] |=3D 2;
> -        if (evpd)
> -                inqCmdBlk[1] |=3D 1;
> -        inqCmdBlk[2] =3D (unsigned char) pg_op;
> +	unsigned char inqCmdBlk[INQUIRY_CMDLEN] =3D
> +		{ INQUIRY_CMD, 0, 0, 0, 0, 0 };
> +	unsigned char sense_b[SENSE_BUFF_LEN];
> +	struct sg_io_hdr io_hdr;
> +
> +	if (cmddt)
> +		inqCmdBlk[1] |=3D 2;
> +	if (evpd)
> +		inqCmdBlk[1] |=3D 1;
> +	inqCmdBlk[2] =3D (unsigned char) pg_op;
>  	inqCmdBlk[3] =3D (unsigned char)((mx_resp_len >> 8) & 0xff);
>  	inqCmdBlk[4] =3D (unsigned char) (mx_resp_len & 0xff);
> -        memset(&io_hdr, 0, sizeof (struct sg_io_hdr));
> -        io_hdr.interface_id =3D 'S';
> -        io_hdr.cmd_len =3D sizeof (inqCmdBlk);
> -        io_hdr.mx_sb_len =3D sizeof (sense_b);
> -        io_hdr.dxfer_direction =3D SG_DXFER_FROM_DEV;
> -        io_hdr.dxfer_len =3D mx_resp_len;
> -        io_hdr.dxferp =3D resp;
> -        io_hdr.cmdp =3D inqCmdBlk;
> -        io_hdr.sbp =3D sense_b;
> -        io_hdr.timeout =3D DEF_TIMEOUT;
> -
> -        if (ioctl(sg_fd, SG_IO, &io_hdr) < 0)
> -                return -1;
> -
> -        /* treat SG_ERR here to get rid of sg_err.[ch] */
> -        io_hdr.status &=3D 0x7e;
> -        if ((0 =3D=3D io_hdr.status) && (0 =3D=3D io_hdr.host_status) =
&&
> -            (0 =3D=3D io_hdr.driver_status))
> -                return 0;
> -        if ((SCSI_CHECK_CONDITION =3D=3D io_hdr.status) ||
> -            (SCSI_COMMAND_TERMINATED =3D=3D io_hdr.status) ||
> -            (SG_ERR_DRIVER_SENSE =3D=3D (0xf & io_hdr.driver_status)))=
 {
> -                if (io_hdr.sbp && (io_hdr.sb_len_wr > 2)) {
> -                        int sense_key;
> -                        unsigned char * sense_buffer =3D io_hdr.sbp;
> -                        if (sense_buffer[0] & 0x2)
> -                                sense_key =3D sense_buffer[1] & 0xf;
> -                        else
> -                                sense_key =3D sense_buffer[2] & 0xf;
> -                        if(RECOVERED_ERROR =3D=3D sense_key)
> -                                return 0;
> -                }
> -        }
> -        return -1;
> +	memset(&io_hdr, 0, sizeof (struct sg_io_hdr));
> +	io_hdr.interface_id =3D 'S';
> +	io_hdr.cmd_len =3D sizeof (inqCmdBlk);
> +	io_hdr.mx_sb_len =3D sizeof (sense_b);
> +	io_hdr.dxfer_direction =3D SG_DXFER_FROM_DEV;
> +	io_hdr.dxfer_len =3D mx_resp_len;
> +	io_hdr.dxferp =3D resp;
> +	io_hdr.cmdp =3D inqCmdBlk;
> +	io_hdr.sbp =3D sense_b;
> +	io_hdr.timeout =3D DEF_TIMEOUT;
> +
> +	if (ioctl(sg_fd, SG_IO, &io_hdr) < 0)
> +		return -1;
> +
> +	/* treat SG_ERR here to get rid of sg_err.[ch] */
> +	io_hdr.status &=3D 0x7e;
> +	if ((0 =3D=3D io_hdr.status) && (0 =3D=3D io_hdr.host_status) &&
> +	    (0 =3D=3D io_hdr.driver_status))
> +		return 0;
> +	if ((SCSI_CHECK_CONDITION =3D=3D io_hdr.status) ||
> +	    (SCSI_COMMAND_TERMINATED =3D=3D io_hdr.status) ||
> +	    (SG_ERR_DRIVER_SENSE =3D=3D (0xf & io_hdr.driver_status))) {
> +		if (io_hdr.sbp && (io_hdr.sb_len_wr > 2)) {
> +			int sense_key;
> +			unsigned char * sense_buffer =3D io_hdr.sbp;
> +			if (sense_buffer[0] & 0x2)
> +				sense_key =3D sense_buffer[1] & 0xf;
> +			else
> +				sense_key =3D sense_buffer[2] & 0xf;
> +			if(RECOVERED_ERROR =3D=3D sense_key)
> +				return 0;
> +		}
> +	}
> +	return -1;
>  }
> =20
>  static int
>  get_serial (char * str, int maxlen, int fd)
>  {
> -        int len =3D 0;
> -        char buff[MX_ALLOC_LEN + 1] =3D {0};
> +	int len =3D 0;
> +	char buff[MX_ALLOC_LEN + 1] =3D {0};
> =20
>  	if (fd < 0)
> -                return 1;
> +		return 1;
> =20
>  	if (0 =3D=3D do_inq(fd, 0, 1, 0x80, buff, MX_ALLOC_LEN, 0)) {
>  		len =3D buff[3];
> @@ -347,7 +344,7 @@ get_serial (char * str, int maxlen, int fd)
>  		}
>  		return 0;
>  	}
> -        return 1;
> +	return 1;
>  }
> =20
>  static int
> @@ -459,7 +456,7 @@ ccw_sysfs_pathinfo (struct path * pp, struct sysfs_=
device * parent)
> =20
>  	/*
>  	 * host / bus / target / lun
> -	 */=09
> +	 */
>  	basename(parent->devpath, attr_path);
>  	pp->sg_id.lun =3D 0;
>  	sscanf(attr_path, "%i.%i.%x",
> diff --git a/libmultipath/log.c b/libmultipath/log.c
> index 90e4d1f..0dd1c22 100644
> --- a/libmultipath/log.c
> +++ b/libmultipath/log.c
> @@ -18,7 +18,7 @@
>  static void dump_logarea (void)
>  {
>  	struct logmsg * msg;
> -=09
> +
>  	logdbg(stderr, "\n=3D=3D=3D=3D area: start addr =3D %p, end addr =3D =
%p =3D=3D=3D=3D\n",
>  		la->start, la->end);
>  	logdbg(stderr, "|addr     |next     |prio|msg\n");
> @@ -34,12 +34,12 @@ static void dump_logarea (void)
>  	logdbg(stderr, "\n\n");
>  }
>  #endif
> -	=09
> +
>  static int logarea_init (int size)
>  {
>  	logdbg(stderr,"enter logarea_init\n");
>  	la =3D (struct logarea *)MALLOC(sizeof(struct logarea));
> -=09
> +
>  	if (!la)
>  		return 1;
> =20
> @@ -107,7 +107,7 @@ int log_enqueue (int prio, const char * fmt, va_lis=
t ap)
>  	lastmsg =3D (struct logmsg *)la->tail;
> =20
>  	if (!la->empty) {
> -		fwd =3D sizeof(struct logmsg) +=20
> +		fwd =3D sizeof(struct logmsg) +
>  		      strlen((char *)&lastmsg->str) * sizeof(char) + 1;
>  		la->tail +=3D ALIGN(fwd, sizeof(void *));
>  	}
> @@ -118,11 +118,11 @@ int log_enqueue (int prio, const char * fmt, va_l=
ist ap)
>  	/* not enough space on tail : rewind */
>  	if (la->head <=3D la->tail && len > (la->end - la->tail)) {
>  		logdbg(stderr, "enqueue: rewind tail to %p\n", la->tail);
> -                if (la->head =3D=3D la->start ) {
> -                        logdbg(stderr, "enqueue: can not rewind tail, =
drop msg\n");
> -                        la->tail =3D lastmsg;
> -                        return 1;  /* can't reuse */
> -                }
> +		if (la->head =3D=3D la->start ) {
> +			logdbg(stderr, "enqueue: can not rewind tail, drop msg\n");
> +			la->tail =3D lastmsg;
> +			return 1;  /* can't reuse */
> +		}
>  		la->tail =3D la->start;
> =20
>  		if (la->empty)
> diff --git a/libmultipath/log_pthread.c b/libmultipath/log_pthread.c
> index 8909440..a1d4a10 100644
> --- a/libmultipath/log_pthread.c
> +++ b/libmultipath/log_pthread.c
> @@ -53,17 +53,17 @@ static void * log_thread (void * et)
>  void log_thread_start (void)
>  {
>  	pthread_attr_t attr;
> -=09
> +
>  	logdbg(stderr,"enter log_thread_start\n");
> =20
>  	logq_lock =3D (pthread_mutex_t *) malloc(sizeof(pthread_mutex_t));
>  	logev_lock =3D (pthread_mutex_t *) malloc(sizeof(pthread_mutex_t));
>  	logev_cond =3D (pthread_cond_t *) malloc(sizeof(pthread_cond_t));
> -=09
> +
>  	pthread_mutex_init(logq_lock, NULL);
>  	pthread_mutex_init(logev_lock, NULL);
>  	pthread_cond_init(logev_cond, NULL);
> -=09
> +
>  	pthread_attr_init(&attr);
>  	pthread_attr_setstacksize(&attr, 64 * 1024);
> =20
> @@ -91,4 +91,4 @@ void log_thread_stop (void)
>  	pthread_cond_destroy(logev_cond);
> =20
>  	free_logarea();
> -}=09
> +}
> diff --git a/libmultipath/parser.c b/libmultipath/parser.c
> index ad2bb4f..62eb712 100644
> --- a/libmultipath/parser.c
> +++ b/libmultipath/parser.c
> @@ -1,11 +1,11 @@
> -/*=20
> +/*
>   * Part:        Configuration file parser/reader. Place into the dynam=
ic
>   *              data structure representation the conf file
> - * =20
> + *
>   * Version:     $Id: parser.c,v 1.0.3 2003/05/11 02:28:03 acassen Exp =
$
> - *=20
> + *
>   * Author:      Alexandre Cassen, <acassen@linux-vs.org>
> - *             =20
> + *
>   *              This program is distributed in the hope that it will b=
e useful,
>   *              but WITHOUT ANY WARRANTY; without even the implied war=
ranty of
>   *              MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> @@ -43,7 +43,7 @@ keyword_alloc(vector keywords, char *string, int (*ha=
ndler) (vector),
> =20
>  	if (!keyword)
>  		return 1;
> -=09
> +
>  	if (!vector_alloc_slot(keywords)) {
>  		FREE(keyword);
>  		return 1;
> @@ -450,7 +450,7 @@ process_stream(vector keywords)
>  				break;
>  			}
>  		}
> -	=09
> +
>  		free_strvec(strvec);
>  	}
> =20
> diff --git a/libmultipath/pgpolicies.c b/libmultipath/pgpolicies.c
> index 2a9671a..0c7eee8 100644
> --- a/libmultipath/pgpolicies.c
> +++ b/libmultipath/pgpolicies.c
> @@ -67,7 +67,7 @@ group_by_node_name (struct multipath * mp) {
>  	struct path * pp;
>  	struct pathgroup * pgp;
>  	struct path * pp2;
> -=09
> +
>  	if (!mp->pg)
>  		mp->pg =3D vector_alloc();
> =20
> @@ -103,12 +103,12 @@ group_by_node_name (struct multipath * mp) {
>  		bitmap[i] =3D 1;
> =20
>  		for (j =3D i + 1; j < VECTOR_SIZE(mp->paths); j++) {
> -		=09
> +
>  			if (bitmap[j])
>  				continue;
> =20
>  			pp2 =3D VECTOR_SLOT(mp->paths, j);
> -		=09
> +
>  			if (!strncmp(pp->tgt_node_name, pp2->tgt_node_name,
>  					NODE_NAME_SIZE)) {
>  				if (store_path(pgp->paths, pp2))
> @@ -140,7 +140,7 @@ group_by_serial (struct multipath * mp) {
>  	struct path * pp;
>  	struct pathgroup * pgp;
>  	struct path * pp2;
> -=09
> +
>  	if (!mp->pg)
>  		mp->pg =3D vector_alloc();
> =20
> @@ -172,16 +172,16 @@ group_by_serial (struct multipath * mp) {
>  		/* feed the first path */
>  		if (store_path(pgp->paths, pp))
>  			goto out1;
> -			=09
> +
>  		bitmap[i] =3D 1;
> =20
>  		for (j =3D i + 1; j < VECTOR_SIZE(mp->paths); j++) {
> -		=09
> +
>  			if (bitmap[j])
>  				continue;
> =20
>  			pp2 =3D VECTOR_SLOT(mp->paths, j);
> -		=09
> +
>  			if (0 =3D=3D strcmp(pp->serial, pp2->serial)) {
>  				if (store_path(pgp->paths, pp2))
>  					goto out1;
> @@ -211,7 +211,7 @@ one_path_per_group (struct multipath * mp)
> =20
>  	if (!mp->pg)
>  		mp->pg =3D vector_alloc();
> -=09
> +
>  	if (!mp->pg)
>  		return 1;
> =20
> @@ -224,7 +224,7 @@ one_path_per_group (struct multipath * mp)
> =20
>  		if (store_pathgroup(mp->pg, pgp))
>  			goto out;
> -	=09
> +
>  		if (store_path(pgp->paths, pp))
>  			goto out;
>  	}
> @@ -252,10 +252,10 @@ one_group (struct multipath * mp)	/* aka multibus=
 */
>  		return 1;
> =20
>  	pgp =3D alloc_pathgroup();
> -=09
> +
>  	if (!pgp)
>  		goto out;
> -=09
> +
>  	vector_free(pgp->paths);
>  	pgp->paths =3D mp->paths;
>  	mp->paths =3D NULL;
> @@ -306,7 +306,7 @@ group_by_prio (struct multipath * mp)
> =20
>  		if (!pgp)
>  			goto out;
> -	=09
> +
>  		if (store_path(pgp->paths, VECTOR_SLOT(mp->paths, 0)))
>  				goto out;
> =20
> diff --git a/libmultipath/print.c b/libmultipath/print.c
> index 3be1c9d..08ebd51 100644
> --- a/libmultipath/print.c
> +++ b/libmultipath/print.c
> @@ -29,7 +29,7 @@
>  #define PAD(x)   while ((int)(c - s) < (x) && (c < (line + len - 1))) =
\
>  			*c++ =3D ' '; s =3D c
>  #define PRINT(var, size, format, args...)      \
> -	         fwd =3D snprintf(var, size, format, ##args); \
> +		fwd =3D snprintf(var, size, format, ##args); \
>  		 c +=3D (fwd >=3D size) ? size : fwd;
> =20
>  /*
> @@ -60,7 +60,7 @@ snprint_size (char * buff, size_t len, unsigned long =
long size)
>  	char fmt[6] =3D {};
>  	char units[] =3D {'K','M','G','T','P'};
>  	char *u =3D units;
> -=09
> +
>  	while (s >=3D 1024 && *u !=3D 'P') {
>  		s =3D s / 1024;
>  		u++;
> @@ -112,7 +112,7 @@ snprint_progress (char * buff, size_t len, int cur,=
 int total)
>  	int j =3D PROGRESS_LEN - i;
>  	char * c =3D buff;
>  	char * end =3D buff + len;
> -=09
> +
>  	while (i-- > 0) {
>  		c +=3D snprintf(c, len, "X");
>  		if ((len =3D (end - c)) <=3D 1) goto out;
> @@ -129,7 +129,7 @@ out:
>  	buff[c - buff + 1] =3D '\0';
>  	return (c - buff + 1);
>  }
> -=09
> +
>  static int
>  snprint_failback (char * buff, size_t len, struct multipath * mpp)
>  {
> @@ -239,7 +239,7 @@ snprint_multipath_vpr (char * buff, size_t len, str=
uct multipath * mpp)
>  	if (!pp)
>  		return 0;
>  	return snprintf(buff, len, "%s,%s",
> -		        pp->vendor_id, pp->product_id);
> +			pp->vendor_id, pp->product_id);
>  }
> =20
>  static int
> @@ -335,7 +335,7 @@ static int
>  snprint_vpr (char * buff, size_t len, struct path * pp)
>  {
>  	return snprintf(buff, len, "%s,%s",
> -		        pp->vendor_id, pp->product_id);
> +			pp->vendor_id, pp->product_id);
>  }
> =20
>  static int
> @@ -530,10 +530,10 @@ snprint_multipath_header (char * line, int len, c=
har * format)
>  			continue;
>  		}
>  		f++;
> -	=09
> +
>  		if (!(data =3D mpd_lookup(*f)))
>  			break; /* unknown wildcard */
> -	=09
> +
>  		PRINT(c, TAIL, data->header);
>  		PAD(data->width);
>  	} while (*f++);
> @@ -565,10 +565,10 @@ snprint_multipath (char * line, int len, char * f=
ormat,
>  			continue;
>  		}
>  		f++;
> -	=09
> +
>  		if (!(data =3D mpd_lookup(*f)))
>  			break;
> -	=09
> +
>  		data->snprint(buff, MAX_FIELD_LEN, mpp);
>  		PRINT(c, TAIL, buff);
>  		PAD(data->width);
> @@ -600,10 +600,10 @@ snprint_path_header (char * line, int len, char *=
 format)
>  			continue;
>  		}
>  		f++;
> -	=09
> +
>  		if (!(data =3D pd_lookup(*f)))
>  			break; /* unknown wildcard */
> -	=09
> +
>  		PRINT(c, TAIL, data->header);
>  		PAD(data->width);
>  	} while (*f++);
> @@ -635,10 +635,10 @@ snprint_path (char * line, int len, char * format=
,
>  			continue;
>  		}
>  		f++;
> -	=09
> +
>  		if (!(data =3D pd_lookup(*f)))
>  			break;
> -	=09
> +
>  		data->snprint(buff, MAX_FIELD_LEN, pp);
>  		PRINT(c, TAIL, buff);
>  		PAD(data->width);
> @@ -671,10 +671,10 @@ snprint_pathgroup (char * line, int len, char * f=
ormat,
>  			continue;
>  		}
>  		f++;
> -	=09
> +
>  		if (!(data =3D pgd_lookup(*f)))
>  			break;
> -	=09
> +
>  		data->snprint(buff, MAX_FIELD_LEN, pgp);
>  		PRINT(c, TAIL, buff);
>  		PAD(data->width);
> @@ -718,7 +718,7 @@ snprint_multipath_topology (char * buff, int len, s=
truct multipath * mpp,
>  			c +=3D sprintf(c, "%%A: ");
> =20
>  	c +=3D sprintf(c, "%%n");
> -=09
> +
>  	if (strncmp(mpp->alias, mpp->wwid, WWID_SIZE))
>  		c +=3D sprintf(c, " (%%w)");
> =20
> @@ -774,7 +774,7 @@ snprint_hwentry (char * buff, int len, struct hwent=
ry * hwe)
>  	if (fwd > len)
>  		return len;
>  	iterate_sub_keywords(rootkw, kw, i) {
> -		fwd +=3D snprint_keyword(buff + fwd, len - fwd, "\t\t%k %v\n",
> +		fwd +=3D snprint_keyword(buff + fwd, len - fwd, "\t\t%k \"%v\"\n",
>  				kw, hwe);
>  		if (fwd > len)
>  			return len;
> @@ -890,7 +890,6 @@ snprint_defaults (char * buff, int len)
>  	if (fwd > len)
>  		return len;
>  	return fwd;
> -=09
>  }
> =20
>  static int
> @@ -956,7 +955,7 @@ snprint_blacklist_report (char * buff, int len)
>  	if ((len - fwd - threshold) <=3D 0)
>  		return len;
>  	fwd +=3D snprintf(buff + fwd, len - fwd, "device node rules:\n"
> -			                       "- blacklist:\n");
> +					       "- blacklist:\n");
>  	if (!snprint_blacklist_group(buff, len, &fwd, &conf->blist_devnode))
>  		return len;
> =20
> @@ -969,7 +968,7 @@ snprint_blacklist_report (char * buff, int len)
>  	if ((len - fwd - threshold) <=3D 0)
>  		return len;
>  	fwd +=3D snprintf(buff + fwd, len - fwd, "wwid rules:\n"
> -			                       "- blacklist:\n");
> +					       "- blacklist:\n");
>  	if (snprint_blacklist_group(buff, len, &fwd, &conf->blist_wwid) =3D=3D=
 0)
>  		return len;
> =20
> @@ -982,7 +981,7 @@ snprint_blacklist_report (char * buff, int len)
>  	if ((len - fwd - threshold) <=3D 0)
>  		return len;
>  	fwd +=3D snprintf(buff + fwd, len - fwd, "device rules:\n"
> -			                       "- blacklist:\n");
> +					       "- blacklist:\n");
>  	if (snprint_blacklist_devgroup(buff, len, &fwd, &conf->blist_device) =
=3D=3D 0)
>  		return len;
> =20
> @@ -1258,7 +1257,7 @@ print_all_paths_custo (vector pathvec, int banner=
, char *fmt)
>  			fprintf(stdout, "=3D=3D=3D=3D=3D no paths =3D=3D=3D=3D=3D\n");
>  		return;
>  	}
> -=09
> +
>  	if (banner)
>  		fprintf(stdout, "=3D=3D=3D=3D=3D paths list =3D=3D=3D=3D=3D\n");
> =20
> diff --git a/libmultipath/prioritizers/alua_rtpg.c b/libmultipath/prior=
itizers/alua_rtpg.c
> index c5528c5..7151cdd 100644
> --- a/libmultipath/prioritizers/alua_rtpg.c
> +++ b/libmultipath/prioritizers/alua_rtpg.c
> @@ -289,7 +289,7 @@ get_asymmetric_access_state(int fd, unsigned int tp=
g)
>  					"more than one entry with same port "
>  					"group.\n");
>  			} else {
> -				PRINT_DEBUG("pref=3D%i\n", dscr->pref);
> +				PRINT_DEBUG("pref=3D%i\n", dscr->b0);
>  				rc =3D rtpg_tpg_dscr_get_aas(dscr);
>  			}
>  		}
> diff --git a/libmultipath/regex.c b/libmultipath/regex.c
> index 3311b50..f08874b 100644
> --- a/libmultipath/regex.c
> +++ b/libmultipath/regex.c
> @@ -116,7 +116,7 @@ static void init_syntax_once(void)
>  /* True if `size1' is non-NULL and PTR is pointing anywhere inside
>     `string1' or just past its end.  This works if PTR is NULL, which i=
s
>     a good thing.  */
> -#define FIRST_STRING_P(ptr) 						\
> +#define FIRST_STRING_P(ptr)						\
>  	(size1 && string1 <=3D (ptr) && (ptr) <=3D string1 + size1)
> =20
>  /* (Re)Allocate N items of type T using malloc, or fail.  */
> @@ -188,7 +188,7 @@ typedef enum {
>  #define EXTRACT_NUMBER_AND_INCR(destination, source)			\
>    do {									\
>      EXTRACT_NUMBER (destination, source);				\
> -    (source) +=3D 2; 							\
> +    (source) +=3D 2;							\
>    } while (0)
> =20
>  #undef assert
> @@ -267,14 +267,14 @@ static reg_errcode_t compile_range (const char **=
p_ptr, const char *pend,
>  #define PATFETCH(c)							\
>    do {if (p =3D=3D pend) return REG_EEND;					\
>      c =3D (unsigned char) *p++;						\
> -    if (translate) c =3D translate[c]; 					\
> +    if (translate) c =3D translate[c];					\
>    } while (0)
> =20
>  /* Fetch the next character in the uncompiled pattern, with no
>     translation.  */
>  #define PATFETCH_RAW(c)							\
>    do {if (p =3D=3D pend) return REG_EEND;					\
> -    c =3D (unsigned char) *p++; 						\
> +    c =3D (unsigned char) *p++;						\
>    } while (0)
> =20
>  /* Go backwards one character in the pattern.  */
> @@ -354,27 +354,27 @@ static reg_errcode_t compile_range (const char **=
p_ptr, const char *pend,
>     correct places in the new one.  If extending the buffer results in =
it
>     being larger than MAX_BUF_SIZE, then flag memory exhausted.  */
>  #define EXTEND_BUFFER()							\
> -  do { 									\
> +  do {									\
>      unsigned char *old_buffer =3D bufp->buffer;				\
> -    if (bufp->allocated =3D=3D MAX_BUF_SIZE) 				\
> +    if (bufp->allocated =3D=3D MAX_BUF_SIZE)				\
>        return REG_ESIZE;							\
>      bufp->allocated <<=3D 1;						\
>      if (bufp->allocated > MAX_BUF_SIZE)					\
> -      bufp->allocated =3D MAX_BUF_SIZE; 					\
> +      bufp->allocated =3D MAX_BUF_SIZE;					\
>      bufp->buffer =3D (unsigned char *) REALLOC(bufp->buffer, bufp->all=
ocated);\
>      if (bufp->buffer =3D=3D NULL)						\
>        return REG_ESPACE;						\
>      /* If the buffer moved, move all the pointers into it.  */		\
>      if (old_buffer !=3D bufp->buffer)					\
>        {									\
> -        b =3D (b - old_buffer) + bufp->buffer;				\
> -        begalt =3D (begalt - old_buffer) + bufp->buffer;			\
> -        if (fixup_alt_jump)						\
> -          fixup_alt_jump =3D (fixup_alt_jump - old_buffer) + bufp->buf=
fer;\
> -        if (laststart)							\
> -          laststart =3D (laststart - old_buffer) + bufp->buffer;		\
> -        if (pending_exact)						\
> -          pending_exact =3D (pending_exact - old_buffer) + bufp->buffe=
r;	\
> +	b =3D (b - old_buffer) + bufp->buffer;				\
> +	begalt =3D (begalt - old_buffer) + bufp->buffer;			\
> +	if (fixup_alt_jump)						\
> +	  fixup_alt_jump =3D (fixup_alt_jump - old_buffer) + bufp->buffer;\
> +	if (laststart)							\
> +	  laststart =3D (laststart - old_buffer) + bufp->buffer;		\
> +	if (pending_exact)						\
> +	  pending_exact =3D (pending_exact - old_buffer) + bufp->buffer;	\
>        }									\
>    } while (0)
> =20
> @@ -428,20 +428,20 @@ typedef struct {
> =20
>=20
>  /* Get the next unsigned number in the uncompiled pattern.  */
> -#define GET_UNSIGNED_NUMBER(num) 					\
> +#define GET_UNSIGNED_NUMBER(num)					\
>    { if (p !=3D pend)							\
>       {									\
> -       PATFETCH (c); 							\
> -       while (ISDIGIT (c)) 						\
> -         { 								\
> -           if (num < 0)							\
> -              num =3D 0;							\
> -           num =3D num * 10 + c - '0'; 					\
> -           if (p =3D=3D pend) 						\
> -              break; 							\
> -           PATFETCH (c);						\
> -         } 								\
> -       } 								\
> +       PATFETCH (c);							\
> +       while (ISDIGIT (c))						\
> +	 {								\
> +	   if (num < 0)							\
> +	      num =3D 0;							\
> +	   num =3D num * 10 + c - '0';					\
> +	   if (p =3D=3D pend)						\
> +	      break;							\
> +	   PATFETCH (c);						\
> +	 }								\
> +       }								\
>      }
> =20
>  #define CHAR_CLASS_MAX_LENGTH  6	/* Namely, `xdigit'.  */
> @@ -1524,14 +1524,14 @@ typedef struct {
>    ((fail_stack).size > re_max_failures * MAX_FAILURE_ITEMS		\
>     ? 0									\
>     : ((fail_stack).stack =3D (fail_stack_elt_t *)				\
> -        REGEX_REALLOCATE ((fail_stack).stack, 				\
> -          (fail_stack).size * sizeof (fail_stack_elt_t),		\
> -          ((fail_stack).size << 1) * sizeof (fail_stack_elt_t)),	\
> +	REGEX_REALLOCATE ((fail_stack).stack,				\
> +	  (fail_stack).size * sizeof (fail_stack_elt_t),		\
> +	  ((fail_stack).size << 1) * sizeof (fail_stack_elt_t)),	\
>  									\
>        (fail_stack).stack =3D=3D NULL					\
>        ? 0								\
> -      : ((fail_stack).size <<=3D 1, 					\
> -         1)))
> +      : ((fail_stack).size <<=3D 1,					\
> +	 1)))
> =20
>=20
>  /* Push PATTERN_OP on FAIL_STACK.
> @@ -1577,7 +1577,7 @@ typedef struct {
>         is wide enough to hold a value of something to which pointer ca=
n \
>         be assigned */							\
>      s_reg_t this_reg;							\
> -    									\
> +									\
>      DEBUG_STATEMENT (failure_id++);					\
>      DEBUG_STATEMENT (nfailure_points_pushed++);				\
>      DEBUG_PRINT2 ("\nPUSH_FAILURE_POINT #%u:\n", failure_id);		\
> @@ -1663,7 +1663,7 @@ typedef struct {
> =20
>  /* We actually push this many items.  */
>  #define NUM_FAILURE_ITEMS						\
> -  ((highest_active_reg - lowest_active_reg + 1) * NUM_REG_ITEMS 	\
> +  ((highest_active_reg - lowest_active_reg + 1) * NUM_REG_ITEMS		\
>      + NUM_NONREG_ITEMS)
> =20
>  /* How many items can still be added to the stack without overflowing =
it.  */
> @@ -2255,13 +2255,13 @@ static int bcmp_translate (const char *s1, cons=
t char *s2,
>  /* Call before fetching a character with *d.  This switches over to
>     string2 if necessary.  */
>  #define PREFETCH()							\
> -  while (d =3D=3D dend)						    	\
> +  while (d =3D=3D dend)							\
>      {									\
>        /* End of string2 =3D> fail.  */					\
> -      if (dend =3D=3D end_match_2) 						\
> -        goto fail;							\
> -      /* End of string1 =3D> advance to string2.  */ 			\
> -      d =3D string2;						        \
> +      if (dend =3D=3D end_match_2)						\
> +	goto fail;							\
> +      /* End of string1 =3D> advance to string2.  */			\
> +      d =3D string2;							\
>        dend =3D end_match_2;						\
>      }
> =20
> @@ -2278,7 +2278,7 @@ static int bcmp_translate (const char *s1, const =
char *s2,
>     string2, look at the last character in string1.  */
>  #define WORDCHAR_P(d)							\
>    (SYNTAX ((d) =3D=3D end1 ? *string2					\
> -           : (d) =3D=3D string2 - 1 ? *(end1 - 1) : *(d))			\
> +	   : (d) =3D=3D string2 - 1 ? *(end1 - 1) : *(d))			\
>     =3D=3D Sword)
> =20
>  /* Test if the character before D and the one at D differ with respect
> diff --git a/libmultipath/structs.c b/libmultipath/structs.c
> index 852e6b3..50f66f4 100644
> --- a/libmultipath/structs.c
> +++ b/libmultipath/structs.c
> @@ -22,7 +22,7 @@ struct path *
>  alloc_path (void)
>  {
>  	struct path * pp;
> -=09
> +
>  	pp =3D (struct path *)MALLOC(sizeof(struct path));
> =20
>  	if (pp) {
> @@ -243,7 +243,7 @@ find_mp_by_minor (vector mpvec, int minor)
>  {
>  	int i;
>  	struct multipath * mpp;
> -=09
> +
>  	if (!mpvec)
>  		return NULL;
> =20
> @@ -262,7 +262,7 @@ find_mp_by_wwid (vector mpvec, char * wwid)
>  {
>  	int i;
>  	struct multipath * mpp;
> -=09
> +
>  	if (!mpvec)
>  		return NULL;
> =20
> @@ -279,7 +279,7 @@ find_mp_by_alias (vector mpvec, char * alias)
>  	int i;
>  	int len;
>  	struct multipath * mpp;
> -=09
> +
>  	if (!mpvec)
>  		return NULL;
> =20
> @@ -287,7 +287,7 @@ find_mp_by_alias (vector mpvec, char * alias)
> =20
>  	if (!len)
>  		return NULL;
> -=09
> +
>  	vector_foreach_slot (mpvec, mpp, i) {
>  		if (strlen(mpp->alias) =3D=3D len &&
>  		    !strncmp(mpp->alias, alias, len))
> @@ -315,7 +315,7 @@ find_path_by_dev (vector pathvec, char * dev)
> =20
>  	if (!pathvec)
>  		return NULL;
> -=09
> +
>  	vector_foreach_slot (pathvec, pp, i)
>  		if (!strcmp_chomp(pp->dev, dev))
>  			return pp;
> diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> index 34b7669..785a766 100644
> --- a/libmultipath/structs_vec.c
> +++ b/libmultipath/structs_vec.c
> @@ -280,13 +280,13 @@ setup_multipath (struct vectors * vecs, struct mu=
ltipath * mpp)
>  retry:
>  	if (dm_get_info(mpp->alias, &mpp->dmi)) {
>  		/* Error accessing table */
> -		condlog(3, "%s: cannot access table", mpp->alias);=20
> +		condlog(3, "%s: cannot access table", mpp->alias);
>  		goto out;
>  	}
> =20
>  	if (!dm_map_present(mpp->alias)) {
>  		/* Table has been removed */
> -		condlog(3, "%s: table does not exist", mpp->alias);=20
> +		condlog(3, "%s: table does not exist", mpp->alias);
>  		goto out;
>  	}
> =20
> diff --git a/libmultipath/switchgroup.c b/libmultipath/switchgroup.c
> index 58b08f6..5d6e805 100644
> --- a/libmultipath/switchgroup.c
> +++ b/libmultipath/switchgroup.c
> @@ -35,7 +35,7 @@ select_path_group (struct multipath * mpp)
> =20
>  	if (!mpp->pg)
>  		return 1;
> -=09
> +
>  	vector_foreach_slot (mpp->pg, pgp, i) {
>  		if (!pgp->paths)
>  			continue;
> diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
> index a4028d8..99757fe 100644
> --- a/libmultipath/uevent.c
> +++ b/libmultipath/uevent.c
> @@ -157,7 +157,7 @@ int uevent_listen(int (*uev_trigger)(struct uevent =
*, void * trigger_data),
>  		}
> =20
>  		/* enable receiving of the sender credentials */
> -		setsockopt(sock, SOL_SOCKET, SO_PASSCRED,=20
> +		setsockopt(sock, SOL_SOCKET, SO_PASSCRED,
>  			   &feature_on, sizeof(feature_on));
> =20
>  	} else {
> diff --git a/libmultipath/util.c b/libmultipath/util.c
> index eaf2266..c7fe6b4 100644
> --- a/libmultipath/util.c
> +++ b/libmultipath/util.c
> @@ -14,7 +14,7 @@ strcmp_chomp(char *str1, char *str2)
>  {
>  	int i;
>  	char s1[PARAMS_SIZE],s2[PARAMS_SIZE];
> -=20
> +
>  	if(!str1 || !str2)
>  		return 1;
> =20
> @@ -67,7 +67,7 @@ get_word (char * sentence, char ** word)
>  	char * p;
>  	int len;
>  	int skip =3D 0;
> -=09
> +
>  	if (word)
>  		*word =3D NULL;
> =20
> diff --git a/libmultipath/uxsock.c b/libmultipath/uxsock.c
> index a070943..9e742e0 100644
> --- a/libmultipath/uxsock.c
> +++ b/libmultipath/uxsock.c
> @@ -26,17 +26,17 @@
>  int ux_socket_connect(const char *name)
>  {
>  	int fd;
> -        struct sockaddr_un addr;
> +	struct sockaddr_un addr;
> =20
> -        memset(&addr, 0, sizeof(addr));
> -        addr.sun_family =3D AF_UNIX;
> -        strncpy(addr.sun_path, name, sizeof(addr.sun_path));
> +	memset(&addr, 0, sizeof(addr));
> +	addr.sun_family =3D AF_UNIX;
> +	strncpy(addr.sun_path, name, sizeof(addr.sun_path));
> =20
>  	fd =3D socket(AF_UNIX, SOCK_STREAM, 0);
>  	if (fd =3D=3D -1) {
>  		return -1;
>  	}
> -=09
> +
>  	if (connect(fd, (struct sockaddr *)&addr, sizeof(addr)) =3D=3D -1) {
>  		close(fd);
>  		return -1;
> @@ -47,12 +47,12 @@ int ux_socket_connect(const char *name)
> =20
>  /*
>   * create a unix domain socket and start listening on it
> - * return a file descriptor open on the socket=20
> + * return a file descriptor open on the socket
>   */
>  int ux_socket_listen(const char *name)
>  {
>  	int fd;
> -        struct sockaddr_un addr;
> +
> =20
>  	/* get rid of any old socket */
>  	unlink(name);
> @@ -60,16 +60,16 @@ int ux_socket_listen(const char *name)
>  	fd =3D socket(AF_UNIX, SOCK_STREAM, 0);
>  	if (fd =3D=3D -1) return -1;
> =20
> -        memset(&addr, 0, sizeof(addr));
> -        addr.sun_family =3D AF_UNIX;
> -        strncpy(addr.sun_path, name, sizeof(addr.sun_path));
> +	memset(&addr, 0, sizeof(addr));
> +	addr.sun_family =3D AF_UNIX;
> +	strncpy(addr.sun_path, name, sizeof(addr.sun_path));
> =20
> -        if (bind(fd, (struct sockaddr *)&addr, sizeof(addr)) =3D=3D -1=
) {
> +	if (bind(fd, (struct sockaddr *)&addr, sizeof(addr)) =3D=3D -1) {
>  		close(fd);
>  		return -1;
> -	}=09
> +	}
> =20
> -        if (listen(fd, 10) =3D=3D -1) {
> +	if (listen(fd, 10) =3D=3D -1) {
>  		close(fd);
>  		return -1;
>  	}
> diff --git a/libmultipath/vector.c b/libmultipath/vector.c
> index 56eb860..3415461 100644
> --- a/libmultipath/vector.c
> +++ b/libmultipath/vector.c
> @@ -1,10 +1,10 @@
> -/*=20
> +/*
>   * Part:        Vector structure manipulation.
> - * =20
> + *
>   * Version:     $Id: vector.c,v 1.0.3 2003/05/11 02:28:03 acassen Exp =
$
> - *=20
> + *
>   * Author:      Alexandre Cassen, <acassen@linux-vs.org>
> - *             =20
> + *
>   *              This program is distributed in the hope that it will b=
e useful,
>   *              but WITHOUT ANY WARRANTY; without even the implied war=
ranty of
>   *              MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> @@ -23,7 +23,7 @@
>  #include <stdlib.h>
>  #include "vector.h"
> =20
> -/*=20
> +/*
>   * Initialize vector struct.
>   * allocated 'size' slot elements then return vector.
>   */
> @@ -54,7 +54,7 @@ void *
>  vector_insert_slot(vector v, int slot, void *value)
>  {
>  	int i;
> -=09
> +
>  	if (!vector_alloc_slot(v))
>  		return NULL;
> =20
> diff --git a/libmultipath/waiter.c b/libmultipath/waiter.c
> index d7af0d1..54cd19f 100644
> --- a/libmultipath/waiter.c
> +++ b/libmultipath/waiter.c
> @@ -58,7 +58,7 @@ void free_waiter (void *data)
>  void stop_waiter_thread (struct multipath *mpp, struct vectors *vecs)
>  {
>  	struct event_thread *wp =3D (struct event_thread *)mpp->waiter;
> -=09
> +
>  	if (!wp) {
>  		condlog(3, "%s: no waiter thread", mpp->alias);
>  		return;
> @@ -113,7 +113,7 @@ int waiteventloop (struct event_thread *waiter)
>  	}
> =20
>  	dm_task_no_open_count(waiter->dmt);
> -=09
> +
>  	/* accept wait interruption */
>  	set =3D unblock_signals();
> =20
> @@ -154,7 +154,7 @@ int waiteventloop (struct event_thread *waiter)
>  		lock_cleanup_pop(waiter->vecs->lock);
> =20
>  		if (r) {
> -			condlog(2, "%s: event checker exit",=20
> +			condlog(2, "%s: event checker exit",
>  				waiter->mapname);
>  			return -1; /* stop the thread */
>  		}
