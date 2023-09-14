Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F4193EE3F2F
	for <dm-devel@archiver.kernel.org>; Fri, 15 Sep 2023 06:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694760358;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=mtKRXPD02bD4kM8vMDMncn815FbgPWdeJdiyToUahMM=;
	b=cjE7jLQmvxQXLFldhj7ymxrj3gH83iREE5qpAl1XgX6fUCskBrEu1CaZ0NNnFmg9QxXVpz
	uI68P5ZBAo2CLtWholSqQLhNese4iUAuemYTcyPEIdpy9bcrgODuYfMB7xIu33gPDs3sCq
	M52rqcwCRUqXodjobPImq/7N1J09g74=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-498-mJQOxyP1PHytHc2Qymi5xw-1; Fri, 15 Sep 2023 02:45:55 -0400
X-MC-Unique: mJQOxyP1PHytHc2Qymi5xw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 62AD388904B;
	Fri, 15 Sep 2023 06:45:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 51084200AC35;
	Fri, 15 Sep 2023 06:45:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 56B531946A48;
	Fri, 15 Sep 2023 06:45:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B589319465B7
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Sep 2023 14:28:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A0E5A40C2009; Thu, 14 Sep 2023 14:28:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9A17140C2070
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 14:28:51 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7C98381D88D
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 14:28:51 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-475-Itklqc5ONH2CH0mtzTL98Q-1; Thu,
 14 Sep 2023 10:28:47 -0400
X-MC-Unique: Itklqc5ONH2CH0mtzTL98Q-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 3BE0521850;
 Thu, 14 Sep 2023 14:28:45 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 145A2139DB;
 Thu, 14 Sep 2023 14:28:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id ShYxA50YA2UQdAAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 14 Sep 2023 14:28:45 +0000
Message-ID: <c0ead45f38a6872010a422562e1d06a3d461fa29.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 14 Sep 2023 16:28:44 +0200
In-Reply-To: <e69bc16163de0f46d615649dcc3c97454fb39682.camel@suse.com>
References: <20230911163846.27197-1-mwilck@suse.com>
 <20230911163846.27197-28-mwilck@suse.com>
 <20230913220727.GX7412@octiron.msp.redhat.com>
 <e69bc16163de0f46d615649dcc3c97454fb39682.camel@suse.com>
User-Agent: Evolution 3.48.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mailman-Approved-At: Fri, 15 Sep 2023 06:44:53 +0000
Subject: Re: [dm-devel] [PATCH v2 27/37] multipathd: watch bindings file
 with inotify + timestamp
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2023-09-14 at 15:25 +0200, Martin Wilck wrote:
> On Wed, 2023-09-13 at 17:07 -0500, Benjamin Marzinski wrote:
> >=20
> > I'm not sure if we should assert that the file has changed if we
> > can't stat() it.
>=20
> I think it's better to (try to) reread the file than pretend that the
> file hadn't changed ("if in doubt, reread").=A0Rationale:
>=20
> In general, the most likely cause for stat() to fail would be that
> the
> file (or the directory or file system containing it) had been
> removed.
> Actually, almost every possible error documented in stat(2) (except
> ENOMEM) indicates such a condition in one way or the other.=A0But in an
> IN_MOVED_TO handler for just this file, that seems quite unlikely, so
> we're really looking at a corner case situation here. A non-existing
> file means no bindings; a "reconfigure" operation would cause
> existing
> bindings to be preserved, newly probed maps would get a new alias
> assigned.=A0Looking at it that way, "rereading" a non-existing file
> doesn't do much harm. Our current bindings list may contain
> additional
> bindings that might be lost by re-reading, but still I think we have
> to
> assume that the file was intentionally deleted, and act accordingly.

Ouch, I'm embarrassed. My own code does not what I described here, it
returns an error if reading the bindings file fails, and does not
replace the current global bindings with an empty list.=A0

We could discuss changing this behavior with a later patch set.

Anyway, I think the basic reasoning was correct: we received an update
event for the file and couldn't prove that our current internal state
was up-to-date; thus we should try to re-read the file next time.

Martin








--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

