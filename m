From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: 2.6.35 causes deadlock when snapshotting root lv
Date: Fri, 18 Jun 2010 14:19:44 -0500
Message-ID: <4C1BC6D0.2030203@sandeen.net>
References: <4C1A2839.5010407@cfl.rr.com> <20100617142731.GA10071@redhat.com> <4C1A4A74.9070105@cfl.rr.com> <20100617162747.GA21336@redhat.com> <4C1ACBF1.3050603@cfl.rr.com> <4C1BC125.4090902@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4C1BC125.4090902@sandeen.net>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Mike Snitzer <snitzer@redhat.com>, device-mapper development <dm-devel@redhat.com>, linux-fsdevel@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
List-Id: dm-devel.ids

Eric Sandeen wrote:
> Phillip Susi wrote:
>> On 06/17/2010 12:27 PM, Mike Snitzer wrote:
>>>>> http://git.kernel.org/linus/18e9e5104fcd9a9
>>>>> http://git.kernel.org/linus/6b0310fbf087ad6
>>>> Yes, these do look suspicious.  I'll test reverting them tonight.
>>> OK, I'd suggest reverting the VFS change (18e9e5104fcd9a9) first.
>> Turns out it was 6b0310fbf087ad6 that did it.  CCing Eric Sandeen since
>> he wrote it.  Eric, this patch seems to cause a deadlock when taking an
>> lvm snapshot of the root lv.  Any idea why?
> 
> I'll look.  A sysrq-w when it hangs up would probably be enlightening...
> 
> -Eric

FWIW simple freeze/unfreeze works for me, and lvm snap on a non-root ext4
partition seems to as well.  I'm out for a few days and probably won't
get a root lv set up to test anytime soon.  If you can provide sysrq-w
output that probably will be a big help if it doesn't end up being obvious
by inspection.  :)

Thanks
-Eric
