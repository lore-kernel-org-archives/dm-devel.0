From: "Mears, Morgan" <Morgan.Mears@netapp.com>
Subject: dm-cache: can the same cache be used with multiple
	origin devices?
Date: Mon, 15 Jul 2013 19:01:54 +0000
Message-ID: <33A0129EBFD46748804DE81B354CA1B2165B1533@SACEXCMBX06-PRD.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi,

In reference to dm-cache: can the same cache and metadata devices be used with multiple origin devices?  This can be configured, and we've done some tests that appear to show that it works - we're looking for confirmation (or otherwise).

Here's an example test setup to clarify -- ssd_metadata and ssd_blocks are being used to cache sdc and sdd.  In testing, different patterns were written to areas of sdc_cached and  sdd_cached; afterwards, the contents of sdc and sdd were as expected.

dmsetup create sdc_cached --table '0 4194304 cache /dev/mapper/ssd_metadata /dev/mapper/ssd_blocks /dev/sdc 512 1 writethrough default 0'
dmsetup create sdd_cached --table '0 4194304 cache /dev/mapper/ssd_metadata /dev/mapper/ssd_blocks /dev/sdd 512 1 writethrough default 0'

Our thinking is that using one large cache for multiple origin devices will result in a more efficient use of flash resources than statically partitioning the flash amongst the origins.  Also, there's no need to repartition or buy another SSD to start caching a newly-added origin.

Thanks,
Morgan Mears
