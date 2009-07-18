From: Andi Kleen <andi@firstfloor.org>
Subject: Re: How to handle >16TB devices on 32 bit hosts ??
Date: Sat, 18 Jul 2009 08:09:33 +0200
Message-ID: <8763dqwmhu.fsf@basil.nowhere.org>
References: <19041.4714.686158.130252@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <19041.4714.686158.130252@notabene.brown> (Neil Brown's message
	of "Sat, 18 Jul 2009 10:08:10 +1000")
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Neil Brown <neilb@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Neil Brown <neilb@suse.de> writes:
>
>  With 2TB drives easily available, more people will probably try
>  building arrays this big and we cannot just assume they will only do
>  it on 64bit hosts.

They should -- no 32bit fsck has any chance running on a 16TB volume.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
