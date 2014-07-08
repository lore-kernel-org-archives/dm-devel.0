From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: v3.15 dm-mpath regression: cable pull test causes
 I/O hang
Date: Tue, 8 Jul 2014 23:24:13 +0000
Message-ID: <11AF7C027C4C02408624617A49860784013265CD@BPXM12GP.gisp.nec.co.jp>
References: <53AD6B62.2020407@acm.org> <20140627133345.GA6150@redhat.com>
	<20140702220223.GA23894@redhat.com> <53B56120.8040802@acm.org>
	<20140703140516.GB28104@redhat.com> <53B569E1.1010405@acm.org>
	<11AF7C027C4C02408624617A4986078401311EA8@BPXM12GP.gisp.nec.co.jp>
	<53BAA35B.30204@acm.org>
	<11AF7C027C4C02408624617A498607840132038A@BPXM12GP.gisp.nec.co.jp>
	<20140708163323.GB23439@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140708163323.GB23439@redhat.com>
Content-Language: ja-JP
Content-ID: <25C70A2ED9C0694E92BE0764E62713B1@gisp.nec.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>
List-Id: dm-devel.ids

On 07/09/14 01:33, Mike Snitzer wrote:
> I've merged your fix with a revised header, if you see anything wrong
> with the header please feel free to let me know!  See:
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=75c76c45b76e53b7c2f025d30e7e308bfe331004
> 
> This will likely go to Linus for 3.16-rc5 by this Friday.

Thank you, Mike. I have no problem with the header.

> BTW, I also staged a related cleanup for 3.17, see:
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=2122e57c913cd842e5061137a7093bd06e728677

Yeah, I'm ok with that.

-- 
Jun'ichi Nomura, NEC Corporation
