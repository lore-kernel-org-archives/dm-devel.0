Return-Path: <SRS0=hAiq=MV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5EE9C4338F
	for <dm-devel@archiver.kernel.org>; Thu, 29 Jul 2021 00:01:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 315096103C
	for <dm-devel@archiver.kernel.org>; Thu, 29 Jul 2021 00:01:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 315096103C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1627516860;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Y6UiKuWr92+cpzqmkkHpPWrYuQzIcOnInf1Z+GMVDGo=;
	b=hEBWgJtFYX3Q0f4H/RUQduuedZI7u06sloLyEiAVS0Eim4yRpMtqiO5OyLg3rw3nRNliri
	5II+Eio21jrn+lSRQ4WooW2WgPfKApuh0ZMvCz2sSL4M+55CNpx2NWW1L5vJuEJ8hWNFUF
	qzLMivp2Q/6OwysDB5Qbvhsno/hHXZ4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-497-R-w0kQYiOT6yJ6paXvnK8w-1; Wed, 28 Jul 2021 20:00:58 -0400
X-MC-Unique: R-w0kQYiOT6yJ6paXvnK8w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B465787D541;
	Thu, 29 Jul 2021 00:00:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6DE925D6A1;
	Thu, 29 Jul 2021 00:00:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9B7134BB7C;
	Thu, 29 Jul 2021 00:00:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16T00k8K022251 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 28 Jul 2021 20:00:46 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 7D81A5D6B1; Thu, 29 Jul 2021 00:00:46 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 87C3A5D6A1;
	Thu, 29 Jul 2021 00:00:42 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 16T00e4V012466; 
	Wed, 28 Jul 2021 19:00:40 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 16T00dcm012465;
	Wed, 28 Jul 2021 19:00:39 -0500
Date: Wed, 28 Jul 2021 19:00:39 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20210729000039.GM3087@octiron.msp.redhat.com>
References: <20210715105223.30463-1-mwilck@suse.com>
	<20210715105223.30463-6-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20210715105223.30463-6-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 5/9] libmultipath: use strbuf in print.c
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Jul 15, 2021 at 12:52:19PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Use the strbuf API in print.c, wherever growing string buffers are
> appropriate. This requires a large amount of changes in print.c itself,
> and in other files that use functions from print.c. It makes no sense
> to separate this into smaller patches though, as the various snprint_xyz()
> functions depend on each other, and need to use similar prototypes.
> 
> libmultipath version must be bumped, as all the printing functions have
> changed prototypes. Also, add the required strbuf functions to the
> libmultipath API.
> 
> Change the libmultipath calls in prioritizers, foreign libs,
> and in multipathd according to the strbuf-related API changes.
> 
> While working on print.c, I made a couple of other other minor changes:
>  - all snprint_xyz() functions return a negative error in case of failure
>    (most likely is -ENOMEM). In case of success, the number of printed
>    characters is returned.
>  - snprint_progress(): use fill_strbuf() rather than repeated iterations
>  - _snprint_multipath(), _snprint_path(), snprint_multipath_header(),
>    snprint_path_header(), _snprint_pathgroup(): use fill_strbuf()
>    instead of the PAD/NOPAD logic.
>  - _snprint_multipath_topology(): simplified the ASCII art generation for
>    the topology tree somewhat.
>  - snprint_json_xyz(): use fill_strbuf() rather than printing the indent
>    repeatedly.
>  - snprint_blacklist_group(), snprint_blacklist_devgroup(): combined two
>    print statements into one.
> 
> In cli_handlers.c, fixed the returned values for the "len" parameter in
> some functions (it's supposed to be the strlen of the reply + 1).
> 

That's a nice cleanup, especially for cli_handlers.c. I only found one
issue, although I have to admit that my eyes glazed over a bit reading
through the print.c changes.

> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/blacklist.c                 |   13 +-
>  libmultipath/discovery.c                 |   13 +-
>  libmultipath/foreign.c                   |   78 +-
>  libmultipath/foreign.h                   |   13 +-
>  libmultipath/foreign/nvme.c              |  100 +-
>  libmultipath/generic.c                   |   26 +-
>  libmultipath/generic.h                   |   17 +-
>  libmultipath/libmultipath.version        |   14 +-
>  libmultipath/parser.c                    |    5 +-
>  libmultipath/parser.h                    |    2 +-
>  libmultipath/print.c                     | 1696 +++++++++-------------
>  libmultipath/print.h                     |   67 +-
>  libmultipath/prioritizers/weightedpath.c |   71 +-
>  multipathd/cli_handlers.c                |  345 ++---
>  14 files changed, 1000 insertions(+), 1460 deletions(-)
> 
> diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
> index 6c6a597..4e315c9 100644
> --- a/libmultipath/blacklist.c
> +++ b/libmultipath/blacklist.c
> @@ -14,6 +14,7 @@
>  #include "blacklist.h"
>  #include "structs_vec.h"
>  #include "print.h"
> +#include "strbuf.h"
>  
>  char *check_invert(char *str, bool *invert)
>  {
> @@ -341,19 +342,21 @@ int
>  filter_protocol(const struct _vector *blist, const struct _vector *elist,
>  		const struct path *pp)
>  {
> -	char buf[PROTOCOL_BUF_SIZE];
> +	STRBUF_ON_STACK(buf);
> +	const char *prot;
>  	int r = MATCH_NOTHING;
>  
>  	if (pp) {
> -		snprint_path_protocol(buf, sizeof(buf), pp);
> +		snprint_path_protocol(&buf, pp);
> +		prot = get_strbuf_str(&buf);
>  
> -		if (match_reglist(elist, buf))
> +		if (match_reglist(elist, prot))
>  			r = MATCH_PROTOCOL_BLIST_EXCEPT;
> -		else if (match_reglist(blist, buf))
> +		else if (match_reglist(blist, prot))
>  			r = MATCH_PROTOCOL_BLIST;
> +		log_filter(pp->dev, NULL, NULL, NULL, NULL, prot, r, 3);
>  	}
>  
> -	log_filter(pp->dev, NULL, NULL, NULL, NULL, buf, r, 3);
>  	return r;
>  }
>  
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index e9f5703..f25fe9e 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -35,6 +35,7 @@
>  #include "foreign.h"
>  #include "configure.h"
>  #include "print.h"
> +#include "strbuf.h"
>  
>  struct vpd_vendor_page vpd_vendor_pages[VPD_VP_ARRAY_SIZE] = {
>  	[VPD_VP_UNDEF]	= { 0x00, "undef" },
> @@ -895,11 +896,11 @@ sysfs_set_scsi_tmo (struct multipath *mpp, unsigned int checkint)
>  	}
>  
>  	if (err_path) {
> -		char proto_buf[32];
> +		STRBUF_ON_STACK(proto_buf);
>  
> -		snprint_path_protocol(proto_buf, sizeof(proto_buf), err_path);
> +		snprint_path_protocol(&proto_buf, err_path);
>  		condlog(2, "%s: setting dev_loss_tmo is unsupported for protocol %s",
> -			mpp->alias, proto_buf);
> +			mpp->alias, get_strbuf_str(&proto_buf));
>  	}
>  	return 0;
>  }
> @@ -2380,11 +2381,11 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
>  				 * It's likely that this path is not fit for
>  				 * multipath use.
>  				 */
> -				char buf[16];
> +				STRBUF_ON_STACK(buf);
>  
> -				snprint_path(buf, sizeof(buf), "%T", pp, 0);
> +				snprint_path(&buf, "%T", pp, 0);
>  				condlog(1, "%s: no WWID in state \"%s\", giving up",
> -					pp->dev, buf);
> +					pp->dev, get_strbuf_str(&buf));
>  				return PATHINFO_SKIPPED;
>  			}
>  			return PATHINFO_OK;
> diff --git a/libmultipath/foreign.c b/libmultipath/foreign.c
> index fce1934..e091a1d 100644
> --- a/libmultipath/foreign.c
> +++ b/libmultipath/foreign.c
> @@ -34,6 +34,7 @@
>  #include "structs.h"
>  #include "structs_vec.h"
>  #include "print.h"
> +#include "strbuf.h"
>  
>  static vector foreigns;
>  
> @@ -497,11 +498,11 @@ void foreign_multipath_layout(void)
>  	pthread_cleanup_pop(1);
>  }
>  
> -int snprint_foreign_topology(char *buf, int len, int verbosity)
> +int snprint_foreign_topology(struct strbuf *buf, int verbosity)
>  {
>  	struct foreign *fgn;
>  	int i;
> -	char *c = buf;
> +	size_t initial_len = get_strbuf_len(buf);
>  
>  	rdlock_foreigns();
>  	if (foreigns == NULL) {
> @@ -521,58 +522,32 @@ int snprint_foreign_topology(char *buf, int len, int verbosity)
>  		vec = fgn->get_multipaths(fgn->context);
>  		if (vec != NULL) {
>  			vector_foreach_slot(vec, gm, j) {
> -
> -				c += _snprint_multipath_topology(gm, c,
> -								 buf + len - c,
> -								 verbosity);
> -				if (c >= buf + len - 1)
> +				if (_snprint_multipath_topology(
> +					    gm, buf, verbosity) < 0)
>  					break;
>  			}
> -			if (c >= buf + len - 1)
> -				break;
>  		}
>  		fgn->release_multipaths(fgn->context, vec);
>  		pthread_cleanup_pop(1);
>  	}
>  
>  	pthread_cleanup_pop(1);
> -	return c - buf;
> +	return get_strbuf_len(buf) - initial_len;
>  }
>  
>  void print_foreign_topology(int verbosity)
>  {
> -	int buflen = MAX_LINE_LEN * MAX_LINES;
> -	char *buf = NULL, *tmp = NULL;
> -
> -	buf = calloc(1, buflen);
> -
> -	while (buf != NULL) {
> -		char *c = buf;
> -
> -		c += snprint_foreign_topology(buf, buflen,
> -						   verbosity);
> -		if (c < buf + buflen - 1)
> -			break;
> -
> -		buflen *= 2;
> -		tmp = buf;
> -		buf = realloc(buf, buflen);
> -	}
> +	STRBUF_ON_STACK(buf);
>  
> -	if (buf == NULL && tmp != NULL)
> -		buf = tmp;
> -
> -	if (buf != NULL) {
> -		printf("%s", buf);
> -		free(buf);
> -	}
> +	snprint_foreign_topology(&buf, verbosity);
> +	printf("%s", get_strbuf_str(&buf));
>  }
>  
> -int snprint_foreign_paths(char *buf, int len, const char *style, int pretty)
> +int snprint_foreign_paths(struct strbuf *buf, const char *style, int pretty)
>  {
>  	struct foreign *fgn;
>  	int i;
> -	char *c = buf;
> +	size_t initial_len = get_strbuf_len(buf);
>  
>  	rdlock_foreigns();
>  	if (foreigns == NULL) {
> @@ -584,7 +559,7 @@ int snprint_foreign_paths(char *buf, int len, const char *style, int pretty)
>  	vector_foreach_slot(foreigns, fgn, i) {
>  		const struct _vector *vec;
>  		const struct gen_path *gp;
> -		int j;
> +		int j, ret = 0;
>  
>  		fgn->lock(fgn->context);
>  		pthread_cleanup_push(fgn->unlock, fgn->context);
> @@ -592,28 +567,27 @@ int snprint_foreign_paths(char *buf, int len, const char *style, int pretty)
>  		vec = fgn->get_paths(fgn->context);
>  		if (vec != NULL) {
>  			vector_foreach_slot(vec, gp, j) {
> -				c += _snprint_path(gp, c, buf + len - c,
> -						   style, pretty);
> -				if (c >= buf + len - 1)
> +				ret = _snprint_path(gp, buf, style, pretty);
> +				if (ret < 0)
>  					break;
>  			}
> -			if (c >= buf + len - 1)
> -				break;
>  		}
>  		fgn->release_paths(fgn->context, vec);
>  		pthread_cleanup_pop(1);
> +		if (ret < 0)
> +			break;
>  	}
>  
>  	pthread_cleanup_pop(1);
> -	return c - buf;
> +	return get_strbuf_len(buf) - initial_len;
>  }
>  
> -int snprint_foreign_multipaths(char *buf, int len,
> +int snprint_foreign_multipaths(struct strbuf *buf,
>  			       const char *style, int pretty)
>  {
>  	struct foreign *fgn;
>  	int i;
> -	char *c = buf;
> +	size_t initial_len = get_strbuf_len(buf);
>  
>  	rdlock_foreigns();
>  	if (foreigns == NULL) {
> @@ -625,7 +599,7 @@ int snprint_foreign_multipaths(char *buf, int len,
>  	vector_foreach_slot(foreigns, fgn, i) {
>  		const struct _vector *vec;
>  		const struct gen_multipath *gm;
> -		int j;
> +		int j, ret = 0;
>  
>  		fgn->lock(fgn->context);
>  		pthread_cleanup_push(fgn->unlock, fgn->context);
> @@ -633,18 +607,18 @@ int snprint_foreign_multipaths(char *buf, int len,
>  		vec = fgn->get_multipaths(fgn->context);
>  		if (vec != NULL) {
>  			vector_foreach_slot(vec, gm, j) {
> -				c += _snprint_multipath(gm, c, buf + len - c,
> -							style, pretty);
> -				if (c >= buf + len - 1)
> +				ret = _snprint_multipath(gm, buf,
> +							 style, pretty);
> +				if (ret < 0)
>  					break;
>  			}
> -			if (c >= buf + len - 1)
> -				break;
>  		}
>  		fgn->release_multipaths(fgn->context, vec);
>  		pthread_cleanup_pop(1);
> +		if (ret < 0)
> +			break;
>  	}
>  
>  	pthread_cleanup_pop(1);
> -	return c - buf;
> +	return get_strbuf_len(buf) - initial_len;
>  }
> diff --git a/libmultipath/foreign.h b/libmultipath/foreign.h
> index acd3360..77fc485 100644
> --- a/libmultipath/foreign.h
> +++ b/libmultipath/foreign.h
> @@ -18,9 +18,9 @@
>  #define _FOREIGN_H
>  #include <stdbool.h>
>  #include <libudev.h>
> +#define LIBMP_FOREIGN_API ((1 << 8) | 1)
>  
> -#define LIBMP_FOREIGN_API ((1 << 8) | 0)
> -
> +struct strbuf;
>  struct context;
>  
>  /* return codes of functions below returning "int" */
> @@ -267,35 +267,32 @@ void foreign_multipath_layout(void);
>   * prints topology information from foreign libraries into buffer,
>   * '\0' - terminated.
>   * @param buf: output buffer
> - * @param len: size of output buffer
>   * @param verbosity: verbosity level
>   * @returns: number of printed characters excluding trailing '\0'.
>   */
> -int snprint_foreign_topology(char *buf, int len, int verbosity);
> +int snprint_foreign_topology(struct strbuf *buf, int verbosity);
>  
>  /**
>   * snprint_foreign_paths(buf, len, style, pad);
>   * prints formatted path information from foreign libraries into buffer,
>   * '\0' - terminated.
>   * @param buf: output buffer
> - * @param len: size of output buffer
>   * @param style: format string
>   * @param pad: whether to pad field width
>   * @returns: number of printed characters excluding trailing '\0'.
>   */
> -int snprint_foreign_paths(char *buf, int len, const char *style, int pad);
> +int snprint_foreign_paths(struct strbuf *buf, const char *style, int pad);
>  
>  /**
>   * snprint_foreign_multipaths(buf, len, style, pad);
>   * prints formatted map information from foreign libraries into buffer,
>   * '\0' - terminated.
>   * @param buf: output buffer
> - * @param len: size of output buffer
>   * @param style: format string
>   * @param pad: whether to pad field width
>   * @returns: number of printed characters excluding trailing '\0'.
>   */
> -int snprint_foreign_multipaths(char *buf, int len,
> +int snprint_foreign_multipaths(struct strbuf *buf,
>  			       const char *style, int pretty);
>  
>  /**
> diff --git a/libmultipath/foreign/nvme.c b/libmultipath/foreign/nvme.c
> index b726be2..d40c086 100644
> --- a/libmultipath/foreign/nvme.c
> +++ b/libmultipath/foreign/nvme.c
> @@ -37,6 +37,7 @@
>  #include "debug.h"
>  #include "structs.h"
>  #include "sysfs.h"
> +#include "strbuf.h"
>  
>  static const char nvme_vendor[] = "NVMe";
>  static const char N_A[] = "n/a";
> @@ -138,7 +139,7 @@ static void rstrip(char *str)
>  }
>  
>  static int snprint_nvme_map(const struct gen_multipath *gmp,
> -			    char *buff, int len, char wildcard)
> +			    struct strbuf *buff, char wildcard)
>  {
>  	const struct nvme_map *nvm = const_gen_mp_to_nvme(gmp);
>  	char fld[NAME_LEN];
> @@ -146,26 +147,26 @@ static int snprint_nvme_map(const struct gen_multipath *gmp,
>  
>  	switch (wildcard) {
>  	case 'd':
> -		return snprintf(buff, len, "%s",
> +		return append_strbuf_str(buff,
>  				udev_device_get_sysname(nvm->udev));
>  	case 'n':
> -		return snprintf(buff, len, "%s:nsid.%s",
> +		return print_strbuf(buff, "%s:nsid.%s",
>  				udev_device_get_sysattr_value(nvm->subsys,
>  							      "subsysnqn"),
>  				udev_device_get_sysattr_value(nvm->udev,
>  							      "nsid"));
>  	case 'w':
> -		return snprintf(buff, len, "%s",
> +		return append_strbuf_str(buff,
>  				udev_device_get_sysattr_value(nvm->udev,
>  							      "wwid"));
>  	case 'N':
> -		return snprintf(buff, len, "%u", nvm->nr_live);
> +		return print_strbuf(buff, "%u", nvm->nr_live);
>  	case 'S':
> -		return snprintf(buff, len, "%s",
> +		return append_strbuf_str(buff,
>  				udev_device_get_sysattr_value(nvm->udev,
>  							      "size"));
>  	case 'v':
> -		return snprintf(buff, len, "%s", nvme_vendor);
> +		return append_strbuf_str(buff, nvme_vendor);
>  	case 's':
>  	case 'p':
>  		snprintf(fld, sizeof(fld), "%s",
> @@ -173,30 +174,30 @@ static int snprint_nvme_map(const struct gen_multipath *gmp,
>  						      "model"));
>  		rstrip(fld);
>  		if (wildcard == 'p')
> -			return snprintf(buff, len, "%s", fld);
> -		return snprintf(buff, len, "%s,%s,%s", nvme_vendor, fld,
> +			return append_strbuf_str(buff, fld);
> +		return print_strbuf(buff, "%s,%s,%s", nvme_vendor, fld,
>  				udev_device_get_sysattr_value(nvm->subsys,
>  							      "firmware_rev"));
>  	case 'e':
> -		return snprintf(buff, len, "%s",
> +		return append_strbuf_str(buff,
>  				udev_device_get_sysattr_value(nvm->subsys,
>  							      "firmware_rev"));
>  	case 'r':
>  		val = udev_device_get_sysattr_value(nvm->udev, "ro");
>  		if (val[0] == 1)
> -			return snprintf(buff, len, "%s", "ro");
> +			return append_strbuf_str(buff, "ro");
>  		else
> -			return snprintf(buff, len, "%s", "rw");
> +			return append_strbuf_str(buff, "rw");
>  	case 'G':
> -		return snprintf(buff, len, "%s", THIS);
> +		return append_strbuf_str(buff, THIS);
>  	case 'h':
>  		if (nvm->ana_supported == YNU_YES)
> -			return snprintf(buff, len, "ANA");
> +			return append_strbuf_str(buff, "ANA");
>  	default:
>  		break;
>  	}
>  
> -	return snprintf(buff, len, N_A);
> +	return append_strbuf_str(buff, N_A);
>  }
>  
>  static const struct _vector*
> @@ -214,7 +215,7 @@ nvme_pg_rel_paths(__attribute__((unused)) const struct gen_pathgroup *gpg,
>  	/* empty */
>  }
>  
> -static int snprint_hcil(const struct nvme_path *np, char *buf, int len)
> +static int snprint_hcil(const struct nvme_path *np, struct strbuf *buf)
>  {
>  	unsigned int nvmeid, ctlid, nsid;
>  	int rc;
> @@ -223,14 +224,13 @@ static int snprint_hcil(const struct nvme_path *np, char *buf, int len)
>  	rc = sscanf(sysname, "nvme%uc%un%u", &nvmeid, &ctlid, &nsid);
>  	if (rc != 3) {
>  		condlog(1, "%s: failed to scan %s", __func__, sysname);
> -		rc = snprintf(buf, len, "(ERR:%s)", sysname);
> +		return print_strbuf(buf, "(ERR:%s)", sysname);
>  	} else
> -		rc = snprintf(buf, len, "%u:%u:%u", nvmeid, ctlid, nsid);
> -	return (rc < len ? rc : len);
> +		return print_strbuf(buf, "%u:%u:%u", nvmeid, ctlid, nsid);
>  }
>  
>  static int snprint_nvme_path(const struct gen_path *gp,
> -			     char *buff, int len, char wildcard)
> +			     struct strbuf *buff, char wildcard)
>  {
>  	const struct nvme_path *np = const_gen_path_to_nvme(gp);
>  	dev_t devt;
> @@ -239,37 +239,37 @@ static int snprint_nvme_path(const struct gen_path *gp,
>  
>  	switch (wildcard) {
>  	case 'w':
> -		return snprintf(buff, len, "%s",
> -				udev_device_get_sysattr_value(np->udev,
> -							      "wwid"));
> +		return print_strbuf(buff, "%s",
> +				    udev_device_get_sysattr_value(np->udev,
> +								  "wwid"));
>  	case 'd':
> -		return snprintf(buff, len, "%s",
> -				udev_device_get_sysname(np->udev));
> +		return print_strbuf(buff, "%s",
> +				    udev_device_get_sysname(np->udev));
>  	case 'i':
> -		return snprint_hcil(np, buff, len);
> +		return snprint_hcil(np, buff);
>  	case 'D':
>  		devt = udev_device_get_devnum(np->udev);
> -		return snprintf(buff, len, "%u:%u", major(devt), minor(devt));
> +		return print_strbuf(buff, "%u:%u", major(devt), minor(devt));
>  	case 'o':
>  		if (sysfs_attr_get_value(np->ctl, "state",
>  					 fld, sizeof(fld)) > 0)
> -			return snprintf(buff, len, "%s", fld);
> +			return append_strbuf_str(buff, fld);
>  		break;
>  	case 'T':
>  		if (sysfs_attr_get_value(np->udev, "ana_state", fld,
>  					 sizeof(fld)) > 0)
> -			return snprintf(buff, len, "%s", fld);
> +			return append_strbuf_str(buff, fld);
>  		break;
>  	case 'p':
>  		if (sysfs_attr_get_value(np->udev, "ana_state", fld,
>  					 sizeof(fld)) > 0) {
>  			rstrip(fld);
>  			if (!strcmp(fld, "optimized"))
> -				return snprintf(buff, len, "%d", 50);
> +				return print_strbuf(buff, "%d", 50);
>  			else if (!strcmp(fld, "non-optimized"))
> -				return snprintf(buff, len, "%d", 10);
> +				return print_strbuf(buff, "%d", 10);
>  			else
> -				return snprintf(buff, len, "%d", 0);
> +				return print_strbuf(buff, "%d", 0);
>  		}
>  		break;
>  	case 's':
> @@ -277,46 +277,45 @@ static int snprint_nvme_path(const struct gen_path *gp,
>  			 udev_device_get_sysattr_value(np->ctl,
>  						      "model"));
>  		rstrip(fld);
> -		return snprintf(buff, len, "%s,%s,%s", nvme_vendor, fld,
> -				udev_device_get_sysattr_value(np->ctl,
> +		return print_strbuf(buff, "%s,%s,%s", nvme_vendor, fld,
> +				    udev_device_get_sysattr_value(np->ctl,
>  							      "firmware_rev"));
>  	case 'S':
> -		return snprintf(buff, len, "%s",
> +		return append_strbuf_str(buff,
>  			udev_device_get_sysattr_value(np->udev,
>  						      "size"));
>  	case 'z':
> -		return snprintf(buff, len, "%s",
> +		return append_strbuf_str(buff,
>  				udev_device_get_sysattr_value(np->ctl,
>  							      "serial"));
>  	case 'm':
> -		return snprintf(buff, len, "%s",
> +		return append_strbuf_str(buff,
>  				udev_device_get_sysname(np->map->udev));
>  	case 'N':
>  	case 'R':
> -		return snprintf(buff, len, "%s:%s",
> +		return print_strbuf(buff, "%s:%s",
>  			udev_device_get_sysattr_value(np->ctl,
>  						      "transport"),
>  			udev_device_get_sysattr_value(np->ctl,
>  						      "address"));
>  	case 'G':
> -		return snprintf(buff, len, "[%s]", THIS);
> +		return print_strbuf(buff, "[%s]", THIS);
>  	case 'a':
>  		pci = udev_device_get_parent_with_subsystem_devtype(np->ctl,
>  								    "pci",
>  								    NULL);
>  		if (pci != NULL)
> -			return snprintf(buff, len, "PCI:%s",
> -					udev_device_get_sysname(pci));
> +			return print_strbuf(buff, "PCI:%s",
> +					    udev_device_get_sysname(pci));
>  		/* fall through */
>  	default:
>  		break;
>  	}
> -	return snprintf(buff, len, "%s", N_A);
> -	return 0;
> +	return append_strbuf_str(buff, N_A);
>  }
>  
>  static int snprint_nvme_pg(const struct gen_pathgroup *gmp,
> -			   char *buff, int len, char wildcard)
> +			   struct strbuf *buff, char wildcard)
>  {
>  	const struct nvme_pathgroup *pg = const_gen_pg_to_nvme(gmp);
>  	const struct nvme_path *path = nvme_pg_to_path(pg);
> @@ -324,22 +323,19 @@ static int snprint_nvme_pg(const struct gen_pathgroup *gmp,
>  	switch (wildcard) {
>  	case 't':
>  		return snprint_nvme_path(nvme_path_to_gen(path),
> -					 buff, len, 'T');
> +					 buff, 'T');
>  	case 'p':
>  		return snprint_nvme_path(nvme_path_to_gen(path),
> -					 buff, len, 'p');
> +					 buff, 'p');
>  	default:
> -		return snprintf(buff, len, N_A);
> +		return append_strbuf_str(buff, N_A);
>  	}
>  }
>  
>  static int nvme_style(__attribute__((unused)) const struct gen_multipath* gm,
> -		      char *buf, int len,
> -		      __attribute__((unused)) int verbosity)
> +		      struct strbuf *buf, __attribute__((unused)) int verbosity)
>  {
> -	int n = snprintf(buf, len, "%%w [%%G]:%%d %%s");
> -
> -	return (n < len ? n : len - 1);
> +	return append_strbuf_str(buf, "%%w [%%G]:%%d %%s");
>  }
>  
>  static const struct gen_multipath_ops nvme_map_ops = {
> diff --git a/libmultipath/generic.c b/libmultipath/generic.c
> index 5f03b9e..e7cf297 100644
> --- a/libmultipath/generic.c
> +++ b/libmultipath/generic.c
> @@ -15,23 +15,23 @@
>    along with this program.  If not, see <https://www.gnu.org/licenses/>.
>   */
>  
> -
> -#include <string.h>
>  #include "generic.h"
>  #include "structs.h"
> +#include "util.h"
> +#include "strbuf.h"
>  
> -int generic_style(const struct gen_multipath* gm,
> -		  char *buf, int len, __attribute__((unused)) int verbosity)
> +int generic_style(const struct gen_multipath* gm, struct strbuf *buf,
> +		  __attribute__((unused)) int verbosity)
>  {
> -	char alias_buf[WWID_SIZE];
> -	char wwid_buf[WWID_SIZE];
> -	int n = 0;
> -
> -	gm->ops->snprint(gm, alias_buf, sizeof(alias_buf), 'n');
> -	gm->ops->snprint(gm, wwid_buf, sizeof(wwid_buf), 'w');
> +	STRBUF_ON_STACK(tmp);
> +	char *alias_buf __attribute__((cleanup(cleanup_charp)));
> +	const char *wwid_buf;
>  
> -	n += snprintf(buf, len, "%%n %s[%%G]:%%d %%s",
> -		      strcmp(alias_buf, wwid_buf) ? "(%w) " : "");
> +	gm->ops->snprint(gm, &tmp, 'n');
> +	alias_buf = steal_strbuf_str(&tmp);
> +	gm->ops->snprint(gm, &tmp, 'w');
> +	wwid_buf = get_strbuf_str(&tmp);
>  
> -	return (n < len ? n : len - 1);
> +	return print_strbuf(buf, "%%n %s[%%G]:%%d %%s",
> +			    strcmp(alias_buf, wwid_buf) ? "(%w) " : "");
>  }
> diff --git a/libmultipath/generic.h b/libmultipath/generic.h
> index 6346ffe..57c123c 100644
> --- a/libmultipath/generic.h
> +++ b/libmultipath/generic.h
> @@ -18,6 +18,7 @@
>  #define _GENERIC_H
>  #include "vector.h"
>  
> +struct strbuf;
>  struct gen_multipath;
>  struct gen_pathgroup;
>  struct gen_path;
> @@ -50,26 +51,24 @@ struct gen_multipath_ops {
>  	 * 0-terminated, no more than "len" characters including trailing '\0'.
>  	 *
>  	 * @param gmp: generic multipath object to act on
> -	 * @param buf: output buffer
> -	 * @param buflen: buffer size
> +	 * @param buf: output struct strbuf
>  	 * @param wildcard: the multipath wildcard (see print.c)
>  	 * @returns the number of characters printed (without trailing '\0').
>  	 */
>  	int (*snprint)(const struct gen_multipath*,
> -		       char *buf, int len, char wildcard);
> +		       struct strbuf *buf, char wildcard);
>  	/**
>  	 * method: style(gmp, buf, len, verbosity)
>  	 * returns the format string to be used for the multipath object,
>  	 * defined with the wildcards as defined in print.c
>  	 * generic_style() should work well in most cases.
>  	 * @param gmp: generic multipath object to act on
> -	 * @param buf: output buffer
> -	 * @param buflen: buffer size
> +	 * @param buf: output strbuf
>  	 * @param verbosity: verbosity level
>  	 * @returns number of format chars printed
>  	 */
>  	int (*style)(const struct gen_multipath*,
> -		     char *buf, int len, int verbosity);
> +		     struct strbuf *buf, int verbosity);
>  };
>  
>  /**
> @@ -95,7 +94,7 @@ struct gen_pathgroup_ops {
>  	 * see gen_multipath_ops->snprint() above
>  	 */
>  	int (*snprint)(const struct gen_pathgroup*,
> -		       char *buf, int len, char wildcard);
> +		       struct strbuf *buf, char wildcard);
>  };
>  
>  struct gen_path_ops {
> @@ -104,7 +103,7 @@ struct gen_path_ops {
>  	 * see gen_multipath_ops->snprint() above
>  	 */
>  	int (*snprint)(const struct gen_path*,
> -		       char *buf, int len, char wildcard);
> +		       struct strbuf *buf, char wildcard);
>  };
>  
>  struct gen_multipath {
> @@ -129,6 +128,6 @@ struct gen_path {
>   * foreign libraries.
>   */
>  int generic_style(const struct gen_multipath*,
> -		  char *buf, int len, int verbosity);
> +		  struct strbuf *buf, int verbosity);
>  
>  #endif /* _GENERIC_H */
> diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
> index 6dd52c2..1d84d97 100644
> --- a/libmultipath/libmultipath.version
> +++ b/libmultipath/libmultipath.version
> @@ -31,7 +31,7 @@
>   *   The new version inherits the previous ones.
>   */
>  
> -LIBMULTIPATH_7.0.0 {
> +LIBMULTIPATH_8.0.0 {
>  global:
>  	/* symbols referenced by multipath and multipathd */
>  	add_foreign;
> @@ -273,3 +273,15 @@ global:
>  local:
>  	*;
>  };
> +
> +LIBMULTIPATH_8.1.0 {
> +global:
> +	reset_strbuf;
> +	append_strbuf_str;
> +	get_strbuf_len;
> +	get_strbuf_str;
> +	steal_strbuf_str;
> +	fill_strbuf;
> +	print_strbuf;
> +	truncate_strbuf;
> +} LIBMULTIPATH_8.0.0;
> diff --git a/libmultipath/parser.c b/libmultipath/parser.c
> index 88c7b59..8ca91bf 100644
> --- a/libmultipath/parser.c
> +++ b/libmultipath/parser.c
> @@ -150,7 +150,7 @@ find_keyword(vector keywords, vector v, char * name)
>  }
>  
>  int
> -snprint_keyword(char *buff, int len, char *fmt, struct keyword *kw,
> +snprint_keyword(struct strbuf *buff, const char *fmt, struct keyword *kw,
>  		const void *data)
>  {
>  	int r;
> @@ -191,7 +191,8 @@ snprint_keyword(char *buff, int len, char *fmt, struct keyword *kw,
>  		}
>  	} while (*fmt++);
>  out:
> -	return snprintf(buff, len, "%s", get_strbuf_str(&sbuf));
> +	return __append_strbuf_str(buff, get_strbuf_str(&sbuf),
> +				   get_strbuf_len(&sbuf));
>  }
>  
>  static const char quote_marker[] = { '\0', '"', '\0' };
> diff --git a/libmultipath/parser.h b/libmultipath/parser.h
> index e8b6eb2..b43d46f 100644
> --- a/libmultipath/parser.h
> +++ b/libmultipath/parser.h
> @@ -82,7 +82,7 @@ extern vector alloc_strvec(char *string);
>  extern void *set_value(vector strvec);
>  extern int process_file(struct config *conf, const char *conf_file);
>  extern struct keyword * find_keyword(vector keywords, vector v, char * name);
> -int snprint_keyword(char *buff, int len, char *fmt, struct keyword *kw,
> +int snprint_keyword(struct strbuf *buff, const char *fmt, struct keyword *kw,
>  		    const void *data);
>  bool is_quote(const char* token);
>  
> diff --git a/libmultipath/print.c b/libmultipath/print.c
> index 29ce499..4bf2f7c 100644
> --- a/libmultipath/print.c
> +++ b/libmultipath/print.c
> @@ -1,4 +1,4 @@
> - /*
> +/*
>   * Copyright (c) 2005 Christophe Varoqui
>   */
>  #include <stdio.h>
> @@ -31,59 +31,33 @@
>  #include "discovery.h"
>  #include "util.h"
>  #include "foreign.h"
> +#include "strbuf.h"
>  
>  #define MAX(x,y) (((x) > (y)) ? (x) : (y))
>  #define MIN(x,y) (((x) > (y)) ? (y) : (x))
> -#define TAIL     (line + len - 1 - c)
> -#define NOPAD    s = c
> -#define PAD(x) \
> -do { \
> -	while (c < (s + x) && (c < (line + len - 1))) \
> -		*c++ = ' '; \
> -	s = c; \
> -} while (0)
> -
> -static char *
> -__endline(char *line, size_t len, char *c)
> -{
> -	if (c > line) {
> -		if (c >= line + len)
> -			c = line + len - 1;
> -		*(c - 1) = '\n';
> -		*c = '\0';
> -	}
> -	return c;
> -}
> -
> -#define PRINT(var, size, format, args...) \
> -do { \
> -	fwd = snprintf(var, size, format, ##args); \
> -	c += (fwd >= size) ? size : fwd; \
> -} while (0)
> -
>  /*
>   * information printing helpers
>   */
>  static int
> -snprint_str (char * buff, size_t len, const char * str)
> +snprint_str(struct strbuf *buff, const char *str)
>  {
> -	return snprintf(buff, len, "%s", str);
> +	return append_strbuf_str(buff, str);
>  }
>  
>  static int
> -snprint_int (char * buff, size_t len, int val)
> +snprint_int (struct strbuf *buff, int val)
>  {
> -	return snprintf(buff, len, "%i", val);
> +	return print_strbuf(buff, "%i", val);
>  }
>  
>  static int
> -snprint_uint (char * buff, size_t len, unsigned int val)
> +snprint_uint (struct strbuf *buff, unsigned int val)
>  {
> -	return snprintf(buff, len, "%u", val);
> +	return print_strbuf(buff, "%u", val);
>  }
>  
>  static int
> -snprint_size (char * buff, size_t len, unsigned long long size)
> +snprint_size (struct strbuf *buff, unsigned long long size)
>  {
>  	float s = (float)(size >> 1); /* start with KB */
>  	char units[] = {'K','M','G','T','P'};
> @@ -94,184 +68,177 @@ snprint_size (char * buff, size_t len, unsigned long long size)
>  		u++;
>  	}
>  
> -	return snprintf(buff, len, "%.*f%c", s < 10, s, *u);
> +	return print_strbuf(buff, "%.*f%c", s < 10, s, *u);
>  }
>  
>  /*
>   * multipath info printing functions
>   */
>  static int
> -snprint_name (char * buff, size_t len, const struct multipath * mpp)
> +snprint_name (struct strbuf *buff, const struct multipath * mpp)
>  {
>  	if (mpp->alias)
> -		return snprintf(buff, len, "%s", mpp->alias);
> +		return append_strbuf_str(buff, mpp->alias);
>  	else
> -		return snprintf(buff, len, "%s", mpp->wwid);
> +		return append_strbuf_str(buff, mpp->wwid);
>  }
>  
>  static int
> -snprint_sysfs (char * buff, size_t len, const struct multipath * mpp)
> +snprint_sysfs (struct strbuf *buff, const struct multipath * mpp)
>  {
>  	if (mpp->dmi)
> -		return snprintf(buff, len, "dm-%i", mpp->dmi->minor);
> +		return print_strbuf(buff, "dm-%i", mpp->dmi->minor);
>  	else
> -		return snprintf(buff, len, "undef");
> +		return append_strbuf_str(buff, "undef");
>  }
>  
>  static int
> -snprint_ro (char * buff, size_t len, const struct multipath * mpp)
> +snprint_ro (struct strbuf *buff, const struct multipath * mpp)
>  {
>  	if (!mpp->dmi)
> -		return snprintf(buff, len, "undef");
> +		return append_strbuf_str(buff, "undef");
>  	if (mpp->dmi->read_only)
> -		return snprintf(buff, len, "ro");
> +		return append_strbuf_str(buff, "ro");
>  	else
> -		return snprintf(buff, len, "rw");
> +		return append_strbuf_str(buff, "rw");
>  }
>  
>  static int
> -snprint_progress (char * buff, size_t len, int cur, int total)
> +snprint_progress (struct strbuf *buff, int cur, int total)
>  {
> -	char * c = buff;
> -	char * end = buff + len;
> +	size_t initial_len = get_strbuf_len(buff);
> +	int rc;
>  
>  	if (total > 0) {
>  		int i = PROGRESS_LEN * cur / total;
>  		int j = PROGRESS_LEN - i;
>  
> -		while (i-- > 0) {
> -			c += snprintf(c, len, "X");
> -			if ((len = (end - c)) <= 1) goto out;
> -		}
> -
> -		while (j-- > 0) {
> -			c += snprintf(c, len,  ".");
> -			if ((len = (end - c)) <= 1) goto out;
> +		if ((rc = fill_strbuf(buff, 'X', i)) < 0 ||
> +		    (rc = fill_strbuf(buff, '.', j) < 0)) {
> +			truncate_strbuf(buff, initial_len);
> +			return rc;
>  		}
>  	}
>  
> -	c += snprintf(c, len, " %i/%i", cur, total);
> -
> -out:
> -	buff[c - buff + 1] = '\0';
> -	return (c - buff + 1);
> +	if ((rc = print_strbuf(buff, " %i/%i", cur, total)) < 0)
> +		return rc;

An extra minus sign crept in here.

-Ben

> +	return get_strbuf_len(buff) - -initial_len;
>  }
>  
>  static int
> -snprint_failback (char * buff, size_t len, const struct multipath * mpp)
> +snprint_failback (struct strbuf *buff, const struct multipath * mpp)
>  {
>  	if (mpp->pgfailback == -FAILBACK_IMMEDIATE)
> -		return snprintf(buff, len, "immediate");
> +		return append_strbuf_str(buff, "immediate");
>  	if (mpp->pgfailback == -FAILBACK_FOLLOWOVER)
> -		return snprintf(buff, len, "followover");
> +		return append_strbuf_str(buff, "followover");
>  
>  	if (!mpp->failback_tick)
> -		return snprintf(buff, len, "-");
> +		return append_strbuf_str(buff, "-");
>  	else
> -		return snprint_progress(buff, len, mpp->failback_tick,
> +		return snprint_progress(buff, mpp->failback_tick,
>  					mpp->pgfailback);
>  }
>  
>  static int
> -snprint_queueing (char * buff, size_t len, const struct multipath * mpp)
> +snprint_queueing (struct strbuf *buff, const struct multipath * mpp)
>  {
>  	if (mpp->no_path_retry == NO_PATH_RETRY_FAIL)
> -		return snprintf(buff, len, "off");
> +		return append_strbuf_str(buff, "off");
>  	else if (mpp->no_path_retry == NO_PATH_RETRY_QUEUE)
> -		return snprintf(buff, len, "on");
> +		return append_strbuf_str(buff, "on");
>  	else if (mpp->no_path_retry == NO_PATH_RETRY_UNDEF)
> -		return snprintf(buff, len, "-");
> +		return append_strbuf_str(buff, "-");
>  	else if (mpp->no_path_retry > 0) {
>  		if (mpp->retry_tick > 0)
>  
> -			return snprintf(buff, len, "%i sec",
> -					mpp->retry_tick);
> +			return print_strbuf(buff, "%i sec", mpp->retry_tick);
>  		else if (mpp->retry_tick == 0 && count_active_paths(mpp) > 0)
> -			return snprintf(buff, len, "%i chk",
> -					mpp->no_path_retry);
> +			return print_strbuf(buff, "%i chk",
> +					    mpp->no_path_retry);
>  		else
> -			return snprintf(buff, len, "off");
> +			return append_strbuf_str(buff, "off");
>  	}
>  	return 0;
>  }
>  
>  static int
> -snprint_nb_paths (char * buff, size_t len, const struct multipath * mpp)
> +snprint_nb_paths (struct strbuf *buff, const struct multipath * mpp)
>  {
> -	return snprint_int(buff, len, count_active_paths(mpp));
> +	return snprint_int(buff, count_active_paths(mpp));
>  }
>  
>  static int
> -snprint_dm_map_state (char * buff, size_t len, const struct multipath * mpp)
> +snprint_dm_map_state (struct strbuf *buff, const struct multipath * mpp)
>  {
>  	if (mpp->dmi && mpp->dmi->suspended)
> -		return snprintf(buff, len, "suspend");
> +		return append_strbuf_str(buff, "suspend");
>  	else
> -		return snprintf(buff, len, "active");
> +		return append_strbuf_str(buff, "active");
>  }
>  
>  static int
> -snprint_multipath_size (char * buff, size_t len, const struct multipath * mpp)
> +snprint_multipath_size (struct strbuf *buff, const struct multipath * mpp)
>  {
> -	return snprint_size(buff, len, mpp->size);
> +	return snprint_size(buff, mpp->size);
>  }
>  
>  static int
> -snprint_features (char * buff, size_t len, const struct multipath * mpp)
> +snprint_features (struct strbuf *buff, const struct multipath * mpp)
>  {
> -	return snprint_str(buff, len, mpp->features);
> +	return snprint_str(buff, mpp->features);
>  }
>  
>  static int
> -snprint_hwhandler (char * buff, size_t len, const struct multipath * mpp)
> +snprint_hwhandler (struct strbuf *buff, const struct multipath * mpp)
>  {
> -	return snprint_str(buff, len, mpp->hwhandler);
> +	return snprint_str(buff, mpp->hwhandler);
>  }
>  
>  static int
> -snprint_path_faults (char * buff, size_t len, const struct multipath * mpp)
> +snprint_path_faults (struct strbuf *buff, const struct multipath * mpp)
>  {
> -	return snprint_uint(buff, len, mpp->stat_path_failures);
> +	return snprint_uint(buff, mpp->stat_path_failures);
>  }
>  
>  static int
> -snprint_switch_grp (char * buff, size_t len, const struct multipath * mpp)
> +snprint_switch_grp (struct strbuf *buff, const struct multipath * mpp)
>  {
> -	return snprint_uint(buff, len, mpp->stat_switchgroup);
> +	return snprint_uint(buff, mpp->stat_switchgroup);
>  }
>  
>  static int
> -snprint_map_loads (char * buff, size_t len, const struct multipath * mpp)
> +snprint_map_loads (struct strbuf *buff, const struct multipath * mpp)
>  {
> -	return snprint_uint(buff, len, mpp->stat_map_loads);
> +	return snprint_uint(buff, mpp->stat_map_loads);
>  }
>  
>  static int
> -snprint_total_q_time (char * buff, size_t len, const struct multipath * mpp)
> +snprint_total_q_time (struct strbuf *buff, const struct multipath * mpp)
>  {
> -	return snprint_uint(buff, len, mpp->stat_total_queueing_time);
> +	return snprint_uint(buff, mpp->stat_total_queueing_time);
>  }
>  
>  static int
> -snprint_q_timeouts (char * buff, size_t len, const struct multipath * mpp)
> +snprint_q_timeouts (struct strbuf *buff, const struct multipath * mpp)
>  {
> -	return snprint_uint(buff, len, mpp->stat_queueing_timeouts);
> +	return snprint_uint(buff, mpp->stat_queueing_timeouts);
>  }
>  
>  static int
> -snprint_map_failures (char * buff, size_t len, const struct multipath * mpp)
> +snprint_map_failures (struct strbuf *buff, const struct multipath * mpp)
>  {
> -	return snprint_uint(buff, len, mpp->stat_map_failures);
> +	return snprint_uint(buff, mpp->stat_map_failures);
>  }
>  
>  static int
> -snprint_multipath_uuid (char * buff, size_t len, const struct multipath * mpp)
> +snprint_multipath_uuid (struct strbuf *buff, const struct multipath * mpp)
>  {
> -	return snprint_str(buff, len, mpp->wwid);
> +	return snprint_str(buff, mpp->wwid);
>  }
>  
>  static int
> -snprint_multipath_vpr (char * buff, size_t len, const struct multipath * mpp)
> +snprint_multipath_vpr (struct strbuf *buff, const struct multipath * mpp)
>  {
>  	struct pathgroup * pgp;
>  	struct path * pp;
> @@ -280,16 +247,16 @@ snprint_multipath_vpr (char * buff, size_t len, const struct multipath * mpp)
>  	vector_foreach_slot(mpp->pg, pgp, i) {
>  		vector_foreach_slot(pgp->paths, pp, j) {
>  			if (strlen(pp->vendor_id) && strlen(pp->product_id))
> -				return snprintf(buff, len, "%s,%s",
> -						pp->vendor_id, pp->product_id);
> +				return print_strbuf(buff, "%s,%s",
> +						    pp->vendor_id, pp->product_id);
>  		}
>  	}
> -	return snprintf(buff, len, "##,##");
> +	return append_strbuf_str(buff, "##,##");
>  }
>  
>  
>  static int
> -snprint_multipath_vend (char * buff, size_t len, const struct multipath * mpp)
> +snprint_multipath_vend (struct strbuf *buff, const struct multipath * mpp)
>  {
>  	struct pathgroup * pgp;
>  	struct path * pp;
> @@ -298,14 +265,14 @@ snprint_multipath_vend (char * buff, size_t len, const struct multipath * mpp)
>  	vector_foreach_slot(mpp->pg, pgp, i) {
>  		vector_foreach_slot(pgp->paths, pp, j) {
>  			if (strlen(pp->vendor_id))
> -				return snprintf(buff, len, "%s", pp->vendor_id);
> +				return append_strbuf_str(buff, pp->vendor_id);
>  		}
>  	}
> -	return snprintf(buff, len, "##");
> +	return append_strbuf_str(buff, "##");
>  }
>  
>  static int
> -snprint_multipath_prod (char * buff, size_t len, const struct multipath * mpp)
> +snprint_multipath_prod (struct strbuf *buff, const struct multipath * mpp)
>  {
>  	struct pathgroup * pgp;
>  	struct path * pp;
> @@ -314,14 +281,14 @@ snprint_multipath_prod (char * buff, size_t len, const struct multipath * mpp)
>  	vector_foreach_slot(mpp->pg, pgp, i) {
>  		vector_foreach_slot(pgp->paths, pp, j) {
>  			if (strlen(pp->product_id))
> -				return snprintf(buff, len, "%s", pp->product_id);
> +				return append_strbuf_str(buff, pp->product_id);
>  		}
>  	}
> -	return snprintf(buff, len, "##");
> +	return append_strbuf_str(buff, "##");
>  }
>  
>  static int
> -snprint_multipath_rev (char * buff, size_t len, const struct multipath * mpp)
> +snprint_multipath_rev (struct strbuf *buff, const struct multipath * mpp)
>  {
>  	struct pathgroup * pgp;
>  	struct path * pp;
> @@ -330,40 +297,40 @@ snprint_multipath_rev (char * buff, size_t len, const struct multipath * mpp)
>  	vector_foreach_slot(mpp->pg, pgp, i) {
>  		vector_foreach_slot(pgp->paths, pp, j) {
>  			if (strlen(pp->rev))
> -				return snprintf(buff, len, "%s", pp->rev);
> +				return append_strbuf_str(buff, pp->rev);
>  		}
>  	}
> -	return snprintf(buff, len, "##");
> +	return append_strbuf_str(buff, "##");
>  }
>  
>  static int
> -snprint_multipath_foreign (char * buff, size_t len,
> +snprint_multipath_foreign (struct strbuf *buff,
>  			   __attribute__((unused)) const struct multipath * pp)
>  {
> -	return snprintf(buff, len, "%s", "--");
> +	return append_strbuf_str(buff, "--");
>  }
>  
>  static int
> -snprint_action (char * buff, size_t len, const struct multipath * mpp)
> +snprint_action (struct strbuf *buff, const struct multipath * mpp)
>  {
>  	switch (mpp->action) {
>  	case ACT_REJECT:
> -		return snprint_str(buff, len, ACT_REJECT_STR);
> +		return snprint_str(buff, ACT_REJECT_STR);
>  	case ACT_RENAME:
> -		return snprint_str(buff, len, ACT_RENAME_STR);
> +		return snprint_str(buff, ACT_RENAME_STR);
>  	case ACT_RELOAD:
> -		return snprint_str(buff, len, ACT_RELOAD_STR);
> +		return snprint_str(buff, ACT_RELOAD_STR);
>  	case ACT_CREATE:
> -		return snprint_str(buff, len, ACT_CREATE_STR);
> +		return snprint_str(buff, ACT_CREATE_STR);
>  	case ACT_SWITCHPG:
> -		return snprint_str(buff, len, ACT_SWITCHPG_STR);
> +		return snprint_str(buff, ACT_SWITCHPG_STR);
>  	default:
>  		return 0;
>  	}
>  }
>  
>  static int
> -snprint_multipath_vpd_data(char * buff, size_t len,
> +snprint_multipath_vpd_data(struct strbuf *buff,
>  			   const struct multipath * mpp)
>  {
>  	struct pathgroup * pgp;
> @@ -373,26 +340,26 @@ snprint_multipath_vpd_data(char * buff, size_t len,
>  	vector_foreach_slot(mpp->pg, pgp, i)
>  		vector_foreach_slot(pgp->paths, pp, j)
>  			if (pp->vpd_data)
> -				return snprintf(buff, len, "%s", pp->vpd_data);
> -	return snprintf(buff, len, "[undef]");
> +				return append_strbuf_str(buff, pp->vpd_data);
> +	return append_strbuf_str(buff, "[undef]");
>  }
>  
>  /*
>   * path info printing functions
>   */
>  static int
> -snprint_path_uuid (char * buff, size_t len, const struct path * pp)
> +snprint_path_uuid (struct strbuf *buff, const struct path * pp)
>  {
> -	return snprint_str(buff, len, pp->wwid);
> +	return snprint_str(buff, pp->wwid);
>  }
>  
>  static int
> -snprint_hcil (char * buff, size_t len, const struct path * pp)
> +snprint_hcil (struct strbuf *buff, const struct path * pp)
>  {
>  	if (!pp || pp->sg_id.host_no < 0)
> -		return snprintf(buff, len, "#:#:#:#");
> +		return append_strbuf_str(buff, "#:#:#:#");
>  
> -	return snprintf(buff, len, "%i:%i:%i:%" PRIu64,
> +	return print_strbuf(buff, "%i:%i:%i:%" PRIu64,
>  			pp->sg_id.host_no,
>  			pp->sg_id.channel,
>  			pp->sg_id.scsi_id,
> @@ -400,159 +367,158 @@ snprint_hcil (char * buff, size_t len, const struct path * pp)
>  }
>  
>  static int
> -snprint_dev (char * buff, size_t len, const struct path * pp)
> +snprint_dev (struct strbuf *buff, const struct path * pp)
>  {
>  	if (!pp || !strlen(pp->dev))
> -		return snprintf(buff, len, "-");
> +		return append_strbuf_str(buff, "-");
>  	else
> -		return snprint_str(buff, len, pp->dev);
> +		return snprint_str(buff, pp->dev);
>  }
>  
>  static int
> -snprint_dev_t (char * buff, size_t len, const struct path * pp)
> +snprint_dev_t (struct strbuf *buff, const struct path * pp)
>  {
>  	if (!pp || !strlen(pp->dev))
> -		return snprintf(buff, len, "#:#");
> +		return append_strbuf_str(buff, "#:#");
>  	else
> -		return snprint_str(buff, len, pp->dev_t);
> +		return snprint_str(buff, pp->dev_t);
>  }
>  
>  static int
> -snprint_offline (char * buff, size_t len, const struct path * pp)
> +snprint_offline (struct strbuf *buff, const struct path * pp)
>  {
>  	if (!pp || !pp->mpp)
> -		return snprintf(buff, len, "unknown");
> +		return append_strbuf_str(buff, "unknown");
>  	else if (pp->offline)
> -		return snprintf(buff, len, "offline");
> +		return append_strbuf_str(buff, "offline");
>  	else
> -		return snprintf(buff, len, "running");
> +		return append_strbuf_str(buff, "running");
>  }
>  
>  static int
> -snprint_chk_state (char * buff, size_t len, const struct path * pp)
> +snprint_chk_state (struct strbuf *buff, const struct path * pp)
>  {
>  	if (!pp || !pp->mpp)
> -		return snprintf(buff, len, "undef");
> +		return append_strbuf_str(buff, "undef");
>  
>  	switch (pp->state) {
>  	case PATH_UP:
> -		return snprintf(buff, len, "ready");
> +		return append_strbuf_str(buff, "ready");
>  	case PATH_DOWN:
> -		return snprintf(buff, len, "faulty");
> +		return append_strbuf_str(buff, "faulty");
>  	case PATH_SHAKY:
> -		return snprintf(buff, len, "shaky");
> +		return append_strbuf_str(buff, "shaky");
>  	case PATH_GHOST:
> -		return snprintf(buff, len, "ghost");
> +		return append_strbuf_str(buff, "ghost");
>  	case PATH_PENDING:
> -		return snprintf(buff, len, "i/o pending");
> +		return append_strbuf_str(buff, "i/o pending");
>  	case PATH_TIMEOUT:
> -		return snprintf(buff, len, "i/o timeout");
> +		return append_strbuf_str(buff, "i/o timeout");
>  	case PATH_DELAYED:
> -		return snprintf(buff, len, "delayed");
> +		return append_strbuf_str(buff, "delayed");
>  	default:
> -		return snprintf(buff, len, "undef");
> +		return append_strbuf_str(buff, "undef");
>  	}
>  }
>  
>  static int
> -snprint_dm_path_state (char * buff, size_t len, const struct path * pp)
> +snprint_dm_path_state (struct strbuf *buff, const struct path * pp)
>  {
>  	if (!pp)
> -		return snprintf(buff, len, "undef");
> +		return append_strbuf_str(buff, "undef");
>  
>  	switch (pp->dmstate) {
>  	case PSTATE_ACTIVE:
> -		return snprintf(buff, len, "active");
> +		return append_strbuf_str(buff, "active");
>  	case PSTATE_FAILED:
> -		return snprintf(buff, len, "failed");
> +		return append_strbuf_str(buff, "failed");
>  	default:
> -		return snprintf(buff, len, "undef");
> +		return append_strbuf_str(buff, "undef");
>  	}
>  }
>  
>  static int
> -snprint_vpr (char * buff, size_t len, const struct path * pp)
> +snprint_vpr (struct strbuf *buff, const struct path * pp)
>  {
> -	return snprintf(buff, len, "%s,%s",
> -			pp->vendor_id, pp->product_id);
> +	return print_strbuf(buff, "%s,%s", pp->vendor_id, pp->product_id);
>  }
>  
>  static int
> -snprint_next_check (char * buff, size_t len, const struct path * pp)
> +snprint_next_check (struct strbuf *buff, const struct path * pp)
>  {
>  	if (!pp || !pp->mpp)
> -		return snprintf(buff, len, "orphan");
> +		return append_strbuf_str(buff, "orphan");
>  
> -	return snprint_progress(buff, len, pp->tick, pp->checkint);
> +	return snprint_progress(buff, pp->tick, pp->checkint);
>  }
>  
>  static int
> -snprint_pri (char * buff, size_t len, const struct path * pp)
> +snprint_pri (struct strbuf *buff, const struct path * pp)
>  {
> -	return snprint_int(buff, len, pp ? pp->priority : -1);
> +	return snprint_int(buff, pp ? pp->priority : -1);
>  }
>  
>  static int
> -snprint_pg_selector (char * buff, size_t len, const struct pathgroup * pgp)
> +snprint_pg_selector (struct strbuf *buff, const struct pathgroup * pgp)
>  {
>  	const char *s = pgp->mpp->selector;
>  
> -	return snprint_str(buff, len, s ? s : "");
> +	return snprint_str(buff, s ? s : "");
>  }
>  
>  static int
> -snprint_pg_pri (char * buff, size_t len, const struct pathgroup * pgp)
> +snprint_pg_pri (struct strbuf *buff, const struct pathgroup * pgp)
>  {
> -	return snprint_int(buff, len, pgp->priority);
> +	return snprint_int(buff, pgp->priority);
>  }
>  
>  static int
> -snprint_pg_state (char * buff, size_t len, const struct pathgroup * pgp)
> +snprint_pg_state (struct strbuf *buff, const struct pathgroup * pgp)
>  {
>  	switch (pgp->status) {
>  	case PGSTATE_ENABLED:
> -		return snprintf(buff, len, "enabled");
> +		return append_strbuf_str(buff, "enabled");
>  	case PGSTATE_DISABLED:
> -		return snprintf(buff, len, "disabled");
> +		return append_strbuf_str(buff, "disabled");
>  	case PGSTATE_ACTIVE:
> -		return snprintf(buff, len, "active");
> +		return append_strbuf_str(buff, "active");
>  	default:
> -		return snprintf(buff, len, "undef");
> +		return append_strbuf_str(buff, "undef");
>  	}
>  }
>  
>  static int
> -snprint_pg_marginal (char * buff, size_t len, const struct pathgroup * pgp)
> +snprint_pg_marginal (struct strbuf *buff, const struct pathgroup * pgp)
>  {
>  	if (pgp->marginal)
> -		return snprintf(buff, len, "marginal");
> -	return snprintf(buff, len, "normal");
> +		return append_strbuf_str(buff, "marginal");
> +	return append_strbuf_str(buff, "normal");
>  }
>  
>  static int
> -snprint_path_size (char * buff, size_t len, const struct path * pp)
> +snprint_path_size (struct strbuf *buff, const struct path * pp)
>  {
> -	return snprint_size(buff, len, pp->size);
> +	return snprint_size(buff, pp->size);
>  }
>  
>  int
> -snprint_path_serial (char * buff, size_t len, const struct path * pp)
> +snprint_path_serial (struct strbuf *buff, const struct path * pp)
>  {
> -	return snprint_str(buff, len, pp->serial);
> +	return snprint_str(buff, pp->serial);
>  }
>  
>  static int
> -snprint_path_mpp (char * buff, size_t len, const struct path * pp)
> +snprint_path_mpp (struct strbuf *buff, const struct path * pp)
>  {
>  	if (!pp->mpp)
> -		return snprintf(buff, len, "[orphan]");
> +		return append_strbuf_str(buff, "[orphan]");
>  	if (!pp->mpp->alias)
> -		return snprintf(buff, len, "[unknown]");
> -	return snprint_str(buff, len, pp->mpp->alias);
> +		return append_strbuf_str(buff, "[unknown]");
> +	return snprint_str(buff, pp->mpp->alias);
>  }
>  
>  static int
> -snprint_host_attr (char * buff, size_t len, const struct path * pp, char *attr)
> +snprint_host_attr (struct strbuf *buff, const struct path * pp, char *attr)
>  {
>  	struct udev_device *host_dev = NULL;
>  	char host_id[32];
> @@ -560,7 +526,7 @@ snprint_host_attr (char * buff, size_t len, const struct path * pp, char *attr)
>  	int ret;
>  
>  	if (pp->sg_id.proto_id != SCSI_PROTOCOL_FCP)
> -		return snprintf(buff, len, "[undef]");
> +		return append_strbuf_str(buff, "[undef]");
>  	sprintf(host_id, "host%d", pp->sg_id.host_no);
>  	host_dev = udev_device_new_from_subsystem_sysname(udev, "fc_host",
>  							  host_id);
> @@ -570,28 +536,28 @@ snprint_host_attr (char * buff, size_t len, const struct path * pp, char *attr)
>  	}
>  	value = udev_device_get_sysattr_value(host_dev, attr);
>  	if (value)
> -		ret = snprint_str(buff, len, value);
> +		ret = snprint_str(buff, value);
>  	udev_device_unref(host_dev);
>  out:
>  	if (!value)
> -		ret = snprintf(buff, len, "[unknown]");
> +		ret = append_strbuf_str(buff, "[unknown]");
>  	return ret;
>  }
>  
>  int
> -snprint_host_wwnn (char * buff, size_t len, const struct path * pp)
> +snprint_host_wwnn (struct strbuf *buff, const struct path * pp)
>  {
> -	return snprint_host_attr(buff, len, pp, "node_name");
> +	return snprint_host_attr(buff, pp, "node_name");
>  }
>  
>  int
> -snprint_host_wwpn (char * buff, size_t len, const struct path * pp)
> +snprint_host_wwpn (struct strbuf *buff, const struct path * pp)
>  {
> -	return snprint_host_attr(buff, len, pp, "port_name");
> +	return snprint_host_attr(buff, pp, "port_name");
>  }
>  
>  int
> -snprint_tgt_wwpn (char * buff, size_t len, const struct path * pp)
> +snprint_tgt_wwpn (struct strbuf *buff, const struct path * pp)
>  {
>  	struct udev_device *rport_dev = NULL;
>  	char rport_id[42];
> @@ -599,7 +565,7 @@ snprint_tgt_wwpn (char * buff, size_t len, const struct path * pp)
>  	int ret;
>  
>  	if (pp->sg_id.proto_id != SCSI_PROTOCOL_FCP)
> -		return snprintf(buff, len, "[undef]");
> +		return append_strbuf_str(buff, "[undef]");
>  	sprintf(rport_id, "rport-%d:%d-%d",
>  		pp->sg_id.host_no, pp->sg_id.channel, pp->sg_id.transport_id);
>  	rport_dev = udev_device_new_from_subsystem_sysname(udev,
> @@ -611,111 +577,111 @@ snprint_tgt_wwpn (char * buff, size_t len, const struct path * pp)
>  	}
>  	value = udev_device_get_sysattr_value(rport_dev, "port_name");
>  	if (value)
> -		ret = snprint_str(buff, len, value);
> +		ret = snprint_str(buff, value);
>  	udev_device_unref(rport_dev);
>  out:
>  	if (!value)
> -		ret = snprintf(buff, len, "[unknown]");
> +		ret = append_strbuf_str(buff, "[unknown]");
>  	return ret;
>  }
>  
>  
>  int
> -snprint_tgt_wwnn (char * buff, size_t len, const struct path * pp)
> +snprint_tgt_wwnn (struct strbuf *buff, const struct path * pp)
>  {
>  	if (pp->tgt_node_name[0] == '\0')
> -		return snprintf(buff, len, "[undef]");
> -	return snprint_str(buff, len, pp->tgt_node_name);
> +		return append_strbuf_str(buff, "[undef]");
> +	return snprint_str(buff, pp->tgt_node_name);
>  }
>  
>  static int
> -snprint_host_adapter (char * buff, size_t len, const struct path * pp)
> +snprint_host_adapter (struct strbuf *buff, const struct path * pp)
>  {
>  	char adapter[SLOT_NAME_SIZE];
>  
>  	if (sysfs_get_host_adapter_name(pp, adapter))
> -		return snprintf(buff, len, "[undef]");
> -	return snprint_str(buff, len, adapter);
> +		return append_strbuf_str(buff, "[undef]");
> +	return snprint_str(buff, adapter);
>  }
>  
>  static int
> -snprint_path_checker (char * buff, size_t len, const struct path * pp)
> +snprint_path_checker (struct strbuf *buff, const struct path * pp)
>  {
>  	const struct checker * c = &pp->checker;
> -	return snprint_str(buff, len, checker_name(c));
> +	return snprint_str(buff, checker_name(c));
>  }
>  
>  static int
> -snprint_path_foreign (char * buff, size_t len,
> +snprint_path_foreign (struct strbuf *buff,
>  		      __attribute__((unused)) const struct path * pp)
>  {
> -	return snprintf(buff, len, "%s", "--");
> +	return append_strbuf_str(buff, "--");
>  }
>  
>  static int
> -snprint_path_failures(char * buff, size_t len, const struct path * pp)
> +snprint_path_failures(struct strbuf *buff, const struct path * pp)
>  {
> -	return snprint_int(buff, len, pp->failcount);
> +	return snprint_int(buff, pp->failcount);
>  }
>  
>  /* if you add a protocol string bigger than "scsi:unspec" you must
>   * also change PROTOCOL_BUF_SIZE */
>  int
> -snprint_path_protocol(char * buff, size_t len, const struct path * pp)
> +snprint_path_protocol(struct strbuf *buff, const struct path * pp)
>  {
>  	switch (pp->bus) {
>  	case SYSFS_BUS_SCSI:
>  		switch (pp->sg_id.proto_id) {
>  		case SCSI_PROTOCOL_FCP:
> -			return snprintf(buff, len, "scsi:fcp");
> +			return append_strbuf_str(buff, "scsi:fcp");
>  		case SCSI_PROTOCOL_SPI:
> -			return snprintf(buff, len, "scsi:spi");
> +			return append_strbuf_str(buff, "scsi:spi");
>  		case SCSI_PROTOCOL_SSA:
> -			return snprintf(buff, len, "scsi:ssa");
> +			return append_strbuf_str(buff, "scsi:ssa");
>  		case SCSI_PROTOCOL_SBP:
> -			return snprintf(buff, len, "scsi:sbp");
> +			return append_strbuf_str(buff, "scsi:sbp");
>  		case SCSI_PROTOCOL_SRP:
> -			return snprintf(buff, len, "scsi:srp");
> +			return append_strbuf_str(buff, "scsi:srp");
>  		case SCSI_PROTOCOL_ISCSI:
> -			return snprintf(buff, len, "scsi:iscsi");
> +			return append_strbuf_str(buff, "scsi:iscsi");
>  		case SCSI_PROTOCOL_SAS:
> -			return snprintf(buff, len, "scsi:sas");
> +			return append_strbuf_str(buff, "scsi:sas");
>  		case SCSI_PROTOCOL_ADT:
> -			return snprintf(buff, len, "scsi:adt");
> +			return append_strbuf_str(buff, "scsi:adt");
>  		case SCSI_PROTOCOL_ATA:
> -			return snprintf(buff, len, "scsi:ata");
> +			return append_strbuf_str(buff, "scsi:ata");
>  		case SCSI_PROTOCOL_USB:
> -			return snprintf(buff, len, "scsi:usb");
> +			return append_strbuf_str(buff, "scsi:usb");
>  		case SCSI_PROTOCOL_UNSPEC:
>  		default:
> -			return snprintf(buff, len, "scsi:unspec");
> +			return append_strbuf_str(buff, "scsi:unspec");
>  		}
>  	case SYSFS_BUS_CCW:
> -		return snprintf(buff, len, "ccw");
> +		return append_strbuf_str(buff, "ccw");
>  	case SYSFS_BUS_CCISS:
> -		return snprintf(buff, len, "cciss");
> +		return append_strbuf_str(buff, "cciss");
>  	case SYSFS_BUS_NVME:
> -		return snprintf(buff, len, "nvme");
> +		return append_strbuf_str(buff, "nvme");
>  	case SYSFS_BUS_UNDEF:
>  	default:
> -		return snprintf(buff, len, "undef");
> +		return append_strbuf_str(buff, "undef");
>  	}
>  }
>  
>  int
> -snprint_path_marginal(char * buff, size_t len, const struct path * pp)
> +snprint_path_marginal(struct strbuf *buff, const struct path * pp)
>  {
>  	if (pp->marginal)
> -		return snprintf(buff, len, "marginal");
> -	return snprintf(buff, len, "normal");
> +		return append_strbuf_str(buff, "marginal");
> +	return append_strbuf_str(buff, "normal");
>  }
>  
>  static int
> -snprint_path_vpd_data(char * buff, size_t len, const struct path * pp)
> +snprint_path_vpd_data(struct strbuf *buff, const struct path * pp)
>  {
>  	if (pp->vpd_data)
> -		return snprintf(buff, len, "%s", pp->vpd_data);
> -	return snprintf(buff, len, "[undef]");
> +		return append_strbuf_str(buff, pp->vpd_data);
> +	return append_strbuf_str(buff, "[undef]");
>  }
>  
>  struct multipath_data mpd[] = {
> @@ -782,24 +748,33 @@ struct pathgroup_data pgd[] = {
>  	{0, NULL, 0 , NULL}
>  };
>  
> -int
> -snprint_wildcards (char * buff, int len)
> +int snprint_wildcards(struct strbuf *buff)
>  {
> -	int i, fwd = 0;
> +	int initial_len = get_strbuf_len(buff);
> +	int i, rc;
>  
> -	fwd += snprintf(buff + fwd, len - fwd, "multipath format wildcards:\n");
> +	if ((rc = append_strbuf_str(buff, "multipath format wildcards:\n")) < 0)
> +		return rc;
>  	for (i = 0; mpd[i].header; i++)
> -		fwd += snprintf(buff + fwd, len - fwd, "%%%c  %s\n",
> -				mpd[i].wildcard, mpd[i].header);
> -	fwd += snprintf(buff + fwd, len - fwd, "\npath format wildcards:\n");
> +		if ((rc = print_strbuf(buff, "%%%c  %s\n",
> +				       mpd[i].wildcard, mpd[i].header)) < 0)
> +			return rc;
> +
> +	if ((rc = append_strbuf_str(buff, "\npath format wildcards:\n")) < 0)
> +		return rc;
>  	for (i = 0; pd[i].header; i++)
> -		fwd += snprintf(buff + fwd, len - fwd, "%%%c  %s\n",
> -				pd[i].wildcard, pd[i].header);
> -	fwd += snprintf(buff + fwd, len - fwd, "\npathgroup format wildcards:\n");
> +		if ((rc = print_strbuf(buff, "%%%c  %s\n",
> +				       pd[i].wildcard, pd[i].header)) < 0)
> +			return rc;
> +
> +	if ((rc = append_strbuf_str(buff, "\npathgroup format wildcards:\n")) < 0)
> +		return rc;
>  	for (i = 0; pgd[i].header; i++)
> -		fwd += snprintf(buff + fwd, len - fwd, "%%%c  %s\n",
> -				pgd[i].wildcard, pgd[i].header);
> -	return fwd;
> +		if ((rc = print_strbuf(buff, "%%%c  %s\n",
> +				       pgd[i].wildcard, pgd[i].header)) < 0)
> +			return rc;
> +
> +	return get_strbuf_len(buff) - initial_len;
>  }
>  
>  void
> @@ -832,10 +807,10 @@ void
>  _get_path_layout (const struct _vector *gpvec, enum layout_reset reset)
>  {
>  	int i, j;
> -	char buff[MAX_FIELD_LEN];
>  	const struct gen_path *gp;
>  
>  	for (j = 0; pd[j].header; j++) {
> +		STRBUF_ON_STACK(buff);
>  
>  		reset_width(&pd[j].width, reset, pd[j].header);
>  
> @@ -843,9 +818,9 @@ _get_path_layout (const struct _vector *gpvec, enum layout_reset reset)
>  			continue;
>  
>  		vector_foreach_slot (gpvec, gp, i) {
> -			gp->ops->snprint(gp, buff, MAX_FIELD_LEN,
> -					 pd[j].wildcard);
> -			pd[j].width = MAX(pd[j].width, strlen(buff));
> +			gp->ops->snprint(gp, &buff, pd[j].wildcard);
> +			pd[j].width = MAX(pd[j].width, get_strbuf_len(&buff));
> +			truncate_strbuf(&buff, 0);
>  		}
>  	}
>  }
> @@ -873,10 +848,10 @@ _get_multipath_layout (const struct _vector *gmvec,
>  			    enum layout_reset reset)
>  {
>  	int i, j;
> -	char buff[MAX_FIELD_LEN];
>  	const struct gen_multipath * gm;
>  
>  	for (j = 0; mpd[j].header; j++) {
> +		STRBUF_ON_STACK(buff);
>  
>  		reset_width(&mpd[j].width, reset, mpd[j].header);
>  
> @@ -884,9 +859,9 @@ _get_multipath_layout (const struct _vector *gmvec,
>  			continue;
>  
>  		vector_foreach_slot (gmvec, gm, i) {
> -			gm->ops->snprint(gm, buff, MAX_FIELD_LEN,
> -					 mpd[j].wildcard);
> -			mpd[j].width = MAX(mpd[j].width, strlen(buff));
> +			gm->ops->snprint(gm, &buff, mpd[j].wildcard);
> +			mpd[j].width = MAX(mpd[j].width, get_strbuf_len(&buff));
> +			truncate_strbuf(&buff, 0);
>  		}
>  		condlog(4, "%s: width %d", mpd[j].header, mpd[j].width);
>  	}
> @@ -905,14 +880,14 @@ mpd_lookup(char wildcard)
>  }
>  
>  int snprint_multipath_attr(const struct gen_multipath* gm,
> -			   char *buf, int len, char wildcard)
> +			   struct strbuf *buf, char wildcard)
>  {
>  	const struct multipath *mpp = gen_multipath_to_dm(gm);
>  	struct multipath_data *mpd = mpd_lookup(wildcard);
>  
>  	if (mpd == NULL)
>  		return 0;
> -	return mpd->snprint(buf, len, mpp);
> +	return mpd->snprint(buf, mpp);
>  }
>  
>  static struct path_data *
> @@ -928,14 +903,14 @@ pd_lookup(char wildcard)
>  }
>  
>  int snprint_path_attr(const struct gen_path* gp,
> -		      char *buf, int len, char wildcard)
> +		      struct strbuf *buf, char wildcard)
>  {
>  	const struct path *pp = gen_path_to_dm(gp);
>  	struct path_data *pd = pd_lookup(wildcard);
>  
>  	if (pd == NULL)
>  		return 0;
> -	return pd->snprint(buf, len, pp);
> +	return pd->snprint(buf, pp);
>  }
>  
>  static struct pathgroup_data *
> @@ -951,220 +926,168 @@ pgd_lookup(char wildcard)
>  }
>  
>  int snprint_pathgroup_attr(const struct gen_pathgroup* gpg,
> -			   char *buf, int len, char wildcard)
> +			   struct strbuf *buf, char wildcard)
>  {
>  	const struct pathgroup *pg = gen_pathgroup_to_dm(gpg);
>  	struct pathgroup_data *pdg = pgd_lookup(wildcard);
>  
>  	if (pdg == NULL)
>  		return 0;
> -	return pdg->snprint(buf, len, pg);
> +	return pdg->snprint(buf, pg);
>  }
>  
> -int
> -snprint_multipath_header (char * line, int len, const char * format)
> +int snprint_multipath_header(struct strbuf *line, const char *format)
>  {
> -	char * c = line;   /* line cursor */
> -	char * s = line;   /* for padding */
> -	const char * f = format; /* format string cursor */
> -	int fwd;
> +	int initial_len = get_strbuf_len(line);
> +	const char *f;
>  	struct multipath_data * data;
> +	int rc;
>  
> -	do {
> -		if (TAIL <= 0)
> -			break;
> +	for (f = strchr(format, '%'); f; f = strchr(++format, '%')) {
> +		if ((rc = __append_strbuf_str(line, format, f - format)) < 0)
> +			return rc;
>  
> -		if (*f != '%') {
> -			*c++ = *f;
> -			NOPAD;
> -			continue;
> -		}
> -		f++;
> -
> -		if (!(data = mpd_lookup(*f)))
> +		format = f + 1;
> +		if (!(data = mpd_lookup(*format)))
>  			continue; /* unknown wildcard */
>  
> -		PRINT(c, TAIL, "%s", data->header);
> -		PAD(data->width);
> -	} while (*f++);
> +		if ((rc = append_strbuf_str(line, data->header)) < 0)
> +			return rc;
> +		else if ((unsigned int)rc < data->width)
> +			if ((rc = fill_strbuf(line, ' ', data->width - rc)) < 0)
> +				return rc;
> +	}
>  
> -	__endline(line, len, c);
> -	return (c - line);
> +	if ((rc = print_strbuf(line, "%s\n", format)) < 0)
> +		return rc;
> +	return get_strbuf_len(line) - initial_len;
>  }
>  
> -int
> -_snprint_multipath (const struct gen_multipath * gmp,
> -		    char * line, int len, const char * format, int pad)
> +int _snprint_multipath(const struct gen_multipath *gmp,
> +		       struct strbuf *line, const char *format, int pad)
>  {
> -	char * c = line;   /* line cursor */
> -	char * s = line;   /* for padding */
> -	const char * f = format; /* format string cursor */
> -	int fwd;
> +	int initial_len = get_strbuf_len(line);
> +	const char *f;
>  	struct multipath_data * data;
> -	char buff[MAX_FIELD_LEN] = {};
> +	int rc;
>  
> -	do {
> -		if (TAIL <= 0)
> -			break;
> +	for (f = strchr(format, '%'); f; f = strchr(++format, '%')) {
> +		if ((rc = __append_strbuf_str(line, format, f - format)) < 0)
> +			return rc;
>  
> -		if (*f != '%') {
> -			*c++ = *f;
> -			NOPAD;
> -			continue;
> -		}
> -		f++;
> -
> -		if (!(data = mpd_lookup(*f)))
> -			continue;
> +		format = f + 1;
> +		if (!(data = mpd_lookup(*format)))
> +			continue; /* unknown wildcard */
>  
> -		gmp->ops->snprint(gmp, buff, MAX_FIELD_LEN, *f);
> -		PRINT(c, TAIL, "%s", buff);
> -		if (pad)
> -			PAD(data->width);
> -		buff[0] = '\0';
> -	} while (*f++);
> +		if ((rc = gmp->ops->snprint(gmp, line, *format)) < 0)
> +			return rc;
> +		else if (pad && (unsigned int)rc < data->width)
> +			if ((rc = fill_strbuf(line, ' ', data->width - rc)) < 0)
> +				return rc;
> +	}
>  
> -	__endline(line, len, c);
> -	return (c - line);
> +	if ((rc = print_strbuf(line, "%s\n", format)) < 0)
> +		return rc;
> +	return get_strbuf_len(line) - initial_len;
>  }
>  
> -int
> -snprint_path_header (char * line, int len, const char * format)
> +int snprint_path_header(struct strbuf *line, const char *format)
>  {
> -	char * c = line;   /* line cursor */
> -	char * s = line;   /* for padding */
> -	const char * f = format; /* format string cursor */
> -	int fwd;
> -	struct path_data * data;
> -
> -	do {
> -		if (TAIL <= 0)
> -			break;
> +	int initial_len = get_strbuf_len(line);
> +	const char *f;
> +	struct path_data *data;
> +	int rc;
>  
> -		if (*f != '%') {
> -			*c++ = *f;
> -			NOPAD;
> -			continue;
> -		}
> -		f++;
> +	for (f = strchr(format, '%'); f; f = strchr(++format, '%')) {
> +		if ((rc = __append_strbuf_str(line, format, f - format)) < 0)
> +			return rc;
>  
> -		if (!(data = pd_lookup(*f)))
> +		format = f + 1;
> +		if (!(data = pd_lookup(*format)))
>  			continue; /* unknown wildcard */
>  
> -		PRINT(c, TAIL, "%s", data->header);
> -		PAD(data->width);
> -	} while (*f++);
> +		if ((rc = append_strbuf_str(line, data->header)) < 0)
> +			return rc;
> +		else if ((unsigned int)rc < data->width)
> +			if ((rc = fill_strbuf(line, ' ', data->width - rc)) < 0)
> +				return rc;
> +	}
>  
> -	__endline(line, len, c);
> -	return (c - line);
> +	if ((rc = print_strbuf(line, "%s\n", format)) < 0)
> +		return rc;
> +	return get_strbuf_len(line) - initial_len;
>  }
>  
> -int
> -_snprint_path (const struct gen_path * gp, char * line, int len,
> -	       const char * format, int pad)
> +int _snprint_path(const struct gen_path *gp, struct strbuf *line,
> +		  const char *format, int pad)
>  {
> -	char * c = line;   /* line cursor */
> -	char * s = line;   /* for padding */
> -	const char * f = format; /* format string cursor */
> -	int fwd;
> +	int initial_len = get_strbuf_len(line);
> +	const char *f;
>  	struct path_data * data;
> -	char buff[MAX_FIELD_LEN];
> +	int rc;
>  
> -	do {
> -		if (TAIL <= 0)
> -			break;
> -
> -		if (*f != '%') {
> -			*c++ = *f;
> -			NOPAD;
> -			continue;
> -		}
> -		f++;
> +	for (f = strchr(format, '%'); f; f = strchr(++format, '%')) {
> +		if ((rc = __append_strbuf_str(line, format, f - format)) < 0)
> +			return rc;
>  
> -		if (!(data = pd_lookup(*f)))
> -			continue;
> +		format = f + 1;
> +		if (!(data = pd_lookup(*format)))
> +			continue; /* unknown wildcard */
>  
> -		gp->ops->snprint(gp, buff, MAX_FIELD_LEN, *f);
> -		PRINT(c, TAIL, "%s", buff);
> -		if (pad)
> -			PAD(data->width);
> -	} while (*f++);
> +		if ((rc = gp->ops->snprint(gp, line, *format)) < 0)
> +			return rc;
> +		else if (pad && (unsigned int)rc < data->width)
> +			if ((rc = fill_strbuf(line, ' ', data->width - rc)) < 0)
> +				return rc;
> +	}
>  
> -	__endline(line, len, c);
> -	return (c - line);
> +	if ((rc = print_strbuf(line, "%s\n", format)) < 0)
> +		return rc;
> +	return get_strbuf_len(line) - initial_len;
>  }
>  
> -int
> -_snprint_pathgroup (const struct gen_pathgroup * ggp, char * line, int len,
> -		    char * format)
> -{
> -	char * c = line;   /* line cursor */
> -	char * s = line;   /* for padding */
> -	char * f = format; /* format string cursor */
> -	int fwd;
> -	struct pathgroup_data * data;
> -	char buff[MAX_FIELD_LEN];
> -
> -	do {
> -		if (TAIL <= 0)
> -			break;
> +int _snprint_pathgroup(const struct gen_pathgroup *ggp, struct strbuf *line,
> +		       const char *format)
> +{
> +	int initial_len = get_strbuf_len(line);
> +	const char *f;
> +	struct pathgroup_data *data;
> +	int rc;
>  
> -		if (*f != '%') {
> -			*c++ = *f;
> -			NOPAD;
> -			continue;
> -		}
> -		f++;
> +	for (f = strchr(format, '%'); f; f = strchr(++format, '%')) {
> +		if ((rc = __append_strbuf_str(line, format, f - format)) < 0)
> +			return rc;
>  
> -		if (!(data = pgd_lookup(*f)))
> -			continue;
> +		format = f + 1;
> +		if (!(data = pgd_lookup(*format)))
> +			continue; /* unknown wildcard */
>  
> -		ggp->ops->snprint(ggp, buff, MAX_FIELD_LEN, *f);
> -		PRINT(c, TAIL, "%s", buff);
> -		PAD(data->width);
> -	} while (*f++);
> +		if ((rc = ggp->ops->snprint(ggp, line, *format)) < 0)
> +			return rc;
> +		else if ((unsigned int)rc < data->width)
> +			if ((rc = fill_strbuf(line, ' ', data->width - rc)) < 0)
> +				return rc;
> +	}
>  
> -	__endline(line, len, c);
> -	return (c - line);
> +	if ((rc = print_strbuf(line, "%s\n", format)) < 0)
> +		return rc;
> +	return get_strbuf_len(line) - initial_len;
>  }
> -#define snprint_pathgroup(line, len, fmt, pgp) \
> -	_snprint_pathgroup(dm_pathgroup_to_gen(pgp), line, len, fmt)
> +
> +#define snprint_pathgroup(line, fmt, pgp)				\
> +	_snprint_pathgroup(dm_pathgroup_to_gen(pgp), line, fmt)
>  
>  void _print_multipath_topology(const struct gen_multipath *gmp, int verbosity)
>  {
> -	int resize;
> -	char *buff = NULL;
> -	char *old = NULL;
> -	int len, maxlen = MAX_LINE_LEN * MAX_LINES;
> -
> -	buff = MALLOC(maxlen);
> -	do {
> -		if (!buff) {
> -			if (old)
> -				FREE(old);
> -			condlog(0, "couldn't allocate memory for list: %s\n",
> -				strerror(errno));
> -			return;
> -		}
> +	STRBUF_ON_STACK(buff);
>  
> -		len = _snprint_multipath_topology(gmp, buff, maxlen, verbosity);
> -		resize = (len == maxlen - 1);
> -
> -		if (resize) {
> -			maxlen *= 2;
> -			old = buff;
> -			buff = REALLOC(buff, maxlen);
> -		}
> -	} while (resize);
> -	printf("%s", buff);
> -	FREE(buff);
> +	_snprint_multipath_topology(gmp, &buff, verbosity);
> +	printf("%s", get_strbuf_str(&buff));
>  }
>  
> -int
> -snprint_multipath_style(const struct gen_multipath *gmp, char *style, int len,
> -			int verbosity)
> +int snprint_multipath_style(const struct gen_multipath *gmp,
> +			    struct strbuf *style, int verbosity)
>  {
> -	int n;
>  	const struct multipath *mpp = gen_multipath_to_dm(gmp);
>  	bool need_action = (verbosity > 1 &&
>  			    mpp->action != ACT_NOTHING &&
> @@ -1172,268 +1095,203 @@ snprint_multipath_style(const struct gen_multipath *gmp, char *style, int len,
>  			    mpp->action != ACT_IMPOSSIBLE);
>  	bool need_wwid = (strncmp(mpp->alias, mpp->wwid, WWID_SIZE));
>  
> -	n = snprintf(style, len, "%s%s%s%s",
> -		     need_action ? "%A: " : "", "%n",
> -		     need_wwid ? " (%w)" : "", " %d %s");
> -	return MIN(n, len - 1);
> +	return print_strbuf(style, "%s%s%s%s",
> +			    need_action ? "%A: " : "", "%n",
> +			    need_wwid ? " (%w)" : "", " %d %s");
>  }
>  
>  int _snprint_multipath_topology(const struct gen_multipath *gmp,
> -				char *buff, int len, int verbosity)
> +				struct strbuf *buff, int verbosity)
>  {
> -	int j, i, fwd = 0;
> +	int j, i, rc;
>  	const struct _vector *pgvec;
>  	const struct gen_pathgroup *gpg;
> -	char style[64];
> -	char * c = style;
> -	char fmt[64];
> -	char * f;
> +	STRBUF_ON_STACK(style);
> +	size_t initial_len = get_strbuf_len(buff);
>  
>  	if (verbosity <= 0)
> -		return fwd;
> +		return 0;
>  
>  	reset_multipath_layout();
>  
>  	if (verbosity == 1)
> -		return _snprint_multipath(gmp, buff, len, "%n", 1);
> -
> -	if(isatty(1))
> -		c += sprintf(c, "%c[%dm", 0x1B, 1); /* bold on */
> +		return _snprint_multipath(gmp, buff, "%n", 1);
>  
> -	c += gmp->ops->style(gmp, c, sizeof(style) - (c - style),
> -			     verbosity);
> -	if(isatty(1))
> -		c += sprintf(c, "%c[%dm", 0x1B, 0); /* bold off */
> +	if(isatty(1) &&
> +	   (rc = print_strbuf(&style, "%c[%dm", 0x1B, 1)) < 0) /* bold on */
> +		return rc;
> +	if ((rc = gmp->ops->style(gmp, &style, verbosity)) < 0)
> +		return rc;
> +	if(isatty(1) &&
> +	   (rc = print_strbuf(&style, "%c[%dm", 0x1B, 0)) < 0) /* bold off */
> +		return rc;
>  
> -	fwd += _snprint_multipath(gmp, buff + fwd, len - fwd, style, 1);
> -	if (fwd >= len)
> -		return len;
> -	fwd += _snprint_multipath(gmp, buff + fwd, len - fwd,
> -				  PRINT_MAP_PROPS, 1);
> -	if (fwd >= len)
> -		return len;
> +	if ((rc = _snprint_multipath(gmp, buff, get_strbuf_str(&style), 1)) < 0
> +	    || (rc = _snprint_multipath(gmp, buff, PRINT_MAP_PROPS, 1)) < 0)
> +		return rc;
>  
>  	pgvec = gmp->ops->get_pathgroups(gmp);
>  	if (pgvec == NULL)
> -		return fwd;
> +		goto out;
>  
>  	vector_foreach_slot (pgvec, gpg, j) {
>  		const struct _vector *pathvec;
>  		struct gen_path *gp;
> +		bool last_group = j + 1 == VECTOR_SIZE(pgvec);
>  
> -		f=fmt;
> -
> -		if (j + 1 < VECTOR_SIZE(pgvec)) {
> -			strcpy(f, "|-+- " PRINT_PG_INDENT);
> -		} else
> -			strcpy(f, "`-+- " PRINT_PG_INDENT);
> -		fwd += _snprint_pathgroup(gpg, buff + fwd, len - fwd, fmt);
> -
> -		if (fwd >= len) {
> -			fwd = len;
> -			break;
> -		}
> +		if ((rc = print_strbuf(buff, "%c-+- ",
> +				       last_group ? '`' : '|')) < 0 ||
> +		    (rc = _snprint_pathgroup(gpg, buff, PRINT_PG_INDENT)) < 0)
> +			return rc;
>  
>  		pathvec = gpg->ops->get_paths(gpg);
>  		if (pathvec == NULL)
>  			continue;
>  
>  		vector_foreach_slot (pathvec, gp, i) {
> -			f=fmt;
> -			if (*f != '|')
> -				*f=' ';
> -			f++;
> -			if (i + 1 < VECTOR_SIZE(pathvec))
> -				strcpy(f, " |- " PRINT_PATH_INDENT);
> -			else
> -				strcpy(f, " `- " PRINT_PATH_INDENT);
> -			fwd += _snprint_path(gp, buff + fwd, len - fwd, fmt, 1);
> -			if (fwd >= len) {
> -				fwd = len;
> -				break;
> -			}
> +			if ((rc = print_strbuf(buff, "%c %c- ",
> +					       last_group ? ' ' : '|',
> +					       i + 1 == VECTOR_SIZE(pathvec) ?
> +					       '`': '|')) < 0 ||
> +			    (rc = _snprint_path(gp, buff,
> +						PRINT_PATH_INDENT, 1)) < 0)
> +				return rc;
>  		}
>  		gpg->ops->rel_paths(gpg, pathvec);
> -
> -		if (fwd == len)
> -			break;
>  	}
> +
>  	gmp->ops->rel_pathgroups(gmp, pgvec);
> -	return fwd;
> +out:
> +	return get_strbuf_len(buff) - initial_len;
>  }
>  
>  
>  static int
> -snprint_json (char * buff, int len, int indent, char *json_str)
> +snprint_json(struct strbuf *buff, int indent, const char *json_str)
>  {
> -	int fwd = 0, i;
> +	int rc;
>  
> -	for (i = 0; i < indent; i++) {
> -		fwd += snprintf(buff + fwd, len - fwd, PRINT_JSON_INDENT);
> -		if (fwd >= len)
> -			return fwd;
> -	}
> +	if ((rc = fill_strbuf(buff, ' ', indent * PRINT_JSON_INDENT_N)) < 0)
> +		return rc;
>  
> -	fwd += snprintf(buff + fwd, len - fwd, "%s", json_str);
> -	return fwd;
> +	return append_strbuf_str(buff, json_str);
>  }
>  
> -static int
> -snprint_json_header (char * buff, int len)
> +static int snprint_json_header(struct strbuf *buff)
>  {
> -	int fwd = 0;
> -
> -	fwd +=  snprint_json(buff, len, 0, PRINT_JSON_START_ELEM);
> -	if (fwd >= len)
> -		return fwd;
> +	int rc;
>  
> -	fwd +=  snprintf(buff + fwd, len  - fwd, PRINT_JSON_START_VERSION,
> -			PRINT_JSON_MAJOR_VERSION, PRINT_JSON_MINOR_VERSION);
> -	return fwd;
> +	if ((rc = snprint_json(buff, 0, PRINT_JSON_START_ELEM)) < 0)
> +		return rc;
> +	return print_strbuf(buff, PRINT_JSON_START_VERSION,
> +			    PRINT_JSON_MAJOR_VERSION, PRINT_JSON_MINOR_VERSION);
>  }
>  
> -static int
> -snprint_json_elem_footer (char * buff, int len, int indent, int last)
> +static int snprint_json_elem_footer(struct strbuf *buff, int indent, bool last)
>  {
> -	int fwd = 0, i;
> +	int rc;
>  
> -	for (i = 0; i < indent; i++) {
> -		fwd += snprintf(buff + fwd, len - fwd, PRINT_JSON_INDENT);
> -		if (fwd >= len)
> -			return fwd;
> -	}
> +	if ((rc = fill_strbuf(buff, ' ', indent * PRINT_JSON_INDENT_N)) < 0)
> +		return rc;
>  
> -	if (last == 1)
> -		fwd += snprintf(buff + fwd, len - fwd, "%s", PRINT_JSON_END_LAST_ELEM);
> +	if (last)
> +		return append_strbuf_str(buff, PRINT_JSON_END_LAST_ELEM);
>  	else
> -		fwd += snprintf(buff + fwd, len - fwd, "%s", PRINT_JSON_END_ELEM);
> -	return fwd;
> +		return append_strbuf_str(buff, PRINT_JSON_END_ELEM);
>  }
>  
> -static int
> -snprint_multipath_fields_json (char * buff, int len,
> -		const struct multipath * mpp, int last)
> +static int snprint_multipath_fields_json(struct strbuf *buff,
> +					 const struct multipath *mpp, int last)
>  {
> -	int i, j, fwd = 0;
> +	int i, j, rc;
>  	struct path *pp;
>  	struct pathgroup *pgp;
> +	size_t initial_len = get_strbuf_len(buff);
>  
> -	fwd += snprint_multipath(buff, len, PRINT_JSON_MAP, mpp, 0);
> -	if (fwd >= len)
> -		return fwd;
> -
> -	fwd += snprint_json(buff + fwd, len - fwd, 2, PRINT_JSON_START_GROUPS);
> -	if (fwd >= len)
> -		return fwd;
> +	if ((rc = snprint_multipath(buff, PRINT_JSON_MAP, mpp, 0)) < 0 ||
> +	    (rc = snprint_json(buff, 2, PRINT_JSON_START_GROUPS)) < 0)
> +		return rc;
>  
>  	vector_foreach_slot (mpp->pg, pgp, i) {
>  
> -		fwd += snprint_pathgroup(buff + fwd, len - fwd, PRINT_JSON_GROUP, pgp);
> -		if (fwd >= len)
> -			return fwd;
> -
> -		fwd += snprintf(buff + fwd, len - fwd, PRINT_JSON_GROUP_NUM, i + 1);
> -		if (fwd >= len)
> -			return fwd;
> -
> -		fwd += snprint_json(buff + fwd, len - fwd, 3, PRINT_JSON_START_PATHS);
> -		if (fwd >= len)
> -			return fwd;
> +		if ((rc = snprint_pathgroup(buff, PRINT_JSON_GROUP, pgp)) < 0 ||
> +		    (rc = print_strbuf(buff, PRINT_JSON_GROUP_NUM, i + 1)) < 0 ||
> +		    (rc = snprint_json(buff, 3, PRINT_JSON_START_PATHS)) < 0)
> +			return rc;
>  
>  		vector_foreach_slot (pgp->paths, pp, j) {
> -			fwd += snprint_path(buff + fwd, len - fwd, PRINT_JSON_PATH, pp, 0);
> -			if (fwd >= len)
> -				return fwd;
> -
> -			fwd += snprint_json_elem_footer(buff + fwd,
> -					len - fwd, 3, j + 1 == VECTOR_SIZE(pgp->paths));
> -			if (fwd >= len)
> -				return fwd;
> +			if ((rc = snprint_path(buff, PRINT_JSON_PATH,
> +					       pp, 0)) < 0 ||
> +			    (rc = snprint_json_elem_footer(
> +				    buff, 3,
> +				    j + 1 == VECTOR_SIZE(pgp->paths))) < 0)
> +				return rc;
>  		}
> -		fwd += snprint_json(buff + fwd, len - fwd, 0, PRINT_JSON_END_ARRAY);
> -		if (fwd >= len)
> -			return fwd;
> -
> -		fwd +=  snprint_json_elem_footer(buff + fwd,
> -				len - fwd, 2, i + 1 == VECTOR_SIZE(mpp->pg));
> -		if (fwd >= len)
> -			return fwd;
> +		if ((rc = snprint_json(buff, 0, PRINT_JSON_END_ARRAY)) < 0 ||
> +		    (rc = snprint_json_elem_footer(
> +			    buff, 2, i + 1 == VECTOR_SIZE(mpp->pg))) < 0)
> +			return rc;
>  	}
>  
> -	fwd += snprint_json(buff + fwd, len - fwd, 0, PRINT_JSON_END_ARRAY);
> -	if (fwd >= len)
> -		return fwd;
> +	if ((rc = snprint_json(buff, 0, PRINT_JSON_END_ARRAY)) < 0 ||
> +	    (rc = snprint_json_elem_footer(buff, 1, last)) < 0)
> +		return rc;
>  
> -	fwd += snprint_json_elem_footer(buff + fwd, len - fwd, 1, last);
> -	return fwd;
> +	return get_strbuf_len(buff) - initial_len;
>  }
>  
> -int
> -snprint_multipath_map_json (char * buff, int len, const struct multipath * mpp)
> +int snprint_multipath_map_json(struct strbuf *buff, const struct multipath * mpp)
>  {
> -	int fwd = 0;
> -
> -	fwd +=  snprint_json_header(buff, len);
> -	if (fwd >= len)
> -		return len;
> +	size_t initial_len = get_strbuf_len(buff);
> +	int rc;
>  
> -	fwd +=  snprint_json(buff + fwd, len - fwd, 0, PRINT_JSON_START_MAP);
> -	if (fwd >= len)
> -		return len;
> +	if ((rc = snprint_json_header(buff)) < 0 ||
> +	    (rc = snprint_json(buff, 0, PRINT_JSON_START_MAP)) < 0)
> +		return rc;
>  
> -	fwd += snprint_multipath_fields_json(buff + fwd, len - fwd, mpp, 1);
> -	if (fwd >= len)
> -		return len;
> +	if ((rc = snprint_multipath_fields_json(buff, mpp, 1)) < 0)
> +		return rc;
>  
> -	fwd +=  snprint_json(buff + fwd, len - fwd, 0, "\n");
> -	if (fwd >= len)
> -		return len;
> +	if ((rc = snprint_json(buff, 0, "\n")) < 0 ||
> +	    (rc = snprint_json(buff, 0, PRINT_JSON_END_LAST)) < 0)
> +		return rc;
>  
> -	fwd +=  snprint_json(buff + fwd, len - fwd, 0, PRINT_JSON_END_LAST);
> -	if (fwd >= len)
> -		return len;
> -	return fwd;
> +	return get_strbuf_len(buff) - initial_len;
>  }
>  
> -int
> -snprint_multipath_topology_json (char * buff, int len, const struct vectors * vecs)
> +int snprint_multipath_topology_json (struct strbuf *buff,
> +				     const struct vectors * vecs)
>  {
> -	int i, fwd = 0;
> +	int i;
>  	struct multipath * mpp;
> +	size_t initial_len = get_strbuf_len(buff);
> +	int rc;
>  
> -	fwd +=  snprint_json_header(buff, len);
> -	if (fwd >= len)
> -		return len;
> -
> -	fwd +=  snprint_json(buff + fwd, len  - fwd, 1, PRINT_JSON_START_MAPS);
> -	if (fwd >= len)
> -		return len;
> +	if ((rc = snprint_json_header(buff)) < 0 ||
> +	    (rc = snprint_json(buff, 1, PRINT_JSON_START_MAPS)) < 0)
> +		return rc;
>  
>  	vector_foreach_slot(vecs->mpvec, mpp, i) {
> -		fwd += snprint_multipath_fields_json(buff + fwd, len - fwd,
> -				mpp, i + 1 == VECTOR_SIZE(vecs->mpvec));
> -		if (fwd >= len)
> -			return len;
> +		if ((rc = snprint_multipath_fields_json(
> +			     buff, mpp, i + 1 == VECTOR_SIZE(vecs->mpvec))) < 0)
> +			return rc;
>  	}
>  
> -	fwd +=  snprint_json(buff + fwd, len - fwd, 0, PRINT_JSON_END_ARRAY);
> -	if (fwd >= len)
> -		return len;
> +	if ((rc = snprint_json(buff, 0, PRINT_JSON_END_ARRAY)) < 0 ||
> +	    (rc = snprint_json(buff, 0, PRINT_JSON_END_LAST)) < 0)
> +		return rc;
>  
> -	fwd +=  snprint_json(buff + fwd, len - fwd, 0, PRINT_JSON_END_LAST);
> -	if (fwd >= len)
> -		return len;
> -	return fwd;
> +	return get_strbuf_len(buff) - initial_len;
>  }
>  
>  static int
>  snprint_hwentry (const struct config *conf,
> -		 char * buff, int len, const struct hwentry * hwe)
> +		 struct strbuf *buff, const struct hwentry * hwe)
>  {
> -	int i;
> -	int fwd = 0;
> +	int i, rc;
>  	struct keyword * kw;
>  	struct keyword * rootkw;
> +	size_t initial_len = get_strbuf_len(buff);
>  
>  	rootkw = find_keyword(conf->keywords, NULL, "devices");
>  
> @@ -1445,57 +1303,53 @@ snprint_hwentry (const struct config *conf,
>  	if (!rootkw)
>  		return 0;
>  
> -	fwd += snprintf(buff + fwd, len - fwd, "\tdevice {\n");
> -	if (fwd >= len)
> -		return len;
> +	if ((rc = append_strbuf_str(buff, "\tdevice {\n")) < 0)
> +		return rc;
> +
>  	iterate_sub_keywords(rootkw, kw, i) {
> -		fwd += snprint_keyword(buff + fwd, len - fwd, "\t\t%k %v\n",
> -				kw, hwe);
> -		if (fwd >= len)
> -			return len;
> +		if ((rc = snprint_keyword(buff, "\t\t%k %v\n", kw, hwe)) < 0)
> +			return rc;
>  	}
> -	fwd += snprintf(buff + fwd, len - fwd, "\t}\n");
> -	if (fwd >= len)
> -		return len;
> -	return fwd;
> +	if ((rc = append_strbuf_str(buff, "\t}\n")) < 0)
> +		return rc;
> +	return get_strbuf_len(buff) - initial_len;
>  }
>  
> -static int snprint_hwtable(const struct config *conf,
> -			   char *buff, int len,
> +static int snprint_hwtable(const struct config *conf, struct strbuf *buff,
>  			   const struct _vector *hwtable)
>  {
> -	int fwd = 0;
> -	int i;
> +	int i, rc;
>  	struct hwentry * hwe;
>  	struct keyword * rootkw;
> +	size_t initial_len = get_strbuf_len(buff);
>  
>  	rootkw = find_keyword(conf->keywords, NULL, "devices");
>  	if (!rootkw)
>  		return 0;
>  
> -	fwd += snprintf(buff + fwd, len - fwd, "devices {\n");
> -	if (fwd >= len)
> -		return len;
> +	if ((rc = append_strbuf_str(buff, "devices {\n")) < 0)
> +		return rc;
> +
>  	vector_foreach_slot (hwtable, hwe, i) {
> -		fwd += snprint_hwentry(conf, buff + fwd, len - fwd, hwe);
> -		if (fwd >= len)
> -			return len;
> +		if ((rc = snprint_hwentry(conf, buff, hwe)) < 0)
> +			return rc;
>  	}
> -	fwd += snprintf(buff + fwd, len - fwd, "}\n");
> -	if (fwd >= len)
> -		return len;
> -	return fwd;
> +
> +	if ((rc = append_strbuf_str(buff, "}\n")) < 0)
> +		return rc;
> +
> +	return get_strbuf_len(buff) - initial_len;
>  }
>  
>  static int
> -snprint_mpentry (const struct config *conf, char * buff, int len,
> +snprint_mpentry (const struct config *conf, struct strbuf *buff,
>  		 const struct mpentry * mpe, const struct _vector *mpvec)
>  {
> -	int i;
> -	int fwd = 0;
> +	int i, rc;
>  	struct keyword * kw;
>  	struct keyword * rootkw;
>  	struct multipath *mpp = NULL;
> +	size_t initial_len = get_strbuf_len(buff);
>  
>  	if (mpvec != NULL && (mpp = find_mp_by_wwid(mpvec, mpe->wwid)) == NULL)
>  		return 0;
> @@ -1504,49 +1358,44 @@ snprint_mpentry (const struct config *conf, char * buff, int len,
>  	if (!rootkw)
>  		return 0;
>  
> -	fwd += snprintf(buff + fwd, len - fwd, "\tmultipath {\n");
> -	if (fwd >= len)
> -		return len;
> +	if ((rc = append_strbuf_str(buff, "\tmultipath {\n")) < 0)
> +		return rc;
> +
>  	iterate_sub_keywords(rootkw, kw, i) {
> -		fwd += snprint_keyword(buff + fwd, len - fwd, "\t\t%k %v\n",
> -				kw, mpe);
> -		if (fwd >= len)
> -			return len;
> +		if ((rc = snprint_keyword(buff, "\t\t%k %v\n", kw, mpe)) < 0)
> +			return rc;
>  	}
>  	/*
>  	 * This mpp doesn't have alias defined. Add the alias in a comment.
>  	 */
> -	if (mpp != NULL && strcmp(mpp->alias, mpp->wwid)) {
> -		fwd += snprintf(buff + fwd, len - fwd, "\t\t# alias \"%s\"\n",
> -				mpp->alias);
> -		if (fwd >= len)
> -			return len;
> -	}
> -	fwd += snprintf(buff + fwd, len - fwd, "\t}\n");
> -	if (fwd >= len)
> -		return len;
> -	return fwd;
> +	if (mpp != NULL && strcmp(mpp->alias, mpp->wwid) &&
> +	    (rc = print_strbuf(buff, "\t\t# alias \"%s\"\n", mpp->alias)) < 0)
> +		return rc;
> +
> +	if ((rc = append_strbuf_str(buff, "\t}\n")) < 0)
> +		return rc;
> +
> +	return get_strbuf_len(buff) - initial_len;
>  }
>  
> -static int snprint_mptable(const struct config *conf,
> -			   char *buff, int len, const struct _vector *mpvec)
> +static int snprint_mptable(const struct config *conf, struct strbuf *buff,
> +			   const struct _vector *mpvec)
>  {
> -	int fwd = 0;
> -	int i;
> +	int i, rc;
>  	struct mpentry * mpe;
>  	struct keyword * rootkw;
> +	size_t initial_len = get_strbuf_len(buff);
>  
>  	rootkw = find_keyword(conf->keywords, NULL, "multipaths");
>  	if (!rootkw)
>  		return 0;
>  
> -	fwd += snprintf(buff + fwd, len - fwd, "multipaths {\n");
> -	if (fwd >= len)
> -		return len;
> +	if ((rc = append_strbuf_str(buff, "multipaths {\n")) < 0)
> +		return rc;
> +
>  	vector_foreach_slot (conf->mptable, mpe, i) {
> -		fwd += snprint_mpentry(conf, buff + fwd, len - fwd, mpe, mpvec);
> -		if (fwd >= len)
> -			return len;
> +		if ((rc = snprint_mpentry(conf, buff, mpe, mpvec)) < 0)
> +			return rc;
>  	}
>  	if (mpvec != NULL) {
>  		struct multipath *mpp;
> @@ -1555,496 +1404,397 @@ static int snprint_mptable(const struct config *conf,
>  			if (find_mpe(conf->mptable, mpp->wwid) != NULL)
>  				continue;
>  
> -			fwd += snprintf(buff + fwd, len - fwd,
> -					"\tmultipath {\n");
> -			if (fwd >= len)
> -				return len;
> -			fwd += snprintf(buff + fwd, len - fwd,
> -					"\t\twwid \"%s\"\n", mpp->wwid);
> -			if (fwd >= len)
> -				return len;
> +			if ((rc = print_strbuf(buff,
> +					       "\tmultipath {\n\t\twwid \"%s\"\n",
> +					       mpp->wwid)) < 0)
> +				return rc;
>  			/*
>  			 * This mpp doesn't have alias defined in
>  			 * multipath.conf - otherwise find_mpe would have
>  			 * found it. Add the alias in a comment.
>  			 */
> -			if (strcmp(mpp->alias, mpp->wwid)) {
> -				fwd += snprintf(buff + fwd, len - fwd,
> -						"\t\t# alias \"%s\"\n",
> -						mpp->alias);
> -				if (fwd >= len)
> -					return len;
> -			}
> -			fwd += snprintf(buff + fwd, len - fwd, "\t}\n");
> -			if (fwd >= len)
> -				return len;
> +			if (strcmp(mpp->alias, mpp->wwid) &&
> +			    (rc = print_strbuf(buff, "\t\t# alias \"%s\"\n",
> +					       mpp->alias)) < 0)
> +				return rc;
> +			if ((rc = append_strbuf_str(buff, "\t}\n")) < 0)
> +				return rc;
>  		}
>  	}
> -	fwd += snprintf(buff + fwd, len - fwd, "}\n");
> -	if (fwd >= len)
> -		return len;
> -	return fwd;
> +	if ((rc = append_strbuf_str(buff, "}\n")) < 0)
> +		return rc;
> +	return get_strbuf_len(buff) - initial_len;
>  }
>  
> -static int snprint_overrides(const struct config *conf, char * buff, int len,
> +static int snprint_overrides(const struct config *conf, struct strbuf *buff,
>  			     const struct hwentry *overrides)
>  {
> -	int fwd = 0;
> -	int i;
> +	int i, rc;
>  	struct keyword *rootkw;
>  	struct keyword *kw;
> +	size_t initial_len = get_strbuf_len(buff);
>  
>  	rootkw = find_keyword(conf->keywords, NULL, "overrides");
>  	if (!rootkw)
>  		return 0;
>  
> -	fwd += snprintf(buff + fwd, len - fwd, "overrides {\n");
> -	if (fwd >= len)
> -		return len;
> +	if ((rc = append_strbuf_str(buff, "overrides {\n")) < 0)
> +		return rc;
>  	if (!overrides)
>  		goto out;
> +
>  	iterate_sub_keywords(rootkw, kw, i) {
> -		fwd += snprint_keyword(buff + fwd, len - fwd, "\t%k %v\n",
> -				       kw, NULL);
> -		if (fwd >= len)
> -			return len;
> +		if ((rc = snprint_keyword(buff, "\t%k %v\n", kw, NULL)) < 0)
> +			return rc;
>  	}
>  out:
> -	fwd += snprintf(buff + fwd, len - fwd, "}\n");
> -	if (fwd >= len)
> -		return len;
> -	return fwd;
> +	if ((rc = append_strbuf_str(buff, "}\n")) < 0)
> +		return rc;
> +	return get_strbuf_len(buff) - initial_len;
>  }
>  
> -static int snprint_defaults(const struct config *conf, char *buff, int len)
> +static int snprint_defaults(const struct config *conf, struct strbuf *buff)
>  {
> -	int fwd = 0;
> -	int i;
> +	int i, rc;
>  	struct keyword *rootkw;
>  	struct keyword *kw;
> +	size_t initial_len = get_strbuf_len(buff);
>  
>  	rootkw = find_keyword(conf->keywords, NULL, "defaults");
>  	if (!rootkw)
>  		return 0;
>  
> -	fwd += snprintf(buff + fwd, len - fwd, "defaults {\n");
> -	if (fwd >= len)
> -		return len;
> +	if ((rc = append_strbuf_str(buff, "defaults {\n")) < 0)
> +		return rc;
>  
>  	iterate_sub_keywords(rootkw, kw, i) {
> -		fwd += snprint_keyword(buff + fwd, len - fwd, "\t%k %v\n",
> -				kw, NULL);
> -		if (fwd >= len)
> -			return len;
> +		if ((rc = snprint_keyword(buff, "\t%k %v\n", kw, NULL)) < 0)
> +			return rc;
>  	}
> -	fwd += snprintf(buff + fwd, len - fwd, "}\n");
> -	if (fwd >= len)
> -		return len;
> -	return fwd;
> +	if ((rc = append_strbuf_str(buff, "}\n")) < 0)
> +		return rc;
> +	return get_strbuf_len(buff) - initial_len;
>  }
>  
> -static int
> -snprint_blacklist_group (char *buff, int len, int *fwd, vector *vec)
> +static int snprint_blacklist_group(struct strbuf *buff, vector *vec)
>  {
> -	int threshold = MAX_LINE_LEN;
>  	struct blentry * ble;
> -	int pos;
> -	int i;
> +	size_t initial_len = get_strbuf_len(buff);
> +	int rc, i;
>  
> -	pos = *fwd;
>  	if (!VECTOR_SIZE(*vec)) {
> -		if ((len - pos - threshold) <= 0)
> -			return 0;
> -		pos += snprintf(buff + pos, len - pos, "        <empty>\n");
> +		if ((rc = append_strbuf_str(buff, "        <empty>\n")) < 0)
> +			return rc;
>  	} else vector_foreach_slot (*vec, ble, i) {
> -		if ((len - pos - threshold) <= 0)
> -			return 0;
> -		if (ble->origin == ORIGIN_CONFIG)
> -			pos += snprintf(buff + pos, len - pos, "        (config file rule) ");
> -		else if (ble->origin == ORIGIN_DEFAULT)
> -			pos += snprintf(buff + pos, len - pos, "        (default rule)     ");
> -		pos += snprintf(buff + pos, len - pos, "%s\n", ble->str);
> +		rc = print_strbuf(buff, "        %s %s\n",
> +				   ble->origin == ORIGIN_CONFIG ?
> +				   "(config file rule)" :
> +				   "(default rule)    ", ble->str);
> +		if (rc < 0)
> +			return rc;
>  	}
>  
> -	*fwd = pos;
> -	return pos;
> +	return get_strbuf_len(buff) - initial_len;
>  }
>  
>  static int
> -snprint_blacklist_devgroup (char *buff, int len, int *fwd, vector *vec)
> +snprint_blacklist_devgroup (struct strbuf *buff, vector *vec)
>  {
> -	int threshold = MAX_LINE_LEN;
>  	struct blentry_device * bled;
> -	int pos;
> -	int i;
> +	size_t initial_len = get_strbuf_len(buff);
> +	int rc, i;
>  
> -	pos = *fwd;
>  	if (!VECTOR_SIZE(*vec)) {
> -		if ((len - pos - threshold) <= 0)
> -			return 0;
> -		pos += snprintf(buff + pos, len - pos, "        <empty>\n");
> +		if ((rc = append_strbuf_str(buff, "        <empty>\n")) < 0)
> +			return rc;
>  	} else vector_foreach_slot (*vec, bled, i) {
> -		if ((len - pos - threshold) <= 0)
> -			return 0;
> -		if (bled->origin == ORIGIN_CONFIG)
> -			pos += snprintf(buff + pos, len - pos, "        (config file rule) ");
> -		else if (bled->origin == ORIGIN_DEFAULT)
> -			pos += snprintf(buff + pos, len - pos, "        (default rule)     ");
> -		pos += snprintf(buff + pos, len - pos, "%s:%s\n", bled->vendor, bled->product);
> +		rc = print_strbuf(buff, "        %s %s:%s\n",
> +				  bled->origin == ORIGIN_CONFIG ?
> +				  "(config file rule)" :
> +				  "(default rule)    ",
> +				  bled->vendor, bled->product);
> +		if (rc < 0)
> +			return rc;
>  	}
>  
> -	*fwd = pos;
> -	return pos;
> -}
> -
> -int snprint_blacklist_report(struct config *conf, char *buff, int len)
> -{
> -	int threshold = MAX_LINE_LEN;
> -	int fwd = 0;
> -
> -	if ((len - fwd - threshold) <= 0)
> -		return len;
> -	fwd += snprintf(buff + fwd, len - fwd, "device node rules:\n"
> -					       "- blacklist:\n");
> -	if (!snprint_blacklist_group(buff, len, &fwd, &conf->blist_devnode))
> -		return len;
> -
> -	if ((len - fwd - threshold) <= 0)
> -		return len;
> -	fwd += snprintf(buff + fwd, len - fwd, "- exceptions:\n");
> -	if (snprint_blacklist_group(buff, len, &fwd, &conf->elist_devnode) == 0)
> -		return len;
> -
> -	if ((len - fwd - threshold) <= 0)
> -		return len;
> -	fwd += snprintf(buff + fwd, len - fwd, "udev property rules:\n"
> -					       "- blacklist:\n");
> -	if (!snprint_blacklist_group(buff, len, &fwd, &conf->blist_property))
> -		return len;
> -
> -	if ((len - fwd - threshold) <= 0)
> -		return len;
> -	fwd += snprintf(buff + fwd, len - fwd, "- exceptions:\n");
> -	if (snprint_blacklist_group(buff, len, &fwd, &conf->elist_property) == 0)
> -		return len;
> -
> -	if ((len - fwd - threshold) <= 0)
> -		return len;
> -	fwd += snprintf(buff + fwd, len - fwd, "protocol rules:\n"
> -					       "- blacklist:\n");
> -	if (!snprint_blacklist_group(buff, len, &fwd, &conf->blist_protocol))
> -		return len;
> -
> -	if ((len - fwd - threshold) <= 0)
> -		return len;
> -	fwd += snprintf(buff + fwd, len - fwd, "- exceptions:\n");
> -	if (snprint_blacklist_group(buff, len, &fwd, &conf->elist_protocol) == 0)
> -		return len;
> -
> -	if ((len - fwd - threshold) <= 0)
> -		return len;
> -	fwd += snprintf(buff + fwd, len - fwd, "wwid rules:\n"
> -					       "- blacklist:\n");
> -	if (snprint_blacklist_group(buff, len, &fwd, &conf->blist_wwid) == 0)
> -		return len;
> -
> -	if ((len - fwd - threshold) <= 0)
> -		return len;
> -	fwd += snprintf(buff + fwd, len - fwd, "- exceptions:\n");
> -	if (snprint_blacklist_group(buff, len, &fwd, &conf->elist_wwid) == 0)
> -		return len;
> -
> -	if ((len - fwd - threshold) <= 0)
> -		return len;
> -	fwd += snprintf(buff + fwd, len - fwd, "device rules:\n"
> -					       "- blacklist:\n");
> -	if (snprint_blacklist_devgroup(buff, len, &fwd, &conf->blist_device) == 0)
> -		return len;
> -
> -	if ((len - fwd - threshold) <= 0)
> -		return len;
> -	fwd += snprintf(buff + fwd, len - fwd, "- exceptions:\n");
> -	if (snprint_blacklist_devgroup(buff, len, &fwd, &conf->elist_device) == 0)
> -		return len;
> -
> -	if (fwd > len)
> -		return len;
> -	return fwd;
> -}
> -
> -static int snprint_blacklist(const struct config *conf, char *buff, int len)
> +	return get_strbuf_len(buff) - initial_len;
> +}
> +
> +int snprint_blacklist_report(struct config *conf, struct strbuf *buff)
>  {
> -	int i;
> +	size_t initial_len = get_strbuf_len(buff);
> +	int rc;
> +
> +	if ((rc = append_strbuf_str(buff, "device node rules:\n- blacklist:\n")) < 0)
> +		return rc;
> +	if ((rc = snprint_blacklist_group(buff, &conf->blist_devnode)) < 0)
> +		return rc;
> +
> +	if ((rc = append_strbuf_str(buff, "- exceptions:\n")) < 0)
> +		return rc;
> +	if ((rc = snprint_blacklist_group(buff, &conf->elist_devnode)) < 0)
> +		return rc;
> +
> +	if ((rc = append_strbuf_str(buff, "udev property rules:\n- blacklist:\n")) < 0)
> +		return rc;
> +	if ((rc = snprint_blacklist_group(buff, &conf->blist_property)) < 0)
> +		return rc;
> +
> +	if ((rc = append_strbuf_str(buff, "- exceptions:\n")) < 0)
> +		return rc;
> +	if ((rc = snprint_blacklist_group(buff, &conf->elist_property)) < 0)
> +		return rc;
> +
> +	if ((rc = append_strbuf_str(buff, "protocol rules:\n- blacklist:\n")) < 0)
> +		return rc;
> +	if ((rc = snprint_blacklist_group(buff, &conf->blist_protocol)) < 0)
> +		return rc;
> +
> +	if ((rc = append_strbuf_str(buff, "- exceptions:\n")) < 0)
> +		return rc;
> +	if ((rc = snprint_blacklist_group(buff, &conf->elist_protocol)) < 0)
> +		return rc;
> +
> +	if ((rc = append_strbuf_str(buff, "wwid rules:\n- blacklist:\n")) < 0)
> +		return rc;
> +	if ((rc = snprint_blacklist_group(buff, &conf->blist_wwid)) < 0)
> +		return rc;
> +
> +	if ((rc = append_strbuf_str(buff, "- exceptions:\n")) < 0)
> +		return rc;
> +	if ((rc = snprint_blacklist_group(buff, &conf->elist_wwid)) < 0)
> +		return rc;
> +
> +	if ((rc = append_strbuf_str(buff, "device rules:\n- blacklist:\n")) < 0)
> +		return rc;
> +	if ((rc = snprint_blacklist_devgroup(buff, &conf->blist_device)) < 0)
> +		return rc;
> +
> +	if ((rc = append_strbuf_str(buff, "- exceptions:\n")) < 0)
> +	     return rc;
> +	if ((rc = snprint_blacklist_devgroup(buff, &conf->elist_device)) < 0)
> +		return rc;
> +
> +	return get_strbuf_len(buff) - initial_len;
> +}
> +
> +static int snprint_blacklist(const struct config *conf, struct strbuf *buff)
> +{
> +	int i, rc;
>  	struct blentry * ble;
>  	struct blentry_device * bled;
> -	int fwd = 0;
>  	struct keyword *rootkw;
>  	struct keyword *kw;
> +	size_t initial_len = get_strbuf_len(buff);
>  
>  	rootkw = find_keyword(conf->keywords, NULL, "blacklist");
>  	if (!rootkw)
>  		return 0;
>  
> -	fwd += snprintf(buff + fwd, len - fwd, "blacklist {\n");
> -	if (fwd >= len)
> -		return len;
> +	if ((rc = append_strbuf_str(buff, "blacklist {\n")) < 0)
> +		return rc;
>  
>  	vector_foreach_slot (conf->blist_devnode, ble, i) {
>  		kw = find_keyword(conf->keywords, rootkw->sub, "devnode");
>  		if (!kw)
>  			return 0;
> -		fwd += snprint_keyword(buff + fwd, len - fwd, "\t%k %v\n",
> -				       kw, ble);
> -		if (fwd >= len)
> -			return len;
> +		if ((rc = snprint_keyword(buff, "\t%k %v\n", kw, ble)) < 0)
> +			return rc;
>  	}
>  	vector_foreach_slot (conf->blist_wwid, ble, i) {
>  		kw = find_keyword(conf->keywords, rootkw->sub, "wwid");
>  		if (!kw)
>  			return 0;
> -		fwd += snprint_keyword(buff + fwd, len - fwd, "\t%k %v\n",
> -				       kw, ble);
> -		if (fwd >= len)
> -			return len;
> +		if ((rc = snprint_keyword(buff, "\t%k %v\n", kw, ble)) < 0)
> +			return rc;
>  	}
>  	vector_foreach_slot (conf->blist_property, ble, i) {
>  		kw = find_keyword(conf->keywords, rootkw->sub, "property");
>  		if (!kw)
>  			return 0;
> -		fwd += snprint_keyword(buff + fwd, len - fwd, "\t%k %v\n",
> -				       kw, ble);
> -		if (fwd >= len)
> -			return len;
> +		if ((rc = snprint_keyword(buff, "\t%k %v\n", kw, ble)) < 0)
> +			return rc;
>  	}
>  	vector_foreach_slot (conf->blist_protocol, ble, i) {
>  		kw = find_keyword(conf->keywords, rootkw->sub, "protocol");
>  		if (!kw)
>  			return 0;
> -		fwd += snprint_keyword(buff + fwd, len - fwd, "\t%k %v\n",
> -				       kw, ble);
> -		if (fwd >= len)
> -			return len;
> +		if ((rc = snprint_keyword(buff, "\t%k %v\n", kw, ble)) < 0)
> +			return rc;
>  	}
> +
>  	rootkw = find_keyword(conf->keywords, rootkw->sub, "device");
>  	if (!rootkw)
>  		return 0;
>  
>  	vector_foreach_slot (conf->blist_device, bled, i) {
> -		fwd += snprintf(buff + fwd, len - fwd, "\tdevice {\n");
> -		if (fwd >= len)
> -			return len;
> +		if ((rc = append_strbuf_str(buff, "\tdevice {\n")) < 0)
> +			return rc;
> +
>  		kw = find_keyword(conf->keywords, rootkw->sub, "vendor");
>  		if (!kw)
>  			return 0;
> -		fwd += snprint_keyword(buff + fwd, len - fwd, "\t\t%k %v\n",
> -				       kw, bled);
> -		if (fwd >= len)
> -			return len;
> +		if ((rc = snprint_keyword(buff, "\t\t%k %v\n", kw, bled)) < 0)
> +			return rc;
>  		kw = find_keyword(conf->keywords, rootkw->sub, "product");
>  		if (!kw)
>  			return 0;
> -		fwd += snprint_keyword(buff + fwd, len - fwd, "\t\t%k %v\n",
> -				       kw, bled);
> -		if (fwd >= len)
> -			return len;
> -		fwd += snprintf(buff + fwd, len - fwd, "\t}\n");
> -		if (fwd >= len)
> -			return len;
> +		if ((rc = snprint_keyword(buff,
> +					  "\t\t%k %v\n\t}\n", kw, bled)) < 0)
> +			return rc;
>  	}
> -	fwd += snprintf(buff + fwd, len - fwd, "}\n");
> -	if (fwd >= len)
> -		return len;
> -	return fwd;
> +
> +	if ((rc = append_strbuf_str(buff, "}\n")) < 0)
> +		return rc;
> +	return get_strbuf_len(buff) - initial_len;
>  }
>  
>  static int snprint_blacklist_except(const struct config *conf,
> -				    char *buff, int len)
> +				    struct strbuf *buff)
>  {
> -	int i;
> +	int i, rc;
>  	struct blentry * ele;
>  	struct blentry_device * eled;
> -	int fwd = 0;
>  	struct keyword *rootkw;
>  	struct keyword *kw;
> +	size_t initial_len = get_strbuf_len(buff);
>  
>  	rootkw = find_keyword(conf->keywords, NULL, "blacklist_exceptions");
>  	if (!rootkw)
>  		return 0;
>  
> -	fwd += snprintf(buff + fwd, len - fwd, "blacklist_exceptions {\n");
> -	if (fwd >= len)
> -		return len;
> +	if ((rc = append_strbuf_str(buff, "blacklist_exceptions {\n")) < 0)
> +		return rc;
>  
>  	vector_foreach_slot (conf->elist_devnode, ele, i) {
>  		kw = find_keyword(conf->keywords, rootkw->sub, "devnode");
>  		if (!kw)
>  			return 0;
> -		fwd += snprint_keyword(buff + fwd, len - fwd, "\t%k %v\n",
> -				       kw, ele);
> -		if (fwd >= len)
> -			return len;
> +		if ((rc = snprint_keyword(buff, "\t%k %v\n", kw, ele)) < 0)
> +			return rc;
>  	}
>  	vector_foreach_slot (conf->elist_wwid, ele, i) {
>  		kw = find_keyword(conf->keywords, rootkw->sub, "wwid");
>  		if (!kw)
>  			return 0;
> -		fwd += snprint_keyword(buff + fwd, len - fwd, "\t%k %v\n",
> -				       kw, ele);
> -		if (fwd >= len)
> -			return len;
> +		if ((rc = snprint_keyword(buff, "\t%k %v\n", kw, ele)) < 0)
> +			return rc;
>  	}
>  	vector_foreach_slot (conf->elist_property, ele, i) {
>  		kw = find_keyword(conf->keywords, rootkw->sub, "property");
>  		if (!kw)
>  			return 0;
> -		fwd += snprint_keyword(buff + fwd, len - fwd, "\t%k %v\n",
> -				       kw, ele);
> -		if (fwd >= len)
> -			return len;
> +		if ((rc = snprint_keyword(buff, "\t%k %v\n", kw, ele)) < 0)
> +			return rc;
>  	}
>  	vector_foreach_slot (conf->elist_protocol, ele, i) {
>  		kw = find_keyword(conf->keywords, rootkw->sub, "protocol");
>  		if (!kw)
>  			return 0;
> -		fwd += snprint_keyword(buff + fwd, len - fwd, "\t%k %v\n",
> -				       kw, ele);
> -		if (fwd >= len)
> -			return len;
> +		if ((rc = snprint_keyword(buff, "\t%k %v\n", kw, ele)) < 0)
> +			return rc;
>  	}
> +
>  	rootkw = find_keyword(conf->keywords, rootkw->sub, "device");
>  	if (!rootkw)
>  		return 0;
>  
>  	vector_foreach_slot (conf->elist_device, eled, i) {
> -		fwd += snprintf(buff + fwd, len - fwd, "\tdevice {\n");
> -		if (fwd >= len)
> -			return len;
> +		if ((rc = append_strbuf_str(buff, "\tdevice {\n")) < 0)
> +			return rc;
> +
>  		kw = find_keyword(conf->keywords, rootkw->sub, "vendor");
>  		if (!kw)
>  			return 0;
> -		fwd += snprint_keyword(buff + fwd, len - fwd, "\t\t%k %v\n",
> -				       kw, eled);
> -		if (fwd >= len)
> -			return len;
> +		if ((rc = snprint_keyword(buff, "\t\t%k %v\n", kw, eled)) < 0)
> +			return rc;
>  		kw = find_keyword(conf->keywords, rootkw->sub, "product");
>  		if (!kw)
>  			return 0;
> -		fwd += snprint_keyword(buff + fwd, len - fwd, "\t\t%k %v\n",
> -				       kw, eled);
> -		if (fwd >= len)
> -			return len;
> -		fwd += snprintf(buff + fwd, len - fwd, "\t}\n");
> -		if (fwd >= len)
> -			return len;
> +		if ((rc = snprint_keyword(buff, "\t\t%k %v\n\t}\n",
> +					  kw, eled)) < 0)
> +			return rc;
>  	}
> -	fwd += snprintf(buff + fwd, len - fwd, "}\n");
> -	if (fwd >= len)
> -		return len;
> -	return fwd;
> +
> +	if ((rc = append_strbuf_str(buff, "}\n")) < 0)
> +		return rc;
> +	return get_strbuf_len(buff) - initial_len;
>  }
>  
>  char *snprint_config(const struct config *conf, int *len,
>  		     const struct _vector *hwtable, const struct _vector *mpvec)
>  {
> +	STRBUF_ON_STACK(buff);
>  	char *reply;
> -	/* built-in config is >20kB already */
> -	unsigned int maxlen = 32768;
> -
> -	for (reply = NULL; maxlen <= UINT_MAX/2; maxlen *= 2) {
> -		char *c, *tmp = reply;
> -
> -		reply = REALLOC(reply, maxlen);
> -		if (!reply) {
> -			if (tmp)
> -				free(tmp);
> +	int rc;
> +
> +	if ((rc = snprint_defaults(conf, &buff)) < 0 ||
> +	    (rc = snprint_blacklist(conf, &buff)) < 0 ||
> +	    (rc = snprint_blacklist_except(conf, &buff)) < 0 ||
> +	    (rc = snprint_hwtable(conf, &buff,
> +				  hwtable ? hwtable : conf->hwtable)) < 0 ||
> +	    (rc = snprint_overrides(conf, &buff, conf->overrides)) < 0)
> +		return NULL;
> +	if (VECTOR_SIZE(conf->mptable) > 0 ||
> +	    (mpvec != NULL && VECTOR_SIZE(mpvec) > 0))
> +		if ((rc = snprint_mptable(conf, &buff, mpvec)) < 0)
>  			return NULL;
> -		}
> -
> -		c = reply + snprint_defaults(conf, reply, maxlen);
> -		if (c == reply + maxlen)
> -			continue;
>  
> -		c += snprint_blacklist(conf, c, reply + maxlen - c);
> -		if (c == reply + maxlen)
> -			continue;
> -
> -		c += snprint_blacklist_except(conf, c, reply + maxlen - c);
> -		if (c == reply + maxlen)
> -			continue;
> -
> -		c += snprint_hwtable(conf, c, reply + maxlen - c,
> -				     hwtable ? hwtable : conf->hwtable);
> -		if (c == reply + maxlen)
> -			continue;
> +	if (len)
> +		*len = get_strbuf_len(&buff);
> +	reply = steal_strbuf_str(&buff);
>  
> -		c += snprint_overrides(conf, c, reply + maxlen - c,
> -				       conf->overrides);
> -		if (c == reply + maxlen)
> -			continue;
> -
> -		if (VECTOR_SIZE(conf->mptable) > 0 ||
> -		    (mpvec != NULL && VECTOR_SIZE(mpvec) > 0))
> -			c += snprint_mptable(conf, c, reply + maxlen - c,
> -					     mpvec);
> -
> -		if (c < reply + maxlen) {
> -			if (len)
> -				*len = c - reply;
> -			return reply;
> -		}
> -	}
> -
> -	free(reply);
> -	return NULL;
> +	return reply;
>  }
>  
> -int snprint_status(char *buff, int len, const struct vectors *vecs)
> +int snprint_status(struct strbuf *buff, const struct vectors *vecs)
>  {
> -	int fwd = 0;
> -	int i;
> +	int i, rc;
>  	unsigned int count[PATH_MAX_STATE] = {0};
> +	int monitored_count = 0;
>  	struct path * pp;
> +	size_t initial_len = get_strbuf_len(buff);
>  
>  	vector_foreach_slot (vecs->pathvec, pp, i) {
>  		count[pp->state]++;
>  	}
> -	fwd += snprintf(buff + fwd, len - fwd, "path checker states:\n");
> -	for (i=0; i<PATH_MAX_STATE; i++) {
> +	if ((rc = append_strbuf_str(buff, "path checker states:\n")) < 0)
> +		return rc;
> +	for (i = 0; i < PATH_MAX_STATE; i++) {
>  		if (!count[i])
>  			continue;
> -		fwd += snprintf(buff + fwd, len - fwd, "%-20s%u\n",
> -				checker_state_name(i), count[i]);
> +		if ((rc = print_strbuf(buff, "%-20s%u\n",
> +				       checker_state_name(i), count[i])) < 0)
> +			return rc;
>  	}
>  
> -	int monitored_count = 0;
> -
>  	vector_foreach_slot(vecs->pathvec, pp, i)
>  		if (pp->fd >= 0)
>  			monitored_count++;
> -	fwd += snprintf(buff + fwd, len - fwd, "\npaths: %d\nbusy: %s\n",
> -			monitored_count, is_uevent_busy()? "True" : "False");
> +	if ((rc = print_strbuf(buff, "\npaths: %d\nbusy: %s\n",
> +			       monitored_count,
> +			       is_uevent_busy()? "True" : "False")) < 0)
> +		return rc;
>  
> -	if (fwd >= len)
> -		return len;
> -	return fwd;
> +	return get_strbuf_len(buff) - initial_len;
>  }
>  
> -int snprint_devices(struct config *conf, char *buff, size_t len,
> +int snprint_devices(struct config *conf, struct strbuf *buff,
>  		    const struct vectors *vecs)
>  {
> -	size_t fwd = 0;
>  	int r;
>  	struct udev_enumerate *enm;
>  	struct udev_list_entry *item, *first;
> -
>  	struct path * pp;
> +	size_t initial_len = get_strbuf_len(buff);
>  
>  	enm = udev_enumerate_new(udev);
>  	if (!enm)
>  		return 1;
>  	udev_enumerate_add_match_subsystem(enm, "block");
>  
> -	fwd += snprintf(buff + fwd, len - fwd, "available block devices:\n");
> +	if ((r = append_strbuf_str(buff, "available block devices:\n")) < 0)
> +		goto out;
>  	r = udev_enumerate_scan_devices(enm);
>  	if (r < 0)
>  		goto out;
> @@ -2066,10 +1816,6 @@ int snprint_devices(struct config *conf, char *buff, size_t len,
>  			continue;
>  		}
>  
> -		fwd += snprintf(buff + fwd, len - fwd, "    %s", devname);
> -		if (fwd >= len)
> -			break;
> -
>  		pp = find_path_by_dev(vecs->pathvec, devname);
>  		if (!pp) {
>  			const char *hidden;
> @@ -2092,41 +1838,27 @@ int snprint_devices(struct config *conf, char *buff, size_t len,
>  		} else
>  			status = " devnode whitelisted, monitored";
>  
> -		fwd += snprintf(buff + fwd, len - fwd, " %s\n", status);
> +		r = print_strbuf(buff, "    %s %s\n", devname, status);
>  		udev_device_unref(u_dev);
> -		if (fwd >= len)
> +		if (r < 0)
>  			break;
>  	}
>  out:
>  	udev_enumerate_unref(enm);
> +	if (r < 0)
> +		return r;
>  
> -	if (fwd >= len)
> -		return len;
> -	return fwd;
> +	return get_strbuf_len(buff) - initial_len;
>  }
>  
>  /*
>   * stdout printing helpers
>   */
> -void print_path(struct path *pp, char *style)
> -{
> -	char line[MAX_LINE_LEN];
> -
> -	memset(&line[0], 0, MAX_LINE_LEN);
> -	snprint_path(&line[0], MAX_LINE_LEN, style, pp, 1);
> -	printf("%s", line);
> -}
> -
> -void print_all_paths(vector pathvec, int banner)
> -{
> -	print_all_paths_custo(pathvec, banner, PRINT_PATH_LONG);
> -}
> -
> -void print_all_paths_custo(vector pathvec, int banner, char *fmt)
> +static void print_all_paths_custo(vector pathvec, int banner, const char *fmt)
>  {
>  	int i;
>  	struct path * pp;
> -	char line[MAX_LINE_LEN];
> +	STRBUF_ON_STACK(line);
>  
>  	if (!VECTOR_SIZE(pathvec)) {
>  		if (banner)
> @@ -2135,12 +1867,18 @@ void print_all_paths_custo(vector pathvec, int banner, char *fmt)
>  	}
>  
>  	if (banner)
> -		fprintf(stdout, "===== paths list =====\n");
> +		append_strbuf_str(&line, "===== paths list =====\n");
>  
>  	get_path_layout(pathvec, 1);
> -	snprint_path_header(line, MAX_LINE_LEN, fmt);
> -	fprintf(stdout, "%s", line);
> +	snprint_path_header(&line, fmt);
>  
>  	vector_foreach_slot (pathvec, pp, i)
> -		print_path(pp, fmt);
> +		snprint_path(&line, fmt, pp, 1);
> +
> +	printf("%s", get_strbuf_str(&line));
> +}
> +
> +void print_all_paths(vector pathvec, int banner)
> +{
> +	print_all_paths_custo(pathvec, banner, PRINT_PATH_LONG);
>  }
> diff --git a/libmultipath/print.h b/libmultipath/print.h
> index 0042cef..b922812 100644
> --- a/libmultipath/print.h
> +++ b/libmultipath/print.h
> @@ -2,6 +2,8 @@
>  #define _PRINT_H
>  #include "dm-generic.h"
>  
> +struct strbuf;
> +
>  #define PRINT_PATH_LONG      "%w %i %d %D %p %t %T %s %o"
>  #define PRINT_PATH_INDENT    "%i %d %D %t %T %o"
>  #define PRINT_PATH_CHECKER   "%i %d %D %p %t %T %o %C"
> @@ -25,7 +27,7 @@
>  #define PRINT_JSON_END_LAST_ELEM  "}"
>  #define PRINT_JSON_END_LAST       "}\n"
>  #define PRINT_JSON_END_ARRAY      "]\n"
> -#define PRINT_JSON_INDENT    "   "
> +#define PRINT_JSON_INDENT_N    3
>  #define PRINT_JSON_MAP       "{\n" \
>  			     "      \"name\" : \"%n\",\n" \
>  			     "      \"uuid\" : \"%w\",\n" \
> @@ -79,21 +81,21 @@ struct path_data {
>  	char wildcard;
>  	char * header;
>  	unsigned int width;
> -	int (*snprint)(char * buff, size_t len, const struct path * pp);
> +	int (*snprint)(struct strbuf *, const struct path * pp);
>  };
>  
>  struct multipath_data {
>  	char wildcard;
>  	char * header;
>  	unsigned int width;
> -	int (*snprint)(char * buff, size_t len, const struct multipath * mpp);
> +	int (*snprint)(struct strbuf *, const struct multipath * mpp);
>  };
>  
>  struct pathgroup_data {
>  	char wildcard;
>  	char * header;
>  	unsigned int width;
> -	int (*snprint)(char * buff, size_t len, const struct pathgroup * pgp);
> +	int (*snprint)(struct strbuf *, const struct pathgroup * pgp);
>  };
>  
>  enum layout_reset {
> @@ -106,37 +108,35 @@ void _get_path_layout (const struct _vector *gpvec, enum layout_reset);
>  void get_path_layout (vector pathvec, int header);
>  void _get_multipath_layout (const struct _vector *gmvec, enum layout_reset);
>  void get_multipath_layout (vector mpvec, int header);
> -int snprint_path_header (char *, int, const char *);
> -int snprint_multipath_header (char *, int, const char *);
> -int _snprint_path (const struct gen_path *, char *, int, const char *, int);
> -#define snprint_path(buf, len, fmt, pp, v) \
> -	_snprint_path(dm_path_to_gen(pp), buf, len, fmt,  v)
> -int _snprint_multipath (const struct gen_multipath *, char *, int,
> +int snprint_path_header(struct strbuf *, const char *);
> +int snprint_multipath_header(struct strbuf *, const char *);
> +int _snprint_path (const struct gen_path *, struct strbuf *, const char *, int);
> +#define snprint_path(buf, fmt, pp, v) \
> +	_snprint_path(dm_path_to_gen(pp), buf, fmt,  v)
> +int _snprint_multipath (const struct gen_multipath *, struct strbuf *,
>  			const char *, int);
> -#define snprint_multipath(buf, len, fmt, mp, v)				\
> -	_snprint_multipath(dm_multipath_to_gen(mp), buf, len, fmt,  v)
> -int _snprint_multipath_topology (const struct gen_multipath *, char *, int,
> +#define snprint_multipath(buf, fmt, mp, v)				\
> +	_snprint_multipath(dm_multipath_to_gen(mp), buf, fmt,  v)
> +int _snprint_multipath_topology (const struct gen_multipath *, struct strbuf *,
>  				 int verbosity);
> -#define snprint_multipath_topology(buf, len, mpp, v) \
> -	_snprint_multipath_topology (dm_multipath_to_gen(mpp), buf, len, v)
> -int snprint_multipath_topology_json (char * buff, int len,
> -				const struct vectors * vecs);
> +#define snprint_multipath_topology(buf, mpp, v) \
> +	_snprint_multipath_topology (dm_multipath_to_gen(mpp), buf, v)
> +int snprint_multipath_topology_json(struct strbuf *, const struct vectors *vecs);
>  char *snprint_config(const struct config *conf, int *len,
>  		     const struct _vector *hwtable,
>  		     const struct _vector *mpvec);
> -int snprint_multipath_map_json (char * buff, int len,
> -				const struct multipath * mpp);
> -int snprint_blacklist_report (struct config *, char *, int);
> -int snprint_wildcards (char *, int);
> -int snprint_status (char *, int, const struct vectors *);
> -int snprint_devices (struct config *, char *, size_t, const struct vectors *);
> -int snprint_path_serial (char *, size_t, const struct path *);
> -int snprint_host_wwnn (char *, size_t, const struct path *);
> -int snprint_host_wwpn (char *, size_t, const struct path *);
> -int snprint_tgt_wwnn (char *, size_t, const struct path *);
> -int snprint_tgt_wwpn (char *, size_t, const struct path *);
> +int snprint_multipath_map_json(struct strbuf *, const struct multipath *mpp);
> +int snprint_blacklist_report(struct config *, struct strbuf *);
> +int snprint_wildcards(struct strbuf *);
> +int snprint_status(struct strbuf *, const struct vectors *);
> +int snprint_devices(struct config *, struct strbuf *, const struct vectors *);
> +int snprint_path_serial(struct strbuf *, const struct path *);
> +int snprint_host_wwnn(struct strbuf *, const struct path *);
> +int snprint_host_wwpn(struct strbuf *, const struct path *);
> +int snprint_tgt_wwnn(struct strbuf *, const struct path *);
> +int snprint_tgt_wwpn(struct strbuf *, const struct path *);
>  #define PROTOCOL_BUF_SIZE sizeof("scsi:unspec")
> -int snprint_path_protocol(char *, size_t, const struct path *);
> +int snprint_path_protocol(struct strbuf *, const struct path *);
>  
>  void _print_multipath_topology (const struct gen_multipath * gmp,
>  				int verbosity);
> @@ -144,14 +144,13 @@ void _print_multipath_topology (const struct gen_multipath * gmp,
>  	_print_multipath_topology(dm_multipath_to_gen(mpp), v)
>  
>  void print_all_paths (vector pathvec, int banner);
> -void print_all_paths_custo (vector pathvec, int banner, char *fmt);
>  
>  int snprint_path_attr(const struct gen_path* gp,
> -		      char *buf, int len, char wildcard);
> +		      struct strbuf *buf, char wildcard);
>  int snprint_pathgroup_attr(const struct gen_pathgroup* gpg,
> -			   char *buf, int len, char wildcard);
> +			   struct strbuf *buf, char wildcard);
>  int snprint_multipath_attr(const struct gen_multipath* gm,
> -			   char *buf, int len, char wildcard);
> +			   struct strbuf *buf, char wildcard);
>  int snprint_multipath_style(const struct gen_multipath *gmp,
> -			    char *style, int len, int verbosity);
> +			    struct strbuf *style, int verbosity);
>  #endif /* _PRINT_H */
> diff --git a/libmultipath/prioritizers/weightedpath.c b/libmultipath/prioritizers/weightedpath.c
> index 650088b..ea03fc3 100644
> --- a/libmultipath/prioritizers/weightedpath.c
> +++ b/libmultipath/prioritizers/weightedpath.c
> @@ -35,52 +35,37 @@
>  #include "structs_vec.h"
>  #include "print.h"
>  #include "util.h"
> -
> -#define CHECK_LEN \
> -do { \
> -	if ((p - str) >= (len - 1)) { \
> -		condlog(0, "%s: %s - buffer size too small", pp->dev, pp->prio.name); \
> -		return -1; \
> -	} \
> -} while(0)
> +#include "strbuf.h"
>  
>  static int
> -build_serial_path(struct path *pp, char *str, int len)
> +build_serial_path(struct path *pp, struct strbuf *buf)
>  {
> -	char *p = str;
> +	int rc = snprint_path_serial(buf, pp);
>  
> -	p += snprint_path_serial(p, str + len - p, pp);
> -	CHECK_LEN;
> -	return 0;
> +	return rc < 0 ? rc : 0;
>  }
>  
>  static int
> -build_wwn_path(struct path *pp, char *str, int len)
> +build_wwn_path(struct path *pp, struct strbuf *buf)
>  {
> -	char *p = str;
> -
> -	p += snprint_host_wwnn(p, str + len - p, pp);
> -	CHECK_LEN;
> -	p += snprintf(p, str + len - p, ":");
> -	CHECK_LEN;
> -	p += snprint_host_wwpn(p, str + len - p, pp);
> -	CHECK_LEN;
> -	p += snprintf(p, str + len - p, ":");
> -	CHECK_LEN;
> -	p += snprint_tgt_wwnn(p, str + len - p, pp);
> -	CHECK_LEN;
> -	p += snprintf(p, str + len - p, ":");
> -	CHECK_LEN;
> -	p += snprint_tgt_wwpn(p, str + len - p, pp);
> -	CHECK_LEN;
> +	int rc;
> +
> +	if ((rc = snprint_host_wwnn(buf, pp)) < 0 ||
> +	    (rc = fill_strbuf(buf, ':', 1)) < 0 ||
> +	    (rc = snprint_host_wwpn(buf, pp)) < 0 ||
> +	    (rc = fill_strbuf(buf, ':', 1)) < 0 ||
> +	    (rc = snprint_tgt_wwnn(buf, pp) < 0) ||
> +	    (rc = fill_strbuf(buf, ':', 1) < 0) ||
> +	    (rc = snprint_tgt_wwpn(buf, pp) < 0))
> +		return rc;
>  	return 0;
>  }
>  
>  /* main priority routine */
>  int prio_path_weight(struct path *pp, char *prio_args)
>  {
> -	char path[FILE_NAME_SIZE];
> -	char *arg;
> +	STRBUF_ON_STACK(path);
> +	char *arg __attribute__((cleanup(cleanup_charp))) = NULL;
>  	char *temp, *regex, *prio;
>  	char split_char[] = " \t";
>  	int priority = DEFAULT_PRIORITY, path_found = 0;
> @@ -101,24 +86,22 @@ int prio_path_weight(struct path *pp, char *prio_args)
>  	}
>  
>  	if (!strcmp(regex, HBTL)) {
> -		sprintf(path, "%d:%d:%d:%" PRIu64, pp->sg_id.host_no,
> -			pp->sg_id.channel, pp->sg_id.scsi_id, pp->sg_id.lun);
> +		if (print_strbuf(&path, "%d:%d:%d:%" PRIu64, pp->sg_id.host_no,
> +				 pp->sg_id.channel, pp->sg_id.scsi_id,
> +				 pp->sg_id.lun) < 0)
> +			return priority;
>  	} else if (!strcmp(regex, DEV_NAME)) {
> -		strcpy(path, pp->dev);
> +		if (append_strbuf_str(&path, pp->dev) < 0)
> +			return priority;
>  	} else if (!strcmp(regex, SERIAL)) {
> -		if (build_serial_path(pp, path, FILE_NAME_SIZE) != 0) {
> -			FREE(arg);
> +		if (build_serial_path(pp, &path) != 0)
>  			return priority;
> -		}
>  	} else if (!strcmp(regex, WWN)) {
> -		if (build_wwn_path(pp, path, FILE_NAME_SIZE) != 0) {
> -			FREE(arg);
> +		if (build_wwn_path(pp, &path) != 0)
>  			return priority;
> -		}
>  	} else {
>  		condlog(0, "%s: %s - Invalid arguments", pp->dev,
>  			pp->prio.name);
> -		FREE(arg);
>  		return priority;
>  	}
>  
> @@ -131,7 +114,8 @@ int prio_path_weight(struct path *pp, char *prio_args)
>  			break;
>  
>  		if (!regcomp(&pathe, regex, REG_EXTENDED|REG_NOSUB)) {
> -			if (!regexec(&pathe, path, 0, NULL, 0)) {
> +			if (!regexec(&pathe, get_strbuf_str(&path), 0,
> +				     NULL, 0)) {
>  				path_found = 1;
>  				priority = atoi(prio);
>  			}
> @@ -139,7 +123,6 @@ int prio_path_weight(struct path *pp, char *prio_args)
>  		}
>  	}
>  
> -	FREE(arg);
>  	return priority;
>  }
>  
> diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> index bce40b1..6d3a0ae 100644
> --- a/multipathd/cli_handlers.c
> +++ b/multipathd/cli_handlers.c
> @@ -30,6 +30,7 @@
>  #include "cli.h"
>  #include "uevent.h"
>  #include "foreign.h"
> +#include "strbuf.h"
>  #include "cli_handlers.h"
>  
>  #define SET_REPLY_AND_LEN(__rep, __len, string_literal)			\
> @@ -42,49 +43,30 @@ int
>  show_paths (char ** r, int * len, struct vectors * vecs, char * style,
>  	    int pretty)
>  {
> +	STRBUF_ON_STACK(reply);
>  	int i;
>  	struct path * pp;
> -	char * c;
> -	char * reply, * header;
> -	unsigned int maxlen = INITIAL_REPLY_LEN;
> -	int again = 1;
> +	int hdr_len = 0;
>  
>  	get_path_layout(vecs->pathvec, 1);
>  	foreign_path_layout();
>  
> -	reply = MALLOC(maxlen);
> +	if (pretty && (hdr_len = snprint_path_header(&reply, style)) < 0)
> +		return 1;
>  
> -	while (again) {
> -		if (!reply)
> +	vector_foreach_slot(vecs->pathvec, pp, i) {
> +		if (snprint_path(&reply, style, pp, pretty) < 0)
>  			return 1;
> -
> -		c = reply;
> -
> -		if (pretty)
> -			c += snprint_path_header(c, reply + maxlen - c,
> -						 style);
> -		header = c;
> -
> -		vector_foreach_slot(vecs->pathvec, pp, i)
> -			c += snprint_path(c, reply + maxlen - c,
> -					  style, pp, pretty);
> -
> -		c += snprint_foreign_paths(c, reply + maxlen - c,
> -					   style, pretty);
> -
> -		again = (c == reply + maxlen - 1);
> -
> -		REALLOC_REPLY(reply, again, maxlen);
>  	}
> +	if (snprint_foreign_paths(&reply, style, pretty) < 0)
> +		return 1;
>  
> -	if (pretty && c == header) {
> +	if (pretty && get_strbuf_len(&reply) == (size_t)hdr_len)
>  		/* No output - clear header */
> -		*reply = '\0';
> -		c = reply;
> -	}
> +		truncate_strbuf(&reply, 0);
>  
> -	*r = reply;
> -	*len = (int)(c - reply + 1);
> +	*len = (int)get_strbuf_len(&reply) + 1;
> +	*r = steal_strbuf_str(&reply);
>  	return 0;
>  }
>  
> @@ -92,28 +74,14 @@ int
>  show_path (char ** r, int * len, struct vectors * vecs, struct path *pp,
>  	   char * style)
>  {
> -	char * c;
> -	char * reply;
> -	unsigned int maxlen = INITIAL_REPLY_LEN;
> -	int again = 1;
> +	STRBUF_ON_STACK(reply);
>  
>  	get_path_layout(vecs->pathvec, 1);
> -	reply = MALLOC(maxlen);
> -
> -	while (again) {
> -		if (!reply)
> -			return 1;
> -
> -		c = reply;
> -
> -		c += snprint_path(c, reply + maxlen - c, style, pp, 0);
> -
> -		again = (c == reply + maxlen - 1);
> +	if (snprint_path(&reply, style, pp, 0) < 0)
> +		return 1;
> +	*len = (int)get_strbuf_len(&reply) + 1;
> +	*r = steal_strbuf_str(&reply);
>  
> -		REALLOC_REPLY(reply, again, maxlen);
> -	}
> -	*r = reply;
> -	*len = (int)(c - reply + 1);
>  	return 0;
>  }
>  
> @@ -121,84 +89,51 @@ int
>  show_map_topology (char ** r, int * len, struct multipath * mpp,
>  		   struct vectors * vecs)
>  {
> -	char * c;
> -	char * reply;
> -	unsigned int maxlen = INITIAL_REPLY_LEN;
> -	int again = 1;
> +	STRBUF_ON_STACK(reply);
>  
>  	if (update_multipath(vecs, mpp->alias, 0))
>  		return 1;
> -	reply = MALLOC(maxlen);
>  
> -	while (again) {
> -		if (!reply)
> -			return 1;
> -
> -		c = reply;
> -
> -		c += snprint_multipath_topology(c, reply + maxlen - c, mpp, 2);
> -		again = (c == reply + maxlen - 1);
> +	if (snprint_multipath_topology(&reply, mpp, 2) < 0)
> +		return 1;
> +	*len = (int)get_strbuf_len(&reply) + 1;
> +	*r = steal_strbuf_str(&reply);
>  
> -		REALLOC_REPLY(reply, again, maxlen);
> -	}
> -	*r = reply;
> -	*len = (int)(c - reply + 1);
>  	return 0;
>  }
>  
>  int
>  show_maps_topology (char ** r, int * len, struct vectors * vecs)
>  {
> +	STRBUF_ON_STACK(reply);
>  	int i;
>  	struct multipath * mpp;
> -	char * c;
> -	char * reply;
> -	unsigned int maxlen = INITIAL_REPLY_LEN;
> -	int again = 1;
>  
>  	get_path_layout(vecs->pathvec, 0);
>  	foreign_path_layout();
>  
> -	reply = MALLOC(maxlen);
> -
> -	while (again) {
> -		if (!reply)
> -			return 1;
> -
> -		c = reply;
> -
> -		vector_foreach_slot(vecs->mpvec, mpp, i) {
> -			if (update_multipath(vecs, mpp->alias, 0)) {
> -				i--;
> -				continue;
> -			}
> -			c += snprint_multipath_topology(c, reply + maxlen - c,
> -							mpp, 2);
> +	vector_foreach_slot(vecs->mpvec, mpp, i) {
> +		if (update_multipath(vecs, mpp->alias, 0)) {
> +			i--;
> +			continue;
>  		}
> -		c += snprint_foreign_topology(c, reply + maxlen - c, 2);
> -
> -		again = (c == reply + maxlen - 1);
> -
> -		REALLOC_REPLY(reply, again, maxlen);
> +		if (snprint_multipath_topology(&reply, mpp, 2) < 0)
> +			return 1;
>  	}
> +	if (snprint_foreign_topology(&reply, 2) < 0)
> +		return 1;
>  
> -	*r = reply;
> -	*len = (int)(c - reply + 1);
> +	*len = (int)get_strbuf_len(&reply) + 1;
> +	*r = steal_strbuf_str(&reply);
>  	return 0;
>  }
>  
>  int
>  show_maps_json (char ** r, int * len, struct vectors * vecs)
>  {
> +	STRBUF_ON_STACK(reply);
>  	int i;
>  	struct multipath * mpp;
> -	char * c;
> -	char * reply;
> -	unsigned int maxlen = INITIAL_REPLY_LEN;
> -	int again = 1;
> -
> -	if (VECTOR_SIZE(vecs->mpvec) > 0)
> -		maxlen *= PRINT_JSON_MULTIPLIER * VECTOR_SIZE(vecs->mpvec);
>  
>  	vector_foreach_slot(vecs->mpvec, mpp, i) {
>  		if (update_multipath(vecs, mpp->alias, 0)) {
> @@ -206,21 +141,11 @@ show_maps_json (char ** r, int * len, struct vectors * vecs)
>  		}
>  	}
>  
> -	reply = MALLOC(maxlen);
> -
> -	while (again) {
> -		if (!reply)
> -			return 1;
> -
> -		c = reply;
> -
> -		c += snprint_multipath_topology_json(c, maxlen, vecs);
> -		again = (c == reply + maxlen);
> +	if (snprint_multipath_topology_json(&reply, vecs) < 0)
> +		return 1;
>  
> -		REALLOC_REPLY(reply, again, maxlen);
> -	}
> -	*r = reply;
> -	*len = (int)(c - reply);
> +	*len = (int)get_strbuf_len(&reply) + 1;
> +	*r = steal_strbuf_str(&reply);
>  	return 0;
>  }
>  
> @@ -228,28 +153,16 @@ int
>  show_map_json (char ** r, int * len, struct multipath * mpp,
>  		   struct vectors * vecs)
>  {
> -	char * c;
> -	char * reply;
> -	unsigned int maxlen = INITIAL_REPLY_LEN;
> -	int again = 1;
> +	STRBUF_ON_STACK(reply);
>  
>  	if (update_multipath(vecs, mpp->alias, 0))
>  		return 1;
> -	reply = MALLOC(maxlen);
> -
> -	while (again) {
> -		if (!reply)
> -			return 1;
>  
> -		c = reply;
> -
> -		c += snprint_multipath_map_json(c, maxlen, mpp);
> -		again = (c == reply + maxlen);
> +	if (snprint_multipath_map_json(&reply, mpp) < 0)
> +		return 1;
>  
> -		REALLOC_REPLY(reply, again, maxlen);
> -	}
> -	*r = reply;
> -	*len = (int)(c - reply);
> +	*len = (int)get_strbuf_len(&reply) + 1;
> +	*r = steal_strbuf_str(&reply);
>  	return 0;
>  }
>  
> @@ -420,58 +333,40 @@ cli_list_maps_json (void * v, char ** reply, int * len, void * data)
>  int
>  cli_list_wildcards (void * v, char ** reply, int * len, void * data)
>  {
> -	char * c;
> -
> -	*reply = MALLOC(INITIAL_REPLY_LEN);
> +	STRBUF_ON_STACK(buf);
>  
> -	if (!*reply)
> +	if (snprint_wildcards(&buf) < 0)
>  		return 1;
>  
> -	c = *reply;
> -	c += snprint_wildcards(c, INITIAL_REPLY_LEN);
> -
> -	*len = INITIAL_REPLY_LEN;
> +	*len = get_strbuf_len(&buf) + 1;
> +	*reply = steal_strbuf_str(&buf);
>  	return 0;
>  }
>  
>  int
>  show_status (char ** r, int *len, struct vectors * vecs)
>  {
> -	char * c;
> -	char * reply;
> -
> -	unsigned int maxlen = INITIAL_REPLY_LEN;
> -	reply = MALLOC(maxlen);
> +	STRBUF_ON_STACK(reply);
>  
> -	if (!reply)
> +	if (snprint_status(&reply, vecs) < 0)
>  		return 1;
>  
> -	c = reply;
> -	c += snprint_status(c, reply + maxlen - c, vecs);
> -
> -	*r = reply;
> -	*len = (int)(c - reply + 1);
> +	*len = get_strbuf_len(&reply) + 1;
> +	*r = steal_strbuf_str(&reply);
>  	return 0;
>  }
>  
>  int
>  show_daemon (char ** r, int *len)
>  {
> -	char * c;
> -	char * reply;
> -
> -	unsigned int maxlen = INITIAL_REPLY_LEN;
> -	reply = MALLOC(maxlen);
> +	STRBUF_ON_STACK(reply);
>  
> -	if (!reply)
> +	if (print_strbuf(&reply, "pid %d %s\n",
> +			 daemon_pid, daemon_status()) < 0)
>  		return 1;
>  
> -	c = reply;
> -	c += snprintf(c, INITIAL_REPLY_LEN, "pid %d %s\n",
> -		      daemon_pid, daemon_status());
> -
> -	*r = reply;
> -	*len = (int)(c - reply + 1);
> +	*len = get_strbuf_len(&reply) + 1;
> +	*r = steal_strbuf_str(&reply);
>  	return 0;
>  }
>  
> @@ -479,26 +374,13 @@ int
>  show_map (char ** r, int *len, struct multipath * mpp, char * style,
>  	  int pretty)
>  {
> -	char * c;
> -	char * reply;
> -	unsigned int maxlen = INITIAL_REPLY_LEN;
> -	int again = 1;
> -
> -	reply = MALLOC(maxlen);
> -	while (again) {
> -		if (!reply)
> -			return 1;
> +	STRBUF_ON_STACK(reply);
>  
> -		c = reply;
> -		c += snprint_multipath(c, reply + maxlen - c, style,
> -				       mpp, pretty);
> -
> -		again = (c == reply + maxlen - 1);
> +	if (snprint_multipath(&reply, style, mpp, pretty) < 0)
> +		return 1;
>  
> -		REALLOC_REPLY(reply, again, maxlen);
> -	}
> -	*r = reply;
> -	*len = (int)(c - reply + 1);
> +	*len = get_strbuf_len(&reply) + 1;
> +	*r = steal_strbuf_str(&reply);
>  	return 0;
>  }
>  
> @@ -506,51 +388,34 @@ int
>  show_maps (char ** r, int *len, struct vectors * vecs, char * style,
>  	   int pretty)
>  {
> +	STRBUF_ON_STACK(reply);
>  	int i;
>  	struct multipath * mpp;
> -	char * c, *header;
> -	char * reply;
> -	unsigned int maxlen = INITIAL_REPLY_LEN;
> -	int again = 1;
> +	int hdr_len = 0;
>  
>  	get_multipath_layout(vecs->mpvec, 1);
>  	foreign_multipath_layout();
>  
> -	reply = MALLOC(maxlen);
> -
> -	while (again) {
> -		if (!reply)
> -			return 1;
> -
> -		c = reply;
> -		if (pretty)
> -			c += snprint_multipath_header(c, reply + maxlen - c,
> -						      style);
> -		header = c;
> -
> -		vector_foreach_slot(vecs->mpvec, mpp, i) {
> -			if (update_multipath(vecs, mpp->alias, 0)) {
> -				i--;
> -				continue;
> -			}
> -			c += snprint_multipath(c, reply + maxlen - c,
> -					       style, mpp, pretty);
> +	if (pretty && (hdr_len = snprint_multipath_header(&reply, style)) < 0)
> +		return 1;
>  
> +	vector_foreach_slot(vecs->mpvec, mpp, i) {
> +		if (update_multipath(vecs, mpp->alias, 0)) {
> +			i--;
> +			continue;
>  		}
> -		c += snprint_foreign_multipaths(c, reply + maxlen - c,
> -						style, pretty);
> -		again = (c == reply + maxlen - 1);
> -
> -		REALLOC_REPLY(reply, again, maxlen);
> +		if (snprint_multipath(&reply, style, mpp, pretty) < 0)
> +			return 1;
>  	}
> +	if (snprint_foreign_multipaths(&reply, style, pretty) < 0)
> +		return 1;
>  
> -	if (pretty && c == header) {
> +	if (pretty && get_strbuf_len(&reply) == (size_t)hdr_len)
>  		/* No output - clear header */
> -		*reply = '\0';
> -		c = reply;
> -	}
> -	*r = reply;
> -	*len = (int)(c - reply + 1);
> +		truncate_strbuf(&reply, 0);
> +
> +	*len = (int)get_strbuf_len(&reply) + 1;
> +	*r = steal_strbuf_str(&reply);
>  	return 0;
>  }
>  
> @@ -1366,34 +1231,20 @@ cli_fail(void * v, char ** reply, int * len, void * data)
>  int
>  show_blacklist (char ** r, int * len)
>  {
> -	char *c = NULL;
> -	char *reply = NULL;
> -	unsigned int maxlen = INITIAL_REPLY_LEN;
> -	int again = 1;
> +	STRBUF_ON_STACK(reply);
>  	struct config *conf;
> -	int fail = 0;
> -
> -	reply = MALLOC(maxlen);
> +	bool fail;
>  
>  	conf = get_multipath_config();
>  	pthread_cleanup_push(put_multipath_config, conf);
> -	while (again) {
> -		if (!reply) {
> -			fail = 1;
> -			break;
> -		}
> -
> -		c = reply;
> -		c += snprint_blacklist_report(conf, c, maxlen);
> -		again = (c == reply + maxlen);
> -		REALLOC_REPLY(reply, again, maxlen);
> -	}
> +	fail = snprint_blacklist_report(conf, &reply) < 0;
>  	pthread_cleanup_pop(1);
>  
>  	if (fail)
>  		return 1;
> -	*r = reply;
> -	*len = (int)(c - reply + 1);
> +
> +	*len = (int)get_strbuf_len(&reply) + 1;
> +	*r = steal_strbuf_str(&reply);
>  	return 0;
>  }
>  
> @@ -1408,34 +1259,20 @@ cli_list_blacklist (void * v, char ** reply, int * len, void * data)
>  int
>  show_devices (char ** r, int * len, struct vectors *vecs)
>  {
> -	char *c = NULL;
> -	char *reply = NULL;
> -	unsigned int maxlen = INITIAL_REPLY_LEN;
> -	int again = 1;
> +	STRBUF_ON_STACK(reply);
>  	struct config *conf;
> -	int fail = 0;
> -
> -	reply = MALLOC(maxlen);
> +	bool fail;
>  
>  	conf = get_multipath_config();
>  	pthread_cleanup_push(put_multipath_config, conf);
> -	while (again) {
> -		if (!reply) {
> -			fail = 1;
> -			break;
> -		}
> -
> -		c = reply;
> -		c += snprint_devices(conf, c, maxlen, vecs);
> -		again = (c == reply + maxlen);
> -		REALLOC_REPLY(reply, again, maxlen);
> -	}
> +	fail = snprint_devices(conf, &reply, vecs) < 0;
>  	pthread_cleanup_pop(1);
>  
>  	if (fail)
>  		return 1;
> -	*r = reply;
> -	*len = (int)(c - reply + 1);
> +
> +	*len = (int)get_strbuf_len(&reply) + 1;
> +	*r = steal_strbuf_str(&reply);
>  
>  	return 0;
>  }
> -- 
> 2.32.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

