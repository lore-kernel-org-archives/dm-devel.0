From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 17/32] libmultipath: fix tur checker double
	locking
Date: Tue, 7 Aug 2018 21:45:05 +0000
Message-ID: <4ebb172b419b154319c076795cb4058bcdde0a6f.camel@wdc.com>
References: <1533157038-3924-1-git-send-email-bmarzins@redhat.com>
	<1533157038-3924-18-git-send-email-bmarzins@redhat.com>
	<a275a1d52e54d8f4ded3561d71d63784ddaeb4b8.camel@wdc.com>
	<20180806225505.GW31378@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180806225505.GW31378@octiron.msp.redhat.com>
Content-Language: en-US
Content-ID: <B413721AB849FD4B9A39AEF0FBF4153A@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "mwilck@suse.com" <mwilck@suse.com>
List-Id: dm-devel.ids

On Mon, 2018-08-06 at 17:55 -0500, Benjamin Marzinski wrote:
> I'm confused here. If the data is only read by multiple threads, I don't
> see why we need to synchronize it. Unless I'm missing something, my
> patch does make sure that the only time ct->devt is written is when
> there is only one thread running that has access to ct.
> 
> -       if (fstat(c->fd, &sb) == 0) {
> ...
> +       if (uatomic_read(&ct->holders) == 1 && ct->devt[0] == 0 &&
> +           fstat(c->fd, &sb) == 0) {
> 
> holders will always be 2 when a tur checker thread is running (well, the
> thread will decrement it when it finishes, but it will not touch ct
> after that action). Since only the thread calling libcheck_init can
> start the tur checker thread using this context, if there is no thread
> running at the start of libcheck_check(), then no thread can be started
> until libcheck_check() starts it.
> 
> Ideally, ct->devt would be set in libcheck_init(), but we don't have the
> information there, so setting it once, on the first time we call
> libcheck_check() seems like a reasonable, and safe, answer.  I certainly
> prefer it to adding recusive locking where it isn't needed.

Replacing a locking scheme into an approach based on atomic variables is
something I don't like because it makes the code harder to analyze for
correctness. Have you considered to keep the locking and fix the bug that
you described in the commit message?

Thanks,

Bart.
