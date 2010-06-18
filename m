From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: 2.6.35 causes deadlock when snapshotting root lv
Date: Thu, 17 Jun 2010 21:29:21 -0400
Message-ID: <4C1ACBF1.3050603@cfl.rr.com>
References: <4C1A2839.5010407@cfl.rr.com> <20100617142731.GA10071@redhat.com> <4C1A4A74.9070105@cfl.rr.com> <20100617162747.GA21336@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100617162747.GA21336@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-fsdevel@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
List-Id: dm-devel.ids

On 06/17/2010 12:27 PM, Mike Snitzer wrote:
>>> http://git.kernel.org/linus/18e9e5104fcd9a9
>>> http://git.kernel.org/linus/6b0310fbf087ad6
>>
>> Yes, these do look suspicious.  I'll test reverting them tonight.
>
> OK, I'd suggest reverting the VFS change (18e9e5104fcd9a9) first.

Turns out it was 6b0310fbf087ad6 that did it.  CCing Eric Sandeen since 
he wrote it.  Eric, this patch seems to cause a deadlock when taking an 
lvm snapshot of the root lv.  Any idea why?
