From: John Ogness <john.ogness@linutronix.de>
Subject: Re: Serial console is causing system lock-up
Date: Tue, 12 Mar 2019 16:19:28 +0100
Message-ID: <87zhq0yvb3.fsf@linutronix.de>
References: <20190307022254.GB4893@jagdpanzerIV>
	<87tvgfhzd6.fsf@linutronix.de> <20190307082509.GA1925@jagdpanzerIV>
	<87pnr3hyle.fsf@linutronix.de> <20190307091748.GA6307@jagdpanzerIV>
	<87o96nezr2.fsf@linutronix.de>
	<20190307122642.GA10415@tigerII.localdomain>
	<87r2biojcx.fsf@linutronix.de> <20190312023231.GA4146@jagdpanzerIV>
	<87a7i05wwi.fsf@linutronix.de>
	<20190312120824.4eaa4eyjcxvuzm23@pathway.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190312120824.4eaa4eyjcxvuzm23@pathway.suse.cz> (Petr Mladek's
	message of "Tue, 12 Mar 2019 13:08:24 +0100")
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Petr Mladek <pmladek@suse.com>
Cc: Nigel Croxon <ncroxon@redhat.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Steven Rostedt <rostedt@goodmis.org>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, linux-serial@vger.kernel.org
List-Id: dm-devel.ids

On 2019-03-12, Petr Mladek <pmladek@suse.com> wrote:
> On Tue 2019-03-12 09:17:49, John Ogness wrote:
>> The current printk implementation is handling all console printing as
>> best effort. Trying hard enough to dramatically affect the system,
>> but not trying hard enough to guarantee success.
>
> I agree that direct output is more reliable. It might be very useful
> for debugging some types of problems. The question is if it is worth
> the cost (code complexity, serializing CPUs == slowing down the
> entire system).
>
> But it is is possible that a reasonable offloading (in the direction
> of last Sergey's approach) might be a better deal.
>
>
> I suggest the following way forward (separate patchsets):
>
>     1. Replace log buffer (least controversial thing)
>     2. Reliable offload to kthread (would be useful anyway)
>     3. Atomic consoles (a lot of tricky code, might not be
> 		worth the effort)
>
> Could we agree on this?

Since this is about the new RFC printk design, I've responded in that
thread [0].

John Ogness

[0] https://lkml.kernel.org/r/874l8815uc.fsf@linutronix.de
