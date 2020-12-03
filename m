Return-Path: <SRS0=D9Ri=FI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C9EDC4361A
	for <dm-devel@archiver.kernel.org>; Fri,  4 Dec 2020 09:27:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9ADBE225AB
	for <dm-devel@archiver.kernel.org>; Fri,  4 Dec 2020 09:27:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9ADBE225AB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-LQLit4WCMr65E0rnFVQr1w-1; Fri, 04 Dec 2020 04:27:42 -0500
X-MC-Unique: LQLit4WCMr65E0rnFVQr1w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DA1D0180A089;
	Fri,  4 Dec 2020 09:27:37 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BCD4B620D7;
	Fri,  4 Dec 2020 09:27:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 91A5E4EE7F;
	Fri,  4 Dec 2020 09:27:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B3MWWxB011133 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Dec 2020 17:32:32 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 239BCF11C7; Thu,  3 Dec 2020 22:32:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E327F00EE
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 22:32:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E7E8C185A7BC
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 22:32:29 +0000 (UTC)
Received: from mail-pf1-f196.google.com (mail-pf1-f196.google.com
	[209.85.210.196]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-226-RKc_LKBUPveRuQ1ds2UzKg-1; Thu, 03 Dec 2020 17:32:27 -0500
X-MC-Unique: RKc_LKBUPveRuQ1ds2UzKg-1
Received: by mail-pf1-f196.google.com with SMTP id 131so2287501pfb.9
	for <dm-devel@redhat.com>; Thu, 03 Dec 2020 14:32:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:cc:from:to;
	bh=isS72LcXXBRrXr0Ako/fe2G087FHJYFoOicsYh1AWO8=;
	b=CrPrb7Eh7/A7b+3W6QWbGM8M4TH+Gy5ZIS6qO9QbKhE5b8eTSntSALcshhXqP80t3y
	UlIgHaJhDIj5wMN52iBO/IA9DDdOwwRUYTusZLP7qg9fKXx+u7zn6f5H7fcSEA1DI/kp
	1ZfAmqoMHwjlyd1/MpmyJE+WzDiQ0E733dugZ3nEmpTUOd8Hg2ryDrhEEc24MGpTbIkY
	il9OaHYx5i5KKpkONfrwOieP6oJ3McUO8iTYx56tHEMHuVmW2V/SboIAooEq52ns+z9q
	kcE8bPBiZiewc8vi20X+dkeyA2YEFrjwavqHCxYLQXqYSYRim9IXAPeuxs150EIIHW4h
	UiVg==
X-Gm-Message-State: AOAM532wWZJW4qI6VSaBmg6YuSDUvRdImXlxhjD0I/qLrOkPg8MFexIo
	dWoav7g/jW+SdAjELiXSUKQtcA==
X-Google-Smtp-Source: ABdhPJxyBjD8G9ISMJWXF9KC/iPnxZEl+jlMD7j47CrGjE+X5vfqNVKfzgCqsSq3L3yisx8iqaM2cQ==
X-Received: by 2002:a65:679a:: with SMTP id e26mr4855403pgr.394.1607034746754; 
	Thu, 03 Dec 2020 14:32:26 -0800 (PST)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net.
	[76.210.143.223])
	by smtp.gmail.com with ESMTPSA id gp14sm333425pjb.6.2020.12.03.14.32.26
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 03 Dec 2020 14:32:26 -0800 (PST)
Date: Thu,  3 Dec 2020 13:58:55 -0800
Message-Id: <20201203215859.2719888-2-palmer@dabbelt.com>
In-Reply-To: <20201203215859.2719888-1-palmer@dabbelt.com>
References: <20201203215859.2719888-1-palmer@dabbelt.com>
MIME-Version: 1.0
From: Palmer Dabbelt <palmer@dabbelt.com>
To: dm-devel@redhat.com, agk@redhat.com, snitzer@redhat.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 04 Dec 2020 04:27:20 -0500
Cc: corbet@lwn.net, linux-doc@vger.kernel.org, kernel-team@android.com,
	Palmer Dabbelt <palmerdabbelt@google.com>,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	song@kernel.org, linux-kselftest@vger.kernel.org, shuah@kernel.org
Subject: [dm-devel] [PATCH v1 1/5] Documentation: Describe dm-user
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Palmer Dabbelt <palmerdabbelt@google.com>

I started by patterning this after the Fuse documentation, which is
located at Documentation/fs/fuse.rst.  There's not a whole lot of that
left, though.

Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>

---

This is a work in progress, but nothing in there should be incorrect.
---
 Documentation/block/dm-user.rst | 99 +++++++++++++++++++++++++++++++++
 1 file changed, 99 insertions(+)
 create mode 100644 Documentation/block/dm-user.rst

diff --git a/Documentation/block/dm-user.rst b/Documentation/block/dm-user.rst
new file mode 100644
index 000000000000..5eb3120f3fd5
--- /dev/null
+++ b/Documentation/block/dm-user.rst
@@ -0,0 +1,99 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=======
+dm-user
+=======
+
+What is dm-user?
+================
+
+dm-user is a device mapper target that allows block accesses to be satisfied by
+an otherwise unprivileged daemon running in userspace.  Conceptually it is
+FUSE, but for block devices as opposed to file systems.
+
+Creating a dm-user Target
+=========================
+
+dm-user is implemented as a Device Mapper target, which allows for various
+device management tasks.  In general dm-user targets function in the same
+fashion as other device-mapper targets, with the exception that dm-user targets
+handle requests via a userspace daemon as opposed to one of various in-kernel
+mechanisms.  As such there is little difference between creating a dm-user
+target and any other device mapper target: the standard device mapper control
+device and ioctl() calls are used to create a table with at least one target of
+the "user" type.  Like all other targets this table entry needs a start/size
+pair.  The additional required argument is the name of the control device that
+will be associated with this target.  Specifically:
+
+````
+user <start sector> <number of sectors> <path to control device>
+````
+
+As a concrete example, the following `dmsetup` invocation will create a new
+device mapper block device available at `/dev/mapper/blk`, consisting entirely
+of a single target which can be controlled via a stream of messages passed over
+`/dev/dm-user/ctl`.
+
+````
+dmsetup create blk <<EOF
+0 1024 user 0 1024 ctl
+EOF
+dmsetup resume blk
+````
+
+Userspace is expected to spin up a daemon to handle those block requests, which
+will block in the meantime.  The various Device Mapper operations should all
+function as they do for other targets.  If the userspace daemon terminates (or
+otherwise closes the control file descriptor) then the kernel will continue to
+queue up BIOs until userspace either starts a new daemon or destroys the
+target.
+
+Userspace may open each control device multiple times, in which case the kernel
+will distribute messages among each file instance.
+
+Writing a dm-user Daemon
+========================
+
+tools/testing/selftests/dm-user contains a handful of test daemons.
+functional/simple-read-all.c is also suitable as an example.
+
+Kernel - userspace interface
+****************************
+
+FIXME: A description of `struct dm_user_message`
+
+Kernel Implementation
+=====================
+
+BIO Lifecycle
+*************
+
+| "dd if=/dev/mapper/user ...             " | dm-user block server
+|                                           |
+|                                           | >sys_read()
+|                                           |  >dev_read()
+|                                           |   [sleep on c->wq]
+|                                           |
+| >sys_read()                               |
+|  [... block and DM layer ... ]            |
+|  >user_map()                              |
+|   [enqueue message]                       |
+|   [wake up c->wq]                         |
+|  <user_map()                              |   [woken up]
+| [sleep on BIO completion]                 |   [copy message to user]
+|                                           |  <dev_read()
+|                                           | <sys_read()
+|                                           |
+|                                           | [obtain request data]
+|                                           |
+|                                           | >sys_write()
+|                                           |  >dev_write()
+|                                           |   [copy message from user]
+|                                           |   [complete BIO]
+|  [woken up on BIO completion]             |  <dev_write()
+| <sys_read()                               | <sys_write()
+|                                           |
+| [write and loop]                          | [loop for more messages]
+
+Locking Scheme
+**************
-- 
2.29.2.454.gaff20da3a2-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

