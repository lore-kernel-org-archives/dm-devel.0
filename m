From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Device removal handling
Date: Tue, 12 Jul 2011 11:58:26 +0100
Message-ID: <20110712105826.GH7857@agk-dp.fab.redhat.com>
References: <4E1A079A.9060901@cfl.rr.com>
	<20110710220330.GA7857@agk-dp.fab.redhat.com>
	<4E1B11D5.8050603@cfl.rr.com> <4E1BE8AC.3090503@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4E1BE8AC.3090503@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, Phillip Susi <psusi@cfl.rr.com>
List-Id: dm-devel.ids

On Tue, Jul 12, 2011 at 08:24:44AM +0200, Hannes Reinecke wrote:
> What I would like to see is this logic being pushed into
> eg dmsetup, so that one call to dmsetup would be sufficient to achieve 
> this. And without heavy parsing of arguments etc.
> Something like 'dmraid replace error' would be cool.

We already have dmsetup remove -f which replaced a device by the error
target then attempts to remove it (which will fail if it is still in
use).

You have a need for this without the removal attempt?

Alasdair
