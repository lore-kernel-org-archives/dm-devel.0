Received: from mail.stoffel.org (mail.stoffel.org [172.104.24.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3958D539A
	for <dm-devel@lists.linux.dev>; Tue, 27 Aug 2024 01:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=172.104.24.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724722045; cv=none; b=IE1ORXgBnO6awez4IR3VMUSHA4ydsGvZAMr67U0Jkj/dWHJQmJUbVnnNcULwSGR1x8t2J1HoqPXylxB6faQKb0+gHAWvdH2ZFUPVrn5zSrP8jKbb95iD+iP5l3KLHGDi9/N5oMwwulpoHFWEIS/Xvo1zcJ2XVKNqmxesfyjlvsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724722045; c=relaxed/simple;
	bh=O2RlU06cOLyb+9IsG+Adt8nyKtdeSVbHY4G+CSIeAo0=;
	h=MIME-Version:Content-Type:Message-ID:Date:From:To:Cc:Subject:
	 In-Reply-To:References; b=F/7sdg9MljpYXEz4KOa7vGuJrYQ/INjy3W0+BU9UKCz57hCIgZEDiK3wMp0PhpDAF6t1zJm5shjfYUIfdmnLOoGFfwJYLccHUqU531KjSgs53bKrBXnQXjajosUNcIDwuVAYEE/TXiecWHa3IUrjmv9lBL/gX5wo6P/m68nZvtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org; spf=pass smtp.mailfrom=stoffel.org; arc=none smtp.client-ip=172.104.24.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stoffel.org
Received: from quad.stoffel.org (syn-097-095-183-072.res.spectrum.com [97.95.183.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.stoffel.org (Postfix) with ESMTPSA id 6E06B1E121;
	Mon, 26 Aug 2024 21:27:17 -0400 (EDT)
Received: by quad.stoffel.org (Postfix, from userid 1000)
	id 28913A0924; Mon, 26 Aug 2024 21:27:16 -0400 (EDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: quoted-printable
Message-ID: <26317.11124.118838.555832@quad.stoffel.home>
Date: Mon, 26 Aug 2024 21:27:16 -0400
From: "John Stoffel" <john@stoffel.org>
To: Dragan =?iso-8859-2?Q?Milivojevi=E6?= <galileo@pkm-inc.com>
Cc: John Stoffel <john@stoffel.org>,
    tihmstar <tihmstar@gmail.com>,
    Christian Theune <ct@flyingcircus.io>,
    Yu Kuai <yukuai1@huaweicloud.com>,
    "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
    dm-devel@lists.linux.dev,
    "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
In-Reply-To: <CALtW_agdJ9RLEit8=3MrOK2R=kT69wQj0oD1O5nEmeEh_WyBHw@mail.gmail.com>
References: <ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io>
	<316050c6-fac2-b022-6350-eaedcc7d953a@huaweicloud.com>
	<58450ED6-EBC3-4770-9C5C-01ABB29468D6@flyingcircus.io>
	<EACD5B78-93F6-443C-BB5A-19C9174A1C5C@flyingcircus.io>
	<22C5E55F-9C50-4DB7-B656-08BEC238C8A7@flyingcircus.io>
	<26291.57727.410499.243125@quad.stoffel.home>
	<2EE0A3CE-CFF2-460C-97CD-262D686BFA8C@flyingcircus.io>
	<26292.54499.173087.840312@quad.stoffel.home>
	<595DE483-7F2D-4B27-9645-AC51E8B90D0C@gmail.com>
	<26307.45971.357185.491868@quad.stoffel.home>
	<CALtW_agdJ9RLEit8=3MrOK2R=kT69wQj0oD1O5nEmeEh_WyBHw@mail.gmail.com>
X-Mailer: VM 8.3.x under 28.2 (x86_64-pc-linux-gnu)

>>>>> "Dragan" =3D=3D Dragan Milivojevi=E6 <galileo@pkm-inc.com> writes=
:

>> Interesting.  Why this way?  It would seem you now have to enter N
>> passwords on bootup, instead of just one.

> On RedHat based distributions, by default, a single entry will
> unlock multiple devices.

Something new to learn!  Thanks,
