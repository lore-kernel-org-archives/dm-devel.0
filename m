From: Brian Hawley <bhawley@luminex.com>
Subject: nvdimm use by kernel modules
Date: Wed, 13 Sep 2017 15:50:17 -0700
Message-ID: <59B9B629.7000802@luminex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids


On this thread:

https://www.spinics.net/lists/dm-devel/msg31991.html


I saw a strawman proposal for using nvdimm in other kernel modules: i.e. 
using ->direct_access()

I am wondering if anyone else is utilizing nvram from kernel modules, 
and if so, what advice you might have, including what kernel version 
should be used.

Thanks,

-- Brian
