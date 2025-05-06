Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440D31388
	for <dm-devel@lists.linux.dev>; Tue,  6 May 2025 22:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746570388; cv=none; b=lhxQTxFw1OEMqJM05b18y5Qv9pRMSs9a6Z6dnKcK+qV6Z8qdnh7Rgv8bEVdqaxiT/5m3VCMv2v6OZyjiOZCyiVkHB/zoNzgsO3MiL29ZLf61szVHeqeqbvRs8VnAOF+C9Nw+/71HhRy831aa+/PmhoHwy+BGf8m4BFpjZMmeRTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746570388; c=relaxed/simple;
	bh=qM8alw1/8LA4zEj9/rjLQvW4C/RFzZM40r2Z2B46t9k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=bpIMDBXCJfyJwfdOEKad+fYxq7B/xNrNGmBtla0+GQotzchUKrceo64JEof2OJ1SP7ayq2ObVqvvOrHsxVYruI4xzrSAHapzqgwgkBpScu1fcC1TOEZJeA2Pcc87LXoPOCDS8G18YR99xE7+5mTarYQElknGatsvovFevoGIeUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FeIZBLf1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FeIZBLf1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746570385;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aZ+PSdxaluJCqU8txC+kzwsnq37l67Uhllkg+hVars8=;
	b=FeIZBLf10qC+LKTxxCgPkp6K3yREbE1Sg1qecf64HX4jLH14Rd4x2yCFsGBajH2m9Qug6J
	szLYhnzNpkRkm3pRwwCr+l9yQxbXisob19kHLGNtjCk90KO9V2SdBjsZIJeVHJkMO7Vwlp
	1KqC62aaOnL69jy8qr7eBCg7geS7vHU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-681-OGgOp7FPOW6oURjGDlHSbA-1; Tue,
 06 May 2025 18:26:23 -0400
X-MC-Unique: OGgOp7FPOW6oURjGDlHSbA-1
X-Mimecast-MFC-AGG-ID: OGgOp7FPOW6oURjGDlHSbA_1746570382
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B9DC51801BD1;
	Tue,  6 May 2025 22:26:22 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 67D35180045B;
	Tue,  6 May 2025 22:26:22 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 546MQKap2974268
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 6 May 2025 18:26:21 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 546MQKiq2974267;
	Tue, 6 May 2025 18:26:20 -0400
Date: Tue, 6 May 2025 18:26:20 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Martin Wilck <mwilck@suse.com>, dm-devel@lists.linux.dev
Subject: Re: [PATCH 0/6] multipath-tools: static analyzer fixes
Message-ID: <aBqMjI8UWOWLlbGh@redhat.com>
References: <20250505163007.59352-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250505163007.59352-1-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: m9RSvTw8AFObUkTWQjbCTvYelTs038lFNG1PUqIMvn8_1746570382
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, May 05, 2025 at 06:29:52PM +0200, Martin Wilck wrote:
> Xose has kindly informed me about the warnings from Fedora's static
> code analysis tool.
> 
> I'm sending a couple of related fixes here. Most of the warnings
> appear to be false positives though, see below (a second look by
> another eye pair would be appreciated).

I mostly agree with you, except that I wouldn't call all the errors
related to VECTOR_SLOT() returning NULL false postitives (so maybe I
mostly disagree with you. I didn't count). If we are in a
vector_foreach_slot_*() loop and we are looking at
VECTOR_SLOT(<vector_we_are_looping_over>, <current_index_value>), then I
agree, we can't see a NULL value. But most, if not all, of the "NULL
value from a vector" errors that got flagged here were not protected by
the checks in vector_foreach_slot_*(). Now I don't know of any cases
where we do have NULLs in a vector, but we certainly could. We
manipulate them all over the code. If we ever call vector_alloc_slot()
and not vector_set_slot() we would have a NULL.  There's also no check
to make sure that we don't call vector_set_slot() with a NULL value.

We do have checks for NULL values when looping through vectors, and we
even have vector_repack() to get rid of them. So, it's completely
reasonable that a static analyzer would think that we might have a NULL
value in a vector. And I'm pretty sure that NULL values in a vector are
always a bug. They make vector_foreach_slot() unable to access any
values past them, despite the fact that we can keep adding values to the
vector.

Actually, cleaning this up, so that the code keeps us from having NULL
values in vectors as long as we only manipulate them with the functions
in vector.h has been on my todo list for a bit. It would take some code
auditing to make sure that there isn't a case where we do use vectors
where NULL values are expected. But if there is, I think that should use
a seperate set of functions, to clearly mark it out as special.

-Ben

> 
> Regards
> Martin
> 
> On Sat, 2025-05-03 at 23:29 +0200, Xose Vazquez Perez wrote:
> > Findings by static analyzers in Fedora 43 Critical Path Packages:
> > https://marc.info/?l=fedora-devel-list&m=174582743823723
> > 
> > device-mapper-multipath-0.11.1-1.fc43:
> > https://openscanhub.fedoraproject.org/task/51915/
> > 
> > device-mapper-multipath-0.11.1-1.fc43 List of Findings:
> > https://openscanhub.fedoraproject.org/task/51915/log/device-mapper-multipath-0.11.1-1.fc43/scan-results.html
> 
> I'll leave the shellcheck errors in mpathconf to Ben.
> 
> > Error: GCC_ANALYZER_WARNING (CWE-775): [#def42]
> > multipath-tools-0.11.1/kpartx/dasd.c:89:24: warning[-Wanalyzer-fd-leak]: leak of file descriptor ‘fd_dasd’
> > multipath-tools-0.11.1/kpartx/dasd.c:69:1: enter_function: entry to ‘read_dasd_pt’
> > ...
> > multipath-tools-0.11.1/kpartx/dasd.c:134:20: branch_true: following ‘true’ branch (when ‘fd_dasd < 0’)...
> > branch_true: ...to here
> 
> This one looks like a false positive to me. If fd_dasd < 0, it can't be leaked.
> 
> > Error: GCC_ANALYZER_WARNING (CWE-476): [#def45]
> > multipath-tools-0.11.1/libmpathutil/parser.c:139:29: warning[-Wanalyzer-null-dereference]: dereference of NULL ‘keyword’
> 
> False positive, too. VECTOR_SLOT won't return NULL here. 
> We could add a test to make the compiler happy, but I don't quite see the point.
> 
> > Error: GCC_ANALYZER_WARNING (CWE-457): [#def49]
> > multipath-tools-0.11.1/libmultipath/alias.c:201:31: warning[-Wanalyzer-use-of-uninitialized-value]: use of uninitialized value ‘bdg’
> 
> False positive. bdg won't be NULL here.
> 
> > Error: GCC_ANALYZER_WARNING (CWE-465): [#def50]
> > multipath-tools-0.11.1/libmultipath/dmparser.c:31:12: warning[-Wanalyzer-deref-before-check]: check of ‘p’ for NULL after already dereferencing it
> 
> False positive. *dst is non-NULL when we call merge_words(). We must double-check
> after calling realloc().
> (That said, we should reimplement this using strbuf functions).
> 
> > Error: GCC_ANALYZER_WARNING (CWE-476): [#def51]
> > multipath-tools-0.11.1/libmultipath/dmparser.c:436:25: warning[-Wanalyzer-null-dereference]: dereference of NULL ‘pgp’
> 
> False positive. VECTOR_SLOT won't return NULL here. Same for the next 3 errors.
> 
> > Error: GCC_ANALYZER_WARNING (CWE-476): [#def55]
> > multipath-tools-0.11.1/libmultipath/dmparser.c:501:33: warning[-Wanalyzer-null-dereference]: dereference of NULL ‘pp’
> 
> Likewise. Same for the next 2 errors.
> 
> > Error: GCC_ANALYZER_WARNING (CWE-476): [#def58]
> > multipath-tools-0.11.1/libmultipath/foreign/nvme.c:494:28: warning[-Wanalyzer-null-dereference]: dereference of NULL ‘path’
> 
> The nvme_pathgroup is a member of struct nvme_path. nvme_pg_to_path() doesn't return NULL. Same for the next 2 errors in nvme.c
> 
> > Error: GCC_ANALYZER_WARNING (CWE-476): [#def62]
> > multipath-tools-0.11.1/libmultipath/pgpolicies.c:191:17: warning[-Wanalyzer-null-dereference]: dereference of NULL ‘pp1’
> 
> Again, false positives; VECTOR_SLOT() doesn't return NULL here.
> Same for the next 3 errors.
> 
> > Error: GCC_ANALYZER_WARNING (CWE-401): [#def66]
> > multipath-tools-0.11.1/libmultipath/print.c:920:16: warning[-Wanalyzer-malloc-leak]: leak of ‘alloc_path_layout()’
> 
> False positive. Strange one - gcc doesn't understand its own __attribute__((cleanup))?
> Or am I blind? Same for the next one.
> 
> > Error: GCC_ANALYZER_WARNING (CWE-126): [#def70]
> multipath-tools-0.11.1/libmultipath/uevent.c:122:9: warning[-Wanalyzer-out-of-bounds]: stack-based buffer over-read
> 
> This one is somewhat harder because it involves list handling macros, but I believe that our code is correct and that this is a false positive, too.
> 
> > Error: GCC_ANALYZER_WARNING (CWE-775): [#def69]
> > multipath-tools-0.11.1/libmultipath/sysfs.c:309:22: warning[-Wanalyzer-fd-leak]: leak of file descriptor ‘open(&pathbuf, 0)’
> 
> Again, false positive; there's a cleanup function for fd.
> 
> > Error: GCC_ANALYZER_WARNING (CWE-775): [#def71]
> > multipath-tools-0.11.1/libmultipath/valid.c:208:34: warning[-Wanalyzer-file-leak]: leak of FILE ‘fopen(&mountinfo, "r")’
> 
> False positive, gcc doesn't understand the cleanup_fclose().
> Same for the next error.
> 
> > Error: GCC_ANALYZER_WARNING (CWE-415): [#def73]
> > multipath-tools-0.11.1/multipathd/fpin_handlers.c:508:17: warning[-Wanalyzer-double-free]: double-‘free’ of ‘els_marginal_list_head.next + -2056’
> 
> I don't see an error in this code. Looks like another false positive to me.
> 
> > Error: GCC_ANALYZER_WARNING: [#def74]
> > multipath-tools-0.11.1/multipathd/fpin_handlers.c:624:23: warning[-Wanalyzer-fd-use-without-check]: ‘read’ on possibly invalid file descriptor ‘fd’
> 
> False positive, too. fd == -1 is checked beforehand.
> 
> > Error: GCC_ANALYZER_WARNING (CWE-688): [#def75]
> > multipath-tools-0.11.1/multipathd/main.c:3286:21: warning[-Wanalyzer-null-argument]: use of NULL ‘new’ where non-null expected
> 
> Similar to other false positives above, VECTOR_SLOT() won't return NULL in a  loop like this.
> 
> > Error: GCC_ANALYZER_WARNING (CWE-775): [#def77]
> > multipath-tools-0.11.1/multipathd/main.c:3973:12: warning[-Wanalyzer-fd-leak]: leak of file descriptor ‘dup2(open("/dev/null", 2), 0)’
> 
> Yet another false positive, the fd is closed in the cleanup handler. Same for the next 3 errors.
> 
> > Error: GCC_ANALYZER_WARNING (CWE-476): [#def81]
> multipath-tools-0.11.1/multipathd/multipathc.c:97:30: warning[-Wanalyzer-null-dereference]: dereference of NULL ‘kw’
> 
> Another case of VECTOR_SLOT() false positive. Same for the next error.
> 
> Regards
> Martin
> 
> Martin Wilck (6):
>   kpartx_id: fix shellcheck reported errors
>   kpartx: fix file descriptor leak
>   libmpathpersist: fix memory leak in mpath_prout_rel()
>   libmpathutil: silence compiler warning in vector_del_slot()
>   libmultipath: fix undefined behavior in 31-bit shift
>   libmultipath: prioritizers/iet: fix possible NULL dereference
> 
>  kpartx/kpartx.c                     | 14 +++++++-------
>  kpartx/kpartx_id                    |  8 ++++----
>  libmpathpersist/mpath_persist_int.c | 12 ++++++------
>  libmpathutil/vector.c               | 16 ++++++++--------
>  libmultipath/nvme/nvme-ioctl.c      |  2 +-
>  libmultipath/prioritizers/iet.c     |  3 +++
>  6 files changed, 29 insertions(+), 26 deletions(-)
> 
> -- 
> 2.49.0

