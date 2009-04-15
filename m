From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm table: verify each target is H/W sector aligned
Date: Wed, 15 Apr 2009 14:50:27 -0400
Message-ID: <20090415185026.GA8431@redhat.com>
References: <1239821170-8989-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1239821170-8989-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Apr 15 2009 at  2:46pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> Establish device limits prior to verifying a target is H/W sector
> aligned.
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> dm_set_device_limits() is now are now established prior to the call check_device_area()

The line after the 'Signed-off-by:' was mistakenly included.  Please
drop that line from this patch's commit message.

Mike
