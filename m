From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] multipathd: fix inverted signal blocking
	logic
Date: Mon, 5 Mar 2018 16:27:20 +0000
Message-ID: <1520267239.2826.17.camel@wdc.com>
References: <20180302200048.GJ14513@octiron.msp.redhat.com>
	<20180302211807.11434-1-mwilck@suse.com>
	<1520026513.2855.30.camel@wdc.com>
	<1520028909.4169.87.camel@suse.com> <1520029421.2855.35.camel@wdc.com>
	<1520032608.4169.91.camel@suse.com> <1520033250.2855.47.camel@wdc.com>
	<1520037092.4169.103.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1520037092.4169.103.camel@suse.com>
Content-Language: en-US
Content-ID: <51307C2D10530F409D734D38B151995A@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>, "mwilck@suse.com" <mwilck@suse.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Sat, 2018-03-03 at 01:31 +0100, Martin Wilck wrote:
> So, there's no reason not to block them, right? Is it expected behavior
> that a user running 'kill -USR2 $(pidof multipathd)' terminates the
> process? Why do you think these signals should interrupt ppoll()
> although the uxlsnr can't can't handle them? Isn't it sufficient that
> they're handled by the threads that are meant to do that?

Blocking all signals except the ones for which we installed a handler sounds
weird to me. I think users expect daemons to process signals instead of
blocking all but a specific set of signals. This is a rather philosophical
argument and not an argument of which I think that it is strong enough to
prevent this patch of being integrated in the upstream multipath-tools
repository.

Bart.
