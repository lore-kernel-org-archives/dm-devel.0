Return-Path: <SRS0=YUkt=HE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 247DAC433E6
	for <dm-devel@archiver.kernel.org>; Tue,  2 Feb 2021 18:00:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7F6EE64F7B
	for <dm-devel@archiver.kernel.org>; Tue,  2 Feb 2021 18:00:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7F6EE64F7B
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-XLFnTOoPNtqi_soc81SfYQ-1; Tue, 02 Feb 2021 13:00:46 -0500
X-MC-Unique: XLFnTOoPNtqi_soc81SfYQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 83FCA107ACE3;
	Tue,  2 Feb 2021 18:00:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C48E5C22B;
	Tue,  2 Feb 2021 18:00:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DD77150038;
	Tue,  2 Feb 2021 18:00:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 112I0XiO022611 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 2 Feb 2021 13:00:33 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 551EF2026D5D; Tue,  2 Feb 2021 18:00:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 506082026D47
	for <dm-devel@redhat.com>; Tue,  2 Feb 2021 18:00:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E83AB811760
	for <dm-devel@redhat.com>; Tue,  2 Feb 2021 18:00:30 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-551-kh_zr4qmPQW7LFoWKghpiA-1;
	Tue, 02 Feb 2021 13:00:28 -0500
X-MC-Unique: kh_zr4qmPQW7LFoWKghpiA-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id D272FAD2B;
	Tue,  2 Feb 2021 18:00:26 +0000 (UTC)
Message-ID: <aeb0260cebd075ff3e6e375969f6a5a039f07838.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, lixiaokeng
	<lixiaokeng@huawei.com>
Date: Tue, 02 Feb 2021 19:00:25 +0100
In-Reply-To: <20210202071859.GQ15006@octiron.msp.redhat.com>
References: <d6652b08-2d6c-ac46-9d73-b252bc26f41a@huawei.com>
	<3992c887b6b9a00c4faad17c1d381d2afb4a2e86.camel@suse.com>
	<b9824ac2-7c64-95e0-d352-1aed99eacb12@huawei.com>
	<035279e085cb7e4f53b00755f491103b9c92ba67.camel@suse.com>
	<b7c44c2a-d401-36de-0384-52bd11e812f8@huawei.com>
	<299a237e5fd558b6f54a1934f4c8aed8aaf24f24.camel@suse.com>
	<20210202052636.GP15006@octiron.msp.redhat.com>
	<20210202071859.GQ15006@octiron.msp.redhat.com>
User-Agent: Evolution 3.38.2
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 112I0XiO022611
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	dm-devel mailing list <dm-devel@redhat.com>
Subject: Re: [dm-devel] libmultipath: fix NULL dereference in get_be64
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2021-02-02 at 01:18 -0600, Benjamin Marzinski wrote:
> On Mon, Feb 01, 2021 at 11:26:36PM -0600, Benjamin Marzinski wrote:
> > On Mon, Feb 01, 2021 at 04:12:34PM +0100, Martin Wilck wrote:
> > >=20
> > > The same argument I made above still holds. "pp" wouldn't have
> > > been
> > > added to mpp, and add_map_with_path() would fail and return NULL.
> > > Also, if pathinfo() returns PATHINFO_SKIPPED for this device,
> > > how comes that cli_add_path() called ev_add_path() for it? It
> > > should
> > > have returned "blacklisted" instead.
> >=20
> > So, I think the main issue here is that filter_property appears to
> > be
> > broken.=A0 It only filters if uid_attribute is set, but that will
> > never be
> > set the first time it's called in pathinfo.=A0 This means that it
> > will
> > pass in the pathinfo call in cli_add_path, and the path will get
> > stored
> > in the pathvec.
>=20
> Just to be a little more clear here, filter_property() will only
> return
> MATCH_PROPERTY_BLIST_MISSING for missing udev properties, if the
> uid_attribute is set and seen. We should probably make sure to set
> uid_attribute before calling it.

I've just spent a few hours trying to figure this out. Unfortunately,
it isn't easy. pp->uid_attribute may be set from the hwtable, which
means that vendor/product must be known, which in turn means that
uid_attribute can't be set correctly before sysfs_pathinfo() is run.

Thus, in order to be consistent, we need to move the filter_property()
quite a bit further down in pathinfo(), after the call to
sysfs_pathinfo(). That can be done, I already have a (basically)
working code here (most of the work was fixing the unit tests).

*However*, that has a side effect. As you said correctly above,=A0
pp->uid_attribute currently is *never* set the first time the call
chain=A0pathinfo()->filter_property() is run. After the proposed change,
it would=A0*always* be set in this call chain, possibly leading to more
cases where pathinfo returns PATHINFO_SKIPPED.

AFAICS this would matter e.g. for "multipath -w". When we remove a
WWID, we must be sure get_refwwid() fills in the wwid, which won't
happen if PATHINFO_SKIPPED is returned. (This would only affect paths
that filter_property() would skip, so it's just a corner case, yet it
might confuse people in certain situations).

In order not to break such use cases, we need to make the
filter_property() test in pathinfo() dependent on DI_BLACKLIST. That
would make a lot of sense, but it'd cause another semantic change.
d51da42 ("libmultipath: move filter_property|devnode() from
path_discover() into pathinfo()") had deliberately not made this
change.

Well, I'll submit a patch set, in order to make you see how this would
end up looking. But I wouldn't propose to queue that up for mainline
just yet. I strongly hope that the fix for add_map_with_path() alone
will fix lixiaokeng's issue.

Cheers,
Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

