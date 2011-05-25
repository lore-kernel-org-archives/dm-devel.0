From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] DM RAID: do not print rebuilds in table	line
Date: Wed, 25 May 2011 15:05:26 +0100
Message-ID: <20110525140526.GA872@agk-dp.fab.redhat.com>
References: <201105231954.p4NJspjN019139@f14.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <201105231954.p4NJspjN019139@f14.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, May 23, 2011 at 02:54:51PM -0500, Jon Brassow wrote:
> DM RAID table status should not include rebuild parameters.

Please could you give an example of a sequence of actual 'dmsetup table' +
'dmsetup status' lines after this change?  (Including reloads during and after
rebuild.)

Please update the documentation file too to mention the asymmetry, if some 
parameter is now input-only.

+ Performing a 'dmsetup table' should display the CTR table used to
+ construct the mapping (with possible reordering of optional
+ parameters).

BTW LVM2 is likely to rely on the order being preserved i.e. it must supply
them to the kernel in the order it is known to print them.  (Remember that the
'table' line gets compared as an unparsed string in userspace.)  Also update it
to say what it does rather than what it 'should' do:)

(We'll increment the API version too of course in the patch.)

Thanks,
Alasdair
