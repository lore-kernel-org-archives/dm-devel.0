From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Question about dmevents
Date: Fri, 20 Jul 2007 17:22:09 +0100
Message-ID: <20070720162209.GZ459@agk.fab.redhat.com>
References: <D44F48C7D79D2943A073C8FA0F49A3CC0122629E@orsmsx418.amr.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <D44F48C7D79D2943A073C8FA0F49A3CC0122629E@orsmsx418.amr.corp.intel.com>
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

Obvious question - but first check your device actually has a uuid.
(Does 'dmsetup info' report it?)

Kernel-side, uuids are optional, but userspace applications are likely
to find it difficult to function reliably without them.

Alasdair
-- 
agk@redhat.com
