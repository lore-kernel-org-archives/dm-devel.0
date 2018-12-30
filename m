From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [git pull] device mapper changes for 4.21
Date: Sun, 30 Dec 2018 14:15:33 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1812301413220.7178@file01.intranet.prod.int.rdu2.redhat.com>
References: <20181227160944.GA12190@redhat.com>
	<20181230090646.GB1022@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181230090646.GB1022@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Sweet Tea <sweettea@redhat.com>, wuzhouhui <wuzhouhui14@mails.ucas.ac.cn>, AliOS system security <alios_sys_security@linux.alibaba.com>, Nikos Tsironis <ntsironis@arrikto.com>, Mike Snitzer <snitzer@redhat.com>, Eric Biggers <ebiggers@google.com>, Heinz Mauelshagen <heinzm@redhat.com>, Shenghui Wang <shhuiw@foxmail.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, Jaegeuk Kim <jaegeuk@kernel.org>, Colin Ian King <colin.king@canonical.com>, Linus Torvalds <torvalds@linux-foundation.org>, Milan Broz <gmazyland@gmail.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids



On Sun, 30 Dec 2018, Christoph Hellwig wrote:

> On Thu, Dec 27, 2018 at 11:09:44AM -0500, Mike Snitzer wrote:
> > - Fix various DM targets to check for device sector overflow if
> >   CONFIG_LBDAF is not set.
> 
> Question to Jens and Linus:
> 
> is there any good reason to keep the CONFIG_LBDAF=n option around?
> Less than 2gig block devices seem to be an absolutele niche, and I
> wonder if it is still worth maintaining the special case just for that.

The CONFIG_LBDAF limit is 2TiB, not 2GiB.

But you're right that 2TiB devices are common and that perhaps this option 
should go away.

Mikulas
