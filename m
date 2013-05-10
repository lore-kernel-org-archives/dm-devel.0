From: Joe Thornber <thornber@redhat.com>
Subject: Re: [dm-devel] dm-cache not writing out cache metadata at reboot?
Date: Fri, 10 May 2013 11:05:21 +0100
Message-ID: <20130510100520.GD20880@debian>
References: <20130508214845.GA7729@blackbox.djwong.org>
 <20130508220526.GA24132@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130508220526.GA24132@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Wed, May 08, 2013 at 06:05:26PM -0400, Mike Snitzer wrote:
> I'll defer to Joe on this but I think sync_metadata() is pretty heavy to
> be doing every 'dmsetup info'.  BTW, with just dm_cache_commit() the
> superblock fields aren't stale; only the on-disk hints are.

Agreed, the hints are v. expensive to write.
