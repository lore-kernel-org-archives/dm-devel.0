From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: [PATCH 0/2] dm-ioband: I/O bandwidth controller v1.10.0:
 Introduction
Date: Tue, 20 Jan 2009 14:10:22 +0900 (JST)
Message-ID: <20090120.141022.193708059.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Alasdair and everyone,

This is the dm-ioband version 1.10.0 release. The patch is created
against the dm quilt tree so that it gets into Patchwork.

Dm-ioband is an I/O bandwidth controller implemented as a device-mapper
driver, which gives specified bandwidth to each job running on the same
physical device.

A lot more information (manual, benchmark results, all-in-one patch
and so on) is available at http://people.valinux.co.jp/~ryov/dm-ioband/ .
I welcome any feed-backs and suggestions. 

Thanks,
Ryo Tsuruta
