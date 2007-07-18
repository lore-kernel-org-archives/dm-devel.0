From: Patrick McHardy <kaber@trash.net>
Subject: Re: [2.6.23 PATCH 07/18] dm io: fix panic on large request
Date: Wed, 18 Jul 2007 12:08:48 +0200
Message-ID: <469DE6B0.60807@trash.net>
References: <20070711205846.GY24114@agk.fab.redhat.com> <469CC11B.2020103@trash.net> <469CF0CD.6060006@ce.jp.nec.com> <469D0159.1010506@trash.net> <469D40BB.3030809@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761418AbXGRKJX@vger.kernel.org>
In-Reply-To: <469D40BB.3030809@ce.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Alasdair G Kergon <agk@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Jun'ichi Nomura wrote:
> Patrick McHardy wrote:
> 
>>Jun'ichi Nomura wrote:
>>
>>>Are you using other dm modules such as dm-multipath, dm-mirror
>>>or dm-snapshot?
>>>If so, can you take the output of 'dmsetup table' and 'dmsetup ls'?
>>
>>No other modules.
>>
>>
>>>Do you have a reliable way to reproduce the oops which I can try?
>>
>>"/etc/init.d/cryptdisk start" (debian) on a luks partition triggered
>>it for me.
> 
> 
> With today's git HEAD (commit 49c13b51a15f1ba9f6d47e26e4a3886c4f3931e2),
> I tried the following but could not reproduce the oops here.
>   # cryptsetup luksFormat /dev/sdb1
>   # cryptsetup luksOpen /dev/sdb1 c
>   # mkfs.ext3 /dev/mapper/c
>   <mount it and do some I/O>


I put in the patch again and it doesn't oops anymore, so sorry for
the false alarm. I did got the oops I pasted several times before
that though, I'll keep an eye on it and try to gather more information
in case it happens again.
