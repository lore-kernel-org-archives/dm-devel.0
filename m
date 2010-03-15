From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 4/4] Test chunk size against both origin and
	snapshot sector size
Date: Mon, 15 Mar 2010 12:53:43 -0400
Message-ID: <yq13a01frvs.fsf@sermon.lab.mkp.net>
References: <Pine.LNX.4.64.1003150201270.12526@hs20-bc2-1.build.redhat.com>
	<20100315145224.GE6853@redhat.com>
	<Pine.LNX.4.64.1003151106290.20210@hs20-bc2-1.build.redhat.com>
	<20100315153031.GA14350@redhat.com>
	<Pine.LNX.4.64.1003151151370.2471@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1003151151370.2471@hs20-bc2-1.build.redhat.com>
	(Mikulas Patocka's message of "Mon, 15 Mar 2010 11:52:56 -0400 (EDT)")
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
Cc: Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids


>>>>> "Mikulas" == Mikulas Patocka <mpatocka@redhat.com> writes:
>> Do you mean something like 512b logical and 4K physical?  Such
>> devices must perform the appropriate r-m-w.  A 4K formatted device
>> will report 4K for both logical and physical (unless the device and
>> format tool allows for physical != logical).
>> 
>> Mike

Mikulas> No, I meant what happens if you format it with 514, 516, etc
Mikulas> physical blocksize. the Linux clearly doesn't support it, so
Mikulas> what will it do with it? I'll try when I finish tests on 4K.

We only support powers of two (except when the drive is formatted with
DIF but even in that case the logical_block_size is a power of two).

-- 
Martin K. Petersen	Oracle Linux Engineering
