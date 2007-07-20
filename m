From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: multipath-tool udev rules require missing dmsetup
	features
Date: Fri, 20 Jul 2007 17:46:35 +0100
Message-ID: <20070720164635.GB459@agk.fab.redhat.com>
References: <469EB881.6070207@csupomona.edu>
	<20070719061622.GB21899@pentland.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20070719061622.GB21899@pentland.suse.de>
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

On Thu, Jul 19, 2007 at 08:16:22AM +0200, Hannes Reinecke wrote:
> As already said, it totally makes sense when you hack up dmsetup and then forget
> about the patch. Sorry about this.
> Alasdair, care to incorporate it?

Kay mentioned this patch to me at OLS.

My answer was that I want to see a generic implementation within the reporting
code.  In other words a new command line flag would instruct the reporting code
to produce its output in this sort of format.  The output needs to be useful
when reporting on multiple objects at once, so to guarantee unique output
lines, you might want to include fields acting as a unique key inside the
variable names, which can be all-caps versions of the existing reporting field
names.
 
Alasdair
-- 
agk@redhat.com
