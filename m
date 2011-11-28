From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [PATCH] DM RAID: Clean-up handling of 'rebuild'
	device requests
Date: Mon, 28 Nov 2011 14:18:56 -0600
Message-ID: <66922A4B-375C-4E1C-85E0-0A642DD8F3E9@redhat.com>
References: <1322510465.20158.2.camel@f14.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1322510465.20158.2.camel@f14.redhat.com>
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
List-Id: dm-devel.ids


On Nov 28, 2011, at 2:01 PM, Jonathan Brassow wrote:

> dm-raid: Change the way the 'rebuild' parameter is processed.
> 	rdev_for_each(r, t, mddev) {
> -		if (!test_bit(In_sync, &r->flags)) {
> -			if (!test_bit(FirstUse, &r->flags))
> -				DMERR("Superblock area of "
> -				      "rebuild device %d should have been "
> -				      "cleared.", r->raid_disk);
> -			set_bit(FirstUse, &r->flags);
> +		if (!test_bit(In_sync, &r->flags))

Missing '{' - will resend.

 brassow
