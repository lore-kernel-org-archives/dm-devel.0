Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937445674A
	for <dm-devel@lists.linux.dev>; Tue, 21 May 2024 23:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.205.220.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716333573; cv=none; b=ri3X6YMvlkSpIHDbvuxK9+OeXF3TrWKzvgKs/xTN+Zn5boyToNTNg1MtOKa2PVthcMd+weyCowlcA5nGGSSHVGeb7hB8UBgV9zjEvYaWje2+u3OTQ1s/pPTfMQOcPjgxHKx4b+8NJBmPm1qrMCw0OzWfhOKawgv7bDl93mxPmOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716333573; c=relaxed/simple;
	bh=uok8ci7oRP3MNHrXIWln3P2ERxY4MQe+7vIO5pahGEs=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=e7balHv8WU4gWLaboxPDlnyAaxZscbaMtwZ7oQI4om4zp1xx8IQNvCgHiUIVVASr5H9b23ghk7FltldSr5FTkX2uWNd7g66VZUbdTarsa4lVbC2tv4bYNb5Jw53GaLDvuLtYSy1IcyaDak/cE0ZIlaI4cbDACqDwzxVH8p7Qdyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lists.ewheeler.net; spf=none smtp.mailfrom=lists.ewheeler.net; arc=none smtp.client-ip=173.205.220.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lists.ewheeler.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=lists.ewheeler.net
Received: from localhost (localhost [127.0.0.1])
	by mx.ewheeler.net (Postfix) with ESMTP id 7750485;
	Tue, 21 May 2024 16:19:26 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
	by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id TDTdmSp48eMn; Tue, 21 May 2024 16:19:22 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx.ewheeler.net (Postfix) with ESMTPSA id 1862440;
	Tue, 21 May 2024 16:19:22 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 1862440
Date: Tue, 21 May 2024 16:19:22 -0700 (PDT)
From: Eric Wheeler <dm-devel@lists.ewheeler.net>
To: Hannes Reinecke <hare@suse.de>
cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org
Subject: Re: Kernel namespaces for device mapper targets and block devices?
In-Reply-To: <5fc134e0-6f9b-4f87-8dea-ba929bf1e91d@suse.de>
Message-ID: <10a92e14-70f5-e3c8-dd75-532c35d51d13@ewheeler.net>
References: <61c1fff7-b5ff-dfdd-62c1-506e055ae5e@ewheeler.net> <a3d8bab5-9293-4765-b202-d2bbecaa1f63@suse.de> <f55c2eb7-eb6d-3f95-b2c8-a28e9447e570@ewheeler.net> <5fc134e0-6f9b-4f87-8dea-ba929bf1e91d@suse.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-1834047648-1716333562=:9489"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1834047648-1716333562=:9489
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Sun, 19 May 2024, Hannes Reinecke wrote:
> On 5/18/24 00:04, Eric Wheeler wrote:
> > On Fri, 17 May 2024, Hannes Reinecke wrote:
> > 
> >> On 5/17/24 02:18, Eric Wheeler wrote:
> >>> Hello everyone,
> >>>
> >>> Is there any work being done on namespaces for device-mapper targets, or
> >>> for the block layer in general?
> >>>
> >>> For example, namespaces could make `dmsetup table` or `losetup -a` see
> >>> only devices mapped in that name space. I found this article from to 2013,
> >>> but it is quite old:
> >>>   https://lwn.net/Articles/564854/
> >>>
> >>> If you know any more recent work on the topic that I would be interested.
> >>> Thank you for help!
> >>>
> >> It is on my to-do list.
> >> We sure should work on that one.
> > 
> > How you envision hooking namespaces into the block layer?
> > 
> Overall idea is to inherit devices from the original namespace.
> - upon creation the new namespace inherits all devices from the
>   original ns.

For namespace initialization, is there way to start with an empty 
namespace (no inherit), and only add devices the namespace that you would 
like to provide to the container? For example, you might want to provide a 
logical volume to the container and then let the container users do with 
they want in terms of creating new devices from that namespace-assigned 
"root level" device.

Somehow it needs to be safe in terms of the container users changing the 
device mapper table spec of a "root level" device using `dmsetup reload 
--table`.


--
Eric Wheeler



> - new devices show up only in the current namespace and all
>   namespaces derived from it.
> - Namespace teardown should remove all devices created
>   within this namespace.
> 
> I did a patchset once, based upon suggestion from Christian Brauner.
> Let me dig it up.
> 
> Cheers,
> 
> Hannes
> -- 
> Dr. Hannes Reinecke                  Kernel Storage Architect
> hare@suse.de                                +49 911 74053 688
> SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
> HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
> 
> 
> 
--8323328-1834047648-1716333562=:9489--
