From: Bob Bell <Bell_Robert@emc.com>
Subject: Re: dmsetup load not working?
Date: Sat, 8 Dec 2007 13:07:15 -0500
Message-ID: <20071208180713.GA6071@newbie.thebellsplace.net>
References: <20071208162439.GA3964@newbie.thebellsplace.net>
	<475ADA37.6060108@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <475ADA37.6060108@redhat.com>
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

On Sat, Dec 08, 2007 at 06:53:59PM +0100, Milan Broz wrote:
> There can be two tables for DM device, active and inactive.
> 
> Active (live) table is used for operation, inactive is used
> in preparation for table change.
> 
> "Inactive" table is activated during device resume (if you need to
> change table, suspend device and resume device is needed to switch
> inactive table to live state).

I missed that these were two separate slots, and that resume was the
trigger to use the inactive table.  It makes a lot of sense now.  That's
for taking the time to explain it.  I should be all set now.

-- 
Bob Bell
