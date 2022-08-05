Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7837EC00140
	for <dm-devel@archiver.kernel.org>; Fri,  5 Aug 2022 23:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659741375;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=SNa+1frUJCUQbZkGTqzqZbv6yTfe5tIJCqv3lBk/w98=;
	b=h8Lj+upyUSUV7Isae8g8d6LwPBOcqRBByTqaW6ke+p1DOgAna7I4vKoi0CwTfqLM03m7UW
	Yrxhu+blMRMJTpnrRw67Sbmm4G/Du7OcQdab+MsMkGNS5tzg6kUUU/jZOJx23XtMHnCIzA
	RHtkXS0F9Lh4ICO9peVQWyHIO6aAJEw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-604-TDMHzLh7NtOGZJoxaAm4aw-1; Fri, 05 Aug 2022 19:16:12 -0400
X-MC-Unique: TDMHzLh7NtOGZJoxaAm4aw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A0101811E80;
	Fri,  5 Aug 2022 23:16:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 94BA72166B26;
	Fri,  5 Aug 2022 23:16:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 591F3193221F;
	Fri,  5 Aug 2022 23:16:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6E293193221E
 for <dm-devel@listman.corp.redhat.com>; Fri,  5 Aug 2022 23:16:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3FA6A400E86C; Fri,  5 Aug 2022 23:16:06 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E47E40149A8;
 Fri,  5 Aug 2022 23:16:06 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 275NG4Zh031465;
 Fri, 5 Aug 2022 18:16:04 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 275NG3ul031462;
 Fri, 5 Aug 2022 18:16:03 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Fri,  5 Aug 2022 18:16:03 -0500
Message-Id: <1659741363-31425-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: [dm-devel] [RFC PATCH] multipath: fix systemd timers in the
 initramfs
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
Cc: device-mapper development <dm-devel@redhat.com>,
 Martin Wilck <Martin.Wilck@suse.com>
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The systemd timers created for "find_multipaths smart" conflict with
shutdown.target, but not with initrd-cleanup.service.  This can make
these timers trigger after the inirtd has started shutting down,
restarting multipathd (which then stops initrd-cleanup.service, since it
conflicts).  To avoid this, make sure the timers and the unit they
trigger conflict with inird-cleanup.service. Also don't make them start
multipathd.  "multipath -u" will not return "maybe" if multipathd isn't
running or set to run, and since we no longer wait for udev-settle,
multipathd starts up pretty quickly, so it shouldn't be a problem to
not trigger it here.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---

Notes:
    I haven't seen this, but I do worry that path uevents could come in
    after initrd-cleanup.service has started. In this case the timers
    themselves could stop initrd-cleanup.service, since they conflict with
    it. I'm not sure if there is any way to see where we are in the
    bootup/shutdown process and not start up the timers if we are already
    cleaning up. Also, I don't know of any way to set a service so that if
    it conflicts with another service, it is always the one that gets
    stopped. A safe option would be to simply make the timers not start
    multipathd, without adding the conflicts.

 multipath/multipath.rules | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipath/multipath.rules b/multipath/multipath.rules
index 9df11a95..f993d996 100644
--- a/multipath/multipath.rules
+++ b/multipath/multipath.rules
@@ -71,7 +71,7 @@ ENV{.SAVED_FM_WAIT_UNTIL}=="?*", GOTO="pretend_mpath"
 #
 # We must trigger an "add" event because LVM2 will only act on those.
 
-RUN+="/usr/bin/systemd-run --unit=cancel-multipath-wait-$kernel --description 'cancel waiting for multipath siblings of $kernel' --no-block --timer-property DefaultDependencies=no --timer-property Conflicts=shutdown.target --timer-property Before=shutdown.target --timer-property AccuracySec=500ms --property DefaultDependencies=no --property Conflicts=shutdown.target --property Before=shutdown.target --property Wants=multipathd.service --property After=multipathd.service --on-active=$env{FIND_MULTIPATHS_WAIT_UNTIL} /usr/bin/udevadm trigger --action=add $sys$devpath"
+RUN+="/usr/bin/systemd-run --unit=cancel-multipath-wait-$kernel --description 'cancel waiting for multipath siblings of $kernel' --no-block --timer-property DefaultDependencies=no --timer-property Conflicts=shutdown.target --timer-property Before=shutdown.target --timer-property Conflicts=initrd-cleanup.service --timer-property Before=initrd-cleanup.service --timer-property AccuracySec=500ms --property DefaultDependencies=no --property Conflicts=shutdown.target --property Before=shutdown.target --property Conflicts=initrd-cleanup.service --property Before=initrd-cleanup.service --on-active=$env{FIND_MULTIPATHS_WAIT_UNTIL} /usr/bin/udevadm trigger --action=add $sys$devpath"
 
 LABEL="pretend_mpath"
 ENV{DM_MULTIPATH_DEVICE_PATH}="1"
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

