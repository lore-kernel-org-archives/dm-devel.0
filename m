Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4071369A7
	for <dm-devel@lists.linux.dev>; Fri, 29 Mar 2024 12:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711715912; cv=none; b=nM14PS7/Kg5LDrZmBe+h9qOspXMdMlSZ2uUJt2nRuWrIaXi1lWvFioGbiP0/0Xn9ycoJ+1GgN0gvfPjnTxqUFMtdjE0rWWsAQ0+E9I9ixwUAh0DC6ukenezb7t5Le+Jn7dUv+K4erFXrOgtV1DRkR1DU9w6C24Rv7IxpBirL1F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711715912; c=relaxed/simple;
	bh=/Vcs98eIwBfAVmQudxzEl/D2HfXg0h5pd/qnhUjw8Bw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LEZlZOyQT5dC+snez3derW8IY737puzY6aO7x+58k6Wi8uE9MpbzX2UMjqMv1Z8ELGejRkCTeFbtKDdOE4gWOlfDwO9F/XpCg8OnawIRIf3WqNzT2FYc1B9Xj721lZfZIoNOsvu+X//vNlyN3hHtX/Ra66nBLLiHTNpi6l6qcOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WaLcX+o9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WaLcX+o9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711715910;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N1h/sI7lud1TUTbC3pqJNKCflJ35bQiddXm8poucTAE=;
	b=WaLcX+o9kbIk0KbokH4PQcXwsvuN+GCW6henPjIpG0VUsZAB/mE1yGEIPVTmzyaTxKFLsW
	HwJKwjg2h09KZa0wBulrDqpnGMt9ry33KYhJEKYp0tiXPHvHA2j3OzS/FQWYfy2+GRVxYj
	52zpOGHlMDgKMSr64Q+ycRsUQnuI4OY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-647-jud4lLB8PvKF1NeK86-r7w-1; Fri, 29 Mar 2024 08:38:26 -0400
X-MC-Unique: jud4lLB8PvKF1NeK86-r7w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9AA7B85A58C;
	Fri, 29 Mar 2024 12:38:25 +0000 (UTC)
Received: from redhat.com (unknown [10.2.16.33])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ADE19111E3F3;
	Fri, 29 Mar 2024 12:38:22 +0000 (UTC)
Date: Fri, 29 Mar 2024 07:38:17 -0500
From: Eric Blake <eblake@redhat.com>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Alasdair Kergon <agk@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev, 
	David Teigland <teigland@redhat.com>, Mike Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Christoph Hellwig <hch@lst.de>, Joe Thornber <ejt@redhat.com>
Subject: Re: [RFC 3/9] selftests: block_seek_hole: add loop block driver tests
Message-ID: <6mssvnoq4bpaf53kkla45np5lijptyh4c2orayqx4mqacj572u@6s4y6bhdtcpm>
References: <20240328203910.2370087-1-stefanha@redhat.com>
 <20240328203910.2370087-4-stefanha@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240328203910.2370087-4-stefanha@redhat.com>
User-Agent: NeoMutt/20240201
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

On Thu, Mar 28, 2024 at 04:39:04PM -0400, Stefan Hajnoczi wrote:
> Run the tests with:
> 
>   $ make TARGETS=block_seek_hole -C tools/selftests run_tests
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>  tools/testing/selftests/Makefile              |   1 +
>  .../selftests/block_seek_hole/Makefile        |  17 +++
>  .../testing/selftests/block_seek_hole/config  |   1 +
>  .../selftests/block_seek_hole/map_holes.py    |  37 +++++++
>  .../testing/selftests/block_seek_hole/test.py | 103 ++++++++++++++++++
>  5 files changed, 159 insertions(+)
>  create mode 100644 tools/testing/selftests/block_seek_hole/Makefile
>  create mode 100644 tools/testing/selftests/block_seek_hole/config
>  create mode 100755 tools/testing/selftests/block_seek_hole/map_holes.py
>  create mode 100755 tools/testing/selftests/block_seek_hole/test.py
> 

> +
> +def map_holes(fd):
> +    end = os.lseek(fd, 0, os.SEEK_END)
> +    offset = 0
> +
> +    print('TYPE START END SIZE')
> +
> +    while offset < end:
> +        contents = 'DATA'
> +        new_offset = os.lseek(fd, offset, os.SEEK_HOLE)
> +        if new_offset == offset:
> +            contents = 'HOLE'
> +            try:
> +              new_offset = os.lseek(fd, offset, os.SEEK_DATA)
> +            except OSError as err:
> +                if err.errno == errno.ENXIO:
> +                    new_offset = end
> +                else:
> +                    raise err
> +            assert new_offset != offset
> +        print(f'{contents} {offset} {new_offset} {new_offset - offset}')
> +        offset = new_offset

Over the years, I've seen various SEEK_HOLE implementation bugs where
things work great on the initial boundary, but fail when requested on
an offset not aligned to the start of the extent boundary.  It would
probably be worth enhancing the test to prove that:

if lseek(fd, offset, SEEK_HOLE) == offset:
  new_offset = lseek(fd, offset, SEEK_DATA)
  assert new_offset > offset
  assert lseek(fd, new_offset - 1, SEEK_HOLE) == new_offset - 1
else:
  assert lseek(fd, offset, SEEK_DATA) == offset
  new_offset = lseek(fd, offset, SEEK_HOLE)
  assert new_offset > offset
  assert lseek(fd, new_offset - 1, SEEK_DATA) == new_offset - 1

Among other things, this would prove that even though block devices
generally operate on a minimum granularity of a sector, lseek() still
gives byte-accurate results for a random offset that falls in the
middle of a sector, and doesn't accidentally round down reporting an
offset less than the value passed in to the request.

-- 
Eric Blake, Principal Software Engineer
Red Hat, Inc.
Virtualization:  qemu.org | libguestfs.org

