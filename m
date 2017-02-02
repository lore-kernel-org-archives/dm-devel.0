From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: linux-next: Tree for Feb 2 (drivers/md/dm.c)
Date: Thu, 2 Feb 2017 09:58:26 -0800
Message-ID: <8a8224e7-4c90-7fa7-9960-fc04fe658014@infradead.org>
References: <20170202182117.73e354f1@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170202182117.73e354f1@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dm <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 02/01/17 23:21, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20170201:
> 

on x86_64:

drivers/built-in.o: In function `dm_blk_ioctl':
dm.c:(.text+0x1a5121): undefined reference to `scsi_verify_blk_ioctl'

# CONFIG_BLK_DEV_BSG is not set
# CONFIG_BLK_DEV_BSGLIB is not set


-- 
~Randy
