From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH RFT/RFC 0/4] add hp sw hw_handler
Date: Fri, 30 Sep 2005 14:42:09 -0500
Message-ID: <1128109329.24395.21.camel@max>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

The following patches move some common hw_handler code to
dm-hw-handler.c, converts dm-emc and adds dm-hp-sw. I have
none of this HW so it is all untested. Christophe?

These patches were made against the current Linus git tree,
but patch against 2.6.14.
