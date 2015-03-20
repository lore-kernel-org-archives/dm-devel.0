From: Zach Brown <zab@zabbo.net>
Subject: Re: [PATCH 1/3] dm: log writes target V2
Date: Fri, 20 Mar 2015 09:31:44 -0700
Message-ID: <20150320163144.GA16200@lenny.home.zabbo.net>
References: <20150319231655.GA6751@lenny.home.zabbo.net>
 <1426863037-5870-1-git-send-email-jbacik@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1426863037-5870-1-git-send-email-jbacik@fb.com>
Sender: fstests-owner@vger.kernel.org
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, fstests@vger.kernel.org, zab@redhat.com
List-Id: dm-devel.ids

On Fri, Mar 20, 2015 at 10:50:37AM -0400, Josef Bacik wrote:
> This creates a new target that is meant for file system developers to test file
> system integrity at particular points in the life of a file system.  We capture
> all write requests and the data and log the requests and the data to a separate
> device for later replay.  There is a userspace utility to do this replay.  The
> idea behind this is to give file system developers to verify that the file
> system is always consistent.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
> V1->V2: fixed up stuff based on Zachs review.

Cool,

Reviewed-by: Zach Brown <zab@zabbo.net>

- z
