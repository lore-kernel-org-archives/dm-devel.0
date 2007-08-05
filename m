From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: lvcreate on 2.6.22.1: kernel tried to execute
	NX-protected page
Date: Sun, 05 Aug 2007 12:46:03 -0700
Message-ID: <1186343163.25667.0.camel@laptopd505.fenrus.org>
References: <87y7gperd1.fsf@blackdown.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <87y7gperd1.fsf@blackdown.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Juergen Kreileder <jk@blackdown.de>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Sun, 2007-08-05 at 21:03 +0200, Juergen Kreileder wrote:
> I've upgraded devmapper to 1.02.20 and lvm2 to 2.02.26.  Didn't help much,
> I just got a the same BUG again:
> 
> kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
> BUG: unable to handle kernel paging request at virtual address f492c1f8


I suspect this is a module that got unloaded but still had some function
pointer registered somewhere.....

do you know if/which module that could be?
(one trick is to compile the kernel such that you don't allow modules to
be unloaded at all; if that makes it work it's clearly the type of bug I
described above)
