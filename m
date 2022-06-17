Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27226C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 17 Jun 2022 06:48:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-133-9MKMP0aZPHWJt7D7zVQ_fQ-1; Fri, 17 Jun 2022 02:48:48 -0400
X-MC-Unique: 9MKMP0aZPHWJt7D7zVQ_fQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 158B110F97FA;
	Fri, 17 Jun 2022 06:48:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 813651121314;
	Fri, 17 Jun 2022 06:48:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 53C8E194705F;
	Fri, 17 Jun 2022 06:48:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 11AB4194705D
 for <dm-devel@listman.corp.redhat.com>; Fri, 17 Jun 2022 06:48:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 039482166B2A; Fri, 17 Jun 2022 06:48:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F39A22166B29
 for <dm-devel@redhat.com>; Fri, 17 Jun 2022 06:48:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D873B2919EC6
 for <dm-devel@redhat.com>; Fri, 17 Jun 2022 06:48:37 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-61-uHkpvsFoOWifmYUyKp5O8Q-1; Fri, 17 Jun 2022 02:48:34 -0400
X-MC-Unique: uHkpvsFoOWifmYUyKp5O8Q-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 393031FA09;
 Fri, 17 Jun 2022 06:48:32 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 098E313458;
 Fri, 17 Jun 2022 06:48:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id Zwy/AMAjrGJEagAAMHmgww
 (envelope-from <mwilck@suse.com>); Fri, 17 Jun 2022 06:48:32 +0000
Message-ID: <5089ee52c1200a0525eb25e9ac2e1a6e00661f01.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Date: Fri, 17 Jun 2022 08:48:31 +0200
In-Reply-To: <950f4ffe-7cf6-b385-1141-f27fbf5ebef9@gmail.com>
References: <20220328170404.8565-1-xose.vazquez@gmail.com>
 <5187f68e1a6595d47d10a05ea01931e1ce8cad27.camel@suse.com>
 <9bdd8437-741b-ff0c-068c-9d8cf211fff0@gmail.com>
 <6e92e5c8678e66808f94b844f86f2573e41ebb01.camel@suse.com>
 <950f4ffe-7cf6-b385-1141-f27fbf5ebef9@gmail.com>
User-Agent: Evolution 3.44.2
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
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
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 DM-DEVEL ML <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2022-06-16 at 22:32 +0200, Xose Vazquez Perez wrote:
> On 4/1/22 12:20, Martin Wilck wrote:
>=20
> > On Mon, 2022-03-28 at 19:57 +0200, Xose Vazquez Perez wrote:
> > > On 3/28/22 19:48, Martin Wilck wrote:
> > > > On Mon, 2022-03-28 at 19:04 +0200, Xose Vazquez Perez wrote:
> > > > > Cc: Martin Wilck <mwilck@suse.com>
> > > > > Cc: Benjamin Marzinski <bmarzins@redhat.com>
> > > > > Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> > > > > Cc: DM-DEVEL ML <dm-devel@redhat.com>
> > > > > Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> > > > > ---
> > > > > =A0=A0=A0README.nvme | 12 ++++++++++++
> > > > > =A0=A0=A01 file changed, 12 insertions(+)
> > > > > =A0=A0=A0create mode 100644 README.nvme
> > > >=20
> > > > Why another separate README with just 12 lines?
> > > >=20
> > > > Martin
> > >=20
> > > README.md is intended multipath-tools developers.
> > > And README.alua and README.nvme are for sysadmins.
> > >=20
> >=20
> > I see no fundamental reason not to merge all READMEs into one,
> > and create "sysadmin" and "developer" sections.
>=20
> README.md is in markdown syntax.
> README.alua and README.nvme are plain text, and its content is easier
> to identify.
> Are you running out of inodes? :-)

No, it' about user friendliness. These .txt files are developer-level
documentation, while ALUA and NVMe are topic which are at least as
important to users as for developers. Distributions tend to ship the
READMEs under /usr/share/doc, but to be realistic, how many users still
look there for documentation these days?

Regards,
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

