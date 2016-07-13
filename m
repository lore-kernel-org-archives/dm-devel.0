From: Michal Hocko <mhocko@kernel.org>
Subject: Re: System freezes after OOM
Date: Wed, 13 Jul 2016 13:14:26 +0200
Message-ID: <20160713111426.GG28723__22649.1167246879$1468417974$gmane$org@dhcp22.suse.cz>
References: <57837CEE.1010609@redhat.com>
	<f80dc690-7e71-26b2-59a2-5a1557d26713@redhat.com>
	<9be09452-de7f-d8be-fd5d-4a80d1cd1ba3@redhat.com>
	<alpine.LRH.2.02.1607111027080.14327@file01.intranet.prod.int.rdu2.redhat.com>
	<20160712064905.GA14586@dhcp22.suse.cz>
	<alpine.LRH.2.02.1607121907160.24806@file01.intranet.prod.int.rdu2.redhat.com>
	<1e31eea2-beb4-5734-c831-0c1753f0115a@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Resent-To: dm-devel@redhat.com
Resent-Message-ID: <7f9aaa5e-a26c-8cfe-d127-08c5d3d3cb44@redhat.com>
Content-Disposition: inline
In-Reply-To: <1e31eea2-beb4-5734-c831-0c1753f0115a@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jerome Marchand <jmarchan@redhat.com>
Cc: Ondrej Kozina <okozina@redhat.com>, Stanislav Kozina <skozina@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
List-Id: dm-devel.ids

On Wed 13-07-16 10:35:01, Jerome Marchand wrote:
> On 07/13/2016 01:44 AM, Mikulas Patocka wrote:
> > The problem of swapping to dm-crypt is this.
> > 
> > The free memory goes low, kswapd decides that some page should be swapped 
> > out. However, when you swap to an ecrypted device, writeback of each page 
> > requires another page to hold the encrypted data. dm-crypt uses mempools 
> > for all its structures and pages, so that it can make forward progress 
> > even if there is no memory free. However, the mempool code first allocates 
> > from general memory allocator and resorts to the mempool only if the 
> > memory is below limit.
> > 
> > So every attempt to swap out some page allocates another page.
> > 
> > As long as swapping is in progress, the free memory is below the limit 
> > (because the swapping activity itself consumes any memory over the limit). 
> > And that triggered the OOM killer prematurely.
> 
> There is a quite recent sysctl vm knob that I believe can help in this
> case: watermark_scale_factor. If you increase this value, kswapd will
> start paging out earlier, when there might still be enough free memory.
> 
> Ondrej, have you tried to increase /proc/sys/vm/watermark_scale_factor?

I suspect this would just change the timing or the real problem gets
hidden.
-- 
Michal Hocko
SUSE Labs
