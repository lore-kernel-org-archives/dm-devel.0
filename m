Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DE33C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 18 Mar 2022 22:43:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-66-6ULcO57rPL2bgUVaT5sUCA-1; Fri, 18 Mar 2022 18:42:56 -0400
X-MC-Unique: 6ULcO57rPL2bgUVaT5sUCA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0A0943803926;
	Fri, 18 Mar 2022 22:42:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AB0FA40679D;
	Fri, 18 Mar 2022 22:42:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 57AC41940373;
	Fri, 18 Mar 2022 22:42:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D1AD3194035B
 for <dm-devel@listman.corp.redhat.com>; Fri, 18 Mar 2022 22:42:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AD04E41F378; Fri, 18 Mar 2022 22:42:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A92A840679D
 for <dm-devel@redhat.com>; Fri, 18 Mar 2022 22:42:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8BFDD3C02B89
 for <dm-devel@redhat.com>; Fri, 18 Mar 2022 22:42:53 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-25-g-xRUFIHNM2lliFLVfuSuw-1; Fri, 18 Mar 2022 18:42:49 -0400
X-MC-Unique: g-xRUFIHNM2lliFLVfuSuw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 6C49B1F37C;
 Fri, 18 Mar 2022 22:42:48 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 108DA132C1;
 Fri, 18 Mar 2022 22:42:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id +XWTAegKNWJSegAAMHmgww
 (envelope-from <mwilck@suse.com>); Fri, 18 Mar 2022 22:42:48 +0000
Message-ID: <070c14f1a5e3a57bb45579991447d3267375e48f.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Jes Sorensen <jsorensen@fb.com>, NeilBrown <neilb@suse.de>
Date: Fri, 18 Mar 2022 23:42:47 +0100
In-Reply-To: <ff8030340e30963a1772f43e8bdfb6b610219887.camel@suse.com>
References: <20220216205914.7575-1-mwilck@suse.com>
 , <164504936873.10228.7361167610237544463@noble.neil.brown.name>
 , <e8720e3f8734cbad1af34d5e54afc47ba3ef1b8f.camel@suse.com>
 , <20220217130934.lh2b33255kyx2pax@alatyr-rpi.brq.redhat.com>
 , <164548656531.8827.3365536065813085321@noble.neil.brown.name>
 , <4b61ca1eafb35e3fdfbc9bb260dc89d56d181499.camel@suse.com>
 <164557016782.28944.17731814770525408828@noble.neil.brown.name>
 <ff8030340e30963a1772f43e8bdfb6b610219887.camel@suse.com>
User-Agent: Evolution 3.42.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH] udev-md-raid-assembly.rules: skip if
 DM_UDEV_DISABLE_OTHER_RULES_FLAG
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
Cc: Coly Li <colyli@suse.com>, Peter Rajnoha <prajnoha@redhat.com>,
 lvm-devel@redhat.com, linux-raid@vger.kernel.org, dm-devel@redhat.com,
 Heming Zhao <heming.zhao@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Jes,

On Mon, 2022-02-28 at 09:48 +0100, Martin Wilck wrote:
> On Wed, 2022-02-23 at 09:49 +1100, NeilBrown wrote:
> > 
> > But if libdevmapper.h is the best you have, then maybe it'll have
> > to
> > do.
> > It is up to Jes what he accepts of course.
> 
> Jes, have you made up your mind on this patch yet?
> Please contact me if you have remarks or questions.

Gentle reminder ...

Regards
Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

