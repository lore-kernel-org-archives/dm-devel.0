From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: dm: submit stacked requests in irq enabled context
Date: Wed, 10 May 2017 16:37:46 +0300
Message-ID: <CAOtvUMcjULAOZYQ3K_XDvxcFoFJJjX-wxF6e6Y1+-r67tS_Y7g@mail.gmail.com>
References: <a66b6e17-a8c4-3465-fc2e-c3114abe0ca7@codeaurora.org>
	<dee12838-7b43-2fdd-0644-41c10ecf9148@codeaurora.org>
	<20170509155555.GB2572@localhost.localdomain>
	<20170510071733.GA24980@infradead.org>
	<39356321-b39b-98c7-f52b-ffd19d6dfc69@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <39356321-b39b-98c7-f52b-ffd19d6dfc69@codeaurora.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Neeraj Soni <neersoni@codeaurora.org>
Cc: Christoph Hellwig <hch@infradead.org>, Keith Busch <keith.busch@intel.com>, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Wed, May 10, 2017 at 11:49 AM, Neeraj Soni <neersoni@codeaurora.org> wrote:
> Hi Keith,
>
> Request based dm (dm-req-crypt) is being used for Disk Encryption solution
> in Android used by Google. Also as i mentioned reverting this fix  improves
> the RR/RW numbers so this proves the request based dm is coming into path
> and is being used.

Sadly, that is an out of tree module.

Does it still use Qcom specific APIs in its implementation (qcrypto_* funcs)?
It did the last time I've checked - and the driver that implements
those is not upstream either...

It makes it difficult to help - which is a shame since I am interested
in enabling higher performance
of dm-crypt when using HW based crypto transformation myself.

Gilad
-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
