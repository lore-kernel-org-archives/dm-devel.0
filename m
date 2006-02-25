From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm missing bdput/thaw_bdev at removal
Date: Sat, 25 Feb 2006 01:17:48 +0000
Message-ID: <20060225011748.GT31641@agk.surrey.redhat.com>
References: <43FE4DB5.5050904@ce.jp.nec.com>
	<20060224163104.GP31641@agk.surrey.redhat.com>
	<f6118578c82e3de376ca44ac19fed545@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <f6118578c82e3de376ca44ac19fed545@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Feb 24, 2006 at 03:21:21PM -0600, Jon Brassow wrote:
> Would this explain the trouble I was having with mirroring and lock_fs?
 
Quite possibly - this one caused problems based on *previous*
actions which you wouldn't normally have thought to associate
with the problem being investigated.

Alasdair
-- 
agk@redhat.com
