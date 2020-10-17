Return-Path: <SRS0=jCgc=DY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB024C433E7
	for <dm-devel@archiver.kernel.org>; Sat, 17 Oct 2020 04:58:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 176F22073A
	for <dm-devel@archiver.kernel.org>; Sat, 17 Oct 2020 04:58:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gc4LySer"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 176F22073A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1602910716;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6YHKBRY/rdrKPXp+J1KJwnv1hadTX9G8cwKRBJKCFhQ=;
	b=gc4LySerOnmrAbP6DqXC5ssud0h7B2jn4+oh/v81A6YyqMYmEpKfGJAQ7gNSCQr2m9H+9w
	trOioNplPMPRY86QZrXSNPIBelFuP0zfbqjOaj1+gSXLwbt8K2VCRbhUIvRF57uIY8v0U2
	C98W4VT2vsa3pB92el5WRbYdXGpYjqk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-550-6TlaBNQnMU6Id4sgVyiZoQ-1; Sat, 17 Oct 2020 00:58:33 -0400
X-MC-Unique: 6TlaBNQnMU6Id4sgVyiZoQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 531171868401;
	Sat, 17 Oct 2020 04:58:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A1A945C1D0;
	Sat, 17 Oct 2020 04:58:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C3F551826D35;
	Sat, 17 Oct 2020 04:58:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09H4wLb5016051 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 17 Oct 2020 00:58:21 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 44BFE5D9D5; Sat, 17 Oct 2020 04:58:21 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1A0225D9CC;
	Sat, 17 Oct 2020 04:58:18 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 09H4wG4A028995; 
	Fri, 16 Oct 2020 23:58:16 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 09H4wF8n028994;
	Fri, 16 Oct 2020 23:58:15 -0500
Date: Fri, 16 Oct 2020 23:58:15 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20201017045815.GY3384@octiron.msp.redhat.com>
References: <20201016104329.8337-1-mwilck@suse.com>
	<20201016104329.8337-11-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20201016104329.8337-11-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v3 10/21] libmultipath: devmapper: refactor
 libdm version determination
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Oct 16, 2020 at 12:43:18PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> As one step towards bundling all possibly racy libdm init calls into a single
> function, split the code for determining and checking versions of
> libdm and kernel components. Provide a generic helper
> libmp_get_version() that makes sure the versions are "lazily" initialized.
> 
> External callers may use dm_prereq(), like before.
> Minor API change: dm_prereq() does not nullify the argument any more
> if an error is encountered.
> 
> Remove the conf->version field, which isn't needed any more after this
> change. This makes it necessary to fixup the hwtable test. Also, it
> represents an incompatible ABI change as offsets in "struct config" are
> changed, and two symbols removed. Bump the ABI major version to 2.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/config.h             |   1 -
>  libmultipath/devmapper.c          | 160 ++++++++++++++++++++----------
>  libmultipath/devmapper.h          |  11 +-
>  libmultipath/libmultipath.version |   5 +-
>  libmultipath/propsel.c            |  10 +-
>  multipathd/dmevents.c             |   2 +-
>  multipathd/main.c                 |   1 -
>  tests/Makefile                    |   2 +-
>  tests/hwtable.c                   |   3 -
>  tests/test-lib.c                  |  13 +++
>  10 files changed, 141 insertions(+), 67 deletions(-)
> 
> diff --git a/libmultipath/config.h b/libmultipath/config.h
> index 290aea5..7af1984 100644
> --- a/libmultipath/config.h
> +++ b/libmultipath/config.h
> @@ -192,7 +192,6 @@ struct config {
>  	int find_multipaths_timeout;
>  	int marginal_pathgroups;
>  	int skip_delegate;
> -	unsigned int version[3];
>  	unsigned int sequence_nr;
>  
>  	char * multipath_dir;
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index 7394796..08aa09f 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -26,6 +26,7 @@
>  #include "sysfs.h"
>  #include "config.h"
>  #include "wwids.h"
> +#include "version.h"
>  
>  #include "log_pthread.h"
>  #include <sys/types.h>
> @@ -34,7 +35,13 @@
>  #define MAX_WAIT 5
>  #define LOOPS_PER_SEC 5
>  
> +#define INVALID_VERSION ~0U
> +static unsigned int dm_library_version[3] = { INVALID_VERSION, };
> +static unsigned int dm_kernel_version[3] = { INVALID_VERSION, };
> +static unsigned int dm_mpath_target_version[3] = { INVALID_VERSION, };
> +
>  static pthread_once_t dm_initialized = PTHREAD_ONCE_INIT;
> +static pthread_once_t versions_initialized = PTHREAD_ONCE_INIT;
>  
>  static int dm_conf_verbosity;
>  
> @@ -102,7 +109,7 @@ dm_write_log (int level, const char *file, int line, const char *f, ...)
>  	return;
>  }
>  
> -void dm_init(int v)
> +static void dm_init(int v)
>  {
>  	/*
>  	 * This maps libdm's standard loglevel _LOG_WARN (= 4), which is rather
> @@ -112,59 +119,66 @@ void dm_init(int v)
>  	dm_log_init(&dm_write_log);
>  }
>  
> +static void init_dm_library_version(void)
> +{
> +	char version[64];
> +	unsigned int v[3];
> +
> +	dm_get_library_version(version, sizeof(version));
> +	if (sscanf(version, "%u.%u.%u ", &v[0], &v[1], &v[2]) != 3) {
> +		condlog(0, "invalid libdevmapper version %s", version);
> +		return;
> +	}
> +	memcpy(dm_library_version, v, sizeof(dm_library_version));
> +	condlog(3, "libdevmapper version %u.%.2u.%.2u",
> +		dm_library_version[0], dm_library_version[1],
> +		dm_library_version[2]);
> +}
> +
>  static int
>  dm_lib_prereq (void)
>  {
> -	char version[64];
> -	int v[3];
> +
>  #if defined(LIBDM_API_HOLD_CONTROL)
> -	int minv[3] = {1, 2, 111};
> +	unsigned int minv[3] = {1, 2, 111};
>  #elif defined(LIBDM_API_DEFERRED)
> -	int minv[3] = {1, 2, 89};
> +	unsigned int minv[3] = {1, 2, 89};
>  #elif defined(DM_SUBSYSTEM_UDEV_FLAG0)
> -	int minv[3] = {1, 2, 82};
> +	unsigned int minv[3] = {1, 2, 82};
>  #elif defined(LIBDM_API_COOKIE)
> -	int minv[3] = {1, 2, 38};
> +	unsigned int minv[3] = {1, 2, 38};
>  #else
> -	int minv[3] = {1, 2, 8};
> +	unsigned int minv[3] = {1, 2, 8};
>  #endif
>  
> -	dm_get_library_version(version, sizeof(version));
> -	condlog(3, "libdevmapper version %s", version);
> -	if (sscanf(version, "%d.%d.%d ", &v[0], &v[1], &v[2]) != 3) {
> -		condlog(0, "invalid libdevmapper version %s", version);
> -		return 1;
> -	}
> -
> -	if VERSION_GE(v, minv)
> +	if (VERSION_GE(dm_library_version, minv))
>  		return 0;
> -	condlog(0, "libdevmapper version must be >= %d.%.2d.%.2d",
> +	condlog(0, "libdevmapper version must be >= %u.%.2u.%.2u",
>  		minv[0], minv[1], minv[2]);
>  	return 1;
>  }
>  
> -int
> -dm_drv_version(unsigned int *v)
> +static void init_dm_drv_version(void)
>  {
>  	char buff[64];
> -
> -	v[0] = 0;
> -	v[1] = 0;
> -	v[2] = 0;
> +	unsigned int v[3];
>  
>  	if (!dm_driver_version(buff, sizeof(buff))) {
>  		condlog(0, "cannot get kernel dm version");
> -		return 1;
> +		return;
>  	}
>  	if (sscanf(buff, "%u.%u.%u ", &v[0], &v[1], &v[2]) != 3) {
>  		condlog(0, "invalid kernel dm version '%s'", buff);
> -		return 1;
> +		return;
>  	}
> -	return 0;
> +	memcpy(dm_kernel_version, v, sizeof(dm_library_version));
> +	condlog(3, "kernel device mapper v%u.%u.%u",
> +		dm_kernel_version[0],
> +		dm_kernel_version[1],
> +		dm_kernel_version[2]);
>  }
>  
> -int
> -dm_tgt_version (unsigned int * version, char * str)
> +static int dm_tgt_version (unsigned int *version, char *str)
>  {
>  	int r = 2;
>  	struct dm_task *dmt;
> @@ -172,10 +186,11 @@ dm_tgt_version (unsigned int * version, char * str)
>  	struct dm_versions *last_target;
>  	unsigned int *v;
>  
> -	version[0] = 0;
> -	version[1] = 0;
> -	version[2] = 0;
> -
> +	/*
> +	 * We have to call dm_task_create() and not libmp_dm_task_create()
> +	 * here to avoid a recursive invocation of
> +	 * pthread_once(&dm_initialized), which would cause a deadlock.
> +	 */
>  	if (!(dmt = dm_task_create(DM_DEVICE_LIST_VERSIONS)))
>  		return 1;
>  
> @@ -211,26 +226,25 @@ out:
>  	return r;
>  }
>  
> -static int
> -dm_tgt_prereq (unsigned int *ver)
> +static void init_dm_mpath_version(void)
>  {
> -	unsigned int minv[3] = {1, 0, 3};
> -	unsigned int version[3] = {0, 0, 0};
> -	unsigned int * v = version;
> -
> -	if (dm_tgt_version(v, TGT_MPATH)) {
> -		/* in doubt return not capable */
> -		return 1;
> -	}
> +	if (!dm_tgt_version(dm_mpath_target_version, TGT_MPATH))
> +		condlog(3, "DM multipath kernel driver v%u.%u.%u",
> +			dm_mpath_target_version[0],
> +			dm_mpath_target_version[1],
> +			dm_mpath_target_version[2]);
> +}
>  
> -	/* test request based multipath capability */
> -	condlog(3, "DM multipath kernel driver v%u.%u.%u",
> -		v[0], v[1], v[2]);
> +static int dm_tgt_prereq (unsigned int *ver)
> +{
> +	unsigned int minv[3] = {1, 0, 3};
>  
> -	if (VERSION_GE(v, minv)) {
> -		ver[0] = v[0];
> -		ver[1] = v[1];
> -		ver[2] = v[2];
> +	if (VERSION_GE(dm_mpath_target_version, minv)) {
> +		if (ver) {
> +			ver[0] = dm_mpath_target_version[0];
> +			ver[1] = dm_mpath_target_version[1];
> +			ver[2] = dm_mpath_target_version[2];
> +		}
>  		return 0;
>  	}
>  
> @@ -239,13 +253,60 @@ dm_tgt_prereq (unsigned int *ver)
>  	return 1;
>  }
>  
> +static void _init_versions(void)
> +{
> +	dlog(logsink, 3, VERSION_STRING);
> +	init_dm_library_version();
> +	init_dm_drv_version();
> +	init_dm_mpath_version();
> +}
> +
> +static int init_versions(void) {
> +	pthread_once(&versions_initialized, _init_versions);
> +	return (dm_library_version[0] == INVALID_VERSION ||
> +		dm_kernel_version[0] == INVALID_VERSION ||
> +		dm_mpath_target_version[0] == INVALID_VERSION);
> +}
> +
>  int dm_prereq(unsigned int *v)
>  {
> +	if (init_versions())
> +		return 1;
>  	if (dm_lib_prereq())
>  		return 1;
>  	return dm_tgt_prereq(v);
>  }
>  
> +int libmp_get_version(int which, unsigned int version[3])
> +{
> +	unsigned int *src_version;
> +
> +	init_versions();
> +	switch (which) {
> +	case DM_LIBRARY_VERSION:
> +		src_version = dm_library_version;
> +		break;
> +	case DM_KERNEL_VERSION:
> +		src_version = dm_kernel_version;
> +		break;
> +	case DM_MPATH_TARGET_VERSION:
> +		src_version = dm_mpath_target_version;
> +		break;
> +	case MULTIPATH_VERSION:
> +		version[0] = (VERSION_CODE >> 16) & 0xff;
> +		version[1] = (VERSION_CODE >> 8) & 0xff;
> +		version[2] = VERSION_CODE & 0xff;
> +		return 0;
> +	default:
> +		condlog(0, "%s: invalid value for 'which'", __func__);
> +		return 1;
> +	}
> +	if (src_version[0] == INVALID_VERSION)
> +		return 1;
> +	memcpy(version, src_version, 3 * sizeof(*version));
> +	return 0;
> +}
> +
>  static int libmp_dm_udev_sync = 0;
>  
>  void libmp_udev_set_sync_support(int on)
> @@ -263,7 +324,6 @@ static void libmp_dm_init(void)
>  		exit(1);
>  	conf = get_multipath_config();
>  	verbosity = conf->verbosity;
> -	memcpy(conf->version, version, sizeof(version));
>  	put_multipath_config(conf);
>  	dm_init(verbosity);
>  #ifdef LIBDM_API_HOLD_CONTROL
> diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
> index f568ab5..c8b37e1 100644
> --- a/libmultipath/devmapper.h
> +++ b/libmultipath/devmapper.h
> @@ -33,13 +33,10 @@ enum {
>  	DMP_NOT_FOUND,
>  };
>  
> -void dm_init(int verbosity);
>  int dm_prereq(unsigned int *v);
>  void skip_libmp_dm_init(void);
>  void libmp_udev_set_sync_support(int on);
>  struct dm_task *libmp_dm_task_create(int task);
> -int dm_drv_version (unsigned int * version);
> -int dm_tgt_version (unsigned int * version, char * str);
>  int dm_simplecmd_flush (int, const char *, uint16_t);
>  int dm_simplecmd_noflush (int, const char *, uint16_t);
>  int dm_addmap_create (struct multipath *mpp, char *params);
> @@ -85,6 +82,14 @@ struct multipath *dm_get_multipath(const char *name);
>  	((v[0] == minv[0]) && (v[1] == minv[1]) && (v[2] >= minv[2])) \
>  )
>  
> +enum {
> +	DM_LIBRARY_VERSION,
> +	DM_KERNEL_VERSION,
> +	DM_MPATH_TARGET_VERSION,
> +	MULTIPATH_VERSION
> +};
> +int libmp_get_version(int which, unsigned int version[3]);
> +
>  #define dm_log_error(lvl, cmd, dmt)			      \
>  	condlog(lvl, "%s: libdm task=%d error: %s", __func__, \
>  		cmd, strerror(dm_task_get_errno(dmt)))	      \
> diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
> index a6bf821..ab5bb0a 100644
> --- a/libmultipath/libmultipath.version
> +++ b/libmultipath/libmultipath.version
> @@ -31,7 +31,7 @@
>   *   The new version inherits the previous ones.
>   */
>  
> -LIBMULTIPATH_1.0.0 {
> +LIBMULTIPATH_2.0.0 {
>  global:
>  	/* symbols referenced by multipath and multipathd */
>  	add_foreign;
> @@ -65,7 +65,6 @@ global:
>  	disassemble_status;
>  	dlog;
>  	dm_cancel_deferred_remove;
> -	dm_drv_version;
>  	dm_enablegroup;
>  	dm_fail_path;
>  	_dm_flush_map;
> @@ -87,7 +86,6 @@ global:
>  	dm_reinstate_path;
>  	dm_simplecmd_noflush;
>  	dm_switchgroup;
> -	dm_tgt_version;
>  	domap;
>  	ensure_directories_exist;
>  	extract_hwe_from_path;
> @@ -128,6 +126,7 @@ global:
>  	is_path_valid;
>  	is_quote;
>  	libmp_dm_task_create;
> +	libmp_get_version;
>  	libmp_udev_set_sync_support;
>  	load_config;
>  	log_thread_reset;
> diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> index 4020134..3f2c2cf 100644
> --- a/libmultipath/propsel.c
> +++ b/libmultipath/propsel.c
> @@ -735,9 +735,10 @@ out:
>  
>  int select_minio(struct config *conf, struct multipath *mp)
>  {
> -	unsigned int minv_dmrq[3] = {1, 1, 0};
> +	unsigned int minv_dmrq[3] = {1, 1, 0}, version[3];
>  
> -	if (VERSION_GE(conf->version, minv_dmrq))
> +	if (!libmp_get_version(DM_MPATH_TARGET_VERSION, version)
> +	    && VERSION_GE(version, minv_dmrq))
>  		return select_minio_rq(conf, mp);
>  	else
>  		return select_minio_bio(conf, mp);
> @@ -820,9 +821,10 @@ out:
>  int select_retain_hwhandler(struct config *conf, struct multipath *mp)
>  {
>  	const char *origin;
> -	unsigned int minv_dm_retain[3] = {1, 5, 0};
> +	unsigned int minv_dm_retain[3] = {1, 5, 0}, version[3];
>  
> -	if (!VERSION_GE(conf->version, minv_dm_retain)) {
> +	if (!libmp_get_version(DM_MPATH_TARGET_VERSION, version) &&
> +	    !VERSION_GE(version, minv_dm_retain)) {
>  		mp->retain_hwhandler = RETAIN_HWHANDLER_OFF;
>  		origin = "(setting: WARNING, requires kernel dm-mpath version >= 1.5.0)";
>  		goto out;
> diff --git a/multipathd/dmevents.c b/multipathd/dmevents.c
> index 5f2d210..fc97c8a 100644
> --- a/multipathd/dmevents.c
> +++ b/multipathd/dmevents.c
> @@ -60,7 +60,7 @@ int dmevent_poll_supported(void)
>  {
>  	unsigned int v[3];
>  
> -	if (dm_drv_version(v))
> +	if (libmp_get_version(DM_KERNEL_VERSION, v))
>  		return 0;
>  
>  	if (VERSION_GE(v, DM_VERSION_FOR_ARM_POLL))
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 5cc3435..00b66ba 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2709,7 +2709,6 @@ reconfigure (struct vectors * vecs)
>  	/* Re-read any timezone changes */
>  	tzset();
>  
> -	dm_tgt_version(conf->version, TGT_MPATH);
>  	if (verbosity)
>  		conf->verbosity = verbosity;
>  	if (bindings_read_only)
> diff --git a/tests/Makefile b/tests/Makefile
> index f6ef16a..7a73869 100644
> --- a/tests/Makefile
> +++ b/tests/Makefile
> @@ -42,7 +42,7 @@ endif
>  dmevents-test_LIBDEPS = -lpthread -ldevmapper -lurcu
>  hwtable-test_TESTDEPS := test-lib.o
>  hwtable-test_OBJDEPS := ../libmultipath/discovery.o ../libmultipath/blacklist.o \
> -	../libmultipath/structs.o
> +	../libmultipath/structs.o ../libmultipath/propsel.o
>  hwtable-test_LIBDEPS := -ludev -lpthread -ldl
>  blacklist-test_TESTDEPS := test-log.o
>  blacklist-test_OBJDEPS := ../libmultipath/blacklist.o
> diff --git a/tests/hwtable.c b/tests/hwtable.c
> index 12660da..57f832b 100644
> --- a/tests/hwtable.c
> +++ b/tests/hwtable.c
> @@ -30,8 +30,6 @@
>  #define N_CONF_FILES 2
>  
>  static const char tmplate[] = "/tmp/hwtable-XXXXXX";
> -/* pretend new dm, use minio_rq */
> -static const unsigned int dm_tgt_version[3] = { 1, 1, 1 };
>  
>  struct key_value {
>  	const char *key;
> @@ -360,7 +358,6 @@ static void write_device(FILE *ff, int nkv, const struct key_value *kv)
>  	assert_ptr_not_equal(__cf, NULL);				\
>  	assert_ptr_not_equal(__cf->hwtable, NULL);			\
>  	__cf->verbosity = VERBOSITY;					\
> -	memcpy(&__cf->version, dm_tgt_version, sizeof(__cf->version));	\
>  	__cf; })
>  
>  #define FREE_CONFIG(conf) do {			\
> diff --git a/tests/test-lib.c b/tests/test-lib.c
> index b7c09cc..e7663f9 100644
> --- a/tests/test-lib.c
> +++ b/tests/test-lib.c
> @@ -56,6 +56,15 @@ int __wrap_execute_program(char *path, char *value, int len)
>  	return 0;
>  }
>  
> +int __wrap_libmp_get_version(int which, unsigned int version[3])
> +{
> +	unsigned int *vers = mock_ptr_type(unsigned int *);
> +
> +	condlog(4, "%s: %d", __func__, which);
> +	memcpy(version, vers, 3 * sizeof(unsigned int));
> +	return 0;
> +}
> +
>  struct udev_list_entry
>  *__wrap_udev_device_get_properties_list_entry(struct udev_device *ud)
>  {
> @@ -339,6 +348,8 @@ struct multipath *__mock_multipath(struct vectors *vecs, struct path *pp)
>  	struct multipath *mp;
>  	struct config *conf;
>  	struct mocked_path mop;
> +	/* pretend new dm, use minio_rq,  */
> +	static const unsigned int fake_dm_tgt_version[3] = { 1, 1, 1 };
>  
>  	mocked_path_from_path(&mop, pp);
>  	/* pathinfo() call in adopt_paths */
> @@ -351,7 +362,9 @@ struct multipath *__mock_multipath(struct vectors *vecs, struct path *pp)
>  	conf = get_multipath_config();
>  	select_pgpolicy(conf, mp);
>  	select_no_path_retry(conf, mp);
> +	will_return(__wrap_libmp_get_version, fake_dm_tgt_version);
>  	select_retain_hwhandler(conf, mp);
> +	will_return(__wrap_libmp_get_version, fake_dm_tgt_version);
>  	select_minio(conf, mp);
>  	put_multipath_config(conf);
>  
> -- 
> 2.28.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

