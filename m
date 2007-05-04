From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: + kcopyd-use-mutex-instead-of-semaphore.patch added
	to -mm tree
Date: Thu, 3 May 2007 23:42:00 -0700
Message-ID: <20070503234200.e75eb71c.akpm@linux-foundation.org>
References: <200705040552.l445q3lu030085@shell0.pdx.osdl.net>
	<17978.53701.832765.808256@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <17978.53701.832765.808256@notabene.brown>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Neil Brown <neilb@suse.de>
Cc: dm-devel@redhat.com, matthias.kaehlcke@gmail.com
List-Id: dm-devel.ids

On Fri, 4 May 2007 16:25:09 +1000 Neil Brown <neilb@suse.de> wrote:

> Should be
>   Cc: dm-devel@redhat.com

drat.

> Maybe there should be a Cc: line in the top of each file??

I've thought about that sometimes.  I end up adding a lot of cc's.

I _could_ just do a reverse lookup on my patches directory and work out
who I cc'ed last time on that file.

A git-whatchanged|grep would be a more accurate way.  A bit spammy though.

I have it all in my head ;)
