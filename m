From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [2.6.23 PATCH 07/18] dm io: fix panic on large
	request
Date: Tue, 17 Jul 2007 18:20:43 -0400
Message-ID: <469D40BB.3030809@ce.jp.nec.com>
References: <20070711205846.GY24114@agk.fab.redhat.com>
	<469CC11B.2020103@trash.net> <469CF0CD.6060006@ce.jp.nec.com>
	<469D0159.1010506@trash.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <469D0159.1010506@trash.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Patrick McHardy <kaber@trash.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Patrick McHardy wrote:
> Jun'ichi Nomura wrote:
>> Are you using other dm modules such as dm-multipath, dm-mirror
>> or dm-snapshot?
>> If so, can you take the output of 'dmsetup table' and 'dmsetup ls'?
> 
> No other modules.
> 
>> Do you have a reliable way to reproduce the oops which I can try?
> 
> "/etc/init.d/cryptdisk start" (debian) on a luks partition triggered
> it for me.

With today's git HEAD (commit 49c13b51a15f1ba9f6d47e26e4a3886c4f3931e2),
I tried the following but could not reproduce the oops here.
  # cryptsetup luksFormat /dev/sdb1
  # cryptsetup luksOpen /dev/sdb1 c
  # mkfs.ext3 /dev/mapper/c
  <mount it and do some I/O>

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation of America
