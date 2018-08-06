From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 17/32] libmultipath: fix tur checker double
	locking
Date: Mon, 6 Aug 2018 17:55:05 -0500
Message-ID: <20180806225505.GW31378@octiron.msp.redhat.com>
References: <1533157038-3924-1-git-send-email-bmarzins@redhat.com>
	<1533157038-3924-18-git-send-email-bmarzins@redhat.com>
	<a275a1d52e54d8f4ded3561d71d63784ddaeb4b8.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <a275a1d52e54d8f4ded3561d71d63784ddaeb4b8.camel@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "mwilck@suse.com" <mwilck@suse.com>
List-Id: dm-devel.ids

On Sun, Aug 05, 2018 at 03:40:30PM +0000, Bart Van Assche wrote:
> On Wed, 2018-08-01 at 15:57 -0500, Benjamin Marzinski wrote:
> > I realize that this locking was added to make an analyzer happy,
> > presumably because sometimes ct->devt was being accessed while ct->devt
> > was held, and sometimes not.  The tur checker locking will be cleaned
> > up in a later patch to deal with this.
> 
> Are you perhaps referring to commit 873be9fef222 ("libmultipath/checkers/tur:
> Serialize tur_checker_context.devt accesses")? Your assumption about how DRD
> works is wrong. DRD doesn't care about which mutex or other synchronization
> primitives are used to serialize accesses to data that is shared between
> threads. All it cares about is that concurrent accesses to shared data are
> serialized. I'm afraid that your patch reintroduces the race conditions that
> were fixed by commit 873be9fef222. Have you considered to fix this without
> removing the locking?

I'm confused here. If the data is only read by multiple threads, I don't
see why we need to synchronize it. Unless I'm missing something, my
patch does make sure that the only time ct->devt is written is when
there is only one thread running that has access to ct.

-       if (fstat(c->fd, &sb) == 0) {
...
+       if (uatomic_read(&ct->holders) == 1 && ct->devt[0] == 0 &&
+           fstat(c->fd, &sb) == 0) {

holders will always be 2 when a tur checker thread is running (well, the
thread will decrement it when it finishes, but it will not touch ct
after that action). Since only the thread calling libcheck_init can
start the tur checker thread using this context, if there is no thread
running at the start of libcheck_check(), then no thread can be started
until libcheck_check() starts it.

Ideally, ct->devt would be set in libcheck_init(), but we don't have the
information there, so setting it once, on the first time we call
libcheck_check() seems like a reasonable, and safe, answer.  I certainly
prefer it to adding recusive locking where it isn't needed.

-Ben

> 
> Bart.
