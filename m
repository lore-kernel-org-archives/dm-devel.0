From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] [153/2many] MAINTAINERS - DEVICE-MAPPER  (LVM)
Date: Tue, 14 Aug 2007 09:19:23 -0700
Message-ID: <1187108363.32555.45.camel@localhost>
References: <46bff986.szARdClTcYqQa8So%joe@perches.com>
	 <46C1888E.4060501@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1764154AbXHNQT5@vger.kernel.org>
In-Reply-To: <46C1888E.4060501@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, akpm@linux-foundation.org, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, 2007-08-14 at 12:48 +0200, Milan Broz wrote:
> File pattern should be:
> F:	drivers/md/dm*
> F:	drivers/md/kcopyd*
> F:	include/linux/device-mapper.h
> F:	include/linux/dm-ioctl.h
> F:	Documentation/device-mapper/

Thanks.  In my tree I've got:

DEVICE-MAPPER  (LVM)
P:	Alasdair Kergon
L:	dm-devel@redhat.com
W:	http://sources.redhat.com/dm
S:	Maintained
F:      Documentation/device-mapper/
F:      drivers/md/dm*
F:      drivers/md/kcopyd*
F:      include/linux/device-mapper.h
F:      include/linux/dm-ioctl.h
