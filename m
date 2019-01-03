From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [git pull] device mapper changes for 4.21
Date: Wed, 2 Jan 2019 23:27:54 -0800
Message-ID: <20190103072754.GA2667@infradead.org>
References: <20181227160944.GA12190@redhat.com>
	<20181230090646.GB1022@infradead.org>
	<alpine.LRH.2.02.1812301413220.7178@file01.intranet.prod.int.rdu2.redhat.com>
	<CAHk-=wh89gmqGaK4K7+ns9S6CSeCfuUmiy8GPeVz8_ntMz-DYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAHk-=wh89gmqGaK4K7+ns9S6CSeCfuUmiy8GPeVz8_ntMz-DYg@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sweet Tea <sweettea@redhat.com>, linux-block <linux-block@vger.kernel.org>, AliOS system security <alios_sys_security@linux.alibaba.com>, Nikos Tsironis <ntsironis@arrikto.com>, Mike Snitzer <snitzer@redhat.com>, Eric Biggers <ebiggers@google.com>, Heinz Mauelshagen <heinzm@redhat.com>, Shenghui Wang <shhuiw@foxmail.com>, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Jaegeuk Kim <jaegeuk@kernel.org>, wuzhouhui <wuzhouhui14@mails.ucas.ac.cn>, Colin Ian King <colin.king@canonical.com>, Milan Broz <gmazyland@gmail.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Sun, Dec 30, 2018 at 04:25:46PM -0800, Linus Torvalds wrote:
> On Sun, Dec 30, 2018 at 11:15 AM Mikulas Patocka <mpatocka@redhat.com> wrote:
> >
> > But you're right that 2TiB devices are common and that perhaps this option
> > should go away.
> 
> 2TiB devices are definitely not common in the one situation where this
> option might matter: small embedded devices.
> 
> I don't think the cost of 64 bit is in the arithmetic, but it might be
> in some of the data structures.
> 
> But my gut feel is that it probably doesn't much matter, and we could
> get rid of the config option without anybody ever noticing. I don't
> think we have that many data structures with 'sector_t' in them.
> 
> We might try to first just force the option on, and see if anybody even cares.

Our smallest embedded devices use raw flash using the MTD subsystem,
and even that is using 64-bit size types everywhere.  So I'd be really
surprised if it is an issue.

> 
>                   Linus
---end quoted text---
