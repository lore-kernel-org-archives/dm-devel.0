From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: dm snapshot: implement .iterate_devices
Date: Wed, 26 Aug 2009 20:32:02 +0100
Message-ID: <20090826193202.GI643@agk-dp.fab.redhat.com>
References: <1251007867-13004-1-git-send-email-snitzer@redhat.com>
	<20090826145045.GH643@agk-dp.fab.redhat.com>
	<20090826181908.GB26018@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090826181908.GB26018@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Wed, Aug 26, 2009 at 02:19:08PM -0400, Mike Snitzer wrote:
> I'll work on a proper solution for snapshot_iterate_devices() and get
> that to you ASAP.
 
So let's push this patch as-is for 2.6.31 as it clearly fixes one problem,
and determine the right way of handling the characteristics of the 'cow'
device in a supplementary patch.

Alasdair
