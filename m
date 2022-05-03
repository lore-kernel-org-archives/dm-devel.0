Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FCD9C433F5
	for <dm-devel@archiver.kernel.org>; Tue,  3 May 2022 22:10:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-90-sS8jbCgHMjiS2TAAqbMpkw-1; Tue, 03 May 2022 18:09:43 -0400
X-MC-Unique: sS8jbCgHMjiS2TAAqbMpkw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1EAC210187E4;
	Tue,  3 May 2022 22:07:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5829E553FF0;
	Tue,  3 May 2022 22:07:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 093CC1947040;
	Tue,  3 May 2022 22:07:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9C67119466DF
 for <dm-devel@listman.corp.redhat.com>; Tue,  3 May 2022 22:07:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8C395111D78B; Tue,  3 May 2022 22:07:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 872C7111D78A
 for <dm-devel@redhat.com>; Tue,  3 May 2022 22:07:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 18B0C29AA2FC
 for <dm-devel@redhat.com>; Tue,  3 May 2022 22:07:27 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-601-qP7JIWajN0WXfpI1iVzfBg-1; Tue, 03 May 2022 18:07:25 -0400
X-MC-Unique: qP7JIWajN0WXfpI1iVzfBg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id B73842186F;
 Tue,  3 May 2022 22:07:17 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8A11313ABE;
 Tue,  3 May 2022 22:07:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id WIgTIJWncWLfFgAAMHmgww
 (envelope-from <mwilck@suse.com>); Tue, 03 May 2022 22:07:17 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed,  4 May 2022 00:06:46 +0200
Message-Id: <20220503220646.16925-8-mwilck@suse.com>
In-Reply-To: <20220503220646.16925-1-mwilck@suse.com>
References: <20220503220646.16925-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: [dm-devel] [PATCH 7/7] github workflows: foreign.yaml: fix config
 dir in run environment
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

The foreign workflow uses a container for running the tests. The
paths for the working directory must match between builder and
runner, otherwise the hwtable test fails while trying to create
the CONFIG_DIR.

The container uses ${{ github.workspace }} as working directory,
whereas the build environment uses the abbreviated
__w/multipath-tools/multipath-tools. Adapt the build environment such
that the path is correct later.

See https://github.com/mosteo-actions/docker-run/blob/v1/action.yml

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 .github/workflows/foreign.yaml | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/.github/workflows/foreign.yaml b/.github/workflows/foreign.yaml
index c164cb3..e9ffd3d 100644
--- a/.github/workflows/foreign.yaml
+++ b/.github/workflows/foreign.yaml
@@ -24,7 +24,8 @@ jobs:
         run: make test
       - name: build
         if: ${{ matrix.arch != '' && matrix.arch != '-i386' }}
-        run: make test-progs
+        # The build path is different between builder and runner
+        run: make TESTDIR=${{ github.workspace }}/tests test-progs
       - name: archive
         if: ${{ matrix.arch != '' && matrix.arch != '-i386' }}
         run: >
@@ -61,6 +62,8 @@ jobs:
         uses: mosteo-actions/docker-run@v1
         with:
           image: mwilck/multipath-run-${{ matrix.os }}-${{ matrix.arch }}
-          # The runner is an image that has "make" as entrypoint
+          # The runner is an image that has "make" as entrypoint and uses
+          # github.workspace as both host dir and guest volume by default.
+          # See https://github.com/mosteo-actions/docker-run/blob/v1/action.yml
           # So run "make -C tests" here
           command: -C tests
-- 
2.36.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

