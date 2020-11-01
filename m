Return-Path: <SRS0=fTgt=EH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDCFCC2D0A3
	for <dm-devel@archiver.kernel.org>; Sun,  1 Nov 2020 20:05:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 21DFD20756
	for <dm-devel@archiver.kernel.org>; Sun,  1 Nov 2020 20:05:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 21DFD20756
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-FF0ET5x3Nn23upe-tX72dQ-1; Sun, 01 Nov 2020 15:04:59 -0500
X-MC-Unique: FF0ET5x3Nn23upe-tX72dQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A195456C8B;
	Sun,  1 Nov 2020 20:04:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BE90A60BE2;
	Sun,  1 Nov 2020 20:04:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 67E2D79FF7;
	Sun,  1 Nov 2020 20:04:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A1K4bJG013620 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 1 Nov 2020 15:04:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 18B3D2166B44; Sun,  1 Nov 2020 20:04:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1379C2166B27
	for <dm-devel@redhat.com>; Sun,  1 Nov 2020 20:04:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AA6E7811E76
	for <dm-devel@redhat.com>; Sun,  1 Nov 2020 20:04:34 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-376-XNqNHl1AMj6549L1f4Qshg-1;
	Sun, 01 Nov 2020 15:04:32 -0500
X-MC-Unique: XNqNHl1AMj6549L1f4Qshg-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id E5D5BABA2;
	Sun,  1 Nov 2020 20:04:30 +0000 (UTC)
Message-ID: <7f4147bc81674e7bdb326bf626466c17b464b98f.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: lixiaokeng <lixiaokeng@huawei.com>, Christophe Varoqui
	<christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel mailing list <dm-devel@redhat.com>
Date: Sun, 01 Nov 2020 21:04:29 +0100
In-Reply-To: <78410089-7318-688e-89a4-b82ee86791bc@huawei.com>
References: <78410089-7318-688e-89a4-b82ee86791bc@huawei.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Subject: Re: [dm-devel] [PATCH] libmultipath: call udev_device_unref before
	return
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, 2020-10-22 at 15:30 +0800, lixiaokeng wrote:
> There is a bug in commit acff7d4. Before return, we should call
> udev_device_unref(hostdev) in sysfs_get_tgt_nodenam.
> 
> Signed-off_by:lixiaokeng <lxiiaokeng@huawei.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>


> ---
>  libmultipath/discovery.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 193d7127..c2e1754c 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -518,8 +518,10 @@ int sysfs_get_host_pci_name(const struct path
> *pp, char *pci_name)
>  		 */
>  		value = udev_device_get_sysname(parent);
> 
> -		if (!value)
> +		if (!value) {
> +			udev_device_unref(hostdev);
>  			return 1;
> +		}
> 
>  		strncpy(pci_name, value, SLOT_NAME_SIZE);
>  		udev_device_unref(hostdev);


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

