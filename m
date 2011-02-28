From: "Eli Malul" <eli.malul@kaminario.com>
Subject: Re: mirrored device with thousand of mappingtableentries
Date: Mon, 28 Feb 2011 18:25:09 +0200
Message-ID: <E04C10E329E0CD40816C9C17AE53BBD301863A79@kit001.kaminario.local>
References: <E04C10E329E0CD40816C9C17AE53BBD3018639C2@kit001.kaminario.local>
	<20110228114801.GZ3626@agk-dp.fab.redhat.com>
	<E04C10E329E0CD40816C9C17AE53BBD3018639CE@kit001.kaminario.local>
	<20110228121149.GA3626@agk-dp.fab.redhat.com>
	<E04C10E329E0CD40816C9C17AE53BBD3018639D7@kit001.kaminario.local>
	<20110228131028.GB3626@agk-dp.fab.redhat.com>
	<E04C10E329E0CD40816C9C17AE53BBD301863A00@kit001.kaminario.local>
	<20110228132920.GC3626@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
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

One way to achieve that is to create two linear mapped devices amd
mirror them and another two linear device to simulate the original
offsets. The last shall be mapped to the first two linear devices so the
client will continue to read and write the same offsets he was used to.

Seems a little bit complex configuration but it shall do the trick.
I will test its scalability and update of course.

BTW - 
CONFIG_BLK_DEV_INTEGRITY is disabled.
 
-----Original Message-----
From: Eli Malul 
Sent: Monday, February 28, 2011 3:43 PM
To: 'Alasdair G Kergon'
Cc: device-mapper development
Subject: RE: [dm-devel] mirrored device with thousand of
mappingtableentries

According to your suggestion I need to map the non contiguous extents
into linear devices and mirror them.

But, what if I am required to preserve the original extent's offset?
Since I need to mirror an existing device with user data already on
it...

-----Original Message-----
From: Alasdair G Kergon [mailto:agk@redhat.com] 
Sent: Monday, February 28, 2011 3:29 PM
To: Eli Malul
Cc: device-mapper development
Subject: Re: [dm-devel] mirrored device with thousand of
mappingtableentries

On Mon, Feb 28, 2011 at 03:13:42PM +0200, Eli Malul wrote:
> But, do you know why having 10,000 extents is causing this
overwhelming
> memory usage?
 
Nobody considered having a huge number of tiny mirrors reasonable or
necessary
so no attempt has been made to optimise that situation.

Alasdair
