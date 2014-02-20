From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-crypt: remove per-cpu structure
Date: Thu, 20 Feb 2014 18:59:35 -0500
Message-ID: <20140220235935.GA32743@redhat.com>
References: <alpine.LRH.2.02.1402201758190.28312@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1402201758190.28312@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: Tejun Heo <tj@kernel.org>, dm-devel@redhat.com, Lisa Du <chunlingdu1@gmail.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Feb 20 2014 at  6:01pm -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Dm-crypt used per-cpu structures to hold pointers to ablkcipher_request.
> The code assumed that the work item keeps executing on a single CPU, so it
> used no synchronization when accessing this structure.
> 
> When we disable a CPU by writing zero to
> /sys/devices/system/cpu/cpu*/online, the work item could be moved to
> another CPU. This causes crashes in dm-crypt because the code starts using
> a wrong ablkcipher_request.
> 
> This patch fixes this bug by removing the percpu definition. The structure
> ablkcipher_request is accessed via a pointer from convert_context.
> Consequently, if the work item is rescheduled to a different CPU, the
> thread still uses the same ablkcipher_request.

Hi Mikulas,

Obviously avoiding crashes is more important than performance.

But are we losing performance by switching away from using percpu?  Do
we care?  I'd like to see the header to speak to the potential for
slowdown (if there is any).
