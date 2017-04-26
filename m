From: Christoph Hellwig <hch@lst.de>
Subject: small dm mpath cleanups
Date: Wed, 26 Apr 2017 09:40:35 +0200
Message-ID: <20170426074039.14602-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: snitzer@redhat.com
Cc: dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

Hi Mike,

this series has some prep patches for my work to have proper, type
checked block errors codes.  One fallout of that is that we need to
get rid of how dm overloads a few return values with either internal
positive error codes or negative errno values.  This patches does
that, which happens to clean things up a bit, and also allows us
dm to propagate the actual error code in one case where it currently
is dropped on the floor.
