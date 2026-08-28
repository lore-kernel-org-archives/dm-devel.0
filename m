Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584BB279907
	for <dm-devel@lists.linux.dev>; Fri, 28 Aug 2026 09:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787909219; cv=none; b=EzkslDu+2eV2yBwcpvEJpgao5jOQp28zn0VpZ6k9HGDAdpU3AOMuRoefpZhti+FaVUU73i8CWzFv68//LhDt2ikR//MxLfiM7wkZHrfVWMO4jgLzkz/Ak3OgGylko4Ai/URxEJiZ04W44DwmXqaUccnpfW4+l+EodJCspDl/3l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787909219; c=relaxed/simple;
	bh=Zvb9wyZO828qthRPWaN57Auq07EU2ZJahzzxA5lN0l0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=suWSkHiFpQvEqD9Hq8NjBa6HnthxtDG5BFynrNLmdVVuuYb6zsnglpKA2aKwxnFZWY368azvQ772KlNVEok8ipPELgS544nLdGDAH/pjsoLD5fGROU8zj0EpBYaeDh5Y5xWIE087NBnZ8jX0Z7J9OsD7K9euGGVUMilPV7GVcWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=p0wDlIoR; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=TUt9OZlf; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="p0wDlIoR";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="TUt9OZlf"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 021B81F8B3;
	Fri, 28 Aug 2026 09:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787909212; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=PjqxFmaDQvZLpJedUUznWLneIulOYtjimjiO2YyVJBk=;
	b=p0wDlIoRLLB8KHcaEMLggIcr8eXNPr0S0vHi5Q4HA8VCPx35CzLnwMXdunIrcT0o2SXUPW
	KEL+SKmiTR5+R3qPbsUxeQgNu38QZ4KYKKB6DhT8DMPaNH+7HbbqbUZwjmdgsETThF6rpd
	UA5N50ag5rfxvpXTFhz7aph85o3oGlE=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787909208; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=PjqxFmaDQvZLpJedUUznWLneIulOYtjimjiO2YyVJBk=;
	b=TUt9OZlfDwqNCDejGeps9Gvp/YENzL7Toifj6ubRElhMa6DinzVic4csaAvwrAjx+l9Wdx
	N4us3PghxYmxdBrWccwiH5BXU3QcGIIZbCWYRsInLQ1OYasYaPw9Ohdj1KcqcoK5R+aS5k
	Kr33OzN9BpvfDlHz0ZurpbfPmaPpFH0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7686513674;
	Fri, 28 Aug 2026 09:26:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Q78FGVdUkWq1dgAAD6G6ig
	(envelope-from <antonio.feijoo@suse.com>); Fri, 28 Aug 2026 09:26:47 +0000
From: Antonio Alvarez Feijoo <antonio.feijoo@suse.com>
To: dm-devel@lists.linux.dev
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	Antonio Alvarez Feijoo <antonio.feijoo@suse.com>
Subject: [PATCH] multipath.rules.in: fix race in unit cancel-multipath-wait-$kernel
Date: Fri, 28 Aug 2026 11:25:48 +0200
Message-ID: <20260828092548.34637-1-antonio.feijoo@suse.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Score: -1.80
X-Spam-Flag: NO
X-Spamd-Result: default: False [-1.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	SUBJECT_HAS_CURRENCY(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.993];
	MIME_GOOD(-0.10)[text/plain];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[]

The transient unit cancel-multipath-wait-$kernel creates a timer and
service with "Conflicts=initrd-cleanup.service":

- sda: /usr/lib/udev/rules.d/56-multipath.rules ...
    --on-active=1.000000 ...
- sda: ... 'Running timer as unit: cancel-multipath-wait-sda.timer'
- sda: ... 'Will run service as unit:
    cancel-multipath-wait-sda.service'

This introduces a race not always reproducible: there is a 1 second
window where this transient unit can start after
initrd-cleanup.service/start is enqueued but is still held back. When
that happens, starting cancel-multipath-wait-$kernel.service pulls in
a stop job for initrd-cleanup.service and the queued start job is
cancelled, the initrd is left with an empty job queue and hangs
forever, before switch-root:

- initrd-parse-etc.service: Triggering OnSuccess= dependencies.
- initrd-cleanup.service: Installed new job
    initrd-cleanup.service/start as 115
- initrd-cleanup.service: starting held back, waiting for:
    dracut-pre-pivot.service
- initrd-cleanup.service: Job 115 initrd-cleanup.service/start
    finished, result=canceled
- initrd-cleanup.service: Installed new job
    initrd-cleanup.service/stop as 133
- initrd-cleanup.service: Job 133 initrd-cleanup.service/stop
    finished, result=done

"Conflicts=" is symmetric: if a unit has a "Conflicts=" requirement
on a set of other units, then starting it will stop all of them and
starting any of them will stop it. This is safe against
shutdown.target, whose jobs are enqueued irreversibly: a unit
starting during shutdown fails to start rather than cancelling the
shutdown. It is not safe against initrd-cleanup.service, whose start
job is an ordinary job enqueued by initrd-parse-etc.service via
"OnSuccess=".

Ordering "Before=initrd-cleanup.service" is enough and is not
destructive: a trigger already in flight completes before cleanup
runs, and a unit with no job does not delay it. Tearing the
transient units down before switch-root is already handled by the
isolate to initrd-switch-root.target, which stops everything that
is not "IgnoreOnIsolate=yes".

Signed-off-by: Antonio Alvarez Feijoo <antonio.feijoo@suse.com>
---
 multipath/multipath.rules.in | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/multipath/multipath.rules.in b/multipath/multipath.rules.in
index 2ac1972f..7b605dd4 100644
--- a/multipath/multipath.rules.in
+++ b/multipath/multipath.rules.in
@@ -68,8 +68,18 @@ ENV{.SAVED_FM_WAIT_UNTIL}=="?*", GOTO="pretend_mpath"
 # the --on-active timeout.
 #
 # We must trigger an "add" event because LVM2 will only act on those.
-
-RUN+="@SYSDIR_BIN@/systemd-run --unit=cancel-multipath-wait-$kernel --description 'cancel waiting for multipath siblings of $kernel' --no-block --timer-property DefaultDependencies=no --timer-property Conflicts=shutdown.target --timer-property Before=shutdown.target --timer-property Conflicts=initrd-cleanup.service --timer-property Before=initrd-cleanup.service --timer-property AccuracySec=500ms --property DefaultDependencies=no --property Conflicts=shutdown.target --property Before=shutdown.target --property Conflicts=initrd-cleanup.service --property Before=initrd-cleanup.service --on-active=$env{FIND_MULTIPATHS_WAIT_UNTIL} @SYSDIR_BIN@/udevadm trigger --action=add $sys$devpath"
+#
+# These units are ordered Before=initrd-cleanup.service so that a trigger that
+# is already in flight completes before the initrd switches root. They must
+# *not* use Conflicts=initrd-cleanup.service: unlike shutdown.target, whose
+# jobs are enqueued irreversibly, initrd-cleanup.service/start is a plain job
+# enqueued by initrd-parse-etc.service via OnSuccess=. Starting a unit that
+# conflicts with it therefore cancels that job instead of failing to start,
+# and OnSuccess= is never retried, so the initrd would hang forever with an
+# empty job queue. Stopping these units before switch-root is already
+# guaranteed by the isolate to initrd-switch-root.target.
+
+RUN+="@SYSDIR_BIN@/systemd-run --unit=cancel-multipath-wait-$kernel --description 'cancel waiting for multipath siblings of $kernel' --no-block --timer-property DefaultDependencies=no --timer-property Conflicts=shutdown.target --timer-property Before=shutdown.target --timer-property Before=initrd-cleanup.service --timer-property AccuracySec=500ms --property DefaultDependencies=no --property Conflicts=shutdown.target --property Before=shutdown.target --property Before=initrd-cleanup.service --on-active=$env{FIND_MULTIPATHS_WAIT_UNTIL} @SYSDIR_BIN@/udevadm trigger --action=add $sys$devpath"
 
 LABEL="pretend_mpath"
 ENV{DM_MULTIPATH_DEVICE_PATH}="1"
-- 
2.51.0

