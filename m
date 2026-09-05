Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E607A35C6B3
	for <dm-devel@lists.linux.dev>; Sat,  5 Sep 2026 16:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788624817; cv=none; b=stdgKSgwzK4nDD/7pbqqSo3P0mZMSitt5COT9JVpx62ToBXJHBn0SKI8VmT+WC5MZbzH5Olezc9uiFa8PWxThVw4CvfhPRSzY8e4KGjYsSu0injJiF5UEjpm4nTTbGh7Cc3JHe4DaFvY+v3CSybXH2z8y2xR3RYfpoKj2kkwuCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788624817; c=relaxed/simple;
	bh=lGIkMP1h1/N1FkZdQJX6hLFFSVZPCllF9GmOR1J/4ks=;
	h=Date:From:To:Message-ID:Subject:MIME-Version:Content-Type; b=Z8Jbs5byZDkYZ0zEjl9/3SPrH46kD0Bc/onE+I/TS/VxQstZD8B8Mz7Vk6LzS76C4TBBTFUxB47qtP+aNvPprgFrpgxpqnEJurfikz2TQ8oMKsKmOaRtP935ykCrKyfc77T8nDOeRhs18Zn5CGmhXRYjdeWqaIKZ6UfdHeT4YKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=CeifCpDE; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="CeifCpDE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Message-ID:Subject:MIME-Version:
	Content-Type; bh=lGIkMP1h1/N1FkZdQJX6hLFFSVZPCllF9GmOR1J/4ks=;
	b=CeifCpDEKNHkCzHk01VzE5K+y5Ht7b6CPFeV6Rnm6uJD4OdGhtJ0T6/2931GWQ
	FOF6cyJNLg29T0EUT7gw0eswdklQhOpiUS5GozTJgpybS1XYAtfvjEjTqsSf3+wf
	Q8mVbDI6TBa+upH34f8wB7ha8phGrzw79ILLTn+V6TFPA=
Received: from bd0d28f35c2f (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgD3nzejP5xqCV2uQA--.60139S2;
	Sun, 06 Sep 2026 00:13:24 +0800 (CST)
Date: Sun, 6 Sep 2026 00:13:23 +0800 (CST)
From: lmyBizExplore02@163.com
To: dm-devel@lists.linux.dev
Message-ID: <376074890.281.1788624803200@bd0d28f35c2f>
Subject: Helping OpenSVC develop the multipath-tools project through
 automated outreach to users
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:PygvCgD3nzejP5xqCV2uQA--.60139S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kw17tw4ktF4rurWDtw1xGrg_yoW8Xr1kpF
	4fu34ay3yDXF1xAFWIq34xJ34I9395J39rCrn8GryrAr1UAryktFyag3yFva47uw4UKr10
	vrnIvwn8ZayUZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UI9aPUUUUU=
X-CM-SenderInfo: xop1uxh2h01zhruhiji6rwjhhfrp/xtbC8AS6R2qcP6T0QwAA3T

OpenSVC: I have been following the multipath-tools project that you are maintaining. Its design logic for managing multi-path storage is highly sophisticated, and it is indeed very useful for the operation and maintenance of Linux systems.

 We are Weifang Leimingyun Network Technology Co., Ltd. With a long history of working in the open-source field, we understand that developers typically possess strong technical skills, but they often struggle to get outstanding open-source projects in front of more potential users and increase their visibility. Our team also won the second prize in the Xingzhi Cup National Artificial Intelligence Competition in 2025, and we are currently operating an independent automated promotion system. This system can search across the entire network to identify potential users who are highly relevant to your project, and once a match is found, it will initiate automated communication efforts, helping to ensure that your project reaches the target users effectively.

 If you are interested, I can give you a 2-month system license to help find more potential users for the OpenSVC project. If the results are good, you can choose to make a purchase later on. Or if your project receives more than 200 stars on GitHub, we can also establish a long-term exchange of resources by adding one of our links in the README, so that both parties can gain more attention. Do you think this attempt is worth trying?

