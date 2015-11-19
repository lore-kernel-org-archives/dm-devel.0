From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] dm-crypt: fix a possible race condition
	on exit
Date: Thu, 19 Nov 2015 14:34:57 -0500
Message-ID: <20151119193456.GA12698@redhat.com>
References: <alpine.LRH.2.02.1511181637540.24040@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1511190733040.27567@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1511190733040.27567@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Nov 19 2015 at  7:36am -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> I forgot to unlock the spinlock when terminating the thread - so here is 
> new version of the patch.

I applied this patch for inclusion in 4.4-rc (will likely send to Linus
next week once it gets some exposure in linux-next), see:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.4&id=bcbd94ff481ec1d7b5c824d90df82d0faafabd35
