From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Barrier support in device mapper
Date: Thu, 18 Sep 2008 20:53:25 +0200
Message-ID: <20080918185325.GR25711@one.firstfloor.org>
References: <200809181127.37704.knikanth@suse.de> <48D1FBBE.4080305@redhat.com>
	<20080918134412.GK25711@one.firstfloor.org>
	<48D27D17.6040207@redhat.com>
	<20080918181311.GN25711@one.firstfloor.org>
	<48D29F49.1050003@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <48D29F49.1050003@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <mbroz@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Andi Kleen <andi@firstfloor.org>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

> > Are they equivalent in the single disk case to my patch?
> It transforms barrier to normal bio with following zero-size barrier bio.
> For the one disk case effect is the same of course.

Ok fine assuming they work. Will they be ready for the 2.6.28 merge window?

If not I would still prefer my patch for .28

-Andi
