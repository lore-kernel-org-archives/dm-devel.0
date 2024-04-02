Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0E881AB6
	for <dm-devel@lists.linux.dev>; Tue,  2 Apr 2024 13:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712064686; cv=none; b=hXnR+BIEpdoGU2OsN8J3hkq5g73D0zaRyOPPvD1iKAPDJvGh4jvL9f3eVlQDbgVHUqGYAfzlQvjAZlO+wDr+wS0FW6cm5vbJWJDzC+1U4HSXj30GUMhhIXkicxzQo1NI/RV5p/cnk49w3Vzrae5Pj15fvHa18GfONtc73jejsEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712064686; c=relaxed/simple;
	bh=kcQoxH0jxIgJ/P84Xua+U3nNWiWfpKTH/xOh3LWBl1c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TfO1P05BTVF1G3qIWwmhx8e+4ibP2hGPxWLFnAoQPUrNrgVV/GF+QsoWOIFBvNIiF3Ehm6iSqT1yS/uhEotJvZ4aQ21gQaxpkvr9SroLfbPCFNY/D5In9fOkm9YQhtzvDDxGy2/HCvvlE23ptwXQke5WxlVsJAsHw1/IPgF/+to=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c5o5bDO1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c5o5bDO1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712064684;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GTjl1nh440a+DglsfE5+x1ZIRvYKsGb3C02MGXgaUA0=;
	b=c5o5bDO1wTqTgkPjwW1Tt7eGUwrwz4f0QnvG0rUY+x5E9HuQOrQ3AoyXdqXBpRBX0N3Xcq
	NqEMm0Ji591Iuh/7ZrmcIeXuDoyJief5afcIFI+Wugcyuqessos7cae3Ix4iDgrTH6gac2
	eSKizUAqAABbIuqCORlKeVI3yBDFz2M=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-317-L19wE6C2MtyeSXI-n9B4Mw-1; Tue,
 02 Apr 2024 09:31:20 -0400
X-MC-Unique: L19wE6C2MtyeSXI-n9B4Mw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6CB0A1C0AF45;
	Tue,  2 Apr 2024 13:31:17 +0000 (UTC)
Received: from redhat.com (unknown [10.2.16.64])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CB0811C060D6;
	Tue,  2 Apr 2024 13:31:14 +0000 (UTC)
Date: Tue, 2 Apr 2024 08:31:09 -0500
From: Eric Blake <eblake@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, 
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev, David Teigland <teigland@redhat.com>, 
	Mike Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>, Joe Thornber <ejt@redhat.com>
Subject: Re: [RFC 0/9] block: add llseek(SEEK_HOLE/SEEK_DATA) support
Message-ID: <6yjbfcrsmdmibrfs2pcseehrcbjkn67qzanyhlrduocguqvoaq@jjwntpqtsmpc>
References: <20240328203910.2370087-1-stefanha@redhat.com>
 <20240402122617.GA30720@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240402122617.GA30720@lst.de>
User-Agent: NeoMutt/20240201
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

On Tue, Apr 02, 2024 at 02:26:17PM +0200, Christoph Hellwig wrote:
> On Thu, Mar 28, 2024 at 04:39:01PM -0400, Stefan Hajnoczi wrote:
> > In the block device world there are similar concepts to holes:
> > - SCSI has Logical Block Provisioning where the "mapped" state would be
> >   considered data and other states would be considered holes.
> 
> But for SCSI (and ATA and NVMe) unmapped/delallocated/etc blocks do
> not have to return zeroes.  They could also return some other
> initialization pattern pattern.  So they are (unfortunately) not a 1:1
> mapping to holes in sparse files.

Yes, and Stefan already answered that:

https://lore.kernel.org/dm-devel/e2lcp3n5gpf7zmlpyn4nj7wsr36sffn23z5bmzlsghu6oapi5u@sdkcbpimi5is/t/#m58146a45951ec086966497e179a2b2715692712d

>> SCSI initiators can check the Logical Block Provisioning Read Zeroes
>> (LBPRZ) field to determine whether or not zeroes are guaranteed. The sd
>> driver would only rely on the device when LPBRZ indicates that zeroes
>> will be read. Otherwise the driver would report that the device is
>> filled with data.

As well as my question on whether the community would be open to
introducing new SEEK_* constants to allow orthogonality between
searching for zeroes (known to read as zero, whether or not it was
allocated) vs. sparseness (known to be unallocated, whether or not it
reads as zero), where the existing SEEK_HOLE seeks for both properties
at once.

-- 
Eric Blake, Principal Software Engineer
Red Hat, Inc.
Virtualization:  qemu.org | libguestfs.org

