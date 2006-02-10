From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] Support HDIO_GETGEO on device-mapper volumes
Date: Fri, 10 Feb 2006 15:13:09 +0000
Message-ID: <20060210151309.GB12173@agk.surrey.redhat.com>
References: <43EBEDD0.60608@us.ibm.com>
	<20060210145348.GA12173@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20060210145348.GA12173@agk.surrey.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Darrick J. Wong" <djwong@us.ibm.com>, dm-devel@redhat.com, Chris McDermott <lcm@us.ibm.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Fri, Feb 10, 2006 at 02:53:48PM +0000, Alasdair G Kergon wrote:
> I disagree - either dm should work out the *correct* geometry to
> return for those mappings where a geometry is known and it's sensible
> to return one (e.g. linear mapping to the start of certain scsi
> devices), or else it should leave it to userspace to decide how to
> handle the situation.  (And there's nothing currently stopping
> userspace seeing that a dm device is constructed out of a scsi device
> and choosing to use the geometry of that underlying device.)

s/scsi/hd/ in those examples for slightly more sense

What would the 'geometry' of a dm 'error' target mean?
Or of a snapshot?

In any patch, consider that we've already identified a need 
(e.g. for multipath) to add a framework to device-mapper to pass 
certain ioctls along to the underlying devices.  I'd prefer
to see that approach here: for tables with a single entry, pass 
the ioctl into the target. Linear and multipath would then pass 
it along to the underlying device; other targets would return zeros.
 
Alasdair
-- 
agk@redhat.com
