From: Andrew Morton <akpm@osdl.org>
Subject: Re: [Bugme-new] [Bug 7158] New: Out of memory happen in
	snapshot
Date: Wed, 13 Sep 2006 22:36:38 -0700
Message-ID: <20060913223638.fcb73078.akpm@osdl.org>
References: <20060913205249.1aa784d9.akpm@osdl.org>
	<200609140525.k8E5Pg4L026098@mail.thecus.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200609140525.k8E5Pg4L026098@mail.thecus.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: kevin Cheng <kevin_cheng@thecus.com>
Cc: dm-devel@redhat.com, agk@redhat.com, "'bugme-daemon@kernel-bugs.osdl.org'" <bugme-daemon@bugzilla.kernel.org>
List-Id: dm-devel.ids

On Thu, 14 Sep 2006 13:25:52 +0800
"kevin Cheng" <kevin_cheng@thecus.com> wrote:

> Dear Andrew:
>    Thanks for your message and help. 
> 
> Attech file is the slabinfo from my machine. Thanks!!
> 

OK, thanks.  A number of DM-related slab caches have really high object
counts.  So there's a good chance that this is either a mistuning/imbalance
issue in DM or an outright leak.

I'd ask the DM developers to take over here please.
