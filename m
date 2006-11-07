From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2.6.19 5/5] fs: freeze_bdev with semaphore
	not mutex
Date: Wed, 8 Nov 2006 00:39:38 +0100
Message-ID: <20061107233938.GA2498@elte.hu>
References: <20061107183459.GG6993@agk.surrey.redhat.com>
	<20061107122837.54828e24.akpm@osdl.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20061107122837.54828e24.akpm@osdl.org>
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
Cc: Srinivasa DS <srinivasa@in.ibm.com>, dm-devel@redhat.com, Eric Sandeen <sandeen@sandeen.net>, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids


* Andrew Morton <akpm@osdl.org> wrote:

> If so, it's a bit sad to switch to semaphore just because of some 
> errant debugging code.  Perhaps it would be better to create a new 
> mutex_unlock_stfu() which suppresses the warning?

the code was not using semaphores as a pure mutex thing. For example 
unlocking by non-owner is not legal. AFAICS the code returns to 
userspace with a held in-kernel mutex. That makes it hard for the kernel 
to determine for example whether the lock has been 'forgotten', or kept 
like that intentionally. Alasdair, what is the motivation for doing it 
like that?

	Ingo
