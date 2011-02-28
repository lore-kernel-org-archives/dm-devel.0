From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: mirrored device with thousand of mappingtableentries
Date: Mon, 28 Feb 2011 10:01:56 -0500
Message-ID: <yq1oc5wp5i3.fsf@sermon.lab.mkp.net>
References: <E04C10E329E0CD40816C9C17AE53BBD3018639C2@kit001.kaminario.local>
	<20110228114801.GZ3626@agk-dp.fab.redhat.com>
	<E04C10E329E0CD40816C9C17AE53BBD3018639CE@kit001.kaminario.local>
	<20110228121149.GA3626@agk-dp.fab.redhat.com>
	<E04C10E329E0CD40816C9C17AE53BBD3018639D7@kit001.kaminario.local>
	<20110228131028.GB3626@agk-dp.fab.redhat.com>
	<E04C10E329E0CD40816C9C17AE53BBD301863A00@kit001.kaminario.local>
	<4D6BA566.1050305@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4D6BA566.1050305@redhat.com> (Zdenek Kabelac's message of "Mon,
	28 Feb 2011 14:38:46 +0100")
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

>>>>> "Zdenek" == Zdenek Kabelac <zkabelac@redhat.com> writes:

Zdenek> If you really need that many devices - be also sure you have
Zdenek> disabled this kernel config option:

Zdenek> CONFIG_BLK_DEV_INTEGRITY

Zdenek> For some reason it consumes massive amount of memory.  Other
Zdenek> than that - you should count with 64KB per device usually.

Care to qualify that?

Unless your HBA indicates that it supports data integrity the only
penalty should be that each bio grows a pointer.

-- 
Martin K. Petersen	Oracle Linux Engineering
