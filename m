From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: Question about dm target size
Date: Wed, 12 Nov 2014 12:28:03 +0000
Message-ID: <20141112122803.GB31997@localhost.localdomain>
References: <5462ABD8.1050609@fb.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <5462ABD8.1050609@fb.com>
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
Cc: snitzer@redhat.com
List-Id: dm-devel.ids

On Tue, Nov 11, 2014 at 07:37:44PM -0500, Josef Bacik wrote:
> Hello,
> 
> I'm creating a dm target to better test power fail situations and I'm having
> trouble figuring out how to make the dm device appear as a different size.
> So for example you do the normal dm table
> 
> offset size power-fail /dev/whatever args

Just make the size argument in your table be equal to dev_size / 2. This is
where ti->len comes from and it's the correct way to tell device-mapper how
big your mapped device should be.

Your ctr can then parse out /dev/whatever from its args, open it and do
whatever it likes with it. Access to that device by your target code is in
no way constrained by the offset/size params used in the table.

E.g.:

# dmsetup create pf0 --table="0 2048 power-fail /dev/whatever foo bar"

Would create a 1M device named pf0. The power-fail target could still access
the whole of /dev/whatever if it wants to.

within the 
Regards,
Bryn.
