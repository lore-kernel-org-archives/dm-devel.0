Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 478DE17D3
	for <dm-devel@lists.linux.dev>; Thu, 18 Jan 2024 01:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705540393; cv=none; b=TkZsjAfrCU+rv6LjLKN2yhe12900MsyJIOpV9NvR+YwF6OfQR+oywqX8m3tLgHaYhOHWazeoGLHdvK5tpXnnAa7lCBeKtXBjEVcxZ+Z5JykiZGe1ZkyLvfEgV5OxrY+snq8gCKHjgcmzxutnZWlqNN+DR7SPzz6uOMvkeUL7csk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705540393; c=relaxed/simple;
	bh=U1Z5i/krwXMsD1z2hq6zUHl9/zMQNP9/EtuaV8RY75M=;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:
	 X-Google-Smtp-Source:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gmail-Original-Message-ID:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding; b=hgZkPYWXaWAtTZ2gRwVGVRT+4ThwtAQy5cMszygoJqC0rSztfO7VEuOhdNvzpC2nQM/y3Wyt45zjmOaUTWs/Tmn0tJ5iR5v++XE/0v2CyA/ESFkGsHDhhRQvnEA54v8BWR+YEi1IudcO+nLuitcnS9Y6ye226V5cAxHLXMjE8Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eK4TAHzZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eK4TAHzZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A9AC433C7
	for <dm-devel@lists.linux.dev>; Thu, 18 Jan 2024 01:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705540392;
	bh=U1Z5i/krwXMsD1z2hq6zUHl9/zMQNP9/EtuaV8RY75M=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=eK4TAHzZjtjmA8dzrJUtiscfpjzW3nCaaAYHG0jWnza/ceyoYZXlTpfi6qgVuzG4B
	 wYlctnAIbsh2ezbbvor0z1/nDxnwKrGjYIVyLoE0Zh4tcgLBwJKF754xXRTZ5+WfC4
	 1H1poerwBIyo4lXAHo7XSFT+Zn3lWgo6R+uBwBGVL+IaKOTkm/sYrzhHPYH/1TNlXQ
	 iulRL1GrxnJhr3gkHO2CslhxHKyYUTLdw/pJXAJWuL27BuD4ypcs6+QBVoeaMce1M5
	 lN+rHcFUSe91vG3FBJ42mRdYBi3lSe3UsecmC5+8xDMS6i29oJIR+lW5JAk9AjLRJU
	 c5VDP33Q70rAg==
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-50eaabc36bcso14648731e87.2
        for <dm-devel@lists.linux.dev>; Wed, 17 Jan 2024 17:13:12 -0800 (PST)
X-Gm-Message-State: AOJu0YzV7HKKzRDxLLrbgtPqRKfO0/NlnSk/dX4K5BS/X13Hezh0/p7F
	x3dKubLEcYxyQc1Z9NXmu6Jt61oq1kfybVIK6vz+qi1coOBdfjnN4sJic9mFB81mYrzh51qTQ6B
	/Rqhm2zSi/0oWdsZK+QDO5xNnwv4=
X-Google-Smtp-Source: AGHT+IHXfGnnQ4BHNPYNwWzfe1cjtRbnf/JF2/OCld0syQO6pN2U6IP9uHROl3emTxuD2adk8RH2ZvFWLaf75ZYweI0=
X-Received: by 2002:a05:6512:3e1e:b0:50e:db50:3b84 with SMTP id
 i30-20020a0565123e1e00b0050edb503b84mr38321lfv.100.1705540390985; Wed, 17 Jan
 2024 17:13:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <e5e8afe2-e9a8-49a2-5ab0-958d4065c55e@redhat.com> <ece2b06f-d647-6613-a534-ff4c9bec1142@redhat.com>
In-Reply-To: <ece2b06f-d647-6613-a534-ff4c9bec1142@redhat.com>
From: Song Liu <song@kernel.org>
Date: Wed, 17 Jan 2024 17:12:59 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6TtWVKggBSa5vhuve69cjMRzUFPWcLQ7VH39mpp9gpqQ@mail.gmail.com>
Message-ID: <CAPhsuW6TtWVKggBSa5vhuve69cjMRzUFPWcLQ7VH39mpp9gpqQ@mail.gmail.com>
Subject: Re: [PATCH 5/7] md: fix deadlock in shell/lvconvert-raid-reshape-linear_to_raid6-single-type.sh
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Yu Kuai <yukuai3@huawei.com>, David Jeffery <djeffery@redhat.com>, 
	Li Nan <linan122@huawei.com>, dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, 
	Mike Snitzer <msnitzer@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>, 
	Benjamin Marzinski <bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 17, 2024 at 10:21=E2=80=AFAM Mikulas Patocka <mpatocka@redhat.c=
om> wrote:
>
> This commit fixes a deadlock in the LVM2 test
> shell/lvconvert-raid-reshape-linear_to_raid6-single-type.sh

I can reproduce this issue on the 6.7 kernel. However, 4/7 and 5/7
(without 1/7-3/7)
cannot fix it. I will run more tests.

Thanks,
Song
