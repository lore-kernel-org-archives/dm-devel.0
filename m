From: David Rientjes <rientjes@google.com>
Subject: Re: System freezes after OOM
Date: Fri, 15 Jul 2016 14:25:22 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1607151422140.121215@chino.kir.corp.google.com>
References: <57837CEE.1010609@redhat.com> <f80dc690-7e71-26b2-59a2-5a1557d26713@redhat.com> <9be09452-de7f-d8be-fd5d-4a80d1cd1ba3@redhat.com> <alpine.LRH.2.02.1607111027080.14327@file01.intranet.prod.int.rdu2.redhat.com> <20160712064905.GA14586@dhcp22.suse.cz>
 <alpine.LRH.2.02.1607121907160.24806@file01.intranet.prod.int.rdu2.redhat.com> <2d5e1f84-e886-7b98-cb11-170d7104fd13@I-love.SAKURA.ne.jp> <20160713133955.GK28723@dhcp22.suse.cz> <alpine.LRH.2.02.1607131004340.31769@file01.intranet.prod.int.rdu2.redhat.com>
 <20160713145638.GM28723@dhcp22.suse.cz> <alpine.LRH.2.02.1607131105080.31769@file01.intranet.prod.int.rdu2.redhat.com> <alpine.DEB.2.10.1607131644590.92037@chino.kir.corp.google.com> <alpine.LRH.2.02.1607140818250.15554@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.DEB.2.10.1607141316240.68666@chino.kir.corp.google.com> <alpine.LRH.2.02.1607150711270.5034@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1607150711270.5034@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Ondrej Kozina <okozina@redhat.com>, Jerome Marchand <jmarchan@redhat.com>, Stanislav Kozina <skozina@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, 15 Jul 2016, Mikulas Patocka wrote:

> > There is no guarantee that _anything_ can return memory to the mempool,
> 
> You misunderstand mempools if you make such claims.
> 
> There is in fact guarantee that objects will be returned to mempool. In 
> the past I reviewed device mapper thoroughly to make sure that it can make 
> forward progress even if there is no available memory.
> 
> I don't know what should I tell you if you keep on repeating the same 
> false claim over and over again. Should I explain mempool oprerations to 
> you in detail? Or will you find it on your own?
> 

If you are talking about patches you're proposing for 4.8 or any guarantee 
of memory freeing that the oom killer/reaper will provide in 4.8, that's 
fine.  However, the state of the 4.7 kernel is the same as it was when I 
fixed this issue that timed out hundreds of our machines and is 
contradicted by that evidence.  Our machines time out after two hours with 
the oom victim looping forever in mempool_alloc(), so if there was a 
guarantee that elements would be returned in a completely livelocked 
kernel in 4.7 or earlier kernels, that would not have been the case.  I 
frankly don't care about your patch reviewing of dm mempool usage when 
dm_request() livelocked our kernel.

Feel free to formally propose patches either for 4.7 or 4.8.
