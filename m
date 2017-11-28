From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] dm-log-writes: invalidate the bdev's for both of our devices
Date: Tue, 28 Nov 2017 21:29:01 +0200
Message-ID: <CAOQ4uxi2fqO4-gQVtRmQ6QP0VqXFVMpbYSdh-mrKuivWiOwECQ@mail.gmail.com>
References: <1511890225-16601-1-git-send-email-josef@toxicpanda.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1511890225-16601-1-git-send-email-josef@toxicpanda.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Josef Bacik <josef@toxicpanda.com>
Cc: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Josef Bacik <jbacik@fb.com>
List-Id: dm-devel.ids

On Tue, Nov 28, 2017 at 7:30 PM, Josef Bacik <josef@toxicpanda.com> wrote:
> From: Josef Bacik <jbacik@fb.com>
>
> Amir noticed that sometimes the xfstests using dm-log-writes would fail
> randomly but would work fine after trying again manually.  This is
> because dm-log-writes writes directly to the device, but the log replay
> tools read and write via the block device page cache.  Sometimes this
> resulted in stale data being in the block device's page cache which
> would result in random failures.  To handle this simply invalidate the
> block device page cache on destruction so any replay of the log device
> that follows will be forced to read the new real contents.
>
> Reported-and-tested-by: Amir Goldstein <amir73il@gmail.com>

I'm fine with the Reported-by, but let's wait a while with this patch so
I have more time to torture it.
The incidents I got even before the patch did not happen more than
a handful of times after running for a few days, so I need some more
days to validate the fix.
I had already sent you some weird output. Let's see what else comes
along.

Thanks,
Amir.
