Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 524E9C43217
	for <dm-devel@archiver.kernel.org>; Fri,  1 Apr 2022 10:20:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-403-yPx5oefuPdybl3UwqX2EVg-1; Fri, 01 Apr 2022 06:20:45 -0400
X-MC-Unique: yPx5oefuPdybl3UwqX2EVg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A6A6310A5CD3;
	Fri,  1 Apr 2022 10:20:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CE02A2026D64;
	Fri,  1 Apr 2022 10:20:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 753AB1947BBF;
	Fri,  1 Apr 2022 10:20:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A4FD41947BBE
 for <dm-devel@listman.corp.redhat.com>; Fri,  1 Apr 2022 10:20:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 887EB401E26; Fri,  1 Apr 2022 10:20:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 84CAE401DB0
 for <dm-devel@redhat.com>; Fri,  1 Apr 2022 10:20:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 654971C0B050
 for <dm-devel@redhat.com>; Fri,  1 Apr 2022 10:20:39 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-435-d9YVdV49N_ieItJdfYNNkw-1; Fri, 01 Apr 2022 06:20:32 -0400
X-MC-Unique: d9YVdV49N_ieItJdfYNNkw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 69F761FD00;
 Fri,  1 Apr 2022 10:20:25 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 36A48132C1;
 Fri,  1 Apr 2022 10:20:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id 2QGDC+nRRmL7dAAAMHmgww
 (envelope-from <mwilck@suse.com>); Fri, 01 Apr 2022 10:20:25 +0000
Message-ID: <6e92e5c8678e66808f94b844f86f2573e41ebb01.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Date: Fri, 01 Apr 2022 12:20:24 +0200
In-Reply-To: <9bdd8437-741b-ff0c-068c-9d8cf211fff0@gmail.com>
References: <20220328170404.8565-1-xose.vazquez@gmail.com>
 <5187f68e1a6595d47d10a05ea01931e1ce8cad27.camel@suse.com>
 <9bdd8437-741b-ff0c-068c-9d8cf211fff0@gmail.com>
User-Agent: Evolution 3.44.0
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH] multipath-tools: add basic info on how to
 use multipath-tools with NVMe devices
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
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2022-03-28 at 19:57 +0200, Xose Vazquez Perez wrote:
> On 3/28/22 19:48, Martin Wilck wrote:
> > On Mon, 2022-03-28 at 19:04 +0200, Xose Vazquez Perez wrote:
> > > Cc: Martin Wilck <mwilck@suse.com>
> > > Cc: Benjamin Marzinski <bmarzins@redhat.com>
> > > Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> > > Cc: DM-DEVEL ML <dm-devel@redhat.com>
> > > Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> > > ---
> > > =A0=A0README.nvme | 12 ++++++++++++
> > > =A0=A01 file changed, 12 insertions(+)
> > > =A0=A0create mode 100644 README.nvme
> >=20
> > Why another separate README with just 12 lines?
> >=20
> > Martin
>=20
> README.md is intended multipath-tools developers.
> And README.alua and README.nvme are for sysadmins.
>=20

I see no fundamental reason not to merge all READMEs into one,
and create "sysadmin" and "developer" sections.

Regards,
Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

