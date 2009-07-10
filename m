From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [RFC][PATCH] dm-mirror: fix data corruption
Date: Fri, 10 Jul 2009 20:16:35 +0900
Message-ID: <4A572313.1050402@ce.jp.nec.com>
References: <4A568333.6090901@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4A568333.6090901@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Yasui-san,

Takahiro Yasui wrote:
> This is a prototype patch to fix data corruption issue on dm-raid1.
> It is just a draft patch and is not tested well, but let me post it
> to review and discuss this in-kernel superblock approach.
> 
> I appreciate your comments and suggestions.
<snip>
>   * Introduce superblock area
> 
>     A superblock area is related to a mirror leg on a one-to-one basis and
>     keeps a sequential number to decide the default mirror when the mirror
>     is resumed.

If you are to introduce kernel-managed RAID1 superblock,
isn't it possible to use the on-disk format compatible to md's?
Then the kernel code to handle the superblock may be shared between
md and dm in future, which I think is even better and would help
dm/md convergence.

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation
