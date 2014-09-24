From: Joe Thornber <thornber@redhat.com>
Subject: Re:
 =?utf-8?q?reply=EF=BC=9A__Thinly-Provisioned_Logical_V?=
 =?utf-8?q?olumes?=
Date: Wed, 24 Sep 2014 09:37:47 +0100
Message-ID: <20140924083747.GA8959@debian>
References: <b3abf2cc-2219-4b5a-b546-5f71301c40e4@aliyun.com>
	<7adc0384-473b-41da-8ae0-08ee4b436388@aliyun.com>
	<ae586129-fc3a-41fe-8f2e-f3124c5ff58d@aliyun.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <ae586129-fc3a-41fe-8f2e-f3124c5ff58d@aliyun.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: lilofile <lilofile@aliyun.com>, device-mapper development <dm-devel@redhat.com>
Cc: Ondrej Kozina <okozina@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, Sep 24, 2014 at 10:11:00AM +0800, lilofile wrote:
> When I test thinly-provisioned logical volumes,I use dd if=/dev/zero of=/dev/mapper/mythinvolume count=1 bs=4k
> I only write 4k data in mythinvolume.but In thin_map functions, I found there are really  4K data written,but I found more read IO,probably dozens of read io. who issue these IO? 

Assuming the IO is going to the data device, and not the metadata
device, then the likely candidates would be read-ahead or udev.

- Joe
