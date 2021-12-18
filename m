Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B42ADC433F5
	for <dm-devel@archiver.kernel.org>; Sat, 18 Dec 2021 01:19:56 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-387-Y4555PdyP5ynr_bRuVIA5g-1; Fri, 17 Dec 2021 20:19:52 -0500
X-MC-Unique: Y4555PdyP5ynr_bRuVIA5g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0130F81CCB5;
	Sat, 18 Dec 2021 01:19:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7BAB212E1B;
	Sat, 18 Dec 2021 01:19:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6FA7C1809CB8;
	Sat, 18 Dec 2021 01:19:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BI1Hmdw011989 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 17 Dec 2021 20:17:48 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7C8852166B13; Sat, 18 Dec 2021 01:17:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 76C802166B4F
	for <dm-devel@redhat.com>; Sat, 18 Dec 2021 01:17:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9D117805B25
	for <dm-devel@redhat.com>; Sat, 18 Dec 2021 01:17:45 +0000 (UTC)
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com
	[209.85.128.47]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-443-d2j532yGO1qlu35pk4xdAA-1; Fri, 17 Dec 2021 20:17:43 -0500
X-MC-Unique: d2j532yGO1qlu35pk4xdAA-1
Received: by mail-wm1-f47.google.com with SMTP id
	n14-20020a7bcbce000000b00332f4abf43fso3334000wmi.0; 
	Fri, 17 Dec 2021 17:17:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=3IBCYfkWgH0fAcUn4/dstu6qStOBGoMsJFlej0QUMCY=;
	b=iAIjhy+EhGGzuMmlk8eeAW48EnMIYMTf/f2k6yVFwqpUYjXGVX1+pa9Q8se/a+sIGs
	WGDwLyXE1PpPaRPb3NnwP/Xv5HSQ75sikZLBBbZv5GGIQjDKhbBgBHZGgRyoaOU/TPpN
	PQ9pyLs/fLh5Sh1TSCwA/hgzmJ1hnRhclqpTNeFGzfPyqhPNAsffYNie2aj0LyL69KJ/
	g+EGa8yNLPV8JAbAzFbIKXBCCVY/U92r0M0C0D5/pX+XylPOAUwOZ2T25UoanthHNYdd
	Xcti8MtrMfXtVGIgkj7QzXJz9N6E1w0GzyB6yAYtGMPoiP+MUyqIQ1Oam9EwTf1qcFLj
	IKWg==
X-Gm-Message-State: AOAM532+DhvYyyX/+j3ERlrEIknnHSs+KW2w6Zi1L42vcOnjmiw7U8Je
	jKv12TZ0z4/w1W8dCgm0GQ==
X-Google-Smtp-Source: ABdhPJyyM0AfVDmhi+qbDD4AhgK8l7q+cFYwGuxDV4zBGv+qHDWkq07JISrn4zHp+SQZ2B6uA+BFiQ==
X-Received: by 2002:a1c:a301:: with SMTP id m1mr11637512wme.118.1639790262202; 
	Fri, 17 Dec 2021 17:17:42 -0800 (PST)
Received: from localhost (255.red-79-146-223.dynamicip.rima-tde.net.
	[79.146.223.255]) by smtp.gmail.com with ESMTPSA id
	t17sm12843257wmq.15.2021.12.17.17.17.41
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 17 Dec 2021 17:17:41 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Sat, 18 Dec 2021 02:17:39 +0100
Message-Id: <20211218011739.51473-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>,
	DM-DEVEL ML <dm-devel@redhat.com>
Subject: [dm-devel] [PATCH] multipath-tools: fix misspellings
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
Unsure about: ./libmpathpersist/mpath_persist.h:80: FORMATE ==> FORMAT ???
---
CHANGES:
./kpartx/crc32.c:345: multile ==> multiple
./kpartx/gpt.c:97: MSDOS ==> MS-DOS
./libdmmp/libdmmp.c:192: retuned ==> returned
./libmpathcmd/mpath_cmd.h:83: successs ==> success
./libmpathpersist/mpath_persist_int.c:549: avialable ==> available
./libmpathvalid/mpath_valid.h:86: reinitalize ==> reinitialize
./libmpathvalid/mpath_valid.h:98: resoures ==> resources
./libmpathvalid/mpath_valid.h:99: futher ==> further
./libmultipath/checkers/directio.c:26: multple ==> multiple
./libmultipath/checkers.h:159: asyncronous ==> asynchronous
./libmultipath/dmparser.c:105: unkown ==> unknown
./libmultipath/foreign.h:45: strucure ==> structure
./libmultipath/Makefile:64: nees ==> needs
./libmultipath/prioritizers/alua_spc3.h:289: asymetric ==> asymmetric
./libmultipath/prioritizers/path_latency.c:287: thresold ==> threshold
./libmultipath/uevent.c:295: exsit ==> exist
./multipathd/dmevents.c:388: intialized ==> initialized
./multipathd/main.c:1602: initalized ==> initialized
./multipathd/main.c:1794: hadling ==> handling
./multipathd/main.c:2110: occured ==> occurred
./multipathd/main.c:2280: abnormaly ==> abnormally
./multipathd/main.h:20: occassion ==> occasion
./multipathd/multipathd.8:85: seperate ==> separate
./multipathd/uxlsnr.c:78: mumber ==> number
./multipath/multipath.conf.5:1100: seperate ==> separate
./multipath/multipath.conf.5:1101: occuring ==> occurring
./multipath/multipath.conf.5:1143: encounted ==> encountered
./multipath/multipath.conf.5:1423: agains ==> against
./multipath/multipath.conf.5:1550: wilcard ==> wildcard
./multipath/multipath.conf.5:1798: occurence ==> occurrence
./multipath/multipath.conf.5:254: effiency ==> efficiency
./multipath/multipath.conf.5:590: greated ==> greater
./multipath/multipath.conf.5:833: mutipath ==> multipath
./tests/hwtable.c:1006: trival ==> trivial
./tests/hwtable.c:1046: trival ==> trivial
./tests/hwtable.c:1089: trival ==> trivial
./tests/hwtable.c:424: expresssions ==> expressions
./tests/hwtable.c:606: qith ==> with
./tests/hwtable.c:970: trival ==> trivial
./tests/README.md:41: containting ==> containing

SUMMARY:
abnormaly     1
asymetric     1
asyncronous   1
avialable     1
containting   1
effiency      1
expresssions  1
futher        1
hadling       1
initalized    1
intialized    1
msdos         1
multile       1
multple       1
mumber        1
mutipath      1
nees          1
occassion     1
occured       1
occurence     1
occuring      1
qith          1
reinitalize   1
resoures      1
retuned       1
seperate      2
strucure      1
successs      1
thresold      1
trival        4
unkown        1
wilcard       1
---
 kpartx/crc32.c                           |  2 +-
 kpartx/gpt.c                             |  2 +-
 libdmmp/libdmmp.c                        |  2 +-
 libmpathcmd/mpath_cmd.h                  |  2 +-
 libmpathpersist/mpath_persist_int.c      |  2 +-
 libmpathvalid/mpath_valid.h              |  6 +++---
 libmultipath/Makefile                    |  2 +-
 libmultipath/checkers.h                  |  2 +-
 libmultipath/checkers/directio.c         |  2 +-
 libmultipath/dmparser.c                  |  2 +-
 libmultipath/foreign.h                   |  2 +-
 libmultipath/prioritizers/alua_spc3.h    |  2 +-
 libmultipath/prioritizers/path_latency.c |  2 +-
 libmultipath/uevent.c                    |  2 +-
 multipath/multipath.conf.5               | 18 +++++++++---------
 multipathd/dmevents.c                    |  2 +-
 multipathd/main.c                        |  8 ++++----
 multipathd/main.h                        |  2 +-
 multipathd/multipathd.8                  |  2 +-
 multipathd/uxlsnr.c                      |  2 +-
 tests/README.md                          |  2 +-
 tests/hwtable.c                          | 12 ++++++------
 22 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/kpartx/crc32.c b/kpartx/crc32.c
index b23a0835..e688f8e9 100644
--- a/kpartx/crc32.c
+++ b/kpartx/crc32.c
@@ -342,7 +342,7 @@ uint32_t attribute((pure)) crc32_be(uint32_t crc, unsigned char const *p, size_t
  * but again the multiple of the polynomial to subtract depends only on
  * the high bits, the high 8 bits in this case.
  *
- * The multile we need in that case is the low 32 bits of a 40-bit
+ * The multiple we need in that case is the low 32 bits of a 40-bit
  * value whose high 8 bits are given, and which is a multiple of the
  * generator polynomial.  This is simply the CRC-32 of the given
  * one-byte message.
diff --git a/kpartx/gpt.c b/kpartx/gpt.c
index f7fefb70..34a910cf 100644
--- a/kpartx/gpt.c
+++ b/kpartx/gpt.c
@@ -94,7 +94,7 @@ efi_crc32(const void *buf, unsigned long len)
  *
  * Description: Returns 1 if PMBR is valid, 0 otherwise.
  * Validity depends on two things:
- *  1) MSDOS signature is in the last two bytes of the MBR
+ *  1) MS-DOS signature is in the last two bytes of the MBR
  *  2) One partition of type 0xEE is found
  */
 static int
diff --git a/libdmmp/libdmmp.c b/libdmmp/libdmmp.c
index aafd5099..51f1d8fc 100644
--- a/libdmmp/libdmmp.c
+++ b/libdmmp/libdmmp.c
@@ -189,7 +189,7 @@ int dmmp_mpath_array_get(struct dmmp_context *ctx,
 	j_token = json_tokener_new();
 	if (j_token == NULL) {
 		rc = DMMP_ERR_BUG;
-		_error(ctx, "BUG: json_tokener_new() retuned NULL");
+		_error(ctx, "BUG: json_tokener_new() returned NULL");
 		goto out;
 	}
 	j_obj = json_tokener_parse_ex(j_token, j_str, strlen(j_str) + 1);
diff --git a/libmpathcmd/mpath_cmd.h b/libmpathcmd/mpath_cmd.h
index ccfd35f2..30838b02 100644
--- a/libmpathcmd/mpath_cmd.h
+++ b/libmpathcmd/mpath_cmd.h
@@ -80,7 +80,7 @@ int mpath_disconnect(int fd);
  *	mpath_recv_reply()
  *
  * RETURNS:
- *	0 on successs, and reply will either be NULL (if there was no
+ *	0 on success, and reply will either be NULL (if there was no
  *	reply data), or point to the reply string, which must be freed by
  *	the caller. -1 on failure (with errno set).
  */
diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index c6fc2871..e34fc32d 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -546,7 +546,7 @@ static int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
 		condlog (2, "%s: Path holding reservation is released.", mpp->wwid);
 		return MPATH_PR_SUCCESS;
 	}
-	condlog (2, "%s: Path holding reservation is not avialable.", mpp->wwid);
+	condlog (2, "%s: Path holding reservation is not available.", mpp->wwid);
 
 	pr_buff =  mpath_alloc_prin_response(MPATH_PRIN_RFSTAT_SA);
 	if (!pr_buff){
diff --git a/libmpathvalid/mpath_valid.h b/libmpathvalid/mpath_valid.h
index 63de4e1c..ed06196e 100644
--- a/libmpathvalid/mpath_valid.h
+++ b/libmpathvalid/mpath_valid.h
@@ -83,7 +83,7 @@ int mpathvalid_init(int verbosity, int log_style);
 
 /*
  * DESCRIPTION:
- * 	Reread the multipath configuration files and reinitalize
+ * 	Reread the multipath configuration files and reinitialize
  * 	the device mapper multipath configuration. This function can
  * 	be called as many times as necessary.
  *
@@ -95,8 +95,8 @@ int mpathvalid_reload_config(void);
 /*
  * DESCRIPTION:
  * 	Release the device mapper multipath configuration. This
- * 	function must be called to cleanup resoures allocated by
- * 	mpathvalid_init(). After calling this function, no futher
+ * 	function must be called to cleanup resources allocated by
+ * 	mpathvalid_init(). After calling this function, no further
  * 	libmpathvalid functions may be called.
  *
  * RETURNS: 0 = Success, -1 = Failure
diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index d4af1a54..4a95cc06 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -61,7 +61,7 @@ nvme-lib.o: nvme-lib.c nvme-ioctl.c nvme-ioctl.h
 	$(CC) $(CFLAGS) -Wno-unused-function -c -o $@ $<
 
 # there are lots of "unused parameters" in dict.c
-# because not all handler / snprint methods nees all parameters
+# because not all handler / snprint methods needs all parameters
 dict.o:	dict.c
 	$(CC) $(CFLAGS) -Wno-unused-parameter -c -o $@ $<
 
diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index f4600ed3..5d25a421 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -156,7 +156,7 @@ void checker_disable (struct checker *);
  *
  * Rationale:
  * Path checkers that do I/O may hang forever. To avoid blocking, some
- * checkers therefore use asyncronous, detached threads for checking
+ * checkers therefore use asynchronous, detached threads for checking
  * the paths. These threads may continue hanging if multipathd is stopped.
  * In this case, we can't unload the checker DSO at exit. In order to
  * avoid race conditions and crashes, the entry point of the thread
diff --git a/libmultipath/checkers/directio.c b/libmultipath/checkers/directio.c
index f73cbe38..28b0cf51 100644
--- a/libmultipath/checkers/directio.c
+++ b/libmultipath/checkers/directio.c
@@ -23,7 +23,7 @@
 
 /* Note: This checker type relies on the fact that only one checker can be run
  * at a time, since multiple checkers share the same aio_group, and must be
- * able to modify other checker's async_reqs. If multple checkers become able
+ * able to modify other checker's async_reqs. If multiple checkers become able
  * to be run at the same time, this checker will need to add locking, and
  * probably polling on event fds, to deal with that */
 
diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index 74c92155..24ba4ac3 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -102,7 +102,7 @@ err:
 }
 
 /*
- * Caution callers: If this function encounters yet unkown path devices, it
+ * Caution callers: If this function encounters yet unknown path devices, it
  * adds them uninitialized to the mpp.
  * Call update_pathvec_from_dm() after this function to make sure
  * all data structures are in a sane state.
diff --git a/libmultipath/foreign.h b/libmultipath/foreign.h
index cf8f570d..f547c14b 100644
--- a/libmultipath/foreign.h
+++ b/libmultipath/foreign.h
@@ -42,7 +42,7 @@ struct foreign {
 	/**
 	 * method: init(api, name)
 	 * Initialize foreign library, and check API compatibility
-	 * return pointer to opaque internal data strucure if successful,
+	 * return pointer to opaque internal data structure if successful,
 	 * NULL otherwise.
 	 *
 	 * @param[in] api: API version
diff --git a/libmultipath/prioritizers/alua_spc3.h b/libmultipath/prioritizers/alua_spc3.h
index f0a4bc44..08e992bd 100644
--- a/libmultipath/prioritizers/alua_spc3.h
+++ b/libmultipath/prioritizers/alua_spc3.h
@@ -286,7 +286,7 @@ struct rtpg_tp_dscr {
 struct rtpg_tpg_dscr {
 	unsigned char	b0;		/* x....... = pref(ered) port        */
 					/* .xxx.... = reserved               */
-					/* ....xxxx = asymetric access state */
+					/* ....xxxx = asymmetric access state*/
 	unsigned char	b1;		/* xxx..... = reserved               */
 					/* ...x.... = LBA dependent support  */
 					/* ....x... = unavailable support    */
diff --git a/libmultipath/prioritizers/path_latency.c b/libmultipath/prioritizers/path_latency.c
index 078226df..e155f6dc 100644
--- a/libmultipath/prioritizers/path_latency.c
+++ b/libmultipath/prioritizers/path_latency.c
@@ -284,7 +284,7 @@ int getprio(struct path *pp, char *args, unsigned int timeout)
 
 	if (lg_avglatency > lg_maxavglatency) {
 		pp_pl_log(2,
-			  "%s: average latency (%lld us) is outside the thresold (%lld us)",
+			  "%s: average latency (%lld us) is outside the threshold (%lld us)",
 			  pp->dev, (long long)pow(base_num, lg_avglatency),
 			  (long long)MAX_AVG_LATENCY);
 		return DEFAULT_PRIORITY;
diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 70ad2175..b1f00b3e 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -292,7 +292,7 @@ static bool
 uevent_can_merge(struct uevent *earlier, struct uevent *later)
 {
 	/* merge paths uevents
-	 * whose wwids exsit and are same
+	 * whose wwids exist and are same
 	 * and actions are same,
 	 * and actions are addition or deletion
 	 */
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 88d2a1df..80fa2920 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -251,7 +251,7 @@ The default is: \fBfailover\fR
 .B uid_attrs
 .
 Setting this option activates \fBmerging uevents\fR by WWID, which may improve
-uevent processing effiency. Moreover, it's an alternative method to configure
+uevent processing efficiency. Moreover, it's an alternative method to configure
 the udev properties to use for determining unique path identifiers (WWIDs).
 .RS
 .PP
@@ -587,7 +587,7 @@ and multipathd. This is equivalent to ulimit \-n. A value of \fImax\fR will set
 this to the system limit from \fI/proc/sys/fs/nr_open\fR. If this is not set, the
 maximum number of open fds is taken from the calling process. It is usually
 1024. To be safe, this should be set to the maximum number of paths plus 32,
-if that number is greated than 1024.
+if that number is greater than 1024.
 .RS
 .TP
 The default is: \fBmax\fR
@@ -830,7 +830,7 @@ The default is: \fBno\fR
 .I yes
 and the SCSI layer has already attached a hardware_handler to the device,
 multipath will not force the device to use the hardware_handler specified by
-mutipath.conf. If the SCSI layer has not attached a hardware handler,
+multipath.conf. If the SCSI layer has not attached a hardware handler,
 multipath will continue to use its configured hardware handler.
 .RS
 .PP
@@ -1097,8 +1097,8 @@ device is not configured to queue IO in this case, it can cause IO errors to
 occur, even though there are marginal paths available.  However, if this
 option is set to \fIyes\fR, when one of the marginal path detecting methods
 determines that a path is marginal, it will be reinstated and placed in a
-seperate pathgroup that will only be used after all the non-marginal pathgroups
-have been tried first. This prevents the possibility of IO errors occuring
+separate pathgroup that will only be used after all the non-marginal pathgroups
+have been tried first. This prevents the possibility of IO errors occurring
 while marginal paths are still usable. After the path has been monitored
 for the configured time, and is declared healthy, it will be returned to its
 normal pathgroup. See "Shaky paths detection" below for more information.
@@ -1140,7 +1140,7 @@ device path.
 .I smart
 This differs from \fIfind_multipaths yes\fR only in
 the way it treats new devices for which only one path has been
-detected yet. When such a device is first encounted in udev rules, it is
+detected yet. When such a device is first encountered in udev rules, it is
 treated as a multipath device. multipathd waits whether additional paths with
 the same WWID appears. If that happens, it sets up a multipath map. If it
 doesn\'t happen until a
@@ -1420,7 +1420,7 @@ from later entries take precedence.
 The \fImultipath\fR subsection recognizes the following attributes:
 .TP 17
 .B wwid
-(Mandatory) World Wide Identifier. Detected multipath maps are matched agains this attribute.
+(Mandatory) World Wide Identifier. Detected multipath maps are matched against this attribute.
 Note that, unlike the \fIwwid\fR attribute in the \fIblacklist\fR section,
 this is \fBnot\fR a regular expression or a substring; WWIDs must match
 exactly inside the multipaths section.
@@ -1547,7 +1547,7 @@ device type, instead of the default "mpath".
 The vendor specific vpd page information, using the vpd page abbreviation.
 The vpd page abbreviation can be found by running \fIsg_vpd -e\fR. multipathd
 will use this information to gather device specific information that can be
-displayed with the \fI%g\fR wilcard for the \fImultipathd show maps format\fR
+displayed with the \fI%g\fR wildcard for the \fImultipathd show maps format\fR
 and \fImultipathd show paths format\fR commands. Currently only the
 \fBhp3par\fR vpd page is supported.
 .TP
@@ -1795,7 +1795,7 @@ in most scenarios. Users who want to enable uevent merging must set
 .SH "Shaky paths detection"
 .\" ----------------------------------------------------------------------------
 .
-A common problem in SAN setups is the occurence of intermittent errors: a
+A common problem in SAN setups is the occurrence of intermittent errors: a
 path is unreachable, then reachable again for a short time, disappears again,
 and so forth. This happens typically on unstable interconnects. It is
 undesirable to switch pathgroups unnecessarily on such frequent, unreliable
diff --git a/multipathd/dmevents.c b/multipathd/dmevents.c
index f035ee7f..3a859691 100644
--- a/multipathd/dmevents.c
+++ b/multipathd/dmevents.c
@@ -385,7 +385,7 @@ void *wait_dmevents (__attribute__((unused)) void *unused)
 
 
 	if (!waiter) {
-		condlog(0, "dmevents waiter not intialized");
+		condlog(0, "dmevents waiter not initialized");
 		return NULL;
 	}
 
diff --git a/multipathd/main.c b/multipathd/main.c
index 6087b5f4..4d611647 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1599,7 +1599,7 @@ out:
 
 		condlog(0, "%s: spurious uevent, path not found", uev->kernel);
 	}
-	/* pp->initalized must not be INIT_PARTIAL if needs_reinit is set */
+	/* pp->initialized must not be INIT_PARTIAL if needs_reinit is set */
 	if (needs_reinit)
 		retval = uev_add_path(uev, vecs, 1);
 	return retval;
@@ -1791,7 +1791,7 @@ uxlsnrloop (void * ap)
 
 	/*
 	 * Wait for initial reconfiguration to finish, while
-	 * hadling signals
+	 * handling signals
 	 */
 	while (wait_for_state_change_if(DAEMON_CONFIGURE, 50)
 	       == DAEMON_CONFIGURE)
@@ -2107,7 +2107,7 @@ static int check_path_reinstate_state(struct path * pp) {
 	/*
 	 * This function is only called when the path state changes
 	 * from "bad" to "good". pp->state reflects the *previous* state.
-	 * If this was "bad", we know that a failure must have occured
+	 * If this was "bad", we know that a failure must have occurred
 	 * beforehand, and count that.
 	 * Note that we count path state _changes_ this way. If a path
 	 * remains in "bad" state, failure count is not increased.
@@ -2277,7 +2277,7 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 
 	/*
 	 * provision a next check soonest,
-	 * in case we exit abnormaly from here
+	 * in case we exit abnormally from here
 	 */
 	pp->tick = checkint;
 
diff --git a/multipathd/main.h b/multipathd/main.h
index 459c7342..e8bee8e6 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -17,7 +17,7 @@ enum remove_path_result {
 	REMOVE_PATH_FAILURE = 0x0, /* path could not be removed. It is still
 				    * part of the kernel map, but its state
 				    * is set to INIT_REMOVED, and it will be
-				    * removed at the next possible occassion */
+				    * removed at the next possible occasion */
 	REMOVE_PATH_SUCCESS = 0x1, /* path was removed */
 	REMOVE_PATH_DELAY = 0x2, /* path is set to be removed later. it
 			          * currently still exists and is part of the
diff --git a/multipathd/multipathd.8 b/multipathd/multipathd.8
index 293e7f22..1e318bdc 100644
--- a/multipathd/multipathd.8
+++ b/multipathd/multipathd.8
@@ -82,7 +82,7 @@ multipathd. See
 .B \-w
 Since kernel 4.14 a new device-mapper event polling interface is used for updating
 multipath devices on dmevents. Use this flag to force it to use the old event
-waiting method, based on creating a seperate thread for each device.
+waiting method, based on creating a separate thread for each device.
 .
 .
 .
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 912ac3c5..c07367f3 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -75,7 +75,7 @@ enum {
 };
 
 #define POLLFD_CHUNK (4096 / sizeof(struct pollfd))
-/* Minimum mumber of pollfds to reserve for clients */
+/* Minimum number of pollfds to reserve for clients */
 #define MIN_POLLS (POLLFD_CHUNK - POLLFDS_BASE)
 /*
  * Max number of client connections allowed
diff --git a/tests/README.md b/tests/README.md
index 47c0f0b2..f0d9be3e 100644
--- a/tests/README.md
+++ b/tests/README.md
@@ -38,7 +38,7 @@ device will be opened in read-only mode; you don't need to worry about data
 loss. However, the user needs to specify a device to be used. Set the
 environment variable `DIO_TEST_DEV` to the path of the device.
 Alternatively, create a file `directio_test_dev` under
-the `tests` directory containting a single line that sets this environment
+the `tests` directory containing a single line that sets this environment
 variable in Bourne Shell syntax, like this:
 
     DIO_TEST_DEV=/dev/sdc3
diff --git a/tests/hwtable.c b/tests/hwtable.c
index 6f5766f7..79bfa5f4 100644
--- a/tests/hwtable.c
+++ b/tests/hwtable.c
@@ -421,7 +421,7 @@ static const struct key_value vnd_boo = { _vendor, "boo" };
 static const struct key_value prd_baz = { _product, "baz" };
 static const struct key_value wwid_test = { _wwid, default_wwid };
 
-/* Regular expresssions */
+/* Regular expressions */
 static const struct key_value vnd__oo = { _vendor, ".oo" };
 static const struct key_value vnd_t_oo = { _vendor, "^.oo" };
 static const struct key_value prd_ba_ = { _product, "ba." };
@@ -603,7 +603,7 @@ static int setup_internal_nvme(void **state)
 }
 
 /*
- * Device section with a simple entry qith double quotes ('foo:"bar"')
+ * Device section with a simple entry with double quotes ('foo:"bar"')
  */
 static void test_quoted_hwe(const struct hwt_state *hwt)
 {
@@ -967,7 +967,7 @@ static int setup_string_regex_hwe_dir(void **state)
 }
 
 /*
- * Two identical device entries kv1 and kv2, trival regex ("string").
+ * Two identical device entries kv1 and kv2, trivial regex ("string").
  * Both are added to the main config file.
  * These entries are NOT merged.
  * This could happen in a large multipath.conf file.
@@ -1003,7 +1003,7 @@ static int setup_2_ident_strings_hwe(void **state)
 }
 
 /*
- * Two identical device entries kv1 and kv2, trival regex ("string").
+ * Two identical device entries kv1 and kv2, trivial regex ("string").
  * Both are added to an extra config file.
  * This could happen in a large multipath.conf file.
  *
@@ -1043,7 +1043,7 @@ static int setup_2_ident_strings_both_dir(void **state)
 }
 
 /*
- * Two identical device entries kv1 and kv2, trival regex ("string").
+ * Two identical device entries kv1 and kv2, trivial regex ("string").
  * Both are added to an extra config file.
  * An empty entry kv0 with the same string exists in the main config file.
  *
@@ -1086,7 +1086,7 @@ static int setup_2_ident_strings_both_dir_w_prev(void **state)
 }
 
 /*
- * Two identical device entries kv1 and kv2, trival regex ("string").
+ * Two identical device entries kv1 and kv2, trivial regex ("string").
  * kv1 is added to the main config file, kv2 to a config_dir file.
  * These entries are merged.
  * This case is more important as you may think, because it's equivalent
-- 
2.33.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

