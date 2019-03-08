From: John Ogness <john.ogness@linutronix.de>
Subject: Re: Serial console is causing system lock-up
Date: Fri, 08 Mar 2019 03:36:27 +0100
Message-ID: <87o96mozx0.fsf@linutronix.de>
References: <alpine.LRH.2.02.1903060917280.5335@file01.intranet.prod.int.rdu2.redhat.com>
	<20190306152218.eocv4zulf7tv2mkc@pathway.suse.cz>
	<alpine.LRH.2.02.1903061031420.16905@file01.intranet.prod.int.rdu2.redhat.com>
	<20190306163003.GA31858@mit.edu>
	<alpine.LRH.2.02.1903061157530.3129@file01.intranet.prod.int.rdu2.redhat.com>
	<20190306171943.12345598@oasis.local.home>
	<87ftrzbp3y.fsf@linutronix.de>
	<23681.9703.524330.948156@quad.stoffel.home>
	<alpine.LRH.2.02.1903070918110.6122@file01.intranet.prod.int.rdu2.redhat.com>
	<20190308012242.GA4063@jagdpanzerIV>
	<20190308013952.GA9085@jagdpanzerIV>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190308013952.GA9085@jagdpanzerIV> (Sergey Senozhatsky's
	message of "Fri, 8 Mar 2019 10:39:52 +0900")
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
Cc: Petr Mladek <pmladek@suse.com>, Nigel Croxon <ncroxon@redhat.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, John Stoffel <john@stoffel.org>, Steven Rostedt <rostedt@goodmis.org>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, linux-serial@vger.kernel.org
List-Id: dm-devel.ids

On 2019-03-08, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com> wrote:
>>> Perhaps a proper solution would be to drop excessive messages to
>>> serial console unless Oops or BUG has happened?
>> 
>> Technically, we can have a per-console loglevel configuration. We
>> have several use cases for this already.
>
> JFI,
>
> lore.kernel.org/r/cover.1551486732.git.calvinowens@fb.com

FWIW, I support the patch. It makes consoles into actual objects rather
than just a collection of callbacks. I feel like Calvin is pushing in a
similar direction to what I would like to see: decoupling of console
drivers to allow for individual behavior and performance tuning. As we
move into the highly SMP systems of the future, I am convinced this is
inevitable.

John Ogness
