From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: dm: pass up rotational flag
Date: Thu, 26 May 2011 22:42:46 -0400
Message-ID: <1306464169-4291-1-git-send-email-martin.petersen@oracle.com>
References: <4DDEA689.2090004@fusionio.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4DDEA689.2090004@fusionio.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jaxboe@fusionio.com
Cc: snitzer@redhat.com, msb@chromium.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Here's a tentative patch set for transitioning the non_rotational,
discard and secure discard queue flags to the topology information.

The first patch introduces a new function for setting the default limits
for stacking drivers like we discussed a few weeks ago.  Wrt. to naming
I felt it was best to have a function that said "stacking".  That's why
I introduced a new call instead of using blk_set_default_limits() even
though that function was originally motivated by device mapper.

The last two patches deal with non-rotational and the discard flags
respectively.

Let me know what you guys think...

-- 
Martin K. Petersen	Oracle Linux Engineering
