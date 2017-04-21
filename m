From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] multipath-tools: Add Huawei prioritizer for
	nvme
Date: Fri, 21 Apr 2017 03:39:20 -0700
Message-ID: <20170421103920.GA14037@infradead.org>
References: <1492770478-14848-1-git-send-email-zouming.zouming@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1492770478-14848-1-git-send-email-zouming.zouming@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zou Ming <zouming.zouming@huawei.com>
Cc: guanjunxiong@huawei.com, philip.yang@huawei.com, linux-nvme@lists.infradead.org, dm-devel@redhat.com, hege09@huawei.com, shenhong09@huawei.com
List-Id: dm-devel.ids

On Fri, Apr 21, 2017 at 10:27:58AM +0000, Zou Ming wrote:
> Tool to make use of a NVMe-feature called HUAWEI Asymmetric Namespace Access.
> It determines the ANA state of a device and prints a priority value to stdout.

NAK.  Please work with the NVMe comittee to get your inputs into the
ANA technical proposal.  We will not support proprietary Multipating
for NVMe under Linux.
