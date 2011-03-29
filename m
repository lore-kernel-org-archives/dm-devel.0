From: Milan Broz <mbroz@redhat.com>
Subject: Re: dm table: Reject unconfigured device
Date: Tue, 29 Mar 2011 20:33:54 +0200
Message-ID: <4D922612.3040904@redhat.com>
References: <1301419172-10489-1-git-send-email-mbroz@redhat.com>
	<20110329182252.GA21671@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110329182252.GA21671@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, zkabelac@redhat.com
List-Id: dm-devel.ids

On 03/29/2011 08:22 PM, Mike Snitzer wrote:
> 
> Part of me was thinking it best to check this, and error out, as early
> as possible (e.g. in drivers/md/dm-table.c:open_dev()).  But I like the
> additional info that is naturally provided in device_area_is_invalid().

Another option is change loop device by assigning request
fn early (it will reject IO if unbounded, once configured it
has request fn defined forever).

But then you get lot of errors instead of crash on access, like
Buffer I/O error on device dm-0, logical block 0

So rejecting unconfigured device use this way seems to me
like better idea.
(If there is no request function, how DM can map it?)

Milan
