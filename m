Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5973E374E7
	for <dm-devel@lists.linux.dev>; Wed,  8 Nov 2023 22:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VNTcduve"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699481606;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KRCee2Ya8BfhjFz1bqbC3MbwItB+uVx0ve7VtAuPKuM=;
	b=VNTcduve3mNwhIZpUYyVrKGr240boj83DoRWdADjTR/CM6PdzmZMwX7p/BysvGYZHHgPAH
	Zb+8XbsaW2bxt4DtdjBb/mlpV1lBve4ZOTcKhkVRaKIacr6or3B7QRkdQJzKT8BIiJApkc
	o7FmO9bHQ+oNT78gJ6qQjQlukOn8wb8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-76-nR33b0lMNc62hwH_HQx_Pw-1; Wed,
 08 Nov 2023 17:13:22 -0500
X-MC-Unique: nR33b0lMNc62hwH_HQx_Pw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6BB2A3C23644;
	Wed,  8 Nov 2023 22:13:22 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (bmarzins-01.fast.rdu2.eng.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 65407492BFA;
	Wed,  8 Nov 2023 22:13:22 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1) with ESMTPS id 3A8MDMxK089883
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 8 Nov 2023 17:13:22 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1/Submit) id 3A8MDMWE089882;
	Wed, 8 Nov 2023 17:13:22 -0500
Date: Wed, 8 Nov 2023 17:13:22 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>,
        "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 3/7] multipathd: check and update all paths when in
 cli_resize
Message-ID: <ZUwIAktuUC6F8woK@bmarzins-01.fast.rdu2.eng.redhat.com>
References: <20231102221507.105371-1-bmarzins@redhat.com>
 <20231102221507.105371-4-bmarzins@redhat.com>
 <e679c9cc5fba535167551e54cf37347b215d44c3.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <e679c9cc5fba535167551e54cf37347b215d44c3.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Nov 08, 2023 at 05:56:42PM +0000, Martin Wilck wrote:
> On Thu, 2023-11-02 at 18:15 -0400, Benjamin Marzinski wrote:
> > When resizing a multipath device, make sure that all the paths have
> > been updated to the new size first.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  multipathd/cli_handlers.c | 30 +++++++++++++++++-------------
> >  1 file changed, 17 insertions(+), 13 deletions(-)
> > 
> > diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> > index c9addfbb..ffea193d 100644
> > --- a/multipathd/cli_handlers.c
> > +++ b/multipathd/cli_handlers.c
> > @@ -845,9 +845,11 @@ cli_resize(void *v, struct strbuf *reply, void
> > *data)
> >  	char * mapname = get_keyparam(v, KEY_MAP);
> >  	struct multipath *mpp;
> >  	int minor;
> > -	unsigned long long size;
> > +	unsigned long long size = 0;
> >  	struct pathgroup *pgp;
> >  	struct path *pp;
> > +	unsigned int i, j;
> > +	bool mismatch = false;
> >  
> >  	mapname = convert_dev(mapname, 0);
> >  	condlog(2, "%s: resize map (operator)", mapname);
> > @@ -867,21 +869,23 @@ cli_resize(void *v, struct strbuf *reply, void
> > *data)
> >  		return 1;
> >  	}
> >  
> > -	pgp = VECTOR_SLOT(mpp->pg, 0);
> > -
> > -	if (!pgp){
> > -		condlog(0, "%s: couldn't get path group. cannot
> > resize",
> > -			mapname);
> > -		return 1;
> > +	vector_foreach_slot(mpp->pg, pgp, i) {
> > +		vector_foreach_slot (pgp->paths, pp, j) {
> > +			if (sysfs_get_size(pp, &pp->size) != 0)
> > +				continue;
> > +			if (!size)
> > +				size = pp->size;
> 
> In the previous patch, you assume that if sysfs_get_size() fails, the
> size is unchanged. The "continue" doesn't make much sense to me: you
> should make the same assumption here, i.e. set size = pp->size even in
> the failure case. Otherwise you might miss a size mismatch.
> 
> Altenatively, you could error out immediately if sysfs_get_size() fails
> for any path.

I figured that paths for which we can't get a size shouldn't stop a
resize if all the other paths have changed size, but I admit that isn't
really consistent. I'll change it.

-Ben
 
> Martin
> 
> 
> > +			else if (pp->size != size)
> > +				mismatch = true;
> > +		}
> >  	}
> > -	pp = VECTOR_SLOT(pgp->paths, 0);
> > -
> > -	if (!pp){
> > -		condlog(0, "%s: couldn't get path. cannot resize",
> > mapname);
> > +	if (!size) {
> > +		condlog(0, "%s: couldn't get size from sysfs. cannot
> > resize",
> > +			mapname);
> >  		return 1;
> >  	}
> > -	if (!pp->udev || sysfs_get_size(pp, &size)) {
> > -		condlog(0, "%s: couldn't get size for sysfs. cannot
> > resize",
> > +	if (mismatch) {
> > +		condlog(0, "%s: path size not consistent. cannot
> > resize",
> >  			mapname);
> >  		return 1;
> >  	}

