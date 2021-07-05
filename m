Return-Path: <SRS0=a4Wy=L5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03FE6C07E99
	for <dm-devel@archiver.kernel.org>; Mon,  5 Jul 2021 13:20:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7C36661447
	for <dm-devel@archiver.kernel.org>; Mon,  5 Jul 2021 13:20:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7C36661447
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-CJG35XyjOMOpduErhchU6w-1; Mon, 05 Jul 2021 09:20:07 -0400
X-MC-Unique: CJG35XyjOMOpduErhchU6w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B59B518D6A31;
	Mon,  5 Jul 2021 13:20:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 30A3A6267C;
	Mon,  5 Jul 2021 13:20:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 32C014A712;
	Mon,  5 Jul 2021 13:20:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 165DJvmh020666 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 5 Jul 2021 09:19:57 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 82C6A5F253; Mon,  5 Jul 2021 13:19:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7CB975EDE2
	for <dm-devel@redhat.com>; Mon,  5 Jul 2021 13:19:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6C8181857F0E
	for <dm-devel@redhat.com>; Mon,  5 Jul 2021 13:19:50 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-311-YpsG3a_jOjS7mT9cpnslfw-1; Mon, 05 Jul 2021 09:19:48 -0400
X-MC-Unique: YpsG3a_jOjS7mT9cpnslfw-1
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D14FE1FE7F;
	Mon,  5 Jul 2021 13:11:31 +0000 (UTC)
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 5D3EE13790;
	Mon,  5 Jul 2021 13:11:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap1.suse-dmz.suse.de with ESMTPSA id +jCSFQMF42CrKgAAGKfGzw
	(envelope-from <hare@suse.de>); Mon, 05 Jul 2021 13:11:31 +0000
To: Paolo Bonzini <pbonzini@redhat.com>, Martin Wilck <mwilck@suse.com>,
	Christoph Hellwig <hch@lst.de>
References: <20210628151558.2289-1-mwilck@suse.com>
	<20210628151558.2289-4-mwilck@suse.com> <20210701075629.GA25768@lst.de>
	<de1e3dcbd26a4c680b27b557ea5384ba40fc7575.camel@suse.com>
	<20210701113442.GA10793@lst.de>
	<003727e7a195cb0f525cc2d7abda3a19ff16eb98.camel@suse.com>
	<e6d76740-e0ed-861a-ef0c-959e738c3ef5@redhat.com>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <5909eff8-82fb-039e-41d3-1612c22498a9@suse.de>
Date: Mon, 5 Jul 2021 15:11:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <e6d76740-e0ed-861a-ef0c-959e738c3ef5@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 165DJvmh020666
X-loop: dm-devel@redhat.com
Cc: linux-scsi@vger.kernel.org, Daniel Wagner <dwagner@suse.de>,
	Mike Snitzer <snitzer@redhat.com>, emilne@redhat.com,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	nkoenig@redhat.com, Bart Van Assche <Bart.VanAssche@sandisk.com>,
	Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v5 3/3] dm mpath: add
 CONFIG_DM_MULTIPATH_SG_IO - failover for SG_IO
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
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-15"; Format="flowed"

On 7/5/21 3:02 PM, Paolo Bonzini wrote:
> On 02/07/21 16:21, Martin Wilck wrote:
>>> SG_IO gives you raw access to the SCSI logic unit, and you get to
>>> keep the pieces if anything goes wrong.
>>
>> That's a very fragile user space API, on the fringe of being useless
>> IMO.
>=20
> Indeed.=A0 If SG_IO is for raw access to an ITL nexus, it shouldn't be
> supported at all by mpath devices.=A0 If on the other hand SG_IO is for
> raw access to a LUN, there is no reason for it to not support failover.
>=20
Or we look at IO_URING_OP_URING_CMD, to send raw cdbs via io_uring.
And delegate SG_IO to raw access to an ITL nexus.
Doesn't help with existing issues, but should get a clean way forward.

... I think I've even tendered a topic at LSF for this ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
HRB 36809 (AG N=FCrnberg), Gesch=E4ftsf=FChrer: Felix Imend=F6rffer


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

