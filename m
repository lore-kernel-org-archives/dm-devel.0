From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: Re: [RFC] dm-writeboost: Porting daemon modulating
 migration from userland into the kernel
Date: Mon, 16 Sep 2013 20:49:03 +0900
Message-ID: <5236F02F.2040609@gmail.com>
References: <5236C737.7040306@gmail.com> <20130916092134.GA20647@debian>
	<5236D9BF.4010501@gmail.com> <20130916110647.GA23933@debian>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130916110647.GA23933@debian>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: gregkh@linuxfoundation.org
List-Id: dm-devel.ids

Joe,

> Is anyone using your new target other than you?  You've posted on
> dm-devel, you've posted on lkml, has anyone bothered to try it?
Unfortunately, the answer is NO.

Some Japanese kernel developers once tried to use it
but didn't reached operation eventually.

But, I am feeling dm-writeboost gathering attention from storage engineers.
That I can not get 3rd party users right now is not because dm-writeboost is trivial.
I believe the target is worth merging in the future.

For example, dm-writeboost is discussed in the Russian website below
http://www.opennet.ru/opennews/art.shtml?num=37864
AND
also in Phoronix
http://phoronix.com/forums/showthread.php?84073-A-New-Log-Structured-Linux-Caching-Software-Driver#post354983

My conclusion is
there are potential users and I think I can greet them as users trying dm-writeboost
if the target is staged.

This issue of porting the userland daemon to in-kernel
is for them to use software of my best efforts.
If the design issue is raised again after all, all I can do it to nothing but fix it.

My regret is that I should have fixed this issue before proposal to staging tree.
PythonDaemon module being unstable was already found before that
although I didn't consider the design is bad.

Akira
