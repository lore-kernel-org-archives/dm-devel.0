Return-Path: <SRS0=8PHT=N6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD799C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  8 Sep 2021 07:23:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6986A61155
	for <dm-devel@archiver.kernel.org>; Wed,  8 Sep 2021 07:23:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6986A61155
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1631085784;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=lmPLxQf4UwQEy+RhGu0P34PwaorSlrSuZ4APzQ8YYNw=;
	b=L9LH3oEil06QdqDwDePYZvS34oafw8Ii2clnkBWuaVyXt7PpFSPAa5ziULIW5BWn0idIfm
	ex7xQ3W6EGdZp+/TU83Wrk9uzvmJJNmq8MSmD8UVuGamu25ob3HAYugDjzVp3FLblEHzDO
	dxw3qheR3Mcr5G0iJdCYDA9L5HkU8h0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-Gash48s2OB22-1CBEffnbA-1; Wed, 08 Sep 2021 03:23:03 -0400
X-MC-Unique: Gash48s2OB22-1CBEffnbA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B1E75801A92;
	Wed,  8 Sep 2021 07:22:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 495B91ABD8;
	Wed,  8 Sep 2021 07:22:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9BF861809C98;
	Wed,  8 Sep 2021 07:22:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1880xw3o014305 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 7 Sep 2021 20:59:58 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id BBFFB5D9F0; Wed,  8 Sep 2021 00:59:58 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.3.128.14])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 40A2B5D9DC;
	Wed,  8 Sep 2021 00:59:44 +0000 (UTC)
Date: Tue, 7 Sep 2021 20:59:42 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: Michael =?iso-8859-1?Q?Wei=DF?= <michael.weiss@aisec.fraunhofer.de>
Message-ID: <20210908005942.GJ490529@madcap2.tricolour.ca>
References: <20210904095934.5033-1-michael.weiss@aisec.fraunhofer.de>
MIME-Version: 1.0
In-Reply-To: <20210904095934.5033-1-michael.weiss@aisec.fraunhofer.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 08 Sep 2021 03:22:49 -0400
Cc: Paul Moore <paul@paul-moore.com>, Mike Snitzer <snitzer@redhat.com>,
	linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
	linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
	dm-devel@redhat.com, linux-audit@redhat.com,
	Casey Schaufler <casey@schaufler-ca.com>, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v4 0/3] dm: audit event logging
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
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On 2021-09-04 11:59, Michael Wei=DF wrote:
> dm integrity and also stacked dm crypt devices track integrity
> violations internally. Thus, integrity violations could be polled
> from user space, e.g., by 'integritysetup status'.
>=20
> >From an auditing perspective, we only could see that there were
> a number of integrity violations, but not when and where the
> violation exactly was taking place. The current error log to
> the kernel ring buffer, contains those information, time stamp and
> sector on device. However, for auditing the audit subsystem provides
> a separate logging mechanism which meets certain criteria for secure
> audit logging.
>=20
> With this small series we make use of the kernel audit framework
> and extend the dm driver to log audit events in case of such
> integrity violations. Further, we also log construction and
> destruction of the device mappings.
>=20
> We focus on dm-integrity and stacked dm-crypt devices for now.
> However, the helper functions to log audit messages should be
> applicable to dm-verity too.
>=20
> The first patch introduce generic audit wrapper functions.
> The second patch makes use of the audit wrapper functions in the
> dm-integrity.c.
> The third patch uses the wrapper functions in dm-crypt.c.
>=20
> The audit logs look like this if executing the following simple test:
>=20
> # dd if=3D/dev/zero of=3Dtest.img bs=3D1M count=3D1024
> # losetup -f test.img
> # integritysetup -vD format --integrity sha256 -t 32 /dev/loop0
> # integritysetup open -D /dev/loop0 --integrity sha256 integritytest
> # integritysetup status integritytest
> # integritysetup close integritytest
> # integritysetup open -D /dev/loop0 --integrity sha256 integritytest
> # integritysetup status integritytest
> # dd if=3D/dev/urandom of=3D/dev/loop0 bs=3D512 count=3D1 seek=3D100000
> # dd if=3D/dev/mapper/integritytest of=3D/dev/null
>=20
> -------------------------
> audit.log from auditd
>=20
> type=3DUNKNOWN[1336] msg=3Daudit(1630425039.363:184): module=3Dintegrity =
op=3Dctr ppid=3D3807 pid=3D3819 auid=3D1000 uid=3D0 gid=3D0 euid=3D0 suid=
=3D0 fsuid=3D0 egid=3D0 sgid=3D0 fsgid=3D0 tty=3Dpts2 ses=3D3 comm=3D"integ=
ritysetup" exe=3D"/sbin/integritysetup" subj=3D=3Dunconfined dev=3D254:3 er=
ror_msg=3D'success' res=3D1
> type=3DUNKNOWN[1336] msg=3Daudit(1630425039.471:185): module=3Dintegrity =
op=3Ddtr ppid=3D3807 pid=3D3819 auid=3D1000 uid=3D0 gid=3D0 euid=3D0 suid=
=3D0 fsuid=3D0 egid=3D0 sgid=3D0 fsgid=3D0 tty=3Dpts2 ses=3D3 comm=3D"integ=
ritysetup" exe=3D"/sbin/integritysetup" subj=3D=3Dunconfined dev=3D254:3 er=
ror_msg=3D'success' res=3D1
> type=3DUNKNOWN[1336] msg=3Daudit(1630425039.611:186): module=3Dintegrity =
op=3Dctr ppid=3D3807 pid=3D3819 auid=3D1000 uid=3D0 gid=3D0 euid=3D0 suid=
=3D0 fsuid=3D0 egid=3D0 sgid=3D0 fsgid=3D0 tty=3Dpts2 ses=3D3 comm=3D"integ=
ritysetup" exe=3D"/sbin/integritysetup" subj=3D=3Dunconfined dev=3D254:3 er=
ror_msg=3D'success' res=3D1
> type=3DUNKNOWN[1336] msg=3Daudit(1630425054.475:187): module=3Dintegrity =
op=3Ddtr ppid=3D3807 pid=3D3819 auid=3D1000 uid=3D0 gid=3D0 euid=3D0 suid=
=3D0 fsuid=3D0 egid=3D0 sgid=3D0 fsgid=3D0 tty=3Dpts2 ses=3D3 comm=3D"integ=
ritysetup" exe=3D"/sbin/integritysetup" subj=3D=3Dunconfined dev=3D254:3 er=
ror_msg=3D'success' res=3D1
>=20
> type=3DUNKNOWN[1336] msg=3Daudit(1630425073.171:191): module=3Dintegrity =
op=3Dctr ppid=3D3807 pid=3D3883 auid=3D1000 uid=3D0 gid=3D0 euid=3D0 suid=
=3D0 fsuid=3D0 egid=3D0 sgid=3D0 fsgid=3D0 tty=3Dpts2 ses=3D3 comm=3D"integ=
ritysetup" exe=3D"/sbin/integritysetup" subj=3D=3Dunconfined dev=3D254:3 er=
ror_msg=3D'success' res=3D1
>=20
> type=3DUNKNOWN[1336] msg=3Daudit(1630425087.239:192): module=3Dintegrity =
op=3Ddtr ppid=3D3807 pid=3D3902 auid=3D1000 uid=3D0 gid=3D0 euid=3D0 suid=
=3D0 fsuid=3D0 egid=3D0 sgid=3D0 fsgid=3D0 tty=3Dpts2 ses=3D3 comm=3D"integ=
ritysetup" exe=3D"/sbin/integritysetup" subj=3D=3Dunconfined dev=3D254:3 er=
ror_msg=3D'success' res=3D1
>=20
> type=3DUNKNOWN[1336] msg=3Daudit(1630425093.755:193): module=3Dintegrity =
op=3Dctr ppid=3D3807 pid=3D3906 auid=3D1000 uid=3D0 gid=3D0 euid=3D0 suid=
=3D0 fsuid=3D0 egid=3D0 sgid=3D0 fsgid=3D0 tty=3Dpts2 ses=3D3 comm=3D"integ=
ritysetup" exe=3D"/sbin/integritysetup" subj=3D=3Dunconfined dev=3D254:3 er=
ror_msg=3D'success' res=3D1
>=20
> type=3DUNKNOWN[1337] msg=3Daudit(1630425112.119:194): module=3Dintegrity =
op=3Dintegrity-checksum dev=3D254:3 sector=3D77480 res=3D0
> type=3DUNKNOWN[1337] msg=3Daudit(1630425112.119:195): module=3Dintegrity =
op=3Dintegrity-checksum dev=3D254:3 sector=3D77480 res=3D0
> type=3DUNKNOWN[1337] msg=3Daudit(1630425112.119:196): module=3Dintegrity =
op=3Dintegrity-checksum dev=3D254:3 sector=3D77480 res=3D0
> type=3DUNKNOWN[1337] msg=3Daudit(1630425112.119:197): module=3Dintegrity =
op=3Dintegrity-checksum dev=3D254:3 sector=3D77480 res=3D0
> type=3DUNKNOWN[1337] msg=3Daudit(1630425112.119:198): module=3Dintegrity =
op=3Dintegrity-checksum dev=3D254:3 sector=3D77480 res=3D0
> type=3DUNKNOWN[1337] msg=3Daudit(1630425112.119:199): module=3Dintegrity =
op=3Dintegrity-checksum dev=3D254:3 sector=3D77480 res=3D0
> type=3DUNKNOWN[1337] msg=3Daudit(1630425112.119:200): module=3Dintegrity =
op=3Dintegrity-checksum dev=3D254:3 sector=3D77480 res=3D0
> type=3DUNKNOWN[1337] msg=3Daudit(1630425112.119:201): module=3Dintegrity =
op=3Dintegrity-checksum dev=3D254:3 sector=3D77480 res=3D0
> type=3DUNKNOWN[1337] msg=3Daudit(1630425112.119:202): module=3Dintegrity =
op=3Dintegrity-checksum dev=3D254:3 sector=3D77480 res=3D0
> type=3DUNKNOWN[1337] msg=3Daudit(1630425112.119:203): module=3Dintegrity =
op=3Dintegrity-checksum dev=3D254:3 sector=3D77480 res=3D0

Are these isolated records, or are they accompanied by a type=3DSYSCALL
record in your logs?

The reason I ask is that audit_log_task_info() is included in three of
the calling methods (dm_audit_log_{target,ctr,dtr}) which use a
combination of AUDIT_DM_CTRL/AUDIT_DM_EVENT type while the fourth
(dm_audit_log_bio) also uses one of the types above but does not include
audit_log_task_info().  If all these records are accompanied by SYSCALL
records, then the task info would be redundant (and might even conflict
if there's a bug).  Another minor oddity is the double "=3D" for the subj
field, which doesn't appear to be a bug in your code, but still puzzling.

Are those last 10 records expected to be identical other than event
serial number?

> v4 Changes:
> - Added comments on intended use of wrapper functions in dm-audit.h
> - dm_audit_log_bio(): Fixed missing '=3D' as spotted by Paul
> - dm_audit_log_ti(): Handle wrong audit_type as suggested by Paul
>=20
> v3 Changes:
> - Use of two audit event types AUDIT_DM_EVENT und AUDIT_DM_CTRL
> - Additionaly use audit_log_task_info in case of AUDIT_DM_CTRL messages
> - Provide consistent fields per message type as suggested by Paul
> - Added sample events to commit message of [1/3] as suggested by Paul
> - Rebased on v5.14
>=20
> v2 Changes:
> - Fixed compile errors if CONFIG_DM_AUDIT is not set
> - Fixed formatting and typos as suggested by Casey
>=20
> Michael Wei=DF (3):
>   dm: introduce audit event module for device mapper
>   dm integrity: log audit events for dm-integrity target
>   dm crypt: log aead integrity violations to audit subsystem
>=20
>  drivers/md/Kconfig         | 10 +++++
>  drivers/md/Makefile        |  4 ++
>  drivers/md/dm-audit.c      | 84 ++++++++++++++++++++++++++++++++++++++
>  drivers/md/dm-audit.h      | 66 ++++++++++++++++++++++++++++++
>  drivers/md/dm-crypt.c      | 22 ++++++++--
>  drivers/md/dm-integrity.c  | 25 ++++++++++--
>  include/uapi/linux/audit.h |  2 +
>  7 files changed, 205 insertions(+), 8 deletions(-)
>  create mode 100644 drivers/md/dm-audit.c
>  create mode 100644 drivers/md/dm-audit.h
>=20
> --=20
> 2.20.1
>=20
> --
> Linux-audit mailing list
> Linux-audit@redhat.com
> https://listman.redhat.com/mailman/listinfo/linux-audit

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

