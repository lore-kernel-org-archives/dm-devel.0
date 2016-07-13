From: Michal Hocko <mhocko@kernel.org>
Subject: Re: System freezes after OOM
Date: Wed, 13 Jul 2016 14:50:51 +0200
Message-ID: <20160713125050.GJ28723__17518.3775289499$1468417981$gmane$org@dhcp22.suse.cz>
References: <57837CEE.1010609@redhat.com>
	<f80dc690-7e71-26b2-59a2-5a1557d26713@redhat.com>
	<9be09452-de7f-d8be-fd5d-4a80d1cd1ba3@redhat.com>
	<alpine.LRH.2.02.1607111027080.14327@file01.intranet.prod.int.rdu2.redhat.com>
	<20160712064905.GA14586@dhcp22.suse.cz>
	<alpine.LRH.2.02.1607121907160.24806@file01.intranet.prod.int.rdu2.redhat.com>
	<20160713111006.GF28723@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Resent-To: dm-devel@redhat.com
Resent-Message-ID: <ee484a0d-7ef7-a64a-1b88-2cbd9b054aa6@redhat.com>
Content-Disposition: inline
In-Reply-To: <20160713111006.GF28723@dhcp22.suse.cz>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Ondrej Kozina <okozina@redhat.com>, Stanislav Kozina <skozina@redhat.com>, Jerome Marchand <jmarchan@redhat.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
List-Id: dm-devel.ids

On Wed 13-07-16 13:10:06, Michal Hocko wrote:
> On Tue 12-07-16 19:44:11, Mikulas Patocka wrote:
[...]
> > As long as swapping is in progress, the free memory is below the limit 
> > (because the swapping activity itself consumes any memory over the limit). 
> > And that triggered the OOM killer prematurely.
> 
> I am not sure I understand the last part. Are you saing that we trigger
> OOM because the initiated swapout will not be able to finish the IO thus
> release the page in time?
> 
> The oom detection checks waits for an ongoing writeout if there is no
> reclaim progress and at least half of the reclaimable memory is either
> dirty or under writeback. Pages under swaout are marked as under
> writeback AFAIR. The writeout path (dm-crypt worker in this case) should
> be able to allocate a memory from the mempool, hand over to the crypt
> layer and finish the IO. Is it possible this might take a lot of time?

I am not familiar with the crypto API but from what I understood from
crypt_convert the encryption is done asynchronously. Then I got lost in
the indirection. Who is completing the request and from what kind of
context? Is it possible it wouldn't be runable for a long time?
-- 
Michal Hocko
SUSE Labs
