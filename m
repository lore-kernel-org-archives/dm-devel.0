From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: linux-next: Tree for Mar 8 (md/dm-mpath.c)
Date: Thu, 8 Mar 2018 09:56:33 -0800
Message-ID: <c4f96fc4-8e90-4682-8190-5ae99b804136@infradead.org>
References: <20180308163336.2943012b@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180308163336.2943012b@canb.auug.org.au>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>, Linux-Next Mailing List <linux-next@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Joe Thornber <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 03/07/2018 09:33 PM, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20180307:
> 

on i386: when CONFIG_SCSI is not enabled:

drivers/md/dm-mpath.o: In function `multipath_ctr':
dm-mpath.c:(.text+0x1ab7): undefined reference to `scsi_device_from_queue'


-- 
~Randy
