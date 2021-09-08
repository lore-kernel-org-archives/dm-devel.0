Return-Path: <SRS0=4gQq=OD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F954C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 13 Sep 2021 06:40:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E390560FE6
	for <dm-devel@archiver.kernel.org>; Mon, 13 Sep 2021 06:40:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E390560FE6
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1631515233;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=bMc4dyYcdtx4n0Yp3E61/53+q/91+u8CLEjKxovDtcQ=;
	b=KPVvi3Wg0vd6DoJ/ZA6D8nzOcwsUtwcQGvRge5pz9zeF8Ds2Z4piduksYKfWsKUfXOd9jg
	NXfF8e+/ENrgq9SOXr/SKp0du6/ZwrXT0+4416R5tPoq74CpW4Pwda6awHPICiJrbht16t
	vooYi4x2Eh+BW48Oj/qmQzGZOD3FXhU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-481-u1XpEpJ1Pi6wsxK2STm0SA-1; Mon, 13 Sep 2021 02:40:31 -0400
X-MC-Unique: u1XpEpJ1Pi6wsxK2STm0SA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B3041E11;
	Mon, 13 Sep 2021 06:40:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 19BF219724;
	Mon, 13 Sep 2021 06:40:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E1ABC4EA30;
	Mon, 13 Sep 2021 06:40:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 188DGc9E015596 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 8 Sep 2021 09:16:38 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 4912B6B551; Wed,  8 Sep 2021 13:16:38 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.3.128.14])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CF74F6B550;
	Wed,  8 Sep 2021 13:16:19 +0000 (UTC)
Date: Wed, 8 Sep 2021 09:16:16 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: =?iso-8859-1?B?V2Vp3yw=?= Michael <michael.weiss@aisec.fraunhofer.de>,
	sgrubb@redhat.com
Message-ID: <20210908131616.GK490529@madcap2.tricolour.ca>
References: <20210904095934.5033-1-michael.weiss@aisec.fraunhofer.de>
	<20210908005942.GJ490529@madcap2.tricolour.ca>
	<9ca855cb19097b6fa98f2b3419864fd8ddadf065.camel@aisec.fraunhofer.de>
MIME-Version: 1.0
In-Reply-To: <9ca855cb19097b6fa98f2b3419864fd8ddadf065.camel@aisec.fraunhofer.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 13 Sep 2021 02:39:51 -0400
Cc: "paul@paul-moore.com" <paul@paul-moore.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"eparis@redhat.com" <eparis@redhat.com>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"song@kernel.org" <song@kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-audit@redhat.com" <linux-audit@redhat.com>,
	"casey@schaufler-ca.com" <casey@schaufler-ca.com>,
	"agk@redhat.com" <agk@redhat.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On 2021-09-08 08:26, Wei=DF, Michael wrote:
> On Tue, 2021-09-07 at 20:59 -0400, Richard Guy Briggs wrote:
> > On 2021-09-04 11:59, Michael Wei=DF wrote:
> > > dm integrity and also stacked dm crypt devices track integrity
> > > violations internally. Thus, integrity violations could be polled
> > > from user space, e.g., by 'integritysetup status'.
> > >=20
> > > > From an auditing perspective, we only could see that there were
> > > a number of integrity violations, but not when and where the
> > > violation exactly was taking place. The current error log to
> > > the kernel ring buffer, contains those information, time stamp and
> > > sector on device. However, for auditing the audit subsystem provides
> > > a separate logging mechanism which meets certain criteria for secure
> > > audit logging.
> > >=20
> > > With this small series we make use of the kernel audit framework
> > > and extend the dm driver to log audit events in case of such
> > > integrity violations. Further, we also log construction and
> > > destruction of the device mappings.
> > >=20
> > > We focus on dm-integrity and stacked dm-crypt devices for now.
> > > However, the helper functions to log audit messages should be
> > > applicable to dm-verity too.
> > >=20
> > > The first patch introduce generic audit wrapper functions.
> > > The second patch makes use of the audit wrapper functions in the
> > > dm-integrity.c.
> > > The third patch uses the wrapper functions in dm-crypt.c.
> > >=20
> > > The audit logs look like this if executing the following simple test:
> > >=20
> > > # dd if=3D/dev/zero of=3Dtest.img bs=3D1M count=3D1024
> > > # losetup -f test.img
> > > # integritysetup -vD format --integrity sha256 -t 32 /dev/loop0
> > > # integritysetup open -D /dev/loop0 --integrity sha256 integritytest
> > > # integritysetup status integritytest
> > > # integritysetup close integritytest
> > > # integritysetup open -D /dev/loop0 --integrity sha256 integritytest
> > > # integritysetup status integritytest
> > > # dd if=3D/dev/urandom of=3D/dev/loop0 bs=3D512 count=3D1 seek=3D1000=
00
> > > # dd if=3D/dev/mapper/integritytest of=3D/dev/null
> > >=20
> > > -------------------------
> > > audit.log from auditd
> > >=20
> > > type=3DUNKNOWN[1336] msg=3Daudit(1630425039.363:184): module=3Dintegr=
ity op=3Dctr ppid=3D3807 pid=3D3819
> > > auid=3D1000 uid=3D0 gid=3D0 euid=3D0 suid=3D0 fsuid=3D0 egid=3D0 sgid=
=3D0 fsgid=3D0 tty=3Dpts2 ses=3D3
> > > comm=3D"integritysetup" exe=3D"/sbin/integritysetup" subj=3D=3Dunconf=
ined dev=3D254:3 error_msg=3D'success'
> > > res=3D1
> > > type=3DUNKNOWN[1336] msg=3Daudit(1630425039.471:185): module=3Dintegr=
ity op=3Ddtr ppid=3D3807 pid=3D3819
> > > auid=3D1000 uid=3D0 gid=3D0 euid=3D0 suid=3D0 fsuid=3D0 egid=3D0 sgid=
=3D0 fsgid=3D0 tty=3Dpts2 ses=3D3
> > > comm=3D"integritysetup" exe=3D"/sbin/integritysetup" subj=3D=3Dunconf=
ined dev=3D254:3 error_msg=3D'success'
> > > res=3D1
> > > type=3DUNKNOWN[1336] msg=3Daudit(1630425039.611:186): module=3Dintegr=
ity op=3Dctr ppid=3D3807 pid=3D3819
> > > auid=3D1000 uid=3D0 gid=3D0 euid=3D0 suid=3D0 fsuid=3D0 egid=3D0 sgid=
=3D0 fsgid=3D0 tty=3Dpts2 ses=3D3
> > > comm=3D"integritysetup" exe=3D"/sbin/integritysetup" subj=3D=3Dunconf=
ined dev=3D254:3 error_msg=3D'success'
> > > res=3D1
> > > type=3DUNKNOWN[1336] msg=3Daudit(1630425054.475:187): module=3Dintegr=
ity op=3Ddtr ppid=3D3807 pid=3D3819
> > > auid=3D1000 uid=3D0 gid=3D0 euid=3D0 suid=3D0 fsuid=3D0 egid=3D0 sgid=
=3D0 fsgid=3D0 tty=3Dpts2 ses=3D3
> > > comm=3D"integritysetup" exe=3D"/sbin/integritysetup" subj=3D=3Dunconf=
ined dev=3D254:3 error_msg=3D'success'
> > > res=3D1
> > >=20
> > > type=3DUNKNOWN[1336] msg=3Daudit(1630425073.171:191): module=3Dintegr=
ity op=3Dctr ppid=3D3807 pid=3D3883
> > > auid=3D1000 uid=3D0 gid=3D0 euid=3D0 suid=3D0 fsuid=3D0 egid=3D0 sgid=
=3D0 fsgid=3D0 tty=3Dpts2 ses=3D3
> > > comm=3D"integritysetup" exe=3D"/sbin/integritysetup" subj=3D=3Dunconf=
ined dev=3D254:3 error_msg=3D'success'
> > > res=3D1
> > >=20
> > > type=3DUNKNOWN[1336] msg=3Daudit(1630425087.239:192): module=3Dintegr=
ity op=3Ddtr ppid=3D3807 pid=3D3902
> > > auid=3D1000 uid=3D0 gid=3D0 euid=3D0 suid=3D0 fsuid=3D0 egid=3D0 sgid=
=3D0 fsgid=3D0 tty=3Dpts2 ses=3D3
> > > comm=3D"integritysetup" exe=3D"/sbin/integritysetup" subj=3D=3Dunconf=
ined dev=3D254:3 error_msg=3D'success'
> > > res=3D1
> > >=20
> > > type=3DUNKNOWN[1336] msg=3Daudit(1630425093.755:193): module=3Dintegr=
ity op=3Dctr ppid=3D3807 pid=3D3906
> > > auid=3D1000 uid=3D0 gid=3D0 euid=3D0 suid=3D0 fsuid=3D0 egid=3D0 sgid=
=3D0 fsgid=3D0 tty=3Dpts2 ses=3D3
> > > comm=3D"integritysetup" exe=3D"/sbin/integritysetup" subj=3D=3Dunconf=
ined dev=3D254:3 error_msg=3D'success'
> > > res=3D1
> > >=20
> > > type=3DUNKNOWN[1337] msg=3Daudit(1630425112.119:194): module=3Dintegr=
ity op=3Dintegrity-checksum
> > > dev=3D254:3 sector=3D77480 res=3D0
> > > type=3DUNKNOWN[1337] msg=3Daudit(1630425112.119:195): module=3Dintegr=
ity op=3Dintegrity-checksum
> > > dev=3D254:3 sector=3D77480 res=3D0
> > > type=3DUNKNOWN[1337] msg=3Daudit(1630425112.119:196): module=3Dintegr=
ity op=3Dintegrity-checksum
> > > dev=3D254:3 sector=3D77480 res=3D0
> > > type=3DUNKNOWN[1337] msg=3Daudit(1630425112.119:197): module=3Dintegr=
ity op=3Dintegrity-checksum
> > > dev=3D254:3 sector=3D77480 res=3D0
> > > type=3DUNKNOWN[1337] msg=3Daudit(1630425112.119:198): module=3Dintegr=
ity op=3Dintegrity-checksum
> > > dev=3D254:3 sector=3D77480 res=3D0
> > > type=3DUNKNOWN[1337] msg=3Daudit(1630425112.119:199): module=3Dintegr=
ity op=3Dintegrity-checksum
> > > dev=3D254:3 sector=3D77480 res=3D0
> > > type=3DUNKNOWN[1337] msg=3Daudit(1630425112.119:200): module=3Dintegr=
ity op=3Dintegrity-checksum
> > > dev=3D254:3 sector=3D77480 res=3D0
> > > type=3DUNKNOWN[1337] msg=3Daudit(1630425112.119:201): module=3Dintegr=
ity op=3Dintegrity-checksum
> > > dev=3D254:3 sector=3D77480 res=3D0
> > > type=3DUNKNOWN[1337] msg=3Daudit(1630425112.119:202): module=3Dintegr=
ity op=3Dintegrity-checksum
> > > dev=3D254:3 sector=3D77480 res=3D0
> > > type=3DUNKNOWN[1337] msg=3Daudit(1630425112.119:203): module=3Dintegr=
ity op=3Dintegrity-checksum
> > > dev=3D254:3 sector=3D77480 res=3D0
> >=20
> > Are these isolated records, or are they accompanied by a type=3DSYSCALL
> > record in your logs?
>=20
> You are right the dm_audit_log_{ctr,dtr} functions produce type=3DAUDIT_D=
M_CTRL
> accompanied by a
> type=3DSYSCALL. This was a mistake by me. I grepped
> the audit log with 'grep -e "133[6-7]"' during my
> tests, thus I have
> missed that. I will remove the audit_log_task_info() call in the
> internal dm_audit_log_ti() function
> for type=3DAUDIT_DM_CTRL.

(To get the whole events, use "ausearch ... -m 1336,1337 ...".)

> dm_audit_log_target and dm_audit_log_bio are using type=3DAUDIT_DM_EVENT,
> These are isolated events since they are not triggert in user context.=20

Ok, so it sounds like those events *should* have task_info in their
record format since they are not accompanied by SYSCALL records that
already contain that information.  So it appears that
audit_log_task_info() should be moved from the type=3DAUDIT_DM_CTRL case
to the type=3DAUDIT_DM_EVENT case.

> > The reason I ask is that audit_log_task_info() is included in three of
> > the calling methods (dm_audit_log_{target,ctr,dtr}) which use a
> > combination of AUDIT_DM_CTRL/AUDIT_DM_EVENT type while the fourth
> > (dm_audit_log_bio) also uses one of the types above but does not includ=
e
> > audit_log_task_info().  If all these records are accompanied by SYSCALL
> > records, then the task info would be redundant (and might even conflict
> > if there's a bug).  Another minor oddity is the double "=3D" for the su=
bj
> > field, which doesn't appear to be a bug in your code, but still puzzlin=
g.
>=20
> In the test setup, I had Apparmor enabled and set as default security mod=
ule.
> This behavior occurs in any audit_log message.
> Seems that this is coming from the label handling there. Having a quick l=
ook
> at the code there is that they use '=3D' in the label to provide a root v=
iew as
> part of their policy virtualization. The corresponding commit is sitting
> there since 2017: "26b7899510ae243e392960704ebdba52d05fbb13"

Interesting...  Thanks for tracking down that cause.  I don't know how
much pain that will cause the userspace parsing tools.  I've added Steve
Grubb to the Cc: to get his input, but this should not derail this patch
set.

This has parallels to this previously reported issue with ima/integrity:
=09https://github.com/linux-audit/audit-kernel/issues/113

> > Are those last 10 records expected to be identical other than event
> > serial number?
>=20
> Yes, because the access to the corrupt sector is made 10 times.
> This reflects exactly the same behavior without the audit logging, in the=
=20
> kernel debug log.

Is there any other distinguishing information for that event other than
audit log serial number that would be useful to add?  (It doesn't sound
like it.)

> > > v4 Changes:
> > > - Added comments on intended use of wrapper functions in dm-audit.h
> > > - dm_audit_log_bio(): Fixed missing '=3D' as spotted by Paul
> > > - dm_audit_log_ti(): Handle wrong audit_type as suggested by Paul
> > >=20
> > > v3 Changes:
> > > - Use of two audit event types AUDIT_DM_EVENT und AUDIT_DM_CTRL
> > > - Additionaly use audit_log_task_info in case of AUDIT_DM_CTRL messag=
es
> > > - Provide consistent fields per message type as suggested by Paul
> > > - Added sample events to commit message of [1/3] as suggested by Paul
> > > - Rebased on v5.14
> > >=20
> > > v2 Changes:
> > > - Fixed compile errors if CONFIG_DM_AUDIT is not set
> > > - Fixed formatting and typos as suggested by Casey
> > >=20
> > > Michael Wei=DF (3):
> > >   dm: introduce audit event module for device mapper
> > >   dm integrity: log audit events for dm-integrity target
> > >   dm crypt: log aead integrity violations to audit subsystem
> > >=20
> > >  drivers/md/Kconfig         | 10 +++++
> > >  drivers/md/Makefile        |  4 ++
> > >  drivers/md/dm-audit.c      | 84 ++++++++++++++++++++++++++++++++++++=
++
> > >  drivers/md/dm-audit.h      | 66 ++++++++++++++++++++++++++++++
> > >  drivers/md/dm-crypt.c      | 22 ++++++++--
> > >  drivers/md/dm-integrity.c  | 25 ++++++++++--
> > >  include/uapi/linux/audit.h |  2 +
> > >  7 files changed, 205 insertions(+), 8 deletions(-)
> > >  create mode 100644 drivers/md/dm-audit.c
> > >  create mode 100644 drivers/md/dm-audit.h
> > >=20
> > > --=20
> > > 2.20.1
> > >=20
> > > --
> > > Linux-audit mailing list
> > > Linux-audit@redhat.com
> > > https://listman.redhat.com/mailman/listinfo/linux-audit
> >=20
> > - RGB
> >=20
> > --
> > Richard Guy Briggs <rgb@redhat.com>
> > Sr. S/W Engineer, Kernel Security, Base Operating Systems
> > Remote, Ottawa, Red Hat Canada
> > IRC: rgb, SunRaycer
> > Voice: +1.647.777.2635, Internal: (81) 32635
> >=20
>=20
> Thanks,
> Michael

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

