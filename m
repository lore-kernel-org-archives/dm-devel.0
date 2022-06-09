Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19CAFC43334
	for <dm-devel@archiver.kernel.org>; Thu,  9 Jun 2022 16:49:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-251-b9bVTHBwPJywn8iuFmWFdg-1; Thu, 09 Jun 2022 12:49:08 -0400
X-MC-Unique: b9bVTHBwPJywn8iuFmWFdg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 01C31101E167;
	Thu,  9 Jun 2022 16:49:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AFA6FC53361;
	Thu,  9 Jun 2022 16:49:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 71BA9194705E;
	Thu,  9 Jun 2022 16:49:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1AC5D1947040
 for <dm-devel@listman.corp.redhat.com>; Thu,  9 Jun 2022 16:49:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F0ECEC53361; Thu,  9 Jun 2022 16:49:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id ECC5FC53360
 for <dm-devel@redhat.com>; Thu,  9 Jun 2022 16:49:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D4BBB294EDDD
 for <dm-devel@redhat.com>; Thu,  9 Jun 2022 16:49:04 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-550-mHNsE1PHNEGe_j-qRbhfhQ-1; Thu, 09 Jun 2022 12:49:03 -0400
X-MC-Unique: mHNsE1PHNEGe_j-qRbhfhQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id BB7211FEB4;
 Thu,  9 Jun 2022 16:49:01 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 731CD13A8C;
 Thu,  9 Jun 2022 16:49:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id QK+KGn0komIaLQAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 09 Jun 2022 16:49:01 +0000
Message-ID: <8ab798a93edf33a550f0c78f113d8943d76916b6.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>, "Schremmer, Steven"
 <Steve.Schremmer@netapp.com>
Date: Thu, 09 Jun 2022 18:49:00 +0200
In-Reply-To: <f29d01dd-676d-0d1e-77b0-df951fb7f99a@gmail.com>
References: <20220514230148.139675-1-xose.vazquez@gmail.com>
 <20220514230148.139675-5-xose.vazquez@gmail.com>
 <SN6PR06MB4495FAEC26D7A272C2DEDA498CD19@SN6PR06MB4495.namprd06.prod.outlook.com>
 <e014a5ee6e313404bb4d1d29c1cd4791f9660c5e.camel@suse.com>
 <SN6PR06MB44955631FFA648B74BB939318CD09@SN6PR06MB4495.namprd06.prod.outlook.com>
 <6d6f31c7e9c03eead93cc5b528bcd8979446fc91.camel@suse.com>
 <SN6PR06MB4495843B676A209F9AA0085A8CD99@SN6PR06MB4495.namprd06.prod.outlook.com>
 <f29d01dd-676d-0d1e-77b0-df951fb7f99a@gmail.com>
User-Agent: Evolution 3.44.2
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH 4/9] multipath-tools: add NetApp E-Series
 NVMe to hardware table
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
Cc: "George, Martin" <Martin.George@netapp.com>,
 Hannes Reinecke <hare@suse.com>,
 ng-eseries-upstream-maintainers <ng-eseries-upstream-maintainers@netapp.com>,
 DM-DEVEL ML <dm-devel@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Xose,

On Thu, 2022-06-09 at 18:36 +0200, Xose Vazquez Perez wrote:
> On 5/26/22 22:10, Schremmer, Steven wrote:
> 
> > Sorry for being slow to respond to this. NetApp publishes settings
> > for
> > multipath-tools for NVMe-attach E-Series for specific distribution
> > versions
> > that we have qualified. Anyone using these settings outside of
> > these
> > versions would NOT be in a valid system configuration for NetApp
> > support. Are
> > reasonable defaults in the hardware table really useful if they
> > cause a user
> > to follow a path that leads them to an unsupported system
> > configuration?
> 
> Do you(@NetApp crew) realize that the "NVME/.*" prod/vendor was added
> more than five years ago:
> https://github.com/opensvc/multipath-tools/commit/4dd25783e13909cba0c38ed8bfedf76dc5a38c7b#diff-eeab98c4bb0459858e2ad17c9aa77ea30ee7a900e16cddb5325b9984b1694021
> 
> Your argument doesn't make any sense.

IIUC NetApp's concern is not the generic entry, but the entries
mentioning E-Series or it's OEM products in NVMe configuration
explicitly. I also have some trouble understanding the concern, but
NetApp is in charge of these entries, so I believe we should respect
what they're saying.

With the late patches I submitted, the generic NVMe defaults would work
for the NetApp devices without those being explicitly mentioned. I hope
this is ok for everyone. Only the no_path_retry setting would get lost,
which is acceptable IMO because this is rather an admin setting than
product-specific.

Regards
Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

