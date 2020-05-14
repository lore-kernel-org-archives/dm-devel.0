From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCHv5 00/14] dm-zoned: metadata version 2
Date: Wed, 13 May 2020 20:20:28 -0400
Message-ID: <yq13683z7sj.fsf@oracle.com>
References: <20200508090332.40716-1-hare@suse.de>
	<BY5PR04MB6900138C0F78196D0F81BF07E7A10@BY5PR04MB6900.namprd04.prod.outlook.com>
	<BY5PR04MB6900C76141ABD428F42C1840E7A10@BY5PR04MB6900.namprd04.prod.outlook.com>
	<2553e593-795d-6aed-f983-e990a283e2ff@suse.de>
	<BY5PR04MB6900C84D00585D3560D4C51AE7A10@BY5PR04MB6900.namprd04.prod.outlook.com>
	<BY5PR04MB690020AE68E7A20EA8BFED0DE7A10@BY5PR04MB6900.namprd04.prod.outlook.com>
	<BY5PR04MB690002ABF208B084607B6971E7BF0@BY5PR04MB6900.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <BY5PR04MB690002ABF208B084607B6971E7BF0@BY5PR04MB6900.namprd04.prod.outlook.com>
	(Damien Le Moal's message of "Wed, 13 May 2020 23:56:23 +0000")
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: Bob Liu <bob.liu@oracle.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids


Damien,

> Any idea why the io_opt limit is not set to the physical block size
> when the drive does not report an optimal transfer length ? Would it
> be bad to set that value instead of leaving it to 0 ?

The original intent was that io_opt was a weak heuristic for something
being a RAID device. Regular disk drives didn't report it. These days
that distinction probably isn't relevant.

However, before we entertain departing from the historic io_opt
behavior, I am a bit puzzled by the fact that you have a device that
reports io_opt as 512 bytes. What kind of device performs best when each
I/O is limited to a single logical block?

-- 
Martin K. Petersen	Oracle Linux Engineering
