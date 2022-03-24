Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8BEAC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 24 Mar 2022 09:21:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-634-ga-KZx4zOUeMVeYMaqTeLA-1; Thu, 24 Mar 2022 05:21:47 -0400
X-MC-Unique: ga-KZx4zOUeMVeYMaqTeLA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B1DBE3C14852;
	Thu, 24 Mar 2022 09:21:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4F8CC111F3C1;
	Thu, 24 Mar 2022 09:21:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 03173194034B;
	Thu, 24 Mar 2022 09:21:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DEDB21940347
 for <dm-devel@listman.corp.redhat.com>; Thu, 24 Mar 2022 09:21:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AAECA400F8C2; Thu, 24 Mar 2022 09:21:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A724340D2853
 for <dm-devel@redhat.com>; Thu, 24 Mar 2022 09:21:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8DC56811E83
 for <dm-devel@redhat.com>; Thu, 24 Mar 2022 09:21:40 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-101-q2QawscLNhWCkG2uBjzuPg-1; Thu, 24 Mar 2022 05:21:38 -0400
X-MC-Unique: q2QawscLNhWCkG2uBjzuPg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 591091F387;
 Thu, 24 Mar 2022 09:21:37 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1FE4413AA8;
 Thu, 24 Mar 2022 09:21:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id KK+qBSE4PGL/MgAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 24 Mar 2022 09:21:37 +0000
Message-ID: <3fdc891239f9c45f8b4c034eae9ded9572f2a0ad.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Uday Shankar <ushankar@purestorage.com>
Date: Thu, 24 Mar 2022 10:21:36 +0100
In-Reply-To: <20220323231023.GL24684@octiron.msp.redhat.com>
References: <20220309200325.2490463-1-ushankar@purestorage.com>
 <20220323231023.GL24684@octiron.msp.redhat.com>
User-Agent: Evolution 3.42.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH] multipath-tools: update mpp->force_readonly
 in ev_add_path
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2022-03-23 at 18:10 -0500, Benjamin Marzinski wrote:
> On Wed, Mar 09, 2022 at 01:03:26PM -0700, Uday Shankar wrote:
> > When NVMe disks are added to the system, no uevent containing the
> > DISK_RO property is generated. As a result, dm-* nodes backed by
> > readonly NVMe disks will not have their RO state set properly. The
> > result looks like this:
> >=20
> > $ multipath -l
> > eui.00c92c091fd6564424a9376600011bd1 dm-3 NVME,Pure Storage
> > FlashArray
> > size=3D1.0T features=3D'0' hwhandler=3D'0' wp=3Drw
> > > -+- policy=3D'service-time 0' prio=3D0 status=3Dactive
> > > `- 0:2:2:72657 nvme0n2 259:4 active undef running
> > `-+- policy=3D'service-time 0' prio=3D0 status=3Denabled
> > =A0 `- 1:0:2:72657 nvme1n2 259:1 active undef running
> > $ cat /sys/block/dm-3/ro
> > 0
> > $ cat /sys/block/nvme*n2/ro
> > 1
> > 1
> >=20
> > This is not a problem for SCSI disks, since the kernel will emit
> > change
> > uevents containing the DISK_RO property when the disk is added to
> > the
> > system. See the following thread for my initial attempt to fix this
> > issue at the kernel level:
> > https://lore.kernel.org/linux-block/Yib8GqCA5e3SQYty@infradead.org/T/#t
> >=20
> > Fix the issue by picking up the path ro state from sysfs in
> > ev_add_path,
> > setting the mpp->force_readonly accordingly, and changing
> > dm_addmap_create to be aware of mpp->force_readonly.
> >=20
> > Signed-off-by: Uday Shankar <ushankar@purestorage.com>
>=20
> Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

Thanks, applied to
https://github.com/openSUSE/multipath-tools/tree/queue

Martin

(Please set me on CC next time to speed up review).

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

