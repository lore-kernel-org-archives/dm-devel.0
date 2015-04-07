From: Josef Bacik <jbacik@fb.com>
Subject: Re: [dm-devel] [PATCH 1/3] dm: log writes target
Date: Tue, 7 Apr 2015 10:45:52 -0400
Message-ID: <5523EDA0.9080504@fb.com>
References: <1426797070-27463-1-git-send-email-jbacik@fb.com> <1426797070-27463-2-git-send-email-jbacik@fb.com> <20150323180245.GE3172@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20150323180245.GE3172@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, zab@redhat.com, fstests@vger.kernel.org
List-Id: dm-devel.ids

On 03/23/2015 02:02 PM, Vivek Goyal wrote:
> On Thu, Mar 19, 2015 at 04:31:08PM -0400, Josef Bacik wrote:
>
> [..]
>> + * We log writes only after they have been flushed, this makes the log describe
>> + * close to the order in which the data hits the actual disk, not its cache.  So
>> + * for example the following sequence (W means write, C means complete)
>> + *
>> + * Wa,Wb,Wc,Cc,Ca,FLUSH,FUAd,Cb,CFLUSH,CFUAd
>> + *
>> + * Would result in the log looking like this
>> + *
>> + * c,a,flush,fuad,b,<other writes>,<next flush>
>> + *
>
> A minor nit, Should this sequence be following.
>
> c,a,b, flush,fuad,<other writes>,<next flush>
>
> when flush completed by that time write of b has completed too. So it
> should be written first?
>

So we want to catch file systems behaving badly by not waiting for the 
IO they care about to complete before issuing their flush, so we take 
the super pessimistic view that only IO that has completed by FLUSH 
issue time can truly be safe.  For all we know the flush could have 
happened first and we just happen to get the endio called for b first 
instead of the flush, so to make it mostly likely that we catch fs bugs 
we enforce this idea that only completed IO can be sure to have been 
flushed at flush submit time.  Thanks,

Josef

