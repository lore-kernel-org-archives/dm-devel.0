Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B75383C97;
	Tue, 16 Jun 2026 20:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781640563; cv=none; b=jY92xbJK9UGeEznoy9MqkYztCeP3FwULIG5ad8zIT0Gtwc/BT3i06ZKQrDq48cA9gbQwWJuTTWQVJ8pc9mdkUMguDOLElmUKzYDwFOCyXtQrIX2WUUsp0LhpmrWk9dBGF8OJ0Yz9qIDLzC7YfgaVYlCXUa61ZUTR/Cjg+YLh+h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781640563; c=relaxed/simple;
	bh=biN34mc3tzes4onlYIm5lUp5N4wyzZL6l1DxGLenBIs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qolc45eIMs6Nt2QL7r1QWSInGQvT/cUMXWhaOVvHuC5xMEbl71R0RMEoT+9TF1pe73dHsN4en7YbqPiuJ58Mdto6sph4gEC336V4ixHGzOh7UuZektGXH9tyjoodzWzn+WQSOOqud77yd9ACbcpGoxXAC/Nb/x97QmTLyaskUic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=TO0g89Dq; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="TO0g89Dq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=M3IO3jImbbmdWmdveUeJx2d7uwMS2XBEpl0/onXjTR0=; b=TO0g89DqEuGwESEw
	vxtGUfjBXSCSDwsA3IT/fGidTeIOKU6k/p9yHkJbmHAeLd5YQETIoGOyhefwptoZqfwE/wyHFDom6
	7KFf9VoEiuSPl6zwGmKuWZw08ZMaeljXwcLH/o5BYY9gGqC02aU2d26AvLHvGEHXINPl/286qtUYJ
	4HRRQEyEo1dma18sGRjZfAdmS5SHvUCuF0/ywh7OZeKYHCUmmCjPFIqjS8Zdnb6jRV7/rTCsPdJFS
	O/qm4459K8UzLDuUxQDeUFM22DA1upREPlSS7HK8+Sm5caJwsUXQuY/OUSkGAKRp8a/yLgxkrtVeK
	NFlqDpXk25yk6WsfBg==;
Received: from dg by mx.treblig.org with local (Exim 4.98.2)
	(envelope-from <dg@treblig.org>)
	id 1wZa62-000000088WK-1pVz;
	Tue, 16 Jun 2026 20:09:18 +0000
Date: Tue, 16 Jun 2026 20:09:18 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org, mpatocka@redhat.com,
	Vjaceslavs Klimovs <vklimovs@gmail.com>
Subject: Re: [PATCH 2/2] dm-raid1: don't fail the mirror for invalid I/O
 errors
Message-ID: <ajGtbuJ2kXo1GZ1d@gallifrey>
References: <20260616150554.1686662-1-kbusch@meta.com>
 <20260616150554.1686662-2-kbusch@meta.com>
 <ajGN1OKun3qyvqMc@gallifrey>
 <ajGacnaCZ6v6VE1B@kbusch-mbp>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <ajGacnaCZ6v6VE1B@kbusch-mbp>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.12.88+deb13-amd64 (x86_64)
X-Uptime: 20:03:05 up 31 days, 23:15,  2 users,  load average: 0.00, 0.00,
 0.00
User-Agent: Mutt/2.2.13 (2024-03-09)

* Keith Busch (kbusch@kernel.org) wrote:
> On Tue, Jun 16, 2026 at 05:54:28PM +0000, Dr. David Alan Gilbert wrote:
> > OK, for this pair I think would be fair for a Tested-by me as well;
> > they certainly resolve the hang and the WARN/BUGs.
> > I still see the errors as EIO on my tests, and on the older mirror type
> 
> Could you share your reproducer? I'm just using the original recipe you
> sent here:
> 
> https://lore.kernel.org/linux-block/ai7rnH20IYeSmY8s@gallifrey/
> 
> And I'm seeing EINVAL instead EIO.

Interesting; I've got your:
  dm-raid1: don't fail the mirror for invalid I/O errors
  For DM_IO_BIO requests, do_region() built each destination bio by walking..
ontop of e21ee273e6fa3879aec9a27251cfce98156e07c4 which is just before 7.1
  I've not your https://lore.kernel.org/linux-block/20260612223205.465913-1-kbusch@meta.com/

root@dalek:/home/dg# lvcreate  --mirrors 1 -L 1G main /dev/sda2 /dev/sdb2
root@dalek:/home/dg# mkfs.ext4 /dev/mapper/main-lvol0
root@dalek:/home/dg# mount /dev/mapper/main-lvol0 /mnt/tmp/
root@dalek:/home/dg# chmod a+rwx /mnt/tmp

dg@dalek:~$ dd if=/dev/zero of=/mnt/tmp/testfile bs=1024k count=1

my two tests are separate tests:
{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}
dg@dalek:~$ cat dbf.c
#include <errno.h>
#include <fcntl.h>             
#include <asm-generic/fcntl.h>
#include <stdio.h> 
#include <unistd.h>


const char* path="/mnt/tmp/testfile";
static char buf[8192];

int main()                                       
{
  int fd=open(path, O_RDWR|O_DIRECT|O_CLOEXEC);
    
  errno=0;
  int res3=pread(fd, buf, 4096, 0);
  printf("pread of 4096 said: %d (%m)\n", res3);

}
{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}
dg@dalek:~$ cat dbf-write.c
#include <errno.h>
#include <fcntl.h>             
#include <asm-generic/fcntl.h>
#include <stdio.h> 
#include <unistd.h>


const char* path="/mnt/tmp/testfile";
static char buf[8192];

int main()                                       
{
  int fd=open(path, O_RDWR|O_DIRECT|O_CLOEXEC);
    
  errno=0;
  int res3=pwrite(fd, buf, 4096, 0);
  printf("pwrite of 4096 said: %d (%m)\n", res3);

}
{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}{--}


> > get the stuck resync on write, and on the newer mirror I see the write
> > apparently succeed (did it really?)
> 
> There was a time when ext4 used to fallback to buffered io for writes
> but not for reads, but looks like that was fixed since 6.18, so should
> be returning error.
> 
> I tried testing it with a modification to your original read test, and
> it is still failing with EINVAL for me:
> 
>   pread of 4096 said: -1 (Invalid argument)
>   pwrite of 4096 said: -1 (Invalid argument)

Your double test gives me:
dg@dalek:~$ ./dbf-joint 
pread of 4096 said: -1 (Input/output error)
pwrite of 4096 said: 4096 (Input/output error)

> ---
> #define _GNU_SOURCE
> #include <errno.h>
> #include <fcntl.h>
> #include <stdio.h>
> #include <unistd.h>
> 
> const char* path="/mnt/tmp/testfile";
> static char buf[8192];
> 
> int main()
> {
>   int fd=open(path, O_RDWR|O_DIRECT|O_CLOEXEC);
> 
>   errno=0;
>   int res3=pread(fd, buf, 4096, 0);
>   printf("pread of 4096 said: %d (%m)\n", res3);

errno=0;

>   res3=pwrite(fd, buf, 4096, 0);
>   printf("pwrite of 4096 said: %d (%m)\n", res3);
> }

Dave

> --
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
