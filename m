From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: udev cookie on DM_DEVICE_RELOAD
Date: Mon, 29 Jun 2015 15:45:33 +0100
Message-ID: <20150629144533.GA14262@agk-dp.fab.redhat.com>
References: <55914C1C.6050309@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <55914C1C.6050309@suse.de>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Jun 29, 2015 at 03:46:04PM +0200, Hannes Reinecke wrote:
> So apparently you can only set the cookie for DM_DEVICE_RESUME,
> _not_ DM_DEVICE_RELOAD.
 
There are various alternative modes of operation to choose between.
It is essential to pick one and use it consistently alongside
the corresponding udev rules.  These sorts of problems arise when
switching between different modes, whether deliberately or otherwise.

> Which is odd, as DM_DEVICE_RELOAD is the only call I'll ever do;
> apparently it's being translated internally into a
> suspend/reload/resume cycle.
 
I didn't think that one got translated internally.

Please point to the actual source code that's causing the problems, 
and say which versions of the udev rules (and libdevmapper and kernel
driver) were installed when getting the errors.

Alasdair
