Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0AE33B6D2
	for <dm-devel@lists.linux.dev>; Fri,  5 Dec 2025 09:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764925989; cv=pass; b=I42/ZMwCsNf9ChVpJ9MRqikmMljkU5AjntwYJoIkvw628d7ZfiJg/iS2nyWLbtrMZXJxxIQN+0WpBr8h2RRlAJYi6XjwMMAP3a15b5rqgzhE25YNay1/ftk7DHL36U3SMHAoaycmNR2vE4fAobd8JqtvCsOKuutfD/MJ3bUl7aQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764925989; c=relaxed/simple;
	bh=ULew8p/F08fY3L8RFauOV+QPKUoh+bTWEg6sj8nOFkQ=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=Pg7a615jAuPJgQ72ELM+SkfOrzxYTGs1v17zsmZFGUoQ8Mub4UzLYZWJcsaUsQTwoVNbsZZqcljX7n7UzllYBNKQAlMZE6JLH+SDYlQjXWnzSmTWV/mDFS22hlkVBK0j3LyXqMYfNYzEMKyPi2104A85woMYxzproEQVri28ak4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=jfnphBZf; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="jfnphBZf"
ARC-Seal: i=1; a=rsa-sha256; t=1764925975; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=TR8Qvt7k/PBWZJRmZdKNsJp/2SDaYSRmXuODn29nO2UTaRKI09TbdmjiSh6Okr3h1ebwB+YJFOPSDcAJj0yqM+078gfRjNg58oONKJH1vuPbAHPPICiD5Zi9BXffcilIBYz8ZR7aSJjwDOFi7hL1ojysw7CPdtKlc2vuZPFqVA0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1764925975; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=s1oJrmXVhZ+A3EBGV2CCJMrhvFTh2aRSSmWM6tjYL8c=; 
	b=k1IULXPIiQJlU+fd+x+uPcjzUaiobSSRjxN8piQIAzQ3kX9m+MqMRvj/7VHXhTYMSRr3qvqIUMvbAsIkCveVoGJMipLiLlGtu42f/1z0IisFRbU6+BR53zoCjCZK5XVeeltJifCoZ5i0qR3jM7frC0OmjY8kQf0dFCMR/f2+vxQ=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1764925975;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=s1oJrmXVhZ+A3EBGV2CCJMrhvFTh2aRSSmWM6tjYL8c=;
	b=jfnphBZf+Nphic1fuPfkQJfm2evQtAiJFSQE19Q30CLwzYWy1LR/CzZf2f65g/jb
	zc7x20R1Ok6EAPLQrZ2EQ43rNomT2FqH+lroU3efgRBIw5+ltFrNRkBi/kic4GNnuN8
	BLYlKyeG6hIUdIxYI8KuYTghhBhqUcuGX4+uiAD0=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 17649259730321001.4593024631594; Fri, 5 Dec 2025 01:12:53 -0800 (PST)
Date: Fri, 05 Dec 2025 17:12:53 +0800
From: Li Chen <me@linux.beauty>
To: "Dongsheng Yang" <dongsheng.yang@linux.dev>
Cc: "dm-devel" <dm-devel@lists.linux.dev>,
	"linux-kernel" <linux-kernel@vger.kernel.org>,
	"Zheng Gu" <cengku@gmail.com>
Message-ID: <19aedc9220c.286fe1e31299075.4407856642004547155@linux.beauty>
In-Reply-To: <0af717b0-21c0-404d-82c1-94d9addd4ef5@linux.dev>
References: <20251202121158.111092-1-me@linux.beauty>
 <65dbab10-a48a-4cfb-8c06-15011e54b1b5@linux.dev>
 <e6170c62-22b9-4d5d-bd97-006a4cecc0b7@linux.dev> <0af717b0-21c0-404d-82c1-94d9addd4ef5@linux.dev>
Subject: Re: [PATCH 0/2] dm-pcache: fix metadata indexing and persistence
 issues
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail

Hi Dongsheng,

 ---- On Thu, 04 Dec 2025 09:38:17 +0800  Dongsheng Yang <dongsheng.yang@li=
nux.dev> wrote ---=20
 >=20
 > =E5=9C=A8 12/4/2025 7:38 AM, Dongsheng Yang =E5=86=99=E9=81=93:
 > >
 > > =E5=9C=A8 12/3/2025 1:56 PM, Dongsheng Yang =E5=86=99=E9=81=93:
 > >> Hi,
 > >>
 > >>     Thanx for your patches, there are some comments inline.
 > >>
 > >> According to these comments, I propose an update base on your patch=
=20
 > >> as [1].
 > >>
 > >> BTW, I added a test case for this problem in dtg-tests:
 > >>
 > >> https://github.com/DataTravelGuide/dtg-tests/blob/main/pcache.py.data=
/pcache_misc_tests/case21_gc_percent_persistence_after_recreate.sh=20
 > >>
 > >>
 > >> It update gc_percent online and recreate pcache device and check=20
 > >> gc_percen
 > >>
 > >>
 > >> [1]:
 > >
 > >
 > > ->info_index means next slot to write, so advancing it at init stage=
=20
 > > is correct
 >=20
 >=20
 > We need to think more thoroughly about the usage of the slot index. In=
=20
 > my original design, all slot indices represent the =E2=80=9Ccurrent slot=
=E2=80=9D. So at=20
 > initialization it is 0; if loading, we simply point it to the loaded=20
 > slot; and on write we advance afterwards. However, the problem now is=20
 > that in all write functions, they first write to the current slot, then=
=20
 > advance.
 >=20
 > Therefore I believe we should clarify that the meaning of the slot index=
=20
 > is =E2=80=9Cthe current slot,=E2=80=9D and stick to the original design.=
 We only need to=20
 > modify the write functions: first perform the advance, and then write=20
 > into the correct slot.
=20
Sounds good, thanks.

Regards,

Li=E2=80=8B

