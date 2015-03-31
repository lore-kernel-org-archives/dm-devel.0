From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [RFC] [PATCH 0/7] fs:  add blkdev name format specifier
Date: Tue, 31 Mar 2015 10:43:07 -0600
Message-ID: <551ACE9B.5050608@kernel.dk>
References: <1427817681-4494-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1427817681-4494-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>, linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, dm-devel@redhat.com
List-Id: dm-devel.ids

On 03/31/2015 10:01 AM, Dmitry Monakhov wrote:
> Currently in order to print block_device name one should  use blkdev() helper
> which requires temproral buffer of size BDEVNAME_SIZE (32bytes). This is very
> ineffective because result in stack usage bloating for deep IO call traces where
> stack usage is close to maximum values.
>
> It is reasonable to introduce dedicated format specifier for block_device name,
> unfortunately "%pb", "%pB", "%pd" and "%pD" are already reserved for other data types
> I've pick "%pg" ala geometry. If some one want to offer sane spacifier name
> please let me know.
>
> Since this is RFC version I've pick rough patch split policy (based on subsystem).
> Please let me know if patchset should be split in different way.

I think this is looks good, nice improvement. I can take the lib and 
block parts, Al can pick up the fs bits.

-- 
Jens Axboe
