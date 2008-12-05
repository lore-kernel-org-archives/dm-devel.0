From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: dm targets with spaces in the name
Date: Fri, 5 Dec 2008 11:58:30 -0500
Message-ID: <49395DB6.6050802@cfl.rr.com>
References: <4936BBC6.7000800@cfl.rr.com>
	<1228405956.23557.74.camel@o>	<49383A77.80903@cfl.rr.com>
	<20081205015938.GQ26097@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20081205015938.GQ26097@agk.fab.redhat.com>
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

Alasdair G Kergon wrote:
> I can't guarantee that names with spaces in them have had much testing
> as LVM doesn't permit them.  But device-mapper itself and dmsetup
> are supposed to support them.
<snip>
> Tools really should not be passing path names into constructors - use the
> major:minor format instead as the in-kernel code paths are much more
> predictable, there are fewer opportunities for races and so it offers
> better control to the userspace code.

But if you run dmsetup and key in a table referencing a device with a 
space in the name, that is what happens; linear_ctr gets passed 
"/dev/foo bar" as the path argv.  Shouldn't it then be just as capable 
of opening the device as a call to open()?
