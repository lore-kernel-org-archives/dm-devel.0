From: "Eli Malul" <eli.malul@kaminario.com>
Subject: Re: mirrored device with thousand of mappingtableentries
Date: Mon, 28 Feb 2011 15:13:42 +0200
Message-ID: <E04C10E329E0CD40816C9C17AE53BBD301863A00@kit001.kaminario.local>
References: <E04C10E329E0CD40816C9C17AE53BBD3018639C2@kit001.kaminario.local>
	<20110228114801.GZ3626@agk-dp.fab.redhat.com>
	<E04C10E329E0CD40816C9C17AE53BBD3018639CE@kit001.kaminario.local>
	<20110228121149.GA3626@agk-dp.fab.redhat.com>
	<E04C10E329E0CD40816C9C17AE53BBD3018639D7@kit001.kaminario.local>
	<20110228131028.GB3626@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20110228131028.GB3626@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


OK, I will try that and check the implications of that, thanks!!

But, do you know why having 10,000 extents is causing this overwhelming
memory usage?

-----Original Message-----
From: Alasdair G Kergon [mailto:agk@redhat.com] 
Sent: Monday, February 28, 2011 3:10 PM
To: Eli Malul
Cc: device-mapper development
Subject: Re: [dm-devel] mirrored device with thousand of
mappingtableentries

On Mon, Feb 28, 2011 at 02:17:52PM +0200, Eli Malul wrote:
> I expect to have thousands of non contiguous extents (so I created a
> synthetic mapping table to test the device-mapper behavior).
> 
> Any suggestions?
 
> -----Original Message-----
> From: Alasdair G Kergon [mailto:agk@redhat.com] 
> Sent: Monday, February 28, 2011 2:12 PM
> To: Eli Malul
> Cc: device-mapper development

> (And if, unlike that example, your extents are not
> contiguous,
> create two new devices that join them together, and mirror those.
> That's
> what LVM does.)

That.
dm0 = list 0
dm1 = list 1
dm2 = mirror of dm0 and dm1

Alasdair
