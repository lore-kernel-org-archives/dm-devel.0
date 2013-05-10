From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH 1/2] dmcache: flush superblock stats when retrieving
 status info
Date: Fri, 10 May 2013 11:10:05 +0100
Message-ID: <20130510101005.GE20880@debian>
References: <20130508214845.GA7729@blackbox.djwong.org>
 <20130508220526.GA24132@redhat.com>
 <20130509203616.GA5713@blackbox.djwong.org>
 <20130509204437.GA5712@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130509204437.GA5712@blackbox.djwong.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Mike Snitzer <snitzer@redhat.com>, device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Thu, May 09, 2013 at 01:44:38PM -0700, Darrick J. Wong wrote:
> When userspace queries dmcache for stats info, we should ensure that all the
> metadata gets flushed out of memory to disk.  The current code neglects to
> update the disk copy of the hit/miss counters.

Nack, I'm afraid.  The commit is there purely to make sure the free
metadata blocks reported from the status are as high as possible.
[When a transaction is open we have to treat all blocks from the
previous transaction as allocated to allow rollback.]
