From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 0/3] sysfs representation of stacked devices
	(dm/md)
Date: Mon, 20 Feb 2006 09:04:27 +1100
Message-ID: <17400.60267.923268.861047@cse.unsw.edu.au>
References: <43F60F31.1030507@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: message from Jun'ichi Nomura on Friday February 17
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>, Lars Marowsky-Bree <lmb@suse.de>, Alasdair Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Friday February 17, j-nomura@ce.jp.nec.com wrote:
> Hello,
> 
> These patches provide common representation of dependencies
> between stacked devices (dm and md) in sysfs.
> For example, if dm-0 maps to sda, we have the following symlinks;
>    /sys/block/dm-0/slaves/sda --> /sys/block/sda
>    /sys/block/sda/holders/dm-0 --> /sys/block/dm-0

I happy with the idea of having these links.
I agree that it would be nice to have this very strongly based on the
bd_claim infrastructure.

It would be really nice if bd_claim took a "kobject *" rather than a 
"void *" and put a link in there.  This would be easy for dm and md,
but awkward for other claimers like filesystems and open file
descriptors as they don't currently have kobjects.

Possibly an extra flag that says if the 'holder' is a kobject or not,
and if it is, appropriate symlinks are created...??

NeilBrown
