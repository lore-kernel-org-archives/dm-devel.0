From: Paul Lawrence <paullawrence@google.com>
Subject: Re: [dm-devel] [RFC] dm-bow working prototype
Date: Mon, 29 Oct 2018 09:51:48 -0700
Message-ID: <fba91b2e-4b2e-8daf-ff64-a12c9139cada@google.com>
References: <20181023212358.60292-1-paullawrence@google.com>
 <20181023221819.GB17552@agk-dp.fab.redhat.com>
 <296148c2-f2d9-5818-ea76-d71a0d6f5cd4@google.com>
 <alpine.LRH.2.02.1810241514310.4080@file01.intranet.prod.int.rdu2.redhat.com>
 <4a934593-1bd1-be5f-35c0-945c42762627@google.com>
 <alpine.LRH.2.02.1810261558460.28906@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1810261558460.28906@file01.intranet.prod.int.rdu2.redhat.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, linux-doc@vger.kernel.org, kernel-team@android.com, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>
List-Id: dm-devel.ids


> The snapshot target could be hacked so that it remembers space trimmed
> with REQ_OP_DISCARD and won't reallocate these blocks.
>
> But I suspect that running discard over the whole device would degrade
> performance more than copying some unneeded data.
>
> How much data do you intend to backup with this solution?
>
>
We are space-constrained - we will have to free up space for the backup 
before we apply the update, so we have to predict the size and keeping 
usage as low as possible is thus very important.

Also, we've discussed the resizing requirement of the dm-snap solution 
and that part is not attractive at all - it seems it would be impossible 
to guarantee that the resizing happens in a timely fashion during the 
(very busy) update cycle.

Thanks everyone for the insights, especially into how dm-snap works, 
which I hadn't fully appreciated. At the moment, and for the above 
reasons, we intend to continue with the dm-bow solution, but do want to 
keep this discussion open. If anyone is going to be at Linux Plumbers, 
I'll be presenting this work and would love to chat about it more.
