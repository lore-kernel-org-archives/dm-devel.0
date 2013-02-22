From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/2] dm: Avoid use-after-free of a mapped device
Date: Fri, 22 Feb 2013 11:45:03 +0100
Message-ID: <51274C2F.6070500@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, Alasdair G Kergon <agk@redhat.com>, Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>, Tejun Heo <tj@kernel.org>, James Bottomley <JBottomley@parallels.com>
List-Id: dm-devel.ids

This mini-series of two patches avoids that the device mapper
implementation triggers a use-after-free during removal of a
mapped device. The two patches in this series are:
- block: Avoid invoking blk_run_queue() recursively
- dm: Avoid use-after-free of a mapped device
