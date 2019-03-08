From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: Serial console is causing system lock-up
Date: Fri, 8 Mar 2019 10:22:42 +0900
Message-ID: <20190308012242.GA4063@jagdpanzerIV>
References: <alpine.LRH.2.02.1903060917280.5335@file01.intranet.prod.int.rdu2.redhat.com>
	<20190306152218.eocv4zulf7tv2mkc@pathway.suse.cz>
	<alpine.LRH.2.02.1903061031420.16905@file01.intranet.prod.int.rdu2.redhat.com>
	<20190306163003.GA31858@mit.edu>
	<alpine.LRH.2.02.1903061157530.3129@file01.intranet.prod.int.rdu2.redhat.com>
	<20190306171943.12345598@oasis.local.home>
	<87ftrzbp3y.fsf@linutronix.de>
	<23681.9703.524330.948156@quad.stoffel.home>
	<alpine.LRH.2.02.1903070918110.6122@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1903070918110.6122@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: Petr Mladek <pmladek@suse.com>, Nigel Croxon <ncroxon@redhat.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, John Ogness <john.ogness@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, John Stoffel <john@stoffel.org>, Steven Rostedt <rostedt@goodmis.org>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, dm-devel@redhat.com, linux-serial@vger.kernel.org
List-Id: dm-devel.ids

On (03/07/19 09:26), Mikulas Patocka wrote:
> On Thu, 7 Mar 2019, John Stoffel wrote:
> 
> > The real problem is the disconnect between serial console speed and
> > capacity in bits/sec and that of the regular console.  Serial, esp at
> > 9600 baud is just a slow and limited resource which needs to be
> > handled differently than a graphical console.
> >
> > I'm also big on ratelimiting messages, even critical warning
> > messages.  Too much redundant info doesn't help anyone.  And what a
> > subsystem thinks is critical, may not be critical to the system as a
> > whole.
> 
> Perhaps a proper solution would be to drop excessive messages to serial 
> console unless Oops or BUG has happened?

Technically, we can have a per-console loglevel configuration. We have
several use cases for this already. Slower consoles will filter out more
messages and print only ERR/CRIT/ALERT/EMERG.

dm-integrity uses WARN level, which is below ERR; so it seems that
per-console loglevel can do the trick.

	-ss
