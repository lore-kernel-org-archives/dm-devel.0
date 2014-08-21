From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: convert dm_ulog_request data to little endian
Date: Thu, 21 Aug 2014 01:00:53 -0500
Message-ID: <E137CEE0-FDE6-4415-92B4-F9A21A8D4C1E@redhat.com>
References: <1407459365-697-1-git-send-email-dmzhang@suse.com>
	<20140811031556.GA27789@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140811031556.GA27789@redhat.com>
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
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Dongmao Zhang <dmzhang@suse.com>
List-Id: dm-devel.ids


On Aug 10, 2014, at 10:15 PM, Mike Snitzer wrote:

> 
> Other than this last hunk (extra whitespace) this patch looks fine to me.
> 
> Jon/Mikulas/Alasdair: could you review this too?  If you guys agree I'll
> get it staged for 3.17 (and mark it for stable).

please do not stage.  I think we will fix this in userspace.

 brassow
