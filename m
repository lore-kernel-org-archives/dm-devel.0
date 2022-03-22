Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6E04C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 22 Mar 2022 16:38:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-uuiU_CUlMlKdBPDE2vb2hA-1; Tue, 22 Mar 2022 12:38:05 -0400
X-MC-Unique: uuiU_CUlMlKdBPDE2vb2hA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5C549101485E;
	Tue, 22 Mar 2022 16:38:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8B0B154DD94;
	Tue, 22 Mar 2022 16:38:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C27B11949762;
	Tue, 22 Mar 2022 16:38:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4A9481947BBC
 for <dm-devel@listman.corp.redhat.com>; Tue, 22 Mar 2022 16:37:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 052EA401E86; Tue, 22 Mar 2022 16:37:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 01772401E9F
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 16:37:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DC16E3C11A00
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 16:37:58 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-386-45fKVljuNveKxtbaXDDZZw-1; Tue, 22 Mar 2022 12:37:57 -0400
X-MC-Unique: 45fKVljuNveKxtbaXDDZZw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 111711F388;
 Tue, 22 Mar 2022 16:37:56 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C5F5B13419;
 Tue, 22 Mar 2022 16:37:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id W/0TLmP7OWI3bwAAMHmgww
 (envelope-from <mwilck@suse.com>); Tue, 22 Mar 2022 16:37:55 +0000
Message-ID: <2191d252133c55350f06137cdfdd7f885ce99b99.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Tue, 22 Mar 2022 17:37:55 +0100
In-Reply-To: <CAPt1nt6_zuhjhKRCXisoRPOcwRZbeMG516AQ9g+6c4mCvWmWPw@mail.gmail.com>
References: <20220318223339.4226-1-mwilck@suse.com>
 <20220318223339.4226-7-mwilck@suse.com>
 <CAPt1nt4LU_pHJA2m9zWjPhn2i=WOaVnzgiKY+V5za=u2a6StUQ@mail.gmail.com>
 <e1064847c02559b157238ec104aa75b3568fd4f6.camel@suse.com>
 <CAPt1nt6_zuhjhKRCXisoRPOcwRZbeMG516AQ9g+6c4mCvWmWPw@mail.gmail.com>
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
Subject: Re: [dm-devel] [PATCH v2 06/11] libmultipath: add callback for
 remove_map()
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
Cc: dm-devel@redhat.com, Guozhonghua <guozh88@chinatelecom.cn>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, 2022-03-22 at 09:59 -0500, Benjamin Marzinski wrote:
> 
> So all of the exported symbols from libmultipath are weak? Good to
> know.

No, "weak" has a special meaning. For dynamic linking, it's default
behavior to resolve symbols by name and use the first definition
encountered. This means that a symbol in a shared library will always
be overridden by a symbol of the same name in the main executable.

"When resolving symbolic references, the dynamic linker examines the
symbol tables with a breadth-first search. That is, it first looks at
the symbol table of the executable program itself, then at the symbol
tables of the DT_NEEDED entries (in order), then at the second level
DT_NEEDED entries, and so on." ([1], III, p. 2-12). The "weak"
attribute only matters during static linking ([1], III, p. 1-5). See
also the description of LD_DYNAMIC_WEAK in ld.so(8) [2].

I didn't understand this clearly before. And the documentation, in
particular the explanation of the "weak" attribute in the gcc docs, is
misleading, because it doesn't explain the difference between static
and dynamic linking [3].

Regards
Martin

[1] https://refspecs.linuxfoundation.org/elf/elf.pdf
[2] https://man7.org/linux/man-pages/man8/ld.so.8.html

[3] https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#Common-Function-Attributes


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

