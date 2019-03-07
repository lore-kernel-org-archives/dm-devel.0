From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Serial console is causing system lock-up
Date: Thu, 7 Mar 2019 08:12:22 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1903070811450.26819@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1903060917280.5335@file01.intranet.prod.int.rdu2.redhat.com>
	<20190306152218.eocv4zulf7tv2mkc@pathway.suse.cz>
	<alpine.LRH.2.02.1903061031420.16905@file01.intranet.prod.int.rdu2.redhat.com>
	<20190307015652.GA4893@jagdpanzerIV>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190307015652.GA4893@jagdpanzerIV>
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
Cc: Petr Mladek <pmladek@suse.com>, Nigel Croxon <ncroxon@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Steven Rostedt <rostedt@goodmis.org>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, dm-devel@redhat.com, linux-serial@vger.kernel.org
List-Id: dm-devel.ids



On Thu, 7 Mar 2019, Sergey Senozhatsky wrote:

> On (03/06/19 11:07), Mikulas Patocka wrote:
> > This bug only happens if we select large logbuffer (millions of 
> > characters). With smaller log buffer, there are messages "** X printk 
> > messages dropped", but there's no lockup.
> > 
> > The kernel apparently puts 2 million characters into a console log buffer, 
> > then takes some lock and than tries to write all of them to a slow serial 
> > line.
> 
> Do you run a preemtible kernel?
> 
> 	-ss

The kernel has voluntary preemption.

Mikulas
