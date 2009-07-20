From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] Allow zero paths for multipath priority groups
Date: Mon, 20 Jul 2009 21:37:53 +0100
Message-ID: <20090720203753.GG32330@agk-dp.fab.redhat.com>
References: <200907081415.39925.knikanth@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <200907081415.39925.knikanth@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Jul 08, 2009 at 02:15:39PM +0530, Nikanth Karthikesan wrote:
> From: Hannes Reinecke <hare@suse.de>
> Subject: Allow zero paths for multipath priority groups
> 
> For correct handling of the all-paths-down scenario we have to
> allow zero paths as a valid argument for priority groups.
 
That seems counter-intuitive.
Can you be more specific, with example scenarios?

Alasdair
