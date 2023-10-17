Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31DA81A584
	for <dm-devel@lists.linux.dev>; Tue, 17 Oct 2023 10:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=ucw.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HvK8M5ll";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=ucw.cz header.i=@ucw.cz header.b="r0HGqmvv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1697539931;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=m671g35jVHurr8wOcj+WlvlYKhYnYhlvUxsN6VNvRGY=;
	b=HvK8M5llBRWz0BVgOF57JunT+Qa77ir4evKj16kNTJFNkp7QMRmh7jL98KMySbdXQGkaoX
	qED08FYWwVtjcMW5RiL8v+QJPFTjfF1yB3DU4ivN/OUmBoLG5RGeoFc3i9JcnI9PI6qdAR
	usm9dY+E++Pqj1PFhIrfMjMuNMJIjcQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-1-1Has4EQMNI2GJzoyQGx1YQ-1; Tue, 17 Oct 2023 06:51:55 -0400
X-MC-Unique: 1Has4EQMNI2GJzoyQGx1YQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7319F8F15C8
	for <dm-devel@lists.linux.dev>; Tue, 17 Oct 2023 10:51:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6B4A81121314
	for <dm-devel@lists.linux.dev>; Tue, 17 Oct 2023 10:51:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 231EC19466ED
	for <dm-devel@lists.linux.dev>; Tue, 17 Oct 2023 10:51:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6D18019465B8
 for <dm-devel@listman.corp.redhat.com>; Tue, 17 Oct 2023 10:51:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5040E2166B27; Tue, 17 Oct 2023 10:51:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 48BEF2166B26
 for <dm-devel@redhat.com>; Tue, 17 Oct 2023 10:51:54 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 28F6681DA9A
 for <dm-devel@redhat.com>; Tue, 17 Oct 2023 10:51:54 +0000 (UTC)
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-461-5WH96vE5M2S_UNru7QNTtA-1; Tue,
 17 Oct 2023 06:51:50 -0400
X-MC-Unique: 5WH96vE5M2S_UNru7QNTtA-1
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
 id 59C431C006A; Tue, 17 Oct 2023 12:46:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ucw.cz; s=gen1;
 t=1697539597;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=m671g35jVHurr8wOcj+WlvlYKhYnYhlvUxsN6VNvRGY=;
 b=r0HGqmvvNd5g7CMrbD4jPXD4pgEr6r1Gm6it6Yn8e+jW1rZb4R31EB/0rxa/Ub2tjKQADj
 GRrPxQw0JGiR3agauWaIPg7A95d06Vso54rp2fJU8pY/eMGv2az94kcMMbS3XZrbhFkUm0
 Vw2I4WKWfM46jsXvzxoxKX1AHMG8KR0=
Date: Tue, 17 Oct 2023 12:46:36 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 00/10] Fix confusion around MAX_ORDER
Message-ID: <ZS5mDNCRkp/RGm45@duo.ucw.cz>
References: <20230315113133.11326-1-kirill.shutemov@linux.intel.com>
 <3c25ec6f-cd33-9445-a76f-6ec2c30755f5@redhat.com>
 <86e7f97a-ac6b-873d-93b2-1121a464989a@redhat.com>
 <b3ed3da7-ffa3-0d35-34c1-27b159af43bb@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="U9ipWO248TbRr+D3"
Content-Disposition: inline
In-Reply-To: <b3ed3da7-ffa3-0d35-34c1-27b159af43bb@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
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
Cc: linux-arch@vger.kernel.org, quic_jhugo@quicinc.com,
 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, dm <dm-devel@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>, Mel Gorman <mgorman@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3


--U9ipWO248TbRr+D3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2023-09-28 18:57:18, Paolo Bonzini wrote:
> On 9/28/23 09:50, Mikulas Patocka wrote:
> > > > Fix the bugs and then change the definition of MAX_ORDER to be
> > > > inclusive: the range of orders user can ask from buddy allocator is
> > > > 0..MAX_ORDER now.
> > I think that exclusive MAX_ORDER is more intuitive in the C language -
> > i.e. if you write "for (i =3D 0; i < MAX_ORDER; i++)", you are supposed=
 to
> > loop over all allowed values. If you declare an array "void
> > *array[MAX_ORDER];" you are supposed to hold a value for each allowed
> > order.
> >=20
> > Pascal has for loops and array dimensions with inclusive ranges - and it
> > is more prone to off-by-one errors.
>=20
> I agree it's somewhat confusing either way but the ship has sailed, the
> patch has been included in Linux for several months.

Just make sure people don't backport it to stable. Fixes: (the commit
that causes the semantic change) should do the trick.

BR,
								Pavel
--=20
People of Russia, stop Putin before his war on Ukraine escalates.

--U9ipWO248TbRr+D3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZS5mDAAKCRAw5/Bqldv6
8tIGAJsFJix/mB5VZ3yp+Ypy6TLK4hgW0QCfcfJ3sDGET1Vosz3XWgzgTqljj6A=
=mKaU
-----END PGP SIGNATURE-----

--U9ipWO248TbRr+D3--

