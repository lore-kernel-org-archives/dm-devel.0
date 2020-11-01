Return-Path: <SRS0=fTgt=EH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0CE6C2D0A3
	for <dm-devel@archiver.kernel.org>; Sun,  1 Nov 2020 21:23:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3425D22246
	for <dm-devel@archiver.kernel.org>; Sun,  1 Nov 2020 21:23:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3425D22246
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-5IPJsN9wPzyjk-pAlhFo_Q-1; Sun, 01 Nov 2020 16:23:50 -0500
X-MC-Unique: 5IPJsN9wPzyjk-pAlhFo_Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 90D9956C8B;
	Sun,  1 Nov 2020 21:23:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7C3DF5B4A0;
	Sun,  1 Nov 2020 21:23:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 559748C7A7;
	Sun,  1 Nov 2020 21:23:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A1LNcVG023184 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 1 Nov 2020 16:23:38 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1268A42AB8; Sun,  1 Nov 2020 21:23:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0C2394241B
	for <dm-devel@redhat.com>; Sun,  1 Nov 2020 21:23:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B8345811E78
	for <dm-devel@redhat.com>; Sun,  1 Nov 2020 21:23:35 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-373-WreUKCvGNcCZqoEt9RKWBw-1;
	Sun, 01 Nov 2020 16:23:30 -0500
X-MC-Unique: WreUKCvGNcCZqoEt9RKWBw-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 201D2AEEF;
	Sun,  1 Nov 2020 21:23:29 +0000 (UTC)
Message-ID: <ad0e21d3cfe99c0361effe4d9b9c177ca1998e7f.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: lixiaokeng <lixiaokeng@huawei.com>, Christophe Varoqui
	<christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel mailing list <dm-devel@redhat.com>
Date: Sun, 01 Nov 2020 22:23:27 +0100
In-Reply-To: <adb9eb05-0597-5027-701d-861e273da9e4@huawei.com>
References: <adb9eb05-0597-5027-701d-861e273da9e4@huawei.com>
User-Agent: Evolution 3.36.5
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Subject: Re: [dm-devel] [PATCH v2] libmultipath: fix memory leaks in
	coalesce_paths
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi lixiaokeng,

On Thu, 2020-10-22 at 15:28 +0800, lixiaokeng wrote:
> When multipath -F are executed first and multipath -v2 or
> -d are executed later, asan will warn memory leaks. The
> reason is that the mpp allocated in coalesce_paths isn't
> freed. Here we use newmp to store mpp. If newmp need not
> be copied to mpvec, we free newmp at the end of the func.
> 
> Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Signed-off-by: Linfeilong <linfeilong@huawei.com>

Thanks. Please see below.

> ---
>  libmultipath/configure.c | 66 +++++++++++++++++++++++++-------------
> --
>  1 file changed, 41 insertions(+), 25 deletions(-)
> 
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index 6fb477fc..9d6eeba1 100644
> --- a/libmultipath/configure.c
> +++ b/libmultipath/configure.c
> @@ -1132,7 +1132,7 @@ out:
>   * FORCE_RELOAD_WEAK: existing maps are compared to the current conf
> and only
>   * reloaded in DM if there's a difference. This is useful during
> startup.
>   */
> -int coalesce_paths (struct vectors * vecs, vector newmp, char *
> refwwid,
> +int coalesce_paths (struct vectors *vecs, vector mpvec, char
> *refwwid,
>  		    int force_reload, enum mpath_cmds cmd)
>  {
>  	int ret = CP_FAIL;
> @@ -1144,10 +1144,20 @@ int coalesce_paths (struct vectors * vecs,
> vector newmp, char * refwwid,
>  	struct path * pp2;
>  	vector curmp = vecs->mpvec;
>  	vector pathvec = vecs->pathvec;
> +	vector newmp = NULL;

This initialization is not necessary.

>  	struct config *conf;
>  	int allow_queueing;
>  	struct bitfield *size_mismatch_seen;
> 
> +	if (mpvec)
> +		newmp = mpvec;
> +	else
> +		newmp = vector_alloc();
> +	if (!newmp) {
> +		condlog(0, "can not allocate newmp");
> +		return ret;
> +	}
> +
>  	/* ignore refwwid if it's empty */
>  	if (refwwid && !strlen(refwwid))
>  		refwwid = NULL;
> @@ -1270,8 +1280,14 @@ int coalesce_paths (struct vectors * vecs,
> vector newmp, char * refwwid,
>  				goto out;
>  			}
>  		}
> -		if (r == DOMAP_DRY)
> +		if (r == DOMAP_DRY) {
> +			if (!vector_alloc_slot(newmp)) {
> +				remove_map(mpp, vecs->pathvec, vecs-
> >mpvec, KEEP_VEC);
> +				goto out;
> +			}
> +			vector_set_slot(newmp, mpp);
>  			continue;
> +		}
> 
>  		if (r == DOMAP_EXIST && mpp->action == ACT_NOTHING &&
>  		    force_reload == FORCE_RELOAD_WEAK)
> @@ -1307,44 +1323,44 @@ int coalesce_paths (struct vectors * vecs,
> vector newmp, char * refwwid,
>  			print_multipath_topology(mpp, verbosity);
>  		}
> 
> -		if (newmp) {
> -			if (mpp->action != ACT_REJECT) {
> -				if (!vector_alloc_slot(newmp))
> -					goto out;
> -				vector_set_slot(newmp, mpp);
> +		if (mpp->action != ACT_REJECT) {
> +			if (!vector_alloc_slot(newmp)) {
> +				remove_map(mpp, vecs->pathvec, vecs-
> >mpvec, KEEP_VEC);
> +				goto out;
>  			}
> -			else
> -				remove_map(mpp, vecs->pathvec, vecs-
> >mpvec,
> -					   KEEP_VEC);
> +			vector_set_slot(newmp, mpp);
>  		}
> +		else
> +			remove_map(mpp, vecs->pathvec, vecs->mpvec,
> +				   KEEP_VEC);
>  	}
>  	/*
>  	 * Flush maps with only dead paths (ie not in sysfs)
>  	 * Keep maps with only failed paths
>  	 */
> -	if (newmp) {
> -		vector_foreach_slot (newmp, mpp, i) {
> -			char alias[WWID_SIZE];
> +	vector_foreach_slot (newmp, mpp, i) {
> +		char alias[WWID_SIZE];
> 
> -			if (!deadmap(mpp))
> -				continue;
> +		if (!deadmap(mpp))
> +			continue;
> 
> -			strlcpy(alias, mpp->alias, WWID_SIZE);
> +		strlcpy(alias, mpp->alias, WWID_SIZE);
> 
> -			vector_del_slot(newmp, i);
> -			i--;
> -			remove_map(mpp, vecs->pathvec, vecs->mpvec,
> KEEP_VEC);
> +		vector_del_slot(newmp, i);
> +		i--;
> +		remove_map(mpp, vecs->pathvec, vecs->mpvec, KEEP_VEC);
> 
> -			if (dm_flush_map(alias))
> -				condlog(2, "%s: remove failed (dead)",
> -					alias);
> -			else
> -				condlog(2, "%s: remove (dead)", alias);
> -		}
> +		if (dm_flush_map(alias))
> +			condlog(2, "%s: remove failed (dead)",
> +				alias);
> +		else
> +			condlog(2, "%s: remove (dead)", alias);

Previously, this code, which flushes maps that aren't valid any more,
would only be called from multipathd() -> reconfigure(), because in all
other cases newmp was NULL.

AFAICS, you will now call dm_flush_map() even if called with
newmp==NULL (this means, from cli_add_map(), or from multipath, even if
called with CMD_DRY_RUN). I don't think that's what we want.

Regards,
Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

