From: Joe Thornber <ejt@redhat.com>
Subject: Re: [PATCH] dm-kcopyd: monitor io activity
Date: Tue, 31 May 2011 10:09:01 +0100
Message-ID: <20110531090900.GA3164@ubuntu>
References: <Pine.LNX.4.64.1105301238460.26092@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1105301238460.26092@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, May 30, 2011 at 12:40:39PM -0400, Mikulas Patocka wrote:
> Here I'm sending three patches that limit kcopyd speed. There is global 
> limit for all kcopyds running in a system. The user can set percentage of 
> kcopyd speed in /sys/module/dm_mod/parameters/dm_kcopyd_throttle

Could you give some explanation of how to choose an appropriate value
for this please?  Should it be 100% unless there is an issue?  How
does the sys admin spot such issues?

Different kcopyd clients have different performance requirements, for
instance the initial sync of a new mirror leg may have less priority
than a copy-on-write exception for a snapshot.  This isn't something
we've addressed so far, but if you're starting to slow kcopyd down
(i.e. so the mirror sync doesn't saturate the system), then I think
you'll get some complaints from the snapshot users.

- joe
