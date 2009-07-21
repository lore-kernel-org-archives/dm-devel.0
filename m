From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] Allow zero paths for multipath priority groups
Date: Tue, 21 Jul 2009 15:55:58 +0100
Message-ID: <20090721145558.GI32330@agk-dp.fab.redhat.com>
References: <200907081415.39925.knikanth@suse.de>
	<20090720203753.GG32330@agk-dp.fab.redhat.com>
	<4A65D4E3.9050405@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4A65D4E3.9050405@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: Nikanth Karthikesan <knikanth@suse.de>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Then effectively the multipath target with no paths turns into a pure
queueing target.  I'll have a think about the options, but that's probably
quite a reasonable idea.

Alasdair
