Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25E34EB64D9
	for <dm-devel@archiver.kernel.org>; Thu, 15 Jun 2023 17:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686849108;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=2uToZsmhI6tcpFQCjw2kN2hTV/EvwpS75og1JpPsD04=;
	b=Q6cF6Tj/ftVjbvdL0EXLI2ID0DOap0zGUen9AVj3zvRAwgVYwTOJv8X9TbNqI8JQFyptfh
	Oc0sOhIO5kS14mE0qShTVfooUdLhMoYQFATa7LR8JSqkpadWwqsXRbxHSS3Ru9M1SvUdgP
	ayZSWlqv8oZgC5SMgWei59K4jwL5sAc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-287-NricuvApPEi_W2R27C6FrQ-1; Thu, 15 Jun 2023 13:11:44 -0400
X-MC-Unique: NricuvApPEi_W2R27C6FrQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF3698030AE;
	Thu, 15 Jun 2023 17:11:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2FBDF1121314;
	Thu, 15 Jun 2023 17:11:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EC47C1946594;
	Thu, 15 Jun 2023 17:11:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D517B1946589
 for <dm-devel@listman.corp.redhat.com>; Thu, 15 Jun 2023 17:11:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BF83C1121318; Thu, 15 Jun 2023 17:11:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B7F7C1121314
 for <dm-devel@redhat.com>; Thu, 15 Jun 2023 17:11:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9570D3C0D84B
 for <dm-devel@redhat.com>; Thu, 15 Jun 2023 17:11:39 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-499-dzJvd0UYPRSf3V5NG5lQSQ-1; Thu,
 15 Jun 2023 13:11:37 -0400
X-MC-Unique: dzJvd0UYPRSf3V5NG5lQSQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id C93431FE58;
 Thu, 15 Jun 2023 17:11:35 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9035A13A32;
 Thu, 15 Jun 2023 17:11:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id IM6iIUdGi2QlRwAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 15 Jun 2023 17:11:35 +0000
Message-ID: <abef20de512fe9a76faf2795ea2b6097b3550936.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Chris Hofstaedtler <zeha@debian.org>
Date: Thu, 15 Jun 2023 19:11:34 +0200
In-Reply-To: <zy7caef43nvpfetodg6sc7bhp5aj3scvkcg2p5jabnzhtetkq3@4aco3dd4kwrh>
References: <a674434b-d365-1f07-2c6f-6a4ffa07578f@gmail.com>
 <946fc11571491dd39971288b48095b6480f7914f.camel@suse.com>
 <bjgxqic4umo4rk2srj4mqdgvvxntosb2xxo63fmymirulir7st@jduzswoyhupe>
 <1f452452d8f0952d3fa704f6ad9861392c5b45f7.camel@suse.com>
 <zy7caef43nvpfetodg6sc7bhp5aj3scvkcg2p5jabnzhtetkq3@4aco3dd4kwrh>
User-Agent: Evolution 3.48.1
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] multipath-tools: Debian patches
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
 dm-devel mailing list <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2023-06-07 at 17:12 +0200, Chris Hofstaedtler wrote:
>=20
> > On rpm-based distributions,package management will be able to
> > figure
> > out this kind of (in)compatibility, albeit in a more coarse-grained
> > way
> > (e.g. the multipathd package requires
> > libmpathpersist.so.0(LIBMPATHPERSIST_2.1.0)(64bit), which must
> > match
> > the provided features of the library package). I suppose something
> > similar exists in the Debian realm, too.
>=20
> Do you also rename the package that ships libpathmpersist.so.0 in
> this case?

No, we don't. The ABI change is solely reflected in the library
package's symbol versions and abstract provides like the one I showed
above. The SONAME remains formally remains "libmpathpersist.so.0".

readelf -W -V -a reports:

Dynamic section at offset 0x8b78 contains 34 entries:
  Tag        Type                         Name/Value
0x000000000000000e (SONAME)             Library soname: [libmpathpersist.so=
.0]
...
Relocation section '.rela.plt' at offset 0x15e0 contains 60 entries:
    Offset             Info             Type               Symbol's Value  =
Symbol's Name + Addend
0000000000009df0  0000004600000007 R_X86_64_JUMP_SLOT     0000000000003600 =
prout_do_scsi_ioctl@@__LIBMPATHPERSIST_INT_1.0.0 + 0
0000000000009df8  0000000100000007 R_X86_64_JUMP_SLOT     0000000000000000 =
__snprintf_chk@GLIBC_2.3.4 + 0
0000000000009e00  0000000200000007 R_X86_64_JUMP_SLOT     0000000000000000 =
free@GLIBC_2.2.5 + 0
0000000000009e08  0000000300000007 R_X86_64_JUMP_SLOT     0000000000000000 =
__errno_location@GLIBC_2.2.5 + 0
0000000000009e10  0000000400000007 R_X86_64_JUMP_SLOT     0000000000000000 =
strncmp@GLIBC_2.2.5 + 0
0000000000009e18  0000000600000007 R_X86_64_JUMP_SLOT     0000000000000000 =
libmp_put_multipath_config@LIBMULTIPATH_18.0.0 + 0
0000000000009e20  0000000700000007 R_X86_64_JUMP_SLOT     0000000000000000 =
puts@GLIBC_2.2.5 + 0
0000000000009e28  0000000800000007 R_X86_64_JUMP_SLOT     0000000000000000 =
select_reservation_key@LIBMULTIPATH_18.0.0 + 0
0000000000009e30  0000000900000007 R_X86_64_JUMP_SLOT     0000000000000000 =
dm_map_present@LIBMULTIPATH_18.0.0 + 0
0000000000009e38  0000000a00000007 R_X86_64_JUMP_SLOT     0000000000000000 =
put_multipath_config@LIBMPATHCOMMON_1.0.0 + 0
0000000000009e40  0000000b00000007 R_X86_64_JUMP_SLOT     0000000000000000 =
free_multipathvec@LIBMULTIPATH_18.0.0 + 0
0000000000009e48  0000000c00000007 R_X86_64_JUMP_SLOT     0000000000000000 =
strlcpy@LIBMULTIPATH_16.0.0 + 0
...


> I.e. how do you make this example work:
>=20
> old libmpathpersist.so.0 provides ABI 1
> new libmpathpersist.so.0(?) provides ABI 2
>=20
> multipathd was linked against the new libmpathpersist.so.0 (ABI 2)
> qemu was linked against the old libmpathpersist.so.0 (ABI 1)
>=20
> I don't see how these can be co-installable if libmpathpersist.so.0
> is never renamed?

They aren't co-installable. But the dependencies make sure that
qemu, multipathd, and possibly other consumers will use the ABI version
that libmpathpersist actually exports. On openSUSE Tumbleweed, our
rebuild policy will ensure this. On the more long-lived products, we
usually can't update the ABI in a backward-incompatible way; our QA
tools would notice if we mistakenly tried. Severe security issues might
justify an exception, in which case we'd provide patches to update the
depending packages in a batch.

> Maybe other distributions do not need coinstallability, but Debian
> needs this, because a) on actual installs we support partial
> upgrades,

openSUSE supports that, too. In the case at hand, you would need to
update the "libmpath0", "multipath-tools", and "qemu-tools" packages
simultaneously.=A0(If you'd try to update just one, the resolver would
tell you that the other two need to be updated as well).

> and b) we do not rebuild all reverse-dependencies of a library the
> moment a new version of that lib is uploaded.

Well, in this case the set of reverse-dependencies is rather small.

> I also wonder you get from symbol versioning if the old symbols just
> disappear. ISTM you could get the same effect - cannot by accident
> load the wrong library version - just by bumping the soname, and
> ignoring manual symbol versioning?

In theory, we could. I guess we could also use some heuristics to
transform the LIBMPATHPERSIST... string to a SONAME, making the
libraries co-installable. But so far we didn't need to, and tbh,
given the small number of users of our library, it doesn't seem to make
much sense. Feel free to send patches if you want.

One reason for the symbol versioning rather than SONAME is that it
makes the ABI changes more transparent to ourselves. Using abigail
to compare the latest code against the ABI of the stable version,=20
we can figure out which parts of the ABI actually changed, and reflect
this in our libmpathpersist.version file.

Thus even if we were to support SONAME, I believe we'd continue using
the symbol versioning.

> I asked around a bit and got "this seems very unusual" as feedback.

I'm sorry to hear that. But I see nothing in the docs that mandates
either providing multiple ABI versions, or modifying the SONAME just
because symbol versions are being used.

Regards,
Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

