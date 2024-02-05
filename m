Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9249B13664A
	for <dm-devel@lists.linux.dev>; Mon,  5 Feb 2024 20:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707165898; cv=none; b=ketf3iWhkKVOFTUh44g4QLcJ21zvfTe0moqSkz3YU80lX4XpXtk6emvwLVCU+jqIvhXMQFnVYKMbYdZUD9qGk7IsATv6sAcFyNs3kHPbSATwg9lfYBSfBjNpPeEDuiwmDPl770v1CVWBKIcGqobprVFgpr0WmAGNomUy6eWQJAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707165898; c=relaxed/simple;
	bh=DpsRFjG/5qxs4II7JFR1SDVySSbzXY4guMZPklnKRo8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=RyN1x+jcBkkQ8uG2gMUsusNK8I5ql/5GqebiWCwZdD953Zuyh2KD224EEj7L3hzcWuULy4yykkNC7A68vtE/V0kubma8WL7vb8qTbI8bFIgQ+LuYEF0vVygFFfm7IAIiDq+4vQM81AX0xFkPQuPb/qgrqcDqJOCMXFepB3950JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=avtRw9I0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="avtRw9I0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707165895;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m+Z//jw/W2CaAqree39ZtErtBXjWuv8DT9RzfVjNNgc=;
	b=avtRw9I0SBZSFG5RdrUOTml1gY94xS1YmX7sc5Cax/2xbPy8VucezAtxoRUpC4GTWh7FV5
	jNlsKD3dLMvoZmkjPwhZQZLmnu+0VNww1ZJaaCXcAdzac54uhDwu5m2sW5FKqZG9x4EPhP
	X1afNWgcHdTt0eX1Fx0xv/JLiG2RuF0=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-441-sTzZHA_EME6cpzbVRb-7wg-1; Mon,
 05 Feb 2024 15:44:52 -0500
X-MC-Unique: sTzZHA_EME6cpzbVRb-7wg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C0D8E1C05AD2;
	Mon,  5 Feb 2024 20:44:50 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A54E22028CD2;
	Mon,  5 Feb 2024 20:44:50 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 415KiogA139428
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 5 Feb 2024 15:44:50 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 415Kiobe139427;
	Mon, 5 Feb 2024 15:44:50 -0500
Date: Mon, 5 Feb 2024 15:44:50 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, linux-lvm@lists.linux.dev,
        Zdenek Kabelac <zkabelac@redhat.com>,
        Peter Rajnoha <prajnoha@redhat.com>
Subject: Re: [PATCH 1/6] 11-dm-mpath.rules: don't import properties that are
 already set
Message-ID: <ZcFIwjEhKAVijIQb@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240205124638.17877-1-mwilck@suse.com>
 <20240205124638.17877-2-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240205124638.17877-2-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 05, 2024 at 01:46:33PM +0100, Martin Wilck wrote:
> DM_UDEV_DISABLE_OTHER_RULES_FLAG and DM_NOSCAN may be already set
> from previous rules, e.g. if the device is suspended. Make sure
> we don't overwrite them.
> 
> DM_DISABLE_OTHER_RULES_FLAG_OLD and MPATH_DEVICE_READY are only
> used in this file, and not used in the scan_import code path.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipath/11-dm-mpath.rules | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/multipath/11-dm-mpath.rules b/multipath/11-dm-mpath.rules
> index c339f52..2c4d006 100644
> --- a/multipath/11-dm-mpath.rules
> +++ b/multipath/11-dm-mpath.rules
> @@ -2,12 +2,19 @@ ACTION!="add|change", GOTO="mpath_end"
>  ENV{DM_UDEV_RULES_VSN}!="?*", GOTO="mpath_end"
>  ENV{DM_UUID}!="mpath-?*", GOTO="mpath_end"
>  
> -IMPORT{db}="DM_DISABLE_OTHER_RULES_FLAG_OLD"
> -IMPORT{db}="MPATH_DEVICE_READY"
> -
>  # If this uevent didn't come from dm, don't try to update the
>  # device state
> -ENV{DM_COOKIE}!="?*", ENV{DM_ACTION}!="PATH_*", IMPORT{db}="DM_UDEV_DISABLE_OTHER_RULES_FLAG", IMPORT{db}="DM_NOSCAN", GOTO="scan_import"
> +ENV{DM_COOKIE}=="?*", GOTO="check_ready"
> +ENV{DM_ACTION}=="PATH_*", GOTO="check_ready"
> +
> +ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}!="?*", IMPORT{db}="DM_UDEV_DISABLE_OTHER_RULES_FLAG"
> +ENV{DM_NOSCAN}!="?*", IMPORT{db}="DM_NOSCAN"
> +GOTO="scan_import"
> +

If we do this, don't we forget the values for
DM_DISABLE_OTHER_RULES_FLAG_OLD and MPATH_DEVICE_READY whenever we get a
non-dm uevent? If we skip importing them for a uevent, they're dropped
from the database, which means that on the next dm-originated uevent we
won't be able to get the old values. right?

-Ben

> +LABEL="check_ready"
> +
> +IMPORT{db}="DM_DISABLE_OTHER_RULES_FLAG_OLD"
> +IMPORT{db}="MPATH_DEVICE_READY"
>  
>  ENV{.MPATH_DEVICE_READY_OLD}="$env{MPATH_DEVICE_READY}"
>  
> -- 
> 2.43.0

