From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/4] fix snapshot flaws with 4k sectors
Date: Mon, 15 Mar 2010 10:08:03 -0400
Message-ID: <20100315140803.GA6853@redhat.com>
References: <Pine.LNX.4.64.1003150145220.12526@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1003150145220.12526@hs20-bc2-1.build.redhat.com>
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

On Mon, Mar 15 2010 at  1:59am -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> BTW. if anyone wants to test his code with non-512-byte sector devices, 
> you can use old Seagate U160 SCSI disks (Cheetah XL and before), they can 
> be reformatted to 512-4096 byte sectors with sg_format command. They are 
> no longer being manufactured, you can find them at internet auctions. The 
> current U320 SCSI disks (Cheetah 10K.X or 15K.X) don't support large 
> sectors, they only support 512-528 byte sector-size.

The scsi_debug modules can also be used to create 4K devices.

This is a software-only test-bed but it is bound by the amount of
available ram.

Mike
