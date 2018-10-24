From: Paul Lawrence <paullawrence@google.com>
Subject: Re: [RFC] dm-bow working prototype
Date: Wed, 24 Oct 2018 11:42:43 -0700
Message-ID: <296148c2-f2d9-5818-ea76-d71a0d6f5cd4@google.com>
References: <20181023212358.60292-1-paullawrence@google.com>
 <20181023221819.GB17552@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181023221819.GB17552@agk-dp.fab.redhat.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Jonathan Corbet <corbet@lwn.net>, Shaohua Li <shli@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, kernel-team@android.com
List-Id: dm-devel.ids

Android has had the concept of A/B updates for since Android N, which 
means that if an update is unable to boot for any reason three times, we 
revert to the older system. However, if the failure occurs after the new 
system has started modifying userdata, we will be attempting to start an 
older system with a newer userdata, which is an unsupported state. Thus 
to make A/B able to fully deliver on its promise of safe updates, we 
need to be able to revert userdata in the event of a failure.

For those cases where the file system on userdata supports 
snapshots/checkpoints, we should clearly use them. However, there are 
many Android devices using filesystems that do not support checkpoints, 
so we need a generic solution. Here we had two options. One was to use 
overlayfs to manage the changes, then on merge have a script that copies 
the files to the underlying fs. This was rejected on the grounds of 
compatibility concerns and managing the merge through reboots, though it 
is definitely a plausible strategy. The second was to work at the block 
layer.

At the block layer, dm-snap would have given us a ready-made solution, 
except that there is no sufficiently large spare partition on Android 
devices. But in general there is free space on userdata, just scattered 
over the device, and of course likely to get modified as soon as 
userdata is written to. We also decided that the merge phase was a high 
risk component of any design. Since the normal path is that the update 
succeeds, we anticipate merges happening 99% of the time, and we want to 
guarantee their success even in the event of unexpected failure during 
the merge. Thus we decided we preferred a strategy where the device is 
in the committed state at all times, and rollback requires work, to one 
where the device remains in the original state but the merge is complex.


On 10/23/2018 03:18 PM, Alasdair G Kergon wrote:
> On Tue, Oct 23, 2018 at 02:23:28PM -0700, Paul Lawrence wrote:
>> It is planned to use this driver to enable restoration of a failed
>> update attempt on Android devices using ext4.
> Could you say a bit more about the reason for this new dm target so we
> can understand better what parameters you are trying to optimise and
> within what new constraints?  What are the failure modes that you need
> to handle better by using this?  (We can guess some answers, but it
> would better if you can lay them out so we don't need to make
> assumptions.)
>
> Alasdair
>
