From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH 0/3] sysfs representation of stacked devices
	(dm/md)
Date: Tue, 21 Feb 2006 10:34:55 -0500
Message-ID: <43FB331F.9020104@ce.jp.nec.com>
References: <43F60F31.1030507@ce.jp.nec.com>
	<20060217194249.GO12169@agk.surrey.redhat.com>
	<43F6769C.5010505@ce.jp.nec.com>
	<20060218195347.GU12169@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060218195347.GU12169@agk.surrey.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Lars Marowsky-Bree <lmb@suse.de>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Alasdair G Kergon wrote:
>>Speaking about the efficiency, 'dmsetup ls --tree' works well.
>>However, I haven't yet found a efficient way to implement
>>'dmsetup info --tree -o inverted dm-0', for example.
>  
> Indeed - but what needs this that doesn't also need to scan
> everything?    mount?

mount, fsck and other blkid based tools could be optimized with it.
However, what I had in mind was system administration like just
using dmsetup or looking /sys to check where a device belongs.

-- 
Jun'ichi Nomura, NEC Solutions (America), Inc.
