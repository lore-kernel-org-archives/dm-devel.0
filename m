Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11800286D70
	for <dm-devel@lists.linux.dev>; Tue,  6 Oct 2026 20:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791319554; cv=none; b=uAT9gben/mBL67Jw3hleOsUwmOsk/5/FNyqbvRp5Wlus/1BKMfRivelRXeEwvsGgg4GrJuiffVZ5w5V1p27oLLoW4NOM9uz0BgPa7oOMMWLL3o2uQI/iLBYpjT8XFyy2ZjlC/kgAe+qNWcSB0nwi/3fKfDU5yA9mej6z1qtE+08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791319554; c=relaxed/simple;
	bh=F9NjckJICFfkkJCe9cYJzm8zMQ6fbPCKlaLGGW2tChw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VTIBFyNYYdcpvJFHitVGUUc5726cXqdqFrye8KsOwHZ9LWsDzepO+/k3BIo6t2OQhdI5ERP9gilLOQuO0xqB6Btx9WaLGgz4rgABeQrznKpILWsYu7f3AiOg0Q/J53BOcCvFtx4X1UNHiSH79icHw/W8wXE83GNg2NGg5D8C/R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=OQW700v7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Fktsyuga; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=QKmoDCFj; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=HeU+qGz8; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="OQW700v7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Fktsyuga";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="QKmoDCFj";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="HeU+qGz8"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 75C7B21FC5;
	Tue,  6 Oct 2026 20:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791319545; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6fyu3f5W0kfiOyWR7BKPKW2nlPPFuSTK6DO/haX62oU=;
	b=OQW700v7UYVXhHqOmVR9obGHtDaEkziUMwsBOMIQjjUGTFIRBNA5J0OpzPVEAH47cCusB0
	LDmZtTEoIkG7BSCPKJpwV9bQESJMj7vSNLx9SgoUEB9MPm9gYoM6csm3fduSwFdBtVzFn6
	i5t84thZjRVCF7LBUZNrfTVJTyNK9a8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791319545;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6fyu3f5W0kfiOyWR7BKPKW2nlPPFuSTK6DO/haX62oU=;
	b=Fktsyuga5Mqt/dWLIs0TX2A/qgGpO24Yz65q7j3RjbwnUIWDOmvTlyOxZLe+syEDscz+ey
	gv/VglN6Tio82TAw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791319541; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6fyu3f5W0kfiOyWR7BKPKW2nlPPFuSTK6DO/haX62oU=;
	b=QKmoDCFjBhztqq8XcROEAQAVGNXLc9+D14Ws8Uxgl1rUzBG63xxNFZjMK2E6b6ht41jtyv
	LIaom14Hj7D4g3/Y3gbHDcTd4e6mppAzEAkubuJnFwUCIPXqca518RbVU4fIjZ7cetpFJS
	vZHnV3Fp9exanTIlUrryOiX+d4FKAxs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791319541;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6fyu3f5W0kfiOyWR7BKPKW2nlPPFuSTK6DO/haX62oU=;
	b=HeU+qGz89YOZbkc5ugUaJ0aOpG09B+Z4Qi7AURxPYxMe9S1Dp0nbP+p3eamTfLtytRH1wc
	q2px9FLHhSMLfdBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 01EDF13B89;
	Tue,  6 Oct 2026 20:45:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id h2fNHvRdxWqCPAAAD6G6ig:T3
	(envelope-from <mwilck@suse.de>); Tue, 06 Oct 2026 20:45:40 +0000
From: mwilck@suse.de
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 2/3] libmultipath: unmangle WWIDs if necessary
Date: Tue,  6 Oct 2026 22:45:22 +0200
Message-ID: <20261006204530.993731-3-mwilck@suse.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261006204530.993731-1-mwilck@suse.de>
References: <20261006204530.993731-1-mwilck@suse.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-0.999];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FROM_NO_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spam-Flag: NO

From: Martin Wilck <mwilck@suse.com>

Recent vulnerability reports have modified the output of sg_inq for
the the WWID in the udev property ID_SERIAL of certain devices [1], for
cases in which the device-provided WWID contains characters that are not
allowed in device nodes, such as comma or semicolon.

This causes 2 problems for multipath-tools:

1) The WWID is now different than before, and doesn't match existing
entries in /etc/multipath/wwids and /etc/multipath/bindings. This can
cause multipath maps not to be assembled at all, in particular if
"find_multipaths strict" is set multipath.conf, or alias mismatches.

2) In certain situations, multipath or multipathd determine the WWID from
the map (DM_UUID) and not from the path. This happens e.g. when an "add"
uevent is recevied for a map that has no known paths, or when "multipath
-U" is run from udev rules. libdevmapper automatically "mangles" device
UUIDs when it creates maps in order to avoid issues with illegal characters
in device nodes or udev symlinks. When it reads the WWIDs back, it
"unmangles" these strings by default, meaning that a WWID that actually
contains a mangled sequence such as `\x2c` will be returned with this
sequence replaced by a comma [2]. This can cause mismatches between map and
path WWID, with the effect that multipath or multipathd fail and remove the
paths from the map. This happens for every path, making the map unusable.

Problem 2) could be fixed by explicitly requesting the unmangled
device-mapper UUID from device-mapper when gathering information about a
map. But this leaves problem 1). Asking libdevmapper not to mangle names
during device creation is another possibility, but it causes issues with
udev symlink names etc. elsewhere, which we should strictly avoid.

Instead, solve the issue by unmangling WWIDs in libmultipath. This comes
with another problem: in libmultipath, we don't know for sure whether or
not given WWID had been mangled by by udev or similar tools like scsi_id or
sg_inq. We just query the ID_SERIAL udev property, which is set by udev
rules from device properties, some of which (like T10 vendor ID and SCSI
name string) are mangled by udev, and some not (like NAA designators). Both
`uid_attribute` and the udev rules can be customized by users, aggravating
the problem. Unmangling a WWID that hadn't been mangled in the first place
causes other issues, and while highly unusual, it is not forbidden that
e.g. the physical model ID contain `\xHH` character sequences.

This patch therefore adopts a multi-stage approach:

1. If the WWID contains a forbidden character, it can't be mangled by udev,
   use original WWID.
2. If it doesn't contain a `\xHH` sequence, it isn't mangled, use original.
3. If the unmangled WWID is known in the WWIDs file, use it.
4. If the original WWID is known in the WWIDs file, use it.
5. If in doubt, use the unmangled WWID.

IOW, option 5) is applied when a WWID is encountered that contains no
forbidden characters and at least one `\xHH` sequence, and which doesn't
appear in the WWIDs file in either unmangled or not-unmangled form. This
can still be wrong in unusual circumstances, but as the WWID appears
to be new, it shouldn't cause disruption as in case 2) above.

The unmangled WWID can contain characters which are not in udev's
whitelist. This patch again "mangles" only unprintable characters to `_`,
in order to avoid issues with symlink names. Whether or not that's correct
is debatable, but as it occurs before map creation, it's unlikely to cause
problems. In accordance with systemd code, multi-byte unicode (UTF-8)
characters are not mangled.

[1] sg3_utils commit 2fe1452 ("sg_inq: --export output conformance for SCSI
name string and ATA fields (github: PR #83); Apply udev-conforming
character encoding to VPD 0x83 designator type 8 (SCSI name string) and the
T10 vendor ID ATA subfield, matching the encoding already used by
designator types 0 and 1 since commit 4d770f1")

[2] See e.g. the documentation for the --manglename option in dmsetup(8).

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 99 ++++++++++++++++++++++++++++++++++++++--
 libmultipath/discovery.h |  1 +
 2 files changed, 96 insertions(+), 4 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 344da19..a52f4c3 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -37,6 +37,7 @@
 #include "print.h"
 #include "strbuf.h"
 #include "pgpolicies.h"
+#include "wwids.h"
 
 #define VPD_BUFLEN 4096
 
@@ -45,6 +46,97 @@ struct vpd_vendor_page vpd_vendor_pages[VPD_VP_ARRAY_SIZE] = {
 	[VPD_VP_HP3PAR]	= { 0xc0, "hp3par" },
 };
 
+/* from libdm/libdm-common.c; license: LGPL-2.1-only */
+static bool _is_whitelisted_char(char c)
+{
+	/*
+	 * Actually, DM supports any character in a device name.
+	 * This whitelist is just for proper integration with udev.
+	 */
+	if ((c >= '0' && c <= '9') || (c >= 'A' && c <= 'Z') ||
+	    (c >= 'a' && c <= 'z') || strchr("#+-.:=@_", c) != NULL)
+		return true;
+
+	return false;
+}
+
+size_t maybe_unmangle_wwid(char new_wwid[WWID_SIZE], const char *wwid)
+{
+	char buf[WWID_SIZE], *dst;
+	const char *src;
+	bool mangled = false, invalid = false;
+	size_t rc, len;
+
+	if (!wwid) {
+		*new_wwid = '\0';
+		return 0;
+	}
+
+	/* this might be > WWID_SIZE - 1 */
+	len = strlen(wwid);
+	/*
+	 * A correctly mangled string doesn't contain invalid characters.
+	 * In particular, if the original string contained `\xXY`, it will
+	 * itself be mangled to '\x5cxXY`.
+	 */
+	/* clang-format off */
+	for (src = wwid, dst = buf;
+	     dst - buf < WWID_SIZE - 1 && *src;
+	     src++, dst++) {
+		/*clang-format on */
+		if (_is_whitelisted_char(*src)) {
+			*dst = *src;
+			continue;
+		}
+		if (*src == '\\') {
+			char hex[3], c;
+
+			/*
+			 * udev mangling always outputs 2-digit hex numbers
+			 * 1-digit would be unprintable, anyway
+			 */
+			if (src + 4 > wwid + len || *(src + 1) != 'x' ||
+			    sscanf(src + 2, "%2[A-Fa-f0-9]", hex) == 0 ||
+			    strlen(hex) != 2) {
+				condlog(3, "%s: wwid \"%s\" contains invalid mangle sequence \"%s\"",
+					__func__, wwid, src);
+				invalid = true;
+				break;
+			}
+			mangled = true;
+			src += 1 + strlen(hex);
+			c = strtol(hex, NULL, 16);
+			/* Allow non-ascii unicode, but avoid non-printable characters */
+			*dst = (c & 0x80) || isprint(c) ? c : '_';
+		} else {
+			condlog(3, "%s: wwid \"%s\" contains illegal character '%02x'",
+				__func__, wwid, (unsigned char)*src);
+			invalid = true;
+			break;
+		}
+	}
+
+	/*
+	 * 1. If we found an invalid character, it can't be mangled by udev,
+	 *    use original WWID.
+	 * 2. If we didn't found a `\xHH`, it isn't mangled, use original.
+	 * 3. If the unmangled WWID is known, use it.
+	 * 4. If the original WWID is known, use it.
+	 * 5. If in doubt, use the unmangled WWID.
+	 */
+	if (invalid || !mangled ||
+	    (check_wwids_file(buf, 0) && !check_wwids_file(wwid, 0))) {
+		rc = strlcpy(new_wwid, wwid, WWID_SIZE);
+		condlog(4, "%s: kept WWID \"%s\"", __func__, new_wwid);
+	} else {
+		*dst = '\0';
+		rc = strlcpy(new_wwid, buf, WWID_SIZE);
+		condlog(3, "%s: unmangled WWID \"%s\" -> \"%s\"", __func__,
+			wwid, new_wwid);
+	}
+	return rc;
+}
+
 int
 alloc_path_with_pathinfo (struct config *conf, struct udev_device *udevice,
 			  const char *wwid, int flag, struct path **pp_ptr)
@@ -65,8 +157,7 @@ alloc_path_with_pathinfo (struct config *conf, struct udev_device *udevice,
 	if (!pp)
 		return PATHINFO_FAILED;
 
-	if (wwid)
-		strlcpy(pp->wwid, wwid, sizeof(pp->wwid));
+	maybe_unmangle_wwid(pp->wwid, wwid);
 
 	if (safe_sprintf(pp->dev, "%s", devname)) {
 		condlog(0, "pp->dev too small");
@@ -2163,8 +2254,8 @@ get_udev_uid(struct path * pp, const char *uid_attribute, struct udev_device *ud
 	value = udev_device_get_property_value(udev, uid_attribute);
 	if ((!value || strlen(value) == 0) && pp->can_use_env_uid)
 		value = getenv(uid_attribute);
-	if (value && strlen(value)) {
-		len = strlcpy(pp->wwid, value, WWID_SIZE);
+	if (value && *value) {
+		len = maybe_unmangle_wwid(pp->wwid, value);
 		if (len >= WWID_SIZE) {
 			len = fix_broken_nvme_wwid(pp, value, WWID_SIZE);
 			if (len > 0)
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index 2ef1d94..4e9c5ae 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -30,6 +30,7 @@
 
 struct config;
 
+size_t maybe_unmangle_wwid(char new_wwid[WWID_SIZE], const char *wwid);
 int path_discovery (vector pathvec, int flag);
 int path_get_tpgs(struct path *pp); /* This function never returns TPGS_UNDEF */
 int do_tur (char *);
-- 
2.55.0

