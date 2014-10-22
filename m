From: Akira Hayakawa <hayakawa@valinux.co.jp>
Subject: Re: ios and sectors should be incremented on completion
Date: Wed, 22 Oct 2014 10:55:41 +0900
Message-ID: <20141022105541.df52d34a8b1113c2a49e3929@valinux.co.jp>
References: <20140926181236.177920a7a88d25a2d7189093@valinux.co.jp>
	<542BBA9C.7010808@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <542BBA9C.7010808@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Junichi Nomura <j-nomura@ce.jp.nec.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Thanks for information Junichi,

> Do you have a problem with the current behavior other than the document?
No. I and my colleagues just wondered why.

> AFAIR, dm increments ios/sectors at submission because md did.
> And other bio-based drivers such as drbd and nvme seem to have followed
> the precedence.
> 
> While md has a reason to do so (some md personalities just remaps bios
> and doesn't track completion), dm should be able to collect stat
> in dec_pending as it always clones.
Very interesting historical background.
Maybe bache, too.

> So, I think it's ok to move ios/sectors counting to end_io_acct().
> It might make tools like iostat happier.
> You might want to fix other bio-based drivers as well.
I want to hear comments from DM maintainers on this issue.

- Akira
