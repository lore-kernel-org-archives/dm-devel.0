Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E362716D4FC
	for <dm-devel@lists.linux.dev>; Thu, 11 Jul 2024 17:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720717269; cv=none; b=o+cYEAJd9o4WGZeU6/suakxiMyGmHaqwRbMKVlyU9QEqzzvmxvyZB5yC7TtuWeUKYlyoJgM2Z3PgIY+bPpp4FJw1gD49scUFrxGSsyTCRX8xvqYS0YXvPG2/CWSWX3O0+bbjyQCBOgEo8+9GWAtZf50CvxetL1bJYccWXD065W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720717269; c=relaxed/simple;
	bh=MMLnTbU8IaeDr9bFROaW+JyRvv3bo4Yptnu4pQxgST0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=N5kKDnVSi+3IQlBmmzrlJGwy/ue7gmq+gWKiFdJgygAcLt5hScLNVSEP2jnKFeR0XTLa77v0x51N1eYE2gatRZ0Emz/MdBAtw8QrpdF0t6Ou+NoPIGfPbqBGmkgBEnmir8a7bQ5pMxyiWsFo98o2Nf4hELV50PUhUs+nsLP/dX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i02AozaE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i02AozaE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720717266;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tGlFdK85ybezNg41nQLGgZs5FfmPe+vpDE7Q8ibSXl8=;
	b=i02AozaEbtjKWB05pIHtZKrGaj8kTy5P+9DQ5zNgnuX4Bb4QlNk2cgRcR6wHXD9Ucu8Ubr
	9Bbyy2BeDrTisIu4ZYIRu20LWQFyTa0sFir5x8qj/ggfOiNVreNmLP16VmCDAFi9ISSK5l
	mbEs6jRxr082K5s5a5B6UMXhtoUUPB8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-402-3YnVxic_MTipZaHuHPkoRw-1; Thu,
 11 Jul 2024 13:01:05 -0400
X-MC-Unique: 3YnVxic_MTipZaHuHPkoRw-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2245519560B4;
	Thu, 11 Jul 2024 17:01:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 93B543000181;
	Thu, 11 Jul 2024 17:01:03 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46BH12Fe1948250
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 11 Jul 2024 13:01:02 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46BH12b21948249;
	Thu, 11 Jul 2024 13:01:02 -0400
Date: Thu, 11 Jul 2024 13:01:02 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH 21/44] libmultipath: is_mpath_part(): improve parsing
Message-ID: <ZpAPzqxbXm6dkTyU@redhat.com>
References: <20240709213935.177028-1-mwilck@suse.com>
 <20240709213935.177028-22-mwilck@suse.com>
 <Zo8RMOqoXP-b3dWz@redhat.com>
 <8348b96fc7ae7ddce4886efebcecbd7416a40d98.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <8348b96fc7ae7ddce4886efebcecbd7416a40d98.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Jul 11, 2024 at 01:08:39PM +0200, Martin Wilck wrote:
> On Wed, 2024-07-10 at 18:54 -0400, Benjamin Marzinski wrote:
> > On Tue, Jul 09, 2024 at 11:39:12PM +0200, Martin Wilck wrote:
> > > Use sscanf to make the parsing of the UUID more robust.
> > > 
> > > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > > ---
> > >  libmultipath/devmapper.c | 17 +++++++----------
> > >  1 file changed, 7 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> > > index 56157af..d62a7dd 100644
> > > --- a/libmultipath/devmapper.c
> > > +++ b/libmultipath/devmapper.c
> > > @@ -846,23 +846,20 @@ int dm_get_uuid(const char *name, char *uuid,
> > > int uuid_len)
> > >  
> > >  static int is_mpath_part(const char *part_name, const char
> > > *map_name)
> > >  {
> > > -	char *p;
> > > -	char part_uuid[DM_UUID_LEN], map_uuid[DM_UUID_LEN];
> > > +	char part_uuid[DM_UUID_LEN], map_uuid[DM_UUID_LEN], c;
> > > +	int np, nc;
> > >  
> > >  	if (dm_get_dm_uuid(part_name, part_uuid) != DMP_OK)
> > >  		return 0;
> > >  
> > > +	if (2 != sscanf(part_uuid, "part%d-%n" UUID_PREFIX "%c",
> > > &np, &nc, &c)
> > 
> > we should probably use "part%u-%n" so we can't match a "-" before the
> > number.
> 
> That doesn't work, %u accepts negative numbers, too
> (https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf)
> That's why I use int and check whether the result is positive.

Huh? I learned something new. I actually find that kind of annoying,
since you could get the same result by just using %d and casting a
unsigned int to a signed one for the assignment, and it seems like
people would often not want to match a dash at the start.

At any rate, you're correct.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> 
> Martin

