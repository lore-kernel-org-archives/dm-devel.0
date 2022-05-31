Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A55B0C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 31 May 2022 20:41:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-317-QOzHcpf9O5mQwRFKlxxw_A-1; Tue, 31 May 2022 16:41:20 -0400
X-MC-Unique: QOzHcpf9O5mQwRFKlxxw_A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5DFE280B712;
	Tue, 31 May 2022 20:41:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4909E2026D07;
	Tue, 31 May 2022 20:41:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B5C26194706A;
	Tue, 31 May 2022 20:41:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8306F1947065
 for <dm-devel@listman.corp.redhat.com>; Tue, 31 May 2022 20:41:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2EC3C2026D07; Tue, 31 May 2022 20:41:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2A42E2026D64
 for <dm-devel@redhat.com>; Tue, 31 May 2022 20:41:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0DFF5296A603
 for <dm-devel@redhat.com>; Tue, 31 May 2022 20:41:16 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-332-T5ECbzisPmqImyK7a3OD1A-1; Tue, 31 May 2022 16:41:12 -0400
X-MC-Unique: T5ECbzisPmqImyK7a3OD1A-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 06F9D1F390;
 Tue, 31 May 2022 20:41:11 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D4ED6132F9;
 Tue, 31 May 2022 20:41:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id VVRgMmZ9lmL3VgAAMHmgww
 (envelope-from <mwilck@suse.com>); Tue, 31 May 2022 20:41:10 +0000
Message-ID: <7b2d927dfc729a21a92c80eafe021198af3e8fa2.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Fabrice Fontaine <fontaine.fabrice@gmail.com>, dm-devel@redhat.com
Date: Tue, 31 May 2022 22:41:10 +0200
In-Reply-To: <20220531161230.3820698-1-fontaine.fabrice@gmail.com>
References: <20220531161230.3820698-1-fontaine.fabrice@gmail.com>
User-Agent: Evolution 3.44.1
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH] multipathd/fpin_handlers.c: include stdint.h
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2022-05-31 at 18:12 +0200, Fabrice Fontaine wrote:
> Include stdint.h to avoid the following build failure since version
> 0.8.9 and commit cfff03efbca753ef485ad717087464dced9c721a:
>=20
> In file included from /nvmedata/autobuild/instance-7/output-
> 1/host/nios2-buildroot-linux-
> gnu/sysroot/usr/include/scsi/scsi_netlink_fc.h:25,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 from fpin_handlers.c:6:
> /nvmedata/autobuild/instance-7/output-1/host/nios2-buildroot-linux-
> gnu/sysroot/usr/include/scsi/scsi_netlink.h:44:2: error: unknown type
> name 'uint8_t'
> =A0=A0 44 |=A0 uint8_t version;
> =A0=A0=A0=A0=A0 |=A0 ^~~~~~~
>=20
> Fixes:
> =A0-
> http://autobuild.buildroot.org/results/32f4ada6c49261924ca78f62dee43241bd=
a379a3
>=20
> Signed-off-by: Fabrice Fontaine <fontaine.fabrice@gmail.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

