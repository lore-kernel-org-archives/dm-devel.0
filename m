From: DagB <dag@bakke.com>
Subject: Re: raid0 and discard/trim - current state?
Date: Sat, 09 Oct 2010 20:34:33 +0200
Message-ID: <4CB0B5B9.8070409@bakke.com>
References: <4CB0A4B5.4010009@bakke.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <4CB0A4B5.4010009@bakke.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-lvm@redhat.com, linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On 10/09/2010 07:21 PM, DagB wrote:
> Hi.
> 
> I wonder about the current state of affairs regarding striping over
> multiple SSDs.
> 
> Found this thread:
> http://marc.info/?t=126787186000002&r=1&w=2
> 
> but nothing after that. Was this problem to hard to handle?
> 

Bad form to reply to self.

More googling finally turned up this commit:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=8357422d4bf33bc2c35884d4016c3fc9efbbc1d2


So I'll be ordering 2 SSDs.


Dag B
