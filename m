From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: LVM2 plus device-mapper-multipath filter question
Date: Wed, 26 Oct 2005 21:58:13 +0100
Message-ID: <20051026205813.GA11086@agk.surrey.redhat.com>
References: <013350FE9CC8AC4EB602045723F47222B9A2CA@xmb-rtp-215.amer.cisco.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <013350FE9CC8AC4EB602045723F47222B9A2CA@xmb-rtp-215.amer.cisco.com>
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

On Wed, Oct 26, 2005 at 03:45:17PM -0400, Phil Lowden (plowden) wrote:
>   types = [ "device-mapper", 16 ]

BTW That should be 1, not 16.
The next release will that line built in.
 
>   /dev/dm-0  vgtest2 lvm2 a-      4.00G   3.90G

Hmm. The ugly internal kernel kobject names appear courtesy of udev.  
Yuck. Don't use them for anything. They aren't meant to be there.

You can probably add some incantation to /etc/udev/rules.d/ to get
rid of them.


The algorithm LVM2 uses to choose the "nicest" display name for each 
device compares each new name it encounters with the current 
name and decides whether the new name is "nicer".
Unfortunately the final choice depends on the sequence in which the
names are encountered. This needs fixing.


Alasdair
-- 
agk@redhat.com
