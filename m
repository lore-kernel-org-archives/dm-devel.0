From: John Ogness <john.ogness@linutronix.de>
Subject: Re: Serial console is causing system lock-up
Date: Wed, 13 Mar 2019 09:43:36 +0100
Message-ID: <878sxj9nbb.fsf@linutronix.de>
References: <87tvgfhzd6.fsf@linutronix.de>
	<20190307082509.GA1925@jagdpanzerIV> <87pnr3hyle.fsf@linutronix.de>
	<20190307091748.GA6307@jagdpanzerIV> <87o96nezr2.fsf@linutronix.de>
	<20190307122642.GA10415@tigerII.localdomain>
	<87r2biojcx.fsf@linutronix.de> <20190312023231.GA4146@jagdpanzerIV>
	<87a7i05wwi.fsf@linutronix.de>
	<20190312120824.4eaa4eyjcxvuzm23@pathway.suse.cz>
	<20190313023836.GC783@jagdpanzerIV>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190313023836.GC783@jagdpanzerIV> (Sergey Senozhatsky's message
	of "Wed, 13 Mar 2019 11:38:36 +0900")
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Petr Mladek <pmladek@suse.com>, Nigel Croxon <ncroxon@redhat.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Steven Rostedt <rostedt@goodmis.org>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, linux-serial@vger.kernel.org
List-Id: dm-devel.ids

On 2019-03-13, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com> wrote:
>>> The current printk implementation is handling all console printing
>>> as best effort. Trying hard enough to dramatically affect the
>>> system, but not trying hard enough to guarantee success.
>>
>> I agree that direct output is more reliable. It might be very useful
>> for debugging some types of problems. The question is
>> if it is worth the cost (code complexity, serializing CPUs
>> == slowing down the entire system).
>
> Agreed.
>
> I'm very skeptical about "serializing CPUs" part. It looks like one
> "print or die trying" is replaced with another "print or die trying".
> What happened to log_store() + flush_on_panic()?

We are literally discussing in a thread where the current printk
implementation failed to get messages out (lots of dropped messages)
_and_ printk console printing was responsible for _killing_ the machine.

What would my proposal do in _this_ situation:

1. If no emergency console was available or the messages were not
classified as emergency, messages would have been dropped during console
printing and the system would have run unaffected. The number of dropped
messages might not even be more if the scheduler could run the printk
kthread effectively.

OR

2. If an emergency console was available and the messages were
classified as emergency, _no_ messages would have dropped, the system
would have become very slow on the CPUs generating the messages, and
then eventually it would have recovered.


I don't understand how you can think "print or die trying" is replaced
with another "print or die trying". But it is probably not constructive
to debate this right now. Petr has laid out a good course that will
allow us to advance in smaller, more conservative, steps.

By the way, Sergey, I appreciate your skepticism.

John Ogness
