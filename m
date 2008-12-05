From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: dm targets with spaces in the name
Date: Fri, 5 Dec 2008 17:08:49 +0000
Message-ID: <20081205170849.GC26097@agk.fab.redhat.com>
References: <4936BBC6.7000800@cfl.rr.com> <1228405956.23557.74.camel@o>
	<49383A77.80903@cfl.rr.com>
	<20081205015938.GQ26097@agk.fab.redhat.com>
	<49395DB6.6050802@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <49395DB6.6050802@cfl.rr.com>
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

On Fri, Dec 05, 2008 at 11:58:30AM -0500, Phillip Susi wrote:
> Alasdair G Kergon wrote:
> >I can't guarantee that names with spaces in them have had much testing
> >as LVM doesn't permit them.  But device-mapper itself and dmsetup
> >are supposed to support them.
> But if you run dmsetup and key in a table referencing a device with a 
> space in the name, that is what happens; linear_ctr gets passed 
> "/dev/foo bar" as the path argv.
 
which is a bug as per what I stated above, if true.

dmsetup knows nothing about the format of the table line - it's a simple
string - and should not be interfering with it: a backslash+space (after any
shell escaping) should get handled consistently, passed through to the target
and should work.

Alasdair
-- 
agk@redhat.com
