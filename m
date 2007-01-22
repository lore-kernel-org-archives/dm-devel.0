From: Christophe Saout <christophe@saout.de>
Subject: Re: Data corruption with raid5/dm-crypt/lvm/reiserfs on
	2.6.19.2
Date: Mon, 22 Jan 2007 22:42:21 +0100
Message-ID: <1169502141.17211.7.camel@leto.intern.saout.de>
References: <d00698fb0701181211l480966e5o6f10db9300d4c8aa@mail.gmail.com>
	<20070122115652.1f7862e1.akpm@osdl.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070122115652.1f7862e1.akpm@osdl.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Morton <akpm@osdl.org>
Cc: dm-devel@redhat.com, noah <noah123@gmail.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Am Montag, den 22.01.2007, 11:56 -0800 schrieb Andrew Morton:

> There has been a long history of similar problems when raid and dm-crypt
> are used together.  I thought a couple of months ago that we were hot on
> the trail of a fix, but I don't think we ever got there.  Perhaps
> Christophe can comment?

No, I think it's exactly this bug. Three month ago someone came up with
a very reliable test case and I managed to nail down the bug.

Readaheads that were aborted by the raid5 code (or some layer below)
were signalled using a cleared BIO_UPTODATE bit, but no error code, and
were missed as aborted by dm-crypt (all other layers apparently set the
error code in this case, so this only happened with raid5) which could
mess up the buffer cache.

Anyway, it then turned out this bug was already "accidentally" fixed in
2.6.19 by RedHat in order to play nicely with make_request changes (the
stuff to reduce stack usage with stacked block device layers), that's
why you probably missed that it got fixed. The fix for pre-2.6.19
kernels went into some 2.6.16.x and 2.6.18.6.
