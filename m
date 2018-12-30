From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [git pull] device mapper changes for 4.21
Date: Sun, 30 Dec 2018 11:40:19 -0800
Message-ID: <1546198819.2844.16.camel@HansenPartnership.com>
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
To: Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>
Cc: Tea <sweettea@redhat.com>, wuzhouhui <wuzhouhui14@mails.ucas.ac.cn>, Heinz, system security <alios_sys_security@linux.alibaba.com>, Tsironis <ntsironis@arrikto.com>, Eric Biggers <ebiggers@google.com>, Mauelshagen <heinzm@redhat.com>, Sweet, Nikos, Shenghui Wang <shhuiw@foxmail.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, Patocka <mpatocka@redhat.com>, Mikulas, Jaegeuk Kim <jaegeuk@kernel.org>, Colin Ian King <colin.king@canonical.com>, linux-arch@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Milan Broz <gmazyland@gmail.com>, Alasdair G Kergon <agk@redhat.com>, AliOS
List-Id: dm-devel.ids

On Sun, 2018-12-30 at 01:06 -0800, Christoph Hellwig wrote:
> On Thu, Dec 27, 2018 at 11:09:44AM -0500, Mike Snitzer wrote:
> > - Fix various DM targets to check for device sector overflow if
> >   CONFIG_LBDAF is not set.
> 
> Question to Jens and Linus:
> 
> is there any good reason to keep the CONFIG_LBDAF=n option around?
> Less than 2gig block devices seem to be an absolutele niche, and I
> wonder if it is still worth maintaining the special case just for
> that.

It's really a question for embedded isn't it? since they're the ones
with this set to 'n' in their default configs (linux-arch cc added). 
What LBDAF=n does is make sector_t and blkcnt_t unsigned long instead
of u64.  The maintenance burden to us is we have to use sector_div
instead of do_div in the code and remember that sector_t may be 32 bit
(the current problem in LVM).  The benefit to embedded architectures is
that they don't have to do 64 bit arithmetic for every block
transaction and the price is they can't support block devices larger
than 2TB (not 2GB, although the AF part means we can't support file
sizes bigger than 2GB).

So the first question is: is there an embedded platform where anyone
thinks the cost of the 64 bit arithmetic is important?  and if there is
can they benchmark it so we get an idea of the value of keeping LBDAF
(i.e. if it's just a few percent then likely it's not worth it, if it's
in the tens of percent, it might be).

James
