From: jiangyiwen <jiangyiwen@huawei.com>
Subject: Why don't return -EOPNOTSUPP?
Date: Tue, 2 Feb 2016 19:57:37 +0800
Message-ID: <56B099B1.2060304@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
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
To: lczerner@redhat.com
Cc: dm-devel@redhat.com, "Qijiang (Joseph, Euler)" <joseph.qi@huawei.com>, xuejiufei@huawei.com
List-Id: dm-devel.ids

Hi Lukas,
I have a question about commit 8af1954d172a("blkdev: Do not return
-EOPNOTSUPP if discard is supported"). That is we issue a
WRITE SAME request to device and return failed with EOPNOTSUPP,
but blkdev_issue_write_same ignore this error and return
success to caller. In this way, this will cause an inconsistent state
between upper layer and bottom layer.

I don't know why don't return EOPNOTSUPP if part of devices support
discard, because I think that blkdev_issue_discard should return
EOPNOTSUPP to caller even if some of devices support discard.

Thanks,
Yiwen Jiang.
