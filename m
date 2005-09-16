From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: lvm - No matching physical volumes found
Date: Fri, 16 Sep 2005 15:40:07 +0100
Message-ID: <20050916144007.GD18976@agk.surrey.redhat.com>
References: <20050916142211.GA10521@locust.cns.vt.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050916142211.GA10521@locust.cns.vt.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Sep 16, 2005 at 10:22:11AM -0400, Ray Stell wrote:
> Can you tell what's going wrong here.  TIA: 
 
1) Run 'pvs -a' and see if the devices appear in the output.
If they don't, run 'vgscan -vvvv' and look for the reason
given for ignorning them.
If they do appear in the output, run pvcreate, vgcreate, lvcreate
etc. to create new LVs using them.

Alasdair
-- 
agk@redhat.com
