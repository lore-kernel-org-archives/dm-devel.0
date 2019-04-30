From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 1/2] block: Fix a NULL pointer dereference in
 generic_make_request()
Date: Tue, 30 Apr 2019 15:55:25 -0700
Message-ID: <1556664925.161891.183.camel@acm.org>
References: <20190430223722.20845-1-gpiccoli@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190430223722.20845-1-gpiccoli@canonical.com>
Sender: stable-owner@vger.kernel.org
To: "Guilherme G. Piccoli" <gpiccoli@canonical.com>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org
Cc: dm-devel@redhat.com, axboe@kernel.dk, gavin.guo@canonical.com, jay.vosburgh@canonical.com, kernel@gpiccoli.net, stable@vger.kernel.org
List-Id: dm-devel.ids

On Tue, 2019-04-30 at 19:37 -0300, Guilherme G. Piccoli wrote:
+AD4 Commit 37f9579f4c31 (+ACI-blk-mq: Avoid that submitting a bio concurrently
+AD4 with device removal triggers a crash+ACI) introduced a NULL pointer
+AD4 dereference in generic+AF8-make+AF8-request(). The patch sets q to NULL and
+AD4 enter+AF8-succeeded to false+ADs right after, there's an 'if (enter+AF8-succeeded)'
+AD4 which is not taken, and then the 'else' will dereference q in
+AD4 blk+AF8-queue+AF8-dying(q).
+AD4 
+AD4 This patch just moves the 'q +AD0 NULL' to a point in which it won't trigger
+AD4 the oops, although the semantics of this NULLification remains untouched.
+AD4 
+AD4 A simple test case/reproducer is as follows:
+AD4 a) Build kernel v5.1-rc7 with CONFIG+AF8-BLK+AF8-CGROUP+AD0-n.
+AD4 
+AD4 b) Create a raid0 md array with 2 NVMe devices as members, and mount it
+AD4 with an ext4 filesystem.
+AD4 
+AD4 c) Run the following oneliner (supposing the raid0 is mounted in /mnt):
+AD4 (dd of+AD0-/mnt/tmp if+AD0-/dev/zero bs+AD0-1M count+AD0-999 +ACY)+ADs sleep 0.3+ADs
+AD4 echo 1 +AD4 /sys/block/nvme0n1/device/device/remove
+AD4 (whereas nvme0n1 is the 2nd array member)

Reviewed-by: Bart Van Assche +ADw-bvanassche+AEA-acm.org+AD4
