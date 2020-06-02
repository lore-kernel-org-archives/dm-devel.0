From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 0/3] optimize buffer cleanup in the ebs target
Date: Tue, 02 Jun 2020 15:34:38 +0200
Message-ID: <20200602133438.763665880@debian-a64.vm>
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
To: Mike Snitzer <msnitzer@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

These patches add a new function dm_bufio_forger_buffers and use it in the
dm-ebs target. It is more efficient than calling dm_bufio_forget in a
loop. The loop could cause excessive CPU consumption when discarding a
larget range.

Mikulas
