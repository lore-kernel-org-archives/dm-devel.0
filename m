From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: Re: [RFC] dm-writeboost: Porting daemon modulating
 migration from userland into the kernel
Date: Mon, 16 Sep 2013 19:13:19 +0900
Message-ID: <5236D9BF.4010501@gmail.com>
References: <5236C737.7040306@gmail.com> <20130916092134.GA20647@debian>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130916092134.GA20647@debian>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, gregkh@linuxfoundation.org
List-Id: dm-devel.ids

Joe,

> I'm a bit confused.  On the one hand you've asked for this to be
> included in linux-next, yet on the other you're still making big
> design changes.
I am sorry for confusing you.

But I believe it is not a big design change.
Porting the daemon to kernel remains most of the code unchanged. 
There are already two daemons in-kernel, flush_work and migrate_work,
and new daemon can be implemented just like them
and implementing daemon is usually loose-coupled.
If changing the design is absolutely prohibited after asking for staging,
I apologize it for all of you.

But if this issue is to discuss sooner or later, the time is now.
This is why I posted this issue at this point of time.

My plan is to fix this issue
and post v2 patch against the latest linux-next.
Also, planning to add more comments is included in my plan.
Few of my colleagues pointed out that my code needs more comments.

> When you first posted this code I said you'd need to get some people
> behind it who are using this successfully.  How far along this path
> are you?
Actually, no progress.
Asking for staging is for getting 3rd party users which is your request.
This is kind of a chicken and egg problem.
Without staging, I think I have no chance of those users and
staging tree exists for this purpose.

Akira
