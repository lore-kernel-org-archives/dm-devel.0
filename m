From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 0/9] Nowait feature for stacked block devices
Date: Wed, 26 Jul 2017 18:57:57 -0500
Message-ID: <20170726235806.12148-1-rgoldwyn@suse.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-block@vger.kernel.org
Cc: hch@infradead.org, jack@suse.cz, linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

This is a continuation of the nowait support which was incorporated
a while back. We introduced REQ_NOWAIT which would return immediately
if the call would block at the block layer. Request based-devices
do not wait. However, bio based devices (the ones which exclusively
call make_request_fn) need to be trained to handle REQ_NOWAIT.

This effort covers the devices under MD and DM which would block
for any reason. If there should be more devices or situations
which need to be covered, please let me know.

-- 
Goldwyn

