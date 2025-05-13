Received: from gardel.0pointer.net (gardel.0pointer.net [85.214.157.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD00257AE4;
	Tue, 13 May 2025 14:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.157.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747146957; cv=none; b=Fd0WNCSETAjqei64RNtmbPhHMNjyxcrDBhetC0ZxELiq7OlvlCeN5KFWvNY/HC4qhFzNbDTrL39ppUOZu+yMdg/YZzynpsPE7N2rzzqMNlIapy/cw1BJ2aFbonDsvAtEJnIRRnT3FnAdkZO2Ji4uiTU2ExbqE5lunXM3o3zbTCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747146957; c=relaxed/simple;
	bh=cyZ1hDrKeSoTFmor0L1mvqP/AwGJviE0iaAVH2qcCFM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QnDgpGN7UyOHfDfrzJ0mzce0+bp9CTg896nP5asNSI9tLo/yNuyamIl5lMzsaVApaOc94vCmo4+qRDcEplxzyx//jBLKxEfVio7I5uKE34jpg1MKXEws5hJKO+IRbKKhLX4EL26E+NW3+XnbN00rsR8PFUjcwqGNOZZfA3R8puQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=poettering.net; spf=pass smtp.mailfrom=poettering.net; arc=none smtp.client-ip=85.214.157.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=poettering.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=poettering.net
Received: from gardel-login.0pointer.net (gardel-mail [IPv6:2a01:238:43ed:c300:10c3:bcf3:3266:da74])
	by gardel.0pointer.net (Postfix) with ESMTP id E51EFE803E2;
	Tue, 13 May 2025 16:35:51 +0200 (CEST)
Received: by gardel-login.0pointer.net (Postfix, from userid 1000)
	id 7A6F416005E; Tue, 13 May 2025 16:35:51 +0200 (CEST)
Date: Tue, 13 May 2025 16:35:51 +0200
From: Lennart Poettering <lennart@poettering.net>
To: Chengen Du <chengen.du@canonical.com>
Cc: dm-devel@lists.linux.dev, linux-lvm@lists.linux.dev,
	christophe.varoqui@opensvc.com, systemd-devel@lists.freedesktop.org
Subject: Re: [systemd-devel] [Discussion][device-mapper] Enabling Block
 Device Access Locking in systemd
Message-ID: <aCNYxyaGNBuKTqX3@gardel-login>
References: <CAPza5qfw-ExyCFnWa5JoUE7eUsk_es8yx=H0YDFcY-=J8OtHpQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPza5qfw-ExyCFnWa5JoUE7eUsk_es8yx=H0YDFcY-=J8OtHpQ@mail.gmail.com>

On Di, 13.05.25 16:08, Chengen Du (chengen.du@canonical.com) wrote:

> Hi,
>
> Apologies for including everyone in this message, but I’d like to bring
> your attention to a fix [1], which may require your input.

As mentioned in my comments there: we can certainly enable the locking
stuff again for DM block devices too, but only if DM maintainers sign
off that this is OK. Hence ping the DM people about this, otherwise we
won't move on this.

> To mitigate such issues, systemd-udevd normally acquires a LOCK_SH|LOCK_NB
> using flock on the main block device before processing.
> However, commit #e918a1b5a94f (udev: exclude device-mapper from block
> device ownership event locking) disabled this behavior for device-mapper
> devices, which appears to be the root cause of the boot hang with encrypted
> swap.

iirc dm for some reason is allergic to us taking a bsd lock, because
they don't want us to hold an fd open while the udev rules run
(because bsd locking implies holding an fd open as long as the lock is
kept).

But only the DM people can shed some light on this. if they are fine
these days if we relax this then we can certainly cover their stuff
via the locking, too.

Lennart

--
Lennart Poettering, Berlin
